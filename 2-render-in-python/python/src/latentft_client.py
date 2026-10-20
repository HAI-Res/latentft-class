"""Client for LatentFT as a service: the class hub (https://latentft.csail.mit.edu, POST /latentft) or your own
latentft_server.py. Standard library + numpy + soundfile, so it runs on Colab or a laptop with no GPU: the renders
happen wherever the models are.

    from latentft_client import LatentFT, keep, ALL
    lf = LatentFT(token="...")                          # or $LATENTFT_TOKEN / ~/.config/flowedit/token
    lf.models()                                         # which models are online, their rate axes
    a, sr = lf.loop("425998")                           # a loop from the class library, or soundfile.read(...)
    res = lf.render(a, sr, [{"a": ALL[:4]}, {"a": keep(hz=[[1.3, 2.7]])}], model="mono")
    res.audio(0)                                        # (T, ch) float32 at 22.05 kHz
    res.renders[0]["keep"]["a"]["ranges"]               # the bins each render kept, as the service resolved them

A render names what to KEEP of clip A and/or clip B; the decoder regenerates the rest. Keep-specs:
    [1, 2, 5]  or  keep(bands=[1, 2, 5])        the paper's 8 log bands (1 = slowest .. 8 = attacks)
    keep(bins=[0, [16, 31], 200])               rate bins (0..512 for the 5.94-s models; inclusive [lo, hi] ranges)
    keep(hz=[[0.3, 1.2], [4, 8]])               Hz ranges on the rate axis
    keep(mask=gains)                            a gain per bin, 0..1 (soft masks are an experiment: trained on 0/1)
    keep(..., dc=False)                         drop bin 0 (the mean) too; by default a lone condition keeps it
Two specs in one render = the paper's blend; add "weights": [wa, wb] to favour one clip. Every render in one call
starts from the same noise (seed), so they line up. For raw access: lf.encode(...) gives the latent (C x T) and
lf.decode(...) renders latents you changed yourself.

Your own GPU instead of the hub: LatentFT(hub="http://127.0.0.1:8765", token=...) against demo/latentft_server.py,
or LatentFT.in_process({"mono": "/path/to/weights.pt"}) inside a Jupyter kernel that has the model repo and a GPU.
"""
from __future__ import annotations

import base64
import io
import json
import os
import ssl
import time
import urllib.error
import urllib.request
from pathlib import Path

import numpy as np
import soundfile as sf

HUB = os.environ.get("LATENTFT_HUB", "https://latentft.csail.mit.edu")   # same hub as audioflow.csail.mit.edu
SR = 22050
WINDOW_S = 512 * 256 / SR          # 5.944 s: one model window (5.94-s models)
ALL = [1, 2, 3, 4, 5, 6, 7, 8]
BAND_EDGES = [0, 4, 8, 16, 32, 64, 128, 256, 513]
BIN_HZ = (SR / 256) / 1024          # 0.0841 Hz between rate bins (5.94-s models)


def keep(bands=None, bins=None, hz=None, mask=None, dc=None) -> dict:
    """Build a keep-spec. Exactly one of bands / bins / hz / mask."""
    given = {k: v for k, v in (("bands", bands), ("bins", bins), ("hz", hz), ("mask", mask)) if v is not None}
    if len(given) != 1:
        raise ValueError("keep() wants exactly one of bands, bins, hz, mask")
    k, v = next(iter(given.items()))
    if k == "mask":
        v = np.asarray(v, dtype=float).round(4).tolist()
    elif k == "hz":
        v = [[float(a), float(b)] for a, b in (v if isinstance(v[0], (list, tuple)) else [v])]
    elif k == "bins":
        v = [[int(x[0]), int(x[1])] if isinstance(x, (list, tuple)) else int(x) for x in v]
    else:
        v = [int(b) for b in v]
    spec = {k: v}
    if dc is not None:
        spec["dc"] = bool(dc)
    return spec


def lowpass(hz_cut: float) -> dict:
    """Keep rates up to hz_cut (plus bin 0)."""
    return keep(hz=[[0.0, float(hz_cut)]])


def highpass(hz_cut: float) -> dict:
    """Keep rates from hz_cut up (bin 0 is kept by the service for a lone condition unless dc=False)."""
    return keep(hz=[[float(hz_cut), 43.07]])


