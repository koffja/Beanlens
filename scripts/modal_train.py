#!/usr/bin/env python3
"""BeanLens model pipeline on Modal: train (GPU) -> ONNX -> K230 kmodel.

Usage (from repo root):

    modal run scripts/modal_train.py::main                       # yolo26n-cls, train + convert
    modal run scripts/modal_train.py::main --model yolo11n-cls.pt   # YOLO11n baseline
    modal run scripts/modal_train.py::main --no-convert             # train only
    modal run scripts/modal_train.py::convert --run <run-name> [--calib-dir <local dir>]
    ... [--quant-type uint8 --w-quant-type int16]           # default int16/int16
    ... --tag u8w16      # variant: kmodel/<run>-u8w16, same weights, new dir

Stages:
  train    GPU, ultralytics image; the dataset folder is baked into the image.
           Run written to Volume "beanlens-runs" at classify/<name>, copied to
           runs/modal/<name>/ locally.
  export   CPU, same ultralytics image: scripts/convert_kmodel.py export
  compile  CPU, separate Linux x86_64 / Python 3.10 / .NET 7 / nncase image:
           scripts/convert_kmodel.py compile (PTQ + ONNX-vs-simulator check on
           the val split, plus board_test/ samples for the on-board check).
           Result written to Volume at kmodel/<name>, copied to
           output/kmodel/<name>/ locally.

Without --calib-dir, PTQ calibrates on the public training crops. That is a
placeholder: AGENTS.md requires calibration from the real BOX lighting and
camera, so the manifest records the calibration source. A kmodel from here is
"host converted" only, not verified on the KPU.

Run names carry a timestamp; existing runs and kmodel dirs are never
overwritten.
"""
import hashlib
import io
import json
import os
import shutil
import subprocess
import tarfile
import tempfile
import time
from pathlib import Path

import modal

ROOT = Path(__file__).resolve().parents[1]
DATASET = "coffee-defect-16"
ULTRALYTICS = "ultralytics==8.4.175"
NNCASE = "2.9.0"  # = config/hardware-baseline.json candidate_local_release
CONVERTER = "/opt/beanlens/convert_kmodel.py"
CALIB_PLACEHOLDER = f"/data/{DATASET}/train"
CHECK_DIR = f"/data/{DATASET}/val"
REMOVE_SHIM = "/usr/local/lib/libfixremove.so"

app = modal.App("beanlens-train")
runs_vol = modal.Volume.from_name("beanlens-runs", create_if_missing=True)

image = (
    modal.Image.debian_slim(python_version="3.12")
    .apt_install("libgl1", "libglib2.0-0")
    .pip_install(ULTRALYTICS, "onnx", "onnxslim", "onnxruntime")
    .add_local_dir(ROOT / "datasets" / DATASET, f"/data/{DATASET}",
                   ignore=["*.cache", ".DS_Store"])
    .add_local_file(ROOT / "scripts" / "convert_kmodel.py", CONVERTER)
)

# nncase 2.x needs Linux x86_64 and the .NET 7 runtime; kept apart from the
# training image so neither environment constrains the other.
nncase_image = (
    modal.Image.debian_slim(python_version="3.10")
    .apt_install("curl", "ca-certificates", "libicu-dev")
    .run_commands(
        "curl -sSL https://dot.net/v1/dotnet-install.sh -o /tmp/dotnet-install.sh",
        "bash /tmp/dotnet-install.sh --channel 7.0 --runtime dotnet --install-dir /usr/share/dotnet",
        "ln -sf /usr/share/dotnet/dotnet /usr/bin/dotnet",
    )
    .env({"DOTNET_ROOT": "/usr/share/dotnet"})
    .pip_install(f"nncase=={NNCASE}", f"nncase-kpu=={NNCASE}", "numpy<2", "pillow", "onnxruntime")
    # nncase-kpu drops its simulator executable into site-packages, off PATH
    .run_commands("SP=$(python -c 'import sysconfig;print(sysconfig.get_paths()[\"purelib\"])') && "
                  "chmod +x $SP/nncase.simulator.k230.sc && "
                  "ln -sf $SP/nncase.simulator.k230.sc /usr/local/bin/nncase.simulator.k230.sc")
    # The simulator's std::filesystem::remove_all() calls glibc remove("dir/").
    # Under Modal's gVisor, unlink("dir/") fails with ENOTDIR instead of EISDIR,
    # so glibc never falls back to rmdir and nncase aborts. LD_PRELOAD shim,
    # applied only to the compile subprocess.
    .apt_install("gcc", "libc6-dev")
    .run_commands(
        "printf '%s\\n' '#define _GNU_SOURCE' '#include <errno.h>' '#include <sys/stat.h>' '#include <unistd.h>' "
        "'int remove(const char *p) { if (unlink(p) == 0) return 0; int e = errno; struct stat st; "
        "if ((e == EISDIR || e == ENOTDIR || e == EPERM) && stat(p, &st) == 0 && S_ISDIR(st.st_mode)) return rmdir(p); "
        "errno = e; return -1; }' > /tmp/fixremove.c && "
        f"gcc -shared -fPIC -O2 -o {REMOVE_SHIM} /tmp/fixremove.c"
    )
    .add_local_dir(ROOT / "datasets" / DATASET, f"/data/{DATASET}",
                   ignore=["*.cache", ".DS_Store"])
    .add_local_file(ROOT / "scripts" / "convert_kmodel.py", CONVERTER)
)


