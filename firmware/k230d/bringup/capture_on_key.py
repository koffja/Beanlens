# BeanLens 屏幕按钮拍照（bring-up 用，单摄）
# 目标：正点原子 K230D BOX + CanMV（ATK v1.3-8dd764f）
#
# 两个界面（都是触摸操作，叠加在相机实时预览上）：
#   1) 选类界面：17 个类别排成网格，点一个就进入拍摄。启动时先显示这个界面。
#   2) 拍摄界面：左上显示当前类别、豆号、张号；右下 [SHOT] 拍照；左下 [CLASS] 回到选类界面。
#      选定类别后一直拍这一类，不用每次重选，换类才点 CLASS 重新选。
#   物理键（触摸不灵时备用）：KEY0 = 拍照；KEY1 = 在选类/拍摄界面间切换。
#   退出：在 CanMV IDE 点停止。
#
# 保存：<OUT_ROOT>/<类别>/<类别>_<豆号4位>_<第几张2位>.jpg，1280x960 全帧。
#   不同类别存进不同目录、文件名带类别名；豆号接着已有文件往后排，不会覆盖。
#   同一颗豆拍 SHOTS_PER_BEAN 张（默认 2：正面、翻面），拍满后豆号自动 +1。
#   豆号用于后期按"实物豆"划分训练/验证/测试，同一颗豆的几张照片不会跨集合（scripts/build_board_crops.py）。
#   离开某一类时，没拍满的那颗豆算结束，下次回到该类从新豆号开始；
#   只进选类界面又原样返回（BACK），不截断当前豆。
#   拍照保存约 0.3~2.5 s（encode+写盘），期间的手指按下会在保存完成后的下一轮才被读到——
#   tp.read 返回当前状态不是事件队列，这不是触摸失灵。
#   黄框是 480x480 传感器像素的中心取景框（与 kmodel_live_classify.py 的 CROP_SIDE 一致），
#   只用于摆位；保存的是整帧，后期再裁。
#
# API 来源（均为厂商/IDE 自带例程，非凭印象）：
#   按键          资料盘 实验3/15：FPIOA.set_function + Pin(..., drive=7)
#   预览/拍照     资料盘 实验15、IDE 17-Sensor/camera_snapshot_and_save.py
#   触摸          IDE 03-Machine/display_and_touch.py：TOUCH(0).read(1)，点有 .x .y .event
#   叠加层        IDE 21-AI-With-Others/ai_save_mp4.py、lvgl_with_sensor.py：
#                 Display.init(..., osd_num=1) + Display.show_image(img, 0, 0, Display.LAYER_OSD1)
#   JPEG 编码     dual_camera_capture.py（已上板）：img.compressed(quality=).bytearray()
#
# 未上板验证：bind_layer 预览 + OSD1 叠加层 + chn1 snapshot 三者同时工作；触摸坐标是否就是
# 640x480 屏幕坐标；网格里文字是否放得下。
# 若叠加层不显示或预览卡住，把 USE_OVERLAY 改 False：没有界面，KEY0 拍照，KEY1 循环切类。

import gc
import os
import time
from media.sensor import *
from media.display import *
from media.media import *
from machine import Pin, FPIOA, TOUCH

