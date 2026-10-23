#####################################################################################################
# BeanLens BRINGUP 预热：摄像头实时预览（BOX 主屏 ST7701 + IDE 帧缓冲双显示）
#
# API 依据：资料盘《标准例程-CanMV版/图像类实验例程/实验1 image元素绘制实验》
#          （正点原子 K230D BOX，CanMV v1.2/v1.3 固件配套例程，非泛化 K230 写法）
#
# 操作：确认 CSI 摄像头排线已接 → CanMV IDE 打开本脚本 → 点击“运行”
# 预期：1) 板载主屏出现实时画面，左上角绿色 "BeanLens fps=N"
#      2) IDE 左侧“帧缓冲区”同步显示同一画面
#      3) IDE 底部串口终端每秒打印一次 fps；几十 fps 属正常
# 失败：sensor.reset() 报错多为摄像头排线未接/未识别；停止请点 IDE“停止”按钮
#      （脚本走 finally 释放媒体资源），不要反复直接断电。
#####################################################################################################

import time, os, sys
from media.sensor import *   # 摄像头接口
from media.display import *  # 显示接口
from media.media import *    # 媒体缓冲管理

sensor = None
try:
    sensor = Sensor(width=1280, height=960)  # 构建摄像头对象（与官方例程参数一致）
    sensor.reset()                           # 复位并初始化摄像头

    sensor.set_framesize(Sensor.VGA)      # 输出 640x480，后续裁单豆图也够用
    sensor.set_pixformat(Sensor.RGB565)   # RGB565：image 对象可直接绘制和做算法

    # ST7701 = BOX 主屏；to_ide=True 同时把画面送入 IDE 帧缓冲区
    Display.init(Display.ST7701, width=640, height=480, to_ide=True)
    MediaManager.init()  # 初始化媒体缓冲（VB 内存池，必须在 sensor.run 之前）
    sensor.run()         # 开始出图

    count = 0
    fps = 0
    last = time.ticks_ms()
    while True:
        os.exitpoint()            # 响应 IDE 的停止/中断
        img = sensor.snapshot()   # 取一帧。BeanLens 以后在这行之后接裁图和 KPU 推理
        count += 1
        if time.ticks_diff(time.ticks_ms(), last) >= 1000:
            fps = count
            count = 0
            last = time.ticks_ms()
            print("fps:", fps)    # 串口终端同步打印
        img.draw_string_advanced(8, 8, 28, "BeanLens  fps=" + str(fps), color=(0, 255, 0))
        Display.show_image(img)   # 送主屏 + IDE 帧缓冲

except KeyboardInterrupt as e:
    print("user stop:", e)
except BaseException as e:
    print(f"Exception {e}")
finally:
    if isinstance(sensor, Sensor):
        sensor.stop()             # 停摄像头
    Display.deinit()              # 释放显示
    os.exitpoint(os.EXITPOINT_ENABLE_SLEEP)
    time.sleep_ms(100)
    MediaManager.deinit()         # 释放媒体缓冲
