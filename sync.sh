#!/bin/sh
# Pull the student-facing pieces from the lab repos into this one. Source of truth stays in HAI-Res/latentft-post-training
# (model code, worker, studies); this repo carries only what students need, with no weights and no secrets.
set -eu
here="$(cd "$(dirname "$0")" && pwd)"; M="${MODEL_REPO:-$here/../latentft-post-training}"
mkdir -p "$here/python/src/latentft_lab" "$here/notebook" "$here/docs" "$here/max/latentft-crossfader" "$here/engaging"
cp "$M/demo/latentft_client.py" "$M/demo/latentft_viz.py" "$here/python/src/"
cp "$M/pkg/pyproject.toml" "$here/python/pyproject.toml"; cp "$M/pkg/README.md" "$here/python/README.md"
cp "$M/demo/LatentFT_lab.ipynb" "$here/notebook/"
cp "$M/docs/API.md" "$M/docs/CLIENT.md" "$here/docs/"
cp "$M/max/build_crossfader.py" "$M/max/latentft_crossfader.maxpat" "$M/max/README.md" "$here/max/latentft-crossfader/"
cp "$M/engaging/README.md" "$M/engaging/setup.sh" "$M/engaging/latentft_server.sbatch" "$M/engaging/WEIGHTS.md" "$here/engaging/"
echo "synced from $M"
