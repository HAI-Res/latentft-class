#!/bin/bash
# One-time environment for LatentFT on Engaging (or any Linux box with a CUDA GPU). Run from the repo root on a
# login node. Makes ./.venv with uv, installs torch + the released latentft package (which brings Mason's BigVGAN
# fork), librosa/soundfile/hydra, Jupyter kernel support; pre-fetches the BigVGAN vocoder into $HF_HOME.
# Untested on Engaging as of 2026-10-18: fix and commit what differs.
set -euo pipefail
cd "$(dirname "$0")/.."
echo "repo: $(pwd)"
[ -f third_party/latentft/setup.py ] || git submodule update --init third_party/latentft

if ! command -v uv >/dev/null; then
  echo "installing uv into ~/.local/bin"
  curl -LsSf https://astral.sh/uv/install.sh | sh
  export PATH="$HOME/.local/bin:$PATH"
fi

export HF_HOME="${HF_HOME:-$(pwd)/.hf}"       # the vocoder cache; set HF_HOME before running jobs too
mkdir -p "$HF_HOME" logs

uv venv --python 3.11 .venv
# shellcheck disable=SC1091
source .venv/bin/activate
uv pip install --upgrade pip
uv pip install torch torchaudio                              # CUDA 12 wheels from PyPI; the L40S/H200 drivers are recent
uv pip install -e ./third_party/latentft                      # latentft + bigvgan fork + lightning/hydra/webdataset ...
uv pip install librosa soundfile numpy hydra-core omegaconf ipykernel jupyter matplotlib huggingface_hub

python - <<'PY'
# pre-fetch the vocoder (public, ~0.9 GB) so a compute node without internet can still load it
from huggingface_hub import snapshot_download
p = snapshot_download("nvidia/bigvgan_v2_22khz_80band_256x", allow_patterns=["*.json", "*.pt", "*.py", "*.md"])
print("vocoder cached at", p)
PY

python -m ipykernel install --user --name latentft --display-name "LatentFT (Engaging)" \
  --env HF_HOME "$HF_HOME" --env HF_HUB_OFFLINE 1 --env PYTHONPATH "$(pwd)/demo:$(pwd)/colab"
echo
echo "done. Next: put the weights in place (engaging/WEIGHTS.md), then either"
echo "  sbatch engaging/latentft_server.sbatch        (a server in a job + ssh tunnel)"
echo "  or start Jupyter at https://orcd-ood.mit.edu on mit_normal_gpu and pick the 'LatentFT (Engaging)' kernel"
