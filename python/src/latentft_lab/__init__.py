"""latentft-lab: the LatentFT class service from Python. Docs: https://latentft.csail.mit.edu/notebook/client.html"""
from latentft_client import *          # noqa: F401,F403
from latentft_client import LatentFT, Result, Encoded, keep, lowpass, highpass, soft_lowpass, ALL, SR, WINDOW_S, BIN_HZ  # noqa: F401
try:
    from latentft_viz import (soft_band, soft_octave, random_soft_mask, random_iid_mask, xfade_sweep, onset_peaks,  # noqa: F401
                              describe, show, show_all, render_figure, sweep_figure, mask_thumb, glide_thumb)
except ImportError:                    # matplotlib / librosa not installed: the client still works
    pass