def soft_lowpass(hz_cut: float, width_hz: float = 0.5, n_bins: int = 513, bin_hz: float = BIN_HZ) -> dict:
    """A raised-cosine roll-off instead of a brick wall: gain 1 below hz_cut - width/2, 0 above hz_cut + width/2."""
    f = np.arange(n_bins) * bin_hz
    lo, hi = hz_cut - width_hz / 2, hz_cut + width_hz / 2
    g = np.clip((hi - f) / max(hi - lo, 1e-9), 0, 1)
    g = 0.5 - 0.5 * np.cos(np.pi * g)
    return keep(mask=g)


def _token(explicit, required=True):
    if explicit:
        return explicit
    if os.environ.get("LATENTFT_TOKEN"):
        return os.environ["LATENTFT_TOKEN"]
    f = Path("~/.config/flowedit/token").expanduser()
    if f.is_file():
        return f.read_text().strip()
    if required:
        raise RuntimeError("no token: pass token=..., set LATENTFT_TOKEN, or write ~/.config/flowedit/token")
    return None


def _wav_b64(y: np.ndarray, sr: int, start_s: float = 0.0, seconds: float = WINDOW_S) -> str:
    """Send exactly the selection, at the model's rate: uploads stay small."""
    y = np.asarray(y, dtype=np.float32)
    y = y[:, None] if y.ndim == 1 else y
    s0 = int(round(start_s * sr))
    y = y[s0: s0 + int(round(seconds * sr))]
    if sr != SR:
        import librosa
        y = librosa.resample(y.T, orig_sr=sr, target_sr=SR).T
    buf = io.BytesIO()
    sf.write(buf, np.clip(y, -1, 1), SR, format="WAV", subtype="PCM_16")
    return base64.b64encode(buf.getvalue()).decode()


def _decode(b64: str) -> np.ndarray:
    y, _ = sf.read(io.BytesIO(base64.b64decode(b64)), dtype="float32", always_2d=True)
    return y


def latent_to_b64(z: np.ndarray) -> dict:
    z = np.ascontiguousarray(np.asarray(z, dtype="<f4"))
    return {"b64": base64.b64encode(z.tobytes()).decode(), "shape": list(z.shape), "dtype": "float32"}


def latent_from_b64(d: dict) -> np.ndarray:
    return np.frombuffer(base64.b64decode(d["b64"]), dtype="<f4").reshape(d["shape"]).copy()


