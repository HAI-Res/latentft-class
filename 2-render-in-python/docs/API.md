# LatentFT service API (v2)

One endpoint, `POST /latentft`, JSON in, JSON out, on

| where | URL | token |
|---|---|---|
| the class hub | `https://latentft.csail.mit.edu/latentft` (the same hub as `audioflow.csail.mit.edu`) | `Authorization: Bearer <class or personal token>` |
| your own GPU | `http://127.0.0.1:8765/latentft` from `demo/latentft_server.py` (see `engaging/`) | whatever `--token` you started it with, or none |

`demo/latentft_client.py` wraps all of this in Python (documented in `CLIENT.md`); the notebook
`demo/LatentFT_lab.ipynb` walks through it. This page is the wire contract, for anyone writing their own client
(SuperCollider, Max, curl). Everything below is what the code does: `demo/latentft_demo.py` (the engine),
`demo/latentft_masks.py` (keep-specs), `demo/latentft_server.py` (the standalone server) and the hub's
`hub/server.py` in `HAI-Res/sa-flowedit`.

## Endpoints

| method and path | token | what |
|---|---|---|
| `POST /latentft` | yes | a render / encode / decode / info request; the body's `op` field picks the operation (default `render`) |
| `GET /latentft/models` | no | the models: which are online, and on the hub which worker holds each |
| `GET /health` | no | is a GPU up: `kinds_online` contains `"latentft"` when one is; cache statistics |
| `GET /whoami` | yes | is this token known, and is it personal (hub only) |
| `GET /queue` | optional | who is waiting and rendering, and the workers (hub only) |
| `GET /latentft/history` | personal | your own saved sessions (hub only) |
| `GET /latentft/history/{job}/request`, `.../result` | personal | one saved session's request or result body, verbatim (hub only) |
| `GET /latentft` | no | the web app (hub only; the site root of `latentft.csail.mit.edu` is the same page) |
| `GET /loops/manifest.json`, `GET /loops/<file>` | no | the class loop library (hub only) |

### Authentication and headers

The hub reads the token from `Authorization: Bearer <token>` or, equivalently, from an `X-FlowEdit-Token: <token>`
header (the latter wins when both are sent). The standalone server reads `Authorization: Bearer` only, and only
when it was started with `--token`. A token is a *class* token (shared, from the instructor) or a *personal* token
(from your sign-in link); both render, only a personal token gets a history.

Request headers:

| header | meaning |
|---|---|
| `Content-Type: application/json` | the body is one JSON object |
| `Authorization: Bearer <token>` | your token (see above) |
| `X-FlowEdit-Client: <name>` | optional free text naming your client; shown in `/queue`, never changes the result |
| `X-LatentFT-Meta: <url-encoded JSON>` | optional, hub only: `{"tab", "a", "b", "a_start", "b_start"}`, the web app's clip titles for the history list. Not part of the body, so it never changes the cache key. Over 2000 characters or not JSON: ignored |

Response headers from the hub (none of these come from the standalone server):

| header | meaning |
|---|---|
| `X-FlowEdit-Job` | the job id (absent on a cache hit) |
| `X-FlowEdit-Worker` | the worker that rendered it; `cache` on a cache hit |
| `X-FlowEdit-Kind` | `latentft` |
| `X-FlowEdit-Queued-S` | seconds the job waited for a GPU (`0.0` on a hit) |
| `X-FlowEdit-Render-S` | seconds the worker took (`0.0` on a hit) |
| `X-FlowEdit-Cache` | `hit`, `shared` or `miss`; see *Cache* below |

The response body is always `application/json`. The standalone server adds `Access-Control-Allow-Origin: *` and
answers `OPTIONS` for browsers.

## The rate axis

A model window (5.944 s for every model served today) becomes a latent of C channels x 512 frames at 86.13 frames/s.
The Fourier transform of each channel along time has **513 bins**, bin k at `k x 0.084114 Hz`, 0 .. 43.07 Hz. A
*keep-spec* says which bins (and at what gain) of a clip's latent the decoder is given; it regenerates the rest.
Bin 0 is each channel's mean (overall level and timbre). The paper's 8 log bands are edges at bins
0, 4, 8, 16, 32, 64, 128, 256, 513 (`bands` in every render response lists them in Hz):

| band | bins | Hz (bin centres) | at 120 BPM |
|---|---|---|---|
| 1 | 0-3 | 0 - 0.252 | slower than a bar, plus bin 0 |
| 2 | 4-7 | 0.336 - 0.589 | the bar (0.5 Hz) |
| 3 | 8-15 | 0.673 - 1.262 | half notes (1 Hz) |
| 4 | 16-31 | 1.346 - 2.608 | the beat (2 Hz) |
| 5 | 32-63 | 2.692 - 5.299 | 8th notes (4 Hz) |
| 6 | 64-127 | 5.383 - 10.682 | 16th notes (8 Hz) |
| 7 | 128-255 | 10.767 - 21.449 | 32nd notes, rolls, flams |
| 8 | 256-512 | 21.533 - 43.066 | micro-timing, attacks |

