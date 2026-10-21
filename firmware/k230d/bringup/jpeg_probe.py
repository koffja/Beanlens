# BeanLens JPEG 存图探测（bring-up 用）
# 目标：正点原子 K230D BOX + CanMV（ATK v1.3-8dd764f）
# 目的：dual_camera_capture.py 在首帧 compressed() 卡死。本脚本从厂商“实验15 拍照实验”的可用配置出发，
#      一次只改一个变量逼近采集脚本，找出卡死条件。
#
# 2026-10-21 已通过（单摄 1280x960@90，DISPLAY_MODE="bind"，编码 chn1，均 5/5）：
#   cam1/cam2 save() → /data；cam2 compressed() → /data、/sdcard；cam2 chn1 320x180 compressed() → /sdcard
#   → JPEG 编码本身可用。剩余嫌疑：双摄、1920x1080@30 传感器模式、chn0 RGB565 软件画布显示并编码 chn0。
#   A 已通过：单摄 cam2 1920x1080@30 bind，chn1 320x180 compressed 5/5，35-51 ms → 传感器模式排除。
#   B 首次：第二路绑 LAYER_VIDEO2 报 "rotation 90/180 only support Display.LAYER_VIDEO1"，已改为第二路不绑显示。
#
# 下一轮建议顺序（每次只改一项，卡死则断电后记下最后一行 "->" 再测下一项）：
#   A. 默认值：单摄、1920x1080@30、bind、编码 chn1 320x180          → 传感器模式
#   B. CAM_IDS=(1, 2)                                              → 双摄（只第一路 chn0 直通显示，第二路只开 chn1）
#   C. CAM_IDS=(2,), SENSOR=1280x960, DISPLAY_MODE="canvas"          → 软件画布显示，编码仍走 chn1
#   D. 在 C 基础上 ENCODE_CHN=0                                     → 直接编码画布显示用的 chn0 帧
#   E. CAM_IDS=(1, 2), SENSOR=1920x1080, canvas, ENCODE_CHN=0        → 即采集脚本原配置，应复现卡死
#   B 第二次：双摄 1920x1080@30 bind，驱动切到 mode 1（offline/多摄），每路 4 x 4149248 B 缓冲，
#     卡在 "shot 0 cam1 snapshot chn1"（尚未编码）。与 capture_test_2_3 的 chn1 卡死一致。
#   双摄卡死追加测试（每次一项）：
#   B2. CAM_IDS=(1, 2), SENSOR_W,SENSOR_H=1280,960, SENSOR_FPS=90   → 缓冲变小是否就不卡（内存/VB 假设）
#   B3. CAM_IDS=(1, 2), RUN_ALL=True（1920x1080）                    → 是否因只 run 了第一个 sensor
#   F（当前默认，决定性测试）：双摄 1280x960@90，chn1 全分辨率 1280x960，镜头前在豆道平面放直尺
#      → 同时回答：双摄全分辨率能否支持、每毫米像素、1280x960 是全视场缩放还是中心截取、坏帧频率。
#      若卡死，只补一次 CHN1_W,CHN1_H=960,720；再不行就改单摄轮流采，不再继续试边界。
#   结果：B2 通过（10/10，131-232 ms/帧）；B3 卡在第二个 run() 之后的建目录 → 只 run 第一个 sensor，
#        双摄用 1280x960@90。dual_camera_capture.py v3 已改为此路径。
# 每一步先打印 "-> 步骤名"，卡死时最后一行就是卡住的位置。
# 只在 OUT_DIR 下新建 probeNNN 目录，不覆盖、不删除已有文件。

import os
import time
from media.sensor import *
from media.display import *
from media.media import *
import image

# ---- 本次测试 ----
CAM_IDS = (1, 2)              # (1,) / (2,) 单摄；(1, 2) 双摄
SENSOR_W, SENSOR_H = 1280, 960    # 双摄只有 1280x960@90 可用；1920x1080 双摄卡死
SENSOR_FPS = 90
DISPLAY_MODE = "bind"         # "bind"：chn0 YUV420SP VGA 直通显示层（实验15）；"canvas"：chn0 RGB565 320x180 snapshot→画布→show_image（采集脚本 v1/v2）
RUN_ALL = False               # 逐个 run() 实测卡死（B3），保持 False
ENCODE_CHN = 1                # 1：编码 chn1；0：编码 chn0 帧（仅 canvas 模式）
CHN1_W, CHN1_H = 1280, 960    # 全分辨率：单豆需约 180 px（训练裁图长边 224 含 12% 余量），不能整帧缩小
ENCODE = "compressed"         # "save"：img.save("x.jpg")；"compressed"：img.compressed().bytearray() 再写文件
JPEG_QUALITY = 90             # 仅 compressed 用
OUT_DIR = "/sdcard/beanlens_probe"
SHOTS = 10                    # 每路 10 帧，顺便统计坏帧
SHOT_GAP_MS = 500

PANE_W, PANE_H = 320, 180     # canvas 模式每路画面尺寸，与采集脚本一致
DISPLAY_W, DISPLAY_H = 640, 480


def step(name):
    print("-> " + name)


def exists(path):
    try:
        os.stat(path)
        return True
    except OSError:
        return False


