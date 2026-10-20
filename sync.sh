#!/bin/sh
# Pull the student-facing pieces from the lab repo into this one. Source of truth stays in HAI-Res/latentft-post-training
# (model code, worker, studies); this repo carries only what students need, with no weights and no secrets.
set -eu
here="$(cd "$(dirname "$0")" && pwd)"; M="${MODEL_REPO:-$here/../latentft-post-training}"
P="$here/2-render-in-python"
mkdir -p "$P/python/src/latentft_lab" "$P/notebook" "$P/docs" "$P/own-gpu-engaging" "$here/3-play-in-max"
cp "$M/demo/latentft_client.py" "$M/demo/latentft_viz.py" "$P/python/src/"
cp "$M/pkg/pyproject.toml" "$P/python/pyproject.toml"; cp "$M/pkg/README.md" "$P/python/README.md"
cp "$M/demo/LatentFT_lab.ipynb" "$P/notebook/"
cp "$M/docs/API.md" "$M/docs/CLIENT.md" "$P/docs/"
cp "$M/engaging/README.md" "$M/engaging/setup.sh" "$M/engaging/latentft_server.sbatch" "$M/engaging/WEIGHTS.md" "$P/own-gpu-engaging/"
cp "$M/max/build_crossfader.py" "$M/max/latentft_crossfader.maxpat" "$M/max/README.md" "$here/3-play-in-max/"
echo "synced from $M"
