# usb_msc_probe.py - read-only probe: does this CanMV build expose a virtual U disk?
# Run in CanMV IDE or via mpremote. Changes nothing on the board.
import os
import sys


def section(title):
    print("")
    print("== " + title + " ==")


def try_import(name):
    try:
        mod = __import__(name)
        names = [n for n in dir(mod) if not n.startswith("_")]
        print("[ok]   import " + name + " -> " + ", ".join(names[:30]))
    except Exception as e:
        print("[none] import " + name + " (" + str(e) + ")")


def statvfs_mb(path):
    try:
        st = os.statvfs(path)
        bsize = st[0] if st[0] else st[1]
        total = st[2] * bsize
        free = st[3] * bsize
        print("%-10s total %.1f MB, free %.1f MB (bsize %d)" % (
            path, total / 1048576.0, free / 1048576.0, st[0]))
    except Exception as e:
        print("%-10s statvfs failed: %s" % (path, e))


section("identity")
print(os.uname())
print(sys.version)

section("root listing")
try:
    print(os.listdir("/"))
except Exception as e:
    print("listdir failed: " + str(e))

section("mount sizes")
for p in ("/sdcard", "/data", "/udisk", "/sdcard1", "/tf"):
    statvfs_mb(p)

section("candidate usb modules")
for m in ("usb", "usbd", "usb.device", "machine", "udisk", "vfs"):
    try_import(m)

section("machine USB-ish attributes")
try:
    import machine
    hits = [n for n in dir(machine) if "usb" in n.lower() or "msc" in n.lower()]
    print(hits if hits else "no usb/msc attribute in machine")
except Exception as e:
    print("machine import failed: " + str(e))

section("os module attributes")
print([n for n in dir(os) if not n.startswith("_")])

print("")
print("Now check the host: does a 'CanMV' volume appear on the Mac?")
print("Mac: ls /Volumes ; system_profiler SPUSBDataType | grep -iE -A8 'canmv|k230|1209'")
