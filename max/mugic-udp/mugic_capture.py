# /// script
# requires-python = ">=3.10"
# dependencies = ["python-osc>=1.8"]
# ///
"""Print live MUGIC readings, and optionally save them to a CSV file.

    uv run mugic_capture.py              # print
    uv run mugic_capture.py take1.csv    # print and save; Ctrl-C to stop
"""
import csv, sys, time
from pythonosc.dispatcher import Dispatcher
from pythonosc.osc_server import BlockingOSCUDPServer

PORT = 4000
FIELDS = ("AX AY AZ EX EY EZ GX GY GZ MX MY MZ QW QX QY QZ "
          "Battery BattV SysStatus GyroStatus AccelStatus MagStatus Ms SeqNum").split()

f = open(sys.argv[1], "w", newline="", buffering=1) if len(sys.argv) > 1 else None  # line-buffered: nothing lost if killed
out = csv.writer(f) if f else None
if out: out.writerow(["t"] + FIELDS)
t0 = last = time.monotonic(); n = 0

def on_data(addr, *v):
    global last, n
    now = time.monotonic(); n += 1
    if out: out.writerow([f"{now - t0:.4f}", *v])
    if now - last >= 0.5:
        d = dict(zip(FIELDS, v))
        print(f"\r{n / (now - last):4.0f} Hz | angles {d['EX']:7.1f} {d['EY']:7.1f} {d['EZ']:7.1f}"
              f" | gyro {d['GX']:7.1f} {d['GY']:7.1f} {d['GZ']:7.1f} | battery {d['Battery']:.0f}%  ",
              end="", flush=True)
        last, n = now, 0

disp = Dispatcher(); disp.map("/mugicdata", on_data)
print(f"Waiting for data on UDP port {PORT}... (Ctrl-C to stop)")
try: BlockingOSCUDPServer(("0.0.0.0", PORT), disp).serve_forever()
except KeyboardInterrupt: pass
finally:
    if f: f.close()                      # flush every sample to disk
    print("\nstopped" + (f"; saved to {sys.argv[1]}" if f else ""))
