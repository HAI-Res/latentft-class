# latentft-lab

The Python side of the LatentFT class service at https://latentft.csail.mit.edu: `LatentFT` (render, encode, decode,
bulk render, save with a manifest), keep-spec helpers (`keep`, `soft_band`, `soft_octave`, …), and pictures
(`show`, `show_all`, glides). Documentation: https://latentft.csail.mit.edu/notebook/client.html

    pip install latentft-lab --extra-index-url https://latentft.csail.mit.edu/pip/simple
    pip install "latentft-lab[viz]" --extra-index-url https://latentft.csail.mit.edu/pip/simple   # with matplotlib etc.

    from latentft_lab import LatentFT, keep, soft_octave, show_all        # or the module names the notebook uses:
    from latentft_client import LatentFT, keep
    from latentft_viz import soft_octave, show_all

Also installs the `latentft-sweep` command: a whole sweep as a resumable job (`latentft-sweep --help`).

With uv, no install: `uvx --from latentft-lab@latest --index https://latentft.csail.mit.edu/pip/simple latentft-sweep --out my_sweep --glides`
