# BeanLens kmodel 实时分类（bring-up 用，单摄、单豆、无执行器）
# 目标：正点原子 K230D BOX + CanMV（ATK v1.3-8dd764f）
# 功能：摄像头连续采集 → 画面中心正方形裁剪 → Ai2d 缩放到 224 → KPU 分类 →
#      在 LCD 上画取景框、top-3 类别与概率、帧率和单帧耗时。
#      退出时（IDE 停止）把耗时统计写到 MODEL_DIR/live_run_<ticks>.json，不保存任何图像。
#
# 准备：先跑通 kmodel_static_check.py（board_vs_sim_top1 接近 1.0），再跑本脚本。
#   板端 MODEL_DIR（板载 SD NAND 的 /sdcard，不是 TF 卡）需要：best.kmodel、labels.txt、manifest.json
#
# 预处理须与训练一致（见 manifest.json preprocess）：
#   kmodel 输入 uint8 RGB NCHW 1x3x224x224，/255 在 kmodel 内部完成。
#   训练/转换为“短边缩放到 224 + 中心裁剪 224”；这里先裁中心正方形再缩放到 224，
#   对正方形区域等价（插值实现可能有细微差异）。
#   训练图是单豆完整裁图，所以要让一颗豆基本填满黄色取景框；
#   框里只有背景或多颗豆时结果没有意义。
#
# 接口来源：libs.PipeLine / AIBase / Ai2d、Sensor、draw_string_advanced 用法取自正点原子
#   CanMV v1.3 AI Hub 例程 self_learning.py。尚未在本机实测。
#
# 判读：
#   - top1 概率低于 MIN_CONF 显示“未判定”，未判定不算正常豆。
#   - 光照、相机和豆种与公开训练集不同，屏上结果只说明模型能在板上跑通，不代表端侧准确率。

import gc
from media.media import *
from media.sensor import *
# 标准模块放在 media 的 * 导入之后：* 导入会覆盖同名的 sys 等（板上实测 sys.print_exception 丢失）
import os
import sys
import time
import ujson
import nncase_runtime as nn
import ulab.numpy as np
from libs.PipeLine import PipeLine, ScopedTiming
from libs.AIBase import AIBase
from libs.AI2D import Ai2d

MODEL_DIR = "/sdcard/beanlens/model-u8w16"
KMODEL = "best.kmodel"
MODEL_INPUT = [224, 224]
SENSOR_SIZE = [1280, 960]   # 送给 AI 的 RGB888P 分辨率，与例程一致
SENSOR_ID = None            # None 用 CanMV 默认摄像头；画面不对时改成 1 或 2 指定 CSI 口（待实机确认编号）
DISPLAY_MODE = "lcd"
DISPLAY_SIZE = [640, 480]
CROP_SIDE = 480             # 中心正方形裁剪边长（传感器像素），按豆在画面中的大小调整，不超过 960
MIN_CONF = 0.5              # top1 概率低于此值显示“未判定”
TOP_K = 3
MAX_TIMING_SAMPLES = 300    # 耗时统计只保留最近 N 帧，避免内存增长
FOCUS_EVERY = 5             # 每 N 帧算一次取景框内清晰度（调焦用）；0 关闭
FOCUS_STEP = 2              # 清晰度计算的抽样步长（像素）


def read_lines(path):
    with open(path, "r") as f:
        return [s.strip() for s in f.read().split("\n") if s.strip()]


def read_manifest():
    try:
        with open(MODEL_DIR + "/manifest.json", "r") as f:
            return ujson.load(f)
    except Exception as e:
        print("manifest.json 读取失败:", e)
        return {}


