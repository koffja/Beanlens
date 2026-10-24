# BeanLens 落豆全流程（bring-up 用，无执行器）：双摄抓拍 → 找豆 → 裁图 → KPU 分类 → 双面合并 → 屏幕计数
# 目标：正点原子 K230D BOX + CanMV（ATK v1.3-8dd764f）
# 前提：假设图像已经“干净”（补光、背景板、对焦已按 drop_capture.py 调好）；先用 drop_capture.py MODE="focus" 对焦，
#      确认 ROI 罩住豆道，再跑本脚本。kmodel 先用 kmodel_static_check.py 跑通板端对照。
# 开机自启：复制为 /sdcard/main.py（TF 启动时即读卡器里 SDCARD 分区根目录的 main.py）。启动前等待 AUTORUN_DELAY_S 秒，
#      期间可用 IDE 停止或串口 Ctrl-C 跳过；若开机即卡死，在电脑上把卡里的 main.py 改名即可取消自启。
#
# 每颗豆的处理（一次触发 = 一个候选）：
#   1. 采集与触发沿用 drop_capture.py v5：两路 1920x1080@30、chn0 RGB565 CAP_W x CAP_H、不 bind、只对第一个 sensor run()；
#      ROI 内网格亮度差触发。v2 起 ROI 沿下落方向取满画面高度（豆在 ROI 内停留更久），待机时每帧保留上一组 ROI 副本
#      （PRE_TRIGGER），触发后用“上一组 + 触发组 + 随后 BURST_AFTER 组”，copy 后立即释放相机缓冲。
#      触发后不再重学背景：画面连续 REARM_QUIET 帧无变化即重新待命；超过 REARM_TIMEOUT_MS 仍有变化才重学背景。
#   2. 找豆：与背景 ROI 副本逐格比较，取变化格外框，再在外框内用细条带亮度差收紧到豆的外框。
#      外框碰 ROI 边（豆没完整进画面）、太小（噪声）或太大（手、多颗豆）的帧不用。每路取外框最大的合格帧。
#   3. 裁图：以豆外框中心取正方形，边长 = 长边 / (1 - 2 x CROP_MARGIN)，向上取 16 的倍数，平移到 ROI 内。
#      训练图为“单豆裁图 + 每边 12% 余量，短边缩放到 224 + 中心裁剪”；这里正方形裁图再缩放到 224 是近似，
#      要用同一批豆的 PC/ONNX 与板端结果对照后才能认为一致。
#   4. 分类（v2 延后进行）：触发时只找豆、复制裁图放进队列（QUEUE_MAX 个、堆余量不低于 QUEUE_MIN_FREE_MB），
#      画面连续 DRAIN_IDLE_FRAMES 帧无变化时每帧分类一颗；队列满的豆记“未判定 queue_full”，不丢计数。
#      裁图 RGB565 → to_rgb888 → to_numpy_ref (HWC) → CHW uint8 → Ai2d 缩放到 224 → KPU（输出已含 softmax）。
#      图像转数组的写法取自正点原子 CanMV 例程「实验4 人脸识别」main1.py image2rgb888array；本脚本尚未上板实测。
#   5. 双面合并（每颗豆）：
#      - 任一面 top1 是瑕疵类且概率 >= MIN_CONF → 瑕疵（取概率最高的瑕疵面作为类别）；
#      - 两面都找到豆，且都是 NORMAL_LABELS 中的类、概率 >= MIN_CONF → 正常；
#      - 其余（只看到一面且不是瑕疵、概率低）→ 未判定。未判定不算正常。
#      - 两路都没找到合格的豆 → 不计为豆，记“空触发”（手、反光、豆出 ROI 等）。
#
# 重要限制：
#   - 当前模型（coffee-defect-16）16 类全是瑕疵类，没有“正常豆”类。NORMAL_LABELS 为空时，
#     所有置信度够的豆都会计为瑕疵，正常数恒为 0；屏幕会显示提示。换成含正常类的模型后把类名填进 NORMAL_LABELS。
#   - 屏上计数是“触发且找到豆”的次数，没有逐豆跟踪核对，不是核对过的逐豆计数；两颗豆同时落下会算一颗或被拒。
#   - 两面不等于全部表面；公开数据集训练、未用本机光照校准，屏上比例不代表端侧准确率。
#   - 相机与 KPU 同时运行、此路径下的内存余量未实测；出问题时串口最后一行 "->" 指出位置。
#
# 输出 /sdcard/beanlens/sortNNN/（只新建，不覆盖、不删除）：
#   meta.txt、beans.csv（v2 起每次触发一行，空触发 bean 列为空；两面帧偏移/top1/概率/外框/裁图边长/各帧找豆原因、
#   合并结果、耗时）、
#   证据裁图 beanNNNN_camK_SxS.rgb565（瑕疵、未判定，以及每 SPOT_CHECK_EVERY 颗的抽查；总数受 MAX_EVIDENCE 限制）、
#   done.txt（正常结束才有，含汇总：触发数、各路找豆原因计数、待机帧间隔、队列丢弃、未分类余量）。
#   漏豆诊断：放已知颗数的豆，对照“实际颗数 / 触发数 / 豆数 / 原因计数”，分别慢放（每颗间隔 3 s 以上）和快放各跑一次。
#存储出错立即停止，已写入的行保留，done.txt 缺失即表示未完成。
#   电脑上看裁图：../tools/rgb565_to_png.py <文件> --width S --height S（S 见文件名）。

