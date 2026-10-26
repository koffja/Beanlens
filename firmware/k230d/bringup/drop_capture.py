# BeanLens 落豆抓拍测试（bring-up 用，无执行器）
# 目标：正点原子 K230D BOX + CanMV v1.6-0-ge4441cc / nncase 2.9.0（待上板验收）
# 目的：相机已固定后，手动从上方丢豆，检查两路相机能否拍到“干净”的豆子图像：
#      豆在画面内、够大、不糊（运动模糊/失焦）、两路几乎同时、无坏帧。
#
# 两种模式（MODE）：
#   - "focus"（默认）：对焦用。两路各显示 ROI 中心 FOCUS_BOX 方框的放大画面和清晰度数值（当前/最高/条形图），
#     串口每秒打印一次；把粘在细杆上的豆举到落豆位置、方框中间，逐个转 M12 镜头到数值最大后锁紧。不写存储。
#     清晰度 = 方框内 10x10 小块亮度标准差的平均，只在同一场景下作相对比较。
#   - "drop"：落豆抓拍，见下。
#
# 落豆抓拍做法（script_version=4 起）：
#   - 两路以 CAP_W x CAP_H 连续取帧（比 v3 的 320x180 高），每路只在豆道竖带 ROI 内做网格亮度差运动检测；
#     ROI 外的手、灯光变化不触发。
#   - 触发后把触发组和随后 BURST_FRAMES-1 组的 ROI 裁图 copy 到内存（连拍中不写盘），结束后按原始 RGB565 写盘，
#     然后重新学习背景，等下一颗豆。
#   - 开始时每路存一张整帧 ref_camN.rgb565（CAP_W x CAP_H），用来核对 ROI 是否罩住豆道。
#   - LCD/IDE 左右分屏显示两路整帧缩略图，黄框/绿框是 ROI，顶栏显示状态。先看框有没有罩住豆道再丢豆。
#   - 画面下方大字显示已拍豆数和每路触发次数。注意这是“触发次数”：一次触发记一颗，
#     手、反光等误触发也会计入，不是核对过的逐豆计数（drop_capture_3 中约一半触发不是豆）。
#
# ROI 设置：ROI_W x ROI_H 两路相同（存盘和 rgb565_to_png.py 都按一个尺寸）；位置 ROI_X[cam]、ROI_Y[cam] 各自设，
#   单位是 CAP_W x CAP_H 下的像素。豆竖直下落，所以 ROI 是竖带；ROI 宽要比豆宽多留左右偏移的余量。
#
# 采集路径沿用 dual_camera_preview.py（2026-10-24 用户确认可用；v3 用同路径 20/20 事件无卡死）：
#   两路 1920x1080@30、chn0 RGB565、不 bind、画布 + Display.show_image、to_ide=True、只对第一个 sensor run()。
#   v1/v2 的 “1280x960@90 + chn0 bind + chn1” 在 2026-10-24 首帧 snapshot(chn1) failed(3)，不用；
#   1920x1080 双摄 chn1 曾卡死（jpeg_probe_3），所以只用 chn0。存原始 RGB565：此路径上 compressed() 曾卡死。
#
# 未验证（v4 新用到，出问题时最后一行 "->" 指出位置）：
#   - chn0 大于 320x180：1280x720 双摄 run() 失败（vicap init failed(-1)，drop_capture_4）；
#     640x360 曾在出厂 demo 自启未关时卡死（capture_test_4），之后没再试。
#     失败就断电，按 960x540 → 640x360 逐级降 CAP_W/CAP_H（ROI 自动缩放）。
#   - img.copy(roi=...) 与 draw_image(..., x_scale, y_scale)。缩略图画不出来时自动只显示文字，不影响采集。
#
# 内存：v3 实测 GC 堆空闲约 3.8 MB，裁图 copy 占这块内存。每组两张裁图 = 2 x ROI_W x ROI_H x 2 B，
#   BURST_FRAMES 由 MEM_BUDGET 自动封顶；MemoryError 时只存已拍到的组。
#
# 输出 /sdcard/beanlens/dropNNN/（只新建，不覆盖、不删除）：
#   meta.txt（width/height 为 ROI 尺寸）、camN.rgb565stream + index.csv、ref_camN.rgb565、events.csv、done.txt（正常结束才有）。
#   电脑上：../tools/drop_review.py <目录> 生成总览图与豆子尺寸/拖影粗估；
#   ../tools/rgb565_to_png.py <目录> 拆单张；整帧参考图：rgb565_to_png.py <目录>/ref_cam1.rgb565 --width CAP_W --height CAP_H。
#   取回：逐个文件 mpremote cp（cp -r 整个目录会卡住，见 drop_capture_3）。
#
# 判读提示：落豆约 1.4 m/s（10 cm 落差）；v3 中 320x180 画面里豆每帧移动约半个画面高，所以每颗豆通常只有 1-2 帧在 ROI 内。
#   v1.6 用 auto_exposure(False) -> run() -> exposure(us) 固定短曝光；失败停止，不回退自动曝光。
#   EXPOSURE_US 是实验起点，不是已标定快门；画面太暗先改善补光。相同曝光不代表双摄同步。

