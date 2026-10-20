# LatentFT Python client and figures

Two files, standard Python, no GPU: `latentft_client.py` talks to the service (`API.md` is the wire format it
speaks) and `latentft_viz.py` draws the results. Both are in `demo/` of this repo and are served at
https://latentft.csail.mit.edu/notebook/latentft_client.py and `.../latentft_viz.py`; the lab notebook
`LatentFT_lab.ipynb` uses them cell by cell.

```sh
pip install numpy soundfile librosa matplotlib          # librosa only for resampling, onset_peaks and the spectrograms
curl -sSO https://latentft.csail.mit.edu/notebook/latentft_client.py
curl -sSO https://latentft.csail.mit.edu/notebook/latentft_viz.py
```

```python
from latentft_client import LatentFT, keep, lowpass, highpass, soft_lowpass, ALL, SR, WINDOW_S, BIN_HZ
from latentft_viz import show, show_all, describe, onset_peaks, soft_band, soft_octave, xfade_sweep, sweep_figure

lf = LatentFT(token="...")                                # or $LATENTFT_TOKEN, or ~/.config/flowedit/token
a, sr = lf.loop("425998")                                 # a loop from the class library, or soundfile.read(...)
res = lf.render(a, sr, [{"a": ALL[:4]}, {"a": keep(hz=[[1.3, 2.7]])}], model="mono")
res.audio(0)                                              # (T, ch) float32 at 22.05 kHz
res.keep(0)["ranges"]                                     # the bins render 0 kept, as the service resolved them
```

Audio is always a `(T, ch)` float32 numpy array (`soundfile` convention). Everything that comes back from the
service is at `SR` = 22050 Hz.


## Installing

```
pip install latentft-lab --extra-index-url https://latentft.csail.mit.edu/pip/simple          # client only
pip install "latentft-lab[viz]" --extra-index-url https://latentft.csail.mit.edu/pip/simple   # with the pictures (matplotlib, ipywidgets)
```

Then `from latentft_client import LatentFT, keep` and `from latentft_viz import ...` as below, or everything at once with
`from latentft_lab import *`. The hosted notebook at https://latentft.csail.mit.edu/jupyter/ has it installed. Without
pip, the two files `latentft_client.py` and `latentft_viz.py` from https://latentft.csail.mit.edu/notebook/ work on their
own next to your notebook (numpy, soundfile and librosa needed; matplotlib for pictures).

## latentft_client

### Constants

| name | value | meaning |
|---|---|---|
| `HUB` | `$LATENTFT_HUB` or `https://latentft.csail.mit.edu` | the default service |
| `SR` | 22050 | the models' sample rate; all returned audio |
| `WINDOW_S` | 5.944 | one model window, seconds |
| `ALL` | `[1, 2, 3, 4, 5, 6, 7, 8]` | every band; `ALL[:4]` is bands 1-4 |
| `BAND_EDGES` | `[0, 4, 8, 16, 32, 64, 128, 256, 513]` | the bin where each band starts |
| `BIN_HZ` | 0.084114 | Hz between rate bins |

### Keep-spec builders

`keep(bands=None, bins=None, hz=None, mask=None, dc=None) -> dict`
Build a keep-spec from exactly one of the four forms; `ValueError` for zero or two. `hz` takes a list of pairs or
one bare pair; `bins` takes ints and `[lo, hi]` lists; `mask` takes anything array-like (513 gains, or C x 513) and
is rounded to 4 decimals; `dc=True|False` adds the explicit bin-0 flag. A plain list `[1, 2, 5]` is also a valid
spec without this function.

```python
keep(bands=[1, 2])                      # {"bands": [1, 2]}
keep(hz=[0.3, 1.2])                     # {"hz": [[0.3, 1.2]]}
keep(bins=[0, [16, 31], 200], dc=False) # {"bins": [0, [16, 31], 200], "dc": False}
keep(mask=np.ones(513) * 0.5)           # a soft mask
```

`lowpass(hz_cut) -> dict`
Keep rates 0 .. `hz_cut` Hz (bin 0 included, since 0 Hz is in the range).

`highpass(hz_cut) -> dict`
Keep rates `hz_cut` .. 43.07 Hz. Bin 0 is still kept when this is the only condition (the dc rule); add
`dc=False` by hand (`keep(hz=[[hz_cut, 43.07]], dc=False)`) to drop it.

