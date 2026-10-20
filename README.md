# LatentFT class: sensor → Python renders → Max

Everything a student needs for the LatentFT lab in one place. The service itself (the GPU, the models, the weights)
lives on the lab's machines and is reached through https://latentft.csail.mit.edu; nothing here needs a GPU or the
model weights.

| part | folder | what you do |
|---|---|---|
| 1 · a sensor into Max | `max/mugic-udp/` | Sabrina's MUGIC example: the IMU sends OSC over UDP (port 4000); `mugic_receive.maxpat` receives and rebroadcasts it, `mugic_examples.maxpat` maps tilt to a slider and to a pitch. `MUGIC_SETUP.pdf` is the setup. `mugic_capture.py` prints or records the readings (`uv run mugic_capture.py take1.csv`). |
| 2 · render a slew of files in Python | `notebook/LatentFT_lab.ipynb`, `python/` | The lab notebook: the rate axis, masks bin by bin, blends, the latent itself, and in section 8 a bulk render: a grid of masks, one WAV each, all from one seed, plus `manifest.json` saying what each file kept. Hosted at https://latentft.csail.mit.edu/jupyter/ (sign in with your token), or run anywhere after `pip install "latentft-lab[viz]" --extra-index-url https://latentft.csail.mit.edu/pip/simple`. |
| 3 · play them from Max | `max/latentft-crossfader/` | Load the bulk folder into buffers and sweep across the files with one slider (equal-power crossfade between neighbours, all files in sync). Put the number from part 1 on the slider. **Work in progress**: the patch works but its layout is being redone. |

References: `docs/API.md` (the wire format, for SuperCollider, Max, curl), `docs/CLIENT.md` (the Python client and the
pictures, with recipes). Listening studies made with the same tools: https://latentft.csail.mit.edu/studies/.
Running the model on your own GPU (MIT Engaging): `engaging/`.

LatentFT is Wang & Huang, *Latent Fourier Transform*, ICLR 2026. The weights are Mason Wang's, shared with permission
for MIT teaching and research; they are not in this repo and must not be redistributed.

## For maintainers

The model code, the hub worker and the listening studies live in `HAI-Res/latentft-post-training`; `./sync.sh` copies
the student-facing files from there (set `MODEL_REPO` if it is not a sibling directory). The Python package in
`python/` is the same `latentft-lab` the site serves; `pip install ./python` installs it from here.