# ===== 配置 =====
# 与 scripts/build_mydata.py 的 CLASSES 保持一致（含 normal），目录可直接拷成 mydata/<类别>/
CATEGORIES = [
    "normal", "full_black", "partial_black", "full_sour", "partial_sour",
    "fungus", "severe_insect_damage", "broken", "cut", "immature",
    "withered", "fade", "shell", "husk", "parchment", "dry_cherry", "floater",
]
SHORT_NAME = {"severe_insect_damage": "severe_insect"}   # 只影响屏幕显示，文件名仍用全名
SENSOR_ID = 1
SENSOR_W, SENSOR_H = 1280, 960      # 单摄已验证；chn1 保持 4:3，16:9 会压扁
SENSOR_FPS = 90
DISPLAY_TYPE = Display.ST7701
DISPLAY_W, DISPLAY_H = 640, 480
JPEG_QUALITY = 95
SHOTS_PER_BEAN = 2                  # 每颗豆拍几张（正面、翻面）；拍满后豆号 +1
CROP_SIDE = 480                     # 中心取景框边长（传感器像素）
OUT_ROOTS = ("/data/beanlens/samples", "/sdcard/beanlens/samples")   # 先试 /data（空间大），失败退回 /sdcard
KEY0_GPIO, KEY1_GPIO = 34, 35       # KEY2 是 GPIO0（启动模式），不要用
USE_OVERLAY = True
STATUS_MS = 1500
# 拍摄界面按钮 (x, y, w, h)，屏幕 640x480
BTN_CLASS = (10, 390, 190, 80)
BTN_SHOT = (430, 390, 200, 80)
# 选类网格：3 列 x 6 行 = 18 格，17 类占前 17 格，最后一格是 BACK
GRID_COLS, GRID_ROWS = 3, 6
GRID_X0, GRID_Y0, GRID_GAP = 8, 40, 6
CELL_W = (DISPLAY_W - 2 * GRID_X0 - (GRID_COLS - 1) * GRID_GAP) // GRID_COLS
CELL_H = (DISPLAY_H - GRID_Y0 - 6 - (GRID_ROWS - 1) * GRID_GAP) // GRID_ROWS
# =================

if len(CATEGORIES) > GRID_COLS * GRID_ROWS - 1:
    raise ValueError("categories do not fit the grid (need one spare cell for BACK)")


def step(name):
    print("-> " + name)


def exists(path):
    try:
        os.stat(path)
        return True
    except OSError:
        return False


def mkdir_p(path):
    cur = ""
    for part in path.strip("/").split("/"):
        cur += "/" + part
        if not exists(cur):
            os.mkdir(cur)


def sync_fs():
    f = getattr(os, "sync", None)
    if f is not None:
        try:
            f()
        except Exception:
            pass


def pick_root():
    for root in OUT_ROOTS:
        try:
            mkdir_p(root)
            probe = root + "/.probe"
            with open(probe, "w") as f:
                f.write("1")
            os.remove(probe)
            return root
        except Exception as e:
            print("root unusable:", root, e)
    raise RuntimeError("no writable output dir")


def scan_class(root, cat):
    # 扫描已有 <cat>_<豆号4位>_<张号2位>.jpg，返回 (已有张数, 下一个可用豆号)
    d = root + "/" + cat
    if not exists(d):
        return 0, 1
    top = 0
    n = 0
    prefix = cat + "_"
    for name in os.listdir(d):
        if name.startswith(prefix) and name.endswith(".jpg"):
            parts = name[len(prefix):-4].split("_")
            if len(parts) == 2:
                try:
                    top = max(top, int(parts[0]))
                    n += 1
                except ValueError:
                    pass
    return n, top + 1


def hit(btn, x, y):
    return btn[0] <= x < btn[0] + btn[2] and btn[1] <= y < btn[1] + btn[3]


def cell_rect(i):
    col = i % GRID_COLS
    row = i // GRID_COLS
    return (GRID_X0 + col * (CELL_W + GRID_GAP), GRID_Y0 + row * (CELL_H + GRID_GAP), CELL_W, CELL_H)


def draw_button(osd, btn, label, color):
    osd.draw_rectangle(btn[0], btn[1], btn[2], btn[3], color=color, thickness=2, fill=True)
    osd.draw_string_advanced(btn[0] + 18, btn[1] + 22, 34, label, color=(255, 255, 255))