def open_sensor(i, cam_id):
    step("open camera id=%d" % cam_id)
    s = Sensor(id=cam_id, width=SENSOR_W, height=SENSOR_H, fps=SENSOR_FPS)
    s.reset()
    if DISPLAY_MODE == "bind" and i == 0:
        step("cam%d chn0 YUV420SP 640x480 -> bind LAYER_VIDEO1" % cam_id)
        s.set_framesize(Sensor.VGA)
        s.set_pixformat(Sensor.YUV420SP)
        Display.bind_layer(**s.bind_info(), layer=Display.LAYER_VIDEO1)
    elif DISPLAY_MODE == "bind":
        # ST7701 需要旋转，只有 LAYER_VIDEO1 支持旋转绑定（2026-10-21 实测 LAYER_VIDEO2 报错）
        step("cam%d chn0 not configured (only LAYER_VIDEO1 can bind with rotation)" % cam_id)
    else:
        step("cam%d chn0 RGB565 %dx%d (canvas)" % (cam_id, PANE_W, PANE_H))
        s.set_framesize(width=PANE_W, height=PANE_H, chn=CAM_CHN_ID_0)
        s.set_pixformat(Sensor.RGB565, chn=CAM_CHN_ID_0)
    if ENCODE_CHN == 1:
        step("cam%d chn1 RGB565 %dx%d" % (cam_id, CHN1_W, CHN1_H))
        s.set_framesize(width=CHN1_W, height=CHN1_H, chn=CAM_CHN_ID_1)
        s.set_pixformat(Sensor.RGB565, chn=CAM_CHN_ID_1)
    return s


def encode_to(img, path):
    if ENCODE == "save":
        img.save(path)
    else:
        data = img.compressed(quality=JPEG_QUALITY).bytearray()
        with open(path, "wb") as f:
            f.write(data)


sensors = []
try:
    if ENCODE_CHN == 0 and DISPLAY_MODE != "canvas":
        raise ValueError("ENCODE_CHN=0 requires DISPLAY_MODE='canvas' (bind mode chn0 is YUV420SP)")
    print("probe: cams=%s sensor=%dx%d@%d run_all=%s display=%s encode=%s chn%d %s out=%s"
          % (CAM_IDS, SENSOR_W, SENSOR_H, SENSOR_FPS, RUN_ALL, DISPLAY_MODE, ENCODE, ENCODE_CHN,
             "%dx%d" % ((CHN1_W, CHN1_H) if ENCODE_CHN == 1 else (PANE_W, PANE_H)), OUT_DIR))
    for i, cid in enumerate(CAM_IDS):
        sensors.append(open_sensor(i, cid))

    step("Display.init")
    Display.init(Display.ST7701, width=DISPLAY_W, height=DISPLAY_H, to_ide=False)
    step("MediaManager.init")
    MediaManager.init()
    if RUN_ALL:
        for i, s in enumerate(sensors):
            step("sensor run cam%d" % CAM_IDS[i])
            s.run()
    else:
        step("sensor run (first only)")
        sensors[0].run()
    time.sleep_ms(500)        # 等自动曝光稳定一点

    canvas = None
    if DISPLAY_MODE == "canvas":
        canvas = image.Image(DISPLAY_W, DISPLAY_H, image.RGB565)
        canvas.clear()
    pane_y = (DISPLAY_H - PANE_H) // 2

    step("create out dir")
    if not exists(OUT_DIR):
        os.mkdir(OUT_DIR)
    n = 0
    while exists("%s/probe%03d" % (OUT_DIR, n)):
        n += 1
    run_dir = "%s/probe%03d" % (OUT_DIR, n)
    os.mkdir(run_dir)
    with open(run_dir + "/meta.txt", "w") as f:
        f.write("cams=%s\nsensor=%dx%d@%d\ndisplay=%s\nencode=%s\nencode_chn=%d\nchn1=%dx%d\n"
                % (",".join(str(c) for c in CAM_IDS), SENSOR_W, SENSOR_H, SENSOR_FPS,
                   DISPLAY_MODE, ENCODE, ENCODE_CHN, CHN1_W, CHN1_H))
    print("output dir:", run_dir)

    results = []
    for k in range(SHOTS):
        os.exitpoint()
        for i, s in enumerate(sensors):
            cid = CAM_IDS[i]
            frame0 = None
            if canvas is not None:
                step("shot %d cam%d snapshot chn0 -> canvas" % (k, cid))
                frame0 = s.snapshot(chn=CAM_CHN_ID_0)
                canvas.draw_image(frame0, i * PANE_W, pane_y)
            if ENCODE_CHN == 1:
                step("shot %d cam%d snapshot chn1" % (k, cid))
                img = s.snapshot(chn=CAM_CHN_ID_1)
            else:
                img = frame0
            path = "%s/cam%d_shot%02d.jpg" % (run_dir, cid, k)
            step("shot %d cam%d %s" % (k, cid, ENCODE))
            t = time.ticks_ms()
            encode_to(img, path)
            dt = time.ticks_diff(time.ticks_ms(), t)
            img = None
            frame0 = None
            size = os.stat(path)[6]
            results.append((cid, k, dt, size))
            print("  ok %s %d B in %d ms" % (path, size, dt))
        if canvas is not None:
            step("shot %d show canvas" % k)
            Display.show_image(canvas)
        time.sleep_ms(SHOT_GAP_MS)

    print("---- summary ----")
    for r in results:
        print("cam%d shot%02d  %4d ms  %d B" % r)
    print("JPEG %s works: %d/%d" % (ENCODE, len(results), SHOTS * len(CAM_IDS)))

except KeyboardInterrupt:
    print("user stop")
except BaseException as e:
    print("Exception:", e)
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