`soft_lowpass(hz_cut, width_hz=0.5, n_bins=513, bin_hz=BIN_HZ) -> dict`
A raised-cosine roll-off instead of a brick wall: gain 1 below `hz_cut - width_hz/2`, 0 above `hz_cut + width_hz/2`,
as a `mask` spec.

```python
renders = [{"a": lowpass(2.5)}, {"a": soft_lowpass(2.5, width_hz=1.0)}, {"a": highpass(5.0)}]
```

### Latent helpers

`latent_to_b64(z) -> dict` turns a `(C, T)` array into the wire form `{"b64", "shape", "dtype": "float32"}`;
`latent_from_b64(d) -> np.ndarray` reads one back. `LatentFT.decode` and `Result` call these for you.

### `class LatentFT`

`LatentFT(token=None, hub=HUB, client="notebook", require_token=None)`

| argument | meaning |
|---|---|
| `token` | your class or personal token. If `None`: `$LATENTFT_TOKEN`, then `~/.config/flowedit/token` (the hosted notebook writes that file). `RuntimeError` when none is found and one is required |
| `hub` | the service URL; `http://127.0.0.1:...` or `http://localhost:...` makes the token optional |
| `client` | sent as `X-FlowEdit-Client`, shown in the hub's queue |
| `require_token` | override the rule above (`False` for a tokenless server on another host) |

```python
lf = LatentFT()                                                    # the hub, token from the environment or file
lf = LatentFT(hub="http://127.0.0.1:8765", token="the job's token") # your own latentft_server.py through a tunnel
```

`LatentFT.in_process(models, device=None) -> LatentFT` (classmethod)
Load the models into this Python process and call the engine directly, no HTTP. Needs torch, a GPU (CPU works and
is slow), and this repo's `demo/` and `colab/` on `sys.path`. `models` is `{"mono": "/path/weights.pt"}` or
`{"unet": {"path": ..., "fp32": True}}`. `device` defaults to `cuda` when available. Every method below then works
the same; `library()` and `loop()` do not (they are hub files).

```python
import sys; sys.path += ["/path/to/latentft-post-training/demo", "/path/to/latentft-post-training/colab"]
lf = LatentFT.in_process({"mono": "/path/to/latentft_mlp_5s_ema_fp32.pt"})
```

`lf.models() -> list[dict]`
The models the service knows. From the hub: catalogue rows (`name`, `label`, `channels`, `encoder`, `note`,
`online`, `workers`); from a standalone server or in process: full `model_info` rows with `online: True`.

```python
MODEL = next(m["name"] for m in lf.models() if m.get("online"))
```

`lf.online() -> bool`
Whether a LatentFT GPU is up (`GET /health`, `kinds_online`). Always `True` in process.

`lf.library() -> list[dict]`
The class loop library (hub only): Freesound Loop Dataset entries with `id`, `file`, `bpm`, `group`, credit and
licence.

`lf.loop(loop_id) -> (audio, sr)`
Download one library loop as `(T, ch)` float32 and its sample rate.

```python
lib = lf.library()
A_ID = next(l["id"] for l in lib if l["group"] == "drums")
a, sr = lf.loop(A_ID); BPM_A = next(l["bpm"] for l in lib if l["id"] == A_ID)
```

`lf.render(a, sr, renders, b=None, sr_b=None, model="mono", start_s=0.0, start_s_b=0.0, seed=0, steps=35,
seconds=None, rate_detail="columns", include_ref=True, bpm_a=None, bpm_b=None, return_latents=False) -> Result`

| argument | meaning |
|---|---|
| `a`, `sr` | clip A, `(T,)` or `(T, ch)` float array and its sample rate; resampled to 22.05 kHz here before upload |
| `renders` | the list of render objects: `{"a": spec}`, `{"a": spec, "b": spec, "weights": [wa, wb]}`, `{"a": spec, "zoom": 0.2}` |
| `b`, `sr_b` | clip B; `sr_b` defaults to `sr` |
| `model` | `mono`, `stereo`, `unet`, whatever `models()` says is online |
| `start_s`, `start_s_b` | where each selection starts, seconds |
| `seed` | the shared initial noise of every render in this call |
| `steps` | sampler steps, 8..60 |
| `seconds` | selection length; default the rest of clip A after `start_s`, clipped to 5.944..30 and rounded to whole samples. Longer selections are rendered as overlapping windows and take proportionally longer |
| `rate_detail` | `"columns"` (default), `"bins"` (every channel x bin, large) or `"none"` |
| `include_ref` | also fetch each clip through mel + vocoder only (`Result.ref`) |
| `bpm_a`, `bpm_b` | known tempos (sent only when truthy); otherwise the service estimates |
| `return_latents` | also fetch the first window's latents (about 0.16 MB each) for `Result.input_latent`, `.latent_cond`, `.latent_out` and the figures |

