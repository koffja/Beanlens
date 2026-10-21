#!/usr/bin/env python3
"""Own-photo annotation factory: tray/single-bean photos -> classification crops.

You sort beans by hand into piles, photograph each pile (or single beans) on a
plain background, drop the photos into

    mydata/<english_class_name>/*.jpg|heic

and run this script. It finds every bean in each photo, crops it, labels it
with the FOLDER name (that is the whole annotation), and writes

    datasets/mydata-16/{train,val}/<english_class_name>/<photo>_<i>.jpg

Split is 85/15 by photo (seed 42) so one photo's beans never straddle sides.
No bounding-box drawing is ever needed.

Shooting rules that keep auto-detection working:
  - plain matte background (white A4 / white tray), beans must contrast with it
  - beans must not touch each other; spacing >= half a bean
  - even light, no harsh shadows; camera 15-30 cm away, in focus
"""
import random
import shutil
import sys
from collections import defaultdict
from pathlib import Path

import cv2
import numpy as np
from PIL import Image

import pillow_heif

pillow_heif.register_heif_opener()

ROOT = Path(__file__).resolve().parents[1]
IN = ROOT / "mydata"
OUT = ROOT / "datasets" / "mydata-16"

CLASSES = [
    "normal", "full_black", "partial_black", "full_sour", "partial_sour",
    "fungus", "severe_insect_damage", "broken", "cut", "immature",
    "withered", "fade", "shell", "husk", "parchment", "dry_cherry", "floater",
]
EXTS = {".jpg", ".jpeg", ".png", ".heic"}

VAL_FRAC = 0.15   # by photo
MARGIN = 0.15     # bbox padding
MIN_CROP_PX = 40  # discard specks
MAX_AREA_FRAC = 0.5
MIN_AREA_PX = 500


def find_beans(gray: np.ndarray) -> list[tuple[int, int, int, int]]:
    h, w = gray.shape
    img_area = h * w
    boxes = []
    blur = cv2.GaussianBlur(gray, (9, 9), 0)
    for thr in (
        cv2.threshold(blur, 0, 255, cv2.THRESH_BINARY_INV + cv2.THRESH_OTSU)[1],
        cv2.adaptiveThreshold(blur, 255, cv2.ADAPTIVE_THRESH_GAUSSIAN_C,
                              cv2.THRESH_BINARY_INV, 51, 5),
    ):
        thr = cv2.morphologyEx(thr, cv2.MORPH_OPEN,
                               cv2.getStructuringElement(cv2.MORPH_ELLIPSE, (7, 7)))
        cnts, _ = cv2.findContours(thr, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)
        cand = []
        for c in cnts:
            x, y, bw, bh = cv2.boundingRect(c)
            area = bw * bh
            ar = bw / max(bh, 1)
            if (area < MIN_AREA_PX or area > MAX_AREA_FRAC * img_area
                    or not 0.3 < ar < 3.4):
                continue
            cand.append((x, y, bw, bh))
        if cand:
            boxes = cand
            break
    return boxes


def main() -> None:
    class_dirs = sorted(d for d in IN.iterdir() if d.is_dir()) if IN.exists() else []
    if not class_dirs:
        print(f"no photos yet: put them in {IN}/<class_name>/ and rerun")
        return
    unknown = [d.name for d in class_dirs if d.name not in CLASSES]
    if unknown:
        print(f"SKIPPED unknown class folders (rename to a known name): {unknown}")
        print(f"allowed: {CLASSES}")

    rng = random.Random(42)
    stats: dict[str, dict[str, int]] = defaultdict(lambda: defaultdict(int))
    if OUT.exists():
        shutil.rmtree(OUT)

    for cdir in class_dirs:
        cls = cdir.name
        if cls not in CLASSES:
            continue
        photos = sorted(p for p in cdir.iterdir() if p.suffix.lower() in EXTS)
        rng.shuffle(photos)
        for pi, photo in enumerate(photos):
            split = "val" if pi < round(len(photos) * VAL_FRAC) else "train"
            im = Image.open(photo).convert("RGB")
            gray = cv2.cvtColor(np.asarray(im), cv2.COLOR_RGB2GRAY)
            beans = find_beans(gray)
            if not beans:
                print(f"  !! no beans found in {photo.name} (check background/light)")
                continue
            W, H = im.size
            out_dir = OUT / split / cls
            out_dir.mkdir(parents=True, exist_ok=True)
            stem = photo.stem[:40]
            kept = 0
            for i, (x, y, bw, bh) in enumerate(beans):
                mx, my = bw * MARGIN, bh * MARGIN
                x0, y0 = max(0, int(x - mx)), max(0, int(y - my))
                x1, y1 = min(W, int(x + bw + mx)), min(H, int(y + bh + my))
                if x1 - x0 < MIN_CROP_PX or y1 - y0 < MIN_CROP_PX:
                    continue
                crop = im.crop((x0, y0, x1, y1))
                scale = 224 / max(crop.size)
                if scale < 1:
                    crop = crop.resize(
                        (round(crop.width * scale), round(crop.height * scale)),
                        Image.LANCZOS)
                crop.save(out_dir / f"{stem}_{i}.jpg", quality=90)
                kept += 1
            stats[cls][split] += kept
            print(f"  {cls}/{photo.name}: {kept} beans -> {split}")

    print(f"\n{'class':<22}{'train':>7}{'val':>6}")
    for cls in sorted(stats):
        print(f"{cls:<22}{stats[cls].get('train', 0):>7}{stats[cls].get('val', 0):>6}")
    print(f"{'TOTAL':<22}{sum(stats[c].get('train', 0) for c in stats):>7}"
          f"{sum(stats[c].get('val', 0) for c in stats):>6}")


if __name__ == "__main__":
    sys.exit(main())
