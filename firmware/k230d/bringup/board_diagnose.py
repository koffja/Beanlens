# BeanLens 板端诊断（bring-up 用）
# 目标：正点原子 K230D BOX + CanMV（ATK v1.3-8dd764f）
# 功能：不初始化相机/屏幕/媒体，只做两件事——
#   1. 打印板端系统信息：固件版本、MicroPython、sys.path、堆内存、挂载点与剩余空间、/proc 信息、nncase 运行时
#   2. 检查双摄预览卡死是否与“已有文件”有关：
#      - 开机自启脚本（main.py / boot.py）是否又出现：曾确认出厂 AI demo 自启会让预览卡死
#      - sys.path 目录里是否有同名文件遮蔽 media / image / time / os 等内置模块
#      - /sdcard/beanlens/capNNN 是否有卡死留下的残缺目录（缺 index.csv、0 字节文件、stat 失败）
#      - 各分区剩余空间、能否 stat 每个根目录条目、能否写读删一个临时文件
# 每一步先打印 "-> 步骤名"，若脚本自己卡住，最后一行就是卡住的位置。
# 只读检查；唯一的写操作是 WRITE_PROBE 创建并删除自己的临时文件，不改动、不删除已有文件。
#
# 用法（二选一）：
#   CanMV IDE：打开本文件 → 运行，在串行终端看输出
#   mpremote（先断开 IDE）：
#     firmware/k230d/tools/.venv-mpremote/bin/mpremote connect /dev/cu.usbmodem0010000001 \
#         run firmware/k230d/bringup/board_diagnose.py
# 建议先断电重启、不运行任何相机脚本，再跑本诊断；结果抄进 config/hardware-baseline.json。

import gc
import os
import sys
import time

WRITE_PROBE = True            # False 则完全不写存储
MOUNTS = ("/sdcard", "/data", "/udisk", "/tmp")
AUTORUN_FILES = ("/sdcard/main.py", "/sdcard/boot.py", "/main.py", "/boot.py",
                 "/data/main.py", "/data/boot.py")
KNOWN_BACKUP = "/sdcard/main.py.bak"   # 2026-10-17 用户改名留下的出厂 demo
SHADOW_NAMES = ("media", "image", "time", "os", "gc", "sys", "machine", "sensor",
                "display", "camera", "lcd", "nncase_runtime", "ulab", "aidemo", "uos", "utime")
OUT_ROOT = "/sdcard/beanlens"
LOW_FREE_MB = 5
MAX_LIST = 200                # 单个目录最多列出条目数，避免大目录刷屏

S_IFDIR = 0x4000
warnings = []


def step(name):
    print("-> " + name)


def warn(msg):
    warnings.append(msg)
    print("  [WARN] " + msg)


def stat_or_none(path):
    try:
        return os.stat(path)
    except OSError:
        return None


def is_dir(st):
    return st is not None and (st[0] & S_IFDIR) != 0


def listdir_safe(path):
    try:
        return sorted(os.listdir(path))
    except Exception as e:
        warn("listdir %s failed: %s" % (path, e))
        return []


def first_line(path):
    try:
        with open(path, "r") as f:
            return f.readline().strip()[:100]
    except Exception as e:
        return "<read failed: %s>" % e


def read_small(path, limit=1024):
    try:
        with open(path, "r") as f:
            return f.read(limit)
    except Exception as e:
        return "<read failed: %s>" % e


def free_mb(path):
    st = os.statvfs(path)
    # 本固件返回 bsize=512, frsize=0, bavail=0：用 bsize * bfree 计算
    bs = st[1] if st[1] else st[0]
    return bs * st[2] / 1048576, bs * st[3] / 1048576


