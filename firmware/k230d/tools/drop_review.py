"""检查 drop_capture.py 拍到的落豆帧（电脑端运行，需要 numpy + Pillow）。

用法：
    python3 drop_review.py <dropNNN 目录> [--out 输出目录] [--thresh 25] [--min-area 30]

对每个事件（每颗豆一组连拍）：
  - 重复帧：与同相机上一组逐像素完全相同 → 连拍取到了同一帧（循环快于传感器帧率）；
  - 背景：同事件同相机所有组逐像素中值（豆在不同组的位置不同，中值近似空背景）；
  - 豆子：|帧 - 背景| 的最大通道差 > --thresh 的像素，取最大连通块外框；
    报告外框宽高（px）、面积、长宽比。豆本身约椭圆，长宽比明显大于 1.5 且沿下落方向拉长说明有拖影；
    拖影长度粗估 = 长边 - 短边（px）。
  - 生成 event_NN.png：两行（cam1 / cam2）× 组数，帧上画出豆子外框，便于目测。
只读原始数据；输出写到 <目录>_review/。结果是粗筛，不替代人工看图。
"""

import argparse
import csv
import pathlib
import sys

import numpy as np
from PIL import Image, ImageDraw


def read_meta(folder):
    meta = {}
    for line in (folder / "meta.txt").read_text().splitlines():
        if "=" in line:
            k, v = line.split("=", 1)
            meta[k.strip()] = v.strip()
    return meta


def rgb565_to_rgb(data, w, h):
    px = np.frombuffer(data, dtype="<u2").reshape(h, w)
    r = ((px >> 11) & 0x1F).astype(np.uint16) * 255 // 31
    g = ((px >> 5) & 0x3F).astype(np.uint16) * 255 // 63
    b = (px & 0x1F).astype(np.uint16) * 255 // 31
    return np.stack([r, g, b], axis=-1).astype(np.uint8)


def largest_blob(mask):
    # 4 邻域连通块，纯 numpy/python 实现（图很小）
    h, w = mask.shape
    seen = np.zeros_like(mask, dtype=bool)
    best = None
    ys, xs = np.nonzero(mask)
    for y0, x0 in zip(ys, xs):
        if seen[y0, x0]:
            continue
        stack = [(y0, x0)]
        seen[y0, x0] = True
        pts = []
        while stack:
            y, x = stack.pop()
            pts.append((y, x))
            for dy, dx in ((1, 0), (-1, 0), (0, 1), (0, -1)):
                ny, nx = y + dy, x + dx
                if 0 <= ny < h and 0 <= nx < w and mask[ny, nx] and not seen[ny, nx]:
                    seen[ny, nx] = True
                    stack.append((ny, nx))
        if best is None or len(pts) > len(best):
            best = pts
    if not best:
        return None
    a = np.array(best)
    y1, x1 = a.min(axis=0)
    y2, x2 = a.max(axis=0)
    return int(x1), int(y1), int(x2), int(y2), len(best)


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("folder", type=pathlib.Path)
    ap.add_argument("--out", type=pathlib.Path)
    ap.add_argument("--thresh", type=int, default=25)
    ap.add_argument("--min-area", type=int, default=30)
    ap.add_argument("--scale", type=int, default=2, help="总览图放大倍数")
    args = ap.parse_args()

    folder = args.folder
    meta = read_meta(folder)
    w, h = int(meta["width"]), int(meta["height"])
    if meta.get("save_mode") != "raw":
        sys.exit("only raw rgb565stream runs are supported")
    out = args.out or folder.parent / (folder.name + "_review")
    out.mkdir(parents=True, exist_ok=True)

    streams = {}
    frames = {}   # (event, group) -> {cam: rgb}
    for row in csv.DictReader((folder / "index.csv").open()):
        cam, fno = int(row["cam"]), int(row["frame"])
        off, ln = int(row["offset"]), int(row["length"])
        path = folder / ("cam%d.rgb565stream" % cam)
        if not path.exists():
            continue
        if cam not in streams:
            streams[cam] = path.read_bytes()
        data = streams[cam][off:off + ln]
        if len(data) != ln:
            continue
        frames.setdefault((fno // 100, fno % 100), {})[cam] = rgb565_to_rgb(data, w, h)
    if not frames:
        sys.exit("no frames found (stream files missing?)")
    cams = sorted({c for v in frames.values() for c in v})
    events = sorted({e for e, _ in frames})

    report = []
    for ev in events:
        groups = sorted(g for e, g in frames if e == ev)
        sheet = Image.new("RGB", (w * len(groups), h * len(cams)), (40, 40, 40))
        draw = ImageDraw.Draw(sheet)
        for ci, cam in enumerate(cams):
            stack = [frames[(ev, g)].get(cam) for g in groups]
            if any(s is None for s in stack):
                continue
            bg = np.median(np.stack(stack).astype(np.int16), axis=0)
            prev = None
            for gi, img in enumerate(stack):
                dup = prev is not None and np.array_equal(img, prev)
                prev = img
                diff = np.abs(img.astype(np.int16) - bg).max(axis=-1)
                blob = largest_blob(diff > args.thresh)
                rec = {"event": ev, "group": gi, "cam": cam, "duplicate": int(dup),
                       "x1": "", "y1": "", "bw": "", "bh": "", "area": 0, "aspect": "", "streak_px": ""}
                sheet.paste(Image.fromarray(img), (gi * w, ci * h))
                if blob and blob[4] >= args.min_area:
                    x1, y1, x2, y2, area = blob
                    bw, bh = x2 - x1 + 1, y2 - y1 + 1
                    rec.update(x1=x1, y1=y1, bw=bw, bh=bh, area=area,
                               aspect="%.2f" % (max(bw, bh) / min(bw, bh)),
                               streak_px=max(bw, bh) - min(bw, bh))
                    draw.rectangle([gi * w + x1, ci * h + y1, gi * w + x2, ci * h + y2], outline=(255, 0, 0))
                label = "cam%d g%d%s" % (cam, gi, " DUP" if dup else "")
                draw.text((gi * w + 3, ci * h + 2), label, fill=(255, 255, 0))
                report.append(rec)
        if args.scale > 1:
            sheet = sheet.resize((sheet.width * args.scale, sheet.height * args.scale), Image.NEAREST)
        sheet.save(out / ("event_%02d.png" % ev))

    keys = ["event", "group", "cam", "duplicate", "x1", "y1", "bw", "bh", "area", "aspect", "streak_px"]
    with (out / "review.csv").open("w", newline="") as f:
        wr = csv.DictWriter(f, fieldnames=keys)
        wr.writeheader()
        wr.writerows(report)

    n = len(report)
    dups = sum(r["duplicate"] for r in report)
    hits = [r for r in report if r["area"]]
    print("frames %d, duplicates %d, frames with a blob %d -> %s" % (n, dups, len(hits), out))
    for ev in events:
        per = [r for r in hits if r["event"] == ev]
        desc = ", ".join("cam%d g%d %sx%s ar%s" % (r["cam"], r["group"], r["bw"], r["bh"], r["aspect"]) for r in per)
        print("event %02d: %s" % (ev, desc or "no blob"))


if __name__ == "__main__":
    main()