The client cuts the selection itself (`start_s` .. `start_s + seconds`) and uploads exactly that span as 16-bit WAV at
22.05 kHz, so uploads stay small and `start_s` never reaches the service. It sends `format: "flac"` and `batch: 16`.
Any non-2xx answer raises `RuntimeError("the service said 400: bad request: ...")` with the service's message.

```python
res = lf.render(a, sr, [{"a": ALL[:k]} for k in range(1, 9)], model=MODEL, seconds=WINDOW_S, bpm_a=BPM_A, return_latents=True)
print(res)                                 # <LatentFT result: 8 renders, mono, 11.8 s on the GPU>
```

`lf.encode(a, sr, model="mono", start_s=0.0, rate_detail="columns", include_ref=True) -> Encoded`
One model window (5.944 s from `start_s`) to its latent.

```python
enc = lf.encode(a, sr, model=MODEL)
enc.z.shape                                # (80, 512)
```

`lf.decode(renders, model="mono", seed=0, steps=35, rate_detail="columns") -> Result`
Latents to audio, all from one seed's noise. Each item of `renders` is a `(C, T)` array (one condition) or
`{"conds": [z1, z2, ...], "weights": [...]}` (a blend of up to 4; `weights` optional, equal by default).

```python
res = lf.decode([enc.z, enc.masked(g), {"conds": [ea.z, eb.z], "weights": [0.7, 0.3]}], model=MODEL)
```

### `class Result`

