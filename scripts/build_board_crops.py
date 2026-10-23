#!/usr/bin/env python3
"""Board captures -> 224x224 classification crops, split by physical bean.

Input: files copied off the BOX (firmware/k230d/bringup/capture_on_key.py), laid out as

    <src>/<class_name>/<class_name>_<bean:04d>_<shot:02d>.jpg      (1280x960 full frames)

Each file is cropped the way the board crops at inference time
(kmodel_live_classify.py: centre CROP_SIDE x CROP_SIDE square of the 1280x960 frame,
bilinear resize to 224x224), so train and deploy see the same pixels.

Split: all shots of one bean (same class + bean number) go to the same side, so the
front/back photos of a bean never straddle train/val/test. Files whose names do not
follow the pattern are treated as one bean each (and counted in the warnings).

Never overwrites: refuses to write into an existing --out directory, and does not
touch build_mydata.py output (datasets/mydata-16).

    .venv/bin/python scripts/build_board_crops.py --src mydata_board --out datasets/board-crops-v1
"""
import argparse
import json
import random
import re
import sys
from collections import defaultdict
from pathlib import Path

import cv2
import numpy as np
from PIL import Image

ROOT = Path(__file__).resolve().parents[1]
NAME_RE = re.compile(r"^(?P<cls>.+)_(?P<bean>\d{4})_(?P<shot>\d{2})\.jpg$", re.IGNORECASE)

# Cross-check against the board-side and mydata scripts so a silent constant drift
# (e.g. someone changes CROP_SIDE in kmodel_live_classify.py) fails loudly here.
def _cross_check() -> None:
    def grab(path: Path, pat: str):
        m = re.search(pat, path.read_text())
        return m.group(1) if m else None
    src_classes = grab(ROOT / "scripts" / "build_mydata.py", r"CLASSES\s*=\s*\[(.*?)\]")
    if src_classes and [c.strip(' "') for c in src_classes.split(",")] != CLASSES:
        print("CLASSES in build_board_crops.py differs from scripts/build_mydata.py — sync them")
        sys.exit(2)
    crop_side = grab(ROOT / "firmware" / "k230d" / "bringup" / "kmodel_live_classify.py",
                     r"CROP_SIDE\s*=\s*(\d+)")
    if crop_side and int(crop_side) != CROP_SIDE:
        print(f"CROP_SIDE mismatch: kmodel_live_classify.py={crop_side}, this script={CROP_SIDE}")
        sys.exit(2)

# keep in sync with build_mydata.py and capture_on_key.py
CLASSES = [
    "normal", "full_black", "partial_black", "full_sour", "partial_sour",
    "fungus", "severe_insect_damage", "broken", "cut", "immature",
    "withered", "fade", "shell", "husk", "parchment", "dry_cherry", "floater",
]
CROP_SIDE = 480   # must equal CROP_SIDE in kmodel_live_classify.py (checked at start)
SPLITS = ("train", "val", "test")


def collect(src: Path, warnings: list[str]) -> dict[str, dict[str, list[Path]]]:
    """class -> group_id -> [files]"""
    out: dict[str, dict[str, list[Path]]] = {}
    for cdir in sorted(d for d in src.iterdir() if d.is_dir()):
        cls = cdir.name
        if cls not in CLASSES:
            warnings.append(f"skipped unknown class folder: {cls}")
            continue
        groups: dict[str, list[Path]] = defaultdict(list)
        solo = 0
        ignored = 0
        for f in sorted(cdir.iterdir()):
            if f.suffix.lower() not in (".jpg", ".jpeg"):
                if f.suffix.lower() not in (".ds_store", ".tmp"):
                    ignored += 1
                continue
            m = NAME_RE.match(f.name)
            if m and m.group("cls") == cls:
                groups["bean" + m.group("bean")].append(f)
            else:
                groups["solo:" + f.name].append(f)
                solo += 1
        if ignored:
            warnings.append(f"{cls}: ignored {ignored} non-image file(s) (only .jpg/.jpeg are read)")
        if solo:
            warnings.append(f"{cls}: {solo} file(s) without bean number, each treated as its own bean")
        if groups:
            out[cls] = dict(groups)
    return out


def assign(groups: list[str], val_frac: float, test_frac: float, seed: int, cls: str,
           warnings: list[str]) -> dict[str, str]:
    ids = sorted(groups)
    random.Random(f"{seed}-{cls}").shuffle(ids)
    n = len(ids)
    if n < 3:
        warnings.append(f"{cls}: only {n} bean(s), all go to train; no val/test for this class")
        return {g: "train" for g in ids}
    n_test = max(1, round(n * test_frac)) if test_frac > 0 else 0
    n_val = max(1, round(n * val_frac)) if val_frac > 0 else 0
    res = {}
    for i, g in enumerate(ids):
        res[g] = "test" if i < n_test else "val" if i < n_test + n_val else "train"
    if n < 20:
        warnings.append(f"{cls}: only {n} beans, val/test have {n_val}/{n_test} bean(s); metrics will be very noisy")
    return res