def sharpness(img, crop):
    # 取景框内 G 通道的平均梯度幅值。只作调焦时的相对比较：同一场景下越大越清楚，
    # 不同光照、背景之间不可比。img 为 PipeLine.get_frame() 的 RGB888P 数组 (3, H, W)。
    x, y, w, h = crop
    g = np.array(img[1, y:y + h:FOCUS_STEP, x:x + w:FOCUS_STEP], dtype=np.float)
    dx = np.mean(abs(g[:, 1:] - g[:, :-1]))
    dy = np.mean(abs(g[1:, :] - g[:-1, :]))
    return float(dx + dy)


def top_k(vec, k):
    idx = sorted(range(len(vec)), key=lambda i: -vec[i])
    return [(i, vec[i]) for i in idx[:k]]


class BeanClassifier(AIBase):
    def __init__(self, kmodel_path, model_input_size, rgb888p_size, display_size, crop_side):
        super().__init__(kmodel_path, model_input_size, rgb888p_size, 0)
        self.model_input_size = model_input_size
        self.rgb888p_size = [ALIGN_UP(rgb888p_size[0], 16), rgb888p_size[1]]
        self.display_size = [ALIGN_UP(display_size[0], 16), display_size[1]]
        side = min(crop_side, self.rgb888p_size[0], self.rgb888p_size[1])
        self.crop = (int((self.rgb888p_size[0] - side) / 2), int((self.rgb888p_size[1] - side) / 2),
                     side, side)
        sx = self.display_size[0] / self.rgb888p_size[0]
        sy = self.display_size[1] / self.rgb888p_size[1]
        self.crop_osd = (int(self.crop[0] * sx), int(self.crop[1] * sy),
                         int(self.crop[2] * sx), int(self.crop[3] * sy))
        self.ai2d = Ai2d(0)
        self.ai2d.set_ai2d_dtype(nn.ai2d_format.NCHW_FMT, nn.ai2d_format.NCHW_FMT,
                                 np.uint8, np.uint8)

    def config_preprocess(self, input_image_size=None):
        size = input_image_size if input_image_size else self.rgb888p_size
        x, y, w, h = self.crop
        self.ai2d.crop(x, y, w, h)
        self.ai2d.resize(nn.interp_method.tf_bilinear, nn.interp_mode.half_pixel)
        self.ai2d.build([1, 3, size[1], size[0]],
                        [1, 3, self.model_input_size[1], self.model_input_size[0]])

    def postprocess(self, results):
        # YOLO-CLS 导出的输出已含 softmax，形状 (1, num_classes)
        return [float(v) for v in results[0][0]]


def draw(pl, clf, labels, ranked, fps, frame_ms, focus):
    osd = pl.osd_img
    osd.clear()
    x, y, w, h = clf.crop_osd
    osd.draw_rectangle(x, y, w, h, color=(255, 255, 255, 0), thickness=3)
    best_i, best_p = ranked[0]
    if best_p < MIN_CONF:
        head, color = "未判定 (%.2f)" % best_p, (255, 255, 128, 0)
    else:
        head, color = "%s %.2f" % (labels[best_i], best_p), (255, 0, 255, 0)
    osd.draw_string_advanced(10, 8, 32, head, color=color)
    ty = 48
    for i, p in ranked[1:]:
        osd.draw_string_advanced(10, ty, 22, "%s %.2f" % (labels[i], p), color=(255, 200, 200, 200))
        ty += 26
    osd.draw_string_advanced(10, clf.display_size[1] - 30, 20,
                             "%.1f fps  %d ms/帧" % (fps, frame_ms), color=(255, 200, 200, 200))
    if focus is not None:
        cur, best = focus
        osd.draw_string_advanced(clf.display_size[0] - 260, clf.display_size[1] - 30, 20,
                                 "清晰度 %.1f / 最高 %.1f" % (cur, best), color=(255, 255, 255, 0))