C is 80 for the mono models and 160 for the stereo model (left channels 0-79, right 80-159). Every number on this
page (513, 0.0841 Hz, 5.944 s, 80 or 160) is a property of the model and is reported in `model_info`; a client
that wants to survive a future model with another window should read `n_bins`, `bin_hz`, `window_s` and
`latent_channels` from there.

## Keep-specs

```
[1, 2, 5]                          bands 1..8
{"bands": [1, 2, 5]}               the same
{"bins": [0, 1, [16, 31], 200]}    bin indices and/or inclusive [lo, hi] ranges, 0..n_bins-1
{"hz": [[0.3, 1.2], [4, 8]]}       inclusive Hz ranges (a bin is in when its centre is in); one pair may be bare
{"mask": [g0, ..., g512]}          a gain per bin, 0..1; anything strictly between 0 and 1 is a *soft* mask
{"mask": [[...], ...]}             a gain per latent channel and bin (C x 513), when channels should differ
```

A dict form has exactly one of `bands`, `bins`, `hz`, `mask`, and may add `"dc": true|false`. The rules per form:

| form | accepted | rejected |
|---|---|---|
| `bands` | integers 1..8, repeats allowed | an empty list; a non-integer or a boolean; a band outside 1..8 |
| `bins` | integers 0..512 and two-element `[lo, hi]` lists with `lo <= hi`, inclusive | an empty list; a range of any other length; `lo > hi`; a bin outside 0..512 |
| `hz` | `[lo, hi]` pairs with `0 <= lo <= hi` and `lo <= 43.07`; a bare pair `[0.3, 1.2]` is read as one range; `hi` may exceed the top (it is clipped) | an empty list; a pair that selects no bin centre (narrower than 0.0841 Hz) |
| `mask` | a list of 513 numbers, or C lists of 513; values are **clipped to 0..1** silently | a wrong length; a wrong channel count; non-finite values; a mask that keeps nothing (all gains 0) |

A bin is in an `hz` range when `lo - 1e-9 <= k x bin_hz <= hi + 1e-9`. `{"hz": [[0, 2.5]]}` therefore covers bin 0.

**The dc rule** (`resolve_dc` in `latentft_masks.py`) decides bin 0 after the form is parsed:

1. One condition in the render (one keep-spec, or a `zoom` render): bin 0 is kept unless the spec says `"dc": false`.
   Without `dc`, bin 0 is set to gain 1 even when the spec did not cover it (`[5, 6]` keeps bins 32-127 *and* bin 0).
2. Two conditions (`a` and `b`): first, every spec with an explicit `dc` has bin 0 set to it. Then, if no condition
   has any gain at bin 0, every spec **without** an explicit `dc` gets bin 0 at gain 1. Specs that already covered
   bin 0 (band 1, a `bins` range from 0, an `hz` range from 0, a mask with `g0 > 0`) keep it and nothing else changes.