import gc
import os
import time
import image
from media.sensor import *
from media.display import *
from media.media import *
# 标准模块放在 media 的 * 导入之后：* 导入会覆盖 sys（kmodel_live_classify.py 实测 sys.print_exception 丢失）
import sys
import ujson
import nncase_runtime as nn
import ulab.numpy as np
from libs.AIBase import AIBase
from libs.AI2D import Ai2d

SCRIPT_VERSION = 3

# ---- 模型 ----
MODEL_DIR = "/sdcard/beanlens/model-u8w16"
KMODEL = "best.kmodel"
MODEL_INPUT = 224
MIN_CONF = 0.5                    # top1 概率低于此值该面记“未判定”
NORMAL_LABELS = ()                # 正常豆的类名；当前 16 类模型没有正常类，保持为空
CROP_MARGIN = 0.12                # 与训练裁图每边余量一致

# ---- 采集（与 drop_capture.py v5 相同，改动前先在 drop_capture.py 上验证）----
CAM_IDS = (1, 2)
SENSOR_W, SENSOR_H = 1920, 1080
FPS = 30
CAP_W, CAP_H = 960, 540
ROI_REF_W, ROI_REF_H = 440, 720   # 按 1280x720 坐标填写，自动缩放到 CAP_W；高度取满（豆沿画面竖直方向运动）
ROI_REF_X = {1: 560, 2: 230}      # 与 drop_capture.py 相同；v1 高度为 480、y=120（避开对面相机与横梁），
ROI_REF_Y = {1: 0, 2: 0}          # 取满高度后静态物体会被背景差抵消，但首次运行前要看一次画面确认
_K = CAP_W / 1280
ROI_W, ROI_H = int(ROI_REF_W * _K), int(ROI_REF_H * _K)
ROI_X = {c: int(x * _K) for c, x in ROI_REF_X.items()}
ROI_Y = {c: int(y * _K) for c, y in ROI_REF_Y.items()}

# ---- 触发 ----
CELL = 30
PATCH = 16
DIFF_L = 10
MIN_CELLS = 2
BG_ALPHA = 0.1
BG_LEARN_FRAMES = 15
BG_COPY_EVERY = 30                # 待机时每 N 帧更新一次找豆用的背景 ROI 副本
SHOW_EVERY = 3
PRE_TRIGGER = True                # 待机时保留上一组 ROI 副本（每帧多一次 copy、多占一组内存）
BURST_AFTER = 1                   # 触发组之后再拍的组数；drop001/002 中触发后的帧大多已没有豆
REARM_QUIET = 2                   # 触发后连续这么多帧无变化才重新待命（防同一颗豆重复触发）
REARM_TIMEOUT_MS = 3000           # 触发后这么久仍不安静（手、豆停在画面里）→ 重学背景

# ---- 延后分类队列 ----
QUEUE_MAX = 4
QUEUE_MIN_FREE_MB = 1.0           # 堆余量低于此值时不再入队
DRAIN_IDLE_FRAMES = 5             # 待命且连续无变化这么多帧后才分类（避开成串落豆）

# ---- 找豆 ----
STRIP = 4                         # 收紧外框时条带宽度（px）
STRIP_DIFF = 6                    # 条带 L 均值偏离背景超过此值算有豆
EDGE = 2                          # 外框离 ROI 边不足此值视为豆被截断
MIN_BEAN_PX = 20                  # 外框长边下限（960x540 下豆约 45-78 px）
MAX_BEAN_PX = 150                 # 外框长边上限；更大多半是手或多颗豆

# ---- 运行与证据 ----
MAX_BEANS = 999
DURATION_MS = 7200000             # 2 小时
SAVE_EVIDENCE = True
SPOT_CHECK_EVERY = 10             # 每 N 颗正常豆存一次抽查证据；0 不抽查
MAX_EVIDENCE = 300                # 证据裁图文件总数上限
OUT_ROOT = "/sdcard/beanlens"
MIN_FREE_MB = 10

DISPLAY_W, DISPLAY_H = 640, 480

R_FLAWED, R_NORMAL, R_UNDECIDED = "flawed", "normal", "undecided"


def step(name):
    print("-> " + name)


def exists(path):
    try:
        os.stat(path)
        return True
    except OSError:
        return False


def sdcard_free_mb():
    try:
        st = os.statvfs("/sdcard")   # 本固件返回 bsize=512, frsize=0
        return st[0] * st[3] / 1048576
    except Exception:
        return -1


def sync_fs():
    f = getattr(os, "sync", None)
    if f is not None:
        try:
            f()
        except Exception:
            pass


def read_lines(path):
    with open(path, "r") as f:
        return [s.strip() for s in f.read().split("\n") if s.strip()]


def read_manifest():
    try:
        with open(MODEL_DIR + "/manifest.json", "r") as f:
            return ujson.load(f)
    except Exception as e:
        print("manifest.json read failed:", e)
        return {}


def roi(cam):
    return (ROI_X[cam], ROI_Y[cam], ROI_W, ROI_H)


def check_config(labels):
    for c in CAM_IDS:
        if ROI_X[c] < 0 or ROI_Y[c] < 0 or ROI_X[c] + ROI_W > CAP_W or ROI_Y[c] + ROI_H > CAP_H:
            raise ValueError("cam%d ROI (%d,%d,%d,%d) outside %dx%d" % ((c,) + roi(c) + (CAP_W, CAP_H)))
    for n in NORMAL_LABELS:
        if n not in labels:
            raise ValueError("NORMAL_LABELS has %s, not in labels.txt" % n)


