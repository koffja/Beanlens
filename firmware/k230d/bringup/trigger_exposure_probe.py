# BeanLens 掉落触发/曝光标定探针（bring-up 用，未上板验证）
# 目标：正点原子 K230D BOX + CanMV（ATK v1.3-8dd764f）
#
# 用途：drop_capture_dual.py 上板前，先跑本脚本 30 秒，拿到两件东西：
#   1) ROI 帧差分布（空景噪声底）→ 定 TRIG_DELTA / TRIG_STAT
#   2) 曝光阶梯下画面亮度/清晰度 → 定 EXPOSURE_US（掉落防糊的快门值）
#
# 用法：CanMV IDE 运行。空跑 5 秒采基线 → 每 2 秒切一档曝光
#       （4000/6000/8000/12000/16000us）各显示亮度。期间往 ROI 扔豆子测帧差峰值。
# 结束后把打印的 [CAL] 行抄进 drop_capture_dual.py 配置区。
#
# API 来源：camera_manual_exposure_lcd.py（曝光）、image_statistics_info.py（statistics）

import os
import time
from media.sensor import *
from media.display import *
from media.media import *
from machine import Pin, FPIOA

SENSOR_ID = 1
SENSOR_W, SENSOR_H = 1280, 960
SENSOR_FPS = 90
DISPLAY_TYPE = Display.ST7701
DISPLAY_W, DISPLAY_H = 640, 480
EXPOSURE_LADDER = (2000, 4000, 6000, 8000, 12000, 16000)
BASELINE_S = 5
STEP_S = 2
STAT_PROBE_S = 20       # TRIG_STAT 扔豆采样时长
STAT_EVENT_MIN = 4      # |mean-基线| 超过此值才算一次掉落事件的起点
KEY1_GPIO = 35

