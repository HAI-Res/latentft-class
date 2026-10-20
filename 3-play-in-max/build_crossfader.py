#!/usr/bin/env python3
"""Generate max/latentft_crossfader.maxpat: load a folder of LatentFT renders (a bulk render from the notebook, or any
folder of same-length WAVs) into buffers and sweep across them with one slider. Part 3 of the class tutorial:
1 sensor data into Max (Sabrina), 2 rendering a slew of files in Python (notebook section 8), 3 this patch; then
students map the slider to whatever they like.

    python3 max/build_crossfader.py          # writes max/latentft_crossfader.maxpat

Why a generator: a .maxpat is JSON with cord endpoints by box id; hand-moved cords break silently. Same pattern as
sa-flowedit/max/build_patch.py.

How it reads (the point is that a student can follow it):
  * [p load_folder]: the plumbing. polybuffer~ loads every sound file of the folder into lft.1 .. lft.N in
    alphabetical order (= the manifest's order); it reports N and the files' length.
  * One phasor~ in ms is sent to every player over [s~ pos], so all files stay sample-aligned (one seed).
  * SLOTS columns, one per file, all identical: [r~ pos] -> [play~ lft.k 2] -> [*~ gain_k] -> [s~ mixL/R].
  * [p gains]: the slider becomes SLOTS gains, gain_k = cos(min(|pos - k|, 1) * pi/2) with pos = x (N - 1).
    Only the two files nearest the slider are non-zero, and the pair is cos/sin of one angle (equal power).
"""
SLOTS = 16   # columns in the patch; a folder with more files uses the first SLOTS
import json
from pathlib import Path

HERE = Path(__file__).resolve().parent
OUT = HERE / "latentft_crossfader.maxpat"


class Patcher:
    def __init__(self):
        self.boxes, self.lines, self.n = [], [], 0

    def box(self, maxclass, x, y, w=None, h=22, text=None, inlets=1, outlets=1, outtypes=None, **attrs):
        self.n += 1
        bid = f"obj-{self.n}"
        b = {"id": bid, "maxclass": maxclass, "numinlets": inlets, "numoutlets": outlets,
             "patching_rect": [float(x), float(y), float(w or (len(text or "") * 6.5 + 14)), float(h)]}
        if outlets:
            b["outlettype"] = outtypes or [""] * outlets
        if text is not None:
            b["text"] = text
        b.update(attrs)
        self.boxes.append({"box": b})
        return bid

    def obj(self, text, x, y, inlets=1, outlets=1, outtypes=None, w=None, **a):
        return self.box("newobj", x, y, w, text=text, inlets=inlets, outlets=outlets, outtypes=outtypes, **a)

    def msg(self, text, x, y, w=None, **a):
        return self.box("message", x, y, w, text=text, inlets=2, outlets=1, **a)

    def comment(self, text, x, y, w=300, h=20, **a):
        return self.box("comment", x, y, w, h, text=text, inlets=0, outlets=0, **a)

    def connect(self, src, dst, out=0, inl=0):
        self.lines.append({"patchline": {"source": [src, out], "destination": [dst, inl]}})

    def chain(self, *ids):
        for a, b in zip(ids, ids[1:]):
            self.connect(a, b)

    def to_dict(self, rect=(60, 80, 1180, 900)):
        return {"patcher": {
            "fileversion": 1, "appversion": {"major": 8, "minor": 5, "revision": 7, "architecture": "x64", "modernui": 1},
            "classnamespace": "box", "rect": list(map(float, rect)), "bglocked": 0, "openinpresentation": 0,
            "default_fontsize": 12.0, "default_fontface": 0, "default_fontname": "Arial",
            "gridonopen": 1, "gridsize": [15.0, 15.0], "gridsnaponopen": 1, "objectsnaponopen": 1,
            "statusbarvisible": 2, "toolbarvisible": 1, "lefttoolbarpinned": 0, "toptoolbarpinned": 0,
            "righttoolbarpinned": 0, "bottomtoolbarpinned": 0, "toolbars_unpinned_last_save": 0, "tallnewobj": 0,
            "boxanimatetime": 200, "enablehscroll": 1, "enablevscroll": 1, "devicewidth": 0.0,
            "description": "", "digest": "", "tags": "", "style": "", "subpatcher_template": "", "assistshowspatchername": 0,
            "boxes": self.boxes, "lines": self.lines}}