def _dataset_digest(root: Path) -> dict:
    h = hashlib.sha256()
    counts: dict[str, int] = {}
    for p in sorted(root.rglob("*.jpg")):
        rel = p.relative_to(root).as_posix()
        h.update(rel.encode())
        h.update(p.read_bytes())
        split = rel.split("/")[0]
        counts[split] = counts.get(split, 0) + 1
    return {"sha256": h.hexdigest(), "counts": counts}


def _per_class_recall(matrix, names: dict) -> dict:
    # ultralytics classify confusion matrix: rows = predicted, cols = true
    out = {}
    for i, name in names.items():
        support = float(matrix[:, i].sum())
        out[name] = {"recall": round(float(matrix[i, i]) / support, 4) if support else None,
                     "support": int(support)}
    return out


def _tar_dirs(dirs: dict[str, Path]) -> bytes:
    buf = io.BytesIO()
    with tarfile.open(fileobj=buf, mode="w:gz") as tar:
        for arcname, d in dirs.items():
            tar.add(d, arcname=arcname)
    return buf.getvalue()


def _untar(blob: bytes, dest: Path) -> None:
    dest.mkdir(parents=True, exist_ok=True)
    with tarfile.open(fileobj=io.BytesIO(blob), mode="r:gz") as tar:
        tar.extractall(dest, filter="data")


@app.function(image=image, gpu="L4", volumes={"/runs": runs_vol}, timeout=4 * 3600)
def train(model: str, name: str, epochs: int, imgsz: int, batch: int, seed: int) -> bytes:
    import platform

    import torch
    import ultralytics
    from ultralytics import YOLO

    data = Path(f"/data/{DATASET}")
    yolo = YOLO(model)  # downloads official pretrained weights inside container
    yolo.train(data=str(data), epochs=epochs, imgsz=imgsz, batch=batch, seed=seed,
               deterministic=True, project="/runs/classify", name=name,
               exist_ok=False, plots=True, workers=4)
    run_dir = Path("/runs/classify") / name

    best = YOLO(run_dir / "weights" / "best.pt")
    metrics = best.val(data=str(data), imgsz=imgsz, split="val", plots=True,
                       project="/runs/classify", name=f"{name}-val")
    meta = {
        "name": name,
        "model": model,
        "dataset": DATASET,
        "dataset_digest": _dataset_digest(data),
        "class_names": best.names,
        "epochs": epochs, "imgsz": imgsz, "batch": batch, "seed": seed,
        "val_top1": float(metrics.top1), "val_top5": float(metrics.top5),
        "val_recall_per_class": _per_class_recall(metrics.confusion_matrix.matrix, best.names),
        "ultralytics": ultralytics.__version__, "torch": torch.__version__,
        "python": platform.python_version(),
        "gpu": torch.cuda.get_device_name(0) if torch.cuda.is_available() else None,
        "best_pt_sha256": hashlib.sha256((run_dir / "weights" / "best.pt").read_bytes()).hexdigest(),
        "platform": "modal",
    }
    (run_dir / "modal_meta.json").write_text(json.dumps(meta, indent=2, ensure_ascii=False))
    runs_vol.commit()
    return _tar_dirs({name: run_dir, f"{name}-val": Path("/runs/classify") / f"{name}-val"})


@app.function(image=image, volumes={"/runs": runs_vol}, timeout=1800)
def export_onnx(name: str, imgsz: int, out_name: str = "") -> None:
    weights = Path("/runs/classify") / name / "weights" / "best.pt"
    out = Path("/runs/kmodel") / (out_name or name)
    if not weights.is_file():
        raise SystemExit(f"no weights on volume: {weights}")
    manifest = out / "manifest.json"
    if manifest.is_file():
        m = json.loads(manifest.read_text())
        if "kmodel" in m:
            raise SystemExit(f"refusing to overwrite compiled kmodel in {out}")
        if (out / m.get("onnx", "")).is_file():
            print(f"reusing exported ONNX {out / m['onnx']}")
            return
    elif out.exists():
        raise SystemExit(f"unexpected contents in {out}; inspect before re-running")
    subprocess.run(["python", CONVERTER, "export", "--weights", str(weights),
                    "--out", str(out), "--imgsz", str(imgsz)], check=True)
    runs_vol.commit()


