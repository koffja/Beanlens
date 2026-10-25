"""把 K230D BOX 板端目录里的文件经 USB 串口拉回到电脑（raw REPL + base64 连续流）。

与 push_files.py 对称（板 -> 电脑方向）。板端无需预装任何脚本：
主机把读取循环作为一段代码注入 raw REPL，板端连续输出 base64 行，
主机大块读取，甩开逐块等确认的往返协议，因此比 CanMV IDE 取回快数倍。
base64 行编码避开 raw REPL 输出通道的 CTRL-D(0x04) 边界冲突。

用法（不使用项目 .venv，pyserial 装在 uv 的临时环境）：
  uv run --no-project --with pyserial python -I firmware/k230d/tools/pull_files.py \
      --port /dev/cu.usbmodemXXXX --src /sdcard/beanlens \
      --out /Users/chengzhe/Projects/Beanlens/tmp/export

- 只拷 --src 下一层的文件（不递归）。
- 每个文件拉完做 SHA-256 校验，不一致报 FAILED 并继续下一个，产物不落盘。
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
        # CDC 波特率参数无实际意义；timeout 决定单次 read 的等待窗口
        self.ser = serial.Serial(port, 115200, timeout=0.05)
        self.timeout = timeout

    def read_until(self, marker, timeout=None):
        deadline = time.monotonic() + (timeout or self.timeout)
        buf = b""
        while not buf.endswith(marker):
            if time.monotonic() > deadline:
                raise BoardError("等待 %r 超时，已收 %d 字节，尾部 %r" % (
                    marker, len(buf), buf[-120:]))
            chunk = self.ser.read(4096)
            if chunk:
                buf += chunk
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
        return out.decode(errors="replace")


def board_listdir(repl, src):
    out = repl.exec(
        "import os\n"
        "try:\n"
        " print('\\n'.join(sorted(n for n in os.listdir(%r) if not n.startswith('.'))))\n"
        "except OSError as e:\n"
        " print('ERR', e)\n" % src, timeout=20)
    if out.startswith("ERR"):
        raise BoardError("板端列目录失败：%s" % out)
    return [n for n in out.split("\n") if n.strip()]


def board_size(repl, path):
    out = repl.exec("import os\nprint(os.stat(%r)[6])" % path, timeout=15)
    return int(out.strip())


def pull_file(repl, board_path, dst_path):
    t0 = time.monotonic()
    size = board_size(repl, board_path)
    code = (
        "import os, hashlib, binascii\n"
        "p = %r\n"
        "print('SIZE', os.stat(p)[6])\n"
        "h = hashlib.sha256()\n"
        "f = open(p, 'rb')\n"
        "try:\n"
        "    while True:\n"
        "        b = f.read(1536)\n"
        "        if not b: break\n"
        "        h.update(b)\n"
        "        print(binascii.b2a_base64(b).decode().strip())\n"
        "finally:\n"
        "    f.close()\n"
        "print('SHA', h.hexdigest())\n" % board_path
    )
    # 传输预算按 40KB/s 下限留 4 倍余量，至少 60 秒
    timeout = max(60.0, size / 40960.0 * 4.0)
    out = repl.exec(code, timeout=timeout)
    lines = out.split("\n")
    if not lines or not lines[0].startswith("SIZE"):
        raise BoardError("意外输出头：%r" % lines[:1])
    sha_lines = [l for l in lines if l.startswith("SHA ")]
    if not sha_lines:
        raise BoardError("输出缺 SHA 结尾（可能被截断），重试本文件")
    want = sha_lines[-1].split()[1]
    b64 = "".join(l for l in lines[1:] if not l.startswith("SHA "))
    data = base64.b64decode(b64)
    got = hashlib.sha256(data).hexdigest()
    if got != want or len(data) != size:
        raise BoardError("校验失败 size %d/%d sha %s/%s" % (
            len(data), size, got[:12], want[:12]))
    os.makedirs(os.path.dirname(os.path.abspath(dst_path)), exist_ok=True)
    with open(dst_path, "wb") as f:
        f.write(data)
    dt = time.monotonic() - t0
    print("完成 %s  %d B  %.1fs  %.0f KB/s  sha=%s" % (
        dst_path, size, dt, size / 1024.0 / dt, got[:12]))


def main():
    ap = argparse.ArgumentParser(description=__doc__.split("\n")[0])
    ap.add_argument("--port", required=True)
    ap.add_argument("--src", required=True, help="板端目录，例如 /sdcard/beanlens")
    ap.add_argument("--out", required=True, help="本机输出目录")
    ap.add_argument("--include", default="", help="只拉文件名包含此子串的文件")
    a = ap.parse_args()

    src = a.src.rstrip("/")
    names = None
    repl = RawRepl(a.port, 10.0)
    try:
        repl.enter()
        names = board_listdir(repl, src)
    except BoardError as e:
        print("失败：%s" % e, file=sys.stderr)
        sys.exit(1)
    finally:
        repl.exit()

    files = [n for n in names if a.include in n]
    files = [n for n in files if not n.endswith(".part")]
    print("待拉取 %d 个文件（%s 下）" % (len(files), src))
    failed = []
    for i, n in enumerate(files):
        try:
            repl = RawRepl(a.port, 10.0)
            repl.enter()
            pull_file(repl, src + "/" + n, os.path.join(a.out, n))
        except BoardError as e:
            print("FAILED %s : %s" % (n, e), file=sys.stderr)
            failed.append(n)
        finally:
            repl.exit()
    print("结束：成功 %d，失败 %d" % (len(files) - len(failed), len(failed)))
    if failed:
        print("失败清单：\n  " + "\n  ".join(failed), file=sys.stderr)
        sys.exit(1)


if __name__ == "__main__":
    main()