import gc
import os
import time
import image
from media.sensor import *
from media.display import *
from media.media import *
# sys 放在 media 的 * 导入之后：* 导入会覆盖 sys（kmodel_live_classify.py 实测 sys.print_exception 丢失）
import sys

MODE = "drop"                    # "focus"：对焦模式，只显示放大的框内画面和清晰度，不写存储；
                                  # "drop"：落豆抓拍。先 focus 调好两个镜头，再改成 "drop"
CAM_IDS = (1, 2)
SENSOR_W, SENSOR_H = 1920, 1080   # 与 dual_camera_preview.py 一致
FPS = 30
EXPOSURE_US = {1: 1000, 2: 1000}  # 每路目标微秒；先静态验光，再按拖影/亮度分别调整
EXPOSURE_SETTLE_FRAMES = 3         # 设置后逐路丢弃启动帧，再读回确认；不用于计数
CAP_W, CAP_H = 960, 540           # chn0 取帧尺寸（16:9 不变形）。v3 320x180 豆约 15x20 px → 这里约 45x60 px。
                                  # 1280x720 在 run() 报 vicap init failed(-1)（drop_capture_4）；失败就断电改 640, 360

# ---- 豆道 ROI：按 1280x720 坐标填写，脚本按 CAP_W 自动缩放，换取帧尺寸时不用改 ----
ROI_REF_W, ROI_REF_H = 440, 480   # 两路相同；宽度为手丢豆的左右偏差留余量，高度取中间 2/3
ROI_REF_X = {1: 560, 2: 230}      # 各相机 ROI 左上角 x。按 drop001 event 0 豆子位置（960 宽下 cam1 x≈570-600、cam2 x≈315-360，
                                  # 两相机对拍所以左右镜像）把框中心移到豆道；只有一颗豆的数据，手丢偏差大时再调
ROI_REF_Y = {1: 120, 2: 120}
_K = CAP_W / 1280
ROI_W, ROI_H = int(ROI_REF_W * _K), int(ROI_REF_H * _K)
ROI_X = {c: int(x * _K) for c, x in ROI_REF_X.items()}
ROI_Y = {c: int(y * _K) for c, y in ROI_REF_Y.items()}

# ---- 运动检测（只在 ROI 内）----
CELL = 30                         # 网格格子边长（px）；每格只统计中心 PATCH x PATCH；豆约 45 px，至少盖住一个中心块
PATCH = 16
DIFF_L = 10                       # 某格 L 均值偏离背景超过此值算“变化”
MIN_CELLS = 2                     # 至少几格变化才触发（有背景板后误触发少；漏拍就调小 DIFF_L 或 MIN_CELLS）
BG_ALPHA = 0.1
BG_LEARN_FRAMES = 15
SHOW_EVERY = 3                    # 待机时每 N 帧刷新一次屏幕，缩略图绘制会拖慢检测循环

# ---- 连拍与存盘 ----
BURST_FRAMES = 3                  # 每次触发保存的组数（含触发组），受 MEM_BUDGET 封顶
MEM_BUDGET = 2600000              # 连拍裁图总字节上限（GC 堆空闲约 3.8 MB）
MAX_EVENTS = 20
DURATION_MS = 180000
OUT_ROOT = "/sdcard/beanlens"
SCRIPT_VERSION = 6
TARGET_FIRMWARE = "CanMV_K230D_ATK_DNK230D_micropython_v1.6-0-ge4441cc_nncase_v2.9.0"

