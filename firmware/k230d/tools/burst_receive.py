"""运行板端 burst_capture.py，结束后从 /sdcard 下载结果并标出豆子（电脑端）。

做法：
  1. 经 USB 串口进入 MicroPython raw-paste 模式，把 ../bringup/burst_capture.py 发给板子执行，转发板子日志；
     板子每轮把裁图写到 /sdcard/beanlens/burstNNN/（开始前检查剩余空间），日志 "@RUNDIR" 给出目录。
  2. 板子结束后用 mpremote 逐个文件下载（cp -r 整个目录会卡住，见 drop_capture_3），核对 files.csv 的 SHA-256。
     本地已有且 SHA-256 一致的文件跳过，所以中断后重跑 --fetch 可续传。板上文件不删除。
  3. 分析每轮每路相机：
     - 背景 = 同一轮同一相机所有帧逐像素中值（豆只在少数帧里，中值近似空背景）；
     - 豆子 = |帧 - 背景| 最大通道差 > --thresh 的最大连通块（面积 >= --min-area），画红框；
     - 清晰度 = 豆子外框内灰度拉普拉斯方差（越大越清楚，只在同一光照/同一相机下相对比较）；
     - 拖影粗估 = 外框长边 - 短边（px），豆本身约椭圆，沿下落方向明显拉长说明有运动模糊。
输出 captures/k230d/sdcard_burstNNN/（与板上目录同名加前缀）：
  板上原始文件、board_log.txt、round_NN/camC_KK.png、round_NN_marked.png（总览，带框）、
  round_NN_best_camC.png（最清楚一帧放大）、analysis.csv。

用法（不使用项目 .venv；先关闭 CanMV IDE 的连接，会打断板上正在运行的程序）：
  拍摄 + 下载 + 分析：
    uv run --no-project --with pyserial --with numpy --with pillow python -I \\
        firmware/k230d/tools/burst_receive.py --port /dev/cu.usbmodem0010000001
  只下载 + 分析（例如在 IDE 里拍的，或下载中断后续传）：
    ... burst_receive.py --port /dev/cu.usbmodem0010000001 --fetch /sdcard/beanlens/burst000
  只重新分析本地目录（不连板子）：
    uv run --no-project --with numpy --with pillow python -I \\
        firmware/k230d/tools/burst_receive.py --analyze captures/k230d/sdcard_burst000
下载用 firmware/k230d/tools/.venv-mpremote 里的 mpremote（约 15 KB/s，一轮 2.64 MB 约 3 分钟）。
拍摄中按 Ctrl-C：向板子发 Ctrl-C，等它释放相机后退出；已写盘的轮次可再用 --fetch 下载。
"""

import argparse
import csv
import hashlib
import pathlib
import subprocess
import sys
import time

sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))   # -I 不把脚本目录放进 sys.path
import numpy as np                                                  # noqa: E402
from PIL import Image, ImageDraw                                    # noqa: E402
from drop_review import largest_blob, read_meta, rgb565_to_rgb      # noqa: E402

ROOT = pathlib.Path(__file__).resolve().parents[3]
BOARD_SCRIPT = ROOT / "firmware/k230d/bringup/burst_capture.py"
OUT_ROOT = ROOT / "captures/k230d"
MPREMOTE = pathlib.Path(__file__).resolve().parent / ".venv-mpremote/bin/mpremote"
CTRL_A, CTRL_B, CTRL_C, CTRL_D = b"\x01", b"\x02", b"\x03", b"\x04"
CSV_KEYS = ["round", "cam", "idx", "t_ms", "bean", "x1", "y1", "bw", "bh", "area", "aspect", "streak_px", "lap_var"]


# ---------------- 分析 ----------------

def lap_var(gray):
    # 4 邻域拉普拉斯的方差；区域太小返回 0
    if gray.shape[0] < 3 or gray.shape[1] < 3:
        return 0.0
    g = gray.astype(np.float32)
    lap = (g[1:-1, :-2] + g[1:-1, 2:] + g[:-2, 1:-1] + g[2:, 1:-1] - 4 * g[1:-1, 1:-1])
    return float(lap.var())


