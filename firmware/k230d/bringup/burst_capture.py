# BeanLens 定时连拍测试（bring-up 用，无执行器）
# 目标：正点原子 K230D BOX + CanMV（ATK v1.3-8dd764f）
# 目的：换一种方式拍落豆——不做运动检测，屏幕倒数 3-2-1 后在 1 秒内按固定间隔拍 FRAMES 组（默认 10 组），
#      看能不能比 drop_capture.py 拿到更清楚的豆子图像。
#
# 做法：
#   - 倒数期间 LCD 左右分屏显示两路实时画面和 ROI 框，中间大字倒数；到 "丢!" 时开始连拍，此时放手丢豆。
#   - 连拍时一直取帧（保持缓冲是新帧），每到一个 INTERVAL_MS 时间点就把两路 ROI 裁图 copy 到内存；
#     连拍中不刷新屏幕、不编码、不写盘。
#   - 每轮拍完把裁图按原始 RGB565 写到板载 SD NAND（/sdcard），再开始下一轮；全部拍完后电脑端下载并分析。
#     开始前检查 /sdcard 剩余空间，不够就不开始。不做 JPEG（compressed() 在此路径曾卡死）。
#   - v1/v2 曾把裁图经 USB 串口 base64 回传：一帧 67 s（大行）或回传途中卡死（小行，需断电），v3 改为写盘。
#
# 运行与取回（电脑端 ../tools/burst_receive.py 一条命令完成，先关闭 CanMV IDE 的连接）：
#   经 raw-paste 发送并运行本脚本、转发日志；结束后用 mpremote 逐个文件下载、核对 SHA-256、标出豆子。
#   在 IDE 里直接运行也可以，之后用 burst_receive.py --fetch <板上目录> 下载。
#
# 输出 /sdcard/beanlens/burstNNN/（只新建，不覆盖、不删除）：
#   meta.txt、frames.csv（round,cam,idx,t_ms,file,offset,length）、rNN_camC.rgb565（该轮该相机各帧首尾相接）、
#   files.csv（name,size,sha256，每轮写完追加）、done.txt（正常结束才有）。
#   日志里 "@RUNDIR <路径>" 一行给出目录，电脑端据此下载。
#
# 采集路径沿用 drop_capture.py v5（2026-10-24 drop002 已跑通）：两路 1920x1080@30、chn0 RGB565 960x540、不 bind、
#   画布 + Display.show_image、只对第一个 sensor run()。1280x720 双摄 run() 失败（drop_capture_4），不用。
#
# 内存：GC 堆空闲约 3.7 MB。一轮裁图 = FRAMES x 两路 x ROI_W x ROI_H x 2 B，必须 <= MEM_BUDGET，否则启动即报错；
#   默认 10 x 2 x 330 x 200 x 2 = 2.64 MB。要更高的 ROI 就减 FRAMES 或只用一路相机（CAM_IDS = (1,)）。
#
# 注意（拍之前先知道）：
#   - 这个方法不缩短曝光：每张的拖影和 drop_capture 一样，由自动曝光决定（本固件没有手动曝光接口）。
#     它解决的是“检测触发慢/漏拍”，以及一次拿到一整秒的帧来挑最清楚的一张。
#   - 落豆约 1.4 m/s，100 ms 间隔里豆会走约 14 cm，可能比整个画面还高，所以一轮 10 组里豆可能只出现在 0-1 组。
#     看结果若大多数轮次没拍到豆，把 INTERVAL_MS 改成 33（传感器 30 fps 的极限，10 组约 0.33 s），并在 "丢!" 时立刻放手。
#   - 两路是先后取帧，不是硬同步；间隔时间以 frames.csv 的 t_ms 为准。
#   - 2026-10-24 写盘时 SD NAND 曾整体出 EIO（drop_capture_5，断电后恢复）。出 EIO 就停，断电后先只读检查。

import gc
import os
import time
import image
from media.sensor import *
from media.display import *
from media.media import *
# 标准库放在 media 的 * 导入之后：* 导入会覆盖 sys（kmodel_live_classify.py 实测）
import sys
import binascii
try:
    import hashlib
except ImportError:
    hashlib = None

