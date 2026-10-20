"""Render a whole sweep as a job: many files, unattended, resumable. Tutorial part 2, the "slew of files" at scale.

    latentft-sweep --out my_sweep        # no file: Bob Dylan's The Man in Me from 2:00, fetched from the class site
    latentft-sweep ~/Music/my_song.wav --start 120 --seconds 30 --out my_sweep \\
        --centres 0.4 16 24 --octaves 2 --kind band --model stereo --stereo-mode mid

    (installed by the latentft-lab package; run the same command again to resume an interrupted sweep)

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


SITE = "https://latentft.csail.mit.edu"


def class_tracks(hub: str | None = None) -> list[dict]:
    import urllib.request
    base = (hub if hub and hub.startswith("https://") else SITE).rstrip("/")
    with urllib.request.urlopen(f"{base}/loops/tracks.json", timeout=60) as r:
        items = json.loads(r.read())
    items = items.get("tracks", []) if isinstance(items, dict) else items   # {sr, note, tracks: [...]}
    return [t for t in items if t.get("loop_seconds") is None] or items      # whole pieces (loops are excluded)


def fetch_track(track_id: str, hub: str | None = None) -> str:
    """Download a class track once into ~/.cache/latentft/tracks and return its path."""
    import urllib.request
    base = (hub if hub and hub.startswith("https://") else SITE).rstrip("/")
    with urllib.request.urlopen(f"{base}/loops/tracks.json", timeout=60) as r:
        items = json.loads(r.read())
    items = items.get("tracks", []) if isinstance(items, dict) else items   # {sr, note, tracks: [...]}
    t = next((x for x in items if x.get("id") == track_id), None)
    if t is None:
        sys.exit(f"no class track {track_id!r}; latentft-sweep --list-tracks shows them")
    cache = Path.home() / ".cache" / "latentft" / "tracks"; cache.mkdir(parents=True, exist_ok=True)
    dst = cache / Path(t["file"]).name
    if not dst.is_file():
        print(f"downloading {t['title']} ({t['credit']}) ...", flush=True)
        urllib.request.urlretrieve(f"{base}/loops/{t['file']}", dst)
    return str(dst)


def main():
    ap = argparse.ArgumentParser(description=__doc__.split("\n")[0], formatter_class=argparse.RawDescriptionHelpFormatter, epilog=__doc__)
    ap.add_argument("audio", nargs="?", default=None,
                    help="your audio file (WAV/FLAC/AIFF/OGG/MP3). Leave it out to use a class track (--track)")
    ap.add_argument("--track", default="dylan-man-in-me",
                    help="a class track from the site, used when no audio file is given (default: dylan-man-in-me, "
                         "Bob Dylan's The Man in Me; --list-tracks shows them all)")
    ap.add_argument("--list-tracks", action="store_true", help="list the class tracks and exit")
    ap.add_argument("--start", type=float, default=None, help="where the selection starts, s (default 0; 120 for the default track)")
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
    ap.add_argument("--token", default=None, help="your API token (otherwise $LATENTFT_TOKEN, or the file ~/.config/flowedit/token)")
    ap.add_argument("--save-token", action="store_true", help="also write --token to ~/.config/flowedit/token, so later runs need no --token")
    ap.add_argument("--hub", default=None, help="another service, e.g. http://127.0.0.1:8765 for your own latentft_server.py")
    args = ap.parse_args()

    if args.list_tracks:
        for t in class_tracks(args.hub):
            print(f"{t['id']:<32} {t['seconds']:6.0f} s  {t.get('group', ''):<14} {t['title']} — {t['credit']}")
        return
    if args.audio is None:
        args.audio = fetch_track(args.track, args.hub)
        if args.start is None:
            args.start = 120.0 if args.track == "dylan-man-in-me" else 0.0
        print(f"no audio file given: using the class track {args.track} ({args.audio}), from {args.start:g} s", flush=True)
    if args.start is None:
        args.start = 0.0
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
    if args.token and args.save_token:
        f = Path.home() / ".config" / "flowedit" / "token"; f.parent.mkdir(parents=True, exist_ok=True)
        f.write_text(args.token.strip() + "\n"); f.chmod(0o600); print(f"token saved to {f}", flush=True)
    try:
        lf = LatentFT(token=args.token, client="render_sweep", **({"hub": args.hub} if args.hub else {}))
    except RuntimeError as e:
        sys.exit(f"{e}\nYour token is in your sign-in link (https://latentft.csail.mit.edu/#token=...) or from your instructor. "
                 "Run once with --token YOUR_TOKEN --save-token and it is remembered.")
    manifest_path = out / "manifest.json"
    planned = {f"{args.kind}_s{sd}_w{w:g}oct_{i:03d}_{fc:.2f}Hz.wav" for sd in args.seeds for w in widths for i, fc in enumerate(centres)}
    others = sorted(f.name for f in out.glob("*.wav") if f.name not in planned)
    if others:
        sys.exit(f"{out} already holds {len(others)} renders from a different sweep (e.g. {others[0]}).\n"
                 f"One folder = one sweep, so the Max crossfader loads only these files: use a new --out, or delete the folder.")
    manifest = json.loads(manifest_path.read_text()) if manifest_path.is_file() else {
        "audio": str(args.audio), "start_s": args.start, "seconds": args.seconds, "model": args.model, "stereo_mode": args.stereo_mode,
        "kind": args.kind, "steps": args.steps, "sr": SR, "renders": []}
    manifest["renders"] = [r for r in manifest["renders"] if r["file"] in planned and (out / r["file"]).is_file()]
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
