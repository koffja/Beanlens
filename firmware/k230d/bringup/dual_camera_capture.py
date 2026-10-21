# BeanLens 双摄定时拍照（bring-up 用）
# 目标：正点原子 K230D BOX + CanMV（ATK v1.3-8dd764f）
# 功能：两路相机每 PERIOD_MS 各拍一帧，持续 DURATION_MS，存到 /sdcard/beanlens/capNNN/；
#      LCD 硬件直通显示相机 1；结束后在日志打印全部帧、文件和节拍统计。
# 只新建 capNNN 目录，不覆盖、不删除已有文件。
#
# 采集路径（script_version=3，按 jpeg_probe.py B2 已通过的组合）：
#   - 两路传感器 1280x960@90（双摄时驱动为 mode 1，每路 4 x 2457600 B 缓冲）
#   - 相机1 chn0 YUV420SP VGA 经 Display.bind_layer 直通 LAYER_VIDEO1；相机2 不配 chn0
#     （ST7701 需旋转，只有 LAYER_VIDEO1 支持旋转绑定）
#   - 两路 chn1 RGB565 PANE_W x PANE_H，snapshot(chn1) 后编码/写盘；只对第一个 sensor 调 run()
#
# 运行目录状态（配合 board_diagnose.py 判断）：
#   - meta.txt：建目录后立即写入并同步，含 script_version、status=started；
#   - index.csv：开拍时写表头，每组追加，每 FLUSH_EVERY 组连同图像流一起 flush + sync；
#     卡死时已 flush 的帧仍可用 ../tools/rgb565_to_png.py 恢复；
#   - done.txt：正常结束才写，含统计；没有 done.txt 即未完成。
# 每个关键步骤先打印 "-> 步骤名"，卡死时最后一行就是卡住的位置。
#
# 存储格式：每个相机一个连续追加文件，index.csv 记录 cam,frame,t_ms,offset,length；
#   SAVE_MODE="jpg"：camN.jpgstream，每帧一段完整 JPEG；
#   SAVE_MODE="raw"：camN.rgb565stream，每帧 W*H*2 字节原始 RGB565。
#   电脑上用 ../tools/rgb565_to_png.py 拆成单张 .jpg / .png。
#
# 实测记录（详见 config/hardware-baseline.json capture_test_* / jpeg_probe_*）：
#   - v1/v2 路径（1920x1080@30 双摄、chn0 RGB565 画布显示）：首帧 compressed() 卡死，与 to_ide 无关；
#     raw 可用，但写 225 KB/组约 208 ms，只有约 5 组/秒
#   - 双摄 1920x1080@30（每路 4 x 4149248 B 缓冲）：snapshot(chn1) 卡死；每路都 run() 也卡
#   - 双摄 1280x960@90 bind + chn1 320x180 compressed(q=90)：10/10，约 13-14 KB、131-232 ms/帧
#   - chn1 320x180 是把 4:3 全画面非等比压扁（同一圆形元件横向拉宽约 1.5 倍），不是裁切 → 只用 4:3 输出
#   - 双摄 chn1 1280x960 compressed(q=90)：20/20，约 175-223 KB，每帧 1.5-2.5 s（单摄约 0.32 s）
#     → 双摄全分辨率能出图，但整帧 JPEG 存盘最多约 0.3 组/秒；实时流程只存单豆裁图与抽查证据
#   - 训练裁图长边 224（含每边 12% 余量），单豆约 180 px；设计视场 120 mm 宽时 1280 宽约 10.7 px/mm，
#     10 mm 豆约 107 px（若 1280x960 为中心截取则更大）—— 需直尺实测

import gc
import os
import time
from media.sensor import *
from media.display import *
from media.media import *

CAM_IDS = (1, 2)
SENSOR_W, SENSOR_H = 1280, 960    # 双摄 1920x1080 会卡死，见文件头
SENSOR_FPS = 90                   # 1280x960 驱动模式为 @90，已验证
DISPLAY_TYPE = Display.ST7701
DISPLAY_W, DISPLAY_H = 640, 480
PANE_W, PANE_H = 1280, 960    # chn1 全分辨率：单豆需约 180 px，缩小整帧不可用；16:9 小图会被压扁

