#!/usr/bin/env python3
"""Ultralytics YOLO classification .pt -> ONNX -> K230 kmodel (nncase PTQ).

Two stages, run in two separate environments (do not install nncase into the
training .venv):

  export   training env (ultralytics)       .pt  -> .onnx
  compile  nncase env (Linux x86_64, py3.10) .onnx -> .kmodel, plus a
           host-side ONNX-vs-simulator check when onnxruntime is installed

Example:
  python scripts/convert_kmodel.py export  --weights yolo26n-cls.pt --out output/kmodel/yolo26n-cls-imagenet
  python scripts/convert_kmodel.py compile --out output/kmodel/yolo26n-cls-imagenet --calib-dir <images>

Target nncase is 2.9.0 = config/hardware-baseline.json candidate_local_release
(ATK CanMV v1.3). That pairing is NOT yet confirmed on the board
(installed_firmware is null); a kmodel from here is only "host converted".

Preprocessing baked into the kmodel matches Ultralytics classify inference:
RGB uint8 NCHW, x/255, mean 0, std 1. Resize-short-side + center-crop is NOT
inside the model; calibration does it here and the board must do the same.
"""
from __future__ import annotations

import argparse
import hashlib
import json
import shutil
import sys
from datetime import datetime, timezone
from pathlib import Path

TARGET_NNCASE = "2.9.0"
IMG_EXTS = {".jpg", ".jpeg", ".png", ".bmp"}


def sha256(path: Path) -> str:
    h = hashlib.sha256()
    with path.open("rb") as f:
        for chunk in iter(lambda: f.read(1 << 20), b""):
            h.update(chunk)
    return h.hexdigest()


def load_manifest(out: Path) -> dict:
    p = out / "manifest.json"
    return json.loads(p.read_text(encoding="utf-8")) if p.exists() else {}


