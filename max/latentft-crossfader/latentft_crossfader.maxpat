{
 "patcher": {
  "fileversion": 1,
  "appversion": {
   "major": 8,
   "minor": 5,
   "revision": 7,
   "architecture": "x64",
   "modernui": 1
  },
  "classnamespace": "box",
  "rect": [
   60.0,
   60.0,
   1260.0,
   980.0
  ],
  "bglocked": 0,
  "openinpresentation": 0,
  "default_fontsize": 12.0,
  "default_fontface": 0,
  "default_fontname": "Arial",
  "gridonopen": 1,
  "gridsize": [
   15.0,
   15.0
  ],
  "gridsnaponopen": 1,
  "objectsnaponopen": 1,
  "statusbarvisible": 2,
  "toolbarvisible": 1,
  "lefttoolbarpinned": 0,
  "toptoolbarpinned": 0,
  "righttoolbarpinned": 0,
  "bottomtoolbarpinned": 0,
  "toolbars_unpinned_last_save": 0,
  "tallnewobj": 0,
  "boxanimatetime": 200,
  "enablehscroll": 1,
  "enablevscroll": 1,
  "devicewidth": 0.0,
  "description": "",
  "digest": "",
  "tags": "",
  "style": "",
  "subpatcher_template": "",
  "assistshowspatchername": 0,
  "boxes": [
   {
    "box": {
     "id": "obj-1",
     "maxclass": "comment",
     "numinlets": 0,
     "numoutlets": 0,
     "patching_rect": [
      20.0,
      15.0,
      600.0,
      26.0
     ],
     "text": "LatentFT crossfader \u2014 a folder of renders, one slider",
     "fontsize": 16.0,
     "fontface": 1
    }
   },
   {
    "box": {
     "id": "obj-2",
     "maxclass": "comment",
     "numinlets": 0,
     "numoutlets": 0,
     "patching_rect": [
      20.0,
      44.0,
      900.0,
      34.0
     ],
     "text": "Tutorial part 3. Part 2 made the files (notebook section 8: one WAV per mask, all from one seed, plus manifest.json). Load the folder; every file plays in sync; the slider glides across them. Map the slider to your sensor (part 1)."
    }
   },
   {
    "box": {
     "id": "obj-3",
     "maxclass": "comment",
     "numinlets": 0,
     "numoutlets": 0,
     "patching_rect": [
      20.0,
      95.0,
      600.0,
      20.0
     ],
     "text": "1 \u00b7 LOAD a folder of same-length WAVs (the bulk render's folder)",
     "fontface": 1
    }
   },
   {
    "box": {
     "id": "obj-4",
     "maxclass": "button",
     "numinlets": 1,
     "numoutlets": 1,
     "patching_rect": [
      20.0,
      121.0,
      24.0,
      24.0
     ],
     "outlettype": [
      "bang"
     ]
    }
   },
   {
    "box": {
     "id": "obj-5",
     "maxclass": "comment",
     "numinlets": 0,
     "numoutlets": 0,
     "patching_rect": [
      50.0,
      123.0,
      160.0,
      20.0
     ],
     "text": "\u2190 choose the folder"
    }
   },
   {
    "box": {
     "id": "obj-6",
     "maxclass": "newobj",
     "numinlets": 1,
     "numoutlets": 2,
     "patching_rect": [
      20.0,
      153.0,
      110.0,
      22.0
     ],
     "outlettype": [
      "",
      "bang"
     ],
     "text": "opendialog fold"
    }
   },
   {
    "box": {
     "id": "obj-7",
     "maxclass": "dropfile",
     "numinlets": 1,
     "numoutlets": 2,
     "patching_rect": [
      220.0,
      121.0,
      200.0,
      54.0
     ],
     "outlettype": [
      "",
      ""
     ]
    }
   },
   {
    "box": {
     "id": "obj-8",
     "maxclass": "comment",
     "numinlets": 0,
     "numoutlets": 0,
     "patching_rect": [
      430.0,
      137.0,
      200.0,
      20.0
     ],
     "text": "\u2026or drop the folder here"
    }
   },
   {
    "box": {
     "id": "obj-9",
     "maxclass": "newobj",
     "numinlets": 1,
     "numoutlets": 3,
     "patching_rect": [
      20.0,
      187.0,
      110.0,
      22.0
     ],
     "outlettype": [
      "",
      "",
      ""
     ],
     "text": "p load_folder",
     "patcher": {
      "fileversion": 1,
      "appversion": {
       "major": 8,
       "minor": 5,
       "revision": 7,
       "architecture": "x64",
       "modernui": 1
      },
      "classnamespace": "box",
      "rect": [
       80.0,
       100.0,
       700.0,
       420.0
      ],
      "bglocked": 0,
      "openinpresentation": 0,
      "default_fontsize": 12.0,
      "default_fontface": 0,
      "default_fontname": "Arial",
      "gridonopen": 1,
      "gridsize": [
       15.0,
       15.0
      ],
      "gridsnaponopen": 1,
      "objectsnaponopen": 1,
      "statusbarvisible": 2,
      "toolbarvisible": 1,
      "lefttoolbarpinned": 0,
      "toptoolbarpinned": 0,
      "righttoolbarpinned": 0,
      "bottomtoolbarpinned": 0,
      "toolbars_unpinned_last_save": 0,
      "tallnewobj": 0,
      "boxanimatetime": 200,
      "enablehscroll": 1,
      "enablevscroll": 1,
      "devicewidth": 0.0,
      "description": "",
      "digest": "",
      "tags": "",
      "style": "",
      "subpatcher_template": "",
      "assistshowspatchername": 0,
      "boxes": [
       {
        "box": {
         "id": "obj-1",
         "maxclass": "comment",
         "numinlets": 0,
         "numoutlets": 0,
         "patching_rect": [
          20.0,
          20.0,
          400.0,
          22.0
         ],
         "text": "LOAD FOLDER \u2014 the plumbing",
         "fontsize": 14.0,
         "fontface": 1
        }
       },
       {
        "box": {
         "id": "obj-2",
         "maxclass": "comment",
         "numinlets": 0,
         "numoutlets": 0,
         "patching_rect": [
          20.0,
          46.0,
          640.0,
          48.0
         ],
         "text": "polybuffer~ lft loads every sound file of the folder as buffers lft.1 \u2026 lft.N, alphabetically (= the manifest's order). folder lists the same names for the umenu. info~ reads the length of the first file; they all share it."
        }
       },
       {
        "box": {
         "id": "obj-3",
         "maxclass": "inlet",
         "numinlets": 0,
         "numoutlets": 1,
         "patching_rect": [
          20.0,
          110.0,
          30.0,
          30.0
         ],
         "outlettype": [
          ""
         ],
         "comment": "folder path"
        }
       },
       {
        "box": {
         "id": "obj-4",
         "maxclass": "newobj",
         "numinlets": 1,
         "numoutlets": 3,
         "patching_rect": [
          20.0,
          150.0,
          70.0,
          22.0
         ],
         "outlettype": [
          "",
          "",
          ""
         ],
         "text": "t s s s"
        }
       },
       {
        "box": {
         "id": "obj-5",
         "maxclass": "newobj",
         "numinlets": 1,
         "numoutlets": 1,
         "patching_rect": [
          300.0,
          190.0,
          130.0,
          22.0
         ],
         "outlettype": [
          ""
         ],
         "text": "prepend readfolder"
        }
       },
       {
        "box": {
         "id": "obj-6",
         "maxclass": "newobj",
         "numinlets": 1,
         "numoutlets": 2,
         "patching_rect": [
          300.0,
          225.0,
          110.0,
          22.0
         ],
         "outlettype": [
          "",
          ""
         ],
         "text": "polybuffer~ lft"
        }
       },
       {
        "box": {
         "id": "obj-7",
         "maxclass": "newobj",
         "numinlets": 1,
         "numoutlets": 1,
         "patching_rect": [
          160.0,
          110.0,
          70.0,
          22.0
         ],
         "outlettype": [
          "bang"
         ],
         "text": "loadbang"
        }
       },
       {
        "box": {
         "id": "obj-8",
         "maxclass": "message",
         "numinlets": 2,
         "numoutlets": 1,
         "patching_rect": [
          160.0,
          150.0,
          150.0,
          22.0
         ],
         "outlettype": [
          ""
         ],
         "text": "types WAVE AIFF AIFC"
        }
       },
       {
        "box": {
         "id": "obj-9",
         "maxclass": "newobj",
         "numinlets": 1,
         "numoutlets": 2,
         "patching_rect": [
          160.0,
          190.0,
          60.0,
          22.0
         ],
         "outlettype": [
          "",
          "int"
         ],
         "text": "folder"
        }
       },
       {
        "box": {
         "id": "obj-10",
         "maxclass": "outlet",
         "numinlets": 1,
         "numoutlets": 0,
         "patching_rect": [
          160.0,
          330.0,
          30.0,
          30.0
         ],
         "comment": "file names (clear / append \u2026) for a umenu"
        }
       },
       {
        "box": {
         "id": "obj-11",
         "maxclass": "newobj",
         "numinlets": 1,
         "numoutlets": 1,
         "patching_rect": [
          20.0,
          190.0,
          80.0,
          22.0
         ],
         "outlettype": [
          "bang"
         ],
         "text": "delay 300"
        }
       },
       {
        "box": {
         "id": "obj-12",
         "maxclass": "newobj",
         "numinlets": 1,
         "numoutlets": 2,
         "patching_rect": [
          20.0,
          225.0,
          50.0,
          22.0
         ],
         "outlettype": [
          "bang",
          "bang"
         ],
         "text": "t b b"
        }
       },
       {
        "box": {
         "id": "obj-13",
         "maxclass": "message",
         "numinlets": 2,
         "numoutlets": 1,
         "patching_rect": [
          80.0,
          260.0,
          70.0,
          22.0
         ],
         "outlettype": [
          ""
         ],
         "text": "getcount"
        }
       },
       {
        "box": {
         "id": "obj-14",
         "maxclass": "newobj",
         "numinlets": 1,
         "numoutlets": 2,
         "patching_rect": [
          300.0,
          260.0,
          90.0,
          22.0
         ],
         "outlettype": [
          "",
          ""
         ],
         "text": "route count"
        }
       },
       {
        "box": {
         "id": "obj-15",
         "maxclass": "outlet",
         "numinlets": 1,
         "numoutlets": 0,
         "patching_rect": [
          300.0,
          330.0,
          30.0,
          30.0
         ],
         "comment": "N files"
        }
       },
       {
        "box": {
         "id": "obj-16",
         "maxclass": "message",
         "numinlets": 2,
         "numoutlets": 1,
         "patching_rect": [
          20.0,
          260.0,
          100.0,
          22.0
         ],
         "outlettype": [
          ""
         ],
         "text": "set lft.1, bang"
        }
       },
       {
        "box": {
         "id": "obj-17",
         "maxclass": "newobj",
         "numinlets": 1,
         "numoutlets": 10,
         "patching_rect": [
          20.0,
          295.0,
          160.0,
          22.0
         ],
         "outlettype": [
          "",
          "",
          "",
          "",
          "",
          "",
          "",
          "",
          "",
          ""
         ],
         "text": "info~"
        }
       },
       {
        "box": {
         "id": "obj-18",
         "maxclass": "outlet",
         "numinlets": 1,
         "numoutlets": 0,
         "patching_rect": [
          20.0,
          330.0,
          30.0,
          30.0
         ],
         "comment": "length of one file, ms"
        }
       }
      ],
      "lines": [
       {
        "patchline": {
         "source": [
          "obj-3",
          0
         ],
         "destination": [
          "obj-4",
          0
         ]
        }
       },
       {
        "patchline": {
         "source": [
          "obj-4",
          2
         ],
         "destination": [
          "obj-5",
          0
         ]
        }
       },
       {
        "patchline": {
         "source": [
          "obj-5",
          0
         ],
         "destination": [
          "obj-6",
          0
         ]
        }
       },
       {
        "patchline": {
         "source": [
          "obj-7",
          0
         ],
         "destination": [
          "obj-8",
          0
         ]
        }
       },
       {
        "patchline": {
         "source": [
          "obj-8",
          0
         ],
         "destination": [
          "obj-9",
          0
         ]
        }
       },
       {
        "patchline": {
         "source": [
          "obj-4",
          1
         ],
         "destination": [
          "obj-9",
          0
         ]
        }
       },
       {
        "patchline": {
         "source": [
          "obj-9",
          0
         ],
         "destination": [
          "obj-10",
          0
         ]
        }
       },
       {
        "patchline": {
         "source": [
          "obj-4",
          0
         ],
         "destination": [
          "obj-11",
          0
         ]
        }
       },
       {
        "patchline": {
         "source": [
          "obj-11",
          0
         ],
         "destination": [
          "obj-12",
          0
         ]
        }
       },
       {
        "patchline": {
         "source": [
          "obj-12",
          1
         ],
         "destination": [
          "obj-13",
          0
         ]
        }
       },
       {
        "patchline": {
         "source": [
          "obj-13",
          0
         ],
         "destination": [
          "obj-6",
          0
         ]
        }
       },
       {
        "patchline": {
         "source": [
          "obj-6",
          0
         ],
         "destination": [
          "obj-14",
          0
         ]
        }
       },
       {
        "patchline": {
         "source": [
          "obj-14",
          0
         ],
         "destination": [
          "obj-15",
          0
         ]
        }
       },
       {
        "patchline": {
         "source": [
          "obj-12",
          0
         ],
         "destination": [
          "obj-16",
          0
         ]
        }
       },
       {
        "patchline": {
         "source": [
          "obj-16",
          0
         ],
         "destination": [
          "obj-17",
          0
         ]
        }
       },
       {
        "patchline": {
         "source": [
          "obj-17",
          6
         ],
         "destination": [
          "obj-18",
          0
         ]
        }
       }
      ]
     }
    }
   },
   {
    "box": {
     "id": "obj-10",
     "maxclass": "comment",
     "numinlets": 0,
     "numoutlets": 0,
     "patching_rect": [
      135.0,
      187.0,
      400.0,
      20.0
     ],
     "text": "\u2190 open it to see the plumbing (polybuffer~, folder, info~)"
    }
   },
   {
    "box": {
     "id": "obj-11",
     "maxclass": "flonum",
     "numinlets": 1,
     "numoutlets": 2,
     "patching_rect": [
      20.0,
      221.0,
      80.0,
      22.0
     ],
     "outlettype": [
      "",
      "bang"
     ]
    }
   },
   {
    "box": {
     "id": "obj-12",
     "maxclass": "comment",
     "numinlets": 0,
     "numoutlets": 0,
     "patching_rect": [
      105.0,
      221.0,
      180.0,
      20.0
     ],
     "text": "\u2190 length of one file, ms"
    }
   },
   {
    "box": {
     "id": "obj-13",
     "maxclass": "umenu",
     "numinlets": 1,
     "numoutlets": 3,
     "patching_rect": [
      320.0,
      221.0,
      320.0,
      22.0
     ],
     "outlettype": [
      "int",
      "",
      ""
     ]
    }
   },
   {
    "box": {
     "id": "obj-14",
     "maxclass": "comment",
     "numinlets": 0,
     "numoutlets": 0,
     "patching_rect": [
      645.0,
      221.0,
      240.0,
      20.0
     ],
     "text": "\u2190 the file the slider is nearest to"
    }
   },
   {
    "box": {
     "id": "obj-15",
     "maxclass": "number",
     "numinlets": 1,
     "numoutlets": 2,
     "patching_rect": [
      20.0,
      255.0,
      60.0,
      22.0
     ],
     "outlettype": [
      "",
      "bang"
     ]
    }
   },
   {
    "box": {
     "id": "obj-16",
     "maxclass": "comment",
     "numinlets": 0,
     "numoutlets": 0,
     "patching_rect": [
      85.0,
      255.0,
      300.0,
      20.0
     ],
     "text": "\u2190 N files (this patch plays the first 16)"
    }
   },
   {
    "box": {
     "id": "obj-17",
     "maxclass": "comment",
     "numinlets": 0,
     "numoutlets": 0,
     "patching_rect": [
      20.0,
      300.0,
      700.0,
      20.0
     ],
     "text": "2 \u00b7 CLOCK \u2014 one phasor~ in milliseconds, sent to every player, so all files stay sample-aligned",
     "fontface": 1
    }
   },
   {
    "box": {
     "id": "obj-18",
     "maxclass": "newobj",
     "numinlets": 1,
     "numoutlets": 1,
     "patching_rect": [
      20.0,
      326.0,
      170.0,
      22.0
     ],
     "outlettype": [
      ""
     ],
     "text": "expr 1000. / max($f1\\, 1.)"
    }
   },
   {
    "box": {
     "id": "obj-19",
     "maxclass": "newobj",
     "numinlets": 2,
     "numoutlets": 1,
     "patching_rect": [
      20.0,
      356.0,
      80.0,
      22.0
     ],
     "outlettype": [
      "signal"
     ],
     "text": "phasor~ 0."
    }
   },
   {
    "box": {
     "id": "obj-20",
     "maxclass": "newobj",
     "numinlets": 2,
     "numoutlets": 1,
     "patching_rect": [
      20.0,
      386.0,
      60.0,
      22.0
     ],
     "outlettype": [
      "signal"
     ],
     "text": "*~ 0."
    }
   },
   {
    "box": {
     "id": "obj-21",
     "maxclass": "newobj",
     "numinlets": 1,
     "numoutlets": 0,
     "patching_rect": [
      20.0,
      416.0,
      60.0,
      22.0
     ],
     "text": "s~ pos"
    }
   },
   {
    "box": {
     "id": "obj-22",
     "maxclass": "comment",
     "numinlets": 0,
     "numoutlets": 0,
     "patching_rect": [
      90.0,
      416.0,
      600.0,
      20.0
     ],
     "text": "\u2190 position in ms = phasor (0..1) \u00d7 length; every column below receives it with [r~ pos]"
    }
   },
   {
    "box": {
     "id": "obj-23",
     "maxclass": "comment",
     "numinlets": 0,
     "numoutlets": 0,
     "patching_rect": [
      20.0,
      460.0,
      800.0,
      20.0
     ],
     "text": "3 \u00b7 THE SLIDER \u2014 map your sensor here (0..1). [p gains] turns it into one gain per file; open it to read the math.",
     "fontface": 1
    }
   },
   {
    "box": {
     "id": "obj-24",
     "maxclass": "slider",
     "numinlets": 1,
     "numoutlets": 1,
     "patching_rect": [
      20.0,
      486.0,
      1178.0,
      30.0
     ],
     "outlettype": [
      ""
     ],
     "floatoutput": 1,
     "size": 1.0
    }
   },
   {
    "box": {
     "id": "obj-25",
     "maxclass": "newobj",
     "numinlets": 2,
     "numoutlets": 16,
     "patching_rect": [
      20.0,
      526.0,
      1178.0,
      22.0
     ],
     "outlettype": [
      "",
      "",
      "",
      "",
      "",
      "",
      "",
      "",
      "",
      "",
      "",
      "",
      "",
      "",
      "",
      ""
     ],
     "text": "p gains",
     "patcher": {
      "fileversion": 1,
      "appversion": {
       "major": 8,
       "minor": 5,
       "revision": 7,
       "architecture": "x64",
       "modernui": 1
      },
      "classnamespace": "box",
      "rect": [
       80.0,
       100.0,
       1240.0,
       580.0
      ],
      "bglocked": 0,
      "openinpresentation": 0,
      "default_fontsize": 12.0,
      "default_fontface": 0,
      "default_fontname": "Arial",
      "gridonopen": 1,
      "gridsize": [
       15.0,
       15.0
      ],
      "gridsnaponopen": 1,
      "objectsnaponopen": 1,
      "statusbarvisible": 2,
      "toolbarvisible": 1,
      "lefttoolbarpinned": 0,
      "toptoolbarpinned": 0,
      "righttoolbarpinned": 0,
      "bottomtoolbarpinned": 0,
      "toolbars_unpinned_last_save": 0,
      "tallnewobj": 0,
      "boxanimatetime": 200,
      "enablehscroll": 1,
      "enablevscroll": 1,
      "devicewidth": 0.0,
      "description": "",
      "digest": "",
      "tags": "",
      "style": "",
      "subpatcher_template": "",
      "assistshowspatchername": 0,
      "boxes": [
       {
        "box": {
         "id": "obj-1",
         "maxclass": "comment",
         "numinlets": 0,
         "numoutlets": 0,
         "patching_rect": [
          20.0,
          20.0,
          560.0,
          22.0
         ],
         "text": "GAINS \u2014 how one slider becomes sixteen gains",
         "fontsize": 14.0,
         "fontface": 1
        }
       },
       {
        "box": {
         "id": "obj-2",
         "maxclass": "inlet",
         "numinlets": 0,
         "numoutlets": 1,
         "patching_rect": [
          20.0,
          60.0,
          30.0,
          30.0
         ],
         "outlettype": [
          ""
         ],
         "comment": "slider 0..1"
        }
       },
       {
        "box": {
         "id": "obj-3",
         "maxclass": "inlet",
         "numinlets": 0,
         "numoutlets": 1,
         "patching_rect": [
          260.0,
          60.0,
          30.0,
          30.0
         ],
         "outlettype": [
          ""
         ],
         "comment": "number of files N"
        }
       },
       {
        "box": {
         "id": "obj-4",
         "maxclass": "comment",
         "numinlets": 0,
         "numoutlets": 0,
         "patching_rect": [
          20.0,
          100.0,
          640.0,
          20.0
         ],
         "text": "1 \u00b7 position in files: pos = x \u00b7 (N \u2212 1). Slider at 0 is file 1, at 1 the last file."
        }
       },
       {
        "box": {
         "id": "obj-5",
         "maxclass": "newobj",
         "numinlets": 2,
         "numoutlets": 1,
         "patching_rect": [
          20.0,
          130.0,
          200.0,
          22.0
         ],
         "outlettype": [
          ""
         ],
         "text": "expr $f1 * (max($i2\\, 2) - 1)"
        }
       },
       {
        "box": {
         "id": "obj-6",
         "maxclass": "flonum",
         "numinlets": 1,
         "numoutlets": 2,
         "patching_rect": [
          240.0,
          130.0,
          70.0,
          22.0
         ],
         "outlettype": [
          "",
          "bang"
         ]
        }
       },
       {
        "box": {
         "id": "obj-7",
         "maxclass": "comment",
         "numinlets": 0,
         "numoutlets": 0,
         "patching_rect": [
          316.0,
          130.0,
          140.0,
          20.0
         ],
         "text": "\u2190 pos (in files)"
        }
       },
       {
        "box": {
         "id": "obj-8",
         "maxclass": "comment",
         "numinlets": 0,
         "numoutlets": 0,
         "patching_rect": [
          20.0,
          165.0,
          760.0,
          20.0
         ],
         "text": "2 \u00b7 every file k measures its distance to the slider, d = |pos \u2212 k|, clipped at 1: anything further than one file away is silent."
        }
       },
       {
        "box": {
         "id": "obj-9",
         "maxclass": "comment",
         "numinlets": 0,
         "numoutlets": 0,
         "patching_rect": [
          20.0,
          190.0,
          760.0,
          34.0
         ],
         "text": "3 \u00b7 gain_k = cos(d \u00b7 \u03c0/2). On the file: 1. One file away: 0. Between two files the pair is cos \u03b8 and sin \u03b8 of the same angle, and cos\u00b2 + sin\u00b2 = 1, so the loudness stays even while you slide (equal power)."
        }
       },
       {
        "box": {
         "id": "obj-10",
         "maxclass": "newobj",
         "numinlets": 1,
         "numoutlets": 1,
         "patching_rect": [
          20.0,
          240.0,
          68.0,
          22.0
         ],
         "outlettype": [
          ""
         ],
         "text": "expr cos(min(abs($f1 - 0)\\, 1.) * 1.5707963)"
        }
       },
       {
        "box": {
         "id": "obj-11",
         "maxclass": "outlet",
         "numinlets": 1,
         "numoutlets": 0,
         "patching_rect": [
          20.0,
          300.0,
          30.0,
          30.0
         ],
         "comment": "gain file 1"
        }
       },
       {
        "box": {
         "id": "obj-12",
         "maxclass": "comment",
         "numinlets": 0,
         "numoutlets": 0,
         "patching_rect": [
          54.0,
          304.0,
          30.0,
          20.0
         ],
         "text": "1"
        }
       },
       {
        "box": {
         "id": "obj-13",
         "maxclass": "newobj",
         "numinlets": 1,
         "numoutlets": 1,
         "patching_rect": [
          94.0,
          240.0,
          68.0,
          22.0
         ],
         "outlettype": [
          ""
         ],
         "text": "expr cos(min(abs($f1 - 1)\\, 1.) * 1.5707963)"
        }
       },
       {
        "box": {
         "id": "obj-14",
         "maxclass": "outlet",
         "numinlets": 1,
         "numoutlets": 0,
         "patching_rect": [
          94.0,
          300.0,
          30.0,
          30.0
         ],
         "comment": "gain file 2"
        }
       },
       {
        "box": {
         "id": "obj-15",
         "maxclass": "comment",
         "numinlets": 0,
         "numoutlets": 0,
         "patching_rect": [
          128.0,
          304.0,
          30.0,
          20.0
         ],
         "text": "2"
        }
       },
       {
        "box": {
         "id": "obj-16",
         "maxclass": "newobj",
         "numinlets": 1,
         "numoutlets": 1,
         "patching_rect": [
          168.0,
          240.0,
          68.0,
          22.0
         ],
         "outlettype": [
          ""
         ],
         "text": "expr cos(min(abs($f1 - 2)\\, 1.) * 1.5707963)"
        }
       },
       {
        "box": {
         "id": "obj-17",
         "maxclass": "outlet",
         "numinlets": 1,
         "numoutlets": 0,
         "patching_rect": [
          168.0,
          300.0,
          30.0,
          30.0
         ],
         "comment": "gain file 3"
        }
       },
       {
        "box": {
         "id": "obj-18",
         "maxclass": "comment",
         "numinlets": 0,
         "numoutlets": 0,
         "patching_rect": [
          202.0,
          304.0,
          30.0,
          20.0
         ],
         "text": "3"
        }
       },
       {
        "box": {
         "id": "obj-19",
         "maxclass": "newobj",
         "numinlets": 1,
         "numoutlets": 1,
         "patching_rect": [
          242.0,
          240.0,
          68.0,
          22.0
         ],
         "outlettype": [
          ""
         ],
         "text": "expr cos(min(abs($f1 - 3)\\, 1.) * 1.5707963)"
        }
       },
       {
        "box": {
         "id": "obj-20",
         "maxclass": "outlet",
         "numinlets": 1,
         "numoutlets": 0,
         "patching_rect": [
          242.0,
          300.0,
          30.0,
          30.0
         ],
         "comment": "gain file 4"
        }
       },
       {
        "box": {
         "id": "obj-21",
         "maxclass": "comment",
         "numinlets": 0,
         "numoutlets": 0,
         "patching_rect": [
          276.0,
          304.0,
          30.0,
          20.0
         ],
         "text": "4"
        }
       },
       {
        "box": {
         "id": "obj-22",
         "maxclass": "newobj",
         "numinlets": 1,
         "numoutlets": 1,
         "patching_rect": [
          316.0,
          240.0,
          68.0,
          22.0
         ],
         "outlettype": [
          ""
         ],
         "text": "expr cos(min(abs($f1 - 4)\\, 1.) * 1.5707963)"
        }
       },
       {
        "box": {
         "id": "obj-23",
         "maxclass": "outlet",
         "numinlets": 1,
         "numoutlets": 0,
         "patching_rect": [
          316.0,
          300.0,
          30.0,
          30.0
         ],
         "comment": "gain file 5"
        }
       },
       {
        "box": {
         "id": "obj-24",
         "maxclass": "comment",
         "numinlets": 0,
         "numoutlets": 0,
         "patching_rect": [
          350.0,
          304.0,
          30.0,
          20.0
         ],
         "text": "5"
        }
       },
       {
        "box": {
         "id": "obj-25",
         "maxclass": "newobj",
         "numinlets": 1,
         "numoutlets": 1,
         "patching_rect": [
          390.0,
          240.0,
          68.0,
          22.0
         ],
         "outlettype": [
          ""
         ],
         "text": "expr cos(min(abs($f1 - 5)\\, 1.) * 1.5707963)"
        }
       },
       {
        "box": {
         "id": "obj-26",
         "maxclass": "outlet",
         "numinlets": 1,
         "numoutlets": 0,
         "patching_rect": [
          390.0,
          300.0,
          30.0,
          30.0
         ],
         "comment": "gain file 6"
        }
       },
       {
        "box": {
         "id": "obj-27",
         "maxclass": "comment",
         "numinlets": 0,
         "numoutlets": 0,
         "patching_rect": [
          424.0,
          304.0,
          30.0,
          20.0
         ],
         "text": "6"
        }
       },
       {
        "box": {
         "id": "obj-28",
         "maxclass": "newobj",
         "numinlets": 1,
         "numoutlets": 1,
         "patching_rect": [
          464.0,
          240.0,
          68.0,
          22.0
         ],
         "outlettype": [
          ""
         ],
         "text": "expr cos(min(abs($f1 - 6)\\, 1.) * 1.5707963)"
        }
       },
       {
        "box": {
         "id": "obj-29",
         "maxclass": "outlet",
         "numinlets": 1,
         "numoutlets": 0,
         "patching_rect": [
          464.0,
          300.0,
          30.0,
          30.0
         ],
         "comment": "gain file 7"
        }
       },
       {
        "box": {
         "id": "obj-30",
         "maxclass": "comment",
         "numinlets": 0,
         "numoutlets": 0,
         "patching_rect": [
          498.0,
          304.0,
          30.0,
          20.0
         ],
         "text": "7"
        }
       },
       {
        "box": {
         "id": "obj-31",
         "maxclass": "newobj",
         "numinlets": 1,
         "numoutlets": 1,
         "patching_rect": [
          538.0,
          240.0,
          68.0,
          22.0
         ],
         "outlettype": [
          ""
         ],
         "text": "expr cos(min(abs($f1 - 7)\\, 1.) * 1.5707963)"
        }
       },
       {
        "box": {
         "id": "obj-32",
         "maxclass": "outlet",
         "numinlets": 1,
         "numoutlets": 0,
         "patching_rect": [
          538.0,
          300.0,
          30.0,
          30.0
         ],
         "comment": "gain file 8"
        }
       },
       {
        "box": {
         "id": "obj-33",
         "maxclass": "comment",
         "numinlets": 0,
         "numoutlets": 0,
         "patching_rect": [
          572.0,
          304.0,
          30.0,
          20.0
         ],
         "text": "8"
        }
       },
       {
        "box": {
         "id": "obj-34",
         "maxclass": "newobj",
         "numinlets": 1,
         "numoutlets": 1,
         "patching_rect": [
          612.0,
          240.0,
          68.0,
          22.0
         ],
         "outlettype": [
          ""
         ],
         "text": "expr cos(min(abs($f1 - 8)\\, 1.) * 1.5707963)"
        }
       },
       {
        "box": {
         "id": "obj-35",
         "maxclass": "outlet",
         "numinlets": 1,
         "numoutlets": 0,
         "patching_rect": [
          612.0,
          300.0,
          30.0,
          30.0
         ],
         "comment": "gain file 9"
        }
       },
       {
        "box": {
         "id": "obj-36",
         "maxclass": "comment",
         "numinlets": 0,
         "numoutlets": 0,
         "patching_rect": [
          646.0,
          304.0,
          30.0,
          20.0
         ],
         "text": "9"
        }
       },
       {
        "box": {
         "id": "obj-37",
         "maxclass": "newobj",
         "numinlets": 1,
         "numoutlets": 1,
         "patching_rect": [
          686.0,
          240.0,
          68.0,
          22.0
         ],
         "outlettype": [
          ""
         ],
         "text": "expr cos(min(abs($f1 - 9)\\, 1.) * 1.5707963)"
        }
       },
       {
        "box": {
         "id": "obj-38",
         "maxclass": "outlet",
         "numinlets": 1,
         "numoutlets": 0,
         "patching_rect": [
          686.0,
          300.0,
          30.0,
          30.0
         ],
         "comment": "gain file 10"
        }
       },
       {
        "box": {
         "id": "obj-39",
         "maxclass": "comment",
         "numinlets": 0,
         "numoutlets": 0,
         "patching_rect": [
          720.0,
          304.0,
          30.0,
          20.0
         ],
         "text": "10"
        }
       },
       {
        "box": {
         "id": "obj-40",
         "maxclass": "newobj",
         "numinlets": 1,
         "numoutlets": 1,
         "patching_rect": [
          760.0,
          240.0,
          68.0,
          22.0
         ],
         "outlettype": [
          ""
         ],
         "text": "expr cos(min(abs($f1 - 10)\\, 1.) * 1.5707963)"
        }
       },
       {
        "box": {
         "id": "obj-41",
         "maxclass": "outlet",
         "numinlets": 1,
         "numoutlets": 0,
         "patching_rect": [
          760.0,
          300.0,
          30.0,
          30.0
         ],
         "comment": "gain file 11"
        }
       },
       {
        "box": {
         "id": "obj-42",
         "maxclass": "comment",
         "numinlets": 0,
         "numoutlets": 0,
         "patching_rect": [
          794.0,
          304.0,
          30.0,
          20.0
         ],
         "text": "11"
        }
       },
       {
        "box": {
         "id": "obj-43",
         "maxclass": "newobj",
         "numinlets": 1,
         "numoutlets": 1,
         "patching_rect": [
          834.0,
          240.0,
          68.0,
          22.0
         ],
         "outlettype": [
          ""
         ],
         "text": "expr cos(min(abs($f1 - 11)\\, 1.) * 1.5707963)"
        }
       },
       {
        "box": {
         "id": "obj-44",
         "maxclass": "outlet",
         "numinlets": 1,
         "numoutlets": 0,
         "patching_rect": [
          834.0,
          300.0,
          30.0,
          30.0
         ],
         "comment": "gain file 12"
        }
       },
       {
        "box": {
         "id": "obj-45",
         "maxclass": "comment",
         "numinlets": 0,
         "numoutlets": 0,
         "patching_rect": [
          868.0,
          304.0,
          30.0,
          20.0
         ],
         "text": "12"
        }
       },
       {
        "box": {
         "id": "obj-46",
         "maxclass": "newobj",
         "numinlets": 1,
         "numoutlets": 1,
         "patching_rect": [
          908.0,
          240.0,
          68.0,
          22.0
         ],
         "outlettype": [
          ""
         ],
         "text": "expr cos(min(abs($f1 - 12)\\, 1.) * 1.5707963)"
        }
       },
       {
        "box": {
         "id": "obj-47",
         "maxclass": "outlet",
         "numinlets": 1,
         "numoutlets": 0,
         "patching_rect": [
          908.0,
          300.0,
          30.0,
          30.0
         ],
         "comment": "gain file 13"
        }
       },
       {
        "box": {
         "id": "obj-48",
         "maxclass": "comment",
         "numinlets": 0,
         "numoutlets": 0,
         "patching_rect": [
          942.0,
          304.0,
          30.0,
          20.0
         ],
         "text": "13"
        }
       },
       {
        "box": {
         "id": "obj-49",
         "maxclass": "newobj",
         "numinlets": 1,
         "numoutlets": 1,
         "patching_rect": [
          982.0,
          240.0,
          68.0,
          22.0
         ],
         "outlettype": [
          ""
         ],
         "text": "expr cos(min(abs($f1 - 13)\\, 1.) * 1.5707963)"
        }
       },
       {
        "box": {
         "id": "obj-50",
         "maxclass": "outlet",
         "numinlets": 1,
         "numoutlets": 0,
         "patching_rect": [
          982.0,
          300.0,
          30.0,
          30.0
         ],
         "comment": "gain file 14"
        }
       },
       {
        "box": {
         "id": "obj-51",
         "maxclass": "comment",
         "numinlets": 0,
         "numoutlets": 0,
         "patching_rect": [
          1016.0,
          304.0,
          30.0,
          20.0
         ],
         "text": "14"
        }
       },
       {
        "box": {
         "id": "obj-52",
         "maxclass": "newobj",
         "numinlets": 1,
         "numoutlets": 1,
         "patching_rect": [
          1056.0,
          240.0,
          68.0,
          22.0
         ],
         "outlettype": [
          ""
         ],
         "text": "expr cos(min(abs($f1 - 14)\\, 1.) * 1.5707963)"
        }
       },
       {
        "box": {
         "id": "obj-53",
         "maxclass": "outlet",
         "numinlets": 1,
         "numoutlets": 0,
         "patching_rect": [
          1056.0,
          300.0,
          30.0,
          30.0
         ],
         "comment": "gain file 15"
        }
       },
       {
        "box": {
         "id": "obj-54",
         "maxclass": "comment",
         "numinlets": 0,
         "numoutlets": 0,
         "patching_rect": [
          1090.0,
          304.0,
          30.0,
          20.0
         ],
         "text": "15"
        }
       },
       {
        "box": {
         "id": "obj-55",
         "maxclass": "newobj",
         "numinlets": 1,
         "numoutlets": 1,
         "patching_rect": [
          1130.0,
          240.0,
          68.0,
          22.0
         ],
         "outlettype": [
          ""
         ],
         "text": "expr cos(min(abs($f1 - 15)\\, 1.) * 1.5707963)"
        }
       },
       {
        "box": {
         "id": "obj-56",
         "maxclass": "outlet",
         "numinlets": 1,
         "numoutlets": 0,
         "patching_rect": [
          1130.0,
          300.0,
          30.0,
          30.0
         ],
         "comment": "gain file 16"
        }
       },
       {
        "box": {
         "id": "obj-57",
         "maxclass": "comment",
         "numinlets": 0,
         "numoutlets": 0,
         "patching_rect": [
          1164.0,
          304.0,
          30.0,
          20.0
         ],
         "text": "16"
        }
       },
       {
        "box": {
         "id": "obj-58",
         "maxclass": "comment",
         "numinlets": 0,
         "numoutlets": 0,
         "patching_rect": [
          20.0,
          350.0,
          480.0,
          20.0
         ],
         "text": "The sixteen gains right now (updates twice a second, never animates):"
        }
       },
       {
        "box": {
         "id": "obj-59",
         "maxclass": "newobj",
         "numinlets": 16,
         "numoutlets": 1,
         "patching_rect": [
          20.0,
          375.0,
          600.0,
          22.0
         ],
         "outlettype": [
          ""
         ],
         "text": "pak f f f f f f f f f f f f f f f f"
        }
       },
       {
        "box": {
         "id": "obj-60",
         "maxclass": "newobj",
         "numinlets": 1,
         "numoutlets": 1,
         "patching_rect": [
          20.0,
          405.0,
          90.0,
          22.0
         ],
         "outlettype": [
          ""
         ],
         "text": "speedlim 500"
        }
       },
       {
        "box": {
         "id": "obj-61",
         "maxclass": "multislider",
         "numinlets": 1,
         "numoutlets": 2,
         "patching_rect": [
          20.0,
          435.0,
          600.0,
          90.0
         ],
         "outlettype": [
          "",
          ""
         ],
         "size": 16,
         "setminmax": [
          0.0,
          1.0
         ],
         "contdata": 1
        }
       }
      ],
      "lines": [
       {
        "patchline": {
         "source": [
          "obj-2",
          0
         ],
         "destination": [
          "obj-5",
          0
         ]
        }
       },
       {
        "patchline": {
         "source": [
          "obj-3",
          0
         ],
         "destination": [
          "obj-5",
          1
         ]
        }
       },
       {
        "patchline": {
         "source": [
          "obj-5",
          0
         ],
         "destination": [
          "obj-6",
          0
         ]
        }
       },
       {
        "patchline": {
         "source": [
          "obj-5",
          0
         ],
         "destination": [
          "obj-10",
          0
         ]
        }
       },
       {
        "patchline": {
         "source": [
          "obj-10",
          0
         ],
         "destination": [
          "obj-11",
          0
         ]
        }
       },
       {
        "patchline": {
         "source": [
          "obj-5",
          0
         ],
         "destination": [
          "obj-13",
          0
         ]
        }
       },
       {
        "patchline": {
         "source": [
          "obj-13",
          0
         ],
         "destination": [
          "obj-14",
          0
         ]
        }
       },
       {
        "patchline": {
         "source": [
          "obj-5",
          0
         ],
         "destination": [
          "obj-16",
          0
         ]
        }
       },
       {
        "patchline": {
         "source": [
          "obj-16",
          0
         ],
         "destination": [
          "obj-17",
          0
         ]
        }
       },
       {
        "patchline": {
         "source": [
          "obj-5",
          0
         ],
         "destination": [
          "obj-19",
          0
         ]
        }
       },
       {
        "patchline": {
         "source": [
          "obj-19",
          0
         ],
         "destination": [
          "obj-20",
          0
         ]
        }
       },
       {
        "patchline": {
         "source": [
          "obj-5",
          0
         ],
         "destination": [
          "obj-22",
          0
         ]
        }
       },
       {
        "patchline": {
         "source": [
          "obj-22",
          0
         ],
         "destination": [
          "obj-23",
          0
         ]
        }
       },
       {
        "patchline": {
         "source": [
          "obj-5",
          0
         ],
         "destination": [
          "obj-25",
          0
         ]
        }
       },
       {
        "patchline": {
         "source": [
          "obj-25",
          0
         ],
         "destination": [
          "obj-26",
          0
         ]
        }
       },
       {
        "patchline": {
         "source": [
          "obj-5",
          0
         ],
         "destination": [
          "obj-28",
          0
         ]
        }
       },
       {
        "patchline": {
         "source": [
          "obj-28",
          0
         ],
         "destination": [
          "obj-29",
          0
         ]
        }
       },
       {
        "patchline": {
         "source": [
          "obj-5",
          0
         ],
         "destination": [
          "obj-31",
          0
         ]
        }
       },
       {
        "patchline": {
         "source": [
          "obj-31",
          0
         ],
         "destination": [
          "obj-32",
          0
         ]
        }
       },
       {
        "patchline": {
         "source": [
          "obj-5",
          0
         ],
         "destination": [
          "obj-34",
          0
         ]
        }
       },
       {
        "patchline": {
         "source": [
          "obj-34",
          0
         ],
         "destination": [
          "obj-35",
          0
         ]
        }
       },
       {
        "patchline": {
         "source": [
          "obj-5",
          0
         ],
         "destination": [
          "obj-37",
          0
         ]
        }
       },
       {
        "patchline": {
         "source": [
          "obj-37",
          0
         ],
         "destination": [
          "obj-38",
          0
         ]
        }
       },
       {
        "patchline": {
         "source": [
          "obj-5",
          0
         ],
         "destination": [
          "obj-40",
          0
         ]
        }
       },
       {
        "patchline": {
         "source": [
          "obj-40",
          0
         ],
         "destination": [
          "obj-41",
          0
         ]
        }
       },
       {
        "patchline": {
         "source": [
          "obj-5",
          0
         ],
         "destination": [
          "obj-43",
          0
         ]
        }
       },
       {
        "patchline": {
         "source": [
          "obj-43",
          0
         ],
         "destination": [
          "obj-44",
          0
         ]
        }
       },
       {
        "patchline": {
         "source": [
          "obj-5",
          0
         ],
         "destination": [
          "obj-46",
          0
         ]
        }
       },
       {
        "patchline": {
         "source": [
          "obj-46",
          0
         ],
         "destination": [
          "obj-47",
          0
         ]
        }
       },
       {
        "patchline": {
         "source": [
          "obj-5",
          0
         ],
         "destination": [
          "obj-49",
          0
         ]
        }
       },
       {
        "patchline": {
         "source": [
          "obj-49",
          0
         ],
         "destination": [
          "obj-50",
          0
         ]
        }
       },
       {
        "patchline": {
         "source": [
          "obj-5",
          0
         ],
         "destination": [
          "obj-52",
          0
         ]
        }
       },
       {
        "patchline": {
         "source": [
          "obj-52",
          0
         ],
         "destination": [
          "obj-53",
          0
         ]
        }
       },
       {
        "patchline": {
         "source": [
          "obj-5",
          0
         ],
         "destination": [
          "obj-55",
          0
         ]
        }
       },
       {
        "patchline": {
         "source": [
          "obj-55",
          0
         ],
         "destination": [
          "obj-56",
          0
         ]
        }
       },
       {
        "patchline": {
         "source": [
          "obj-10",
          0
         ],
         "destination": [
          "obj-59",
          0
         ]
        }
       },
       {
        "patchline": {
         "source": [
          "obj-13",
          0
         ],
         "destination": [
          "obj-59",
          1
         ]
        }
       },
       {
        "patchline": {
         "source": [
          "obj-16",
          0
         ],
         "destination": [
          "obj-59",
          2
         ]
        }
       },
       {
        "patchline": {
         "source": [
          "obj-19",
          0
         ],
         "destination": [
          "obj-59",
          3
         ]
        }
       },
       {
        "patchline": {
         "source": [
          "obj-22",
          0
         ],
         "destination": [
          "obj-59",
          4
         ]
        }
       },
       {
        "patchline": {
         "source": [
          "obj-25",
          0
         ],
         "destination": [
          "obj-59",
          5
         ]
        }
       },
       {
        "patchline": {
         "source": [
          "obj-28",
          0
         ],
         "destination": [
          "obj-59",
          6
         ]
        }
       },
       {
        "patchline": {
         "source": [
          "obj-31",
          0
         ],
         "destination": [
          "obj-59",
          7
         ]
        }
       },
       {
        "patchline": {
         "source": [
          "obj-34",
          0
         ],
         "destination": [
          "obj-59",
          8
         ]
        }
       },
       {
        "patchline": {
         "source": [
          "obj-37",
          0
         ],
         "destination": [
          "obj-59",
          9
         ]
        }
       },
       {
        "patchline": {
         "source": [
          "obj-40",
          0
         ],
         "destination": [
          "obj-59",
          10
         ]
        }
       },
       {
        "patchline": {
         "source": [
          "obj-43",
          0
         ],
         "destination": [
          "obj-59",
          11
         ]
        }
       },
       {
        "patchline": {
         "source": [
          "obj-46",
          0
         ],
         "destination": [
          "obj-59",
          12
         ]
        }
       },
       {
        "patchline": {
         "source": [
          "obj-49",
          0
         ],
         "destination": [
          "obj-59",
          13
         ]
        }
       },
       {
        "patchline": {
         "source": [
          "obj-52",
          0
         ],
         "destination": [
          "obj-59",
          14
         ]
        }
       },
       {
        "patchline": {
         "source": [
          "obj-55",
          0
         ],
         "destination": [
          "obj-59",
          15
         ]
        }
       },
       {
        "patchline": {
         "source": [
          "obj-59",
          0
         ],
         "destination": [
          "obj-60",
          0
         ]
        }
       },
       {
        "patchline": {
         "source": [
          "obj-60",
          0
         ],
         "destination": [
          "obj-61",
          0
         ]
        }
       }
      ]
     }
    }
   },
   {
    "box": {
     "id": "obj-26",
     "maxclass": "newobj",
     "numinlets": 2,
     "numoutlets": 1,
     "patching_rect": [
      1214.0,
      486.0,
      250.0,
      22.0
     ],
     "outlettype": [
      ""
     ],
     "text": "expr int(floor($f1 * (max($i2\\, 2) - 1) + 0.5))"
    }
   },
   {
    "box": {
     "id": "obj-27",
     "maxclass": "comment",
     "numinlets": 0,
     "numoutlets": 0,
     "patching_rect": [
      1214.0,
      510.0,
      200.0,
      20.0
     ],
     "text": "\u2191 nearest file \u2192 umenu"
    }
   },
   {
    "box": {
     "id": "obj-28",
     "maxclass": "comment",
     "numinlets": 0,
     "numoutlets": 0,
     "patching_rect": [
      20.0,
      570.0,
      800.0,
      20.0
     ],
     "text": "4 \u00b7 PLAYERS \u2014 16 identical columns, one per file: [r~ pos] \u2192 play~ lft.k \u2192 \u00d7gain_k (30 ms ramp) \u2192 the mix",
     "fontface": 1
    }
   },
   {
    "box": {
     "id": "obj-29",
     "maxclass": "newobj",
     "numinlets": 0,
     "numoutlets": 1,
     "patching_rect": [
      20.0,
      596.0,
      56.0,
      22.0
     ],
     "outlettype": [
      "signal"
     ],
     "text": "r~ pos"
    }
   },
   {
    "box": {
     "id": "obj-30",
     "maxclass": "newobj",
     "numinlets": 1,
     "numoutlets": 3,
     "patching_rect": [
      20.0,
      626.0,
      68.0,
      22.0
     ],
     "outlettype": [
      "signal",
      "signal",
      "bang"
     ],
     "text": "play~ lft.1 2"
    }
   },
   {
    "box": {
     "id": "obj-31",
     "maxclass": "newobj",
     "numinlets": 2,
     "numoutlets": 1,
     "patching_rect": [
      20.0,
      656.0,
      62.0,
      22.0
     ],
     "outlettype": [
      ""
     ],
     "text": "pack f 30"
    }
   },
   {
    "box": {
     "id": "obj-32",
     "maxclass": "newobj",
     "numinlets": 2,
     "numoutlets": 2,
     "patching_rect": [
      20.0,
      686.0,
      48.0,
      22.0
     ],
     "outlettype": [
      "signal",
      "bang"
     ],
     "text": "line~"
    }
   },
   {
    "box": {
     "id": "obj-33",
     "maxclass": "newobj",
     "numinlets": 2,
     "numoutlets": 1,
     "patching_rect": [
      20.0,
      716.0,
      28.0,
      22.0
     ],
     "outlettype": [
      "signal"
     ],
     "text": "*~"
    }
   },
   {
    "box": {
     "id": "obj-34",
     "maxclass": "newobj",
     "numinlets": 2,
     "numoutlets": 1,
     "patching_rect": [
      54.0,
      716.0,
      28.0,
      22.0
     ],
     "outlettype": [
      "signal"
     ],
     "text": "*~"
    }
   },
   {
    "box": {
     "id": "obj-35",
     "maxclass": "newobj",
     "numinlets": 1,
     "numoutlets": 0,
     "patching_rect": [
      20.0,
      746.0,
      28.0,
      22.0
     ],
     "text": "s~ mixL"
    }
   },
   {
    "box": {
     "id": "obj-36",
     "maxclass": "newobj",
     "numinlets": 1,
     "numoutlets": 0,
     "patching_rect": [
      54.0,
      746.0,
      28.0,
      22.0
     ],
     "text": "s~ mixR"
    }
   },
   {
    "box": {
     "id": "obj-37",
     "maxclass": "comment",
     "numinlets": 0,
     "numoutlets": 0,
     "patching_rect": [
      44.0,
      770.0,
      30.0,
      20.0
     ],
     "text": "1"
    }
   },
   {
    "box": {
     "id": "obj-38",
     "maxclass": "newobj",
     "numinlets": 0,
     "numoutlets": 1,
     "patching_rect": [
      94.0,
      596.0,
      56.0,
      22.0
     ],
     "outlettype": [
      "signal"
     ],
     "text": "r~ pos"
    }
   },
   {
    "box": {
     "id": "obj-39",
     "maxclass": "newobj",
     "numinlets": 1,
     "numoutlets": 3,
     "patching_rect": [
      94.0,
      626.0,
      68.0,
      22.0
     ],
     "outlettype": [
      "signal",
      "signal",
      "bang"
     ],
     "text": "play~ lft.2 2"
    }
   },
   {
    "box": {
     "id": "obj-40",
     "maxclass": "newobj",
     "numinlets": 2,
     "numoutlets": 1,
     "patching_rect": [
      94.0,
      656.0,
      62.0,
      22.0
     ],
     "outlettype": [
      ""
     ],
     "text": "pack f 30"
    }
   },
   {
    "box": {
     "id": "obj-41",
     "maxclass": "newobj",
     "numinlets": 2,
     "numoutlets": 2,
     "patching_rect": [
      94.0,
      686.0,
      48.0,
      22.0
     ],
     "outlettype": [
      "signal",
      "bang"
     ],
     "text": "line~"
    }
   },
   {
    "box": {
     "id": "obj-42",
     "maxclass": "newobj",
     "numinlets": 2,
     "numoutlets": 1,
     "patching_rect": [
      94.0,
      716.0,
      28.0,
      22.0
     ],
     "outlettype": [
      "signal"
     ],
     "text": "*~"
    }
   },
   {
    "box": {
     "id": "obj-43",
     "maxclass": "newobj",
     "numinlets": 2,
     "numoutlets": 1,
     "patching_rect": [
      128.0,
      716.0,
      28.0,
      22.0
     ],
     "outlettype": [
      "signal"
     ],
     "text": "*~"
    }
   },
   {
    "box": {
     "id": "obj-44",
     "maxclass": "newobj",
     "numinlets": 1,
     "numoutlets": 0,
     "patching_rect": [
      94.0,
      746.0,
      28.0,
      22.0
     ],
     "text": "s~ mixL"
    }
   },
   {
    "box": {
     "id": "obj-45",
     "maxclass": "newobj",
     "numinlets": 1,
     "numoutlets": 0,
     "patching_rect": [
      128.0,
      746.0,
      28.0,
      22.0
     ],
     "text": "s~ mixR"
    }
   },
   {
    "box": {
     "id": "obj-46",
     "maxclass": "comment",
     "numinlets": 0,
     "numoutlets": 0,
     "patching_rect": [
      118.0,
      770.0,
      30.0,
      20.0
     ],
     "text": "2"
    }
   },
   {
    "box": {
     "id": "obj-47",
     "maxclass": "newobj",
     "numinlets": 0,
     "numoutlets": 1,
     "patching_rect": [
      168.0,
      596.0,
      56.0,
      22.0
     ],
     "outlettype": [
      "signal"
     ],
     "text": "r~ pos"
    }
   },
   {
    "box": {
     "id": "obj-48",
     "maxclass": "newobj",
     "numinlets": 1,
     "numoutlets": 3,
     "patching_rect": [
      168.0,
      626.0,
      68.0,
      22.0
     ],
     "outlettype": [
      "signal",
      "signal",
      "bang"
     ],
     "text": "play~ lft.3 2"
    }
   },
   {
    "box": {
     "id": "obj-49",
     "maxclass": "newobj",
     "numinlets": 2,
     "numoutlets": 1,
     "patching_rect": [
      168.0,
      656.0,
      62.0,
      22.0
     ],
     "outlettype": [
      ""
     ],
     "text": "pack f 30"
    }
   },
   {
    "box": {
     "id": "obj-50",
     "maxclass": "newobj",
     "numinlets": 2,
     "numoutlets": 2,
     "patching_rect": [
      168.0,
      686.0,
      48.0,
      22.0
     ],
     "outlettype": [
      "signal",
      "bang"
     ],
     "text": "line~"
    }
   },
   {
    "box": {
     "id": "obj-51",
     "maxclass": "newobj",
     "numinlets": 2,
     "numoutlets": 1,
     "patching_rect": [
      168.0,
      716.0,
      28.0,
      22.0
     ],
     "outlettype": [
      "signal"
     ],
     "text": "*~"
    }
   },
   {
    "box": {
     "id": "obj-52",
     "maxclass": "newobj",
     "numinlets": 2,
     "numoutlets": 1,
     "patching_rect": [
      202.0,
      716.0,
      28.0,
      22.0
     ],
     "outlettype": [
      "signal"
     ],
     "text": "*~"
    }
   },
   {
    "box": {
     "id": "obj-53",
     "maxclass": "newobj",
     "numinlets": 1,
     "numoutlets": 0,
     "patching_rect": [
      168.0,
      746.0,
      28.0,
      22.0
     ],
     "text": "s~ mixL"
    }
   },
   {
    "box": {
     "id": "obj-54",
     "maxclass": "newobj",
     "numinlets": 1,
     "numoutlets": 0,
     "patching_rect": [
      202.0,
      746.0,
      28.0,
      22.0
     ],
     "text": "s~ mixR"
    }
   },
   {
    "box": {
     "id": "obj-55",
     "maxclass": "comment",
     "numinlets": 0,
     "numoutlets": 0,
     "patching_rect": [
      192.0,
      770.0,
      30.0,
      20.0
     ],
     "text": "3"
    }
   },
   {
    "box": {
     "id": "obj-56",
     "maxclass": "newobj",
     "numinlets": 0,
     "numoutlets": 1,
     "patching_rect": [
      242.0,
      596.0,
      56.0,
      22.0
     ],
     "outlettype": [
      "signal"
     ],
     "text": "r~ pos"
    }
   },
   {
    "box": {
     "id": "obj-57",
     "maxclass": "newobj",
     "numinlets": 1,
     "numoutlets": 3,
     "patching_rect": [
      242.0,
      626.0,
      68.0,
      22.0
     ],
     "outlettype": [
      "signal",
      "signal",
      "bang"
     ],
     "text": "play~ lft.4 2"
    }
   },
   {
    "box": {
     "id": "obj-58",
     "maxclass": "newobj",
     "numinlets": 2,
     "numoutlets": 1,
     "patching_rect": [
      242.0,
      656.0,
      62.0,
      22.0
     ],
     "outlettype": [
      ""
     ],
     "text": "pack f 30"
    }
   },
   {
    "box": {
     "id": "obj-59",
     "maxclass": "newobj",
     "numinlets": 2,
     "numoutlets": 2,
     "patching_rect": [
      242.0,
      686.0,
      48.0,
      22.0
     ],
     "outlettype": [
      "signal",
      "bang"
     ],
     "text": "line~"
    }
   },
   {
    "box": {
     "id": "obj-60",
     "maxclass": "newobj",
     "numinlets": 2,
     "numoutlets": 1,
     "patching_rect": [
      242.0,
      716.0,
      28.0,
      22.0
     ],
     "outlettype": [
      "signal"
     ],
     "text": "*~"
    }
   },
   {
    "box": {
     "id": "obj-61",
     "maxclass": "newobj",
     "numinlets": 2,
     "numoutlets": 1,
     "patching_rect": [
      276.0,
      716.0,
      28.0,
      22.0
     ],
     "outlettype": [
      "signal"
     ],
     "text": "*~"
    }
   },
   {
    "box": {
     "id": "obj-62",
     "maxclass": "newobj",
     "numinlets": 1,
     "numoutlets": 0,
     "patching_rect": [
      242.0,
      746.0,
      28.0,
      22.0
     ],
     "text": "s~ mixL"
    }
   },
   {
    "box": {
     "id": "obj-63",
     "maxclass": "newobj",
     "numinlets": 1,
     "numoutlets": 0,
     "patching_rect": [
      276.0,
      746.0,
      28.0,
      22.0
     ],
     "text": "s~ mixR"
    }
   },
   {
    "box": {
     "id": "obj-64",
     "maxclass": "comment",
     "numinlets": 0,
     "numoutlets": 0,
     "patching_rect": [
      266.0,
      770.0,
      30.0,
      20.0
     ],
     "text": "4"
    }
   },
   {
    "box": {
     "id": "obj-65",
     "maxclass": "newobj",
     "numinlets": 0,
     "numoutlets": 1,
     "patching_rect": [
      316.0,
      596.0,
      56.0,
      22.0
     ],
     "outlettype": [
      "signal"
     ],
     "text": "r~ pos"
    }
   },
   {
    "box": {
     "id": "obj-66",
     "maxclass": "newobj",
     "numinlets": 1,
     "numoutlets": 3,
     "patching_rect": [
      316.0,
      626.0,
      68.0,
      22.0
     ],
     "outlettype": [
      "signal",
      "signal",
      "bang"
     ],
     "text": "play~ lft.5 2"
    }
   },
   {
    "box": {
     "id": "obj-67",
     "maxclass": "newobj",
     "numinlets": 2,
     "numoutlets": 1,
     "patching_rect": [
      316.0,
      656.0,
      62.0,
      22.0
     ],
     "outlettype": [
      ""
     ],
     "text": "pack f 30"
    }
   },
   {
    "box": {
     "id": "obj-68",
     "maxclass": "newobj",
     "numinlets": 2,
     "numoutlets": 2,
     "patching_rect": [
      316.0,
      686.0,
      48.0,
      22.0
     ],
     "outlettype": [
      "signal",
      "bang"
     ],
     "text": "line~"
    }
   },
   {
    "box": {
     "id": "obj-69",
     "maxclass": "newobj",
     "numinlets": 2,
     "numoutlets": 1,
     "patching_rect": [
      316.0,
      716.0,
      28.0,
      22.0
     ],
     "outlettype": [
      "signal"
     ],
     "text": "*~"
    }
   },
   {
    "box": {
     "id": "obj-70",
     "maxclass": "newobj",
     "numinlets": 2,
     "numoutlets": 1,
     "patching_rect": [
      350.0,
      716.0,
      28.0,
      22.0
     ],
     "outlettype": [
      "signal"
     ],
     "text": "*~"
    }
   },
   {
    "box": {
     "id": "obj-71",
     "maxclass": "newobj",
     "numinlets": 1,
     "numoutlets": 0,
     "patching_rect": [
      316.0,
      746.0,
      28.0,
      22.0
     ],
     "text": "s~ mixL"
    }
   },
   {
    "box": {
     "id": "obj-72",
     "maxclass": "newobj",
     "numinlets": 1,
     "numoutlets": 0,
     "patching_rect": [
      350.0,
      746.0,
      28.0,
      22.0
     ],
     "text": "s~ mixR"
    }
   },
   {
    "box": {
     "id": "obj-73",
     "maxclass": "comment",
     "numinlets": 0,
     "numoutlets": 0,
     "patching_rect": [
      340.0,
      770.0,
      30.0,
      20.0
     ],
     "text": "5"
    }
   },
   {
    "box": {
     "id": "obj-74",
     "maxclass": "newobj",
     "numinlets": 0,
     "numoutlets": 1,
     "patching_rect": [
      390.0,
      596.0,
      56.0,
      22.0
     ],
     "outlettype": [
      "signal"
     ],
     "text": "r~ pos"
    }
   },
   {
    "box": {
     "id": "obj-75",
     "maxclass": "newobj",
     "numinlets": 1,
     "numoutlets": 3,
     "patching_rect": [
      390.0,
      626.0,
      68.0,
      22.0
     ],
     "outlettype": [
      "signal",
      "signal",
      "bang"
     ],
     "text": "play~ lft.6 2"
    }
   },
   {
    "box": {
     "id": "obj-76",
     "maxclass": "newobj",
     "numinlets": 2,
     "numoutlets": 1,
     "patching_rect": [
      390.0,
      656.0,
      62.0,
      22.0
     ],
     "outlettype": [
      ""
     ],
     "text": "pack f 30"
    }
   },
   {
    "box": {
     "id": "obj-77",
     "maxclass": "newobj",
     "numinlets": 2,
     "numoutlets": 2,
     "patching_rect": [
      390.0,
      686.0,
      48.0,
      22.0
     ],
     "outlettype": [
      "signal",
      "bang"
     ],
     "text": "line~"
    }
   },
   {
    "box": {
     "id": "obj-78",
     "maxclass": "newobj",
     "numinlets": 2,
     "numoutlets": 1,
     "patching_rect": [
      390.0,
      716.0,
      28.0,
      22.0
     ],
     "outlettype": [
      "signal"
     ],
     "text": "*~"
    }
   },
   {
    "box": {
     "id": "obj-79",
     "maxclass": "newobj",
     "numinlets": 2,
     "numoutlets": 1,
     "patching_rect": [
      424.0,
      716.0,
      28.0,
      22.0
     ],
     "outlettype": [
      "signal"
     ],
     "text": "*~"
    }
   },
   {
    "box": {
     "id": "obj-80",
     "maxclass": "newobj",
     "numinlets": 1,
     "numoutlets": 0,
     "patching_rect": [
      390.0,
      746.0,
      28.0,
      22.0
     ],
     "text": "s~ mixL"
    }
   },
   {
    "box": {
     "id": "obj-81",
     "maxclass": "newobj",
     "numinlets": 1,
     "numoutlets": 0,
     "patching_rect": [
      424.0,
      746.0,
      28.0,
      22.0
     ],
     "text": "s~ mixR"
    }
   },
   {
    "box": {
     "id": "obj-82",
     "maxclass": "comment",
     "numinlets": 0,
     "numoutlets": 0,
     "patching_rect": [
      414.0,
      770.0,
      30.0,
      20.0
     ],
     "text": "6"
    }
   },
   {
    "box": {
     "id": "obj-83",
     "maxclass": "newobj",
     "numinlets": 0,
     "numoutlets": 1,
     "patching_rect": [
      464.0,
      596.0,
      56.0,
      22.0
     ],
     "outlettype": [
      "signal"
     ],
     "text": "r~ pos"
    }
   },
   {
    "box": {
     "id": "obj-84",
     "maxclass": "newobj",
     "numinlets": 1,
     "numoutlets": 3,
     "patching_rect": [
      464.0,
      626.0,
      68.0,
      22.0
     ],
     "outlettype": [
      "signal",
      "signal",
      "bang"
     ],
     "text": "play~ lft.7 2"
    }
   },
   {
    "box": {
     "id": "obj-85",
     "maxclass": "newobj",
     "numinlets": 2,
     "numoutlets": 1,
     "patching_rect": [
      464.0,
      656.0,
      62.0,
      22.0
     ],
     "outlettype": [
      ""
     ],
     "text": "pack f 30"
    }
   },
   {
    "box": {
     "id": "obj-86",
     "maxclass": "newobj",
     "numinlets": 2,
     "numoutlets": 2,
     "patching_rect": [
      464.0,
      686.0,
      48.0,
      22.0
     ],
     "outlettype": [
      "signal",
      "bang"
     ],
     "text": "line~"
    }
   },
   {
    "box": {
     "id": "obj-87",
     "maxclass": "newobj",
     "numinlets": 2,
     "numoutlets": 1,
     "patching_rect": [
      464.0,
      716.0,
      28.0,
      22.0
     ],
     "outlettype": [
      "signal"
     ],
     "text": "*~"
    }
   },
   {
    "box": {
     "id": "obj-88",
     "maxclass": "newobj",
     "numinlets": 2,
     "numoutlets": 1,
     "patching_rect": [
      498.0,
      716.0,
      28.0,
      22.0
     ],
     "outlettype": [
      "signal"
     ],
     "text": "*~"
    }
   },
   {
    "box": {
     "id": "obj-89",
     "maxclass": "newobj",
     "numinlets": 1,
     "numoutlets": 0,
     "patching_rect": [
      464.0,
      746.0,
      28.0,
      22.0
     ],
     "text": "s~ mixL"
    }
   },
   {
    "box": {
     "id": "obj-90",
     "maxclass": "newobj",
     "numinlets": 1,
     "numoutlets": 0,
     "patching_rect": [
      498.0,
      746.0,
      28.0,
      22.0
     ],
     "text": "s~ mixR"
    }
   },
   {
    "box": {
     "id": "obj-91",
     "maxclass": "comment",
     "numinlets": 0,
     "numoutlets": 0,
     "patching_rect": [
      488.0,
      770.0,
      30.0,
      20.0
     ],
     "text": "7"
    }
   },
   {
    "box": {
     "id": "obj-92",
     "maxclass": "newobj",
     "numinlets": 0,
     "numoutlets": 1,
     "patching_rect": [
      538.0,
      596.0,
      56.0,
      22.0
     ],
     "outlettype": [
      "signal"
     ],
     "text": "r~ pos"
    }
   },
   {
    "box": {
     "id": "obj-93",
     "maxclass": "newobj",
     "numinlets": 1,
     "numoutlets": 3,
     "patching_rect": [
      538.0,
      626.0,
      68.0,
      22.0
     ],
     "outlettype": [
      "signal",
      "signal",
      "bang"
     ],
     "text": "play~ lft.8 2"
    }
   },
   {
    "box": {
     "id": "obj-94",
     "maxclass": "newobj",
     "numinlets": 2,
     "numoutlets": 1,
     "patching_rect": [
      538.0,
      656.0,
      62.0,
      22.0
     ],
     "outlettype": [
      ""
     ],
     "text": "pack f 30"
    }
   },
   {
    "box": {
     "id": "obj-95",
     "maxclass": "newobj",
     "numinlets": 2,
     "numoutlets": 2,
     "patching_rect": [
      538.0,
      686.0,
      48.0,
      22.0
     ],
     "outlettype": [
      "signal",
      "bang"
     ],
     "text": "line~"
    }
   },
   {
    "box": {
     "id": "obj-96",
     "maxclass": "newobj",
     "numinlets": 2,
     "numoutlets": 1,
     "patching_rect": [
      538.0,
      716.0,
      28.0,
      22.0
     ],
     "outlettype": [
      "signal"
     ],
     "text": "*~"
    }
   },
   {
    "box": {
     "id": "obj-97",
     "maxclass": "newobj",
     "numinlets": 2,
     "numoutlets": 1,
     "patching_rect": [
      572.0,
      716.0,
      28.0,
      22.0
     ],
     "outlettype": [
      "signal"
     ],
     "text": "*~"
    }
   },
   {
    "box": {
     "id": "obj-98",
     "maxclass": "newobj",
     "numinlets": 1,
     "numoutlets": 0,
     "patching_rect": [
      538.0,
      746.0,
      28.0,
      22.0
     ],
     "text": "s~ mixL"
    }
   },
   {
    "box": {
     "id": "obj-99",
     "maxclass": "newobj",
     "numinlets": 1,
     "numoutlets": 0,
     "patching_rect": [
      572.0,
      746.0,
      28.0,
      22.0
     ],
     "text": "s~ mixR"
    }
   },
   {
    "box": {
     "id": "obj-100",
     "maxclass": "comment",
     "numinlets": 0,
     "numoutlets": 0,
     "patching_rect": [
      562.0,
      770.0,
      30.0,
      20.0
     ],
     "text": "8"
    }
   },
   {
    "box": {
     "id": "obj-101",
     "maxclass": "newobj",
     "numinlets": 0,
     "numoutlets": 1,
     "patching_rect": [
      612.0,
      596.0,
      56.0,
      22.0
     ],
     "outlettype": [
      "signal"
     ],
     "text": "r~ pos"
    }
   },
   {
    "box": {
     "id": "obj-102",
     "maxclass": "newobj",
     "numinlets": 1,
     "numoutlets": 3,
     "patching_rect": [
      612.0,
      626.0,
      68.0,
      22.0
     ],
     "outlettype": [
      "signal",
      "signal",
      "bang"
     ],
     "text": "play~ lft.9 2"
    }
   },
   {
    "box": {
     "id": "obj-103",
     "maxclass": "newobj",
     "numinlets": 2,
     "numoutlets": 1,
     "patching_rect": [
      612.0,
      656.0,
      62.0,
      22.0
     ],
     "outlettype": [
      ""
     ],
     "text": "pack f 30"
    }
   },
   {
    "box": {
     "id": "obj-104",
     "maxclass": "newobj",
     "numinlets": 2,
     "numoutlets": 2,
     "patching_rect": [
      612.0,
      686.0,
      48.0,
      22.0
     ],
     "outlettype": [
      "signal",
      "bang"
     ],
     "text": "line~"
    }
   },
   {
    "box": {
     "id": "obj-105",
     "maxclass": "newobj",
     "numinlets": 2,
     "numoutlets": 1,
     "patching_rect": [
      612.0,
      716.0,
      28.0,
      22.0
     ],
     "outlettype": [
      "signal"
     ],
     "text": "*~"
    }
   },
   {
    "box": {
     "id": "obj-106",
     "maxclass": "newobj",
     "numinlets": 2,
     "numoutlets": 1,
     "patching_rect": [
      646.0,
      716.0,
      28.0,
      22.0
     ],
     "outlettype": [
      "signal"
     ],
     "text": "*~"
    }
   },
   {
    "box": {
     "id": "obj-107",
     "maxclass": "newobj",
     "numinlets": 1,
     "numoutlets": 0,
     "patching_rect": [
      612.0,
      746.0,
      28.0,
      22.0
     ],
     "text": "s~ mixL"
    }
   },
   {
    "box": {
     "id": "obj-108",
     "maxclass": "newobj",
     "numinlets": 1,
     "numoutlets": 0,
     "patching_rect": [
      646.0,
      746.0,
      28.0,
      22.0
     ],
     "text": "s~ mixR"
    }
   },
   {
    "box": {
     "id": "obj-109",
     "maxclass": "comment",
     "numinlets": 0,
     "numoutlets": 0,
     "patching_rect": [
      636.0,
      770.0,
      30.0,
      20.0
     ],
     "text": "9"
    }
   },
   {
    "box": {
     "id": "obj-110",
     "maxclass": "newobj",
     "numinlets": 0,
     "numoutlets": 1,
     "patching_rect": [
      686.0,
      596.0,
      56.0,
      22.0
     ],
     "outlettype": [
      "signal"
     ],
     "text": "r~ pos"
    }
   },
   {
    "box": {
     "id": "obj-111",
     "maxclass": "newobj",
     "numinlets": 1,
     "numoutlets": 3,
     "patching_rect": [
      686.0,
      626.0,
      68.0,
      22.0
     ],
     "outlettype": [
      "signal",
      "signal",
      "bang"
     ],
     "text": "play~ lft.10 2"
    }
   },
   {
    "box": {
     "id": "obj-112",
     "maxclass": "newobj",
     "numinlets": 2,
     "numoutlets": 1,
     "patching_rect": [
      686.0,
      656.0,
      62.0,
      22.0
     ],
     "outlettype": [
      ""
     ],
     "text": "pack f 30"
    }
   },
   {
    "box": {
     "id": "obj-113",
     "maxclass": "newobj",
     "numinlets": 2,
     "numoutlets": 2,
     "patching_rect": [
      686.0,
      686.0,
      48.0,
      22.0
     ],
     "outlettype": [
      "signal",
      "bang"
     ],
     "text": "line~"
    }
   },
   {
    "box": {
     "id": "obj-114",
     "maxclass": "newobj",
     "numinlets": 2,
     "numoutlets": 1,
     "patching_rect": [
      686.0,
      716.0,
      28.0,
      22.0
     ],
     "outlettype": [
      "signal"
     ],
     "text": "*~"
    }
   },
   {
    "box": {
     "id": "obj-115",
     "maxclass": "newobj",
     "numinlets": 2,
     "numoutlets": 1,
     "patching_rect": [
      720.0,
      716.0,
      28.0,
      22.0
     ],
     "outlettype": [
      "signal"
     ],
     "text": "*~"
    }
   },
   {
    "box": {
     "id": "obj-116",
     "maxclass": "newobj",
     "numinlets": 1,
     "numoutlets": 0,
     "patching_rect": [
      686.0,
      746.0,
      28.0,
      22.0
     ],
     "text": "s~ mixL"
    }
   },
   {
    "box": {
     "id": "obj-117",
     "maxclass": "newobj",
     "numinlets": 1,
     "numoutlets": 0,
     "patching_rect": [
      720.0,
      746.0,
      28.0,
      22.0
     ],
     "text": "s~ mixR"
    }
   },
   {
    "box": {
     "id": "obj-118",
     "maxclass": "comment",
     "numinlets": 0,
     "numoutlets": 0,
     "patching_rect": [
      710.0,
      770.0,
      30.0,
      20.0
     ],
     "text": "10"
    }
   },
   {
    "box": {
     "id": "obj-119",
     "maxclass": "newobj",
     "numinlets": 0,
     "numoutlets": 1,
     "patching_rect": [
      760.0,
      596.0,
      56.0,
      22.0
     ],
     "outlettype": [
      "signal"
     ],
     "text": "r~ pos"
    }
   },
   {
    "box": {
     "id": "obj-120",
     "maxclass": "newobj",
     "numinlets": 1,
     "numoutlets": 3,
     "patching_rect": [
      760.0,
      626.0,
      68.0,
      22.0
     ],
     "outlettype": [
      "signal",
      "signal",
      "bang"
     ],
     "text": "play~ lft.11 2"
    }
   },
   {
    "box": {
     "id": "obj-121",
     "maxclass": "newobj",
     "numinlets": 2,
     "numoutlets": 1,
     "patching_rect": [
      760.0,
      656.0,
      62.0,
      22.0
     ],
     "outlettype": [
      ""
     ],
     "text": "pack f 30"
    }
   },
   {
    "box": {
     "id": "obj-122",
     "maxclass": "newobj",
     "numinlets": 2,
     "numoutlets": 2,
     "patching_rect": [
      760.0,
      686.0,
      48.0,
      22.0
     ],
     "outlettype": [
      "signal",
      "bang"
     ],
     "text": "line~"
    }
   },
   {
    "box": {
     "id": "obj-123",
     "maxclass": "newobj",
     "numinlets": 2,
     "numoutlets": 1,
     "patching_rect": [
      760.0,
      716.0,
      28.0,
      22.0
     ],
     "outlettype": [
      "signal"
     ],
     "text": "*~"
    }
   },
   {
    "box": {
     "id": "obj-124",
     "maxclass": "newobj",
     "numinlets": 2,
     "numoutlets": 1,
     "patching_rect": [
      794.0,
      716.0,
      28.0,
      22.0
     ],
     "outlettype": [
      "signal"
     ],
     "text": "*~"
    }
   },
   {
    "box": {
     "id": "obj-125",
     "maxclass": "newobj",
     "numinlets": 1,
     "numoutlets": 0,
     "patching_rect": [
      760.0,
      746.0,
      28.0,
      22.0
     ],
     "text": "s~ mixL"
    }
   },
   {
    "box": {
     "id": "obj-126",
     "maxclass": "newobj",
     "numinlets": 1,
     "numoutlets": 0,
     "patching_rect": [
      794.0,
      746.0,
      28.0,
      22.0
     ],
     "text": "s~ mixR"
    }
   },
   {
    "box": {
     "id": "obj-127",
     "maxclass": "comment",
     "numinlets": 0,
     "numoutlets": 0,
     "patching_rect": [
      784.0,
      770.0,
      30.0,
      20.0
     ],
     "text": "11"
    }
   },
   {
    "box": {
     "id": "obj-128",
     "maxclass": "newobj",
     "numinlets": 0,
     "numoutlets": 1,
     "patching_rect": [
      834.0,
      596.0,
      56.0,
      22.0
     ],
     "outlettype": [
      "signal"
     ],
     "text": "r~ pos"
    }
   },
   {
    "box": {
     "id": "obj-129",
     "maxclass": "newobj",
     "numinlets": 1,
     "numoutlets": 3,
     "patching_rect": [
      834.0,
      626.0,
      68.0,
      22.0
     ],
     "outlettype": [
      "signal",
      "signal",
      "bang"
     ],
     "text": "play~ lft.12 2"
    }
   },
   {
    "box": {
     "id": "obj-130",
     "maxclass": "newobj",
     "numinlets": 2,
     "numoutlets": 1,
     "patching_rect": [
      834.0,
      656.0,
      62.0,
      22.0
     ],
     "outlettype": [
      ""
     ],
     "text": "pack f 30"
    }
   },
   {
    "box": {
     "id": "obj-131",
     "maxclass": "newobj",
     "numinlets": 2,
     "numoutlets": 2,
     "patching_rect": [
      834.0,
      686.0,
      48.0,
      22.0
     ],
     "outlettype": [
      "signal",
      "bang"
     ],
     "text": "line~"
    }
   },
   {
    "box": {
     "id": "obj-132",
     "maxclass": "newobj",
     "numinlets": 2,
     "numoutlets": 1,
     "patching_rect": [
      834.0,
      716.0,
      28.0,
      22.0
     ],
     "outlettype": [
      "signal"
     ],
     "text": "*~"
    }
   },
   {
    "box": {
     "id": "obj-133",
     "maxclass": "newobj",
     "numinlets": 2,
     "numoutlets": 1,
     "patching_rect": [
      868.0,
      716.0,
      28.0,
      22.0
     ],
     "outlettype": [
      "signal"
     ],
     "text": "*~"
    }
   },
   {
    "box": {
     "id": "obj-134",
     "maxclass": "newobj",
     "numinlets": 1,
     "numoutlets": 0,
     "patching_rect": [
      834.0,
      746.0,
      28.0,
      22.0
     ],
     "text": "s~ mixL"
    }
   },
   {
    "box": {
     "id": "obj-135",
     "maxclass": "newobj",
     "numinlets": 1,
     "numoutlets": 0,
     "patching_rect": [
      868.0,
      746.0,
      28.0,
      22.0
     ],
     "text": "s~ mixR"
    }
   },
   {
    "box": {
     "id": "obj-136",
     "maxclass": "comment",
     "numinlets": 0,
     "numoutlets": 0,
     "patching_rect": [
      858.0,
      770.0,
      30.0,
      20.0
     ],
     "text": "12"
    }
   },
   {
    "box": {
     "id": "obj-137",
     "maxclass": "newobj",
     "numinlets": 0,
     "numoutlets": 1,
     "patching_rect": [
      908.0,
      596.0,
      56.0,
      22.0
     ],
     "outlettype": [
      "signal"
     ],
     "text": "r~ pos"
    }
   },
   {
    "box": {
     "id": "obj-138",
     "maxclass": "newobj",
     "numinlets": 1,
     "numoutlets": 3,
     "patching_rect": [
      908.0,
      626.0,
      68.0,
      22.0
     ],
     "outlettype": [
      "signal",
      "signal",
      "bang"
     ],
     "text": "play~ lft.13 2"
    }
   },
   {
    "box": {
     "id": "obj-139",
     "maxclass": "newobj",
     "numinlets": 2,
     "numoutlets": 1,
     "patching_rect": [
      908.0,
      656.0,
      62.0,
      22.0
     ],
     "outlettype": [
      ""
     ],
     "text": "pack f 30"
    }
   },
   {
    "box": {
     "id": "obj-140",
     "maxclass": "newobj",
     "numinlets": 2,
     "numoutlets": 2,
     "patching_rect": [
      908.0,
      686.0,
      48.0,
      22.0
     ],
     "outlettype": [
      "signal",
      "bang"
     ],
     "text": "line~"
    }
   },
   {
    "box": {
     "id": "obj-141",
     "maxclass": "newobj",
     "numinlets": 2,
     "numoutlets": 1,
     "patching_rect": [
      908.0,
      716.0,
      28.0,
      22.0
     ],
     "outlettype": [
      "signal"
     ],
     "text": "*~"
    }
   },
   {
    "box": {
     "id": "obj-142",
     "maxclass": "newobj",
     "numinlets": 2,
     "numoutlets": 1,
     "patching_rect": [
      942.0,
      716.0,
      28.0,
      22.0
     ],
     "outlettype": [
      "signal"
     ],
     "text": "*~"
    }
   },
   {
    "box": {
     "id": "obj-143",
     "maxclass": "newobj",
     "numinlets": 1,
     "numoutlets": 0,
     "patching_rect": [
      908.0,
      746.0,
      28.0,
      22.0
     ],
     "text": "s~ mixL"
    }
   },
   {
    "box": {
     "id": "obj-144",
     "maxclass": "newobj",
     "numinlets": 1,
     "numoutlets": 0,
     "patching_rect": [
      942.0,
      746.0,
      28.0,
      22.0
     ],
     "text": "s~ mixR"
    }
   },
   {
    "box": {
     "id": "obj-145",
     "maxclass": "comment",
     "numinlets": 0,
     "numoutlets": 0,
     "patching_rect": [
      932.0,
      770.0,
      30.0,
      20.0
     ],
     "text": "13"
    }
   },
   {
    "box": {
     "id": "obj-146",
     "maxclass": "newobj",
     "numinlets": 0,
     "numoutlets": 1,
     "patching_rect": [
      982.0,
      596.0,
      56.0,
      22.0
     ],
     "outlettype": [
      "signal"
     ],
     "text": "r~ pos"
    }
   },
   {
    "box": {
     "id": "obj-147",
     "maxclass": "newobj",
     "numinlets": 1,
     "numoutlets": 3,
     "patching_rect": [
      982.0,
      626.0,
      68.0,
      22.0
     ],
     "outlettype": [
      "signal",
      "signal",
      "bang"
     ],
     "text": "play~ lft.14 2"
    }
   },
   {
    "box": {
     "id": "obj-148",
     "maxclass": "newobj",
     "numinlets": 2,
     "numoutlets": 1,
     "patching_rect": [
      982.0,
      656.0,
      62.0,
      22.0
     ],
     "outlettype": [
      ""
     ],
     "text": "pack f 30"
    }
   },
   {
    "box": {
     "id": "obj-149",
     "maxclass": "newobj",
     "numinlets": 2,
     "numoutlets": 2,
     "patching_rect": [
      982.0,
      686.0,
      48.0,
      22.0
     ],
     "outlettype": [
      "signal",
      "bang"
     ],
     "text": "line~"
    }
   },
   {
    "box": {
     "id": "obj-150",
     "maxclass": "newobj",
     "numinlets": 2,
     "numoutlets": 1,
     "patching_rect": [
      982.0,
      716.0,
      28.0,
      22.0
     ],
     "outlettype": [
      "signal"
     ],
     "text": "*~"
    }
   },
   {
    "box": {
     "id": "obj-151",
     "maxclass": "newobj",
     "numinlets": 2,
     "numoutlets": 1,
     "patching_rect": [
      1016.0,
      716.0,
      28.0,
      22.0
     ],
     "outlettype": [
      "signal"
     ],
     "text": "*~"
    }
   },
   {
    "box": {
     "id": "obj-152",
     "maxclass": "newobj",
     "numinlets": 1,
     "numoutlets": 0,
     "patching_rect": [
      982.0,
      746.0,
      28.0,
      22.0
     ],
     "text": "s~ mixL"
    }
   },
   {
    "box": {
     "id": "obj-153",
     "maxclass": "newobj",
     "numinlets": 1,
     "numoutlets": 0,
     "patching_rect": [
      1016.0,
      746.0,
      28.0,
      22.0
     ],
     "text": "s~ mixR"
    }
   },
   {
    "box": {
     "id": "obj-154",
     "maxclass": "comment",
     "numinlets": 0,
     "numoutlets": 0,
     "patching_rect": [
      1006.0,
      770.0,
      30.0,
      20.0
     ],
     "text": "14"
    }
   },
   {
    "box": {
     "id": "obj-155",
     "maxclass": "newobj",
     "numinlets": 0,
     "numoutlets": 1,
     "patching_rect": [
      1056.0,
      596.0,
      56.0,
      22.0
     ],
     "outlettype": [
      "signal"
     ],
     "text": "r~ pos"
    }
   },
   {
    "box": {
     "id": "obj-156",
     "maxclass": "newobj",
     "numinlets": 1,
     "numoutlets": 3,
     "patching_rect": [
      1056.0,
      626.0,
      68.0,
      22.0
     ],
     "outlettype": [
      "signal",
      "signal",
      "bang"
     ],
     "text": "play~ lft.15 2"
    }
   },
   {
    "box": {
     "id": "obj-157",
     "maxclass": "newobj",
     "numinlets": 2,
     "numoutlets": 1,
     "patching_rect": [
      1056.0,
      656.0,
      62.0,
      22.0
     ],
     "outlettype": [
      ""
     ],
     "text": "pack f 30"
    }
   },
   {
    "box": {
     "id": "obj-158",
     "maxclass": "newobj",
     "numinlets": 2,
     "numoutlets": 2,
     "patching_rect": [
      1056.0,
      686.0,
      48.0,
      22.0
     ],
     "outlettype": [
      "signal",
      "bang"
     ],
     "text": "line~"
    }
   },
   {
    "box": {
     "id": "obj-159",
     "maxclass": "newobj",
     "numinlets": 2,
     "numoutlets": 1,
     "patching_rect": [
      1056.0,
      716.0,
      28.0,
      22.0
     ],
     "outlettype": [
      "signal"
     ],
     "text": "*~"
    }
   },
   {
    "box": {
     "id": "obj-160",
     "maxclass": "newobj",
     "numinlets": 2,
     "numoutlets": 1,
     "patching_rect": [
      1090.0,
      716.0,
      28.0,
      22.0
     ],
     "outlettype": [
      "signal"
     ],
     "text": "*~"
    }
   },
   {
    "box": {
     "id": "obj-161",
     "maxclass": "newobj",
     "numinlets": 1,
     "numoutlets": 0,
     "patching_rect": [
      1056.0,
      746.0,
      28.0,
      22.0
     ],
     "text": "s~ mixL"
    }
   },
   {
    "box": {
     "id": "obj-162",
     "maxclass": "newobj",
     "numinlets": 1,
     "numoutlets": 0,
     "patching_rect": [
      1090.0,
      746.0,
      28.0,
      22.0
     ],
     "text": "s~ mixR"
    }
   },
   {
    "box": {
     "id": "obj-163",
     "maxclass": "comment",
     "numinlets": 0,
     "numoutlets": 0,
     "patching_rect": [
      1080.0,
      770.0,
      30.0,
      20.0
     ],
     "text": "15"
    }
   },
   {
    "box": {
     "id": "obj-164",
     "maxclass": "newobj",
     "numinlets": 0,
     "numoutlets": 1,
     "patching_rect": [
      1130.0,
      596.0,
      56.0,
      22.0
     ],
     "outlettype": [
      "signal"
     ],
     "text": "r~ pos"
    }
   },
   {
    "box": {
     "id": "obj-165",
     "maxclass": "newobj",
     "numinlets": 1,
     "numoutlets": 3,
     "patching_rect": [
      1130.0,
      626.0,
      68.0,
      22.0
     ],
     "outlettype": [
      "signal",
      "signal",
      "bang"
     ],
     "text": "play~ lft.16 2"
    }
   },
   {
    "box": {
     "id": "obj-166",
     "maxclass": "newobj",
     "numinlets": 2,
     "numoutlets": 1,
     "patching_rect": [
      1130.0,
      656.0,
      62.0,
      22.0
     ],
     "outlettype": [
      ""
     ],
     "text": "pack f 30"
    }
   },
   {
    "box": {
     "id": "obj-167",
     "maxclass": "newobj",
     "numinlets": 2,
     "numoutlets": 2,
     "patching_rect": [
      1130.0,
      686.0,
      48.0,
      22.0
     ],
     "outlettype": [
      "signal",
      "bang"
     ],
     "text": "line~"
    }
   },
   {
    "box": {
     "id": "obj-168",
     "maxclass": "newobj",
     "numinlets": 2,
     "numoutlets": 1,
     "patching_rect": [
      1130.0,
      716.0,
      28.0,
      22.0
     ],
     "outlettype": [
      "signal"
     ],
     "text": "*~"
    }
   },
   {
    "box": {
     "id": "obj-169",
     "maxclass": "newobj",
     "numinlets": 2,
     "numoutlets": 1,
     "patching_rect": [
      1164.0,
      716.0,
      28.0,
      22.0
     ],
     "outlettype": [
      "signal"
     ],
     "text": "*~"
    }
   },
   {
    "box": {
     "id": "obj-170",
     "maxclass": "newobj",
     "numinlets": 1,
     "numoutlets": 0,
     "patching_rect": [
      1130.0,
      746.0,
      28.0,
      22.0
     ],
     "text": "s~ mixL"
    }
   },
   {
    "box": {
     "id": "obj-171",
     "maxclass": "newobj",
     "numinlets": 1,
     "numoutlets": 0,
     "patching_rect": [
      1164.0,
      746.0,
      28.0,
      22.0
     ],
     "text": "s~ mixR"
    }
   },
   {
    "box": {
     "id": "obj-172",
     "maxclass": "comment",
     "numinlets": 0,
     "numoutlets": 0,
     "patching_rect": [
      1154.0,
      770.0,
      30.0,
      20.0
     ],
     "text": "16"
    }
   },
   {
    "box": {
     "id": "obj-173",
     "maxclass": "comment",
     "numinlets": 0,
     "numoutlets": 0,
     "patching_rect": [
      20.0,
      805.0,
      400.0,
      20.0
     ],
     "text": "5 \u00b7 OUT \u2014 the columns sum into the mix",
     "fontface": 1
    }
   },
   {
    "box": {
     "id": "obj-174",
     "maxclass": "newobj",
     "numinlets": 0,
     "numoutlets": 1,
     "patching_rect": [
      20.0,
      831.0,
      60.0,
      22.0
     ],
     "outlettype": [
      "signal"
     ],
     "text": "r~ mixL"
    }
   },
   {
    "box": {
     "id": "obj-175",
     "maxclass": "newobj",
     "numinlets": 0,
     "numoutlets": 1,
     "patching_rect": [
      90.0,
      831.0,
      60.0,
      22.0
     ],
     "outlettype": [
      "signal"
     ],
     "text": "r~ mixR"
    }
   },
   {
    "box": {
     "id": "obj-176",
     "maxclass": "live.gain~",
     "numinlets": 2,
     "numoutlets": 5,
     "patching_rect": [
      20.0,
      861.0,
      120.0,
      90.0
     ],
     "outlettype": [
      "signal",
      "signal",
      "",
      "",
      "list"
     ],
     "parameter_enable": 1,
     "saved_attribute_attributes": {
      "valueof": {
       "parameter_longname": "master",
       "parameter_shortname": "master",
       "parameter_type": 0,
       "parameter_mmin": -70.0,
       "parameter_mmax": 6.0,
       "parameter_initial": [
        -6.0
       ],
       "parameter_initial_enable": 1,
       "parameter_unitstyle": 4
      }
     }
    }
   },
   {
    "box": {
     "id": "obj-177",
     "maxclass": "ezdac~",
     "numinlets": 2,
     "numoutlets": 0,
     "patching_rect": [
      160.0,
      885.0,
      45.0,
      45.0
     ]
    }
   },
   {
    "box": {
     "id": "obj-178",
     "maxclass": "comment",
     "numinlets": 0,
     "numoutlets": 0,
     "patching_rect": [
      215.0,
      897.0,
      560.0,
      20.0
     ],
     "text": "\u2190 start audio. Load a folder, move the slider, listen; then put your sensor on the slider."
    }
   }
  ],
  "lines": [
   {
    "patchline": {
     "source": [
      "obj-4",
      0
     ],
     "destination": [
      "obj-6",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-6",
      0
     ],
     "destination": [
      "obj-9",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-7",
      0
     ],
     "destination": [
      "obj-9",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-9",
      0
     ],
     "destination": [
      "obj-11",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-9",
      1
     ],
     "destination": [
      "obj-13",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-9",
      2
     ],
     "destination": [
      "obj-15",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-11",
      0
     ],
     "destination": [
      "obj-18",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-18",
      0
     ],
     "destination": [
      "obj-19",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-19",
      0
     ],
     "destination": [
      "obj-20",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-11",
      0
     ],
     "destination": [
      "obj-20",
      1
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-20",
      0
     ],
     "destination": [
      "obj-21",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-24",
      0
     ],
     "destination": [
      "obj-25",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-15",
      0
     ],
     "destination": [
      "obj-25",
      1
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-24",
      0
     ],
     "destination": [
      "obj-26",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-15",
      0
     ],
     "destination": [
      "obj-26",
      1
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-26",
      0
     ],
     "destination": [
      "obj-13",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-29",
      0
     ],
     "destination": [
      "obj-30",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-25",
      0
     ],
     "destination": [
      "obj-31",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-31",
      0
     ],
     "destination": [
      "obj-32",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-30",
      0
     ],
     "destination": [
      "obj-33",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-30",
      1
     ],
     "destination": [
      "obj-34",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-32",
      0
     ],
     "destination": [
      "obj-33",
      1
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-32",
      0
     ],
     "destination": [
      "obj-34",
      1
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-33",
      0
     ],
     "destination": [
      "obj-35",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-34",
      0
     ],
     "destination": [
      "obj-36",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-38",
      0
     ],
     "destination": [
      "obj-39",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-25",
      1
     ],
     "destination": [
      "obj-40",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-40",
      0
     ],
     "destination": [
      "obj-41",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-39",
      0
     ],
     "destination": [
      "obj-42",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-39",
      1
     ],
     "destination": [
      "obj-43",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-41",
      0
     ],
     "destination": [
      "obj-42",
      1
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-41",
      0
     ],
     "destination": [
      "obj-43",
      1
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-42",
      0
     ],
     "destination": [
      "obj-44",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-43",
      0
     ],
     "destination": [
      "obj-45",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-47",
      0
     ],
     "destination": [
      "obj-48",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-25",
      2
     ],
     "destination": [
      "obj-49",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-49",
      0
     ],
     "destination": [
      "obj-50",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-48",
      0
     ],
     "destination": [
      "obj-51",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-48",
      1
     ],
     "destination": [
      "obj-52",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-50",
      0
     ],
     "destination": [
      "obj-51",
      1
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-50",
      0
     ],
     "destination": [
      "obj-52",
      1
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-51",
      0
     ],
     "destination": [
      "obj-53",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-52",
      0
     ],
     "destination": [
      "obj-54",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-56",
      0
     ],
     "destination": [
      "obj-57",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-25",
      3
     ],
     "destination": [
      "obj-58",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-58",
      0
     ],
     "destination": [
      "obj-59",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-57",
      0
     ],
     "destination": [
      "obj-60",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-57",
      1
     ],
     "destination": [
      "obj-61",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-59",
      0
     ],
     "destination": [
      "obj-60",
      1
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-59",
      0
     ],
     "destination": [
      "obj-61",
      1
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-60",
      0
     ],
     "destination": [
      "obj-62",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-61",
      0
     ],
     "destination": [
      "obj-63",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-65",
      0
     ],
     "destination": [
      "obj-66",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-25",
      4
     ],
     "destination": [
      "obj-67",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-67",
      0
     ],
     "destination": [
      "obj-68",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-66",
      0
     ],
     "destination": [
      "obj-69",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-66",
      1
     ],
     "destination": [
      "obj-70",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-68",
      0
     ],
     "destination": [
      "obj-69",
      1
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-68",
      0
     ],
     "destination": [
      "obj-70",
      1
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-69",
      0
     ],
     "destination": [
      "obj-71",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-70",
      0
     ],
     "destination": [
      "obj-72",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-74",
      0
     ],
     "destination": [
      "obj-75",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-25",
      5
     ],
     "destination": [
      "obj-76",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-76",
      0
     ],
     "destination": [
      "obj-77",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-75",
      0
     ],
     "destination": [
      "obj-78",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-75",
      1
     ],
     "destination": [
      "obj-79",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-77",
      0
     ],
     "destination": [
      "obj-78",
      1
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-77",
      0
     ],
     "destination": [
      "obj-79",
      1
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-78",
      0
     ],
     "destination": [
      "obj-80",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-79",
      0
     ],
     "destination": [
      "obj-81",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-83",
      0
     ],
     "destination": [
      "obj-84",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-25",
      6
     ],
     "destination": [
      "obj-85",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-85",
      0
     ],
     "destination": [
      "obj-86",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-84",
      0
     ],
     "destination": [
      "obj-87",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-84",
      1
     ],
     "destination": [
      "obj-88",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-86",
      0
     ],
     "destination": [
      "obj-87",
      1
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-86",
      0
     ],
     "destination": [
      "obj-88",
      1
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-87",
      0
     ],
     "destination": [
      "obj-89",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-88",
      0
     ],
     "destination": [
      "obj-90",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-92",
      0
     ],
     "destination": [
      "obj-93",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-25",
      7
     ],
     "destination": [
      "obj-94",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-94",
      0
     ],
     "destination": [
      "obj-95",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-93",
      0
     ],
     "destination": [
      "obj-96",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-93",
      1
     ],
     "destination": [
      "obj-97",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-95",
      0
     ],
     "destination": [
      "obj-96",
      1
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-95",
      0
     ],
     "destination": [
      "obj-97",
      1
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-96",
      0
     ],
     "destination": [
      "obj-98",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-97",
      0
     ],
     "destination": [
      "obj-99",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-101",
      0
     ],
     "destination": [
      "obj-102",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-25",
      8
     ],
     "destination": [
      "obj-103",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-103",
      0
     ],
     "destination": [
      "obj-104",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-102",
      0
     ],
     "destination": [
      "obj-105",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-102",
      1
     ],
     "destination": [
      "obj-106",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-104",
      0
     ],
     "destination": [
      "obj-105",
      1
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-104",
      0
     ],
     "destination": [
      "obj-106",
      1
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-105",
      0
     ],
     "destination": [
      "obj-107",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-106",
      0
     ],
     "destination": [
      "obj-108",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-110",
      0
     ],
     "destination": [
      "obj-111",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-25",
      9
     ],
     "destination": [
      "obj-112",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-112",
      0
     ],
     "destination": [
      "obj-113",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-111",
      0
     ],
     "destination": [
      "obj-114",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-111",
      1
     ],
     "destination": [
      "obj-115",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-113",
      0
     ],
     "destination": [
      "obj-114",
      1
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-113",
      0
     ],
     "destination": [
      "obj-115",
      1
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-114",
      0
     ],
     "destination": [
      "obj-116",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-115",
      0
     ],
     "destination": [
      "obj-117",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-119",
      0
     ],
     "destination": [
      "obj-120",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-25",
      10
     ],
     "destination": [
      "obj-121",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-121",
      0
     ],
     "destination": [
      "obj-122",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-120",
      0
     ],
     "destination": [
      "obj-123",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-120",
      1
     ],
     "destination": [
      "obj-124",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-122",
      0
     ],
     "destination": [
      "obj-123",
      1
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-122",
      0
     ],
     "destination": [
      "obj-124",
      1
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-123",
      0
     ],
     "destination": [
      "obj-125",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-124",
      0
     ],
     "destination": [
      "obj-126",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-128",
      0
     ],
     "destination": [
      "obj-129",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-25",
      11
     ],
     "destination": [
      "obj-130",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-130",
      0
     ],
     "destination": [
      "obj-131",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-129",
      0
     ],
     "destination": [
      "obj-132",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-129",
      1
     ],
     "destination": [
      "obj-133",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-131",
      0
     ],
     "destination": [
      "obj-132",
      1
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-131",
      0
     ],
     "destination": [
      "obj-133",
      1
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-132",
      0
     ],
     "destination": [
      "obj-134",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-133",
      0
     ],
     "destination": [
      "obj-135",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-137",
      0
     ],
     "destination": [
      "obj-138",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-25",
      12
     ],
     "destination": [
      "obj-139",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-139",
      0
     ],
     "destination": [
      "obj-140",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-138",
      0
     ],
     "destination": [
      "obj-141",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-138",
      1
     ],
     "destination": [
      "obj-142",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-140",
      0
     ],
     "destination": [
      "obj-141",
      1
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-140",
      0
     ],
     "destination": [
      "obj-142",
      1
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-141",
      0
     ],
     "destination": [
      "obj-143",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-142",
      0
     ],
     "destination": [
      "obj-144",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-146",
      0
     ],
     "destination": [
      "obj-147",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-25",
      13
     ],
     "destination": [
      "obj-148",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-148",
      0
     ],
     "destination": [
      "obj-149",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-147",
      0
     ],
     "destination": [
      "obj-150",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-147",
      1
     ],
     "destination": [
      "obj-151",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-149",
      0
     ],
     "destination": [
      "obj-150",
      1
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-149",
      0
     ],
     "destination": [
      "obj-151",
      1
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-150",
      0
     ],
     "destination": [
      "obj-152",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-151",
      0
     ],
     "destination": [
      "obj-153",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-155",
      0
     ],
     "destination": [
      "obj-156",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-25",
      14
     ],
     "destination": [
      "obj-157",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-157",
      0
     ],
     "destination": [
      "obj-158",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-156",
      0
     ],
     "destination": [
      "obj-159",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-156",
      1
     ],
     "destination": [
      "obj-160",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-158",
      0
     ],
     "destination": [
      "obj-159",
      1
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-158",
      0
     ],
     "destination": [
      "obj-160",
      1
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-159",
      0
     ],
     "destination": [
      "obj-161",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-160",
      0
     ],
     "destination": [
      "obj-162",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-164",
      0
     ],
     "destination": [
      "obj-165",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-25",
      15
     ],
     "destination": [
      "obj-166",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-166",
      0
     ],
     "destination": [
      "obj-167",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-165",
      0
     ],
     "destination": [
      "obj-168",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-165",
      1
     ],
     "destination": [
      "obj-169",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-167",
      0
     ],
     "destination": [
      "obj-168",
      1
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-167",
      0
     ],
     "destination": [
      "obj-169",
      1
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-168",
      0
     ],
     "destination": [
      "obj-170",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-169",
      0
     ],
     "destination": [
      "obj-171",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-174",
      0
     ],
     "destination": [
      "obj-176",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-175",
      0
     ],
     "destination": [
      "obj-176",
      1
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-176",
      0
     ],
     "destination": [
      "obj-177",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-176",
      1
     ],
     "destination": [
      "obj-177",
      1
     ]
    }
   }
  ]
 }
}