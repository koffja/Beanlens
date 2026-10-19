# BeanLens kmodel 静态对照（bring-up 用，不接相机）
# 目标：正点原子 K230D BOX + CanMV（ATK v1.3-8dd764f）
# 功能：读取主机已预处理好的样本（raw uint8 RGB NCHW 1x3x224x224），在 KPU 上推理，
#      与主机 ONNX / nncase 模拟器的参考输出比对，打印 top1 一致率、输出差值和推理耗时，
#      结果写到 MODEL_DIR/board_check_<ticks>.json。只新建结果文件，不覆盖已有文件。
#
# 准备（电脑上）：把 output/kmodel/<run>/ 里的这些文件拷到 TF 卡 MODEL_DIR：
#   best.kmodel、labels.txt、manifest.json、board_test/（*.bin + reference.json）
#
# 接口来源：libs.AIBase / nncase_runtime.from_numpy 用法取自正点原子 CanMV v1.3
#   AI Hub 例程（keyword_spotting.py、dynamic_gesture.py）。尚未在本机实测。
#
# 判读：
#   - board_vs_sim_top1 应接近 1.0；明显偏低说明板端运行时与 nncase 2.9.0 不配套，或输入格式不对
#   - board_vs_onnx_top1 反映量化损失，主机 manifest.host_check 里有同一批样本的模拟器值

import gc
import os
import time
import ujson
import nncase_runtime as nn
import ulab.numpy as np
from libs.AIBase import AIBase

MODEL_DIR = "/sdcard/beanlens/model"
KMODEL = "best.kmodel"
INPUT_SIZE = 224
BIN_BYTES = 3 * INPUT_SIZE * INPUT_SIZE


def read_lines(path):
    with open(path, "r") as f:
        return [s.strip() for s in f.read().split("\n") if s.strip()]


def argmax(vec):
    best, idx = vec[0], 0
    for i in range(1, len(vec)):
        if vec[i] > best:
            best, idx = vec[i], i
    return idx


def main():
    labels = read_lines(MODEL_DIR + "/labels.txt")
    with open(MODEL_DIR + "/board_test/reference.json", "r") as f:
        ref = ujson.load(f)
    samples = ref["samples"]
    print("kmodel:", KMODEL, "classes:", len(labels), "samples:", len(samples))

    model = AIBase(MODEL_DIR + "/" + KMODEL, [INPUT_SIZE, INPUT_SIZE], [INPUT_SIZE, INPUT_SIZE])
    rows = []
    sim_match = 0
    onnx_match = 0
    max_diff_all = 0.0
    times = []
    try:
        for s in samples:
            with open(MODEL_DIR + "/board_test/" + s["file"], "rb") as f:
                data = f.read()
            if len(data) != BIN_BYTES:
                raise ValueError("%s: %d bytes, expected %d" % (s["file"], len(data), BIN_BYTES))
            x = np.frombuffer(data, dtype=np.uint8).reshape((1, 3, INPUT_SIZE, INPUT_SIZE))

            t0 = time.ticks_us()
            out = model.inference([nn.from_numpy(x)])[0]
            dt = time.ticks_diff(time.ticks_us(), t0)
            times.append(dt)

            vec = [float(v) for v in out.flatten()]
            top1 = argmax(vec)
            diff = 0.0
            for a, b in zip(vec, s["sim_out"]):
                d = abs(a - b)
                if d > diff:
                    diff = d
            max_diff_all = max(max_diff_all, diff)
            sim_match += int(top1 == s["sim_top1"])
            onnx_match += int(top1 == s["onnx_top1"])
            rows.append({"file": s["file"], "board_top1": top1, "sim_top1": s["sim_top1"],
                         "onnx_top1": s["onnx_top1"], "max_abs_diff_vs_sim": diff, "us": dt})
            print("%s board=%s sim=%s onnx=%s folder=%s diff=%.4f %dus" % (
                s["file"], labels[top1], labels[s["sim_top1"]], labels[s["onnx_top1"]],
                s["folder_label"], diff, dt))
            del x, out, data
            gc.collect()
    finally:
        model.deinit()

    n = len(rows)
    times.sort()
    result = {
        "kmodel": KMODEL,
        "uname": str(os.uname()),
        "samples": n,
        "board_vs_sim_top1": sim_match / n if n else None,
        "board_vs_onnx_top1": onnx_match / n if n else None,
        "max_abs_diff_vs_sim": max_diff_all,
        "inference_us_median": times[n // 2] if n else None,
        "inference_us_max": times[-1] if n else None,
        "note": "KPU inference only (from_numpy -> inference); excludes camera, crop and resize",
        "rows": rows,
    }
    out_path = "%s/board_check_%d.json" % (MODEL_DIR, time.ticks_ms())
    with open(out_path, "w") as f:
        ujson.dump(result, f)
    print("board_vs_sim_top1=%s board_vs_onnx_top1=%s max_diff=%.4f median=%sus" % (
        result["board_vs_sim_top1"], result["board_vs_onnx_top1"], max_diff_all,
        result["inference_us_median"]))
    print("result ->", out_path)


try:
    main()
finally:
    gc.collect()
    nn.shrink_memory_pool()
