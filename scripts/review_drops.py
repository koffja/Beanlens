#!/usr/bin/env python3
"""Review drop_capture_dual.py output copied off the BOX: draw boxes, pair cameras.

Input: one or more drop_NNN directories (layout written by firmware/k230d/bringup/drop_capture_dual.py)

    drop_NNN/cam<id>_seq<NNNN>.jpg  (+ same-name .txt, YOLO "0 cx cy w h")
    drop_NNN/blur.txt  meta.txt  done.txt   (optional)

For every seq, cam images are put side by side with their auto boxes drawn, so one
look tells you: same bean in both views? box tight? blur? Output goes to a NEW
directory (refuses to write into a non-empty one) and the input is never modified.

    .venv/bin/python scripts/review_drops.py --src path/to/drop_000 --out tmp/review_drop_000

Flags written to summary.csv (a flag is a reason to look, not a verdict):
    no_box      jpg has no .txt sidecar (auto box found nothing)
    tiny_box    box area < 2% of frame
    huge_box    box area > 70% of frame (likely background or several beans)
    edge_box    box touches the frame border (bean cut off or background blob)
    blur        listed in blur.txt by the board (stdev proxy below baseline)
    missing_cam only one camera has this seq
"""
import argparse
import csv
import re
import sys
from collections import defaultdict
from pathlib import Path

import cv2
import numpy as np

NAME_RE = re.compile(r"^cam(?P<cam>\d+)_seq(?P<seq>\d+)\.jpg$", re.IGNORECASE)
PANE_H = 480            # each camera pane is scaled to this height in the review image
TINY_AREA, HUGE_AREA = 0.02, 0.70
EDGE_PX = 2             # box within this many source pixels of the border counts as touching


def read_box(txt: Path, w: int, h: int):
    """YOLO sidecar -> pixel box (x0, y0, x1, y1), or None when absent/unparseable."""
    if not txt.exists():
        return None
    try:
        parts = txt.read_text().split()
        _, cx, cy, bw, bh = parts[:5]
        cx, cy, bw, bh = float(cx) * w, float(cy) * h, float(bw) * w, float(bh) * h
    except (ValueError, IndexError):
        return None
    return cx - bw / 2, cy - bh / 2, cx + bw / 2, cy + bh / 2


def read_blur(drop: Path) -> set:
    f = drop / "blur.txt"
    if not f.exists():
        return set()
    return {line.split()[0] for line in f.read_text().splitlines() if line.strip()}


def box_flags(box, w: int, h: int):
    if box is None:
        return ["no_box"]
    x0, y0, x1, y1 = box
    flags = []
    area = max(0.0, x1 - x0) * max(0.0, y1 - y0) / (w * h)
    if area < TINY_AREA:
        flags.append("tiny_box")
    if area > HUGE_AREA:
        flags.append("huge_box")
    if x0 <= EDGE_PX or y0 <= EDGE_PX or x1 >= w - EDGE_PX or y1 >= h - EDGE_PX:
        flags.append("edge_box")
    return flags


def pane(img_path: Path, label: str, box, bad: bool):
    img = cv2.imread(str(img_path))
    if img is None:
        return None, None, None
    h, w = img.shape[:2]
    scale = PANE_H / h
    out = cv2.resize(img, (int(w * scale), PANE_H), interpolation=cv2.INTER_AREA)
    if box is not None:
        x0, y0, x1, y1 = (int(v * scale) for v in box)
        cv2.rectangle(out, (x0, y0), (x1, y1), (0, 0, 255) if bad else (0, 255, 0), 2)
    cv2.rectangle(out, (0, 0), (out.shape[1], 26), (0, 0, 0), -1)
    cv2.putText(out, label, (6, 19), cv2.FONT_HERSHEY_SIMPLEX, 0.6, (255, 255, 255), 1, cv2.LINE_AA)
    return out, w, h


def review_drop(drop: Path, out: Path, rows: list) -> None:
    by_seq = defaultdict(dict)
    for p in sorted(drop.iterdir()):
        m = NAME_RE.match(p.name)
        if m:
            by_seq[int(m["seq"])][int(m["cam"])] = p
    if not by_seq:
        print(f"[skip] {drop}: no cam*_seq*.jpg files", file=sys.stderr)
        return
    cams = sorted({c for d in by_seq.values() for c in d})
    blur = read_blur(drop)

    for seq in sorted(by_seq):
        panes, flags = [], []
        for cam in cams:
            p = by_seq[seq].get(cam)
            if p is None:
                flags.append(f"cam{cam}:missing_cam")
                continue
            img = cv2.imread(str(p))
            if img is None:
                flags.append(f"cam{cam}:unreadable")
                continue
            h, w = img.shape[:2]
            box = read_box(p.with_suffix(".txt"), w, h)
            f = box_flags(box, w, h)
            if p.stem in blur:
                f.append("blur")
            flags += [f"cam{cam}:{x}" for x in f]
            label = f"{drop.name} seq{seq:04d} cam{cam}" + (" [" + ",".join(f) + "]" if f else "")
            pn, _, _ = pane(p, label, box, bool(f))
            if pn is not None:
                panes.append(pn)
        if panes:
            cv2.imwrite(str(out / f"{drop.name}_seq{seq:04d}.jpg"), np.hstack(panes),
                        [cv2.IMWRITE_JPEG_QUALITY, 88])
        rows.append([drop.name, seq, len(by_seq[seq]), ";".join(flags)])


def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--src", nargs="+", required=True, type=Path, help="one or more drop_NNN directories")
    ap.add_argument("--out", required=True, type=Path, help="new directory for review images + summary.csv")
    args = ap.parse_args()

    for s in args.src:
        if not s.is_dir():
            print(f"error: {s} is not a directory", file=sys.stderr)
            return 2
    if args.out.exists() and any(args.out.iterdir()):
        print(f"error: {args.out} exists and is not empty; refusing to overwrite", file=sys.stderr)
        return 2
    args.out.mkdir(parents=True, exist_ok=True)

    rows = []
    for s in args.src:
        review_drop(s, args.out, rows)
        done = s / "done.txt"
        if done.exists():
            print(f"[{s.name}] done.txt: " + " | ".join(done.read_text().splitlines()))
        else:
            print(f"[{s.name}] no done.txt (run ended without clean exit; files may be partial)")

    with open(args.out / "summary.csv", "w", newline="") as f:
        w = csv.writer(f)
        w.writerow(["drop", "seq", "n_cams", "flags"])
        w.writerows(rows)

    flagged = [r for r in rows if r[3]]
    print(f"pairs reviewed: {len(rows)}   flagged: {len(flagged)}   -> {args.out}")
    for r in flagged[:20]:
        print(f"  {r[0]} seq{r[1]:04d}: {r[3]}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