def analyze_round(out, rnd, frames, thresh, min_area, scale):
    """frames: {(cam, idx): (t_ms, rgb)}；返回 CSV 行。生成带框总览和最清楚帧放大图。"""
    cams = sorted({c for c, _ in frames})
    idxs = sorted({i for _, i in frames})
    h, w = next(iter(frames.values()))[1].shape[:2]
    sheet = Image.new("RGB", (w * len(idxs), (h + 14) * len(cams)), (40, 40, 40))
    draw = ImageDraw.Draw(sheet)
    rows = []
    for ci, cam in enumerate(cams):
        stack = [frames[(cam, i)][1] for i in idxs if (cam, i) in frames]
        bg = np.median(np.stack(stack).astype(np.int16), axis=0) if len(stack) >= 3 else None
        best = None
        for col, i in enumerate(idxs):
            if (cam, i) not in frames:
                continue
            t, img = frames[(cam, i)]
            x0, y0 = col * w, ci * (h + 14)
            sheet.paste(Image.fromarray(img), (x0, y0 + 14))
            rec = {"round": rnd, "cam": cam, "idx": i, "t_ms": t, "bean": 0, "x1": "", "y1": "", "bw": "",
                   "bh": "", "area": 0, "aspect": "", "streak_px": "", "lap_var": ""}
            blob = None
            if bg is not None:
                diff = np.abs(img.astype(np.int16) - bg).max(axis=-1)
                blob = largest_blob(diff > thresh)
            label = "cam%d #%d %dms" % (cam, i, t)
            if blob and blob[4] >= min_area:
                x1, y1, x2, y2, area = blob
                bw, bh = x2 - x1 + 1, y2 - y1 + 1
                gray = img.astype(np.float32) @ np.array([0.299, 0.587, 0.114], dtype=np.float32)
                lv = lap_var(gray[max(0, y1 - 3):y2 + 4, max(0, x1 - 3):x2 + 4])
                rec.update(bean=1, x1=x1, y1=y1, bw=bw, bh=bh, area=area,
                           aspect="%.2f" % (max(bw, bh) / min(bw, bh)), streak_px=max(bw, bh) - min(bw, bh),
                           lap_var="%.1f" % lv)
                draw.rectangle([x0 + x1 - 2, y0 + 14 + y1 - 2, x0 + x2 + 2, y0 + 14 + y2 + 2],
                               outline=(255, 0, 0), width=2)
                label += " lap%.0f" % lv
                if best is None or lv > best[0]:
                    best = (lv, i, (x1, y1, x2, y2))
            draw.text((x0 + 3, y0 + 1), label, fill=(255, 255, 0) if rec["bean"] else (150, 150, 150))
            rows.append(rec)
        if best is not None:
            lv, i, (x1, y1, x2, y2) = best
            pad = 12
            crop = frames[(cam, i)][1][max(0, y1 - pad):y2 + pad + 1, max(0, x1 - pad):x2 + pad + 1]
            im = Image.fromarray(crop)
            im.resize((im.width * 4, im.height * 4), Image.NEAREST).save(
                out / ("round_%02d_best_cam%d.png" % (rnd, cam)))
    if scale > 1:
        sheet = sheet.resize((sheet.width * scale, sheet.height * scale), Image.NEAREST)
    sheet.save(out / ("round_%02d_marked.png" % rnd))
    return rows


def summarize(rnd, rows):
    for cam in sorted({r["cam"] for r in rows}):
        hits = [r for r in rows if r["cam"] == cam and r["bean"]]
        total = sum(1 for r in rows if r["cam"] == cam)
        if not hits:
            print("  round %d cam%d: no bean in %d frames" % (rnd, cam, total))
            continue
        desc = ", ".join("#%d %sx%s lap%s streak%s" % (r["idx"], r["bw"], r["bh"], r["lap_var"], r["streak_px"])
                         for r in hits)
        print("  round %d cam%d: bean in %d/%d frames: %s" % (rnd, cam, len(hits), total, desc))


def analyze_dir(out, thresh, min_area, scale):
    meta = read_meta(out)
    w, h = int(meta["width"]), int(meta["height"])
    blobs = {}
    rounds = {}
    for r in csv.DictReader((out / "frames.csv").open()):
        path = out / r["file"]
        if not path.exists():
            continue
        if r["file"] not in blobs:
            blobs[r["file"]] = path.read_bytes()
        off, ln = int(r["offset"]), int(r["length"])
        data = blobs[r["file"]][off:off + ln]
        if len(data) != ln:
            continue
        rgb = rgb565_to_rgb(data, w, h)
        rnd, cam, idx = int(r["round"]), int(r["cam"]), int(r["idx"])
        rdir = out / ("round_%02d" % rnd)
        rdir.mkdir(exist_ok=True)
        Image.fromarray(rgb).save(rdir / ("cam%d_%02d.png" % (cam, idx)))
        rounds.setdefault(rnd, {})[(cam, idx)] = (int(r["t_ms"]), rgb)
    rows = []
    for rnd in sorted(rounds):
        r = analyze_round(out, rnd, rounds[rnd], thresh, min_area, scale)
        summarize(rnd, r)
        rows += r
    with (out / "analysis.csv").open("w", newline="") as f:
        wr = csv.DictWriter(f, fieldnames=CSV_KEYS)
        wr.writeheader()
        wr.writerows(rows)
    print("analysis -> %s (%d rounds)" % (out, len(rounds)))