# ---- 对焦模式 ----
FOCUS_BOX = 150                   # ROI 中心的方框边长（CAP 像素）；把粘在细杆上的豆举到框中间
FOCUS_PATCH = 10                  # 清晰度 = 方框内各 PATCH x PATCH 小块亮度标准差的平均；越清楚越大
FOCUS_PRINT_MS = 1000             # 串口每隔多少毫秒打印一次数值

DISPLAY_W, DISPLAY_H = 640, 480
SHOW_W = DISPLAY_W // 2
SHOW_H = SHOW_W * CAP_H // CAP_W
SHOW_Y = (DISPLAY_H - SHOW_H) // 2
PANE_X = (0, DISPLAY_W // 2)

CROP_BYTES = ROI_W * ROI_H * 2
BURST = max(1, min(BURST_FRAMES, MEM_BUDGET // (CROP_BYTES * len(CAM_IDS))))


def make_cells(cam):
    x0, y0 = ROI_X[cam], ROI_Y[cam]
    off = (CELL - PATCH) // 2
    return [(x0 + gx * CELL + off, y0 + gy * CELL + off, PATCH, PATCH)
            for gy in range(ROI_H // CELL) for gx in range(ROI_W // CELL)]


def roi(cam):
    return (ROI_X[cam], ROI_Y[cam], ROI_W, ROI_H)


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


def focus_box(cam):
    x0, y0 = ROI_X[cam], ROI_Y[cam]
    b = min(FOCUS_BOX, ROI_W, ROI_H)
    return (x0 + (ROI_W - b) // 2, y0 + (ROI_H - b) // 2, b, b)


def sharpness(img, box):
    # 只作调焦时的相对比较：同一场景、同一光照下越大越清楚；不同场景之间不可比
    x0, y0, w, h = box
    vals = [img.get_statistics(roi=(x, y, FOCUS_PATCH, FOCUS_PATCH)).l_stdev()
            for y in range(y0, y0 + h - FOCUS_PATCH + 1, FOCUS_PATCH)
            for x in range(x0, x0 + w - FOCUS_PATCH + 1, FOCUS_PATCH)]
    return sum(vals) / len(vals)


def focus_loop(sensors, canvas):
    # 两路各显示方框内画面（放大），下方显示当前/最高清晰度和条形图；不写存储
    boxes = [focus_box(c) for c in CAM_IDS]
    side = boxes[0][2]
    zoom = min((DISPLAY_W // 2 - 20) / side, 300 / side)
    best = [0.0] * len(sensors)
    hist = [[] for _ in sensors]          # 最近几帧平滑，减少数值跳动
    last_print = time.ticks_ms()
    print("focus mode: hold a bean (e.g. taped to a thin stick) at the drop position, inside the box;")
    print("turn each M12 lens slowly until the number peaks, then lock it. Stop the script when done.")
    while True:
        os.exitpoint()
        crops, cur = [], []
        for i, s in enumerate(sensors):
            img = s.snapshot(chn=CAM_CHN_ID_0)
            v = sharpness(img, boxes[i])
            hist[i] = (hist[i] + [v])[-5:]
            v = sum(hist[i]) / len(hist[i])
            best[i] = max(best[i], v)
            cur.append(v)
            crops.append(img.copy(roi=boxes[i]))
            img = None
        canvas.clear()
        canvas.draw_rectangle(0, 0, DISPLAY_W, 28, color=(0, 0, 0), fill=True)
        canvas.draw_string_advanced(4, 4, 20, "对焦模式：豆放在框中间，转镜头使数值最大", color=(255, 255, 0))
        for i, c in enumerate(CAM_IDS):
            x0 = PANE_X[i] + 10
            try:
                canvas.draw_image(crops[i], x0, 36, x_scale=zoom, y_scale=zoom)
            except Exception as e:
                print("zoomed draw failed:", e)
            y = 36 + int(side * zoom) + 8
            canvas.draw_string_advanced(x0, y, 20, "CAM%d" % c, color=(255, 255, 0))
            canvas.draw_string_advanced(x0, y + 24, 32, "%.1f" % cur[i], color=(255, 255, 255))
            canvas.draw_string_advanced(x0 + 120, y + 34, 18, "最高 %.1f" % best[i], color=(160, 160, 160))
            bar = int(280 * cur[i] / best[i]) if best[i] > 0 else 0
            canvas.draw_rectangle(x0, y + 64, 280, 14, color=(80, 80, 80), fill=True)
            canvas.draw_rectangle(x0, y + 64, bar, 14,
                                  color=(0, 255, 0) if cur[i] >= 0.95 * best[i] else (255, 160, 0), fill=True)
        Display.show_image(canvas)
        crops = None
        if time.ticks_diff(time.ticks_ms(), last_print) >= FOCUS_PRINT_MS:
            last_print = time.ticks_ms()
            print("  " + "   ".join("cam%d %.1f (max %.1f)" % (c, cur[i], best[i]) for i, c in enumerate(CAM_IDS)))


def check_config():
    for c in CAM_IDS:
        if ROI_X[c] < 0 or ROI_Y[c] < 0 or ROI_X[c] + ROI_W > CAP_W or ROI_Y[c] + ROI_H > CAP_H:
            raise ValueError("cam%d ROI (%d,%d,%d,%d) outside %dx%d" % ((c,) + roi(c) + (CAP_W, CAP_H)))
    if ROI_W < CELL or ROI_H < CELL:
        raise ValueError("ROI smaller than one CELL")


def open_sensor(cam_id):
    step("open camera id=%d" % cam_id)
    s = Sensor(id=cam_id, width=SENSOR_W, height=SENSOR_H, fps=FPS)
    try:
        s.reset()
        s.set_framesize(width=CAP_W, height=CAP_H, chn=CAM_CHN_ID_0)
        s.set_pixformat(Sensor.RGB565, chn=CAM_CHN_ID_0)
        # v1.6 只在 run() 前提交 AE 开关；曝光范围/读写须等 run() 创建有效 fd。
        for name in ("auto_exposure", "get_exposure_time_range", "exposure"):
            if not callable(getattr(s, name, None)):
                raise RuntimeError("cam%d missing %s; use ATK DNK230D v1.6" % (cam_id, name))
        s.auto_exposure(False)
        if s.auto_exposure() is not False:
            raise RuntimeError("cam%d could not disable auto exposure" % cam_id)
    except BaseException:
        s.stop()
        raise
    return s


def positive_number(value):
    # 同时拒绝 bool、NaN、无穷；MicroPython 不依赖 math.isfinite。
    return (not isinstance(value, bool) and isinstance(value, (int, float))
            and 0 < value < float("inf"))


def start_sensors(sensors):
    # v1.6 Sensor._run_mcm_device() 会启动所有已 reset 的相机，仍只调用首路 run。
    sensors[0].run()
    records = []
    for cid, s in zip(CAM_IDS, sensors):
        target = EXPOSURE_US.get(cid)
        if not positive_number(target):
            raise ValueError("cam%d exposure target must be positive finite us" % cid)
        limits = s.get_exposure_time_range()
        if not isinstance(limits, (tuple, list)) or len(limits) != 2:
            raise RuntimeError("cam%d exposure range unavailable: %s" % (cid, limits))
        max_us, min_us = limits
        if not positive_number(min_us) or not positive_number(max_us) or min_us > max_us:
            raise RuntimeError("cam%d invalid exposure range: %s" % (cid, limits))
        if not min_us <= target <= max_us:
            raise ValueError("cam%d exposure %s us outside [%s, %s]; adjust EXPOSURE_US"
                             % (cid, target, min_us, max_us))
        # setter 的返回值不当作实际曝光；以下用读回值确认，容许传感器行周期量化。
        s.exposure(target)
        for _ in range(EXPOSURE_SETTLE_FRAMES):
            s.snapshot(chn=CAM_CHN_ID_0)
        actual = s.exposure()
        tolerance = max(100, target * 0.05)
        if (s.auto_exposure() is not False or not positive_number(actual)
                or not min_us <= actual <= max_us or abs(actual - target) > tolerance):
            raise RuntimeError("cam%d exposure verification failed: requested=%s actual=%s us"
                               % (cid, target, actual))
        rec = (cid, target, actual, min_us, max_us)
        records.append(rec)
        print("cam%d manual exposure: requested=%s actual=%s range=[%s,%s] us" % rec)
    return records


def cell_means(img, cells):
    return [img.get_statistics(roi=r).l_mean() for r in cells]


def changed_cells(means, bg):
    return sum(1 for m, b in zip(means, bg) if abs(m - b) > DIFF_L)


def update_bg(bg, means):
    for k in range(len(bg)):
        bg[k] += BG_ALPHA * (means[k] - bg[k])


thumbs_ok = True
trig_by_cam = {c: 0 for c in CAM_IDS}   # 每路是触发相机的次数


def show_canvas(canvas, imgs, text, color, box_color):
    global thumbs_ok
    canvas.clear()
    sx, sy = SHOW_W / CAP_W, SHOW_H / CAP_H
    for i, img in enumerate(imgs):
        if thumbs_ok and img is not None:
            try:
                canvas.draw_image(img, PANE_X[i], SHOW_Y, x_scale=sx, y_scale=sy)
            except Exception as e:
                thumbs_ok = False
                print("thumbnail drawing not supported, text only:", e)
        c = CAM_IDS[i]
        canvas.draw_rectangle(PANE_X[i] + int(ROI_X[c] * sx), SHOW_Y + int(ROI_Y[c] * sy),
                              max(2, int(ROI_W * sx)), max(2, int(ROI_H * sy)), color=box_color, thickness=2)
        canvas.draw_string_advanced(PANE_X[i] + 4, SHOW_Y + SHOW_H + 4, 18, "CAM%d" % c, color=(255, 255, 0))
    canvas.draw_rectangle(0, 0, DISPLAY_W, 28, color=(0, 0, 0), fill=True)
    canvas.draw_string_advanced(4, 4, 20, text, color=color)
    fy = SHOW_Y + SHOW_H + 30
    canvas.draw_string_advanced(10, fy, 48, "豆子 %d / %d" % (n_events, MAX_EVENTS), color=(255, 255, 255))
    canvas.draw_string_advanced(330, fy + 4, 20,
                                "  ".join("CAM%d 触发 %d" % (c, trig_by_cam[c]) for c in CAM_IDS),
                                color=(200, 200, 200))
    canvas.draw_string_advanced(330, fy + 30, 16, "按触发计数，含误触发", color=(160, 160, 160))
    Display.show_image(canvas)


def make_run_dir(exposure_records):
    if not exists(OUT_ROOT):
        os.mkdir(OUT_ROOT)
    n = 0
    while exists("%s/drop%03d" % (OUT_ROOT, n)):
        n += 1
    path = "%s/drop%03d" % (OUT_ROOT, n)
    os.mkdir(path)
    with open(path + "/meta.txt", "w") as f:
        f.write("script=drop_capture.py\nscript_version=%d\nstatus=started\n"
                "width=%d\nheight=%d\nformat=RGB565\nsave_mode=raw\n"
                "sensor=%dx%d@%d\nchn=0\ncap=%dx%d\ncams=%s\nroi=%s\n"
                "cell=%d\npatch=%d\ndiff_l=%d\nmin_cells=%d\nburst_frames=%d\n"
                % (SCRIPT_VERSION, ROI_W, ROI_H, SENSOR_W, SENSOR_H, FPS, CAP_W, CAP_H,
                   ",".join(str(c) for c in CAM_IDS),
                   ";".join("cam%d:%d,%d,%d,%d" % ((c,) + roi(c)) for c in CAM_IDS),
                   CELL, PATCH, DIFF_L, MIN_CELLS, BURST))
        f.write("target_firmware=%s\nuname=%s\nauto_exposure=False\n"
                "exposure_settle_frames=%d\nexposure_verified=readback_only\n"
                % (TARGET_FIRMWARE, str(os.uname()), EXPOSURE_SETTLE_FRAMES))
        for cid, requested, actual, min_us, max_us in exposure_records:
            f.write("cam%d_exposure_requested_us=%s\ncam%d_exposure_actual_us=%s\n"
                    "cam%d_exposure_min_us=%s\ncam%d_exposure_max_us=%s\n"
                    % (cid, requested, cid, actual, cid, min_us, cid, max_us))
    sync_fs()
    return path


sensors = []
streams = []
offsets = []
index_f = None
events_f = None
run_dir = None
n_events = 0
n_frames_saved = 0
loop_frames = 0
loop_ms = 0
try:
    check_config()
    cells = [make_cells(c) for c in CAM_IDS]
    print("cap %dx%d, ROI %dx%d (%d cells/cam), burst %d pairs (%d B per crop)"
          % (CAP_W, CAP_H, ROI_W, ROI_H, len(cells[0]), BURST, CROP_BYTES))
    for cid in CAM_IDS:
        sensors.append(open_sensor(cid))

    step("Display.init")
    Display.init(Display.ST7701, width=DISPLAY_W, height=DISPLAY_H, to_ide=True)
    step("MediaManager.init")
    MediaManager.init()
    step("sensor run")
    print("target firmware:", TARGET_FIRMWARE, "actual uname:", os.uname())
    exposure_records = start_sensors(sensors)
    canvas = image.Image(DISPLAY_W, DISPLAY_H, image.RGB565)

    step("first snapshot chn0 %dx%d" % (CAP_W, CAP_H))
    first = [s.snapshot(chn=CAM_CHN_ID_0) for s in sensors]
    print("first frames ok")
    step("first get_statistics")
    for i, img in enumerate(first):
        cell_means(img, cells[i])
    print("statistics ok")
    step("first ROI copy")
    first[0].copy(roi=roi(CAM_IDS[0]))
    print("roi copy ok")

    if MODE == "focus":
        first = None                  # 不长期持有相机缓冲
        focus_loop(sensors, canvas)
    else:
        free_mb = sdcard_free_mb()
        need_mb = (2 * CAP_W * CAP_H * 2 + MAX_EVENTS * BURST * len(CAM_IDS) * CROP_BYTES) / 1048576
        print("/sdcard free %.1f MB, this run needs up to %.1f MB" % (free_mb, need_mb))
        if 0 <= free_mb < need_mb + 5:
            raise OSError("not enough space on /sdcard: free %.1f MB < %.1f MB; copy old dropNNN to PC then delete them"
                          % (free_mb, need_mb + 5))
        step("create run dir")
        run_dir = make_run_dir(exposure_records)
        print("output dir:", run_dir)
        step("save full-frame references")
        for i, img in enumerate(first):
            with open("%s/ref_cam%d.rgb565" % (run_dir, CAM_IDS[i]), "wb") as f:
                f.write(img.bytearray())
        first = None
        for cid in CAM_IDS:
            streams.append(open("%s/cam%d.rgb565stream" % (run_dir, cid), "wb"))
            offsets.append(0)
        index_f = open(run_dir + "/index.csv", "w")
        index_f.write("cam,frame,t_ms,offset,length\n")
        events_f = open(run_dir + "/events.csv", "w")
        events_f.write("event,t_ms,trigger_cam,cells_cam1,cells_cam2,frames,burst_ms,max_skew_ms,write_ms\n")
        for f in (index_f, events_f):
            f.flush()
        sync_fs()

        gc.collect()
        print("heap free before loop: %.1f MB" % (gc.mem_free() / 1048576))

        bgs = [None] * len(sensors)
        learn = BG_LEARN_FRAMES
        t0 = time.ticks_ms()
        step("learning background, keep the view empty")
        while n_events < MAX_EVENTS:
            os.exitpoint()
            now = time.ticks_diff(time.ticks_ms(), t0)
            if now >= DURATION_MS:
                print("duration reached")
                break

            tl = time.ticks_ms()
            imgs, ts, counts = [], [], []
            for i, s in enumerate(sensors):
                img = s.snapshot(chn=CAM_CHN_ID_0)
                ts.append(time.ticks_diff(time.ticks_ms(), t0))
                m = cell_means(img, cells[i])
                if bgs[i] is None:
                    bgs[i] = list(m)
                counts.append(changed_cells(m, bgs[i]))
                if learn > 0 or counts[i] < MIN_CELLS:
                    update_bg(bgs[i], m)
                imgs.append(img)
            loop_frames += 1
            loop_ms += time.ticks_diff(time.ticks_ms(), tl)
            triggered = learn == 0 and max(counts) >= MIN_CELLS

            if not triggered:
                if learn > 0:
                    learn -= 1
                    text, color, box = "learning background...", (255, 255, 0), (255, 255, 0)
                    if learn == 0:
                        print("ready: drop a bean (%d/%d saved)" % (n_events, MAX_EVENTS))
                else:
                    text, color, box = ("READY drop a bean %d/%d cells %s" % (n_events, MAX_EVENTS, counts),
                                        (0, 255, 0), (0, 255, 0))
                if loop_frames % SHOW_EVERY == 0:
                    show_canvas(canvas, imgs, text, color, box)
                imgs = None
                continue

            # ---- 触发：裁 ROI 复制到内存后连拍；连拍中不刷新屏幕 ----
            trig_cam = CAM_IDS[0] if counts[0] >= counts[1] else CAM_IDS[1]
            trig_by_cam[trig_cam] += 1
            t_trig = ts[0]
            burst = []
            tb = time.ticks_ms()
            try:
                burst.append(([im.copy(roi=roi(CAM_IDS[i])) for i, im in enumerate(imgs)], list(ts)))
                imgs = None
                for k in range(BURST - 1):
                    pair, pts = [], []
                    for i, s in enumerate(sensors):
                        pair.append(s.snapshot(chn=CAM_CHN_ID_0).copy(roi=roi(CAM_IDS[i])))
                        pts.append(time.ticks_diff(time.ticks_ms(), t0))
                    burst.append((pair, pts))
            except MemoryError:
                imgs = None
                print("  MemoryError after %d pairs, saving what was captured" % len(burst))
            burst_ms = time.ticks_diff(time.ticks_ms(), tb)
            if not burst:
                learn = BG_LEARN_FRAMES
                continue
            max_skew = max(abs(p[1] - p[0]) for _, p in burst if len(p) == 2)
            show_canvas(canvas, [None, None], "saving bean %d ..." % (n_events + 1), (255, 128, 0), (255, 128, 0))

            tw = time.ticks_ms()
            for k, (pair, pts) in enumerate(burst):
                frame_no = n_events * 100 + k
                for i, im in enumerate(pair):
                    streams[i].write(im.bytearray())
                    index_f.write("%d,%d,%d,%d,%d\n" % (CAM_IDS[i], frame_no, pts[i], offsets[i], CROP_BYTES))
                    offsets[i] += CROP_BYTES
                    n_frames_saved += 1
                burst[k] = None
            n_pairs = len(burst)
            burst = None
            for f in streams + [index_f]:
                f.flush()
            write_ms = time.ticks_diff(time.ticks_ms(), tw)
            events_f.write("%d,%d,%d,%d,%d,%d,%d,%d,%d\n"
                           % (n_events, t_trig, trig_cam, counts[0], counts[1], n_pairs, burst_ms, max_skew, write_ms))
            events_f.flush()
            sync_fs()
            gc.collect()
            print("event %d: t=%d ms trig cam%d cells=%s, %d pairs in %d ms, skew<=%d ms, written in %d ms, heap %.1f MB"
                  % (n_events, t_trig, trig_cam, counts, n_pairs, burst_ms, max_skew, write_ms,
                     gc.mem_free() / 1048576))
            n_events += 1
            learn = BG_LEARN_FRAMES
            show_canvas(canvas, [None, None], "saved, learning background...", (255, 255, 0), (255, 255, 0))

        elapsed = time.ticks_diff(time.ticks_ms(), t0)
        step("close files")
        for f in streams + [index_f, events_f]:
            f.close()
        streams, index_f, events_f = [], None, None
        with open(run_dir + "/done.txt", "w") as f:
            f.write("status=done\nelapsed_ms=%d\nevents=%d\nframes=%d\nloop_frames=%d\nloop_avg_ms=%.1f\n"
                    % (elapsed, n_events, n_frames_saved, loop_frames, loop_ms / max(1, loop_frames)))
        sync_fs()

        print("---- summary ----")
        print("events: %d, frames saved: %d, elapsed %d ms, triggers by cam: %s"
              % (n_events, n_frames_saved, elapsed, trig_by_cam))
        if loop_frames:
            avg = loop_ms / loop_frames
            print("detect loop: %d pairs, avg %.1f ms/pair (%.1f pairs/s, excl. display)"
                  % (loop_frames, avg, 1000 / avg if avg else 0))
        print("copy each file separately (cp -r stalls): %s/{meta.txt,index.csv,events.csv,done.txt,"
              "ref_cam1.rgb565,ref_cam2.rgb565,cam1.rgb565stream,cam2.rgb565stream}" % run_dir)

except KeyboardInterrupt:
    print("user stop, events saved:", n_events)
except BaseException as e:
    print("Exception:", e)
    try:
        sys.print_exception(e)       # 打印出错行号；EIO 时可区分是写盘还是取帧
    except Exception:
        pass
    print("/sdcard free: %.1f MB" % sdcard_free_mb())
finally:
    for f in streams + [x for x in (index_f, events_f) if x is not None]:
        try:
            f.close()
        except Exception:
            pass
    for s in sensors:
        try:
            s.stop()
        except Exception:
            pass
    Display.deinit()
    os.exitpoint(os.EXITPOINT_ENABLE_SLEEP)
    time.sleep_ms(100)
    MediaManager.deinit()