class Result:
    """A render or decode response. .audio(i) decodes render i; .ref('a') is clip A through mel + vocoder only."""

    def __init__(self, d: dict):
        self.raw = d
        self.bands = d.get("bands")
        self.renders = d["renders"]
        self.clip_a = d.get("clip_a") or {}
        self.clip_b = d.get("clip_b") or {}
        self.render_s = d.get("render_s")
        self.sr = d["sr"]
        self.model = d.get("model")
        self.model_info = d.get("model_info") or {}
        self.rate_hz = d.get("rate_hz")           # centre Hz of the rate_db columns

    def audio(self, i: int) -> np.ndarray:
        return _decode(self.renders[i]["wav_b64"])

    def ref(self, which: str = "a") -> np.ndarray:
        c = self.clip_a if which == "a" else self.clip_b
        return _decode(c["ref_wav_b64"])

    def keep(self, i: int, which: str = "a") -> dict | None:
        """What render i kept of clip A or B, as the service resolved it: form, ranges (bins), hz, dc, soft."""
        return (self.renders[i].get("keep") or {}).get(which)

    def input_latent(self, which: str = "a") -> np.ndarray:
        """The clip's latent (C, T), first window; needs render(..., return_latents=True)."""
        c = self.clip_a if which == "a" else self.clip_b
        return latent_from_b64(c["latent"])

    def latent_cond(self, i: int) -> list[np.ndarray]:
        """Render i's conditioning latents (one per clip in the render, masked), what the decoder was given."""
        return [latent_from_b64(d) for d in self.renders[i]["latent_cond"]]

    def latent_out(self, i: int) -> np.ndarray:
        """Render i's output re-encoded: the latent of what came out."""
        return latent_from_b64(self.renders[i]["latent_out"])

    def mask(self, i: int, which: str = "a", n_bins: int = 513) -> np.ndarray | None:
        """The gain per rate bin render i applied to clip `which` (from the echoed spec, or the kept ranges)."""
        k = self.keep(i, which)
        if k is None:
            return None
        spec = self.renders[i].get(which)
        if isinstance(spec, dict) and "mask" in spec:
            m = np.asarray(spec["mask"], dtype=np.float32)
            m = m if m.ndim == 1 else m.max(0)
        else:
            m = np.zeros(n_bins, np.float32)
            for lo, hi in (k.get("support") or []):
                m[lo: hi + 1] = 1
        if k.get("dc") is not None:
            m[0] = 1.0 if k["dc"] else 0.0
        return m

    def label(self, i: int) -> str:
        r = self.renders[i]
        parts = []
        for t in ("a", "b"):
            k = (r.get("keep") or {}).get(t)
            if not k:
                continue
            if k.get("ranges") is not None:
                parts.append(f"{t.upper()} " + " ".join(f"{lo:g}-{hi:g}Hz" for lo, hi in k["hz"]))
            else:
                sup = " ".join(f"{lo:g}-{hi:g}Hz" for lo, hi in (k.get("support_hz") or []))
                full = " ".join(f"{lo:g}-{hi:g}Hz" for lo, hi in (k.get("full_hz") or []))
                parts.append(f"{t.upper()} soft {sup}" + (f" (full gain {full})" if full else "") if sup else f"{t.upper()} soft mask ({k['bins_kept']} bins)")
        w = r.get("weights")
        if w and len(w) == 2 and abs(w[0] - 0.5) > 1e-3:
            parts.append(f"weights {w[0]:.2f}/{w[1]:.2f}")
        return ", ".join(parts) or str(r.get("weights"))

    def save(self, folder: str, prefix: str = "render", manifest: bool = True) -> list[str]:
        """Write every render as 22.05-kHz WAV files (the vocoder references under ref/); returns the paths. With `manifest`, also
        writes manifest.json: one entry per file with its index, the request's a/b/weights and the resolved `keep`,
        so a patch (SuperCollider, Max, a sampler) can map files to what they are without the notebook."""
        import re
        out = Path(folder)
        out.mkdir(parents=True, exist_ok=True)
        paths, rows = [], []
        for i in range(len(self.renders)):
            name = re.sub(r"[^A-Za-z0-9._-]+", "_", self.label(i))[:80]
            p = out / f"{prefix}_{i:03d}_{name}.wav"
            sf.write(p, self.audio(i), self.sr)
            paths.append(str(p))
            r = self.renders[i]
            rows.append({"index": i, "file": p.name, "a": r.get("a"), "b": r.get("b"), "weights": r.get("weights"),
                         "zoom": r.get("zoom"), "keep": r.get("keep"), "label": self.label(i)})
        if manifest:
            (out / "manifest.json").write_text(json.dumps({"model": self.model, "seed": self.raw.get("seed"), "steps": self.raw.get("steps"),
                                                           "seconds": self.raw.get("seconds"), "sr": self.sr, "renders": rows}, indent=1))
        for t in ("a", "b"):                    # references go in ref/, so a folder loader (Max polybuffer~) sees renders only
            c = self.clip_a if t == "a" else self.clip_b
            if c.get("ref_wav_b64"):
                (out / "ref").mkdir(exist_ok=True)
                p = out / "ref" / f"what_the_model_hears_{t}.wav"
                sf.write(p, self.ref(t), self.sr)
                paths.append(str(p))
        return paths

    def __len__(self):
        return len(self.renders)

    def __repr__(self):
        return f"<LatentFT result: {len(self)} renders, {self.model}, {self.render_s} s on the GPU>"


