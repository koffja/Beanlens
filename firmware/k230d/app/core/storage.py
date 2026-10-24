# 本地存储工具：原子写 JSON（临时文件 + rename + 保留 .prev）与回退读取。
# 只用 os / json，按 MicroPython 可用的子集编写（未在 CanMV 板上验证）。
# 注意：MicroPython 没有 os.path / os.makedirs，os.rename 在目标存在时行为也不同，
# 所以这里自己实现路径拼接、逐级建目录，并且从不依赖 rename 覆盖已有文件。
import os
import json

HOST_BASE_DIR = "~/.beanlens"
# 假设值：板上没有 os.path.expanduser 时的回退目录，沿用 bringup 结果所在的 /sdcard/beanlens。
# 尚未在板上核对，见汇报。
BOARD_FALLBACK_BASE_DIR = "/sdcard/beanlens"


def default_base_dir():
    """默认落盘根目录：主机上是 ~/.beanlens，板上回退到 BOARD_FALLBACK_BASE_DIR。"""
    path_mod = getattr(os, "path", None)
    expand = getattr(path_mod, "expanduser", None)
    if expand is not None:
        return expand(HOST_BASE_DIR)
    return BOARD_FALLBACK_BASE_DIR


def join_path(*parts):
    result = ""
    for part in parts:
        if result == "":
            result = part
        elif result.endswith("/"):
            result = result + part
        else:
            result = result + "/" + part
    return result


def exists(path):
    try:
        os.stat(path)
        return True
    except OSError:
        return False


def ensure_dir(path):
    """逐级创建目录（相当于 makedirs，已存在则跳过）。"""
    if path == "":
        return
    current = ""
    index = 0
    for part in path.split("/"):
        if index == 0:
            current = part
        elif part != "":
            current = current + "/" + part
        index += 1
        if current == "" or part == "":
            continue
        if not exists(current):
            os.mkdir(current)


def _parent_dir(path):
    if "/" not in path:
        return ""
    head = path.rsplit("/", 1)[0]
    if head == "":
        return "/"
    return head


def _try_load(path):
    """返回 (是否成功, 对象)。文件缺失或不是合法 JSON 都算失败。"""
    try:
        with open(path, "r") as f:
            text = f.read()
        return True, json.loads(text)
    except (OSError, ValueError):
        return False, None


def _sync():
    sync = getattr(os, "sync", None)
    if sync is not None:
        sync()


def atomic_write_json(path, obj):
    """把 obj 写成 JSON 到 path：先写 path.tmp，再 rename 替换，旧内容留在 path.prev。

    中断后读回的要么是旧内容要么是新内容（见 read_json），不会是半个 JSON。
    序列化失败会在碰任何文件之前抛出。
    """
    text = json.dumps(obj)
    ensure_dir(_parent_dir(path))
    tmp = path + ".tmp"
    prev = path + ".prev"

    with open(tmp, "w") as f:
        f.write(text)
        f.flush()
    _sync()

    if exists(path):
        ok, _ = _try_load(path)
        if ok:
            # 主文件完好：轮换成 .prev。先删旧 .prev，避免依赖 rename 覆盖。
            if exists(prev):
                os.remove(prev)
            os.rename(path, prev)
        else:
            # 主文件已损坏（外部原因）：丢掉它，保留完好的旧 .prev 不被污染。
            os.remove(path)
    os.rename(tmp, path)


def remove_json(path):
    """删除 atomic_write_json 写出的一组文件（path、path.prev、path.tmp），缺失的跳过。

    删除顺序是先 .prev、再主文件、最后 .tmp：任何一步断电，read_json 读回的要么是当前版本，
    要么什么都没有，不会回退到更旧的 .prev 把已删除的记录“复活”。
    """
    for name in (path + ".prev", path, path + ".tmp"):
        if exists(name):
            os.remove(name)


def read_json(path, default=None):
    """读 path；主文件缺失或损坏时回退 path.prev；都不可用返回 default。"""
    ok, obj = _try_load(path)
    if ok:
        return obj
    ok, obj = _try_load(path + ".prev")
    if ok:
        return obj
    return default
