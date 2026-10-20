#!/bin/bash
# LatentFT as a private HTTP service on one Engaging GPU, for one person. Speaks the class hub's POST /latentft
# (docs/API.md); reach it from your laptop through an ssh tunnel via the login node (engaging/README.md, Way 1).
#
#   sbatch engaging/latentft_server.sbatch                      # defaults below
#   WEIGHTS_DIR=/orcd/pool/.../latentft sbatch engaging/latentft_server.sbatch
#
# Untested on Engaging as of 2026-10-18 (partition and gres names from the ORCD docs; fix what differs).
#SBATCH --job-name=latentft-server
#SBATCH --partition=mit_normal_gpu
#SBATCH --gres=gpu:1
#SBATCH --cpus-per-task=4
#SBATCH --mem=32G
#SBATCH --time=04:00:00
#SBATCH --output=logs/%x-%j.out
set -euo pipefail
cd "$(dirname "$(scontrol show job "$SLURM_JOB_ID" | sed -n 's/.*Command=//p' | head -1)")/.." 2>/dev/null || cd "$SLURM_SUBMIT_DIR"
WEIGHTS_DIR="${WEIGHTS_DIR:-$(pwd)/weights}"
PORT="${PORT:-8765}"
export HF_HOME="${HF_HOME:-$(pwd)/.hf}" HF_HUB_OFFLINE=1 PYTHONUNBUFFERED=1 OMP_NUM_THREADS=4
# shellcheck disable=SC1091
source .venv/bin/activate

MODELS=()
[ -f "$WEIGHTS_DIR/latentft_mlp_5s_ema_fp32.pt" ]  && MODELS+=(--model "mono=$WEIGHTS_DIR/latentft_mlp_5s_ema_fp32.pt")
[ -f "$WEIGHTS_DIR/stereo_v1_ema_step250000.pt" ]  && MODELS+=(--model "stereo=$WEIGHTS_DIR/stereo_v1_ema_step250000.pt")
[ -f "$WEIGHTS_DIR/latentft_unet_5s_ema_fp32.pt" ] && MODELS+=(--model "unet=$WEIGHTS_DIR/latentft_unet_5s_ema_fp32.pt:fp32")
[ ${#MODELS[@]} -gt 0 ] || { echo "no weights found in $WEIGHTS_DIR (see engaging/WEIGHTS.md)" >&2; exit 1; }

TOKEN=$(python -c 'import secrets; print(secrets.token_urlsafe(18))')
umask 077; echo "$TOKEN" > "logs/latentft-server-$SLURM_JOB_ID.token"
echo "$(date -Is) job $SLURM_JOB_ID on $(hostname -s), GPU ${CUDA_VISIBLE_DEVICES:-?}, models: ${MODELS[*]}"
echo
echo "From your laptop:   ssh -L $PORT:$(hostname -s):$PORT $USER@orcd-login.mit.edu"
echo "In the notebook:    LatentFT(hub=\"http://127.0.0.1:$PORT\", token=\"$TOKEN\")"
echo "Token also in:      logs/latentft-server-$SLURM_JOB_ID.token"
echo
exec python demo/latentft_server.py "${MODELS[@]}" --host 0.0.0.0 --port "$PORT" --token "$TOKEN"
