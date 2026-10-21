# BeanLens 采集目录清理（bring-up 用）
# 目标：正点原子 K230D BOX + CanMV（ATK v1.3-8dd764f）
# 功能：删除 /sdcard/beanlens/ 下全部 capNNN 目录（含完整与卡死留下的残缺目录）。
# 范围：只删名字为 cap + 3 位数字的目录及其中的文件；/sdcard/beanlens 本身和其他条目保留。
#      capNNN 内若有子目录，该目录整体跳过并报告，不递归删除。
# 删除不可恢复：需要保留的数据先用 mpremote 拷到电脑（cap010、cap011 已有副本在 captures/k230d/）。
# 用法：默认 DRY_RUN=True 只列清单；确认后把 DRY_RUN 改为 False 再运行才会真正删除。
#   CanMV IDE：打开本文件 → 运行
#   mpremote（先断开 IDE）：
#     firmware/k230d/tools/.venv-mpremote/bin/mpremote connect /dev/cu.usbmodem0010000001 \
#         run firmware/k230d/bringup/clean_beanlens.py

import os

ROOT = "/sdcard/beanlens"
DRY_RUN = False                # 改为 False 才会删除

S_IFDIR = 0x4000


def is_cap_name(name):
    return len(name) == 6 and name.startswith("cap") and name[3:].isdigit()


def stat_or_none(path):
    try:
        return os.stat(path)
    except OSError:
        return None


def free_mb(path):
    st = os.statvfs(path)
    bs = st[1] if st[1] else st[0]   # 本固件 frsize=0，用 bsize
    return bs * st[3] / 1048576


def clean_dir(d):
    """删除 d 中的文件后删除 d；返回 (文件数, 字节数, 错误列表)。"""
    files, size, errors = 0, 0, []
    names = sorted(os.listdir(d))
    for name in names:
        st = stat_or_none(d + "/" + name)
        if st is not None and st[0] & S_IFDIR:
            return files, size, ["contains subdirectory %s, skipped" % name]
    for name in names:
        p = d + "/" + name
        st = stat_or_none(p)
        n = st[6] if st is not None else 0
        if DRY_RUN:
            files += 1
            size += n
            continue
        try:
            os.remove(p)
            files += 1
            size += n
        except OSError as e:
            errors.append("remove %s: %s" % (name, e))
    if not DRY_RUN and not errors:
        try:
            os.rmdir(d)
        except OSError as e:
            errors.append("rmdir: %s" % e)
    return files, size, errors


try:
    if stat_or_none(ROOT) is None:
        print("%s not present, nothing to do" % ROOT)
    else:
        caps = [n for n in sorted(os.listdir(ROOT)) if is_cap_name(n)]
        print("%s: %d cap dirs%s" % (ROOT, len(caps), " (DRY RUN, nothing deleted)" if DRY_RUN else ""))
        try:
            before = free_mb("/sdcard")
        except Exception:
            before = None
        total_files, total_bytes, failed = 0, 0, []
        verb = "would remove" if DRY_RUN else "removed"
        for n in caps:
            files, size, errors = clean_dir(ROOT + "/" + n)
            total_files += files
            total_bytes += size
            if errors:
                failed.append(n)
                print("  %s: FAILED %s" % (n, "; ".join(errors)))
            else:
                print("  %s: %s %d files, %.1f MB" % (n, verb, files, size / 1048576))
        print("---- summary ----")
        print("dirs: %d, failed: %d %s" % (len(caps), len(failed), failed if failed else ""))
        print("files %s: %d, %.1f MB" % (verb, total_files, total_bytes / 1048576))
        if not DRY_RUN and before is not None:
            print("/sdcard free: %.1f MB -> %.1f MB" % (before, free_mb("/sdcard")))
        print("remaining in %s: %s" % (ROOT, os.listdir(ROOT)))
        if DRY_RUN:
            print("set DRY_RUN = False and rerun to delete")
except KeyboardInterrupt:
    print("user stop")
except BaseException as e:
    print("Exception:", e)