SAVE_MODE = "jpg"             # "jpg"：本路径已验证；"raw"：原始 RGB565
JPEG_QUALITY = 90
PERIOD_MS = 4000              # 双摄全分辨率每帧编码+写盘 1.5-2.5 s，每组约 3.5 s；本脚本只用于采实拍样本
DURATION_MS = 40000           # 约 10 组
OUT_ROOT = "/sdcard/beanlens"
SCRIPT_VERSION = 3
FLUSH_EVERY = 10              # 每 10 组把索引和图像流落盘一次


def step(name):
    print("-> " + name)


def open_sensor(i, cam_id):
    step("open camera id=%d" % cam_id)
    s = Sensor(id=cam_id, width=SENSOR_W, height=SENSOR_H, fps=SENSOR_FPS)
    s.reset()
    if i == 0:
        step("cam%d chn0 YUV420SP 640x480 -> bind LAYER_VIDEO1" % cam_id)
        s.set_framesize(Sensor.VGA)
        s.set_pixformat(Sensor.YUV420SP)
        Display.bind_layer(**s.bind_info(), layer=Display.LAYER_VIDEO1)
    step("cam%d chn1 RGB565 %dx%d" % (cam_id, PANE_W, PANE_H))
    s.set_framesize(width=PANE_W, height=PANE_H, chn=CAM_CHN_ID_1)
    s.set_pixformat(Sensor.RGB565, chn=CAM_CHN_ID_1)
    return s


def sync_fs():
    # 部分固件没有 os.sync；没有时只依赖 flush/close
    f = getattr(os, "sync", None)
    if f is not None:
        try:
            f()
        except Exception:
            pass


def exists(path):
    try:
        os.stat(path)
        return True
    except OSError:
        return False


def make_run_dir():
    if not exists(OUT_ROOT):
        os.mkdir(OUT_ROOT)
    n = 0
    while exists("%s/cap%03d" % (OUT_ROOT, n)):
        n += 1
    path = "%s/cap%03d" % (OUT_ROOT, n)
    os.mkdir(path)
    with open(path + "/meta.txt", "w") as f:
        f.write("script_version=%d\nstatus=started\n"
                "width=%d\nheight=%d\nformat=RGB565\nsave_mode=%s\njpeg_quality=%d\n"
                "sensor=%dx%d@%d\nchn=1\ndisplay=bind_cam%d\n"
                "period_ms=%d\nduration_ms=%d\ncams=%s\n"
                % (SCRIPT_VERSION, PANE_W, PANE_H, SAVE_MODE, JPEG_QUALITY,
                   SENSOR_W, SENSOR_H, SENSOR_FPS, CAM_IDS[0],
                   PERIOD_MS, DURATION_MS, ",".join(str(c) for c in CAM_IDS)))
    sync_fs()
    return path


def flush_all(files):
    for f in files:
        f.flush()
    sync_fs()