# ---- 触发用网格（整帧坐标，只统计格子中心 PATCH）----
def trigger_cells(cam):
    x0, y0 = ROI_X[cam], ROI_Y[cam]
    off = (CELL - PATCH) // 2
    return [(x0 + gx * CELL + off, y0 + gy * CELL + off, PATCH, PATCH)
            for gy in range(ROI_H // CELL) for gx in range(ROI_W // CELL)]


def cell_means(img, cells):
    return [img.get_statistics(roi=r).l_mean() for r in cells]


def changed_cells(means, bg):
    return sum(1 for m, b in zip(means, bg) if abs(m - b) > DIFF_L)


def update_bg(bg, means):
    for k in range(len(bg)):
        bg[k] += BG_ALPHA * (means[k] - bg[k])


# ---- 找豆（ROI 局部坐标，在 ROI 副本上做）----
LOCAL_CELLS = [(gx * CELL, gy * CELL, CELL, CELL)
               for gy in range(ROI_H // CELL) for gx in range(ROI_W // CELL)]


class Background:
    # 找豆用的背景：ROI 副本 + 各格 L 均值（避免每次重算）
    def __init__(self):
        self.img = None
        self.means = None

    def set(self, roi_img):
        self.img = roi_img
        self.means = cell_means(roi_img, LOCAL_CELLS)


def strip_extent(img, bg_img, box, vertical):
    # vertical=True：竖条带扫 x 方向；返回超过 STRIP_DIFF 的首末位置（局部坐标），没有则 None
    x, y, w, h = box
    lo = hi = None
    n = (w if vertical else h) // STRIP
    for k in range(n):
        r = (x + k * STRIP, y, STRIP, h) if vertical else (x, y + k * STRIP, w, STRIP)
        d = abs(img.get_statistics(roi=r).l_mean() - bg_img.get_statistics(roi=r).l_mean())
        if d > STRIP_DIFF:
            p = (x if vertical else y) + k * STRIP
            if lo is None:
                lo = p
            hi = p + STRIP
    return None if lo is None else (lo, hi)


def locate_bean(img, bg):
    # 返回 (x, y, w, h, reason)；不合格时前四项为 None
    means = cell_means(img, LOCAL_CELLS)
    hit = [LOCAL_CELLS[k] for k in range(len(means)) if abs(means[k] - bg.means[k]) > DIFF_L]
    if not hit:
        return None, None, None, None, "no_change"
    cx0 = min(c[0] for c in hit)
    cy0 = min(c[1] for c in hit)
    cx1 = max(c[0] + CELL for c in hit)
    cy1 = max(c[1] + CELL for c in hit)
    if max(cx1 - cx0, cy1 - cy0) > MAX_BEAN_PX + 2 * CELL:
        return None, None, None, None, "too_big"
    # 外扩一格再收紧：豆可能只盖住格子的一部分
    bx0, by0 = max(0, cx0 - CELL), max(0, cy0 - CELL)
    bx1, by1 = min(ROI_W, cx1 + CELL), min(ROI_H, cy1 + CELL)
    box = (bx0, by0, bx1 - bx0, by1 - by0)
    xs = strip_extent(img, bg.img, box, True)
    ys = strip_extent(img, bg.img, box, False)
    if xs is None or ys is None:
        return None, None, None, None, "no_strip"
    x, y, w, h = xs[0], ys[0], xs[1] - xs[0], ys[1] - ys[0]
    long_side = max(w, h)
    if long_side < MIN_BEAN_PX:
        return None, None, None, None, "too_small"
    if long_side > MAX_BEAN_PX:
        return None, None, None, None, "too_big"
    if x <= EDGE or y <= EDGE or x + w >= ROI_W - EDGE or y + h >= ROI_H - EDGE:
        return None, None, None, None, "clipped"
    return x, y, w, h, "ok"


def square_crop(x, y, w, h):
    # 以外框中心取正方形（局部坐标），边长为 16 的倍数并放进 ROI 内
    side = int(max(w, h) / (1 - 2 * CROP_MARGIN))
    side = (side + 15) // 16 * 16
    side = min(side, ROI_W // 16 * 16, ROI_H // 16 * 16)
    cx, cy = x + w // 2, y + h // 2
    sx = min(max(0, cx - side // 2), ROI_W - side)
    sy = min(max(0, cy - side // 2), ROI_H - side)
    return (sx, sy, side, side)


# ---- 分类 ----
class BeanClassifier(AIBase):
    def __init__(self, kmodel_path):
        super().__init__(kmodel_path, [MODEL_INPUT, MODEL_INPUT], [MODEL_INPUT, MODEL_INPUT], 0)
        self.model_input_size = [MODEL_INPUT, MODEL_INPUT]
        self.ai2d = Ai2d(0)
        self.ai2d.set_ai2d_dtype(nn.ai2d_format.NCHW_FMT, nn.ai2d_format.NCHW_FMT, np.uint8, np.uint8)
        self.side = None

    def config_preprocess(self, input_image_size=None):
        # 输入为正方形裁图，直接缩放到 224（正方形下等价于短边缩放 + 中心裁剪）
        side = input_image_size[0]
        self.ai2d.resize(nn.interp_method.tf_bilinear, nn.interp_mode.half_pixel)
        self.ai2d.build([1, 3, side, side], [1, 3, MODEL_INPUT, MODEL_INPUT])
        self.side = side

    def postprocess(self, results):
        return [float(v) for v in results[0][0]]   # YOLO-CLS 导出的输出已含 softmax

    def classify(self, crop_img):
        side = crop_img.width()
        if side != self.side:
            self.config_preprocess([side, side])
        rgb = crop_img.to_rgb888()
        hwc = rgb.to_numpy_ref()
        chw = hwc.reshape((side * side, 3)).transpose().copy().reshape((1, 3, side, side))
        probs = self.run(chw)
        del chw, hwc, rgb
        return probs


def top1(probs):
    best, idx = probs[0], 0
    for i in range(1, len(probs)):
        if probs[i] > best:
            best, idx = probs[i], i
    return idx, best


def side_status(label, p):
    if p < MIN_CONF:
        return R_UNDECIDED
    return R_NORMAL if label in NORMAL_LABELS else R_FLAWED


def merge_sides(sides):
    # sides：每路 None（没找到合格的豆）或 (label, p)。返回 (结果, 类别)；两路都 None 返回 (None, None)
    seen = [s for s in sides if s is not None]
    if not seen:
        return None, None
    flawed = [s for s in seen if side_status(s[0], s[1]) == R_FLAWED]
    if flawed:
        best = max(flawed, key=lambda s: s[1])
        return R_FLAWED, best[0]
    if len(seen) == len(sides) and all(side_status(s[0], s[1]) == R_NORMAL for s in seen):
        return R_NORMAL, seen[0][0]
    return R_UNDECIDED, ""


# ---- 屏幕 ----
class Stats:
    def __init__(self):
        self.beans = 0
        self.flawed = 0
        self.normal = 0
        self.undecided = 0
        self.empty = 0            # 触发但两路都没找到合格的豆
        self.by_label = {}
        self.triggers = 0
        self.queue_dropped = 0    # 队列满、记为未判定的豆
        self.rearm_timeouts = 0
        self.reasons = {}         # "camK:原因" -> 帧数（每次触发每路每帧一个）
        self.found = [0] * len(CAM_IDS)   # 每路找到合格豆的触发数
        self.locate_ms = []       # 以下只保留最近 100 个
        self.cls_ms = []
        self.idle_ms = []         # 待命无变化时的帧间隔（含刷屏）

    def keep(self, name, v):
        setattr(self, name, (getattr(self, name) + [v])[-100:])

    def add_reasons(self, reasons):
        for i, rs in enumerate(reasons):
            for r in rs:
                k = "cam%d:%s" % (CAM_IDS[i], r[1])
                self.reasons[k] = self.reasons.get(k, 0) + 1

    def top_rejects(self, n):
        items = [kv for kv in self.reasons.items() if not kv[0].endswith(":ok")]
        return sorted(items, key=lambda kv: -kv[1])[:n]

    def add(self, result, label):
        if result is None:
            self.empty += 1
            return
        self.beans += 1
        if result == R_FLAWED:
            self.flawed += 1
            self.by_label[label] = self.by_label.get(label, 0) + 1
        elif result == R_NORMAL:
            self.normal += 1
        else:
            self.undecided += 1


thumbs_ok = True


def median(v):
    s = sorted(v)
    return s[len(s) // 2] if s else ""


def draw_screen(canvas, st, status, status_color, last, n_pending):
    # last：None 或 (结果, 类别, [每路裁图或 None], [每路文字])
    global thumbs_ok
    canvas.clear()
    canvas.draw_rectangle(0, 0, DISPLAY_W, 28, color=(0, 0, 0), fill=True)
    canvas.draw_string_advanced(4, 4, 20, status, color=status_color)

    canvas.draw_string_advanced(16, 40, 28, "总豆数", color=(200, 200, 200))
    canvas.draw_string_advanced(16, 72, 72, "%d" % st.beans, color=(255, 255, 255))
    canvas.draw_string_advanced(330, 40, 28, "瑕疵豆", color=(255, 120, 120))
    canvas.draw_string_advanced(330, 72, 72, "%d" % st.flawed, color=(255, 60, 60))
    pct = " (%.0f%%)" % (100.0 * st.flawed / st.beans) if st.beans else ""
    canvas.draw_string_advanced(470, 110, 24, pct, color=(255, 120, 120))

    y = 168
    canvas.draw_string_advanced(16, y - 22, 18, "触发 %d   待分类 %d   队列满 %d   帧间隔 %s ms"
                                % (st.triggers, n_pending, st.queue_dropped, median(st.idle_ms)),
                                color=(160, 200, 255))
    canvas.draw_string_advanced(16, y, 22, "正常 %d   未判定 %d   空触发 %d" % (st.normal, st.undecided, st.empty),
                                color=(200, 200, 200))
    top = sorted(st.by_label.items(), key=lambda kv: -kv[1])[:3]
    if top:
        canvas.draw_string_advanced(16, y + 24, 20, "  ".join("%s %d" % kv for kv in top), color=(255, 180, 120))
    rej = st.top_rejects(3)
    if rej:
        canvas.draw_string_advanced(16, y + 46, 18, "拒判帧 " + "  ".join("%s %d" % kv for kv in rej),
                                    color=(200, 160, 255))
    if not NORMAL_LABELS:
        canvas.draw_string_advanced(16, y + 66, 18, "模型无正常类：正常数恒为 0，置信度够即计瑕疵",
                                    color=(255, 255, 0))

    if last is not None:
        result, label, crops, texts = last
        ly = 256
        head = {R_FLAWED: ("上一颗：瑕疵 " + label, (255, 60, 60)),
                R_NORMAL: ("上一颗：正常", (0, 255, 0)),
                R_UNDECIDED: ("上一颗：未判定", (255, 255, 0))}.get(result, ("上一颗：空触发", (160, 160, 160)))
        canvas.draw_string_advanced(16, ly, 22, head[0], color=head[1])
        for i, c in enumerate(CAM_IDS):
            x0 = 16 + i * 310
            if thumbs_ok and crops[i] is not None:
                try:
                    k = 150 / crops[i].width()
                    canvas.draw_image(crops[i], x0, ly + 30, x_scale=k, y_scale=k)
                except Exception as e:
                    thumbs_ok = False
                    print("thumbnail drawing not supported, text only:", e)
            canvas.draw_string_advanced(x0 + 160, ly + 34, 18, "CAM%d" % c, color=(255, 255, 0))
            canvas.draw_string_advanced(x0 + 160, ly + 58, 18, texts[i], color=(220, 220, 220))

    canvas.draw_string_advanced(16, DISPLAY_H - 24, 16, "按触发计数，未逐豆核对；未判定不算正常；比例不代表准确率",
                                color=(140, 140, 140))
    Display.show_image(canvas)


# ---- 输出 ----
def make_run_dir(manifest, labels):
    if not exists(OUT_ROOT):
        os.mkdir(OUT_ROOT)
    n = 0
    while exists("%s/sort%03d" % (OUT_ROOT, n)):
        n += 1
    path = "%s/sort%03d" % (OUT_ROOT, n)
    os.mkdir(path)
    with open(path + "/meta.txt", "w") as f:
        f.write("script=main.py (bean sort pipeline)\nscript_version=%d\nstatus=started\n"
                "model_dir=%s\nkmodel=%s\nkmodel_sha256_manifest=%s\nnncase_manifest=%s\nclasses=%d\n"
                "normal_labels=%s\nmin_conf=%.2f\ncrop_margin=%.2f\n"
                "sensor=%dx%d@%d\nchn=0\ncap=%dx%d\ncams=%s\nroi=%s\n"
                "cell=%d\npatch=%d\ndiff_l=%d\nmin_cells=%d\npre_trigger=%d\nburst_after=%d\n"
                "rearm_quiet=%d\nrearm_timeout_ms=%d\nqueue_max=%d\nqueue_min_free_mb=%.1f\ndrain_idle_frames=%d\n"
                "strip=%d\nstrip_diff=%d\nmin_bean_px=%d\nmax_bean_px=%d\nuname=%s\n"
                % (SCRIPT_VERSION, MODEL_DIR, KMODEL, manifest.get("kmodel_sha256"), manifest.get("nncase"),
                   len(labels), ",".join(NORMAL_LABELS), MIN_CONF, CROP_MARGIN,
                   SENSOR_W, SENSOR_H, FPS, CAP_W, CAP_H, ",".join(str(c) for c in CAM_IDS),
                   ";".join("cam%d:%d,%d,%d,%d" % ((c,) + roi(c)) for c in CAM_IDS),
                   CELL, PATCH, DIFF_L, MIN_CELLS, PRE_TRIGGER, BURST_AFTER, REARM_QUIET, REARM_TIMEOUT_MS,
                   QUEUE_MAX, QUEUE_MIN_FREE_MB, DRAIN_IDLE_FRAMES,
                   STRIP, STRIP_DIFF, MIN_BEAN_PX, MAX_BEAN_PX, os.uname()))
    sync_fs()
    return path


def open_sensor(cam_id):
    step("open camera id=%d" % cam_id)
    s = Sensor(id=cam_id, width=SENSOR_W, height=SENSOR_H, fps=FPS)
    s.reset()
    s.set_framesize(width=CAP_W, height=CAP_H, chn=CAM_CHN_ID_0)
    s.set_pixformat(Sensor.RGB565, chn=CAM_CHN_ID_0)
    return s


def locate_event(burst, bgs):
    # burst：[(帧偏移, [每路 ROI 副本]), ...]，偏移 -1 = 触发前一组，0 = 触发组。
    # 返回 (每路 None 或 (偏移, 外框, 正方形框, 裁图), 每路 [(偏移, 原因), ...])；裁图已复制，burst 可立即释放
    found, reasons = [], []
    for i in range(len(CAM_IDS)):
        best, rs = None, []
        for off, pair in burst:
            x, y, w, h, why = locate_bean(pair[i], bgs[i])
            rs.append((off, why))
            if why == "ok" and (best is None or w * h > best[3] * best[4]):
                best = (off, x, y, w, h, pair[i])
        reasons.append(rs)
        if best is None:
            found.append(None)
            continue
        off, x, y, w, h, src = best
        sq = square_crop(x, y, w, h)
        found.append((off, (x, y, w, h), sq, src.copy(roi=sq)))
    return found, reasons


def reasons_text(rs):
    return "/".join("%d:%s" % r for r in rs)


def side_cols(f, rs, label="", p=None, status=""):
    # 一路的 csv 字段：偏移,类别,概率,外框,裁图边长,状态,各帧原因
    if f is None:
        return ",,,,,,%s" % reasons_text(rs)
    off, box, sq, _ = f
    return "%d,%s,%s,%d %d %d %d,%d,%s,%s" % (off, label, "" if p is None else "%.3f" % p,
                                              box[0], box[1], box[2], box[3], sq[2], status, reasons_text(rs))


def classify_item(clf, labels, item):
    # 返回 (结果, 类别, 每路裁图, 每路文字, 每路 csv 字段)
    crops, texts, sides, cols = [], [], [], []
    for f, rs in zip(item["found"], item["reasons"]):
        if f is None:
            crops.append(None)
            sides.append(None)
            texts.append("拒判 " + "/".join(r[1] for r in rs))
            cols.append(side_cols(None, rs))
            continue
        crop = f[3]
        idx, p = top1(clf.classify(crop))
        crops.append(crop)
        sides.append((labels[idx], p))
        texts.append("%s %.2f" % (labels[idx], p) if p >= MIN_CONF else "未判定 %s %.2f" % (labels[idx], p))
        cols.append(side_cols(f, rs, labels[idx], p, side_status(labels[idx], p)))
    result, label = merge_sides(sides)
    return result, label, crops, texts, cols


def save_evidence(run_dir, bean_no, crops):
    for i, c in enumerate(crops):
        if c is None:
            continue
        with open("%s/bean%04d_cam%d_%dx%d.rgb565" % (run_dir, bean_no, CAM_IDS[i], c.width(), c.height()),
                  "wb") as f:
            f.write(c.bytearray())


def write_row(f, item, result, label, cols, queue_ms, classify_ms, ev):
    f.write("%d,%s,%d,%s,%s,%s,%d,%d,%s,%s,%s\n"
            % (item["event"], "" if item["bean"] is None else item["bean"], item["t"], result, label,
               ",".join(cols), item["burst_ms"], item["locate_ms"], queue_ms, classify_ms, ev))
    f.flush()


def main():
    labels = read_lines(MODEL_DIR + "/labels.txt")
    manifest = read_manifest()
    if manifest.get("num_classes") not in (None, len(labels)):
        raise ValueError("labels.txt %d classes, manifest %s" % (len(labels), manifest["num_classes"]))
    check_config(labels)
    print("kmodel:", KMODEL, "sha256(manifest):", manifest.get("kmodel_sha256"), "classes:", len(labels),
          "normal labels:", NORMAL_LABELS or "(none: every confident bean counts as flawed)")
    pair_kb = len(CAM_IDS) * ROI_W * ROI_H * 2 / 1024
    print("ROI %dx%d, %.0f KB per pair, up to %d pairs per trigger"
          % (ROI_W, ROI_H, pair_kb, int(PRE_TRIGGER) + 1 + BURST_AFTER))

    sensors = []
    clf = None
    beans_f = None
    run_dir = None
    st = Stats()
    stop_reason = "unknown"
    evidence = 0
    pending = []
    next_bean = 0
    t0 = time.ticks_ms()
    try:
        free_mb = sdcard_free_mb()
        print("/sdcard free %.1f MB" % free_mb)
        if 0 <= free_mb < MIN_FREE_MB:
            raise OSError("not enough space on /sdcard: %.1f MB < %d MB" % (free_mb, MIN_FREE_MB))

        step("load kmodel")
        clf = BeanClassifier(MODEL_DIR + "/" + KMODEL)
        gc.collect()
        print("heap free after kmodel: %.1f MB" % (gc.mem_free() / 1048576))

        for cid in CAM_IDS:
            sensors.append(open_sensor(cid))
        step("Display.init")
        Display.init(Display.ST7701, width=DISPLAY_W, height=DISPLAY_H, to_ide=True)
        step("MediaManager.init")
        MediaManager.init()
        step("sensor run")
        sensors[0].run()
        canvas = image.Image(DISPLAY_W, DISPLAY_H, image.RGB565)

        step("create run dir")
        run_dir = make_run_dir(manifest, labels)
        print("output dir:", run_dir)
        beans_f = open(run_dir + "/beans.csv", "w")
        beans_f.write("event,bean,t_ms,result,label,"
                      + ",".join("cam%d_offset,cam%d_label,cam%d_p,cam%d_box,cam%d_side,cam%d_status,cam%d_reasons"
                                 % ((c,) * 7) for c in CAM_IDS)
                      + ",burst_ms,locate_ms,queue_ms,classify_ms,evidence\n")
        beans_f.flush()
        sync_fs()

        step("first snapshot + classify warm-up")
        cells = [trigger_cells(c) for c in CAM_IDS]
        trig_bgs = [None] * len(CAM_IDS)
        bgs = [Background() for _ in CAM_IDS]
        for i, s in enumerate(sensors):
            img = s.snapshot(chn=CAM_CHN_ID_0)
            r = img.copy(roi=roi(CAM_IDS[i]))
            img = None
            bgs[i].set(r)
        sq = square_crop(ROI_W // 2 - 30, ROI_H // 2 - 30, 60, 60)
        ti = time.ticks_ms()
        clf.classify(bgs[0].img.copy(roi=sq))          # 首次推理：确认相机 + KPU 能同时运行，结果丢弃
        print("warm-up classify ok, %d ms" % time.ticks_diff(time.ticks_ms(), ti))
        gc.collect()
        print("heap free before loop: %.1f MB" % (gc.mem_free() / 1048576))

        def classify_next():
            # 分类队列最前一颗，写行、存证据；返回屏幕用的 last
            nonlocal evidence
            item = pending.pop(0)
            tc = time.ticks_ms()
            queue_ms = time.ticks_diff(tc, item["t_abs"])
            result, label, crops, texts, cols = classify_item(clf, labels, item)
            cls_ms = time.ticks_diff(time.ticks_ms(), tc)
            st.add(result, label)
            st.keep("cls_ms", cls_ms)
            ev = ""
            spot = (result == R_NORMAL and SPOT_CHECK_EVERY and (st.normal - 1) % SPOT_CHECK_EVERY == 0)
            if SAVE_EVIDENCE and evidence < MAX_EVIDENCE and (result != R_NORMAL or spot):
                save_evidence(run_dir, item["bean"], crops)
                evidence += sum(1 for c in crops if c is not None)
                ev = "spot" if spot else "yes"
            write_row(beans_f, item, result, label, cols, queue_ms, cls_ms, ev)
            print("bean %d: %s %s | %s | queued %d ms, classify %d ms, heap %.1f MB"
                  % (item["bean"], result, label or "", " | ".join(texts), queue_ms, cls_ms,
                     gc.mem_free() / 1048576))
            return (result, label or "", crops, texts)

        learn = BG_LEARN_FRAMES
        armed = False
        pre_trigger = PRE_TRIGGER
        quiet = 0
        busy_since = 0
        idle = 0
        prev = None
        last = None
        n_frames = 0
        last_top, last_idle = None, False
        step("learning background, keep the view empty")
        while next_bean < MAX_BEANS:
            os.exitpoint()
            now = time.ticks_ms()
            if time.ticks_diff(now, t0) >= DURATION_MS:
                stop_reason = "duration"
                break
            if last_idle:
                st.keep("idle_ms", time.ticks_diff(now, last_top))
            last_top, last_idle = now, False
            imgs, counts = [], []
            for i, s in enumerate(sensors):
                img = s.snapshot(chn=CAM_CHN_ID_0)
                m = cell_means(img, cells[i])
                if trig_bgs[i] is None:
                    trig_bgs[i] = list(m)
                counts.append(changed_cells(m, trig_bgs[i]))
                if learn > 0 or counts[i] < MIN_CELLS:
                    update_bg(trig_bgs[i], m)
                imgs.append(img)
            n_frames += 1
            active = max(counts) >= MIN_CELLS

            if learn > 0:
                if not active:
                    learn -= 1
                if learn == 0:
                    for i, im in enumerate(imgs):
                        bgs[i].set(im.copy(roi=roi(CAM_IDS[i])))
                    armed, idle, prev = True, 0, None
                    print("ready: drop beans")
                imgs = None
                if n_frames % SHOW_EVERY == 0:
                    draw_screen(canvas, st, "学习背景中，画面保持空…", (255, 255, 0), last, len(pending))
                continue

            if not armed:
                # 上一次触发后等画面安静，避免同一颗豆再次触发
                imgs = None
                if active:
                    quiet = 0
                    if time.ticks_diff(now, busy_since) > REARM_TIMEOUT_MS:
                        st.rearm_timeouts += 1
                        learn = BG_LEARN_FRAMES
                        print("view not quiet for %d ms, relearning background" % REARM_TIMEOUT_MS)
                else:
                    quiet += 1
                    if quiet >= REARM_QUIET:
                        armed, idle = True, 0
                if n_frames % SHOW_EVERY == 0:
                    draw_screen(canvas, st, "等待画面安静…", (255, 255, 0), last, len(pending))
                continue

            if not active:
                idle += 1
                last_idle = True
                if idle % BG_COPY_EVERY == 0:
                    for i, im in enumerate(imgs):
                        bgs[i].set(im.copy(roi=roi(CAM_IDS[i])))
                if pre_trigger:
                    prev = None
                    try:
                        prev = [im.copy(roi=roi(CAM_IDS[i])) for i, im in enumerate(imgs)]
                    except MemoryError:
                        pre_trigger, prev = False, None
                        print("MemoryError keeping the pre-trigger pair, PRE_TRIGGER disabled for this run")
                imgs = None
                if pending and idle >= DRAIN_IDLE_FRAMES:
                    last_idle = False            # 本帧含分类，不计入待命帧间隔
                    last = classify_next()
                    gc.collect()
                    draw_screen(canvas, st, "就绪：可以落豆", (0, 255, 0), last, len(pending))
                elif n_frames % SHOW_EVERY == 0:
                    draw_screen(canvas, st, "就绪：可以落豆", (0, 255, 0), last, len(pending))
                continue

            # ---- 触发：先把 ROI 复制出来，立即释放相机缓冲 ----
            st.triggers += 1
            t_trig = time.ticks_diff(now, t0)
            tb = time.ticks_ms()
            burst = []
            if prev is not None:
                burst.append((-1, prev))
                prev = None
            try:
                burst.append((0, [im.copy(roi=roi(CAM_IDS[i])) for i, im in enumerate(imgs)]))
                imgs = None
                for k in range(BURST_AFTER):
                    burst.append((k + 1, [s.snapshot(chn=CAM_CHN_ID_0).copy(roi=roi(CAM_IDS[i]))
                                          for i, s in enumerate(sensors)]))
            except MemoryError:
                imgs = None
                print("  MemoryError after %d pairs, using what was captured" % len(burst))
            burst_ms = time.ticks_diff(time.ticks_ms(), tb)
            armed, quiet, busy_since = False, 0, time.ticks_ms()

            tl = time.ticks_ms()
            found, reasons = locate_event(burst, bgs)
            burst = None
            locate_ms = time.ticks_diff(time.ticks_ms(), tl)
            st.keep("locate_ms", locate_ms)
            st.add_reasons(reasons)
            for i, f in enumerate(found):
                if f is not None:
                    st.found[i] += 1
            item = {"event": st.triggers - 1, "bean": None, "t": t_trig, "t_abs": tb, "burst_ms": burst_ms,
                    "locate_ms": locate_ms, "found": found, "reasons": reasons}

            if all(f is None for f in found):
                st.add(None, None)
                write_row(beans_f, item, "empty", "", [side_cols(None, rs) for rs in reasons], "", "", "")
                print("event %d: empty | %s | burst %d ms, locate %d ms"
                      % (item["event"], " | ".join(reasons_text(rs) for rs in reasons), burst_ms, locate_ms))
                last = (None, "", [None] * len(CAM_IDS), ["拒判 " + "/".join(r[1] for r in rs) for rs in reasons])
            else:
                item["bean"] = next_bean
                next_bean += 1
                free = gc.mem_free()
                if len(pending) < QUEUE_MAX and free < QUEUE_MIN_FREE_MB * 1048576:
                    gc.collect()                 # 待命时每帧复制上一组，余量里含未回收的垃圾
                    free = gc.mem_free()
                if len(pending) >= QUEUE_MAX or free < QUEUE_MIN_FREE_MB * 1048576:
                    # 队列满：不丢计数，记未判定
                    st.queue_dropped += 1
                    st.add(R_UNDECIDED, "")
                    write_row(beans_f, item, R_UNDECIDED, "",
                              [side_cols(f, rs, status="queue_full") for f, rs in zip(found, reasons)],
                              "", "", "")
                    print("bean %d: queue full (%d pending, heap %.1f MB), counted as undecided"
                          % (item["bean"], len(pending), gc.mem_free() / 1048576))
                else:
                    pending.append(item)
                    print("bean %d queued (event %d, %d pending) | %s | burst %d ms, locate %d ms"
                          % (item["bean"], item["event"], len(pending),
                             " | ".join(reasons_text(rs) for rs in reasons), burst_ms, locate_ms))
            item = found = None
            draw_screen(canvas, st, "已触发，等待画面安静…", (255, 255, 0), last, len(pending))
        else:
            stop_reason = "max_beans"

        # 正常结束：把队列里的豆分类完
        while pending:
            os.exitpoint()
            last = classify_next()
            gc.collect()

    except KeyboardInterrupt:
        stop_reason = "user_stop"
        print("user stop")
    except BaseException as e:
        stop_reason = "error: %s" % e
        print("Exception:", e)
        try:
            sys.print_exception(e)
        except Exception:
            pass
        print("/sdcard free: %.1f MB" % sdcard_free_mb())
    finally:
        elapsed = time.ticks_diff(time.ticks_ms(), t0)
        summary = ("status=%s\nstop_reason=%s\nelapsed_ms=%d\ntriggers=%d\nbeans=%d\nflawed=%d\nnormal=%d\n"
                   "undecided=%d\nempty_triggers=%d\nqueue_dropped=%d\npending_unclassified=%d\n"
                   "rearm_timeouts=%d\nfound_per_cam=%s\nframe_reasons=%s\nidle_frame_ms_median=%s\n"
                   "locate_ms_median=%s\nlocate_ms_max=%s\nclassify_ms_median=%s\nclassify_ms_max=%s\n"
                   "evidence_files=%d\nby_label=%s\n"
                   % ("done" if not stop_reason.startswith("error") else "incomplete", stop_reason, elapsed,
                      st.triggers, next_bean, st.flawed, st.normal, st.undecided, st.empty, st.queue_dropped,
                      len(pending), st.rearm_timeouts,
                      ";".join("cam%d:%d" % (c, st.found[i]) for i, c in enumerate(CAM_IDS)),
                      ";".join("%s:%d" % kv for kv in sorted(st.reasons.items())),
                      median(st.idle_ms), median(st.locate_ms), max(st.locate_ms) if st.locate_ms else "",
                      median(st.cls_ms), max(st.cls_ms) if st.cls_ms else "", evidence,
                      ";".join("%s:%d" % kv for kv in sorted(st.by_label.items()))))
        print("---- summary ----")
        print(summary)
        if beans_f is not None:
            try:
                beans_f.close()
            except Exception:
                pass
        # 出错时不写 done.txt：缺少 done.txt 即表示本次未完成
        if run_dir is not None and not stop_reason.startswith("error"):
            try:
                with open(run_dir + "/done.txt", "w") as f:
                    f.write(summary)
                sync_fs()
            except Exception as e:
                print("done.txt write failed:", e)
        for s in sensors:
            try:
                s.stop()
            except Exception:
                pass
        if clf is not None:
            try:
                clf.deinit()
            except Exception:
                pass
        Display.deinit()
        os.exitpoint(os.EXITPOINT_ENABLE_SLEEP)
        time.sleep_ms(100)
        MediaManager.deinit()


AUTORUN_DELAY_S = 3


def autorun_delay():
    print("bean sort pipeline v%d starts in %d s (stop from IDE / Ctrl-C to skip)" % (SCRIPT_VERSION, AUTORUN_DELAY_S))
    for _ in range(AUTORUN_DELAY_S * 10):
        os.exitpoint()
        time.sleep_ms(100)


try:
    autorun_delay()
    main()
except KeyboardInterrupt:
    print("skipped")
finally:
    gc.collect()
    nn.shrink_memory_pool()