What `render()` and `decode()` return. Attributes: `raw` (the whole response dict), `renders` (the response's list),
`clip_a`, `clip_b` (dicts, `{}` when absent), `bands`, `rate_hz`, `sr`, `model`, `model_info`, `render_s`.
`len(res)` is the number of renders.

| method | returns |
|---|---|
| `res.audio(i)` | render `i` as `(T, ch)` float32 at 22.05 kHz |
| `res.ref(which="a")` | clip A or B through mel + vocoder only, `(T, ch)` (needs `include_ref`; `KeyError` after a decode) |
| `res.keep(i, which="a")` | the `keep` dict the service applied to that clip in render `i`: `form`, `soft`, `dc`, `ranges`, `hz`, `support`, `support_hz`, `full`, `full_hz`, `bins_kept`; `None` when the render did not use that clip |
| `res.mask(i, which="a", n_bins=513)` | the gain per rate bin as a `(513,)` array: the echoed `mask` spec (max over channels) when there was one, else 1 over `support`; bin 0 set from `keep.dc` |
| `res.label(i)` | a short label, e.g. `A 0-2.6075Hz`, `A soft 0-2.944Hz (full gain 0-2.0187Hz)`, `A 0-0.5888Hz, B 2.6917-43.0664Hz, weights 0.70/0.30` |
| `res.input_latent(which="a")` | the clip's latent `(C, T)`, first window (needs `return_latents=True`) |
| `res.latent_cond(i)` | the conditioning latents of render `i`, a list of `(C, T)` arrays in the order a, b (a `zoom` render has two: masked, then whole) |
| `res.latent_out(i)` | the output of render `i` re-encoded, `(C, T)` |
| `res.save(folder, prefix="render")` | writes `render_00_<label>.wav`, ... and `ref_a.wav` / `ref_b.wav` as 22.05-kHz WAV; returns the paths |

```python
for i in range(len(res)):
    k = res.keep(i)
    print(i, res.label(i), k["bins_kept"], "bins, dc =", k["dc"])
    display(Audio(res.audio(i).T, rate=res.sr))
print(res.clip_a["bpm"], "BPM, beat in band", res.clip_a["beat_band"])
```

### `class Encoded`

What `encode()` returns. Attributes: `z` (the latent `(C, T)` float32), `raw`, `model`, `model_info`, `n_fft`
(1024), `bin_hz`, `rate_hz`, `band_energy_db`; `freqs` is the rate axis in Hz, `(513,)`.

| method | returns |
|---|---|
| `enc.spectrum(z=None)` | `rfft` along time of `z` (default `enc.z`), complex `(C, 513)` |
| `enc.from_spectrum(Z)` | back to a `(C, T)` float32 latent, what `decode()` wants |
| `enc.masked(gains)` | a gain per bin `(513,)` or per channel and bin `(C, 513)` applied exactly as the service does |
| `enc.ref()` | the window through mel + vocoder only, `(T, ch)` |

```python
Z = enc.spectrum()
Z[:, 32:64] *= 3                                     # boost the 8th-note band by hand
z_strong = enc.from_spectrum(Z)
```

## latentft_viz

Pure numpy for the masks and the piece; matplotlib and librosa for the figures; IPython for `show`.
Constants: `SR`, `BIN_HZ`, `N_BINS` (513), `F` (the 513 bin centres in Hz), `FRAME_RATE` (86.13).

### Masks and pieces

`soft_band(f0, width_hz) -> np.ndarray`
A raised cosine centred on `f0` in linear Hz: gain 1 at `f0`, 0 at `f0 +- width_hz/2`. 513 gains, for `keep(mask=...)`.

`soft_octave(fc, octaves=1.0) -> np.ndarray`
A raised cosine in log frequency: gain 1 at `fc`, 0 at `fc * 2^(+-octaves/2)`. Bin 0 is 0; the service's dc rule
decides it (kept, for a lone condition). `1 - soft_octave(fc)` is the notch.

```python
beat = BPM_A / 60
renders = [{"a": keep(mask=soft_octave(beat))}, {"a": keep(mask=1 - soft_octave(beat))}, {"a": keep(mask=soft_band(beat, 0.5))}]
```

`xfade_sweep(renders, passes=(True,), repeats=1) -> np.ndarray`
A piece from a list of same-length renders `(T, ch)` that share a seed: per pass the clip plays `repeats` times while
the active render moves linearly through the list (`True` = up, `False` = down), equal-power crossfade between
neighbours. Returns `(T * repeats * len(passes), ch)`.

`random_soft_mask(seed, corr_octaves=0.35, sharpness=2.0) -> np.ndarray`
A random gain per rate bin: Gaussian noise correlated along log frequency (kernel width `corr_octaves`), squashed
through a sigmoid (`sharpness` higher = closer to 0/1). The soft cousin of the paper's training masks. Bin 0 is 1.

### Analysis

`onset_peaks(y, sr) -> list[tuple[float, str]]`
The clip's strongest onset rate in three ranges: `(hz, "beat?")` in 0.8-1.8 Hz, `"syllables?"` in 1.8-3.6, `"strum?"`
in 3.6-7.2. For the `marks` argument of the figures.

`describe(res, i) -> str`
One sentence saying what render `i` does, from the service's `keep`: e.g. "from the clip, keep only 1.35-2.69 Hz
(17 bins, hard edges); the rest regenerated; zoom 0.2".

### Figures

`render_figure(res, i, which="a", marks=None, words=None, title=None, z_scale=None) -> matplotlib.figure.Figure`
The five panels of render `i`: the mask over the rate axis (gain per bin, log Hz, with `marks` as dotted lines); the
clip's latent (channels x time, first window); the latent the decoder was given; the output re-encoded; the output's
mel spectrogram. Needs `render(..., return_latents=True)` (`ValueError` otherwise). `which` picks clip a or b for
the mask and latent panels; `z_scale` fixes the colour scale (default the 99th percentile of the input latent);
`words` defaults to `describe(res, i)`.

`sweep_figure(audio, centres, passes, marks=None, words="", title="", band=True, model="", octaves=1.0) -> Figure`
The picture of a gliding-zone piece from `xfade_sweep`: the kept rates over time (blue; `band=False` draws the
erased zone grey and the rest blue) and the piece's spectrogram. `centres` are the zone centres in Hz you rendered,
`passes` the same list you gave `xfade_sweep`.

### In a notebook

`show(res, i, which="a", marks=None, words=None, z_scale=None)`
One render the way the listening page shows it: a bold label line with the sentence, an audio player, the five
panels. Closes the figure after showing it.

`show_all(res, which="a", marks=None, words=None, indices=None)`
Every render of a result (or `indices`) through `show`, with one colour scale for the whole set. `words` is a list or
`{index: sentence}` of your own captions.

```python
res = lf.render(a, sr, renders, model=MODEL, seconds=WINDOW_S, return_latents=True)
show_all(res, marks=onset_peaks(a, sr))
```

## Recipes

Each assumes the setup block at the top: `lf`, a clip `a, sr`, its `BPM_A` (or `None`), and `MODEL`.

### A band ladder

```python
res = lf.render(a, sr, [{"a": ALL[:k]} for k in range(1, 9)], model=MODEL, seconds=WINDOW_S, bpm_a=BPM_A, return_latents=True)
show_all(res, marks=onset_peaks(a, sr))      # render 0 is band 1 only, render 7 is everything (the reconstruction)
```

### A Hz zone around the beat

```python
bpm = res.clip_a["bpm"] or 120.0
beat = bpm / 60
res2 = lf.render(a, sr, [
    {"a": keep(hz=[[beat / 1.41, beat * 1.41]])},         # the octave around the beat, hard edges
    {"a": keep(bins=[[0, 15], [128, 512]])},             # slow + very fast, nothing in between
    {"a": keep(hz=[[beat / 1.41, beat * 1.41]], dc=False)},   # the same octave without the mean
], model=MODEL, seconds=WINDOW_S, bpm_a=BPM_A)
for i in range(len(res2)):
    print(res2.label(i), res2.keep(i)["hz"] or res2.keep(i)["support_hz"])
```

### Stereo with one phase

```python
res_lr = lf.render(a, sr, renders, model="stereo", seconds=10)                      # default: L and R vocoded separately
res_mid = lf.render(a, sr, renders, model="stereo", seconds=10, stereo_mode="mid")  # one phase, width from the model's levels
```

Per-channel vocoding gives left and right unrelated phase (L/R correlation about 0 even for the plain reconstruction of
a recording at +0.6). `stereo_mode="mid"` keeps the model's level differences between the channels but vocodes once,
so the image is coherent like the recording. Mono models ignore the option.

### A soft edge against a brick wall

```python
res3 = lf.render(a, sr, [{"a": lowpass(2.5)}, {"a": soft_lowpass(2.5, width_hz=1.0)}], model=MODEL, seconds=WINDOW_S)
k = res3.keep(1); print(k["soft"], "support", k["support_hz"], "full gain", k["full_hz"])
```

### Two clips: A's slow rates, B's fast rates, with weights

```python
b, sr_b = lf.loop(B_ID)
cut = 2.7                                                # Hz: A below, B above
sweep = [{"a": keep(hz=[[0, cut]]), "b": keep(hz=[[cut, 43.07]]), "weights": [w, round(1 - w, 2)]}
         for w in (0.9, 0.7, 0.5, 0.3, 0.1)]
res5 = lf.render(a, sr, sweep, b=b, sr_b=sr_b, model=MODEL, seconds=WINDOW_S, bpm_a=BPM_A, bpm_b=BPM_B)
print(res5.keep(0, "a")["dc"], res5.keep(0, "b")["dc"])  # True False: A's range covers 0 Hz, so A owns the mean
```

### Zoom in on a band

```python
res_z = lf.render(a, sr, [{"a": keep(hz=[[4, 8]]), "zoom": z} for z in (0.0, 0.1, 0.2, 0.4)], model=MODEL, seconds=WINDOW_S)
# zoom 0 is a plain solo of 4-8 Hz; larger zoom lets more of the whole clip back in
```

### Encode, edit the latent yourself, decode

```python
ea, eb = lf.encode(a, sr, model=MODEL), lf.encode(b, sr_b, model=MODEL)
Za = ea.spectrum()
Z_strong = Za.copy(); Z_strong[:, 32:64] *= 3                      # louder 8ths
z_strong = ea.from_spectrum(Z_strong)
z_collage = ea.from_spectrum(np.where(ea.freqs < 2.7, Za, eb.spectrum()))   # A's slow bins, B's fast bins, one latent
z_mean = ea.masked(np.r_[1.0, np.zeros(512)])                      # only bin 0: level and timbre, no movement
res6 = lf.decode([ea.z, z_strong, z_collage, z_mean, {"conds": [ea.z, eb.z], "weights": [0.5, 0.5]}], model=MODEL)
```

The dc rule is not applied to latents you send: whatever your spectrum has at bin 0 is what the decoder gets.

### A glide piece with xfade_sweep

```python
SWEEP_S = min(30.0, len(a) / sr)                         # longer selections make a longer glide, 30 s max
centres = np.geomspace(0.4, 16.0, 8)
glide = [{"a": keep(mask=soft_octave(fc))} for fc in centres]
res_g = lf.render(a, sr, glide, model=MODEL, seconds=SWEEP_S, bpm_a=BPM_A)
renders = [res_g.audio(i) for i in range(len(res_g))]    # same seed, same length: they crossfade cleanly
piece = xfade_sweep(renders, passes=[True, False], repeats=1)
sweep_figure(piece, centres, [True, False], marks=onset_peaks(a, sr),
             words=f"the kept octave glides {centres[0]:.1f} -> {centres[-1]:.1f} Hz and back", title="glide", model=MODEL)
sf.write("glide.wav", piece, SR)
```

### A random soft mask

```python
from latentft_viz import random_soft_mask
res_r = lf.render(a, sr, [{"a": keep(mask=random_soft_mask(s))} for s in range(4)], model=MODEL, seconds=WINDOW_S, return_latents=True)
show_all(res_r)                                          # the mask panel shows each random gain curve
```

### Bulk render for mapping offline

```python
centres = np.geomspace(0.4, 16.0, 16); widths = (1.0, 2.0, 3.0)
grid = [(fc, w) for w in widths for fc in centres]                       # 48 renders
renders = [{"a": keep(mask=soft_octave(fc, w))} for fc, w in grid]
res = lf.render_many(a, sr, renders, model="stereo", seconds=30, seed=0)   # calls of 48, one seed: everything lines up
paths = res.save("bulk_stereo_30s", prefix="zone")                       # WAVs + manifest.json (index, file, a/b, weights, keep)
```

`render_many` splits a list of any length into calls the service accepts (48 per call) and merges the results into one
`Result`. `save` writes a `manifest.json` next to the files, so a SuperCollider or Max patch can map a controller to the
files by what each one kept (bins and Hz) without the notebook. Zip the folder and download it from the hosted
notebook's file browser (right-click the zip).

### A sweep as a job (`latentft-sweep`)

```
latentft-sweep ~/Music/my_song.wav --start 120 --seconds 30 --out my_sweep --centres 0.4 16 24 --octaves 2 --kind band --glides
```

It prints its progress as it goes. If it stops (you close the terminal, the network drops), run the same command
again: it picks up where it left off.

Installed with the package. One render per zone centre (K log-spaced centres from LO to HI Hz), `--widths 1 2 3` and
`--seeds 0 1 2` for more axes, `--kind notch` to erase instead of keep, `--stereo-mode mid|lr`, `--model`. Writes the
renders as the only top-level WAVs (so the Max crossfader's folder loader sees just them), `manifest.json` after
every 48, `ref/` (the original and the vocoder reference) and with `--glides` the crossfaded pieces in `glides/`.
Existing files are skipped, so an interrupted job continues; identical requests are cache hits on the service.
On Engaging, the same command inside an `sbatch` script with `--hub http://127.0.0.1:8765` against your own server
(`own-gpu-engaging/`) is the batch route.

### Saving

```python
paths = res.save("out/ladder", prefix="ladder")          # out/ladder/ladder_00_A_0-0.252Hz.wav, ..., out/ladder/ref_a.wav
sf.write("out/one.wav", res.audio(3), res.sr)            # or any single render by hand
import json; json.dump(res.raw, open("out/ladder/response.json", "w"))   # the whole response, audio included
```

### Your own GPU

Through a tunnel to a `latentft_server.py` job (see `engaging/README.md`):

```python
lf = LatentFT(hub="http://127.0.0.1:8765", token=open("logs/latentft-server-<jobid>.token").read().strip())
```

In the same process, in a Jupyter kernel with the repo and the weights on the GPU node:

```python
import sys
REPO = "/path/to/latentft-post-training"
sys.path += [f"{REPO}/demo", f"{REPO}/colab"]
lf = LatentFT.in_process({"mono": "/path/to/latentft_mlp_5s_ema_fp32.pt",
                          "unet": {"path": "/path/to/latentft_unet_5s_ema_fp32.pt", "fp32": True}})
res = lf.render(a, sr, [{"a": ALL[:4]}], model="unet")  # identical calls, no HTTP, no token, no library
```