sensors = []
streams = []        # 每个相机一个打开的追加文件
index_f = None      # 边拍边追加的 index.csv
index = []          # (cam_id, frame, t_ms, offset, length)
offsets = []        # 每个相机流文件当前写到的位置
late_ms = []
write_ms = []       # 每组两帧的取帧+编码+写入耗时
skipped = 0
run_dir = None
try:
    for i, cid in enumerate(CAM_IDS):
        sensors.append(open_sensor(i, cid))

    gc.collect()
    print("heap free: %.1f MB" % (gc.mem_free() / 1048576))
    print("save mode: %s, sensor %dx%d@%d, chn1 %dx%d"
          % (SAVE_MODE, SENSOR_W, SENSOR_H, SENSOR_FPS, PANE_W, PANE_H))
    step("Display.init")
    Display.init(DISPLAY_TYPE, width=DISPLAY_W, height=DISPLAY_H, to_ide=False)
    step("MediaManager.init")
    MediaManager.init()
    step("sensor run")
    sensors[0].run()          # 多摄只在第一个 sensor 上调用一次；逐个 run() 实测卡死
    time.sleep_ms(500)        # 等自动曝光稳定一点

    step("first snapshot chn1")
    for i, s in enumerate(sensors):
        s.snapshot(chn=CAM_CHN_ID_1)
    print("first frames ok")

    step("create run dir")
    run_dir = make_run_dir()
    print("output dir:", run_dir)
    ext = "jpgstream" if SAVE_MODE == "jpg" else "rgb565stream"
    for cid in CAM_IDS:
        streams.append(open("%s/cam%d.%s" % (run_dir, cid, ext), "wb"))
        offsets.append(0)
    index_f = open(run_dir + "/index.csv", "w")
    index_f.write("cam,frame,t_ms,offset,length\n")
    flush_all([index_f])

    step("recording")
    t0 = time.ticks_ms()
    next_shot = 0
    shot_idx = 0
    while True:
        os.exitpoint()
        now = time.ticks_diff(time.ticks_ms(), t0)
        if now >= DURATION_MS:
            break
        if now < next_shot:
            time.sleep_ms(1)
            continue

        late_ms.append(now - next_shot)
        tw = time.ticks_ms()
        for i, s in enumerate(sensors):
            img = s.snapshot(chn=CAM_CHN_ID_1)
            if SAVE_MODE == "jpg":
                data = img.compressed(quality=JPEG_QUALITY).bytearray()
            else:
                data = img.bytearray()
            img = None
            streams[i].write(data)
            row = (CAM_IDS[i], shot_idx, now, offsets[i], len(data))
            index.append(row)
            index_f.write("%d,%d,%d,%d,%d\n" % row)
            offsets[i] += len(data)
            data = None
        shot_idx += 1
        if shot_idx % FLUSH_EVERY == 0:
            flush_all(streams + [index_f])
        write_ms.append(time.ticks_diff(time.ticks_ms(), tw))
        if shot_idx % 10 == 0:
            print("  %d shots, %.1f s" % (shot_idx, now / 1000))
        next_shot += PERIOD_MS
        # 落后超过一个周期时跳过错过的时刻，不连拍补齐
        done = time.ticks_diff(time.ticks_ms(), t0)
        while next_shot + PERIOD_MS <= done:
            next_shot += PERIOD_MS
            skipped += 1

    elapsed = time.ticks_diff(time.ticks_ms(), t0)
    step("close files")
    for f in streams + [index_f]:
        f.close()
    streams = []
    index_f = None
    with open(run_dir + "/done.txt", "w") as f:
        f.write("status=done\nelapsed_ms=%d\nshots=%d\nplanned=%d\nskipped=%d\nframes=%d\n"
                % (elapsed, shot_idx, DURATION_MS // PERIOD_MS, skipped, len(index)))
    sync_fs()

    print("---- frames (cam, frame, t_ms, offset, length) ----")
    for row in index:
        print("cam%d  #%03d  %5d ms  @%d  %d B" % row)
    print("---- files ----")
    for name in sorted(os.listdir(run_dir)):
        print("%s/%s  %d bytes" % (run_dir, name, os.stat(run_dir + "/" + name)[6]))
    print("---- summary ----")
    print("elapsed: %d ms, shots: %d (planned %d), skipped slots: %d"
          % (elapsed, shot_idx, DURATION_MS // PERIOD_MS, skipped))
    if late_ms:
        print("shot delay vs schedule: avg %.1f ms, max %d ms"
              % (sum(late_ms) / len(late_ms), max(late_ms)))
        avg_kb = sum(r[4] for r in index) / max(1, shot_idx) / 1024
        print("snapshot+encode+write per shot (%d frames, avg %.1f KB): avg %.1f ms, max %d ms"
              % (len(CAM_IDS), avg_kb, sum(write_ms) / len(write_ms), max(write_ms)))
    try:
        st = os.statvfs("/sdcard")   # 本固件返回 bsize=512, frsize=0
        print("/sdcard free: %.1f MB" % (st[0] * st[3] / 1048576))
    except Exception as e:
        print("/sdcard free: unknown (%s)" % e)

except KeyboardInterrupt:
    print("user stop, frames saved so far:", len(index))
except BaseException as e:
    print("Exception:", e)
finally:
    # 异常退出也把已写的帧落盘；不写 done.txt，目录保持“未完成”
    for f in streams + ([index_f] if index_f is not None else []):
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
