# Weights for self-hosting

The checkpoints are Mason Wang's (paper models) and the lab's (stereo-v1), shared by Mason on 2026-09-21 for MIT
teaching and research. **Never put them anywhere public**, never in git, never on a shared filesystem path that is
world-readable. `CHECKPOINTS.md` at the repo root lists where each lives on the CSAIL volumes with checksums.

| file (what the job files expect) | model | size |
|---|---|---|
| `latentft_mlp_5s_ema_fp32.pt` | mono paper model (MLP encoder, step 660k, EMA) | 1.5 GB |
| `stereo_v1_ema_step250000.pt` | stereo-v1 (rename of `frozen/stereo-v1/ema_step250000.pt`) | 1.5 GB |
| `latentft_unet_5s_ema_fp32.pt` | paper U-Net-encoder model (step 658.5k, EMA) | 2.8 GB |

Put them in `weights/` at the repo root (git-ignored), or anywhere and pass `WEIGHTS_DIR=` to the job / the paths
to `LatentFT.in_process(...)`. Check them: `sha256sum weights/*.pt` against `CHECKPOINTS.md`.

## How students get them (decide once, per class)

The class service never hands the weights out: the notebook's `hub` mode calls the lab GPU. Self-hosting means each
student holds a copy, so this needs a decision by the instructor; the options, in order of least exposure:

1. **A shared, group-readable directory on Engaging.** If the class has an Engaging group / project space, the
   instructor copies the three files there once with mode 640 and the class Unix group. Students pass
   `WEIGHTS_DIR=/path/to/that`. Nothing is copied per student, access ends with the group.
2. **A private Hugging Face repo** (e.g. `HAI-Res/latentft-weights`) with read access granted per student. Works on
   Engaging, Colab and laptops: `hf download HAI-Res/latentft-weights --local-dir weights` with the student's token.
   Copies do leave the lab; access can be revoked but copies cannot.
3. **Direct transfer** from a lab machine to the student's Engaging scratch (scp), case by case.

Whichever is chosen, tell Mason how the weights are being used (the README's standing note).