def build_gains():
    """The slider -> SLOTS gains. Same math as the FlowEdit morph panner and latentft_viz.xfade_sweep."""
    p = Patcher()
    p.comment("GAINS — how one slider becomes sixteen gains", 20, 20, 560, 22, fontsize=14.0, fontface=1)
    in_x = p.box("inlet", 20, 60, 30, 30, inlets=0, outlets=1, comment="slider 0..1")
    in_n = p.box("inlet", 260, 60, 30, 30, inlets=0, outlets=1, comment="number of files N")
    p.comment("1 · position in files: pos = x · (N − 1). Slider at 0 is file 1, at 1 the last file.", 20, 100, 640, 20)
    pos = p.obj("expr $f1 * (max($i2\\, 2) - 1)", 20, 130, inlets=2, w=200)
    p.connect(in_x, pos, 0, 0); p.connect(in_n, pos, 0, 1)
    posnum = p.box("flonum", 240, 130, 70, 22, outlets=2, outtypes=["", "bang"]); p.connect(pos, posnum)
    p.comment("← pos (in files)", 316, 130, 140, 20)
    p.comment("2 · every file k measures its distance to the slider, d = |pos − k|, clipped at 1: anything further than one file away is silent.", 20, 165, 760, 20)
    p.comment("3 · gain_k = cos(d · π/2). On the file: 1. One file away: 0. Between two files the pair is cos θ and sin θ of the same angle, "
              "and cos² + sin² = 1, so the loudness stays even while you slide (equal power).", 20, 190, 760, 34)
    gains = []
    for k in range(SLOTS):
        x = 20 + k * 74
        e = p.obj(f"expr cos(min(abs($f1 - {k})\\, 1.) * 1.5707963)", x, 240, w=68)
        p.connect(pos, e)
        o = p.box("outlet", x, 300, 30, 30, inlets=1, outlets=0, comment=f"gain file {k + 1}")
        p.connect(e, o); p.comment(f"{k + 1}", x + 34, 304, 30, 20)
        gains.append(e)
    p.comment("The sixteen gains right now (updates twice a second, never animates):", 20, 350, 480, 20)
    pk = p.obj("pak " + " ".join(["f"] * SLOTS), 20, 375, inlets=SLOTS, outlets=1, w=600)
    for k, g in enumerate(gains):
        p.connect(g, pk, 0, k)
    sl = p.obj("speedlim 500", 20, 405, w=90); p.connect(pk, sl)
    ms = p.box("multislider", 20, 435, 600, 90, inlets=1, outlets=2, outtypes=["", ""], size=SLOTS, setminmax=[0.0, 1.0], contdata=1)
    p.connect(sl, ms)
    return p


def build_loader():
    """A folder path in -> files loaded into lft.1..N, N out, length (ms) out, file names out (for a umenu)."""
    p = Patcher()
    p.comment("LOAD FOLDER — the plumbing", 20, 20, 400, 22, fontsize=14.0, fontface=1)
    p.comment("polybuffer~ lft loads every sound file of the folder as buffers lft.1 … lft.N, alphabetically (= the manifest's order). "
              "folder lists the same names for the umenu. info~ reads the length of the first file; they all share it.", 20, 46, 640, 48)
    inp = p.box("inlet", 20, 110, 30, 30, inlets=0, outlets=1, comment="folder path")
    t = p.obj("t s s s", 20, 150, outlets=3, outtypes=["", "", ""], w=70); p.connect(inp, t)
    rf = p.obj("prepend readfolder", 300, 190, w=130); pb = p.obj("polybuffer~ lft", 300, 225, inlets=1, outlets=2, outtypes=["", ""], w=110)
    p.connect(t, rf, 2, 0); p.connect(rf, pb)
    lb = p.obj("loadbang", 160, 110, outlets=1, outtypes=["bang"], w=70); ty = p.msg("types WAVE AIFF AIFC", 160, 150, w=150)
    fo = p.obj("folder", 160, 190, inlets=1, outlets=2, outtypes=["", "int"], w=60)
    p.chain(lb, ty, fo); p.connect(t, fo, 1, 0)
    out_names = p.box("outlet", 160, 330, 30, 30, inlets=1, outlets=0, comment="file names (clear / append …) for a umenu"); p.connect(fo, out_names)
    dl = p.obj("delay 300", 20, 190, outlets=1, outtypes=["bang"], w=80); p.connect(t, dl, 0, 0)
    tbb = p.obj("t b b", 20, 225, outlets=2, outtypes=["bang", "bang"], w=50); p.connect(dl, tbb)
    gc = p.msg("getcount", 80, 260, w=70); p.connect(tbb, gc, 1, 0); p.connect(gc, pb)
    rc = p.obj("route count", 300, 260, outlets=2, outtypes=["", ""], w=90); p.connect(pb, rc, 0, 0)
    out_n = p.box("outlet", 300, 330, 30, 30, inlets=1, outlets=0, comment="N files"); p.connect(rc, out_n)
    si = p.msg("set lft.1, bang", 20, 260, w=100); p.connect(tbb, si, 0, 0)
    info = p.obj("info~", 20, 295, inlets=1, outlets=10, outtypes=[""] * 10, w=160); p.connect(si, info)
    out_len = p.box("outlet", 20, 330, 30, 30, inlets=1, outlets=0, comment="length of one file, ms"); p.connect(info, out_len, 6, 0)
    return p