def write_summary(manifest, labels, times_us, frames, started_ms):
    times = sorted(times_us)
    n = len(times)
    result = {
        "script": "kmodel_live_classify.py",
        "kmodel": KMODEL,
        "kmodel_sha256_manifest": manifest.get("kmodel_sha256"),
        "nncase_manifest": manifest.get("nncase"),
        "uname": str(os.uname()),
        "classes": len(labels),
        "sensor_size": SENSOR_SIZE,
        "sensor_id": SENSOR_ID,
        "crop_side": CROP_SIDE,
        "min_conf": MIN_CONF,
        "frames": frames,
        "elapsed_ms": time.ticks_diff(time.ticks_ms(), started_ms),
        "timing_window": n,
        "run_us_median": times[n // 2] if n else None,
        "run_us_max": times[-1] if n else None,
        "note": "run_us = Ai2d crop/resize + KPU + postprocess; excludes get_frame and OSD",
    }
    path = "%s/live_run_%d.json" % (MODEL_DIR, time.ticks_ms())
    with open(path, "w") as f:
        ujson.dump(result, f)
    print("median=%sus max=%sus frames=%d -> %s" % (
        result["run_us_median"], result["run_us_max"], frames, path))


def main():
    labels = read_lines(MODEL_DIR + "/labels.txt")
    manifest = read_manifest()
    if manifest.get("num_classes") not in (None, len(labels)):
        raise ValueError("labels.txt %d 类，manifest %s 类" % (len(labels), manifest["num_classes"]))
    print("kmodel:", KMODEL, "sha256(manifest):", manifest.get("kmodel_sha256"),
          "classes:", len(labels))

    if SENSOR_ID is None:
        sensor = Sensor(width=SENSOR_SIZE[0], height=SENSOR_SIZE[1])
    else:
        sensor = Sensor(id=SENSOR_ID, width=SENSOR_SIZE[0], height=SENSOR_SIZE[1])
    pl = PipeLine(rgb888p_size=SENSOR_SIZE, display_size=DISPLAY_SIZE, display_mode=DISPLAY_MODE)
    pl.create(sensor=sensor)
    clf = BeanClassifier(MODEL_DIR + "/" + KMODEL, MODEL_INPUT, SENSOR_SIZE, DISPLAY_SIZE, CROP_SIDE)
    clf.config_preprocess()

    times_us = []
    frames = 0
    started_ms = time.ticks_ms()
    last_ms = started_ms
    fps = 0.0
    focus = None
    focus_best = 0.0
    focus_on = FOCUS_EVERY > 0
    try:
        while True:
            os.exitpoint()
            img = pl.get_frame()
            t0 = time.ticks_us()
            probs = clf.run(img)
            dt = time.ticks_diff(time.ticks_us(), t0)
            times_us.append(dt)
            if len(times_us) > MAX_TIMING_SAMPLES:
                times_us.pop(0)
            frames += 1

            now = time.ticks_ms()
            frame_ms = time.ticks_diff(now, last_ms)
            last_ms = now
            if frame_ms > 0:
                fps = 0.9 * fps + 0.1 * (1000.0 / frame_ms) if fps else 1000.0 / frame_ms

            ranked = top_k(probs, TOP_K)
            if focus_on and frames % FOCUS_EVERY == 1:
                try:
                    cur = sharpness(img, clf.crop)
                    focus_best = max(focus_best, cur)
                    focus = (cur, focus_best)
                except Exception as e:
                    focus_on = False
                    focus = None
                    print("清晰度计算不可用，已关闭:", e)
            draw(pl, clf, labels, ranked, fps, dt // 1000, focus)
            pl.show_image()
            if frames % 30 == 0:
                print("%s %.3f | %.1f fps %dus | focus %s" % (labels[ranked[0][0]], ranked[0][1], fps, dt,
                                                              "%.1f" % focus[0] if focus else "-"))
            del probs
            gc.collect()
    except Exception as e:
        sys.print_exception(e)
    finally:
        try:
            write_summary(manifest, labels, times_us, frames, started_ms)
        except Exception as e:
            print("统计写入失败:", e)
        clf.deinit()
        pl.destroy()


try:
    main()
finally:
    gc.collect()
    nn.shrink_memory_pool()