try:
    fpioa = FPIOA()
    fpioa.set_function(KEY1_GPIO, getattr(FPIOA, "GPIO%d" % KEY1_GPIO))
    key1 = Pin(KEY1_GPIO, Pin.IN, pull=Pin.PULL_UP, drive=7)

    print("open cam")
    sensor = Sensor(id=SENSOR_ID, width=SENSOR_W, height=SENSOR_H, fps=SENSOR_FPS)
    sensor.reset()
    sensor.set_framesize(Sensor.VGA)
    sensor.set_pixformat(Sensor.YUV420SP)
    Display.bind_layer(**sensor.bind_info(), layer=Display.LAYER_VIDEO1)
    sensor.set_framesize(width=SENSOR_W, height=SENSOR_H, chn=CAM_CHN_ID_1)
    sensor.set_pixformat(Sensor.RGB565, chn=CAM_CHN_ID_1)

    Display.init(DISPLAY_TYPE, width=DISPLAY_W, height=DISPLAY_H, to_ide=False, osd_num=1)
    MediaManager.init()
    try:
        sensor.auto_exposure(False)
        rng = sensor.get_exposure_time_range()
        if rng:
            print("[CAL] exposure range: %s..%s us" % (rng[1], rng[0]))
    except Exception as e:
        print("manual exposure unavailable:", e)
    sensor.run()
    time.sleep_ms(500)

    osd = image.Image(DISPLAY_W, DISPLAY_H, image.ARGB8888)
    prev_mean = None
    roi = (640 // 3, 480 // 3, 640 // 3, 480 // 3)   # VGA 中心 1/3

    # 1) 空景基线
    print("[CAL] baseline %d s: keep ROI empty" % BASELINE_S)
    diffs = []
    base_means = []
    t_end = time.ticks_add(time.ticks_ms(), BASELINE_S * 1000)
    while time.ticks_diff(t_end, time.ticks_ms()) > 0:
        os.exitpoint()
        f0 = sensor.snapshot(chn=CAM_CHN_ID_0)
        m1 = f0.get_statistics(roi=roi).mean()
        base_means.append(m1)
        if prev_mean is not None:
            diffs.append(abs(m1 - prev_mean))
        prev_mean = m1
        time.sleep_ms(33)
    baseline = sum(base_means) / len(base_means) if base_means else 0
    if diffs:
        diffs = sorted(diffs)
        n = len(diffs)
        print("[CAL] empty-ROI frame-diff: p50=%.1f p95=%.1f max=%.1f (n=%d)"
              % (diffs[n // 2], diffs[int(n * 0.95)], diffs[-1], n))
        print("[CAL] -> TRIG_DELTA = %d (p95 x 1.5)" % max(2, int(diffs[int(n * 0.95)] * 1.5)))
        bm = sorted(base_means)
        print("[CAL] empty-ROI mean=%.1f spread(p5~p95)=%.1f"
              % (baseline, bm[int(len(bm) * 0.95)] - bm[int(len(bm) * 0.05)]))

    # 2) 曝光阶梯
    for exp in EXPOSURE_LADDER:
        try:
            sensor.exposure(exp)
        except Exception as e:
            print("exposure(%d) failed:" % exp, e)
            continue
        means = []
        sharps = []
        t_end = time.ticks_add(time.ticks_ms(), STEP_S * 1000)
        while time.ticks_diff(t_end, time.ticks_ms()) > 0:
            os.exitpoint()
            if key1.value() == 0:
                raise KeyboardInterrupt
            f0 = sensor.snapshot(chn=CAM_CHN_ID_0)
            st = f0.get_statistics(roi=roi)
            means.append(st.mean())
            # stdev() 是否存在未经核实：没有就不统计清晰度，不报错
            sd = getattr(st, "stdev", None)
            if sd is not None:
                try:
                    sharps.append(sd())
                except Exception:
                    pass
            osd.clear()
            osd.draw_string_advanced(10, 8, 26, "EXP %d us" % exp, color=(0, 255, 0))
            osd.draw_string_advanced(10, 40, 22, "mean %.1f" % (sum(means) / len(means)),
                                     color=(255, 255, 255))
            osd.draw_string_advanced(10, 70, 20, "throw beans into ROI to test diff peak",
                                     color=(255, 255, 0))
            Display.show_image(osd, 0, 0, Display.LAYER_OSD1)
            time.sleep_ms(100)
        if means:
            print("[CAL] exp=%dus  mean=%.1f  stdev=%s  (darker<--  -->brighter)"
                  % (exp, sum(means) / len(means),
                     "%.1f" % (sum(sharps) / len(sharps)) if sharps else "n/a"))

    # 3) TRIG_STAT 采样：停在最后一档曝光，持续往 ROI 里扔豆子，记录 |mean-空景基线| 峰值
    print("[CAL] TRIG_STAT sampling %d s: keep dropping beans through ROI" % STAT_PROBE_S)
    peaks = []
    t_end = time.ticks_add(time.ticks_ms(), STAT_PROBE_S * 1000)
    cur_peak = 0.0
    while time.ticks_diff(t_end, time.ticks_ms()) > 0:
        os.exitpoint()
        if key1.value() == 0:
            raise KeyboardInterrupt
        m1 = sensor.snapshot(chn=CAM_CHN_ID_0).get_statistics(roi=roi).mean()
        dev = abs(m1 - baseline)
        if dev > STAT_EVENT_MIN:
            cur_peak = max(cur_peak, dev)      # 一次掉落事件内取峰值
        elif cur_peak > 0:
            peaks.append(cur_peak)
            cur_peak = 0.0
        time.sleep_ms(33)
    if cur_peak > 0:
        peaks.append(cur_peak)
    if peaks:
        peaks.sort()
        print("[CAL] drop events=%d  peak |mean-base|: min=%.1f p50=%.1f max=%.1f"
              % (len(peaks), peaks[0], peaks[len(peaks) // 2], peaks[-1]))
        print("[CAL] -> TRIG_STAT = %d (min peak x 0.6; must exceed empty spread)"
              % max(2, int(peaks[0] * 0.6)))
    else:
        print("[CAL] no drop events seen (>%d): lower STAT_EVENT_MIN or check ROI/lighting"
              % STAT_EVENT_MIN)

    print("[CAL] done. pick the SHORTEST exposure with acceptable brightness,")
    print("[CAL] then verify no motion blur by dropping a bean at that exposure.")

except KeyboardInterrupt:
    print("user stop")
except BaseException as e:
    import sys
    sys.print_exception(e)
finally:
    try:
        sensor.stop()
    except Exception:
        pass
    try:
        Display.deinit()
    except Exception:
        pass
    os.exitpoint(os.EXITPOINT_ENABLE_SLEEP)
    time.sleep_ms(100)
    try:
        MediaManager.deinit()
    except Exception:
        pass
