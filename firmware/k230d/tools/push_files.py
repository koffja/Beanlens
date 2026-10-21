"""把电脑上的文件经 USB 串口（MicroPython raw REPL）拷到 K230D BOX 的 /sdcard。

为什么不用 mpremote cp：在 ATK CanMV v1.3-8dd764f 上实测，mpremote 的 raw paste
传到约 1.8MB 时卡死，板子需要重启。这里改用普通 raw REPL，每次只发一小块
（默认 1KB，base64），等板子回 OK 后再发下一块；先写 <name>.part，板端 SHA-256
与本地一致后才改名为正式文件名。

用法（不使用项目 .venv，pyserial 装在 uv 的临时环境）：
  uv run --no-project --with pyserial python -I firmware/k230d/tools/push_files.py \
      --port /dev/cu.usbmodemXXXX --dest /sdcard/beanlens/model \
      output/kmodel/<run>/labels.txt output/kmodel/<run>/board_test ...

- 参数里的目录会连同其文件拷到 dest/<目录名>/（只拷一层，不递归子目录）。
- 板上已有同名且 SHA-256 相同的文件：跳过（可用来断点续传）。
- 板上已有同名但内容不同的文件：默认报错停止；加 --overwrite 才替换。
- 运行前关闭 CanMV IDE 的连接，否则串口被占用。会打断板上正在运行的程序。
"""

import argparse
import base64
import hashlib
import os
import sys
import time

import serial

CTRL_A, CTRL_B, CTRL_C, CTRL_D = b"\x01", b"\x02", b"\x03", b"\x04"


class BoardError(RuntimeError):
    pass


class RawRepl:
    def __init__(self, port, timeout):
        self.ser = serial.Serial(port, 115200, timeout=0.1)
        self.timeout = timeout

    def read_until(self, marker, timeout=None):
        deadline = time.monotonic() + (timeout or self.timeout)
        buf = b""
        while not buf.endswith(marker):
            if time.monotonic() > deadline:
                raise BoardError("等待 %r 超时，已收到：%r" % (marker, buf[-200:]))
            buf += self.ser.read(1)
        return buf

    def enter(self):
        self.ser.write(b"\r" + CTRL_C + CTRL_C)
        time.sleep(0.3)
        self.ser.reset_input_buffer()
        self.ser.write(b"\r" + CTRL_A)
        self.read_until(b"raw REPL; CTRL-B to exit\r\n>", timeout=5)

    def exit(self):
        try:
            self.ser.write(b"\r" + CTRL_B)
        finally:
            self.ser.close()

    def exec(self, code, timeout=None):
        data = code.encode() if isinstance(code, str) else code
        # 小块写入，避免板端 USB CDC 接收缓冲溢出
        for i in range(0, len(data), 256):
            self.ser.write(data[i:i + 256])
            self.ser.flush()
        self.ser.write(CTRL_D)
        try:
            self.read_until(b"OK", timeout)
        except BoardError as e:
            raise BoardError("板子未确认代码块（不在 raw REPL 或已卡住）：%s" % e)
        out = self.read_until(CTRL_D, timeout)[:-1]
        err = self.read_until(CTRL_D, timeout)[:-1]
        self.read_until(b">", timeout)
        if err:
            raise BoardError(err.decode(errors="replace").strip())
        return out.decode(errors="replace").strip()


def board_sha256(repl, path):
    out = repl.exec(
        "try:\n"
        " _h=hashlib.sha256()\n"
        " with open(%r,'rb') as _f:\n"
        "  while True:\n"
        "   _b=_f.read(4096)\n"
        "   if not _b: break\n"
        "   _h.update(_b)\n"
        " print(binascii.hexlify(_h.digest()).decode())\n"
        "except OSError:\n"
        " print('MISSING')\n" % path,
        timeout=120,
    )
    return None if out == "MISSING" else out


def local_sha256(path):
    h = hashlib.sha256()
    with open(path, "rb") as f:
        for b in iter(lambda: f.read(1 << 16), b""):
            h.update(b)
    return h.hexdigest()


def mkdirs(repl, path):
    parts = path.strip("/").split("/")
    for i in range(1, len(parts) + 1):
        p = "/" + "/".join(parts[:i])
        repl.exec("try:\n os.mkdir(%r)\nexcept OSError:\n pass\n" % p)


def push_file(repl, src, dst, chunk, overwrite):
    want = local_sha256(src)
    have = board_sha256(repl, dst)
    if have == want:
        print("跳过（已一致） %s" % dst)
        return
    if have is not None and not overwrite:
        raise BoardError("%s 已存在且内容不同；确认可替换后加 --overwrite" % dst)

    size = os.path.getsize(src)
    part = dst + ".part"
    t0 = time.monotonic()
    repl.exec("_f=open(%r,'wb')" % part)
    try:
        with open(src, "rb") as f:
            sent = 0
            while True:
                b = f.read(chunk)
                if not b:
                    break
                repl.exec("_f.write(binascii.a2b_base64(%r))" % base64.b64encode(b))
                sent += len(b)
                if size > 256 * 1024 and sent % (256 * 1024) < chunk:
                    print("  %s %d/%d KB" % (os.path.basename(src), sent // 1024, size // 1024))
    finally:
        repl.exec("_f.close()")

    got = board_sha256(repl, part)
    if got != want:
        raise BoardError("%s 校验失败：板端 %s，本地 %s（.part 保留待查）" % (dst, got, want))
    repl.exec(
        "try:\n os.remove(%r)\nexcept OSError:\n pass\nos.rename(%r,%r)\n" % (dst, part, dst))
    dt = time.monotonic() - t0
    print("完成 %s  %d B  %.1fs  sha256=%s" % (dst, size, dt, want[:16]))


def collect(paths, dest):
    jobs = []
    for p in paths:
        if os.path.isdir(p):
            sub = dest + "/" + os.path.basename(os.path.normpath(p))
            for n in sorted(os.listdir(p)):
                full = os.path.join(p, n)
                if os.path.isfile(full) and not n.startswith("."):
                    jobs.append((full, sub + "/" + n))
        elif os.path.isfile(p):
            jobs.append((p, dest + "/" + os.path.basename(p)))
        else:
            raise SystemExit("找不到 %s" % p)
    return jobs


def main():
    ap = argparse.ArgumentParser(description=__doc__.split("\n")[0])
    ap.add_argument("--port", required=True)
    ap.add_argument("--dest", required=True, help="板端目录，例如 /sdcard/beanlens/model")
    ap.add_argument("--chunk", type=int, default=1024, help="每块原始字节数")
    ap.add_argument("--timeout", type=float, default=10.0, help="单个代码块等待秒数")
    ap.add_argument("--overwrite", action="store_true")
    ap.add_argument("paths", nargs="+")
    a = ap.parse_args()

    dest = a.dest.rstrip("/")
    if not dest.startswith("/sdcard/"):
        raise SystemExit("--dest 只允许 /sdcard/ 下的目录")
    jobs = collect(a.paths, dest)

    repl = RawRepl(a.port, a.timeout)
    try:
        repl.enter()
        repl.exec("import os, binascii, hashlib")
        for d in sorted({dst.rsplit("/", 1)[0] for _, dst in jobs}):
            mkdirs(repl, d)
        for src, dst in jobs:
            push_file(repl, src, dst, a.chunk, a.overwrite)
    except BoardError as e:
        print("失败：%s" % e, file=sys.stderr)
        sys.exit(1)
    finally:
        repl.exit()
    print("全部 %d 个文件已一致。" % len(jobs))


if __name__ == "__main__":
    main()