CAM_IDS = (1, 2)
SENSOR_W, SENSOR_H = 1920, 1080
FPS = 30
CAP_W, CAP_H = 960, 540           # chn0 取帧尺寸，与 drop_capture.py v5 相同

# ---- 豆道 ROI（960x540 坐标）：x 沿用 drop002（cam1 420、cam2 172，宽 330）；高度为了内存从 360 减到 200 ----
ROI_W, ROI_H = 330, 200
ROI_X = {1: 420, 2: 172}
ROI_Y = {1: 170, 2: 170}          # 原 ROI 竖向 90-450 的中段；倒数画面里看豆道是否在框内，不在就调

# ---- 连拍 ----
FRAMES = 10                       # 每轮组数（每组两路各一张）
INTERVAL_MS = 100                 # 组间隔；10 x 100 ms = 1 s。拍不到豆时改 33（见上方注意）
COUNTDOWN_S = 3
ROUNDS = 5
PAUSE_MS = 1500                   # 每轮写完到下一轮倒数之间
MEM_BUDGET = 3000000              # 一轮裁图总字节上限（GC 堆空闲约 3.7 MB）
OUT_ROOT = "/sdcard/beanlens"
FREE_MARGIN_MB = 10               # 写完本次全部轮次后 /sdcard 至少还要剩这么多
SCRIPT_VERSION = 3

