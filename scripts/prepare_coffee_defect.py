#!/usr/bin/env python3
"""Roboflow YOLO detection boxes -> ImageFolder classification crops.

Input : "Green Coffee Bean Defects.v2i.yolo26"/train  (640x640 images + YOLO txt)
Output: datasets/coffee-defect-16/{train,val}/<class>/<stem>_<i>.jpg

Split is by source image (filename stem before ".rf.") so the augmented copies
of the same photo never straddle train/val. All 16 Roboflow classes are kept
as-is (owner decision 10-11: they follow SCA green-coffee defect definitions).
"""
import random
import shutil
from collections import defaultdict
from pathlib import Path

from PIL import Image

SRC = Path(__file__).resolve().parents[1] / "Green Coffee Bean Defects.v2i.yolo26" / "train"
DST = Path(__file__).resolve().parents[1] / "datasets" / "coffee-defect-16"

VAL_FRAC = 0.15   # fraction of SOURCE images held out for val
MARGIN = 0.12     # bbox padding on each side, fraction of box size
MAX_SIDE = 224    # match yolo26n-cls imgsz
MIN_BOX_PX = 20   # discard degenerate boxes

ROBOFLOW_NAMES = [
    "broken", "cut", "dry_cherry", "fade", "floater", "full_black",
    "full_sour", "fungus", "husk", "immature", "parchment",
    "partial_black", "partial_sour", "severe_insect_damage", "shell", "withered",
]
# Keep every Roboflow class under its own SCA-faithful name; None = drop.
MAP = {name: name for name in ROBOFLOW_NAMES}


def main() -> None:
    images = sorted((SRC / "images").glob("*.jpg"))
    sources = defaultdict(list)
    for img in images:
        sources[img.name.split(".rf.")[0]].append(img)
    src_ids = sorted(sources)

    rng = random.Random(42)
    rng.shuffle(src_ids)
    n_val = round(len(src_ids) * VAL_FRAC)
    val_ids = set(src_ids[:n_val])

    if DST.exists():
        shutil.rmtree(DST)
    stats: dict[str, dict[str, int]] = defaultdict(lambda: defaultdict(int))
    skipped = 0

    for src_id in src_ids:
        split = "val" if src_id in val_ids else "train"
        for img_path in sources[src_id]:
            label_path = SRC / "labels" / (img_path.stem + ".txt")
            if not label_path.exists():
                skipped += 1
                continue
            with Image.open(img_path) as im:
                im = im.convert("RGB")
                W, H = im.size
                for i, line in enumerate(label_path.read_text().splitlines()):
                    parts = line.split()
                    if len(parts) != 5:
                        skipped += 1
                        continue
                    cid = int(parts[0])
                    target = MAP[ROBOFLOW_NAMES[cid]]
                    if target is None:
                        continue
                    xc, yc, bw, bh = (float(v) for v in parts[1:])
                    bw_px, bh_px = bw * W, bh * H
                    if bw_px < MIN_BOX_PX or bh_px < MIN_BOX_PX:
                        skipped += 1
                        continue
                    mx, my = bw * MARGIN, bh * MARGIN
                    x0 = max(0, int((xc - bw / 2 - mx) * W))
                    y0 = max(0, int((yc - bh / 2 - my) * H))
                    x1 = min(W, int((xc + bw / 2 + mx) * W))
                    y1 = min(H, int((yc + bh / 2 + my) * H))
                    crop = im.crop((x0, y0, x1, y1))
                    scale = MAX_SIDE / max(crop.size)
                    if scale < 1:
                        crop = crop.resize(
                            (round(crop.width * scale), round(crop.height * scale)),
                            Image.LANCZOS,
                        )
                    out_dir = DST / split / target
                    out_dir.mkdir(parents=True, exist_ok=True)
                    crop.save(out_dir / f"{img_path.stem}_{i}.jpg", quality=90)
                    stats[split][target] += 1

    print(f"sources: {len(src_ids)}  (train {len(src_ids) - len(val_ids)} / val {len(val_ids)})")
    print(f"{'class':<12}{'train':>7}{'val':>6}")
    classes = sorted({c for s in stats.values() for c in s})
    for c in classes:
        print(f"{c:<12}{stats['train'].get(c, 0):>7}{stats['val'].get(c, 0):>6}")
    total_train, total_val = sum(stats["train"].values()), sum(stats["val"].values())
    print(f"{'TOTAL':<12}{total_train:>7}{total_val:>6}  (skipped: {skipped})")


if __name__ == "__main__":
    main()
