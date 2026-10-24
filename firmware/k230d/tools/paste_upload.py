#!/usr/bin/env python3
# 经 USB 串口 raw-paste 模式把一个小文件写到 K230D BOX（CanMV）上，写完在板端校验 SHA-256 后才改成目标名。
#
# 为什么不用 mpremote fs cp / push_files.py：2026-10-21、10-24 两种方式电脑→板子拷贝多次把板子卡死（需断电）。
# raw-paste（有流控）上传 burst_capture.py 执行过且校验一致，所以这里把文件 base64 嵌在一段板端代码里用 raw-paste 发送。
#
# 步骤：1. 板端写 <目标>.part 并读回算 SHA-256；2. 与电脑端一致才 rename 成目标名，目标已存在则拒绝（不覆盖）。
# 中途卡死时最多留下 .part 文件，不会留下半截的目标文件（例如半截 main.py 开机自启）。
#
# 用法（先关掉 CanMV IDE）：
#   .venv-mpremote/bin/python paste_upload.py ../bringup/main.py /sdcard/main.py
# 只适合几十 KB 以内的脚本；模型等大文件仍用读卡器拷贝。

import argparse
import base64
import hashlib
import pathlib
import sys
import time

CTRL_A, CTRL_B, CTRL_C, CTRL_D = b"\x01", b"\x02", b"\x03", b"\x04"
B64_LINE = 76 * 8


def read_exact(ser, n, timeout=5):
    buf = b""
    deadline = time.monotonic() + timeout
    while len(buf) < n:
        if time.monotonic() > deadline:
            sys.exit("timeout waiting for board, got %r" % buf)
        buf += ser.read(n - len(buf))
    return buf


def enter_raw(ser):
    ser.write(b"\r" + CTRL_C + CTRL_C)
    time.sleep(0.3)
    ser.reset_input_buffer()
    ser.write(b"\r" + CTRL_A)
    buf = b""
    deadline = time.monotonic() + 5
    while not buf.endswith(b"raw REPL; CTRL-B to exit\r\n>"):
        if time.monotonic() > deadline:
            sys.exit("no raw REPL prompt, got %r. Close CanMV IDE; otherwise power cycle the board" % buf[-200:])
        buf += ser.read(1)


def run_paste(ser, code, timeout=60):
    # raw-paste 上传 + 运行，返回 (stdout, stderr)
    ser.write(b"\x05A\x01")
    if read_exact(ser, 2) != b"R\x01":
        sys.exit("board does not support raw-paste mode")
    window = int.from_bytes(read_exact(ser, 2), "little")
    remaining, i = window, 0
    while i < len(code):
        while ser.in_waiting:
            b = ser.read(1)
            if b == CTRL_A:
                remaining += window
            elif b == CTRL_D:
                ser.write(CTRL_D)
                sys.exit("board aborted the upload")
        if remaining == 0:
            b = read_exact(ser, 1, timeout=10)
            if b == CTRL_A:
                remaining += window
            elif b == CTRL_D:
                ser.write(CTRL_D)
                sys.exit("board aborted the upload")
            continue
        n = min(remaining, len(code) - i)
        ser.write(code[i:i + n])
        i += n
        remaining -= n
    ser.write(CTRL_D)
    while read_exact(ser, 1, timeout=10) != CTRL_D:
        pass
    out = b""
    deadline = time.monotonic() + timeout
    while out.count(CTRL_D) < 2:
        if time.monotonic() > deadline:
            sys.exit("board did not finish within %d s, got %r" % (timeout, out[-300:]))
        out += ser.read(max(1, ser.in_waiting))
    stdout, stderr, _ = out.split(CTRL_D, 2)
    return stdout.decode(errors="replace"), stderr.decode(errors="replace")


def board_value(stdout, key):
    for ln in stdout.splitlines():
        if ln.startswith(key + "="):
            return ln[len(key) + 1:].strip()
    return None


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("local")
    ap.add_argument("remote")
    ap.add_argument("--port", default="/dev/cu.usbmodem0010000001")
    args = ap.parse_args()

    import serial

    data = pathlib.Path(args.local).read_bytes()
    sha = hashlib.sha256(data).hexdigest()
    b64 = base64.b64encode(data).decode()
    lines = [b64[k:k + B64_LINE] for k in range(0, len(b64), B64_LINE)]
    part = args.remote + ".part"
    print("%s: %d B, sha256 %s -> %s" % (args.local, len(data), sha, args.remote))

    write_code = (
        "import os, ubinascii, uhashlib\n"
        "D = %r\nP = %r\n"
        "try:\n    os.stat(D)\n    print('exists=1')\nexcept OSError:\n    print('exists=0')\n"
        "B = [\n%s]\n"
        "f = open(P, 'wb')\n"
        "for s in B:\n    f.write(ubinascii.a2b_base64(s))\n"
        "f.close()\nB = None\n"
        "h = uhashlib.sha256()\n"
        "with open(P, 'rb') as f:\n"
        "    while True:\n        c = f.read(4096)\n        if not c:\n            break\n        h.update(c)\n"
        "print('size=%%d' %% os.stat(P)[6])\n"
        "print('sha=' + ubinascii.hexlify(h.digest()).decode())\n"
        % (args.remote, part, "".join("%r,\n" % s for s in lines))
    ).encode()

    ser = serial.Serial(args.port, 115200, timeout=0.2)
    try:
        enter_raw(ser)
        print("step 1: writing %s (%d B of code)" % (part, len(write_code)))
        out, err = run_paste(ser, write_code)
        if err.strip():
            sys.exit("board error:\n" + err)
        if board_value(out, "exists") != "0":
            sys.exit("%s already exists on the board; not overwriting (%s left in place)" % (args.remote, part))
        size, bsha = board_value(out, "size"), board_value(out, "sha")
        print("board: size %s, sha256 %s" % (size, bsha))
        if size != str(len(data)) or bsha != sha:
            sys.exit("MISMATCH: %s kept on the board for inspection, %s not created" % (part, args.remote))

        print("step 2: rename to %s" % args.remote)
        rename_code = (
            "import os\nD = %r\nP = %r\n"
            "try:\n    os.stat(D)\n    print('result=exists')\nexcept OSError:\n"
            "    os.rename(P, D)\n"
            "    s = getattr(os, 'sync', None)\n    if s:\n        s()\n"
            "    print('result=ok size=%%d' %% os.stat(D)[6])\n" % (args.remote, part)
        ).encode()
        out, err = run_paste(ser, rename_code)
        if err.strip():
            sys.exit("board error:\n" + err)
        print("board: " + (board_value(out, "result") or out.strip()))
    finally:
        try:
            ser.write(CTRL_B)
        except Exception:
            pass
        ser.close()


if __name__ == "__main__":
    main()