@app.function(image=nncase_image, volumes={"/runs": runs_vol}, timeout=3600, memory=8192)
def compile_kmodel(name: str, calib_tar: bytes | None, calib_label: str, quant: list[str]) -> bytes:
    vol_out = Path("/runs/kmodel") / name
    if (vol_out / "manifest.json").is_file() and "kmodel" in json.loads((vol_out / "manifest.json").read_text()):
        raise SystemExit(f"refusing to overwrite compiled kmodel in {vol_out}")
    calib_dir = Path(CALIB_PLACEHOLDER)
    if calib_tar is not None:
        calib_dir = Path("/tmp/calib")
        _untar(calib_tar, calib_dir)

    # Compile on local disk, then copy back, so a failure leaves no half-written
    # kmodel on the volume. The simulator writes gmodel_dump_dir/ into cwd.
    work = Path(tempfile.mkdtemp()) / name
    shutil.copytree(vol_out, work)
    subprocess.run(["python", "-u", CONVERTER, "compile", "--out", str(work),
                    "--calib-dir", str(calib_dir), "--check-dir", CHECK_DIR, *quant],
                   check=True, cwd=work.parent, env={**os.environ, "LD_PRELOAD": REMOVE_SHIM})

    manifest_path = work / "manifest.json"
    manifest = json.loads(manifest_path.read_text())
    manifest["ptq"]["calib_source"] = calib_label
    manifest["converted_on"] = "modal (linux x86_64, python 3.10, .NET 7)"
    manifest_path.write_text(json.dumps(manifest, indent=2, ensure_ascii=False) + "\n")
    shutil.rmtree(work / "nncase_dump", ignore_errors=True)
    shutil.copytree(work, vol_out, dirs_exist_ok=True)
    runs_vol.commit()
    return _tar_dirs({name: work})


def _convert(name: str, imgsz: int, calib_dir: str, quant_type: str, w_quant_type: str,
             tag: str = "") -> None:
    dest = ROOT / "output" / "kmodel"
    out_name = f"{name}-{tag}" if tag else name
    if (dest / out_name).exists():
        raise SystemExit(f"refusing to overwrite {dest / out_name}")
    if calib_dir:
        src = Path(calib_dir).resolve()
        if not src.is_dir():
            raise SystemExit(f"calib dir not found: {src}")
        calib_tar, calib_label = _tar_dirs({"calib": src}), f"local:{src}"
    else:
        calib_tar = None
        calib_label = f"placeholder: public {DATASET}/train crops, not BOX lighting/camera"

    print(f"exporting ONNX for {name} ...")
    export_onnx.remote(name, imgsz, out_name)
    print("compiling kmodel (nncase) ...")
    quant = ["--quant-type", quant_type, "--w-quant-type", w_quant_type]
    _untar(compile_kmodel.remote(out_name, calib_tar, calib_label, quant), dest)
    manifest = json.loads((dest / out_name / "manifest.json").read_text())
    print(json.dumps({k: manifest.get(k) for k in
                      ("kmodel", "kmodel_sha256", "nncase", "ptq", "host_check")}, indent=2))
    print(f"saved to {dest / out_name}")


@app.local_entrypoint()
def main(model: str = "yolo26n-cls.pt", epochs: int = 100, imgsz: int = 224,
         batch: int = 64, seed: int = 0, gpu: str = "L4", convert: bool = True,
         calib_dir: str = "", quant_type: str = "int16", w_quant_type: str = "int16"):
    stem = model.removesuffix(".pt")
    name = f"{stem}-{DATASET}-{time.strftime('%Y%m%d-%H%M%S')}"
    out = ROOT / "runs" / "modal"
    if (out / name).exists():
        raise SystemExit(f"refusing to overwrite {out / name}")

    print(f"training {name} on Modal ({gpu}) ...")
    _untar(train.with_options(gpu=gpu).remote(model, name, epochs, imgsz, batch, seed), out)
    meta = json.loads((out / name / "modal_meta.json").read_text())
    print(json.dumps({k: meta[k] for k in ("name", "val_top1", "val_top5", "gpu")}, indent=2))
    print(f"saved to {out / name}")
    if convert:
        _convert(name, imgsz, calib_dir, quant_type, w_quant_type)


@app.local_entrypoint()
def convert(run: str, imgsz: int = 224, calib_dir: str = "",
            quant_type: str = "int16", w_quant_type: str = "int16", tag: str = ""):
    """Convert an existing run on the volume (classify/<run>) to kmodel.

    --tag writes a variant to kmodel/<run>-<tag> (e.g. other quant types)
    without touching the run's existing kmodel."""
    if tag and not tag.replace("-", "").isalnum():
        raise SystemExit("--tag: letters, digits and '-' only")
    _convert(run, imgsz, calib_dir, quant_type, w_quant_type, tag)
