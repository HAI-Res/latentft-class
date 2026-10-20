"""Pictures for LatentFT results (matplotlib + librosa), shared by the lab notebook and the listening studies.

    from latentft_viz import show, show_all, describe, onset_peaks, soft_band, soft_octave, xfade_sweep, sweep_figure
    res = lf.render(a, sr, renders, ..., return_latents=True)      # latents are needed for the latent panels
    show_all(res, marks=onset_peaks(a, sr))                         # per render: words, player, five panels

The five panels of a render: the mask as a graph over the rate axis (gain per bin, log Hz); the clip's latent
(channels x time, first model window); the latent the decoder was given (masked along time); the output's latent
(re-encoded); the output's spectrogram. One colour scale for all latents of a result, so renders compare.
"""
from __future__ import annotations

import numpy as np

SR = 22050
BIN_HZ = (SR / 256) / 1024
N_BINS = 513
F = np.arange(N_BINS) * BIN_HZ
FRAME_RATE = SR / 256


# ----------------------------------------------------------------------------- masks and pieces
def soft_band(f0: float, width_hz: float) -> np.ndarray:
    """Raised cosine centred on f0: gain 1 at f0, 0 at f0 +- width/2 (linear Hz). 513 gains."""
    d = np.abs(F - f0) / (width_hz / 2)
    return np.where(d < 1, 0.5 + 0.5 * np.cos(np.pi * d), 0.0)


def soft_octave(fc: float, octaves: float = 1.0) -> np.ndarray:
    """Raised cosine in log frequency: gain 1 at fc, 0 at fc * 2^(+-octaves/2). Bin 0 is 0 (the service's dc rule decides)."""
    with np.errstate(divide="ignore", invalid="ignore"):      # bin 0 is log2(0) = -inf; masked out just below
        d = np.abs(np.log2(F / fc)) / (octaves / 2)
        g = np.where(d < 1, 0.5 + 0.5 * np.cos(np.pi * d), 0.0)
    g[0] = 0.0
    return g


def xfade_sweep(renders: list[np.ndarray], passes: list[bool] = (True,), repeats: int = 1) -> np.ndarray:
    """A piece: per pass the clip plays `repeats` times while the active render moves linearly through the list
    (True = up, False = down), equal-power crossfade between neighbours. Renders must share the seed (they do
    within one call). Longer passes: render a longer selection (up to 30 s) or raise `repeats`."""
    if repeats > 1:
        renders = [np.tile(r, (repeats, 1)) for r in renders]
    K, n = len(renders), len(renders[0])
    out = []
    for up in passes:
        pos = np.linspace(0, K - 1, n) if up else np.linspace(K - 1, 0, n)
        i0 = np.clip(np.floor(pos).astype(int), 0, K - 1)
        i1 = np.clip(i0 + 1, 0, K - 1)
        frac = (pos - i0)[:, None]
        g1, g0 = np.sin(frac * np.pi / 2), np.cos(frac * np.pi / 2)
        seg = np.zeros_like(renders[0])
        for k in range(K):
            seg += renders[k] * (g0 * (i0 == k)[:, None] + g1 * (i1 == k)[:, None])
        out.append(seg)
    return np.concatenate(out, 0)


def random_soft_mask(seed: int, corr_octaves: float = 0.35, sharpness: float = 2.0) -> np.ndarray:
    """A random gain per rate bin, fixed for the whole render: Gaussian noise correlated along log frequency
    (kernel width `corr_octaves`), squashed through a sigmoid (`sharpness`: higher = closer to 0/1). This is the
    soft cousin of the paper's training masks, which threshold such correlated noise to 0/1. Bin 0 is 1."""
    rng = np.random.default_rng(seed)
    logf = np.log2(F[1:])
    noise = rng.standard_normal(len(logf))
    k = np.exp(-0.5 * ((logf[:, None] - logf[None, :]) / corr_octaves) ** 2)
    scores = k @ noise / np.sqrt((k ** 2).sum(1))
    g = 1 / (1 + np.exp(-sharpness * scores))
    return np.concatenate([[1.0], g]).astype(np.float32)


def random_iid_mask(seed: int, binary: bool = False, p: float = 0.5) -> np.ndarray:
    """Every rate bin draws its own gain, independently of its neighbours: uniform 0..1 per bin (soft), or with
    `binary` a coin flip (1 with probability p, else 0), the hard version. Bin 0 is 1. The opposite of
    random_soft_mask, whose gains vary smoothly along the axis."""
    rng = np.random.default_rng(seed)
    g = (rng.random(N_BINS - 1) < p).astype(np.float32) if binary else rng.random(N_BINS - 1).astype(np.float32)
    return np.concatenate([[1.0], g]).astype(np.float32)