def draw_picker(osd, cur, counts, bean_no):
    # 选类界面：整屏不透明深色底（盖住预览），17 个类别按钮 + 可选的 BACK
    osd.clear()
    osd.draw_rectangle(0, 0, DISPLAY_W, DISPLAY_H, color=(15, 15, 15), thickness=1, fill=True)
    osd.draw_string_advanced(10, 6, 24, "Tap a class to start shooting", color=(255, 255, 255))
    for i, c in enumerate(CATEGORIES):
        x, y, w, h = cell_rect(i)
        color = (30, 120, 60) if i == cur else (55, 55, 55)
        osd.draw_rectangle(x, y, w, h, color=color, thickness=2, fill=True)
        osd.draw_string_advanced(x + 8, y + 6, 22, SHORT_NAME.get(c, c), color=(255, 255, 255))
        n = counts[i]
        osd.draw_string_advanced(x + 8, y + 38, 20, "%d img  %d bean" % (n, bean_no[i] - 1),
                                 color=(210, 210, 210) if n else (120, 120, 120))
    if cur is not None:
        x, y, w, h = cell_rect(len(CATEGORIES))
        osd.draw_rectangle(x, y, w, h, color=(40, 90, 160), thickness=2, fill=True)
        osd.draw_string_advanced(x + 8, y + 18, 28, "BACK", color=(255, 255, 255))


def draw_ui(osd, crop, cat, n_cat, total, bean, shot, status):
    # 拍摄界面：透明叠加层，只画取景框、文字和两个按钮
    osd.clear()
    osd.draw_rectangle(crop[0], crop[1], crop[2], crop[3], color=(255, 255, 0), thickness=2, fill=False)
    osd.draw_string_advanced(10, 8, 30, cat, color=(0, 255, 0))
    osd.draw_string_advanced(10, 46, 22, "bean %d  shot %d/%d   class %d  total %d"
                             % (bean, shot, SHOTS_PER_BEAN, n_cat, total), color=(255, 255, 255))
    if status:
        osd.draw_string_advanced(10, 350, 24, status, color=(255, 255, 0))
    draw_button(osd, BTN_CLASS, "CLASS", (40, 90, 160))
    draw_button(osd, BTN_SHOT, "SHOT", (190, 40, 40))


def save_shot(sensor, root, cat, bean, shot):
    t0 = time.ticks_ms()
    img = sensor.snapshot(chn=CAM_CHN_ID_1)
    data = img.compressed(quality=JPEG_QUALITY).bytearray()
    d = root + "/" + cat
    if not exists(d):
        mkdir_p(d)
    path = "%s/%s_%04d_%02d.jpg" % (d, cat, bean, shot)
    if exists(path):
        raise OSError("refuse to overwrite " + path)
    with open(path, "wb") as f:
        f.write(data)
    sync_fs()
    ms = time.ticks_diff(time.ticks_ms(), t0)
    kb = len(data) // 1024
    img = None
    data = None
    gc.collect()
    return path, kb, ms