# ---------------------------------------------------------------- 系统信息
def system_info():
    print("==== system info ====")
    step("os.uname")
    try:
        u = os.uname()
        for k in ("sysname", "nodename", "release", "version", "machine"):
            print("  %-9s %s" % (k, getattr(u, k, "?")))
    except Exception as e:
        warn("os.uname failed: %s" % e)

    step("sys")
    print("  version   %s" % sys.version)
    try:
        impl = sys.implementation
        print("  impl      %s %s" % (impl.name, ".".join(str(x) for x in impl.version[:3])))
        print("  _machine  %s" % getattr(impl, "_machine", "?"))
    except Exception as e:
        warn("sys.implementation failed: %s" % e)
    print("  platform  %s" % sys.platform)
    print("  path      %s" % (sys.path,))
    try:
        print("  cwd       %s" % os.getcwd())
    except Exception:
        pass

    step("heap")
    gc.collect()
    try:
        free, alloc = gc.mem_free(), gc.mem_alloc()
        print("  heap free %.1f MB, used %.1f MB" % (free / 1048576, alloc / 1048576))
    except Exception as e:
        warn("gc.mem_* failed: %s" % e)

    step("machine")
    try:
        import machine
        try:
            print("  cpu freq  %s" % (machine.freq(),))
        except Exception as e:
            print("  cpu freq  unavailable (%s)" % e)
        try:
            print("  unique_id %s" % "".join("%02x" % b for b in machine.unique_id()))
        except Exception as e:
            print("  unique_id unavailable (%s)" % e)
    except ImportError as e:
        print("  machine module missing (%s)" % e)

    step("nncase runtime")
    try:
        import nncase_runtime as nn
        v = getattr(nn, "version", None)
        print("  nncase_runtime %s" % (v() if callable(v) else v))
    except Exception as e:
        print("  nncase_runtime unavailable (%s)" % e)

    step("media modules (import only, no init)")
    for mod in ("media.sensor", "media.display", "media.media", "image"):
        try:
            __import__(mod)
            print("  import %-14s ok" % mod)
        except Exception as e:
            warn("import %s failed: %s" % (mod, e))

    for p in ("/proc/version", "/proc/uptime", "/proc/meminfo"):
        step(p)
        if stat_or_none(p) is None:
            print("  (not present)")
            continue
        for line in read_small(p, 600).split("\n")[:8]:
            if line:
                print("  " + line)

    step("mounts")
    print("  / = %s" % listdir_safe("/"))
    for m in MOUNTS:
        if stat_or_none(m) is None:
            print("  %-8s not present" % m)
            continue
        try:
            total, free = free_mb(m)
            print("  %-8s total %.1f MB, free %.1f MB" % (m, total, free))
            if total > 0 and free < LOW_FREE_MB and m in ("/sdcard", "/data"):
                warn("%s free space %.1f MB < %d MB" % (m, free, LOW_FREE_MB))
        except Exception as e:
            print("  %-8s statvfs failed: %s" % (m, e))


# ---------------------------------------------------------------- 文件检查
def check_autorun():
    step("autorun scripts")
    found = False
    for p in AUTORUN_FILES:
        st = stat_or_none(p)
        if st is not None and not is_dir(st):
            found = True
            warn("autorun file present: %s (%d B), first line: %s" % (p, st[6], first_line(p)))
    if not found:
        print("  no main.py / boot.py autorun found")
    st = stat_or_none(KNOWN_BACKUP)
    if st is not None:
        print("  %s present (%d B) - factory demo kept disabled, ok" % (KNOWN_BACKUP, st[6]))


def check_shadowing():
    step("module shadowing in sys.path")
    dirs = []
    for d in list(sys.path) + ["/sdcard", "/sdcard/libs"]:
        if d in ("", ".") or d.startswith(".frozen"):
            try:
                d = os.getcwd()
            except Exception:
                continue
        if d not in dirs and is_dir(stat_or_none(d)):
            dirs.append(d)
    hit = False
    for d in dirs:
        for name in listdir_safe(d):
            base = name.rsplit(".", 1)[0] if "." in name else name
            ext = name[len(base):]
            if base in SHADOW_NAMES and ext in ("", ".py", ".mpy"):
                hit = True
                warn("%s/%s may shadow built-in module '%s'" % (d, name, base))
    print("  scanned: %s" % dirs)
    if not hit:
        print("  no shadowing files")