# ---------------- 下载 ----------------

def mpremote_cp(port, remote, local):
    cmd = [str(MPREMOTE), "connect", port, "fs", "cp", ":" + remote, str(local)]
    r = subprocess.run(cmd, capture_output=True, text=True)
    return r.returncode == 0, (r.stdout + r.stderr).strip()


def sha256_file(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def fetch(port, remote_dir):
    if not MPREMOTE.exists():
        sys.exit("mpremote not found at %s (see config/hardware-baseline.json file_retrieval)" % MPREMOTE)
    remote_dir = remote_dir.rstrip("/")
    out = OUT_ROOT / ("sdcard_" + remote_dir.split("/")[-1])
    out.mkdir(parents=True, exist_ok=True)
    print("downloading %s -> %s" % (remote_dir, out))
    for name in ("meta.txt", "frames.csv", "files.csv"):
        ok, msg = mpremote_cp(port, remote_dir + "/" + name, out / name)
        if not ok:
            sys.exit("copy %s failed: %s" % (name, msg))
    ok, _ = mpremote_cp(port, remote_dir + "/done.txt", out / "done.txt")
    if not ok:
        print("no done.txt on board: the run did not finish; downloading the rounds that were saved")
    files = list(csv.DictReader((out / "files.csv").open()))
    bad = 0
    for i, row in enumerate(files):
        local = out / row["name"]
        if local.exists() and row["sha256"] != "-" and sha256_file(local) == row["sha256"]:
            print("  [%d/%d] %s already here, skipped" % (i + 1, len(files), row["name"]))
            continue
        t = time.monotonic()
        ok, msg = mpremote_cp(port, remote_dir + "/" + row["name"], local)
        if not ok:
            print("  [%d/%d] %s copy failed: %s" % (i + 1, len(files), row["name"], msg))
            bad += 1
            continue
        good = row["sha256"] == "-" or sha256_file(local) == row["sha256"]
        print("  [%d/%d] %s %d B in %.0f s, SHA-256 %s"
              % (i + 1, len(files), row["name"], local.stat().st_size, time.monotonic() - t,
                 "ok" if good else "MISMATCH"))
        if not good:
            local.rename(local.with_suffix(".bad"))
            bad += 1
    if bad:
        print("%d file(s) failed; run again with --fetch %s to retry" % (bad, remote_dir))
    return out


# ---------------- 运行板端脚本 ----------------

def read_exact(ser, n, timeout=5):
    buf = b""
    deadline = time.monotonic() + timeout
    while len(buf) < n:
        if time.monotonic() > deadline:
            sys.exit("timeout waiting for board, got %r" % buf)
        buf += ser.read(n - len(buf))
    return buf


def send_raw_paste(ser, script):
    # raw-paste 模式（mpremote 同款）：板子按窗口大小给发送许可，有流控，不丢字节。
    # 2026-10-24 普通 raw REPL 一次写 256 B 时板端收到的脚本损坏（line 1 SyntaxError），所以不用它。
    ser.write(b"\x05A\x01")
    resp = read_exact(ser, 2)
    if resp != b"R\x01":
        sys.exit("board does not support raw-paste mode (reply %r)" % resp)
    window = int.from_bytes(read_exact(ser, 2), "little")
    remaining = window
    i = 0
    while i < len(script):
        while ser.in_waiting:                       # 板子发 \x01 = 再给一个窗口；\x04 = 中止
            b = ser.read(1)
            if b == b"\x01":
                remaining += window
            elif b == CTRL_D:
                ser.write(CTRL_D)
                sys.exit("board aborted the upload")
        if remaining == 0:
            b = read_exact(ser, 1, timeout=10)
            if b == b"\x01":
                remaining += window
            elif b == CTRL_D:
                ser.write(CTRL_D)
                sys.exit("board aborted the upload")
            continue
        n = min(remaining, len(script) - i)
        ser.write(script[i:i + n])
        i += n
        remaining -= n
    ser.write(CTRL_D)                               # 结束上传；板子回 \x04 后编译并运行
    while read_exact(ser, 1, timeout=10) != CTRL_D:
        pass


def run_board(args):
    import serial

    script = BOARD_SCRIPT.read_bytes()
    log_lines = []
    run_dir = None
    done = False
    ser = serial.Serial(args.port, 115200, timeout=0.2)
    try:
        ser.write(b"\r" + CTRL_C + CTRL_C)
        time.sleep(0.3)
        ser.reset_input_buffer()
        ser.write(b"\r" + CTRL_A)
        buf = b""
        deadline = time.monotonic() + 5
        while not buf.endswith(b"raw REPL; CTRL-B to exit\r\n>"):
            if time.monotonic() > deadline:
                sys.exit("no raw REPL prompt, got %r. Close CanMV IDE if it is connected; otherwise the board "
                         "is hung: power cycle it (unplug power/USB, wait 5 s) and run again" % buf[-200:])
            buf += ser.read(1)
        send_raw_paste(ser, script)
        print("script running on board; watch the screen for the countdown")
        pending = b""
        last_rx = time.monotonic()
        while True:
            chunk = ser.read(max(1, ser.in_waiting))
            if chunk:
                last_rx = time.monotonic()
                pending += chunk
                end = CTRL_D in pending                # 程序结束：stdout 结束标记，后面是错误输出
                head, _, tail = pending.partition(CTRL_D)
                lines = head.split(b"\n")
                pending = b"" if end else lines.pop()
                for ln in lines:
                    text = ln.decode(errors="replace").rstrip("\r\n")
                    if not text:
                        continue
                    log_lines.append(text)
                    print("board:", text)
                    if text.startswith("@RUNDIR "):
                        run_dir = text.split(None, 1)[1].strip()
                    elif text.startswith("@DONE"):
                        done = True
                if end:
                    err = tail
                    t_end = time.monotonic() + 3
                    while CTRL_D not in err and time.monotonic() < t_end:
                        err += ser.read(256)
                    err = err.split(CTRL_D)[0].decode(errors="replace").strip()
                    if err:
                        print("board error:\n" + err)
                        log_lines.append("ERROR: " + err)
                    break
            elif time.monotonic() - last_rx > args.idle_timeout:
                last = log_lines[-1] if log_lines else ""
                print("no output from board for %d s after %r; it is probably hung: power cycle it "
                      "(unplug power/USB, wait 5 s), then fetch what was saved with --fetch"
                      % (args.idle_timeout, last))
                break
    except KeyboardInterrupt:
        # 等板子跑完 finally（释放相机/显示/媒体）并回到 raw REPL 提示符再退出
        print("Ctrl-C: stopping the board script, waiting for it to release the cameras ...")
        ser.write(CTRL_C)
        tail = b""
        t_end = time.monotonic() + 20
        while time.monotonic() < t_end and not (tail.count(CTRL_D) >= 2 and tail.endswith(b">")):
            tail = (tail + ser.read(4096))[-2000:]
        print("board stopped cleanly" if tail.count(CTRL_D) >= 2 and tail.endswith(b">")
              else "board did not confirm it stopped; power cycle it before the next run")
    finally:
        try:
            ser.write(b"\r" + CTRL_B)
        finally:
            ser.close()
    if run_dir is None:
        print("board did not create a run directory; nothing to download")
        return None
    print("board run %s: %s" % (run_dir, "finished" if done else "NOT finished"))
    out = fetch(args.port, run_dir)
    (out / "board_log.txt").write_text("\n".join(log_lines) + "\n")
    return out


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--port", help="板子 USB 串口，例如 /dev/cu.usbmodem0010000001")
    ap.add_argument("--fetch", help="只下载板上已有目录，例如 /sdcard/beanlens/burst000")
    ap.add_argument("--analyze", type=pathlib.Path, help="只重新分析本地目录")
    ap.add_argument("--thresh", type=int, default=25, help="与背景的最大通道差阈值")
    ap.add_argument("--min-area", type=int, default=80, help="豆子连通块最小像素数")
    ap.add_argument("--scale", type=int, default=1, help="总览图放大倍数")
    ap.add_argument("--idle-timeout", type=int, default=60, help="多少秒没有板子日志就认为卡住")
    args = ap.parse_args()
    if args.analyze:
        out = args.analyze
    elif args.port and args.fetch:
        out = fetch(args.port, args.fetch)
    elif args.port:
        out = run_board(args)
    else:
        ap.error("need --port (optionally with --fetch) or --analyze")
    if out is not None and (out / "frames.csv").exists():
        analyze_dir(out, args.thresh, args.min_area, args.scale)


if __name__ == "__main__":
    main()