# ----------------------------------------------------------------------------- analysis
def onset_peaks(y: np.ndarray, sr: int) -> list[tuple[float, str]]:
    """The clip's strongest onset rates in three ranges (beat-ish, syllable-ish, strum-ish), to mark on the graphs."""
    import librosa
    y = np.asarray(y, dtype=np.float32)
    m = y.mean(1) if y.ndim == 2 else y
    o = librosa.onset.onset_strength(y=m, sr=sr, hop_length=512)
    fr = sr / 512
    O = np.abs(np.fft.rfft(o - o.mean(), n=8192))
    f = np.fft.rfftfreq(8192, 1 / fr)
    out = []
    for lo, hi, name in ((0.8, 1.8, "beat?"), (1.8, 3.6, "syllables?"), (3.6, 7.2, "strum?")):
        b = (f > lo) & (f < hi)
        out.append((float(f[np.argmax(O * b)]), name))
    return out


def describe(res, i: int) -> str:
    """One sentence saying what render i does, from the service's own account of what it applied."""
    parts = []
    for tag in ("a", "b"):
        k = res.keep(i, tag)
        if not k:
            continue
        clip = f"clip {tag.upper()}" if res.keep(i, "b") else "the clip"
        rng = k["hz"] if k["hz"] is not None else k["support_hz"]
        span = " and ".join(f"{lo:.2f}-{hi:.2f} Hz" for lo, hi in rng) if rng else "nothing"
        kept = k["bins_kept"]
        if k["soft"]:
            full = " and ".join(f"{lo:.2f}-{hi:.2f} Hz" for lo, hi in (k.get("full_hz") or [])) or "no bin"
            parts.append(f"from {clip}, keep a soft region over {span} ({kept} bins; full gain at {full}); the rest regenerated")
        elif kept >= N_BINS - 1:
            parts.append(f"keep every rate of {clip}: the plain reconstruction")
        elif kept > N_BINS // 2:
            erased = N_BINS - kept
            parts.append(f"from {clip}, erase {erased} bin{'s' if erased > 1 else ''} and keep the rest ({span})")
        else:
            parts.append(f"from {clip}, keep only {span} ({kept} bin{'s' if kept > 1 else ''}, hard edges); the rest regenerated")
    w = res.renders[i].get("weights")
    if w and len(w) == 2:
        parts.append(f"blend weights {w[0]:.2f} / {w[1]:.2f}")
    if res.renders[i].get("zoom") is not None:
        parts.append(f"zoom {res.renders[i]['zoom']}")
    return "; ".join(parts)


# ----------------------------------------------------------------------------- figures
def _need_latents(res):
    if "latent" not in (res.clip_a or {}):
        raise ValueError("this result has no latents: call render(..., return_latents=True)")