def build():
    p = Patcher()
    p.comment("LatentFT crossfader — a folder of renders, one slider", 20, 15, 600, 26, fontsize=16.0, fontface=1)
    p.comment("Tutorial part 3. Part 2 made the files (notebook section 8: one WAV per mask, all from one seed, plus manifest.json). "
              "Load the folder; every file plays in sync; the slider glides across them. Map the slider to your sensor (part 1).", 20, 44, 900, 34)

    # 1 LOAD
    lx, ly = 20, 95
    p.comment("1 · LOAD a folder of same-length WAVs (the bulk render's folder)", lx, ly, 600, 20, fontface=1)
    btn = p.box("button", lx, ly + 26, 24, 24, outlets=1, outtypes=["bang"]); p.comment("← choose the folder", lx + 30, ly + 28, 160, 20)
    od = p.obj("opendialog fold", lx, ly + 58, outlets=2, outtypes=["", "bang"], w=110)
    drop = p.box("dropfile", lx + 200, ly + 26, 200, 54, inlets=1, outlets=2, outtypes=["", ""]); p.comment("…or drop the folder here", lx + 410, ly + 42, 200, 20)
    loader_sub = build_loader().to_dict(rect=(80, 100, 700, 420))["patcher"]
    loader = p.box("newobj", lx, ly + 92, 110, 22, text="p load_folder", inlets=1, outlets=3, outtypes=["", "", ""], patcher=loader_sub)
    p.connect(btn, od); p.connect(od, loader); p.connect(drop, loader)
    p.comment("← open it to see the plumbing (polybuffer~, folder, info~)", lx + 115, ly + 92, 400, 20)
    len_ms = p.box("flonum", lx, ly + 126, 80, 22, outlets=2, outtypes=["", "bang"]); p.connect(loader, len_ms, 0, 0)
    p.comment("← length of one file, ms", lx + 85, ly + 126, 180, 20)
    um = p.box("umenu", lx + 300, ly + 126, 320, 22, inlets=1, outlets=3, outtypes=["int", "", ""]); p.connect(loader, um, 1, 0)
    p.comment("← the file the slider is nearest to", lx + 625, ly + 126, 240, 20)
    n_num = p.box("number", lx, ly + 160, 60, 22, outlets=2, outtypes=["", "bang"]); p.connect(loader, n_num, 2, 0)
    p.comment(f"← N files (this patch plays the first {SLOTS})", lx + 65, ly + 160, 300, 20)

    # 2 CLOCK
    cx, cy = 20, ly + 205
    p.comment("2 · CLOCK — one phasor~ in milliseconds, sent to every player, so all files stay sample-aligned", cx, cy, 700, 20, fontface=1)
    freq = p.obj("expr 1000. / max($f1\\, 1.)", cx, cy + 26, w=170); p.connect(len_ms, freq)
    ph = p.obj("phasor~ 0.", cx, cy + 56, inlets=2, outlets=1, outtypes=["signal"], w=80); p.connect(freq, ph, 0, 0)
    mul = p.obj("*~ 0.", cx, cy + 86, inlets=2, outlets=1, outtypes=["signal"], w=60); p.connect(ph, mul, 0, 0); p.connect(len_ms, mul, 0, 1)
    spos = p.obj("s~ pos", cx, cy + 116, outlets=0, w=60); p.connect(mul, spos)
    p.comment("← position in ms = phasor (0..1) × length; every column below receives it with [r~ pos]", cx + 70, cy + 116, 600, 20)

    # 3 SLIDER + gains
    sx, sy = 20, cy + 160
    p.comment("3 · THE SLIDER — map your sensor here (0..1). [p gains] turns it into one gain per file; open it to read the math.", sx, sy, 800, 20, fontface=1)
    slider = p.box("slider", sx, sy + 26, SLOTS * 74 - 6, 30, outlets=1, floatoutput=1, size=1.0)
    gains_sub = build_gains().to_dict(rect=(80, 100, 1240, 580))["patcher"]
    gains = p.box("newobj", sx, sy + 66, SLOTS * 74 - 6, 22, text="p gains", inlets=2, outlets=SLOTS, outtypes=[""] * SLOTS, patcher=gains_sub)
    p.connect(slider, gains, 0, 0); p.connect(n_num, gains, 0, 1)
    nearest = p.obj("expr int(floor($f1 * (max($i2\\, 2) - 1) + 0.5))", sx + SLOTS * 74 + 10, sy + 26, inlets=2, w=250)
    p.connect(slider, nearest, 0, 0); p.connect(n_num, nearest, 0, 1); p.connect(nearest, um)
    p.comment("↑ nearest file → umenu", sx + SLOTS * 74 + 10, sy + 50, 200, 20)

    # 4 PLAYERS: one column per file
    rx, ry = 20, sy + 110
    p.comment(f"4 · PLAYERS — {SLOTS} identical columns, one per file: [r~ pos] → play~ lft.k → ×gain_k (30 ms ramp) → the mix", rx, ry, 800, 20, fontface=1)
    for k in range(SLOTS):
        x = rx + k * 74
        r = p.obj("r~ pos", x, ry + 26, inlets=0, outlets=1, outtypes=["signal"], w=56)
        pl = p.obj(f"play~ lft.{k + 1} 2", x, ry + 56, inlets=1, outlets=3, outtypes=["signal", "signal", "bang"], w=68)
        p.connect(r, pl)
        pk = p.obj("pack f 30", x, ry + 86, inlets=2, w=62); ln = p.obj("line~", x, ry + 116, inlets=2, outlets=2, outtypes=["signal", "bang"], w=48)
        p.connect(gains, pk, k, 0); p.connect(pk, ln)
        mL = p.obj("*~", x, ry + 146, inlets=2, outlets=1, outtypes=["signal"], w=28); mR = p.obj("*~", x + 34, ry + 146, inlets=2, outlets=1, outtypes=["signal"], w=28)
        p.connect(pl, mL, 0, 0); p.connect(pl, mR, 1, 0); p.connect(ln, mL, 0, 1); p.connect(ln, mR, 0, 1)
        sL = p.obj("s~ mixL", x, ry + 176, outlets=0, w=28); sR = p.obj("s~ mixR", x + 34, ry + 176, outlets=0, w=28)
        p.connect(mL, sL); p.connect(mR, sR)
        p.comment(f"{k + 1}", x + 24, ry + 200, 30, 20)

    # 5 OUT
    ox, oy = 20, ry + 235
    p.comment("5 · OUT — the columns sum into the mix", ox, oy, 400, 20, fontface=1)
    rL = p.obj("r~ mixL", ox, oy + 26, inlets=0, outlets=1, outtypes=["signal"], w=60); rR = p.obj("r~ mixR", ox + 70, oy + 26, inlets=0, outlets=1, outtypes=["signal"], w=60)
    master = p.box("live.gain~", ox, oy + 56, 120, 90, inlets=2, outlets=5, outtypes=["signal", "signal", "", "", "list"], parameter_enable=1,
                   saved_attribute_attributes={"valueof": {"parameter_longname": "master", "parameter_shortname": "master", "parameter_type": 0,
                   "parameter_mmin": -70.0, "parameter_mmax": 6.0, "parameter_initial": [-6.0], "parameter_initial_enable": 1, "parameter_unitstyle": 4}})
    p.connect(rL, master, 0, 0); p.connect(rR, master, 0, 1)
    dac = p.box("ezdac~", ox + 140, oy + 80, 45, 45, inlets=2, outlets=0); p.connect(master, dac, 0, 0); p.connect(master, dac, 1, 1)
    p.comment("← start audio. Load a folder, move the slider, listen; then put your sensor on the slider.", ox + 195, oy + 92, 560, 20)
    return p


def main():
    p = build()
    d = p.to_dict(rect=(60, 60, 1260, 980))
    def check(patcher):
        ids = {b["box"]["id"]: b["box"] for b in patcher["boxes"]}
        for ln in patcher["lines"]:
            s, so = ln["patchline"]["source"]; t, ti = ln["patchline"]["destination"]
            assert so < ids[s]["numoutlets"], (ids[s].get("text", s), so)
            assert ti < ids[t]["numinlets"], (ids[t].get("text", t), ti)
        for b in patcher["boxes"]:
            if "patcher" in b["box"]:
                check(b["box"]["patcher"])
    check(d["patcher"])
    OUT.write_text(json.dumps(d, indent=1))
    n = len(d["patcher"]["boxes"]); print(f"wrote {OUT}: {n} boxes, {len(d['patcher']['lines'])} cords, {SLOTS} slots, 2 subpatches")


if __name__ == "__main__":
    main()