DISPLAY_W, DISPLAY_H = 640, 480
SHOW_W = DISPLAY_W // 2
SHOW_H = SHOW_W * CAP_H // CAP_W
SHOW_Y = (DISPLAY_H - SHOW_H) // 2
PANE_X = (0, DISPLAY_W // 2)

CROP_BYTES = ROI_W * ROI_H * 2
ROUND_BYTES = FRAMES * len(CAM_IDS) * CROP_BYTES


def step(name):
    print("-> " + name)


def roi(cam):
    return (ROI_X[cam], ROI_Y[cam], ROI_W, ROI_H)


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


def check_config():
    for c in CAM_IDS:
        if ROI_X[c] < 0 or ROI_Y[c] < 0 or ROI_X[c] + ROI_W > CAP_W or ROI_Y[c] + ROI_H > CAP_H:
            raise ValueError("cam%d ROI (%d,%d,%d,%d) outside %dx%d" % ((c,) + roi(c) + (CAP_W, CAP_H)))
    if ROUND_BYTES > MEM_BUDGET:
        raise ValueError("one round needs %d B > MEM_BUDGET %d B; lower FRAMES, ROI_W/ROI_H or use one camera"
                         % (ROUND_BYTES, MEM_BUDGET))


def check_space():
    free = sdcard_free_mb()
    need = ROUNDS * ROUND_BYTES / 1048576
    print("/sdcard free %.1f MB, this run writes %.1f MB, keeps >= %d MB free" % (free, need, FREE_MARGIN_MB))
    if free < 0:
        raise OSError("cannot read /sdcard free space (statvfs failed); power cycle and check read-only first")
    if free < need + FREE_MARGIN_MB:
        raise OSError("not enough space on /sdcard: free %.1f MB < %.1f MB; copy old runs to the PC, then delete them"
                      % (free, need + FREE_MARGIN_MB))


def make_run_dir():
    if not exists(OUT_ROOT):
        os.mkdir(OUT_ROOT)
    n = 0
    while exists("%s/burst%03d" % (OUT_ROOT, n)):
        n += 1
    path = "%s/burst%03d" % (OUT_ROOT, n)
    os.mkdir(path)
    with open(path + "/meta.txt", "w") as f:
        f.write("script=burst_capture.py\nscript_version=%d\nsensor=%dx%d@%d\ncap=%dx%d\nformat=RGB565\n"
                "width=%d\nheight=%d\ncams=%s\nroi=%s\nframes=%d\ninterval_ms=%d\ncountdown_s=%d\nrounds=%d\n"
                % (SCRIPT_VERSION, SENSOR_W, SENSOR_H, FPS, CAP_W, CAP_H, ROI_W, ROI_H,
                   ",".join(str(c) for c in CAM_IDS),
                   ";".join("cam%d:%d,%d,%d,%d" % ((c,) + roi(c)) for c in CAM_IDS),
                   FRAMES, INTERVAL_MS, COUNTDOWN_S, ROUNDS))
    with open(path + "/frames.csv", "w") as f:
        f.write("round,cam,idx,t_ms,file,offset,length\n")
    with open(path + "/files.csv", "w") as f:
        f.write("name,size,sha256\n")
    sync_fs()
    return path


def open_sensor(cam_id):
    step("open camera id=%d" % cam_id)
    s = Sensor(id=cam_id, width=SENSOR_W, height=SENSOR_H, fps=FPS)
    s.reset()
    s.set_framesize(width=CAP_W, height=CAP_H, chn=CAM_CHN_ID_0)
    s.set_pixformat(Sensor.RGB565, chn=CAM_CHN_ID_0)
    return s


thumbs_ok = True


def show(canvas, imgs, big, big_color, top, top_color):
    # imgs 为 None 时只显示文字；缩略图画不出来时自动退回只显示文字
    global thumbs_ok
    canvas.clear()
    sx, sy = SHOW_W / CAP_W, SHOW_H / CAP_H
    for i, c in enumerate(CAM_IDS):
        img = imgs[i] if imgs else None
        if thumbs_ok and img is not None:
            try:
                canvas.draw_image(img, PANE_X[i], SHOW_Y, x_scale=sx, y_scale=sy)
            except Exception as e:
                thumbs_ok = False
                print("thumbnail drawing not supported, text only:", e)
        canvas.draw_rectangle(PANE_X[i] + int(ROI_X[c] * sx), SHOW_Y + int(ROI_Y[c] * sy),
                              int(ROI_W * sx), int(ROI_H * sy), color=(0, 255, 0), thickness=2)
        canvas.draw_string_advanced(PANE_X[i] + 4, SHOW_Y + SHOW_H + 4, 18, "CAM%d" % c, color=(255, 255, 0))
    canvas.draw_rectangle(0, 0, DISPLAY_W, 28, color=(0, 0, 0), fill=True)
    canvas.draw_string_advanced(4, 4, 20, top, color=top_color)
    if big:
        canvas.draw_string_advanced(DISPLAY_W // 2 - 60, DISPLAY_H - 120, 96, big, color=big_color)
    Display.show_image(canvas)


def countdown(sensors, canvas, rnd):
    # 实时预览 + 倒数；返回时立刻开始连拍
    t0 = time.ticks_ms()
    total = COUNTDOWN_S * 1000
    last = None
    while True:
        os.exitpoint()
        left = total - time.ticks_diff(time.ticks_ms(), t0)
        if left <= 0:
            break
        n = (left + 999) // 1000
        if n != last:
            print("countdown %d" % n)
            last = n
        imgs = [s.snapshot(chn=CAM_CHN_ID_0) for s in sensors]
        show(canvas, imgs, "%d" % n, (255, 255, 0),
             "第 %d/%d 轮：豆拿在落豆口，数到 0 放手" % (rnd + 1, ROUNDS), (255, 255, 0))
        imgs = None
    # 文字提示一次即可，连拍期间不再刷新屏幕
    show(canvas, None, "丢!", (0, 255, 0), "第 %d/%d 轮：连拍中" % (rnd + 1, ROUNDS), (0, 255, 0))
    print("DROP")


def burst(sensors):
    # 连拍：一直取帧保持缓冲是新帧，每到 INTERVAL_MS 时间点 copy 一组 ROI；返回 [(cam, idx, t_ms, crop)]
    out = []
    t0 = time.ticks_ms()
    k = 0
    try:
        while k < FRAMES:
            due = time.ticks_diff(time.ticks_ms(), t0) >= k * INTERVAL_MS
            for i, s in enumerate(sensors):
                img = s.snapshot(chn=CAM_CHN_ID_0)
                if due:
                    t = time.ticks_diff(time.ticks_ms(), t0)
                    out.append((CAM_IDS[i], k, t, img.copy(roi=roi(CAM_IDS[i]))))
                img = None
            if due:
                k += 1
    except MemoryError:
        print("MemoryError after %d crops, saving what was captured" % len(out))
    return out, time.ticks_diff(time.ticks_ms(), t0)


def save_round(run_dir, rnd, crops):
    # 每路一个文件，各帧首尾相接；frames.csv 记偏移；files.csv 记 SHA-256 供电脑端核对
    rows = []
    for cam in CAM_IDS:
        name = "r%02d_cam%d.rgb565" % (rnd, cam)
        h = hashlib.sha256() if hashlib is not None else None
        off = 0
        with open("%s/%s" % (run_dir, name), "wb") as f:
            for j in range(len(crops)):
                if crops[j] is None or crops[j][0] != cam:
                    continue
                _, idx, t, crop = crops[j]
                buf = crop.bytearray()
                f.write(buf)
                if h is not None:
                    h.update(buf)
                rows.append("%d,%d,%d,%d,%s,%d,%d\n" % (rnd, cam, idx, t, name, off, len(buf)))
                off += len(buf)
                crops[j] = None
                crop = buf = None
        digest = binascii.hexlify(h.digest()).decode() if h is not None else "-"
        with open(run_dir + "/files.csv", "a") as f:
            f.write("%s,%d,%s\n" % (name, off, digest))
    with open(run_dir + "/frames.csv", "a") as f:
        for r in rows:
            f.write(r)
    sync_fs()


sensors = []
rounds_done = 0
run_dir = None
try:
    check_config()
    check_space()
    print("cap %dx%d, ROI %dx%d, %d frames every %d ms, %d B per crop, %d B per round"
          % (CAP_W, CAP_H, ROI_W, ROI_H, FRAMES, INTERVAL_MS, CROP_BYTES, ROUND_BYTES))
    step("create run dir")
    run_dir = make_run_dir()
    print("@RUNDIR " + run_dir)
    for cid in CAM_IDS:
        sensors.append(open_sensor(cid))
    step("Display.init")
    Display.init(Display.ST7701, width=DISPLAY_W, height=DISPLAY_H, to_ide=True)
    step("MediaManager.init")
    MediaManager.init()
    step("sensor run")
    sensors[0].run()
    canvas = image.Image(DISPLAY_W, DISPLAY_H, image.RGB565)
    step("first snapshot")
    for s in sensors:
        s.snapshot(chn=CAM_CHN_ID_0)
    gc.collect()
    print("heap free: %.1f MB" % (gc.mem_free() / 1048576))

    for rnd in range(ROUNDS):
        countdown(sensors, canvas, rnd)
        crops, burst_ms = burst(sensors)
        print("round %d: %d crops in %d ms" % (rnd, len(crops), burst_ms))
        show(canvas, None, None, None, "第 %d/%d 轮：保存中..." % (rnd + 1, ROUNDS), (255, 128, 0))
        tw = time.ticks_ms()
        save_round(run_dir, rnd, crops)
        crops = None
        rounds_done += 1
        gc.collect()
        print("round %d saved in %d ms, heap free %.1f MB, /sdcard free %.1f MB"
              % (rnd, time.ticks_diff(time.ticks_ms(), tw), gc.mem_free() / 1048576, sdcard_free_mb()))
        if rnd + 1 < ROUNDS:
            show(canvas, None, None, None, "已保存，准备下一颗豆", (255, 255, 0))
            time.sleep_ms(PAUSE_MS)
    with open(run_dir + "/done.txt", "w") as f:
        f.write("status=done\nrounds=%d\n" % rounds_done)
    sync_fs()
    show(canvas, None, None, None, "全部完成 %d 轮，可以下载" % rounds_done, (0, 255, 0))
    print("@DONE rounds=%d" % rounds_done)

except KeyboardInterrupt:
    print("user stop, rounds saved:", rounds_done)
except BaseException as e:
    print("Exception:", e)
    try:
        sys.print_exception(e)       # EIO 时可区分是写盘还是取帧
    except Exception:
        pass
    print("/sdcard free: %.1f MB" % sdcard_free_mb())
finally:
    for s in sensors:
        try:
            s.stop()
        except Exception:
            pass
    Display.deinit()
    os.exitpoint(os.EXITPOINT_ENABLE_SLEEP)
    time.sleep_ms(100)
    MediaManager.deinit()
    print("@STOPPED rounds=%d" % rounds_done)