def save_manifest(out: Path, manifest: dict) -> None:
    (out / "manifest.json").write_text(
        json.dumps(manifest, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")


# --------------------------------------------------------------------- export
def cmd_export(args: argparse.Namespace) -> None:
    from ultralytics import YOLO  # training env only

    src = Path(args.weights).resolve()
    out = Path(args.out).resolve()
    out.mkdir(parents=True, exist_ok=True)

    # Ultralytics writes the .onnx next to the .pt; export from a copy so a
    # user's existing root-level .onnx is never overwritten.
    pt = out / src.name
    if pt.resolve() != src:
        shutil.copy2(src, pt)

    model = YOLO(str(pt))
    if model.task != "classify":
        sys.exit(f"{src.name} is task={model.task!r}; this script only handles classify")
    onnx_path = Path(model.export(format="onnx", imgsz=args.imgsz, opset=args.opset,
                                  simplify=True, dynamic=False, batch=1))

    names = model.names
    labels = [names[i] for i in sorted(names)]
    (out / "labels.txt").write_text("\n".join(labels) + "\n", encoding="utf-8")

    import ultralytics
    save_manifest(out, {
        "source_weights": str(src),
        "source_weights_sha256": sha256(src),
        "ultralytics": ultralytics.__version__,
        "onnx": onnx_path.name,
        "onnx_sha256": sha256(onnx_path),
        "opset": args.opset,
        "input_shape": [1, 3, args.imgsz, args.imgsz],
        "num_classes": len(labels),
        "labels": "labels.txt",
        "exported_at": datetime.now(timezone.utc).isoformat(timespec="seconds"),
    })
    print(f"ONNX  -> {onnx_path}\nlabels -> {out / 'labels.txt'} ({len(labels)} classes)")


# -------------------------------------------------------------------- compile
def preprocess(path: Path, size: int):
    """Ultralytics classify_transforms: short side -> size, center crop, RGB."""
    import numpy as np
    from PIL import Image

    img = Image.open(path).convert("RGB")
    w, h = img.size
    s = size / min(w, h)
    img = img.resize((max(size, round(w * s)), max(size, round(h * s))), Image.BILINEAR)
    w, h = img.size
    left, top = (w - size) // 2, (h - size) // 2
    img = img.crop((left, top, left + size, top + size))
    # transpose() is a strided view; nncase RuntimeTensor.from_numpy reads the raw
    # buffer, so without a contiguous copy calibration and simulation get HWC data.
    return np.ascontiguousarray(np.asarray(img, dtype=np.uint8).transpose(2, 0, 1)[None])  # 1x3xHxW


def list_images(d: Path) -> list[Path]:
    return sorted(p for p in d.rglob("*") if p.suffix.lower() in IMG_EXTS)


def check_nncase_version(allow_mismatch: bool) -> str:
    from importlib.metadata import PackageNotFoundError, version

    found = {}
    for pkg in ("nncase", "nncase-kpu"):
        try:
            found[pkg] = version(pkg)
        except PackageNotFoundError:
            sys.exit(f"{pkg} not installed; pip install {pkg}=={TARGET_NNCASE} (Linux x86_64)")
    bad = {k: v for k, v in found.items() if v != TARGET_NNCASE}
    if bad and not allow_mismatch:
        sys.exit(f"expected nncase {TARGET_NNCASE} to match board runtime, found {found}; "
                 "pass --allow-version-mismatch only after confirming the board firmware")
    return found["nncase"]


def cmd_compile(args: argparse.Namespace) -> None:
    import nncase
    import numpy as np

    nncase_ver = check_nncase_version(args.allow_version_mismatch)
    out = Path(args.out).resolve()
    manifest = load_manifest(out)
    onnx_path = Path(args.onnx).resolve() if args.onnx else out / manifest.get("onnx", "")
    if not onnx_path.is_file():
        sys.exit(f"ONNX not found: {onnx_path}; run the export stage or pass --onnx")
    size = manifest.get("input_shape", [1, 3, args.imgsz, args.imgsz])[2]

    images = list_images(Path(args.calib_dir))
    if len(images) < args.calib_count:
        sys.exit(f"need {args.calib_count} calibration images, found {len(images)} in {args.calib_dir}")
    rng = np.random.default_rng(0)
    calib_paths = [images[i] for i in sorted(rng.choice(len(images), args.calib_count, replace=False))]
    calib = [preprocess(p, size) for p in calib_paths]

    opt = nncase.CompileOptions()
    opt.target = "k230"
    opt.dump_ir = False
    opt.dump_asm = False
    opt.dump_dir = str(out / "nncase_dump")
    opt.preprocess = True
    opt.input_type = "uint8"
    opt.input_shape = [1, 3, size, size]
    opt.input_layout = "NCHW"
    opt.input_range = [0, 1]
    opt.mean = [0, 0, 0]
    opt.std = [1, 1, 1]
    opt.swapRB = False  # board feeds RGB

    compiler = nncase.Compiler(opt)
    compiler.import_onnx(onnx_path.read_bytes(), nncase.ImportOptions())

    ptq = nncase.PTQTensorOptions()
    ptq.samples_count = len(calib)
    ptq.calibrate_method = args.calibrate_method
    ptq.quant_type = args.quant_type
    ptq.w_quant_type = args.w_quant_type
    ptq.finetune_weights_method = args.finetune
    ptq.set_tensor_data([[x] for x in calib])  # [sample][input]
    compiler.use_ptq(ptq)

    compiler.compile()
    kmodel_path = out / (onnx_path.stem + ".kmodel")
    kmodel_path.write_bytes(compiler.gencode_tobytes())
    print(f"kmodel -> {kmodel_path}")

    manifest.update({
        "kmodel": kmodel_path.name,
        "kmodel_sha256": sha256(kmodel_path),
        "nncase": nncase_ver,
        "target": "k230",
        "board_runtime_verified": False,
        "preprocess": {
            "kmodel_input": f"uint8 RGB NCHW 1x3x{size}x{size}",
            "inside_kmodel": "x/255, mean 0, std 1",
            "outside_kmodel": f"resize short side to {size} (bilinear), center crop {size}",
        },
        "ptq": {
            "calib_dir": str(Path(args.calib_dir).resolve()),
            "samples": len(calib),
            "seed": 0,
            "calibrate_method": args.calibrate_method,
            "quant_type": args.quant_type,
            "w_quant_type": args.w_quant_type,
            "finetune_weights_method": args.finetune,
        },
        "compiled_at": datetime.now(timezone.utc).isoformat(timespec="seconds"),
    })

    if not args.skip_check:
        check_images = list_images(Path(args.check_dir)) if args.check_dir else images
        manifest["host_check"] = host_check(onnx_path, kmodel_path, check_images, size, args.check_count,
                                            out, args.board_samples)
        manifest["host_check"]["check_dir"] = str(Path(args.check_dir or args.calib_dir).resolve())
    save_manifest(out, manifest)
    print(f"manifest -> {out / 'manifest.json'}")


def host_check(onnx_path: Path, kmodel_path: Path, images: list[Path], size: int, n: int,
               out: Path, board_samples: int) -> dict:
    """ONNX (float, x/255 on host) vs nncase simulator (uint8 in) on the same crops.

    The first `board_samples` checked crops are also written to out/board_test/
    as raw uint8 1x3xHxW .bin files plus reference.json, so the board can run
    the same tensors through the KPU (firmware/k230d/bringup/kmodel_static_check.py).
    """
    import nncase
    import numpy as np
    try:
        import onnxruntime as ort
    except ImportError:
        print("onnxruntime not installed; host check skipped")
        return {"skipped": "onnxruntime not installed"}

    sess = ort.InferenceSession(str(onnx_path), providers=["CPUExecutionProvider"])
    in_name = sess.get_inputs()[0].name
    sim = nncase.Simulator()
    sim.load_model(kmodel_path.read_bytes())

    picks = images[:: max(1, len(images) // n)][:n]
    board_dir = out / "board_test"
    if board_samples:
        board_dir.mkdir(exist_ok=True)
    reference = []
    top1_match, cosines = 0, []
    for i, p in enumerate(picks):
        x = preprocess(p, size)
        ref = sess.run(None, {in_name: x.astype(np.float32) / 255.0})[0].ravel()
        sim.set_input_tensor(0, nncase.RuntimeTensor.from_numpy(x))
        sim.run()
        got = sim.get_output_tensor(0).to_numpy().ravel()
        top1_match += int(ref.argmax() == got.argmax())
        cosines.append(float(ref @ got / (np.linalg.norm(ref) * np.linalg.norm(got) + 1e-12)))
        if i < board_samples:
            fname = f"{i:03d}.bin"
            (board_dir / fname).write_bytes(np.ascontiguousarray(x).tobytes())
            reference.append({
                "file": fname,
                "source": p.as_posix(),
                "folder_label": p.parent.name,
                "onnx_top1": int(ref.argmax()),
                "onnx_out": [round(float(v), 6) for v in ref],
                "sim_top1": int(got.argmax()),
                "sim_out": [round(float(v), 6) for v in got],
            })

    result = {
        "images": len(picks),
        "top1_agreement": top1_match / len(picks),
        "cosine_min": min(cosines),
        "cosine_mean": sum(cosines) / len(cosines),
        "note": "host simulator only; not a board (KPU) run",
    }
    if reference:
        (board_dir / "reference.json").write_text(json.dumps({
            "input": f"raw uint8 RGB NCHW 1x3x{size}x{size}, already resized/cropped",
            "samples": reference,
        }, indent=1, ensure_ascii=False) + "\n", encoding="utf-8")
        result["board_samples"] = len(reference)
    print(json.dumps(result, indent=2))
    return result


def main() -> None:
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    sub = ap.add_subparsers(dest="cmd", required=True)

    e = sub.add_parser("export", help=".pt -> .onnx (training env)")
    e.add_argument("--weights", required=True, help="Ultralytics classify .pt")
    e.add_argument("--out", required=True, help="new versioned output dir, e.g. output/kmodel/<name>")
    e.add_argument("--imgsz", type=int, default=224)
    e.add_argument("--opset", type=int, default=13)
    e.set_defaults(func=cmd_export)

    c = sub.add_parser("compile", help=".onnx -> .kmodel (nncase env)")
    c.add_argument("--out", required=True, help="same dir as export (reads manifest.json)")
    c.add_argument("--onnx", help="override ONNX path (default: from manifest)")
    c.add_argument("--calib-dir", required=True, help="images from real lighting/camera, searched recursively")
    c.add_argument("--calib-count", type=int, default=100)
    c.add_argument("--calibrate-method", default="NoClip", choices=["NoClip", "Kld"])
    # int16 default: on 2026-10-18 YOLO26n-cls/YOLO11n-cls, all-uint8 PTQ kept only
    # ~0.70 top1 agreement with ONNX on the simulator, int16 ~0.95 (cos 0.9997).
    c.add_argument("--quant-type", default="int16", choices=["uint8", "int8", "int16"],
                   help="activation quantization")
    c.add_argument("--w-quant-type", default="int16", choices=["uint8", "int8", "int16"],
                   help="weight quantization")
    c.add_argument("--finetune", default="NoFineTuneWeights", choices=["NoFineTuneWeights", "UseSquant"])
    c.add_argument("--imgsz", type=int, default=224, help="used only if manifest has no input_shape")
    c.add_argument("--check-count", type=int, default=50)
    c.add_argument("--check-dir", help="images for the ONNX-vs-simulator check (default: --calib-dir)")
    c.add_argument("--skip-check", action="store_true")
    c.add_argument("--board-samples", type=int, default=20,
                   help="write N checked crops + references to board_test/ (0 = none)")
    c.add_argument("--allow-version-mismatch", action="store_true")
    c.set_defaults(func=cmd_compile)

    args = ap.parse_args()
    args.func(args)


if __name__ == "__main__":
    main()
