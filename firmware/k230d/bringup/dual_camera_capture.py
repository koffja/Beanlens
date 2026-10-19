# BeanLens 双摄定时拍照（bring-up 用）
# 目标：正点原子 K230D BOX + CanMV（ATK v1.3-8dd764f）
# 功能：两路相机每 100ms 各拍一帧，持续 10 秒，存到 /sdcard/beanlens/capNNN/；
#      屏幕左右继续显示预览；结束后在日志打印全部帧、文件和节拍统计。
# 只新建 capNNN 目录，不覆盖、不删除已有文件。
#
# 存储格式：每个相机一个连续追加文件，index.csv 记录 cam,frame,t_ms,offset,length；
#   SAVE_MODE="jpg"：camN.jpgstream，每帧一段完整 JPEG；
#   SAVE_MODE="raw"：camN.rgb565stream，每帧 W*H*2 字节原始 RGB565。
#   电脑上用 ../tools/rgb565_to_png.py 拆成单张 .jpg / .png。
#
# 2026-10-17 实测（ATK v1.3, to_ide=True）：
#   - 相机启动前做 TF 操作 + 单独自检时第一次 snapshot 卡死；本结构（以预览脚本为底稿）正常
#   - compressed()/save() 做 JPEG 编码卡死（相机缓冲区和堆副本都卡）
#   - 每帧单独建文件：2 x 115 KB/组，只达到约 5 组/秒，且越往后越慢
#   - 连续追加 raw：写 225 KB/组平均 208 ms（约 1.1 MB/s），仍只有约 5 组/秒 → TF 写入带宽是瓶颈
#   - 下一步验证：关闭 IDE 帧缓冲（TO_IDE=False）后 JPEG 编码是否还卡死

import gc
import os
import time
import image
from media.sensor import *
from media.display import *
from media.media import *

CAM_IDS = (1, 2)
SENSOR_W, SENSOR_H = 1920, 1080
DISPLAY_TYPE = Display.ST7701
DISPLAY_W, DISPLAY_H = 640, 480
PANE_W, PANE_H = 320, 180     # 与预览相同；存盘也用这一帧
FPS = 30

SAVE_MODE = "jpg"             # "jpg" 或 "raw"，见文件头
TO_IDE = False                # 怀疑 IDE 帧缓冲的 JPEG 编码与 compressed() 冲突；关闭后只在 LCD 显示
JPEG_QUALITY = 90
PERIOD_MS = 100               # 10 组/秒
DURATION_MS = 10000           # 10 秒
OUT_ROOT = "/sdcard/beanlens"

pane_y = (DISPLAY_H - PANE_H) // 2
PANE_X = (0, DISPLAY_W // 2)


def open_sensor(cam_id):
    s = Sensor(id=cam_id, width=SENSOR_W, height=SENSOR_H, fps=FPS)
    s.reset()
    s.set_framesize(width=PANE_W, height=PANE_H, chn=CAM_CHN_ID_0)
    s.set_pixformat(Sensor.RGB565, chn=CAM_CHN_ID_0)
    return s


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
        f.write("width=%d\nheight=%d\nformat=RGB565\nsave_mode=%s\nperiod_ms=%d\ncams=%s\n"
                % (PANE_W, PANE_H, SAVE_MODE, PERIOD_MS, ",".join(str(c) for c in CAM_IDS)))
    return path


sensors = []
streams = []        # 每个相机一个打开的追加文件
index = []          # (cam_id, frame, t_ms, offset, length)
offsets = []        # 每个相机流文件当前写到的位置
late_ms = []
write_ms = []       # 每组两帧的写入耗时
skipped = 0
run_dir = None
try:
    for cid in CAM_IDS:
        sensors.append(open_sensor(cid))
        print("camera id=%d opened" % cid)

    gc.collect()
    print("heap free: %.1f MB" % (gc.mem_free() / 1048576))
    print("save mode: %s, to_ide: %s" % (SAVE_MODE, TO_IDE))
    Display.init(DISPLAY_TYPE, width=DISPLAY_W, height=DISPLAY_H, to_ide=TO_IDE)
    MediaManager.init()
    sensors[0].run()

    canvas = image.Image(DISPLAY_W, DISPLAY_H, image.RGB565)
    canvas.clear()

    t0 = 0
    next_shot = 0
    shot_idx = 0
    while True:
        os.exitpoint()
        frames = [s.snapshot(chn=CAM_CHN_ID_0) for s in sensors]

        if run_dir is None:     # 第一帧读到后再碰 TF 卡
            print("first frames ok")
            run_dir = make_run_dir()
            print("output dir:", run_dir)
            ext = "jpgstream" if SAVE_MODE == "jpg" else "rgb565stream"
            for cid in CAM_IDS:
                streams.append(open("%s/cam%d.%s" % (run_dir, cid, ext), "wb"))
                offsets.append(0)
            t0 = time.ticks_ms()

        now = time.ticks_diff(time.ticks_ms(), t0)
        if now >= DURATION_MS:
            break

        if now >= next_shot:
            late_ms.append(now - next_shot)
            tw = time.ticks_ms()
            for i, img in enumerate(frames):
                if SAVE_MODE == "jpg":
                    if shot_idx == 0:
                        print("first jpeg encode cam%d ..." % CAM_IDS[i])
                    data = img.compressed(quality=JPEG_QUALITY).bytearray()
                    if shot_idx == 0:
                        print("  ok %d bytes" % len(data))
                else:
                    data = img.bytearray()
                streams[i].write(data)
                index.append((CAM_IDS[i], shot_idx, now, offsets[i], len(data)))
                offsets[i] += len(data)
            write_ms.append(time.ticks_diff(time.ticks_ms(), tw))
            shot_idx += 1
            next_shot += PERIOD_MS
            # 落后超过一个周期时跳过错过的时刻，不连拍补齐
            done = time.ticks_diff(time.ticks_ms(), t0)
            while next_shot + PERIOD_MS <= done:
                next_shot += PERIOD_MS
                skipped += 1
            frames = None
            continue            # 存帧的这一轮不刷新屏幕，把时间留给写卡

        for i, img in enumerate(frames):
            canvas.draw_image(img, PANE_X[i], pane_y)
        frames = None
        canvas.draw_rectangle(0, 0, DISPLAY_W, 24, color=(0, 0, 0), fill=True)
        canvas.draw_string_advanced(4, 2, 18, "REC %d/%d" % (shot_idx, DURATION_MS // PERIOD_MS),
                                    color=(255, 0, 0))
        canvas.draw_string_advanced(DISPLAY_W - 120, 2, 18, "%.1f s" % (now / 1000), color=(0, 255, 0))
        Display.show_image(canvas)

    elapsed = time.ticks_diff(time.ticks_ms(), t0)
    for f in streams:
        f.close()
    streams = []
    with open(run_dir + "/index.csv", "w") as f:
        f.write("cam,frame,t_ms,offset,length\n")
        for row in index:
            f.write("%d,%d,%d,%d,%d\n" % row)

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
        print("encode+write per shot (2 frames, avg %.1f KB): avg %.1f ms, max %d ms"
              % (avg_kb, sum(write_ms) / len(write_ms), max(write_ms)))
    try:
        st = os.statvfs("/sdcard")   # 本固件返回 bsize=512, frsize=0
        print("TF /sdcard free: %.1f MB" % (st[0] * st[3] / 1048576))
    except Exception as e:
        print("TF free: unknown (%s)" % e)

except KeyboardInterrupt:
    print("user stop, frames saved so far:", len(index))
except BaseException as e:
    print("Exception:", e)
finally:
    for f in streams:
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
