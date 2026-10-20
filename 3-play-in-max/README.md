# LatentFT crossfader — Max patch (tutorial part 3)

`latentft_crossfader.maxpat` loads a folder of LatentFT renders into buffers and sweeps across them with one slider.
It is the last third of a three-part lab:

1. **Sensor data into Max** (Sabrina's tutorial): a controller, a phone, a camera, anything that becomes a number 0..1.
2. **Rendering a slew of files in Python** (`demo/LatentFT_lab.ipynb`, section 8, or `docs/CLIENT.md` "Bulk render"):
   a grid of masks, one WAV per point, all from one seed so they line up, plus `manifest.json` saying what each file kept.
3. **This patch**: load that folder, every file plays in sync, the slider glides across them. Map the number from
   part 1 onto the slider and the mapping is yours.

**Do not edit the .maxpat by hand.** It is generated: `python3 max/build_crossfader.py`. The generator checks every
cord against its box's inlets and outlets; the design and the comments live there.

## Using it

1. Open `latentft_crossfader.maxpat` in Max 8.5+ (nothing else to install). Click the speaker to start audio.
2. Click the button at **1 · LOAD** and choose the bulk render's folder (or drop the folder on the box). The files
   load into `lft.1 … lft.N` in alphabetical order, which is the manifest's order (`zone_000_…`, `zone_001_…`);
   `N` and the files' length appear; the umenu lists the names.
3. Move the slider at **3**. At each moment only the two files nearest the slider sound, crossfaded equal-power.
   The umenu shows the file the slider is nearest to; look it up in `manifest.json` to see what it kept.
4. Replace the slider's input with your sensor (a `scale` to 0..1 and a `line` or `slide` to smooth jumps).

## How it works

The main window reads top to bottom, and the two subpatches are the only places with any arithmetic:

1. **LOAD** — a button (or a dropped folder) sends the path into `[p load_folder]`, which holds the plumbing:
   `polybuffer~ lft` loads every sound file as `lft.1 … lft.N` in alphabetical order (the manifest's order),
   `folder` lists the names for the umenu, `info~` reads the length of the first file. Out come N, the length and the names.
2. **CLOCK** — one `phasor~` at `1000 / length_ms` Hz, times the length, is the position in milliseconds. It is sent
   to every player over `[s~ pos]`, so all files stay sample-aligned (they were rendered from one seed).
3. **THE SLIDER** — `[p gains]` turns the slider into sixteen gains: `pos = x (N − 1)`, and for file k
   `gain_k = cos(min(|pos − k|, 1) · π/2)`. Only the two files nearest the slider are non-zero, and that pair is
   cos θ and sin θ of one angle, so cos² + sin² = 1 and the loudness stays even while you slide (equal power). The
   subpatch shows the sixteen gains as bars, updated twice a second. This is the same math as the glides on the
   listening pages and `latentft_viz.xfade_sweep`.
4. **PLAYERS** — sixteen identical columns, one per file: `[r~ pos] → play~ lft.k 2 → *~ gain_k → s~ mix`. Gains
   ramp over 30 ms. A folder with more than sixteen files plays the first sixteen; change `SLOTS` in the generator
   for more.
5. **OUT** — the columns sum into `live.gain~` and `ezdac~`.

## Making a folder for it

Any folder of same-length WAVs at one sample rate works; alphabetical order is the slider's order. From the client
(`pip install latentft-lab --extra-index-url https://latentft.csail.mit.edu/pip/simple`):

```python
centres = np.geomspace(0.4, 16.0, 16)
renders = [{"a": keep(mask=soft_octave(fc, 2.0))} for fc in centres]          # a zone moving up the rate axis
res = lf.render_many(a, sr, renders, model="stereo", seconds=30, seed=0, stereo_mode="mid")
res.save("my_zone_sweep", prefix="zone")                                      # WAVs + manifest.json
```

`stereo_mode="mid"` gives a coherent stereo image; the default per-channel vocoding gives two uncorrelated channels
(lab journal SD-50). Ideas for the grid: zone centre (as above); zone width at one centre; notch instead of band
(`1 - soft_octave(...)`); two clips blended with `weights` from 0 to 1; the same mask across seeds.
