"""Render a whole sweep as a job: many files, unattended, resumable. Tutorial part 2, the "slew of files" at scale.

    latentft-sweep ~/Music/my_song.wav --start 120 --seconds 30 --out my_sweep \\
        --centres 0.4 16 24 --octaves 2 --kind band --model stereo --stereo-mode mid

    nohup latentft-sweep ... > sweep.log 2>&1 &          # leave it running; re-run the same command to resume
    (latentft-sweep is installed by the latentft-lab package; `python latentft_sweep.py` is the same thing)

What it does: one render per zone centre (log-spaced from lo to hi, K of them), every render from one seed so the
files line up, written as WAV into --out with a manifest.json (index, file, centre, octaves, what was kept in bins and
Hz). Calls go to the service 48 renders at a time; a file that already exists is skipped, so an interrupted job
continues where it stopped, and the service answers an identical request from its cache, so repeats cost no GPU.
With --glides it also writes up / down / up-and-down pieces that crossfade through the files (latentft_viz.xfade_sweep)
into glides/. The renders themselves are the only WAVs at the top level, so a folder loader (the Max crossfader's
polybuffer~) sees just them; the original and the vocoder reference go in ref/.

Other sweeps: --kind notch (erase the zone instead of keeping it); --widths 1 2 3 (a second axis: every centre at
every width); --seeds 0 1 2 (the same masks with different sampler noise). Needs the latentft-lab package
(pip install "latentft-lab[viz]" --extra-index-url https://latentft.csail.mit.edu/pip/simple) and a token in
~/.config/flowedit/token or $LATENTFT_TOKEN.
"""
from __future__ import annotations

import argparse
import json
import sys
import time
from pathlib import Path

import numpy as np
import soundfile as sf

sys.path.insert(0, str(Path(__file__).resolve().parent))
from latentft_client import SR, LatentFT, keep  # noqa: E402
from latentft_viz import soft_octave, xfade_sweep  # noqa: E402