class Encoded:
    """An encode response: .z is the latent (C, T) float32; .spectrum() its rfft along time (C, n_bins)."""

    def __init__(self, d: dict):
        self.raw = d
        self.z = latent_from_b64(d["latent"])
        self.model = d["model"]
        self.model_info = d["model_info"]
        self.n_fft = int(self.model_info["n_fft"])
        self.bin_hz = float(self.model_info["bin_hz"])
        self.rate_hz = d.get("rate_hz")
        self.band_energy_db = d.get("band_energy_db")

    def spectrum(self, z: np.ndarray | None = None) -> np.ndarray:
        return np.fft.rfft(self.z if z is None else z, n=self.n_fft, axis=-1)

    def from_spectrum(self, Z: np.ndarray) -> np.ndarray:
        """Back to a latent of the original length (what decode() wants)."""
        return np.fft.irfft(Z, n=self.n_fft, axis=-1)[..., : self.z.shape[-1]].astype(np.float32)

    def masked(self, gains: np.ndarray) -> np.ndarray:
        """Apply a gain per bin (or per channel and bin) exactly as the service does."""
        g = np.asarray(gains, dtype=np.float32)
        return self.from_spectrum(self.spectrum() * (g if g.ndim == 2 else g[None, :]))

    def ref(self) -> np.ndarray:
        return _decode(self.raw["ref_wav_b64"])

    @property
    def freqs(self) -> np.ndarray:
        return np.arange(self.n_fft // 2 + 1) * self.bin_hz

    def __repr__(self):
        return f"<LatentFT latent {self.z.shape} from {self.model}, {len(self.freqs)} rate bins x {self.bin_hz:.4f} Hz>"


# GPU seconds per (render x model window), learned from finished requests; these are the first guesses (one L40S /
# RTX 6000, 35 steps, batch 16, measured 2026-10-19). Plus a fixed overhead per request (upload, vocoder, download).
_RATE_GUESS = {"mono": 0.30, "stereo": 0.65, "unet": 0.80}
_OVERHEAD_S = 3.0


def _windows(seconds: float) -> int:
    """Model windows a selection is rendered as (5.944 s each, overlapping by at least 0.25 s)."""
    if seconds <= WINDOW_S + 1e-6:
        return 1
    return max(2, int(np.ceil((seconds - 0.25) / (WINDOW_S - 0.25))))


class _Progress:
    """One status line, rewritten once a second while a request is out: elapsed, estimated remaining, a bar.
    Plain text, no animation beyond the 1-second update; prints nothing for requests that finish within a second."""

    def __init__(self, label: str, est_s: float, enabled: bool):
        import threading
        self.label, self.est, self.enabled = label, max(est_s, 1.0), enabled
        self.t0 = time.time(); self._stop = threading.Event(); self._shown = False
        self._th = threading.Thread(target=self._run, daemon=True)
        if enabled:
            self._th.start()

    def _line(self, final: str | None = None) -> str:
        el = time.time() - self.t0
        if final:
            return f"\r{self.label}: {final} in {el:4.0f} s" + " " * 40
        frac = min(el / self.est, 0.99)
        bar = "#" * int(frac * 24) + "." * (24 - int(frac * 24))
        left = self.est - el
        rest = f"about {left:3.0f} s left" if left > 0 else "taking longer than estimated (queue, or a slow GPU)"
        return f"\r{self.label}: [{bar}] {el:4.0f} s, {rest}   "

    def _run(self):
        while not self._stop.wait(1.0):
            print(self._line(), end="", flush=True); self._shown = True

    def done(self, how: str = "done"):
        if not self.enabled:
            return
        self._stop.set(); self._th.join(timeout=2)
        if self._shown:
            print(self._line(how), flush=True)


class LatentFT:
    def __init__(self, token: str | None = None, hub: str = HUB, client: str = "notebook", require_token: bool | None = None,
                 progress: bool = True):
        """progress: print a status line (elapsed, estimated time left) while a request is out; False for silence."""
        self.progress = progress
        self._rate = dict(_RATE_GUESS)
        self.hub, self.client = hub.rstrip("/"), client
        local = self.hub.startswith("http://127.0.0.1") or self.hub.startswith("http://localhost")
        self.token = _token(token, required=(not local) if require_token is None else require_token)
        self._demo = None

    @classmethod
    def in_process(cls, models: dict, device: str | None = None) -> "LatentFT":
        """Run the models in this Python process (needs the latentft-post-training repo on sys.path, torch and a
        GPU). models: {"mono": "/path/weights.pt", "unet": {"path": ..., "fp32": True}}."""
        import torch
        from latentft_demo import Demo
        self = cls.__new__(cls)
        self.hub, self.client, self.token = "in-process", "notebook", None
        self.progress, self._rate = True, dict(_RATE_GUESS)
        self._demo = Demo(models, device=device or ("cuda" if torch.cuda.is_available() else "cpu"))
        return self

    # -- transport ---------------------------------------------------------------------------------
    def _get(self, path):
        with urllib.request.urlopen(f"{self.hub}{path}", timeout=60) as r:
            return r.read()

    def _estimate(self, body: dict) -> tuple[float, int]:
        """(estimated seconds, render-windows) for a request, from the learned GPU rate for its model."""
        n = len(body.get("renders") or []) or 1
        w = _windows(float(body.get("seconds") or WINDOW_S)) if body.get("op", "render") == "render" else 1
        units = n * w
        return _OVERHEAD_S + units * self._rate.get(body.get("model", "mono"), 0.6), units

    def _post(self, body: dict, label: str | None = None) -> dict:
        est, units = self._estimate(body)
        n = len(body.get("renders") or [])
        label = label or (f"{body.get('op', 'render')} {n} render{'s' if n != 1 else ''}" + (f" x {units // max(n, 1)} windows" if units > n else "")
                          + f", {body.get('model', 'mono')}")
        bar = _Progress(label, est, bool(getattr(self, "progress", True)))
        try:
            d = self._post_raw(body)
        except BaseException:
            bar.done("failed"); raise
        gpu = d.get("render_s")
        if gpu and units and gpu > 0.5:              # learn this model's rate (a cache hit has the old render_s; fine)
            m = body.get("model", "mono"); r = max(gpu - 1.0, 0.1) / units
            self._rate[m] = 0.5 * self._rate.get(m, r) + 0.5 * r
        bar.done("done")
        return d

    def _post_raw(self, body: dict) -> dict:
        if self._demo is not None:
            return self._demo.handle(json.loads(json.dumps(body)))
        headers = {"Content-Type": "application/json", "X-FlowEdit-Client": self.client}
        if self.token:
            headers["Authorization"] = f"Bearer {self.token}"
        data = json.dumps(body).encode()
        # A damaged upload (TLS "bad record mac", broken pipe, reset: seen from home connections) never reaches the
        # queue, and an identical retry is free when the render did finish (the hub caches by body), so retry a
        # connection-level failure up to 3 times. An HTTP error from the service is never retried.
        for attempt in range(3):
            req = urllib.request.Request(f"{self.hub}/latentft", data=data, method="POST", headers=headers)
            try:
                with urllib.request.urlopen(req, timeout=2800) as r:      # the hub itself gives up at 2700 s (its 504)
                    d = json.loads(r.read())
                break
            except urllib.error.HTTPError as e:
                msg = e.read().decode(errors="replace")[:400]
                try:
                    msg = json.loads(msg).get("error") or json.loads(msg).get("detail") or msg
                except ValueError:
                    pass
                raise RuntimeError(f"the service said {e.code}: {msg}") from None
            except (urllib.error.URLError, ssl.SSLError, ConnectionError, TimeoutError) as e:
                if attempt == 2:
                    raise RuntimeError(f"could not reach the service after 3 attempts: {e}") from None
                time.sleep(2 * (attempt + 1))
        if "error" in d:
            raise RuntimeError(d["error"])
        return d

    # -- discovery ---------------------------------------------------------------------------------
    def models(self) -> list[dict]:
        """The models the service knows, with "online" and each one's axis (n_bins, bin_hz, window_s, channels)."""
        if self._demo is not None:
            return [{**m, "online": True} for m in self._demo.infos()]
        return json.loads(self._get("/latentft/models"))["models"]

    def online(self) -> bool:
        if self._demo is not None:
            return True
        return "latentft" in json.loads(self._get("/health")).get("kinds_online", [])

    def library(self) -> list[dict]:
        """The class loop library (hub only): Freesound Loop Dataset loops with BPM, genre, credit and licence."""
        return json.loads(self._get("/loops/manifest.json"))["loops"]

    def loop(self, loop_id: str) -> tuple[np.ndarray, int]:
        item = next(l for l in self.library() if l["id"] == str(loop_id))
        y, sr = sf.read(io.BytesIO(self._get("/loops/" + item["file"])), dtype="float32", always_2d=True)
        return y, sr

    # -- operations --------------------------------------------------------------------------------
    def render(self, a: np.ndarray, sr: int, renders: list[dict], b: np.ndarray | None = None, sr_b: int | None = None,
               model: str = "mono", start_s: float = 0.0, start_s_b: float = 0.0, seed: int = 0,
               steps: int = 35, seconds: float | None = None, rate_detail: str = "columns",
               include_ref: bool = True, bpm_a: float | None = None, bpm_b: float | None = None,
               return_latents: bool = False, stereo_mode: str = "lr") -> Result:
        """renders: [{"a": spec}, {"a": spec, "b": spec, "weights": [wa, wb]}, {"a": spec, "zoom": 0.2}, ...]
        seconds: length of the selection (5.944-30 s; default the whole clip after start_s, capped at 30). Longer
        selections are rendered as overlapping model windows and take proportionally longer.
        rate_detail: "columns" (64 log columns, the page's picture), "bins" (every channel x bin, large) or "none".
        return_latents: also return the first window's latents (input, each render's conditions and output; ~0.2 MB
        each): Result.input_latent(), .latent_cond(i), .latent_out(i).
        stereo_mode (stereo model only): "lr" = each channel vocoded on its own, L and R come out with unrelated phase
        (uncorrelated, maximally wide); "mid" = one vocoder pass on the mid, L and R from the model's per-band level
        differences, so the channels share a phase like the recording. Mono models ignore it."""
        if seconds is None:
            seconds = (len(a) / sr) - start_s
        seconds = float(min(max(seconds, WINDOW_S), 30.0))
        seconds = round(seconds * SR) / SR                    # whole samples at 22.05 kHz
        body = {"model": model, "audio_b64": _wav_b64(a, sr, start_s, seconds), "renders": renders, "seed": int(seed),
                "steps": int(steps), "batch": 16, "include_ref": bool(include_ref), "seconds": seconds, "format": "flac",
                "rate_detail": rate_detail}
        if return_latents:
            body["return_latents"] = True
        if stereo_mode != "lr":
            body["stereo_mode"] = stereo_mode
        if b is not None:
            body["audio_b64_b"] = _wav_b64(b, sr_b or sr, start_s_b, seconds)
        if bpm_a:
            body["bpm_a"] = float(bpm_a)
        if bpm_b:
            body["bpm_b"] = float(bpm_b)
        return Result(self._post(body, getattr(self, "_label", None)))

    def render_many(self, a: np.ndarray, sr: int, renders: list[dict], chunk: int = 48, progress=print, **kw) -> Result:
        """Any number of renders, in calls of `chunk` (the service takes at most 48 per call), merged into one Result.
        Same clip, same seed in every call, so all of them share the noise and line up, as in one call."""
        parts = []
        total = len(renders)
        for i in range(0, total, chunk):
            self._label = f"renders {i + 1}-{min(i + chunk, total)} of {total}"
            try:
                parts.append(self.render(a, sr, renders[i: i + chunk], **kw))
            finally:
                self._label = None
            if progress and not getattr(self, "progress", True):
                progress(f"  {min(i + chunk, total)}/{total} renders, {parts[-1].render_s} s on the GPU")
        d = dict(parts[0].raw)
        d["renders"] = [r for p in parts for r in p.renders]
        d["render_s"] = round(sum(p.render_s or 0 for p in parts), 2)
        return Result(d)

    def encode(self, a: np.ndarray, sr: int, model: str = "mono", start_s: float = 0.0, rate_detail: str = "columns",
               include_ref: bool = True) -> Encoded:
        """One model window (5.944 s from start_s) -> its latent, to manipulate in numpy and send to decode()."""
        body = {"op": "encode", "model": model, "audio_b64": _wav_b64(a, sr, start_s, WINDOW_S), "format": "flac",
                "rate_detail": rate_detail, "include_ref": bool(include_ref)}
        return Encoded(self._post(body))

    def decode(self, renders: list, model: str = "mono", seed: int = 0, steps: int = 35, rate_detail: str = "columns",
               stereo_mode: str = "lr") -> Result:
        """renders: a list whose items are a latent (C, T) array, or {"conds": [z1, z2, ...], "weights": [...]} for a
        blend of several conditions. All renders share the seed's noise, like render()."""
        items = []
        for r in renders:
            if isinstance(r, dict):
                items.append({"conds": [latent_to_b64(z) for z in r["conds"]], **({"weights": list(r["weights"])} if r.get("weights") else {})})
            else:
                items.append({"conds": [latent_to_b64(r)]})
        body = {"op": "decode", "model": model, "renders": items, "seed": int(seed), "steps": int(steps), "batch": 16,
                "format": "flac", "rate_detail": rate_detail}
        if stereo_mode != "lr":
            body["stereo_mode"] = stereo_mode
        return Result(self._post(body, getattr(self, "_label", None)))
