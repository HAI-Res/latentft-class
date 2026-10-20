# LatentFT on Engaging (MIT ORCD): run it yourself

The class service (https://latentft.csail.mit.edu) is one GPU shared by everyone. If you want LatentFT on your own
schedule, or more GPU than the class has, run the **same code and the same API** on MIT's Engaging cluster. Any MIT
Kerberos holder can get an Engaging account, and the public GPU partition has L40S and H200 cards.

Everything below was written from the ORCD documentation (https://orcd-docs.mit.edu) on 2026-10-18 and has **not
yet been run on Engaging**; the first person to do it should fix what differs and send the changes back.

## What you need

1. **An Engaging account.** Log in once at https://orcd-ood.mit.edu with your MIT Kerberos; the account is created
   automatically (wait ~15 min before the first job).
2. **This repo.** `git clone https://github.com/HAI-Res/latentft-post-training.git` on Engaging (it is private: ask
   for access, or get a tarball from the instructor). The vendored model code is the submodule `third_party/latentft`:
   `git submodule update --init`.
3. **The weights.** They are Mason Wang's, shared with permission for MIT teaching and research, **never public**.
   `WEIGHTS.md` says how to get them onto Engaging. You need at least the mono paper model (1.5 GB).

## One-time setup (on a login node, ~10 minutes, mostly downloads)

    ssh <kerberos>@orcd-login.mit.edu          # Kerberos password + Duo
    cd /path/to/latentft-post-training
    bash engaging/setup.sh                     # uv venv in ./.venv, torch, the latentft package, a Jupyter kernel

The environment lives in the repo directory (`.venv`, ~6 GB). Keep it out of your home directory if home is small;
the ORCD docs suggest scratch for large environments. BigVGAN (the vocoder, ~0.9 GB) is fetched from Hugging Face
the first time a model loads; `setup.sh` pre-fetches it so a compute job without internet still works.

## Way 1: a server in a job, the notebook anywhere

    sbatch engaging/latentft_server.sbatch     # 1 GPU on mit_normal_gpu, 4 h by default
    squeue -u $USER                            # wait for it to be RUNNING; note the node (e.g. node2801)
    tail -f logs/latentft-server-<jobid>.out   # prints "serving on http://0.0.0.0:8765" and the tunnel command

From your laptop, open a tunnel through the login node to the compute node, then point the notebook at it:

    ssh -L 8765:<node>:8765 <kerberos>@orcd-login.mit.edu
    # in LatentFT_lab.ipynb:  MODE = "local"   ->  LatentFT(hub="http://127.0.0.1:8765", token=<the job's token>)

The job writes a random token to `logs/latentft-server-<jobid>.token`; the server refuses requests without it, so
another user on the login node cannot use your GPU. The server speaks exactly the hub's `POST /latentft`
(`docs/API.md`), so the notebook, `latentft_client.py`, SuperCollider or curl all work unchanged.

## Way 2: Jupyter on the GPU node (Open OnDemand)

At https://orcd-ood.mit.edu start **Jupyter** with partition `mit_normal_gpu`, 1 GPU, 4 CPUs, 32 GB, a few hours.
Pick the **LatentFT** kernel that `setup.sh` registered. In `LatentFT_lab.ipynb` set `MODE = "in_process"` and the
paths to this repo and the weights: the models load into the kernel (about 40 s) and every call runs on your GPU with
no server and no tunnel. This is the simplest way once setup is done.

## Way 3: batch, no notebook

`demo/latentft_demo.py` is importable: `Demo({"mono": WEIGHTS}).handle({...})` takes the same JSON as the service.
`sbatch` a Python script around it for long sweeps; see `cluster/` for the lab's own job files as patterns.

## Costs and limits

- One L40S renders a 5.944-s window with 35 steps in ~1.2 s per render plus vocoding; a 31-render set is ~20 s.
- Memory: mono + stereo resident ~3.3 GiB, peak ~5.2 GiB at batch 16; the U-Net model adds ~2.8 GiB and runs fp32.
- `mit_normal_gpu` has a per-partition time limit you cannot raise (`sinfo -p mit_normal_gpu` shows it);
  `mit_preemptable` is longer but may be stopped and requeued.
- Compute-node internet access is not documented; `setup.sh` therefore pre-fetches the vocoder on the login node.

## Files

| file | what |
|---|---|
| `setup.sh` | venv + packages + vocoder cache + Jupyter kernel |
| `latentft_server.sbatch` | one-GPU job running `demo/latentft_server.py` with a token, prints the tunnel command |
| `WEIGHTS.md` | where the weights are and how they are distributed to students |