def crop_one(path: Path, frame: tuple[int, int], side: int, size: int):
    im = Image.open(path).convert("RGB")
    if im.size != frame:
        return None, im.size
    arr = np.asarray(im)
    x0 = (frame[0] - side) // 2
    y0 = (frame[1] - side) // 2
    c = arr[y0:y0 + side, x0:x0 + side]
    # INTER_LINEAR = bilinear, no antialias, same family as the board's tf_bilinear/half_pixel
    c = cv2.resize(c, (size, size), interpolation=cv2.INTER_LINEAR)
    return Image.fromarray(c), im.size


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--src", type=Path, default=ROOT / "mydata_board")
    ap.add_argument("--out", type=Path, default=ROOT / "datasets" / "board-crops")
    ap.add_argument("--crop-side", type=int, default=CROP_SIDE, help="must equal CROP_SIDE in kmodel_live_classify.py")
    ap.add_argument("--size", type=int, default=224)
    ap.add_argument("--frame", default="1280x960")
    ap.add_argument("--val", type=float, default=0.15)
    ap.add_argument("--test", type=float, default=0.15)
    ap.add_argument("--seed", type=int, default=42)
    ap.add_argument("--quality", type=int, default=95)
    ap.add_argument("--dry-run", action="store_true")
    a = ap.parse_args()
    _cross_check()

    fw, fh = (int(v) for v in a.frame.lower().split("x"))
    frame = (fw, fh)
    if a.crop_side > min(fw, fh):
        print(f"crop-side {a.crop_side} larger than frame {a.frame}")
        return 2
    if a.val < 0 or a.test < 0 or a.val + a.test >= 0.9:
        print("--val/--test fractions invalid")
        return 2
    if not a.src.is_dir():
        print(f"source folder not found: {a.src}")
        return 2
    if not a.dry_run and a.out.exists() and any(a.out.iterdir()):
        print(f"refusing to write into existing non-empty folder: {a.out} (pick a new --out)")
        return 2

    warnings: list[str] = []
    data = collect(a.src, warnings)
    if not data:
        print("no class folders with jpg files found")
        return 1

    plan: dict[str, dict[str, str]] = {c: assign(list(g), a.val, a.test, a.seed, c, warnings)
                                       for c, g in data.items()}

    # leak check: a bean id must map to exactly one split (true by construction; verify anyway)
    for c, m in plan.items():
        assert len(m) == len(data[c])

    stats = {c: {s: {"beans": 0, "images": 0} for s in SPLITS} for c in data}
    bad_size = 0
    bad_decode = 0
    for c, groups in data.items():
        for gid, files in groups.items():
            split = plan[c][gid]
            saved_any = False
            for f in files:
                try:
                    img, sz = crop_one(f, frame, a.crop_side, a.size)
                except Exception as e:
                    bad_decode += 1
                    warnings.append(f"skipped {c}/{f.name}: cannot decode ({type(e).__name__}: {e})")
                    continue
                if img is None:
                    bad_size += 1
                    warnings.append(f"skipped {c}/{f.name}: size {sz[0]}x{sz[1]} != {a.frame}")
                    continue
                stats[c][split]["images"] += 1
                saved_any = True
                if not a.dry_run:
                    d = a.out / split / c
                    d.mkdir(parents=True, exist_ok=True)
                    img.save(d / f.name, quality=a.quality)
            if saved_any:
                stats[c][plan[c][gid]]["beans"] += 1

    print(f"\n{'class':<22}" + "".join(f"{s + ' b/img':>16}" for s in SPLITS))
    for c in sorted(stats):
        print(f"{c:<22}" + "".join(f"{stats[c][s]['beans']:>7}/{stats[c][s]['images']:<8}" for s in SPLITS))
    for w in warnings:
        print("WARN:", w)

    if not a.dry_run:
        manifest = {
            "source": str(a.src), "crop_side": a.crop_side, "size": a.size, "frame": a.frame,
            "resize": "cv2.INTER_LINEAR", "val_frac": a.val, "test_frac": a.test, "seed": a.seed,
            "jpeg_quality": a.quality, "stats": stats, "warnings": warnings,
            "split_by": "class+bean number (all shots of one bean on the same side)",
            "bean_assignment": {c: {s: sorted(g for g, v in m.items() if v == s) for s in SPLITS}
                                for c, m in plan.items()},
        }
        (a.out / "crop_manifest.json").write_text(json.dumps(manifest, indent=2, ensure_ascii=False))
        print(f"\nwritten: {a.out}  (manifest: crop_manifest.json)")
    return 0


if __name__ == "__main__":
    sys.exit(main())
