# LatentFT class: 1 a sensor into Max → 2 renders from Python → 3 play them in Max

Three pieces, in order. The LatentFT service (GPU, models, weights) runs on the lab's machines behind
https://latentft.csail.mit.edu; nothing in this repo needs a GPU or the model weights.

## 1 · A sensor into Max — `1-sensor-into-max/`
Sabrina's MUGIC example. The MUGIC sensor (an IMU) sends its readings as OSC over UDP, port 4000.
- `MUGIC_SETUP.pdf`: setting the sensor up.
- `mugic_receive.maxpat`: receives the data and rebroadcasts it inside Max; open it first and leave it open.
- `mugic_examples.maxpat`: tilt moves a slider; tilt changes a pitch.
- `mugic_capture.py`: prints the live readings, or records them to CSV (`uv run mugic_capture.py take1.csv`).

The outcome of part 1 is a number between 0 and 1 that follows your movement.

## 2 · Render a slew of files in Python — `2-render-in-python/`
- `notebook/LatentFT_lab.ipynb`: the lab notebook. The rate axis, masks bin by bin, blends, the latent itself, and
  in **section 8** a bulk render: a grid of masks, one WAV each, all from one seed so they line up, plus a
  `manifest.json` saying what each file kept. Run it hosted at https://latentft.csail.mit.edu/jupyter/ (sign in with
  your token; everything is installed), or anywhere with

      pip install "latentft-lab[viz]" --extra-index-url https://latentft.csail.mit.edu/pip/simple

- **A sweep as a job**: the package installs `latentft-sweep`, which renders a whole sweep in one command, resumably
  (one file per zone centre, any number, several widths or seeds, a manifest, optional glide pieces):

      latentft-sweep --out my_sweep --centres 0.4 16 24 --octaves 2 --kind band --glides

  With no audio file it uses Bob Dylan's *The Man in Me* from 2:00, fetched from the class site; put your own file's
  path first to use that instead (`--start` says where to begin). It prints its progress as it goes; if it stops, run the same command again and
  it picks up where it left off.

  With [uv](https://docs.astral.sh/uv/), no install needed:

      uvx --from latentft-lab@latest --index https://latentft.csail.mit.edu/pip/simple latentft-sweep --out my_sweep --glides

- `python/`: that package's source (`pip install ./python` also works).
- `docs/CLIENT.md`: the Python client and the pictures, function by function, with recipes.
  `docs/API.md`: the wire format, for SuperCollider, Max, curl, or your own client.
- `own-gpu-engaging/`: running the model yourself on MIT's Engaging cluster (needs the weights: see `WEIGHTS.md`).

**Your API token.** Every call to the service needs your token: the personal one in your sign-in link
(`https://latentft.csail.mit.edu/#token=...`, the part after `token=`) or the class token from your instructor. The
first time, give it on the command line and let the command remember it:

```
latentft-sweep --token YOUR_TOKEN --save-token --out my_sweep --glides
```

After that no token is needed in commands: it is read from `~/.config/flowedit/token` (the same file the FlowEdit
tools use). Alternatives: `export LATENTFT_TOKEN=YOUR_TOKEN` in the shell, or `LatentFT(token="...")` in Python. The
hosted notebook has your token on file already. Keep it private: anyone with it renders as you, in your history.

The outcome of part 2 is a folder of same-length WAVs and a manifest.

## 3 · Play them in Max — `3-play-in-max/`
`latentft_crossfader.maxpat` loads the folder from part 2 into buffers; every file plays in sync, and one slider
glides across them with an equal-power crossfade between neighbours. Put the number from part 1 on the slider, and
the mapping is yours. **Work in progress**: it plays, but its layout is being redone. `build_crossfader.py`
generates the patch (do not edit the .maxpat by hand); `README.md` explains the math.

## Also
Listening studies made with these tools, each example with the Python that made it: https://latentft.csail.mit.edu/studies/

LatentFT is Wang & Huang, *Latent Fourier Transform*, ICLR 2026. The weights are Mason Wang's, shared with permission
for MIT teaching and research; they are not in this repo and must not be redistributed.

### For maintainers
Model code, hub worker and studies live in `HAI-Res/latentft-post-training`; `./sync.sh` copies the shared files
from there (set `MODEL_REPO` if it is not a sibling directory).