def main():
    ap = argparse.ArgumentParser(description=__doc__.split("\n")[0], formatter_class=argparse.RawDescriptionHelpFormatter, epilog=__doc__)
    ap.add_argument("audio")
    ap.add_argument("--start", type=float, default=0.0, help="where the selection starts in the file, s")
    ap.add_argument("--seconds", type=float, default=30.0, help="selection length, 5.944..30")
    ap.add_argument("--out", required=True)
    ap.add_argument("--centres", nargs=3, type=float, default=[0.4, 16.0, 16], metavar=("LO_HZ", "HI_HZ", "K"))
    ap.add_argument("--widths", nargs="+", type=float, default=None, help="zone widths in octaves (default: --octaves only)")
    ap.add_argument("--octaves", type=float, default=2.0)
    ap.add_argument("--kind", choices=["band", "notch"], default="band", help="keep the zone, or erase it")
    ap.add_argument("--model", default="stereo")
    ap.add_argument("--stereo-mode", choices=["lr", "mid"], default="mid")
    ap.add_argument("--seeds", nargs="+", type=int, default=[0])
    ap.add_argument("--steps", type=int, default=35)
    ap.add_argument("--glides", action="store_true", help="also write up/down/updown pieces through the files of each (width, seed)")
    ap.add_argument("--hub", default=None, help="another service, e.g. http://127.0.0.1:8765 for your own latentft_server.py")
    args = ap.parse_args()

    out = Path(args.out).expanduser(); out.mkdir(parents=True, exist_ok=True)
    if not Path(args.audio).expanduser().is_file():
        sys.exit(f"no such audio file: {args.audio}  (give the path to a WAV/FLAC/AIFF you have, e.g. ~/Music/song.wav)")
    try:
        y, sr = sf.read(str(Path(args.audio).expanduser()), dtype="float32", always_2d=True)
    except Exception as e:  # noqa: BLE001
        sys.exit(f"could not read {args.audio} as audio ({e}); use WAV, FLAC, AIFF or OGG (convert MP3s first)")
    seg = y[int(args.start * sr): int((args.start + args.seconds) * sr)]
    lo, hi, K = args.centres; K = int(K)
    centres = np.geomspace(lo, hi, K)
    widths = args.widths or [args.octaves]
    lf = LatentFT(client="render_sweep", **({"hub": args.hub} if args.hub else {}))
    manifest_path = out / "manifest.json"
    manifest = json.loads(manifest_path.read_text()) if manifest_path.is_file() else {
        "audio": str(args.audio), "start_s": args.start, "seconds": args.seconds, "model": args.model, "stereo_mode": args.stereo_mode,
        "kind": args.kind, "steps": args.steps, "sr": SR, "renders": []}
    done = {r["file"] for r in manifest["renders"]}
    t0 = time.time()
    for seed in args.seeds:
        for w in widths:
            plan = []                                       # (file name, centre, spec) for this (seed, width)
            for i, fc in enumerate(centres):
                name = f"{args.kind}_s{seed}_w{w:g}oct_{i:03d}_{fc:.2f}Hz.wav"
                m = soft_octave(fc, w)
                plan.append((name, fc, keep(mask=(m if args.kind == "band" else 1 - m))))
            todo = [p for p in plan if p[0] not in done]
            print(f"seed {seed}, width {w:g} oct: {len(plan)} files, {len(todo)} to render", flush=True)
            for c0 in range(0, len(todo), 48):              # the service takes at most 48 renders per call
                chunk = todo[c0: c0 + 48]
                res = lf.render(seg, sr, [{"a": p[2]} for p in chunk], model=args.model, seconds=args.seconds, seed=seed, steps=args.steps,
                                stereo_mode=args.stereo_mode, include_ref=(c0 == 0 and not done))
                for j, (name, fc, _) in enumerate(chunk):
                    sf.write(out / name, res.audio(j), SR)
                    k = res.keep(j)
                    manifest["renders"].append({"file": name, "seed": seed, "octaves": w, "centre_hz": round(float(fc), 4), "kind": args.kind,
                                                "index": int(name.split("_")[3]), "keep_hz": k["hz"] if k["hz"] is not None else k["support_hz"],
                                                "full_gain_hz": k["full_hz"], "bins_kept": k["bins_kept"]})
                    done.add(name)
                if c0 == 0 and res.clip_a.get("ref_wav_b64") and not (out / "ref" / "what_the_model_hears.wav").is_file():
                    (out / "ref").mkdir(exist_ok=True); sf.write(out / "ref" / "what_the_model_hears.wav", res.ref("a"), SR)
                manifest_path.write_text(json.dumps(manifest, indent=1))   # after every chunk: a crash loses nothing
                print(f"  {min(c0 + 48, len(todo))}/{len(todo)} rendered ({res.render_s} s on the GPU, {time.time() - t0:.0f} s wall)", flush=True)
            if args.glides:
                files = [out / p[0] for p in plan]
                parts = [sf.read(f, dtype="float32", always_2d=True)[0] for f in files]
                (out / "glides").mkdir(exist_ok=True)
                for pname, passes in (("up", [True]), ("down", [False]), ("updown", [True, False])):
                    piece = xfade_sweep(parts, passes)
                    sf.write(out / "glides" / f"glide_{pname}_s{seed}_w{w:g}oct.wav", piece, SR)
                print(f"  glides written for seed {seed}, width {w:g}", flush=True)
    (out / "ref").mkdir(exist_ok=True)
    sf.write(out / "ref" / "original.wav", seg if sr == SR else __import__("librosa").resample(seg.T, orig_sr=sr, target_sr=SR).T, SR)
    print(f"done: {len(manifest['renders'])} files in {out} ({time.time() - t0:.0f} s)")


if __name__ == "__main__":
    main()