def main():
    os.exitpoint(os.EXITPOINT_ENABLE)

    fpioa = FPIOA()
    fpioa.set_function(KEY0_GPIO, getattr(FPIOA, "GPIO%d" % KEY0_GPIO))
    fpioa.set_function(KEY1_GPIO, getattr(FPIOA, "GPIO%d" % KEY1_GPIO))
    key0 = Pin(KEY0_GPIO, Pin.IN, pull=Pin.PULL_UP, drive=7)
    key1 = Pin(KEY1_GPIO, Pin.IN, pull=Pin.PULL_UP, drive=7)
    # 触摸初始化失败不致命：置 None 后走纯物理键模式（KEY0 拍照 / KEY1 切换）
    try:
        tp = TOUCH(0)
    except Exception as e:
        print("touch init failed (use KEY0/KEY1):", e)
        tp = None

    root = pick_root()
    print("output root:", root)
    # 剩余空间提示（q95 全帧约 200KB+/张，SD 将满时提前发现）
    for vol in ("/data", "/sdcard"):
        try:
            st = os.statvfs(vol)
            if st[3] > 0:
                print("%s free: %.1f MB" % (vol, st[0] * st[3] / 1048576))
        except Exception:
            pass
    scanned = [scan_class(root, c) for c in CATEGORIES]
    counts = [s[0] for s in scanned]        # 每类已有张数
    bean_no = [s[1] for s in scanned]       # 每类当前豆号
    shot_no = [1] * len(CATEGORIES)         # 当前这颗豆的第几张
    try:
        with open(root + "/capture_params.txt", "w") as f:
            f.write("sensor=%dx%d@%d csi%d\nformat=RGB565 chn1 -> jpeg q%d\ncrop_side_sensor_px=%d\n"
                    % (SENSOR_W, SENSOR_H, SENSOR_FPS, SENSOR_ID, JPEG_QUALITY, CROP_SIDE))
    except Exception as e:
        print("params file skipped:", e)

    sensor = None
    try:
        step("init sensor csi%d" % SENSOR_ID)
        sensor = Sensor(id=SENSOR_ID, width=SENSOR_W, height=SENSOR_H, fps=SENSOR_FPS)
        sensor.reset()
        sensor.set_framesize(Sensor.VGA)
        sensor.set_pixformat(Sensor.YUV420SP)
        Display.bind_layer(**sensor.bind_info(), layer=Display.LAYER_VIDEO1)
        sensor.set_framesize(width=SENSOR_W, height=SENSOR_H, chn=CAM_CHN_ID_1)
        sensor.set_pixformat(Sensor.RGB565, chn=CAM_CHN_ID_1)

        step("init display")
        Display.init(DISPLAY_TYPE, width=DISPLAY_W, height=DISPLAY_H, to_ide=False, osd_num=1)
        step("MediaManager.init")
        MediaManager.init()
        sensor.run()
        time.sleep_ms(500)
        sensor.snapshot(chn=CAM_CHN_ID_1)    # 预热一帧

        side = min(CROP_SIDE, SENSOR_W, SENSOR_H)
        sx, sy = DISPLAY_W / SENSOR_W, DISPLAY_H / SENSOR_H
        crop = (int((SENSOR_W - side) // 2 * sx), int((SENSOR_H - side) // 2 * sy),
                int(side * sx), int(side * sy))
        osd = image.Image(DISPLAY_W, DISPLAY_H, image.ARGB8888) if USE_OVERLAY else None

        # 有界面：先选类再拍，避免拍进错的类；无界面：默认第一类，KEY1 循环切类
        if osd is not None:
            mode, cat_idx = "pick", None
            print("ready. tap a class on screen, then SHOT / KEY0 to capture")
        else:
            mode, cat_idx = "shoot", 0
            print("ready (no overlay). KEY0 = capture, KEY1 = next class; class:", CATEGORIES[0])
        status = ""
        status_until = time.ticks_ms()
        dirty = True
        touch_down = False
        touch_err = 0
        k0_prev = k1_prev = False

        def leave_class(i):
            # 离开一类前：这颗豆没拍满也算结束，下次换新豆号
            if i is not None and shot_no[i] > 1:
                bean_no[i] += 1
                shot_no[i] = 1

        while True:
            os.exitpoint()
            now = time.ticks_ms()
            act = None
            arg = None

            # 触摸：只在按下的上升沿触发；换界面那一下手指还按着，不会连带触发新界面里的按钮。
            # tp 为 None（初始化失败）时跳过；tp.read 偶发异常按"本帧无触摸"处理，不中断采集。
            # 只认 EVENT_DOWN / EVENT_MOVE。event 的数值语义未上板确认，不要加 == 0 假设。
            pressed = False
            px = py = 0
            if tp is not None:
                try:
                    pts = tp.read(1)
                except Exception as te:
                    if touch_err == 0:
                        print("touch read error (ignored, keys still work):", te)
                    touch_err += 1
                    pts = []
                if len(pts):
                    p = pts[0]
                    if p.event == TOUCH.EVENT_DOWN or p.event == TOUCH.EVENT_MOVE:
                        pressed = True
                        px, py = p.x, p.y
            if pressed and not touch_down:
                if mode == "shoot":
                    if hit(BTN_SHOT, px, py):
                        act = "shot"
                    elif hit(BTN_CLASS, px, py):
                        act = "picker"
                else:
                    for i in range(len(CATEGORIES)):
                        if hit(cell_rect(i), px, py):
                            act = "pick"
                            arg = i
                            break
                    else:
                        if cat_idx is not None and hit(cell_rect(len(CATEGORIES)), px, py):
                            act = "back"
            touch_down = pressed

            # 物理键：上升沿 + 简单去抖
            k0 = key0.value() == 0
            k1 = key1.value() == 0
            if k0 and not k0_prev:
                time.sleep_ms(20)
                if key0.value() == 0 and mode == "shoot":
                    act = "shot"
            if k1 and not k1_prev:
                time.sleep_ms(20)
                if key1.value() == 0:
                    if osd is None:
                        act = "cycle"
                    elif mode == "shoot":
                        act = "picker"
                    elif cat_idx is not None:
                        act = "back"
            k0_prev, k1_prev = k0, k1

            if act == "picker":
                mode = "pick"
                dirty = True
            elif act == "back":
                # 返回原类不算换类：豆没拍满也不断号，接着这颗拍
                mode = "shoot"
                dirty = True
            elif act == "pick":
                if cat_idx != arg:
                    leave_class(cat_idx)   # 只在真正换了类时结束当前豆
                cat_idx = arg
                mode = "shoot"
                status = "class: " + CATEGORIES[cat_idx]
                status_until = time.ticks_add(now, STATUS_MS)
                print("class ->", CATEGORIES[cat_idx])
                dirty = True
            elif act == "cycle":
                leave_class(cat_idx)
                cat_idx = (cat_idx + 1) % len(CATEGORIES)
                print("class ->", CATEGORIES[cat_idx])
            elif act == "shot" and cat_idx is not None:
                cat = CATEGORIES[cat_idx]
                try:
                    path, kb, ms = save_shot(sensor, root, cat, bean_no[cat_idx], shot_no[cat_idx])
                    counts[cat_idx] += 1
                    status = "saved bean %d shot %d  %dKB %dms" % (bean_no[cat_idx], shot_no[cat_idx], kb, ms)
                    shot_no[cat_idx] += 1
                    if shot_no[cat_idx] > SHOTS_PER_BEAN:
                        bean_no[cat_idx] += 1
                        shot_no[cat_idx] = 1
                    print("[%d] %s  %d KB  %d ms" % (sum(counts), path, kb, ms))
                except Exception as e:
                    status = "SAVE FAIL"
                    print("save failed:", e)
                status_until = time.ticks_add(time.ticks_ms(), STATUS_MS)
                dirty = True

            if status and time.ticks_diff(now, status_until) > 0:
                status = ""
                dirty = True

            if osd is not None and dirty:
                if mode == "pick":
                    draw_picker(osd, cat_idx, counts, bean_no)
                else:
                    draw_ui(osd, crop, CATEGORIES[cat_idx], counts[cat_idx], sum(counts),
                            bean_no[cat_idx], shot_no[cat_idx], status)
                Display.show_image(osd, 0, 0, Display.LAYER_OSD1)
                dirty = False
            time.sleep_ms(20)

    except KeyboardInterrupt:
        print("user stop")
    except BaseException as e:
        import sys
        sys.print_exception(e)
    finally:
        print("---- summary ----")
        print("total in this root: %d" % sum(counts))
        for c, n in zip(CATEGORIES, counts):
            if n:
                print("  %s: %d" % (c, n))
        if isinstance(sensor, Sensor):
            try:
                sensor.stop()
            except Exception as e:
                print("sensor.stop error:", e)
        try:
            Display.deinit()
        except Exception as e:
            print("Display.deinit error:", e)
        os.exitpoint(os.EXITPOINT_ENABLE_SLEEP)
        time.sleep_ms(100)
        try:
            MediaManager.deinit()
        except Exception as e:
            print("MediaManager.deinit error:", e)


main()
gc.collect()