def check_root_entries(root):
    step("stat every entry of " + root)
    names = listdir_safe(root)
    bad = 0
    for name in names[:MAX_LIST]:
        p = root + "/" + name
        st = stat_or_none(p)
        if st is None:
            bad += 1
            warn("cannot stat %s (possible FAT damage after hard hang)" % p)
        else:
            print("  %s %-28s %d B" % ("d" if is_dir(st) else "-", name, st[6]))
    if len(names) > MAX_LIST:
        print("  ... %d more entries not listed" % (len(names) - MAX_LIST))
    print("  %d entries, %d unreadable" % (len(names), bad))


def check_capture_dirs():
    step("capture output " + OUT_ROOT)
    if not is_dir(stat_or_none(OUT_ROOT)):
        print("  %s not present (fine, preview does not need it)" % OUT_ROOT)
        return
    names = listdir_safe(OUT_ROOT)
    caps = [n for n in names if n.startswith("cap")]
    others = [n for n in names if not n.startswith("cap")]
    if others:
        print("  other entries: %s" % others)
    for n in caps:
        d = OUT_ROOT + "/" + n
        files = listdir_safe(d)
        issues = []
        total = 0
        for f in files:
            st = stat_or_none(d + "/" + f)
            if st is None:
                issues.append("cannot stat " + f)
            else:
                total += st[6]
                if st[6] == 0:
                    issues.append(f + " is 0 B")
        if "meta.txt" not in files:
            issues.append("no meta.txt")
        elif "script_version" in read_small(d + "/meta.txt", 200):
            # dual_camera_capture.py v2 起：index.csv 边拍边写，只有 done.txt 表示正常结束
            if "done.txt" not in files:
                issues.append("no done.txt (run did not finish, flushed frames recoverable)")
        elif "index.csv" not in files:
            issues.append("no index.csv (run did not finish)")
        line = "  %s: %d files, %.1f MB" % (n, len(files), total / 1048576)
        if issues:
            print(line)
            warn("%s incomplete: %s" % (d, "; ".join(issues)))
        else:
            print(line + ", complete")


def write_probe():
    if not WRITE_PROBE:
        print("-> write probe skipped (WRITE_PROBE=False)")
        return
    for m in ("/sdcard", "/data"):
        if not is_dir(stat_or_none(m)):
            continue
        p = "%s/_beanlens_diag_%d.tmp" % (m, time.ticks_ms())
        step("write/read/delete probe " + p)
        if stat_or_none(p) is not None:
            print("  name collision, skipped")
            continue
        data = b"BeanLens" * 1024    # 8 KB
        try:
            t = time.ticks_ms()
            with open(p, "wb") as f:
                f.write(data)
            tw = time.ticks_diff(time.ticks_ms(), t)
            with open(p, "rb") as f:
                ok = f.read() == data
            os.remove(p)
            print("  %s, write 8 KB in %d ms" % ("ok" if ok else "READ MISMATCH", tw))
            if not ok:
                warn("%s read-back mismatch" % m)
        except Exception as e:
            warn("%s write probe failed: %s" % (m, e))
            try:
                os.remove(p)
            except Exception:
                pass


# ---------------------------------------------------------------- main
t_start = time.ticks_ms()
try:
    system_info()
    print("==== file checks ====")
    check_autorun()
    check_shadowing()
    check_root_entries("/sdcard")
    check_capture_dirs()
    write_probe()
except KeyboardInterrupt:
    print("user stop")
except BaseException as e:
    warn("diagnose aborted: %s" % e)

print("==== summary (%d ms) ====" % time.ticks_diff(time.ticks_ms(), t_start))
if warnings:
    for w in warnings:
        print("  WARN " + w)
    print("  -> fix the warnings above, power cycle, then rerun dual_camera_preview.py")
else:
    print("  no file-related problem found; preview hang is likely not caused by existing files")
    print("  -> power cycle, run only dual_camera_preview.py, note the last printed line before the hang")