def render_figure(res, i: int, which: str = "a", marks=None, words: str | None = None, title: str | None = None, z_scale: float | None = None):
    """The five-panel picture of render i. Returns the matplotlib figure."""
    import librosa, librosa.display
    import matplotlib.pyplot as plt
    _need_latents(res)
    z_in = res.input_latent(which)
    tags = [t for t in ("a", "b") if res.keep(i, t) is not None]
    z_cond = res.latent_cond(i)[tags.index(which)] if which in tags else res.latent_cond(i)[0]
    z_out = res.latent_out(i)
    m = res.mask(i, which if which in tags else tags[0])
    audio = res.audio(i)
    v = z_scale or float(np.percentile(np.abs(z_in), 99))
    words = words if words is not None else describe(res, i)
    title = title if title is not None else f"render {i}: {res.label(i)}   ({res.model} model)"

    fig, ax = plt.subplots(5, 1, figsize=(12, 12.5), gridspec_kw={"height_ratios": [1.5, 1, 1, 1, 1.3]})
    fig.suptitle(title, fontsize=12, x=0.01, ha="left")
    # 1 mask
    a0 = ax[0]
    a0.fill_between(F[1:], 0, m[1:], step="mid", color="#2b6ea3", alpha=0.85, lw=0)
    a0.set_xscale("log"); a0.set_xlim(F[1], F[-1]); a0.set_ylim(0, 1.08)
    a0.set_ylabel("gain", fontsize=8); a0.set_yticks([0, 0.5, 1]); a0.tick_params(labelsize=7)
    a0.set_xlabel("rate along the latent's time axis (Hz, log)", fontsize=8)
    for hz, name in (marks or []):
        a0.axvline(hz, color="k", lw=0.6, ls=":"); a0.text(hz, 1.03, f"{name} {hz:.2f}", fontsize=6.5, ha="center", va="bottom")
    a0.text(0.01, 0.9, f"bin 0 (mean level/timbre) {'kept' if m[0] > 0 else 'erased'}", transform=a0.transAxes, fontsize=7)
    a0.set_title("mask: 1 = this rate of change is kept from the clip, 0 = erased and regenerated by the decoder; in between = kept faintly (soft)\n"
                 + words, fontsize=9, loc="left")
    # 2-4 latents
    def lat(a, z, t_):
        C = z.shape[0]
        t = np.arange(z.shape[1]) / FRAME_RATE
        a.pcolormesh(t, np.arange(C), z, cmap="RdBu_r", vmin=-v, vmax=v, shading="auto", rasterized=True)
        a.set_title(t_, fontsize=9, loc="left"); a.set_ylabel("latent channel" + (" (L 0-79, R 80-159)" if C == 160 else ""), fontsize=8)
        a.set_yticks([0, C // 2, C - 1]); a.tick_params(labelsize=7)
    lat(ax[1], z_in, f"the clip's latent ({z_in.shape[0]} channels x 5.94 s, first model window): what the encoder wrote down")
    lat(ax[2], z_cond, "what the decoder was given: the same latent with the mask applied along time")
    lat(ax[3], z_out, "the output, re-encoded: where the decoder kept movement and where it invented it")
    ax[3].set_xlabel("time (s)", fontsize=8)
    # 5 spectrogram
    y = audio[: int(5.944 * SR)]
    S = librosa.power_to_db(librosa.feature.melspectrogram(y=y.mean(1), sr=SR, n_mels=96, hop_length=256, fmax=11025), ref=np.max)
    librosa.display.specshow(S, sr=SR, hop_length=256, y_axis="mel", fmax=11025, ax=ax[4], cmap="magma", vmin=-70, vmax=0)
    ax[4].set_title("the output's spectrogram (same 5.94 s)", fontsize=9, loc="left"); ax[4].set_ylabel("Hz", fontsize=8)
    ax[4].tick_params(labelsize=7); ax[4].set_xlabel("time (s)", fontsize=8)
    fig.tight_layout(rect=(0, 0, 1, 0.97))
    return fig


def sweep_figure(audio: np.ndarray, centres, passes, marks=None, words: str = "", title: str = "", band: bool = True, model: str = "", octaves: float = 1.0):
    """The picture of a gliding-zone piece: the zone's position over time (blue = rates kept) and the spectrogram."""
    import librosa, librosa.display
    import matplotlib.pyplot as plt
    centres = np.asarray(centres, dtype=float)
    fig, ax = plt.subplots(2, 1, figsize=(12, 6.5), gridspec_kw={"height_ratios": [1, 1.3]})
    fig.suptitle(f"{title}   ({model} model)" if model else title, fontsize=12, x=0.01, ha="left")
    n = len(audio) / SR
    pos = np.concatenate([(np.linspace(0, 1, 400 // len(passes)) if up else 1 - np.linspace(0, 1, 400 // len(passes))) for up in passes])
    fc = np.exp(np.log(centres[0]) + pos * (np.log(centres[-1]) - np.log(centres[0])))
    half = 2 ** (octaves / 2)
    lo, hi = np.clip(fc / half, F[1], F[-1]), np.clip(fc * half, F[1], F[-1])
    tt = np.linspace(0, n, len(fc))
    if band:
        ax[0].fill_between(tt, lo, hi, color="#2b6ea3", alpha=0.6, lw=0)
    else:
        ax[0].fill_between(tt, lo, hi, color="#aaaaaa", alpha=0.6, lw=0)
        ax[0].fill_between(tt, F[1], lo, color="#2b6ea3", alpha=0.6, lw=0); ax[0].fill_between(tt, hi, F[-1], color="#2b6ea3", alpha=0.6, lw=0)
    ax[0].plot(tt, fc, color="k", lw=1)
    ax[0].set_yscale("log"); ax[0].set_ylim(F[1], F[-1]); ax[0].set_ylabel("rate (Hz, log)", fontsize=8); ax[0].tick_params(labelsize=7)
    for hz, nm in (marks or []):
        ax[0].axhline(hz, color="k", lw=0.6, ls=":"); ax[0].text(0.1, hz, f"{nm} {hz:.2f}", fontsize=6.5, va="bottom")
    ax[0].set_title(f"blue = rates kept over time (the {octaves:g}-octave zone glides; the music plays " + ("once" if len(passes) == 1 else f"{len(passes)} times") + ")\n" + words,
                    fontsize=9, loc="left")
    S = librosa.power_to_db(librosa.feature.melspectrogram(y=audio.mean(1), sr=SR, n_mels=96, hop_length=256, fmax=11025), ref=np.max)
    librosa.display.specshow(S, sr=SR, hop_length=256, y_axis="mel", fmax=11025, ax=ax[1], cmap="magma", vmin=-70, vmax=0)
    ax[1].set_title("the piece's spectrogram", fontsize=9, loc="left"); ax[1].set_ylabel("Hz", fontsize=8); ax[1].tick_params(labelsize=7); ax[1].set_xlabel("time (s)", fontsize=8)
    fig.tight_layout(rect=(0, 0, 1, 0.95))
    return fig


def mask_thumb(mask: np.ndarray, marks=None, figsize=(10, 1.3)):
    """A small strip of the mask alone (gain per rate bin, log Hz), to orient while scrolling a page."""
    import matplotlib.pyplot as plt
    fig, ax = plt.subplots(figsize=figsize)
    ax.fill_between(F[1:], 0, mask[1:], step="mid", color="#2b6ea3", alpha=0.9, lw=0)
    ax.set_xscale("log"); ax.set_xlim(F[1], F[-1]); ax.set_ylim(0, 1.05); ax.set_yticks([0, 1]); ax.tick_params(labelsize=7)
    for hz, name in (marks or []):
        ax.axvline(hz, color="k", lw=0.5, ls=":")
    ax.set_xticks([0.1, 0.5, 1, 2, 5, 10, 20, 40]); ax.set_xticklabels(["0.1", "0.5", "1", "2", "5", "10", "20", "40 Hz"])
    ax.text(0.005, 0.8, "kept", transform=ax.transAxes, fontsize=7, color="#2b6ea3"); ax.text(0.005, 0.1, "erased", transform=ax.transAxes, fontsize=7, color="#888")
    fig.tight_layout(pad=0.3)
    return fig


def glide_thumb(centres, passes, seconds: float, marks=None, band: bool = True, octaves: float = 1.0, figsize=(10, 1.6)):
    """A small strip of a glide's zone position over time (blue = kept rates)."""
    import matplotlib.pyplot as plt
    centres = np.asarray(centres, dtype=float)
    fig, ax = plt.subplots(figsize=figsize)
    n = seconds * len(passes)
    pos = np.concatenate([(np.linspace(0, 1, 200) if up else 1 - np.linspace(0, 1, 200)) for up in passes])
    fc = np.exp(np.log(centres[0]) + pos * (np.log(centres[-1]) - np.log(centres[0])))
    half = 2 ** (octaves / 2)
    lo, hi = np.clip(fc / half, F[1], F[-1]), np.clip(fc * half, F[1], F[-1])
    tt = np.linspace(0, n, len(fc))
    if band:
        ax.fill_between(tt, lo, hi, color="#2b6ea3", alpha=0.7, lw=0)
    else:
        ax.fill_between(tt, F[1], lo, color="#2b6ea3", alpha=0.7, lw=0); ax.fill_between(tt, hi, F[-1], color="#2b6ea3", alpha=0.7, lw=0)
    ax.set_yscale("log"); ax.set_ylim(F[1], F[-1]); ax.set_xlim(0, n); ax.tick_params(labelsize=7)
    ax.set_yticks([0.1, 1, 10]); ax.set_yticklabels(["0.1", "1", "10 Hz"]); ax.set_xlabel("time (s)", fontsize=7)
    for hz, name in (marks or []):
        ax.axhline(hz, color="k", lw=0.5, ls=":")
    fig.tight_layout(pad=0.3)
    return fig


# ----------------------------------------------------------------------------- in a notebook
def show(res, i: int, which: str = "a", marks=None, words: str | None = None, z_scale: float | None = None):
    """One render, the way the listening page shows it: the sentence, a player, the five panels."""
    from IPython.display import Audio, Markdown, display
    import matplotlib.pyplot as plt
    words = words if words is not None else describe(res, i)
    display(Markdown(f"**{i}: {res.label(i)}** — {words}"))
    display(Audio(res.audio(i).T, rate=res.sr))
    fig = render_figure(res, i, which=which, marks=marks, words=words, z_scale=z_scale)
    plt.show(); plt.close(fig)


def show_all(res, which: str = "a", marks=None, words: dict | list | None = None, indices=None):
    """Every render of a result in order (or `indices`). `words`: per-render sentences, list or {index: text}."""
    _need_latents(res)
    z_scale = float(np.percentile(np.abs(res.input_latent(which)), 99))   # one colour scale for the whole set
    for i in (indices if indices is not None else range(len(res))):
        w = (words[i] if isinstance(words, list) else words.get(i)) if words is not None else None
        show(res, i, which=which, marks=marks, words=w, z_scale=z_scale)
