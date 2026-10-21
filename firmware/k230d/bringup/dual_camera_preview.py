# BeanLens 双摄预览（bring-up 用，未上板验证）
# 目标：正点原子 K230D BOX + CanMV（ATK v1.x，基于 CanMV K230 media API）
# 功能：同时打开两路 GC2093，左半屏显示相机 A，右半屏显示相机 B。
# 用法：CanMV IDE 连接板卡 → 打开本文件 → 运行；IDE 帧缓冲与 LCD 同时显示。

import os
import time
import image
from media.sensor import *
from media.display import *
from media.media import *

# ---- 需按实机核对的参数 ----
CAM_IDS = (1, 2)              # BOX 两个摄像头所在 CSI 编号；若某路打不开，先试 (0, 1) / (0, 2)
SENSOR_W, SENSOR_H = 1920, 1080   # GC2093 原生 16:9
DISPLAY_TYPE = Display.ST7701  # BOX 自带 MIPI 屏；只想看 IDE 预览可改为 Display.VIRT
DISPLAY_W, DISPLAY_H = 640, 480
PANE_W, PANE_H = 320, 180     # 每路画面尺寸，保持 16:9 不变形；宽度须 16 对齐
FPS = 30

pane_y = (DISPLAY_H - PANE_H) // 2
PANE_X = (0, DISPLAY_W // 2)  # 左、右起点


def open_sensor(cam_id):
    s = Sensor(id=cam_id, width=SENSOR_W, height=SENSOR_H, fps=FPS)
    s.reset()
    s.set_framesize(width=PANE_W, height=PANE_H, chn=CAM_CHN_ID_0)
    s.set_pixformat(Sensor.RGB565, chn=CAM_CHN_ID_0)
    return s


sensors = []
try:
    for cid in CAM_IDS:
        try:
            sensors.append(open_sensor(cid))
            print("camera id=%d opened" % cid)
        except Exception as e:
            raise RuntimeError("camera id=%d open failed: %s" % (cid, e))

    Display.init(DISPLAY_TYPE, width=DISPLAY_W, height=DISPLAY_H, to_ide=True)
    MediaManager.init()
    # 多摄场景只需在其中一个 sensor 上调用一次 run()
    sensors[0].run()

    canvas = image.Image(DISPLAY_W, DISPLAY_H, image.RGB565)
    canvas.clear()
    clock = time.clock()

    while True:
        os.exitpoint()
        clock.tick()
        for i, s in enumerate(sensors):
            frame = s.snapshot(chn=CAM_CHN_ID_0)
            canvas.draw_image(frame, PANE_X[i], pane_y)
            # snapshot 缓冲由运行时回收，这里不长期持有 frame
        canvas.draw_rectangle(0, 0, DISPLAY_W, 24, color=(0, 0, 0), fill=True)
        canvas.draw_string_advanced(4, 2, 18, "CAM%d" % CAM_IDS[0], color=(255, 255, 0))
        canvas.draw_string_advanced(DISPLAY_W // 2 + 4, 2, 18, "CAM%d" % CAM_IDS[1], color=(255, 255, 0))
        canvas.draw_string_advanced(DISPLAY_W - 110, 2, 18, "%.1f fps" % clock.fps(), color=(0, 255, 0))
        Display.show_image(canvas)

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