So: `{"a": [1, 2, 3, 4], "b": [5, 6, 7, 8]}` gives A bin 0 and B not. `{"a": [2, 3], "b": [6]}` gives it to both
(the paper's blend never drops the mean altogether). `{"a": {"bands": [1, 2], "dc": false}, "b": [6]}` gives it to
B only, and `{"a": {"bands": [1], "dc": false}, "b": {"bands": [6], "dc": false}}` to neither: an explicit `false`
is always honoured. The `keep.*.dc` field of the response reports what was finally applied (whether bin 0 has any
gain), never what you wrote.

**Soft masks** are an experiment: the model trained on 0/1 masks only, so a gain of 0.3 is a condition with that
rate's pattern at 30 % amplitude, not "30 % kept". For a controllable partial effect use `weights` (below). A spec
counts as `soft` when any gain is strictly between 0 and 1, or when a 2-D mask differs between channels anywhere.

## A render

The `renders` list of a render request holds objects, each one output file:

| field | type | meaning |
|---|---|---|
| `a` | keep-spec | what to keep of clip A (`null` = absent) |
| `b` | keep-spec | what to keep of clip B; needs `audio_b64_b` in the request |
| `weights` | `[wa, wb]` | blend weights for a two-condition render, non-negative, sum > 0, normalised to sum 1 by the service; default equal. For a single condition `[w]` is accepted and normalises to `[1.0]` |
| `zoom` | number 0..1 | the paper's zoom-in (Sec 4.5, App. A.8): the clip's chosen bins at weight 1 and its *whole* latent at weight `zoom`. Single-clip renders only; does not combine with `weights`. `0` is a plain solo |

At least one of `a` / `b` is required. Two specs make the paper's blend (Sec 4.3): each clip's latent is masked to
its own bins and the sampler follows both conditions, weighted.

## `op: "render"` (default)

```json
{
  "model": "mono",
  "audio_b64": "<WAV/FLAC/OGG, base64>",
  "audio_b64_b": "<optional clip B>",
  "start_s": 0.0, "start_s_b": 0.0,
  "seconds": 5.944,
  "renders": [
    {"a": [1, 2, 3, 4]},
    {"a": {"hz": [[1.3, 2.7]]}},
    {"a": {"bins": [[0, 63]]}, "b": {"bins": [[64, 512]]}},
    {"a": [1, 2], "b": [5, 6, 7, 8], "weights": [0.7, 0.3]},
    {"a": {"hz": [[4, 8]]}, "zoom": 0.2}
  ],
  "seed": 0, "steps": 35, "batch": 16,
  "format": "flac", "include_ref": true, "rate_detail": "columns",
  "return_latents": false,
  "bpm_a": 120, "bpm_b": 96
}
```

| field | type | default | range | meaning |
|---|---|---|---|---|
| `op` | string | `"render"` | render, encode, decode, info | the operation |
| `model` | string | `"mono"` | a name from `GET /latentft/models` | which model renders |
| `audio_b64` | string | required | | clip A: any file `soundfile` reads (WAV, FLAC, OGG), base64. Any sample rate (resampled to 22.05 kHz); mono or stereo (more channels are cut to the first two) |
| `audio_b64_b` | string | none | | clip B, the same way; an empty string counts as absent |
| `start_s`, `start_s_b` | number | 0 | >= 0 (negative is read as 0) | where in each clip the selection starts, seconds |
| `seconds` | number | the rest of clip A after `start_s` | clipped to `window_s` .. 30 | selection length. Shorter than one window is raised to one window; longer than 30 s is cut to 30. `null` means the default |
| `renders` | list | required | 1 .. 48 items | see *A render* |
| `seed` | integer | 0 | | the initial noise. Every render in one request shares it, so they line up in time and crossfade coherently; the same seed in another request gives the same noise |
| `steps` | integer | 35 | clipped to 8 .. 60 | sampler steps |
| `batch` | integer | 8 | clipped to 1 .. 32 | renders per GPU batch; purely a memory knob, no effect on the audio. The worker lowers it to 2 by itself after an out-of-memory |
| `format` | string | `"wav"` | `"flac"` or anything else (= wav) | encoding of every audio field in the response: 16-bit, 22.05 kHz, FLAC about half the size |
| `include_ref` | boolean | true | | also return each clip through mel + vocoder only (`clip_a.ref_wav_b64`), "what the model hears" and the ceiling every render is heard against |
| `rate_detail` | string | `"columns"` | columns, bins, none | the rate pictures: `columns` = the log-column picture (`rate_db`), `bins` = that plus every channel x bin (`rate_db_bins`, large), `none` = no pictures. `null` means columns |
| `return_latents` | boolean | false | | also return the **first window's** latents: each clip's input latent, each render's conditioning latents and its output's latent, as float32 base64 (about 0.16 MB each for C = 80) |
| `stereo_mode` | string | `"lr"` | stereo models only. `lr`: each channel through the vocoder on its own, so L and R get unrelated phase (uncorrelated, maximally wide; the behaviour before 2026-10-20). `mid`: the mid mel is vocoded once and L and R are made from that one waveform by the model's per-band level differences, so the channels share a phase like a recording. Echoed as `stereo_mode` (null for mono models). Also accepted by `decode`. |
| `bpm_a`, `bpm_b` | number | none | 40 .. 240 | a known tempo for `clip_a.bpm` / `beat_band`; outside the range or absent, the service estimates one (`librosa.beat.beat_track`) and reports `null` when the estimate is outside 40..240 |

Unknown fields are ignored. Field values are read with Python's `int()` / `float()`, so `"steps": "35"` works and
`"steps": "many"` is a 400.

**Selections and windows.** The clip is cut at `start_s`, then *tiled* (looped) or cut to the selection length plus
one window, so a 2-s loop with no `seconds` is heard as 5.944 s of itself repeating, never padded with silence. A
selection longer than one window is rendered as overlapping windows stitched with an equal-power crossfade (sine /
cosine over the overlap): the number of windows is `max(2, ceil((seconds - 0.25) / (window_s - 0.25)))`, spaced
evenly so neighbours overlap by at least 0.25 s. For the 5.944-s models: 6 s -> 2, 12 s -> 3, 20 s -> 4, 25 s -> 5,
30 s -> 6. Every window is rendered for every render, from the same noise.

**Limits.** 1 .. 48 renders; renders x windows <= 400 (a 400 is returned naming both numbers); the hub rejects an
`audio_b64` string longer than 32 MB (413) and nginx rejects a body over 64 MB (a bare 413 page, not JSON); the
standalone server rejects a body over 64 MB.

### Render response

```json
{
  "api": 2, "model": "mono", "model_info": {"...": "see op info"},
  "channels": 1, "sr": 22050, "format": "flac",
  "seconds": 5.944, "window_s": 5.944, "windows": 1, "steps": 35, "seed": 0,
  "n_bins": 513, "bin_hz": 0.084114,
  "bands": [{"band": 1, "lo_bin": 0, "hi_bin": 3, "lo_hz": 0.0, "hi_hz": 0.252, "name_at_120bpm": "slower than a bar"}, "..."],
  "rate_hz": [0.0841, 0.1682, 0.2523, "... one centre per rate_db column"],
  "renders": [
    {"a": [1, 2, 3, 4], "b": [], "weights": [1.0],
     "keep": {"a": {"form": "bands", "soft": false, "dc": true,
                    "ranges": [[0, 31]], "hz": [[0.0, 2.6075]],
                    "support": [[0, 31]], "support_hz": [[0.0, 2.6075]],
                    "full": [[0, 31]], "full_hz": [[0.0, 2.6075]], "bins_kept": 32}},
     "wav_b64": "<FLAC, base64>",
     "rate_db": [["...80 rows x 49 columns, dB, -80..0..."]]},
    {"a": {"hz": [[1.3, 2.7]]}, "b": [], "weights": [1.0],
     "keep": {"a": {"form": "hz", "soft": false, "dc": true, "ranges": [[16, 32]], "hz": [[1.3458, 2.6917]],
                    "support": [[16, 32]], "support_hz": [[1.3458, 2.6917]], "full": [[16, 32]], "full_hz": [[1.3458, 2.6917]], "bins_kept": 17}},
     "wav_b64": "...", "rate_db": ["..."]},
    {"a": {"bins": [[0, 63]]}, "b": {"bins": [[64, 512]]}, "weights": [0.5, 0.5],
     "keep": {"a": {"form": "bins", "soft": false, "dc": true, "ranges": [[0, 63]], "hz": [[0.0, 5.2992]], "...": "..."},
              "b": {"form": "bins", "soft": false, "dc": false, "ranges": [[64, 512]], "hz": [[5.3833, 43.0664]], "...": "..."}},
     "wav_b64": "...", "rate_db": ["..."]},
    {"a": [1, 2], "b": [5, 6, 7, 8], "weights": [0.7, 0.3], "keep": {"a": "...", "b": "..."}, "wav_b64": "...", "rate_db": ["..."]},
    {"a": {"hz": [[4, 8]]}, "b": [], "weights": [1.0], "zoom": 0.2,
     "keep": {"a": {"form": "hz", "soft": false, "dc": true, "ranges": [[48, 95]], "hz": [[4.0375, 7.9908]], "...": "..."}},
     "wav_b64": "...", "rate_db": ["..."]}
  ],
  "clip_a": {"ref_wav_b64": "...", "band_energy_db": [-3.1, -9.8, -7.2, -5.0, -11.4, -14.9, -20.3, -27.6],
             "rate_db": ["..."], "bpm": 120.0, "beat_band": 4, "sixteenth_band": 6},
  "clip_b": {"...": "when B was sent"},
  "render_s": 12.3
}
```

Top level:

| field | type | meaning |
|---|---|---|
| `api` | 2 | the API version of the worker |
| `model`, `model_info` | | the model used and its facts (see `op: "info"`) |
| `channels` | 1 or 2 | audio channels of every audio field |
| `sr` | 22050 | sample rate of every audio field |
| `format` | wav or flac | encoding of every audio field |
| `seconds` | number | the selection as rendered (after clipping to the limits), rounded to ms |
| `window_s`, `windows` | | one model window in seconds, and how many were stitched |
| `steps`, `seed` | | as applied (steps after clipping) |
| `n_bins`, `bin_hz` | 513, 0.084114 | the rate axis |
| `bands` | list of 8 | the band table above, in bins and Hz |
| `rate_hz` | list | the centre frequency in Hz of each `rate_db` column |
| `renders` | list | one per request render, in order |
| `clip_a`, `clip_b` | object | per clip; `clip_b` only when B was sent |
| `latents_window` | `"first"` | present only with `return_latents`: the latents describe the first model window of the selection |
| `render_s` | number | seconds the worker spent on the whole request |

Each render:

| field | type | meaning |
|---|---|---|
| `a`, `b` | | the request's specs echoed; `[]` when absent. A `{"bands": [...]}` dict with nothing else is echoed as the plain list |
| `weights` | list | the normalised weights, one per condition, rounded to 4 decimals. For a `zoom` render this is `[1.0]` (the zoom condition is not listed here) |
| `zoom` | number | only when the request had it |
| `keep` | object | per clip (`a`, `b`) what the service applied after the dc rule, see below |
| `wav_b64` | string | the output, `seconds` long, `channels` wide, in `format` |
| `rate_db` | 80 x N | with `rate_detail` columns or bins: the output's rate spectrum, see *Rate pictures* |
| `rate_db_bins` | C x 513 | with `rate_detail: "bins"` only |
| `latent_cond` | list of latents | with `return_latents`: the conditioning latents the decoder was given, masked, one per condition, in the order `a`, `b`; a `zoom` render has two (the masked latent, then the whole one) |
| `latent_out` | latent | with `return_latents`: the output re-encoded by the model's encoder |

`keep.a` / `keep.b`:

| field | type | meaning |
|---|---|---|
| `form` | bands, bins, hz, mask | the form of the spec as sent |
| `soft` | boolean | any gain strictly between 0 and 1, or per-channel differences |
| `dc` | boolean | whether bin 0 ended up with any gain |
| `ranges` | list of `[lo, hi]` bin pairs | the kept bins as inclusive runs, for a binary mask; `null` for a soft mask |
| `hz` | list of `[lo, hi]` Hz pairs | `ranges` in Hz (bin centres, 4 decimals); `null` for a soft mask |
| `support`, `support_hz` | runs | every bin with any gain > 0 |
| `full`, `full_hz` | runs | the bins kept at gain 1 (>= 0.999). For a binary mask `ranges`, `support` and `full` agree; for a soft mask they show where the roll-off lives |
| `bins_kept` | integer | bins with any gain, of 513 (bin 0 included when kept) |

For a 2-D mask the runs are computed on the per-bin maximum over channels.

`clip_a` / `clip_b`:

| field | type | meaning |
|---|---|---|
| `ref_wav_b64` | string or `null` | the selection through mel + vocoder only, no model; `null` when `include_ref` is false |
| `latent` | latent | with `return_latents`: the clip's input latent, first window |
| `band_energy_db` | 8 numbers | the share of the clip's non-DC latent energy in each band, dB (all <= 0; a band with everything is 0), averaged over windows |
| `rate_db`, `rate_db_bins` | | the clip's own rate spectrum, per `rate_detail` |
| `bpm` | number or `null` | `bpm_a` if it was given and in 40..240, else the estimate |
| `beat_band`, `sixteenth_band` | 1..8 or `null` | the band holding `bpm / 60` Hz and `bpm / 15` Hz |

**Rate pictures.** `rate_db` is the output's power spectrum along the rate axis, in dB relative to one reference
for the whole response (the loudest column of the clips' own reference spectra, bins 1 and up), clipped to -80 .. 0
and rounded to 0.1 dB. Rows are latent channels: 80 rows, and for the 160-channel stereo model consecutive pairs of
channels are averaged into one row. Columns are log-spaced groups of bins from bin 1 up; the service asks for 64
but merges the ones that round to the same bins at the low end, so a 513-bin model has **49 columns**. Count
`rate_hz`, do not assume 64. Bin 0 is never in the picture. `rate_db_bins` is the unmerged C x 513 table on the same
dB scale.

**Latents** on the wire are `{"b64": "<float32 little-endian, row-major>", "shape": [C, 512], "dtype": "float32"}`.

## `op: "encode"`

One model window -> its latent, for you to manipulate.

```json
{"op": "encode", "model": "mono", "audio_b64": "...", "start_s": 0.0,
 "include_ref": true, "rate_detail": "columns", "format": "flac"}
```

`audio_b64` is required; `start_s` cuts the clip, which is then tiled or cut to exactly one window. `seconds`,
`seed`, `steps`, `renders` are ignored; `format` applies to the reference. Response:

```json
{"api": 2, "op": "encode", "model": "mono", "model_info": {"...": "..."}, "sr": 22050, "window_s": 5.9443,
 "latent": {"b64": "<float32 little-endian>", "shape": [80, 512], "dtype": "float32"},
 "rate_hz": ["..."], "band_energy_db": ["8 numbers"], "rate_db": ["80 x 49"],
 "ref_wav_b64": "...", "render_s": 0.4}
```

`rate_db` / `rate_db_bins` follow `rate_detail`, here relative to this clip's own loudest column. `ref_wav_b64` is
present when `include_ref` is true.

The latent is in the time domain (C x 512). Its rate spectrum is `rfft(z, n=model_info.n_fft, axis=-1)`
(`n_fft` = 1024 -> 513 bins) and the way back is `irfft(Z, n=n_fft)[..., :512]`. Masking a latent yourself this way
and sending it to `decode` is exactly what `render` does with a keep-spec, apart from the dc rule, which is yours to
apply.

## `op: "decode"`

Latents you made -> audio, all from one seed's noise.

```json
{"op": "decode", "model": "mono", "seed": 0, "steps": 35, "format": "flac", "rate_detail": "columns",
 "renders": [
   {"conds": [{"b64": "...", "shape": [80, 512], "dtype": "float32"}]},
   {"conds": [{"b64": "..."}, {"b64": "..."}], "weights": [0.5, 0.5]},
   {"b64": "...", "shape": [80, 512]},
   "<a bare base64 string is a one-condition render too>"
 ]}
```

| field | type | default | meaning |
|---|---|---|---|
| `renders` | list, 1 .. 48 | required | each item is `{"conds": [...], "weights": [...]}`, or a single latent (dict or bare base64 string) meaning one condition |
| `renders[].conds` | list of 1 .. 4 latents | | the conditions the sampler follows together |
| `renders[].weights` | list | equal | one non-negative number per condition, sum > 0, normalised by the service |
| a latent | `{"b64", "shape"?, "dtype"?}` or string | | `dtype` is `float32` (default) or `float16`, little-endian; the value count must be exactly `latent_channels x frames` of the model (80 x 512 or 160 x 512). `shape` is **not** checked, only the count; non-finite values are a 400 |
| `model`, `seed`, `steps`, `batch`, `format`, `rate_detail` | | as for render | |

No audio is sent, so the hub does not require `audio_b64` here. Response:

```json
{"api": 2, "op": "decode", "model": "mono", "model_info": {"...": "..."}, "channels": 1, "sr": 22050, "format": "flac",
 "seconds": 5.944, "window_s": 5.944, "steps": 35, "seed": 0, "rate_hz": ["..."],
 "renders": [{"weights": [1.0], "wav_b64": "...", "rate_db": ["..."]},
             {"weights": [0.5, 0.5], "wav_b64": "...", "rate_db": ["..."]}],
 "render_s": 2.1}
```

Each render carries `weights`, `wav_b64` and the rate pictures per `rate_detail` (dB here relative to the loudest
output column, since there is no clip to refer to). There is no `keep`, no `a` / `b` and no `clip_a`. Every output
is exactly one window long.

## `op: "info"`

`{"op": "info"}` -> `{"api": 2, "models": [model_info, ...]}`: the models held by the worker that answered. On the
hub the request is routed like any other, by its `model` field (default `mono`), so you see the models of *one*
worker holding that model; `GET /latentft/models` is the hub-wide list. A `model_info`:

```json
{"name": "stereo", "label": "Stereo · stereo-v1 (L|R fine-tune)", "channels": 2,
 "latent_channels": 160, "frames": 512, "frame_rate": 86.1328, "window_s": 5.9443,
 "n_fft": 1024, "n_bins": 513, "bin_hz": 0.084114, "max_hz": 43.0664,
 "encoder": "mlp", "encoder_class": "PointwiseNet", "fp32": false, "bands": ["the band table"]}
```

| field | meaning |
|---|---|
| `name`, `label` | the name you send as `model`, and a label for menus |
| `channels` | audio channels in and out (2 for the stereo model, which takes [L\|R] as one latent) |
| `latent_channels`, `frames` | the latent's shape C x T (80 x 512 mono, 160 x 512 stereo) |
| `frame_rate` | latent frames per second (86.13) |
| `window_s` | one model window in seconds (5.9443) |
| `n_fft`, `n_bins`, `bin_hz`, `max_hz` | the rate axis: 1024-point rfft -> 513 bins, 0.084114 Hz apart, up to 43.0664 Hz |
| `encoder`, `encoder_class` | `mlp` (PointwiseNet) or `unet` |
| `fp32` | whether the model runs without fp16 autocast (the U-Net does; it overflows in fp16) |
| `bands` | the 8-band table for this axis |

## `GET /latentft/models`

Two different bodies, depending on who answers.

The **hub** returns its catalogue with online flags, no token needed:

```json
{"api": 2, "kinds_online": ["flowedit", "latentft"],
 "models": [
   {"name": "mono", "label": "Mono · paper model (MLP encoder)", "channels": 1, "encoder": "mlp",
    "note": "Mason Wang's ICLR checkpoint, step 660k; stereo input is downmixed", "online": true, "workers": ["mobile01-latentft"]},
   {"name": "stereo", "label": "Stereo · stereo-v1 (L|R fine-tune)", "channels": 2, "encoder": "mlp", "note": "...", "online": true, "workers": ["mobile01-latentft"]},
   {"name": "unet", "label": "Mono · paper U-Net encoder", "channels": 1, "encoder": "unet", "note": "...", "online": false, "workers": []}
 ]}
```

`api` is 2 when a worker announces `lft-api:2`, 1 when only older workers are up, `null` with no worker. A model a
worker holds that is not in the catalogue is listed after it with its name as label. The hub's rows do **not** carry
the axis (`n_bins`, `bin_hz`, `window_s`, `latent_channels`): for those use `op: "info"` or the `model_info` of any
response.

The **standalone server** returns `{"api": 2, "models": [{...model_info, "online": true}, ...]}`: full `model_info`
per model, all online.

## Other hub routes

`GET /health` (no token): `{"ok": true, "active_workers": 1, "pending": 0, "workers": [...], "kinds_online":
["latentft", ...], "running": 0, "done": 1234, "failed": 2, "held_mb": 0, "budget_mb": 768, "typical_render_s":
14.0, "uptime_s": 86400, "latentft_cache": {"version": "2026-10-15", "entries": 410, "mb": 1200.5, "cap_gb": 50.0,
"hits": 88, "misses": 410, "shared": 3, "history_volume_free_gb": 40.2, "history_volume_used_pct": 19.5}, ...}`.
`latentft_cache` is `null` when the cache is off. The standalone server's `/health` is `{"ok": true, "kinds_online":
["latentft"], "api": 2, "models": ["mono", ...], "busy": false, "uptime_s": 120}`.

`GET /whoami` (token): `{"ok": true, "label": "<name or token label>", "personal": true|false}`; 401
`{"detail": "unknown token"}` otherwise. The token is never echoed.

`GET /queue`: `{"pending": [{"position": 1, "kind": "latentft", "waiting_s": 4, "eta_s": 30}], "running":
[{"worker": "...", "elapsed_s": 12}], "workers": [{"name", "idle_s", "jobs_done", "busy", "kinds", "model",
"features"}], "active_workers", "kinds_online", "typical_render_s", "done", "failed", "held_mb", "budget_mb", ...}`.
With a valid token each pending and running item also carries `id`, `label` and `client`.

`GET /latentft/history?limit=50&offset=0` (personal token; `limit` 1..200): `{"total": 12, "offset": 0, "count":
12, "results": [{"label": "<your name>", "job": "<job id>", "time": 1760900000.0, "cache": "rendered"|"hit",
"worker": "...", "render_s": 12.3, "op": "render", "model": "mono", "seed": 0, "seconds": 5.944, "steps": 35,
"format": "flac", "rate_detail": "columns", "return_latents": true, "bpm_a": 120, "renders": 5, "two_clips": false,
"tab": "...", "title_a": "...", "title_b": "...", "a_start": 0.0, "b_start": 0.0}, ...]}`, newest first. The small
fields are peeked out of the request body by regex (`renders` counts `"a":` keys, or `"conds":` for a decode) and
the titles come from `X-LatentFT-Meta`. A class token gets 401 `{"detail": "history needs a personal token (your
sign-in link)"}`; a hub without history configured answers 404.

`GET /latentft/history/{job}/request` and `.../result` return the saved request and response bodies verbatim
(`application/json`), 404 for another user's job or an unknown one.

## Errors

A client error is a JSON body with the message under `error` (from the worker or the standalone server) or
`detail` (from the hub's own checks); read whichever is present. The message is written to be shown to the person.

| status | body | from | when |
|---|---|---|---|
| 400 | `{"error": "bad request: render 2: hz ranges are within 0..43.07 Hz with lo <= hi, got [50, 60]"}` | worker | anything wrong in the body: the message names the render index and the field. Also `bad request: send 1 to 48 renders`, `bad request: missing audio_b64 (clip A)`, `bad request: 48 renders x 6 windows is more than 400; shorten the selection or ask for fewer renders`, `bad request: model must be one of ['mono', 'stereo'], got 'x'`, `bad request: op must be render, encode, decode or info`, `bad request: rate_detail is columns (default), bins or none`, `bad request: audio could not be decoded (LibsndfileError); send WAV, FLAC or OGG as base64` |
| 400 | `{"error": "body is not JSON"}` | worker | |
| 400 | `{"detail": "body must be a JSON object"}`, `{"detail": "missing field: audio_b64"}` | hub | before queueing: a render or encode without `audio_b64` |
| 401 | `{"detail": "missing or unknown token: pass --token (or Authorization: Bearer ...)"}` | hub | no or unknown token |
| 401 | `{"error": "missing or wrong token: send Authorization: Bearer <token>"}` | standalone | |
| 404 | `{"error": "no such route /x; this server has POST /latentft, GET /latentft/models, GET /health"}` | standalone | |
| 413 | `{"detail": "audio_b64 is 40000 KB; limit 32768 KB"}` | hub | clip A's base64 over 32 MB |
| 413 | an nginx HTML page, not JSON | nginx | the whole body over 64 MB |
| 413 | `{"error": "body must be 1 byte to 64 MB of JSON"}` | standalone | |
| 500 | `{"error": "render failed: RuntimeError: ..."}` | worker | an unexpected failure in the engine; the worker survives |
| 503 | `{"detail": "no LatentFT worker online holds model 'unet' right now (online: mono, stereo)"}` | hub | the requested model is not online |
| 503 | `{"detail": "no latentft worker is online right now (GPU workers: none)"}` | hub | no LatentFT GPU at all |
| 503 | `{"detail": "queue is full (64 waiting); try again in a minute"}` | hub | |
| 503 | `{"detail": "hub memory budget is full (700 MB held, 12 waiting); try again in a minute"}` | hub | the results in flight would exceed the hub's 768 MB |
| 503 | `{"error": "the GPU is out of memory right now; try again in a minute"}` | worker | after one retry at `batch` 2 |
| 504 | `{"error": "timed out waiting for the render"}` or `{"error": "timed out waiting in queue"}` | hub | the client waited 45 min (`FLOWEDIT_JOB_TIMEOUT_S`) |
| 504 | `{"error": "worker mobile01-latentft did not return a result within 1800s"}` | hub | the worker went silent mid-job |

Clipping is not an error: `steps`, `batch` and `seconds` outside their ranges are brought into range silently and the
response reports the applied values. The Python client raises `RuntimeError("the service said 400: bad request: ...")`
with the message from either key.

## Cache (hub only)

A render is a pure function of its request, so the hub keeps a shared result cache on disk (`latentft_store.py`),
configured by `FLOWEDIT_LATENTFT_CACHE` and `FLOWEDIT_LATENTFT_HISTORY` (both must be set; the class hub has them).

- The key is `sha256(FLOWEDIT_LATENTFT_VERSION + "\0" + body)` over the **raw request bytes**. Only a byte-identical
  body hits: the same JSON key order, whitespace, number formatting and the same base64 audio. A header never changes
  the key. `seed`, `bpm_a`, `rate_detail`, `include_ref` and `format` are part of the body, so changing any of them
  is a miss even though the GPU work would be the same.
- `X-FlowEdit-Cache: hit`: served from disk, no GPU, no queue; `X-FlowEdit-Worker: cache`, `Queued-S` and
  `Render-S` are `0.0`, there is no `X-FlowEdit-Job`. The body is the original worker response verbatim, so its
  `render_s` is the original render's time. A hit still needs a valid token (401 otherwise).
- `X-FlowEdit-Cache: shared`: an identical request was already queued or rendering; yours waited for that one and got
  the same bytes.
- `X-FlowEdit-Cache: miss`: rendered for you, then stored. Only successful responses (2xx whose body does not start
  with `{"error"`) are stored.
- Capacity `FLOWEDIT_LATENTFT_CACHE_GB` (50 GB), least recently used results evicted first; a hit refreshes an entry.
- `FLOWEDIT_LATENTFT_VERSION` (`2026-10-15` today) names the worker and weights generation. Operators bump it
  whenever the rendered audio changes, so old results stop matching. API v2 was verified bit-identical to v1 on a
  saved request, so it was not bumped for v2.
- With a personal token every request, hit or rendered, is recorded in your history (`/latentft/history`); a class
  token leaves no history.

## Model routing (hub)

A worker announces the models it holds as features `lft:mono`, `lft:stereo`, `lft:unet`, plus `lft-api:2`. The hub
reads `model` out of the request body (default `mono`), and hands the job only to a worker with `lft:<model>`; when
none is online it answers 503 naming the online ones, before queueing. `op: "info"` and `op: "decode"` are routed
the same way by their `model`. A worker from before per-model announcement (none today) counts as holding
`mono` and `stereo`. Several workers may hold the same model; the oldest pending job goes to the first free worker
that has what it needs.

## curl

```sh
TOKEN=...   # your class or personal token
A=$(base64 < loop.wav | tr -d '\n')
cat > req.json <<EOF
{"model": "mono", "audio_b64": "$A", "seconds": 5.944, "seed": 0, "steps": 35, "format": "wav",
 "renders": [{"a": [1, 2, 3, 4]}, {"a": {"hz": [[1.3, 2.7]]}}, {"a": {"bands": [5, 6], "dc": false}}]}
EOF
curl -sS -D headers.txt -H "Authorization: Bearer $TOKEN" -H "Content-Type: application/json" \
     -H "X-FlowEdit-Client: curl" --data-binary @req.json https://latentft.csail.mit.edu/latentft > res.json
grep -i x-flowedit headers.txt
python3 -c 'import json,base64,sys; d=json.load(open("res.json"))
for i,r in enumerate(d["renders"]):
    open(f"render_{i}.wav","wb").write(base64.b64decode(r["wav_b64"])); print(i, r["keep"])
open("ref_a.wav","wb").write(base64.b64decode(d["clip_a"]["ref_wav_b64"]))'
```

Discovery without a token:

```sh
curl -sS https://latentft.csail.mit.edu/latentft/models
curl -sS https://latentft.csail.mit.edu/health | python3 -m json.tool
```

Against your own server, replace the host with `http://127.0.0.1:8765` and the token with the one from
`--token` (or drop the header when it was started without one).

## Self-hosting

`demo/latentft_server.py` serves the same `POST /latentft`, `GET /latentft/models` and `GET /health` on one GPU with
no hub, no queue and no worker: renders are serialised with a lock. `engaging/README.md` has the recipe for MIT's
Engaging cluster (a server in a SLURM job plus an ssh tunnel, or Jupyter on the GPU node with the models loaded in
process) and the weights policy. The Python client takes `hub="http://127.0.0.1:8765"`, or
`LatentFT.in_process({...})` to skip HTTP altogether.

## What changed from v1

Requests from the first version (bands only, `model` mono or stereo) are unchanged and give the same audio
(bit-identical on a saved request). New in v2:

- keep-specs beyond bands: `bins`, `hz`, `mask` (soft and per-channel), and an explicit `dc`;
- `weights` on a blend and the paper's `zoom`;
- `op: "encode"`, `op: "decode"` and `op: "info"`; `return_latents` on a render;
- `rate_detail` (`bins` for the full-resolution picture, `none` to skip it);
- the `unet` model, and per-model routing on the hub (`lft:NAME` features, 503 naming what is online);
- in the response: `api`, `model_info`, `keep`, `weights`, `n_bins`, `bin_hz`, `zoom`, `latents_window`;
- `GET /latentft/models` with online flags and holders; `GET /latentft/history` for personal tokens.

## Gotchas

- `rate_db` has **49** columns for the 513-bin models, not 64: the log spacing is computed for 64 and the duplicate
  low-end columns are merged. `rate_hz` has one entry per column; use its length.
- Two shapes of `GET /latentft/models`: the hub's rows have no axis fields; the standalone server's are full
  `model_info`. The client's `models()` returns whichever it gets.
- `op: "info"` through the hub is never cached and goes to any online LatentFT worker (since 2026-10-19); it still
  costs a queue slot, so `GET /latentft/models` is the cheaper way to ask what is online.
- The dc rule means `[5, 6]` alone keeps bin 0 but `{"a": [5, 6], "b": [1, 2]}` gives bin 0 to B only. Say `dc`
  explicitly when it matters.
- `mask` gains are clipped to 0..1 without a warning; a gain of 2 is 1.
- A clip shorter than the selection is looped, not padded. With no `seconds`, a 2-s loop renders as 5.944 s.
- `seconds` below one window is raised, above 30 is cut, with no error; read `seconds` and `windows` back.
- A decode latent's `shape`, when given, must equal the model's `[latent_channels, frames]` (checked since
  2026-10-19; a transposed array is a 400). Without `shape`, only the number of values is checked.
- `latent_cond` of a `zoom` render has two entries (masked, then whole); its `weights` echo is `[1.0]`.
- The hub's 32 MB per-clip limit applies to `audio_b64` and to `audio_b64_b` (both 413 above it); the 64 MB body
  limit is nginx's ceiling for the whole request.
- `format` is `flac` only when it is exactly `"flac"`; `"FLAC"` or `"mp3"` give WAV.
- A cache hit's `render_s` is the original render's, and a hit still counts a `/latentft/history` entry for a
  personal token.
- The Python client waits 2800 s for a response, just past the hub's own 2700 s 504, and retries a connection-level
  failure (TLS damage, broken pipe, reset) up to 3 times; a retried finished render is a cache hit.
