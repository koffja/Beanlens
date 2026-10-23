# BeanLens 双摄掉落触发采集（bring-up 用，未上板验证）
# 目标：正点原子 K230D BOX + CanMV（ATK v1.3-8dd764f）
#
# 场景：H3 机型的拍摄模式——两台 GC2093 水平对摄，豆子从上方落入视野，
#       落速已机械减慢。本脚本负责：监视→触发→双摄同拍→存整帧+自动框→写YOLO sidecar。
#
# 产出（与 capture_on_key.py 静止摆拍线互补）：
#   <root>/drop_<NNN>/cam<id>_<seq:04d>.jpg + 同名 .txt（YOLO 归一化框，class 恒为 0）
#   <root>/drop_<NNN>/meta.txt
# drop_<NNN> 递增不覆盖；同一颗豆的 A/B 面靠 seq 配对（cam1_seq0007 ↔ cam2_seq0007）。
# 类别标注留到主机侧（build_board_crops.py 思路），板端不猜类别。
#
# 触发状态机（级联防误触 + 防重触发）：
#   IDLE: ROI 帧差小 → 持续刷新空景基线（rolling mean）
#   ARM:  连续 ARM_HOLD_FRAMES 帧 ROI 帧差 > TRIG_DELTA → 武装，记基线
#   FIRE: 武装后 get_statistics(roi) 亮度均值 vs 空景差 > TRIG_STAT → 双摄同帧快照
#   COOL: 冷却 COOLDOWN_MS 且 ROI 安静 ROI_QUIET_MS → 回 IDLE
#   KEY1(GPIO35) 随时退出并打印统计；手动补拍留 KEY0，未实现（IDE 停止即可重拍）。
#
# 快门策略（先预判，上板按序校准）：
#   掉落防糊靠"短曝光冻结"，不靠帧率：EXPOSURE_US 从 4000us 起调，
#   光不足就加补光/增益，而不是加长曝光。两摄曝光参数一致，同帧拍=同一时刻同一豆位。
#
# 自动画框（存 YOLO sidecar，主机验证过可行性）：
#   灰度多级阈值反阈值找最大 blob 为主（非真 Otsu，MicroPython 无直方图/Otsu API，
#   用"均值±偏移"多档阈值链模拟自适应，见 largest_bean_box），HSV 饱和度阈值兜底
#   （v2 数据集 80% IoU>=0.5）留主机端复核脚本，板上不做。框误检时主机删 .txt
#   即可，jpg 不受影响。
#
# API 来源（厂商/IDE 例程，非凭印象）：
#   双摄构造/仅首个 run      dual_camera_capture.py（已上板）
#   sensor.exposure(us) / auto_exposure(False) / get_exposure_time_range
#                           IDE 17-Sensor/camera_manual_exposure_lcd.py（未逐字核对签名）
#   img.get_statistics(roi=) IDE 09-Color-Tracking/image_statistics_info.py（未逐字核对签名）
#   img.find_blobs([...])    IDE 09-Color-Tracking（pixels_threshold/area_threshold/merge）
#   叠加层/触摸              同 capture_on_key.py
#
# 代码审查后修正（2026-10-23，requesting-code-review 子代理发现）：
#   1. [严重] save_pair 原先对每路相机串行执行"snapshot+encode+写盘"，
#      实测同类负载（dual_camera_capture.py 记录）单摄 encode+写盘约 0.32s，
#      双摄合计 1.5-2.5s，而非设计时假设的 ~11ms。两次 snapshot 中间隔着整段
#      编码写盘，豆子早已继续下落，A/B 面配对的物理意义被破坏。
#      修正：save_pair 先连续拿完两路 snapshot，再统一编码写盘；用 ticks_us
#      测量两次 snapshot 间的真实间隔并写入 meta/打印，不再假设数值。
#   2. [严重] ARM→FIRE 原先只看"当前这一帧"的亮度偏离，没有窗口累积也没有
#      超时，可能因单帧漏采而错过触发，也可能因长时间处于阈值边界卡死在 ARM。
#      修正：加 ARM_TIMEOUT_MS 强制回落 IDLE；FIRE 判据保留但状态转移前打印
#      诊断，避免悄悄卡死。
#   3. [中] largest_otsu_box 阈值窗固定 35 级且命名为"otsu"实际只是均值偏移，
#      对光照/豆色适应性差，遇到命中不了的场景直接整图无框。
#      修正：改名 largest_bean_box，用多档阈值链（窄→宽）逐级尝试，命中即停。
#   4. [中] 无清晰度判据，短曝光是否真的冻住运动完全没有量化验证，糊片会被
#      当正常样本存下。
#      修正：save_pair 存图后用 get_statistics().stdev() 做清晰度粗代理
#      （若固件没有 stdev() 则该函数返回 None，自动跳过检测而不报错），
#      以前 5 对样本的中位数为基准，显著低于基准时记入 drop_NNN/blur.txt 供主机筛查
#      （sidecar 必须与 jpg 同名才能被 YOLO 配对，所以不改文件名）。
#   5. [低] gc.collect() 原先放在 save_pair 循环内部，每拍一张图都做一次全量
#      GC，GC 停顿时间不确定会进一步放大两路相机的同步误差。
#      修正：挪到两路图都抓完、编码写盘都结束之后统一调用一次。
#   未上板验证：级联触发的实际误触/漏触率；两 CSI 摄像头 sensor.exposure 是否各自生效；
# chn0(帧差,320x180) 与 chn1(存图,1280x960) 的帧新鲜度差；get_statistics() 是否有
# stdev() 方法（清晰度代理的前提，没有则自动降级为不做模糊检测）；find_blobs 是否
# 支持 roi= 关键字参数（当前未使用，先用全图搜索打通主流程）。

import gc
import os
import time
from media.sensor import *
from media.display import *
from media.media import *
from machine import Pin, FPIOA

# ===== 配置 =====
CAM_IDS = (1, 2)
SENSOR_W, SENSOR_H = 1280, 960      # 已验证双摄上限；16:9 会卡死
SENSOR_FPS = 90
DISPLAY_TYPE = Display.ST7701
DISPLAY_W, DISPLAY_H = 640, 480
PANE_W, PANE_H = 320, 180           # 预览小窗每路尺寸，宽 16 对齐
# 曝光（掉落防糊关键；上板先跑 exposure_probe.py 确认范围再定）
AUTO_EXPOSURE = False
EXPOSURE_US = 4000                  # 4ms 起点；太糊→再降，太暗→加灯/增益
GAIN_DB = None                      # None=不动增益
# 触发（上板用 trigger_exposure_probe.py 打 ROI 帧差分布+豆投掷采样来标定，
# 两个值都要标，TRIG_STAT 没有真实掉豆数据支撑前不要信任默认值 25）
TRIG_MODE = "stat"                  # "stat" 或 "blob"
TRIG_DELTA = 12                     # 帧差灰度阈值
TRIG_STAT = 25                      # 空景 vs 有物 亮度均值差（未标定默认值，见上）
ROI = None                          # None=中央 1/3 豆窗口；(x,y,w,h) 自定
ARM_HOLD_FRAMES = 2                 # 连续 N 帧差才武装
ARM_TIMEOUT_MS = 600                # ARM 态最长停留；超时强制回 IDLE，防止卡死
COOLDOWN_MS = 1200                  # 拍后冷却（同一颗豆只拍一次）
ROI_QUIET_MS = 800                  # 重新武装前 ROI 须安静
# 保存
JPEG_QUALITY = 95
BOX_MARGIN_F = 0.12              # 自动框外扩比例（与 build_mydata MARGIN 一致）
# 多级阈值链：(低偏移, 高偏移)，从窄到宽依次尝试，命中即停；窄档更准，宽档兜底
BOX_THRESH_OFFSETS = ((45, 10), (60, 15), (80, 20), (100, 5))
BLUR_STDEV_RATIO = 0.6            # 清晰度低于基准该比例判为可疑模糊（需 stdev() 可用）
OUT_ROOTS = ("/data/beanlens/drops", "/sdcard/beanlens/drops")
KEY1_GPIO = 35                      # 退出键
# =================


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


def next_drop_dir(root):
    n = 0
    while exists("%s/drop_%03d" % (root, n)):
        n += 1
    path = "%s/drop_%03d" % (root, n)
    os.mkdir(path)
    return path


def roi_rect(img_w, img_h):
    if ROI is not None:
        return ROI
    return (img_w // 3, img_h // 3, img_w // 3, img_h // 3)


def frame_diff(img, prev, roi):
    # ROI 内平均绝对差（灰度 0-255 单位）。img/prev 为 snapshot 返回的 image 对象
    s = img.get_statistics(roi=roi)
    sp = prev.get_statistics(roi=roi)
    return abs(s.mean() - sp.mean())


def draw_osd(osd, state, seq, n_saved, status):
    osd.clear()
    osd.draw_string_advanced(10, 8, 28, "DROP CAPTURE", color=(0, 255, 0))
    osd.draw_string_advanced(10, 44, 22, "state %s   saved %d" % (state, n_saved), color=(255, 255, 255))
    if status:
        osd.draw_string_advanced(10, 80, 22, status, color=(255, 255, 0))
    # 状态色条
    color = {"IDLE": (0, 120, 0), "ARM": (255, 140, 0), "FIRE": (255, 0, 0), "COOL": (90, 90, 200)}[state]
    osd.draw_rectangle(DISPLAY_W - 120, 8, 100, 40, color=color, thickness=2, fill=True)
    osd.draw_string_advanced(DISPLAY_W - 110, 16, 24, state, color=(255, 255, 255))


def largest_bean_box(gray, mean):
    # MicroPython image 无直方图/真Otsu API。用多级阈值链模拟自适应：
    # 从窄到宽，逐级放宽阈值直到命中豆子 blob，适应不同光照/豆色组合。
    # 反阈值（BINARY_INV）找暗色豆（通道背光/浅背景），面积最大者。
    # mean 参数从外部 get_statistics() 传入，避免重复计算。
    for lo_off, hi_off in BOX_THRESH_OFFSETS:
        thr_lo = max(0, int(mean - lo_off))
        thr_hi = min(255, int(mean - hi_off))
        if thr_hi <= thr_lo:
            continue
        try:
            blobs = gray.find_blobs([(thr_lo, thr_hi)], pixels_threshold=300,
                                     area_threshold=300, merge=True)
            if blobs:
                b = max(blobs, key=lambda x: x.pixels())
                return b.rect()
        except Exception:
            continue
    return None


def save_pair(sensors, out_dir, seq, sharp_baseline):
    # 双摄连续抓帧（最小化间隔）+ 统一编码写盘 + 自动框 sidecar + 清晰度检测
    # 返回：(saved_list, total_ms, capture_interval_us, sharp_vals)
    saved = []
    sharp_vals = []  # 每路的清晰度代理值（stdev 或 None）
    
    # 第一步：连续抓两帧，用 ticks_us 测量真实间隔，不插入任何编码/写盘操作
    t_cap_start = time.ticks_us()
    imgs = [s.snapshot(chn=CAM_CHN_ID_1) for s in sensors]
    t_cap_end = time.ticks_us()
    cap_interval_us = time.ticks_diff(t_cap_end, t_cap_start)
    
    # 第二步：统一编码、写盘、自动框、清晰度检测
    t_proc_start = time.ticks_ms()
    for cid, img in zip(CAM_IDS, imgs):
        data = img.compressed(quality=JPEG_QUALITY).bytearray()
        base = "cam%d_seq%04d" % (cid, seq)
        jpg = "%s/%s.jpg" % (out_dir, base)
        with open(jpg, "wb") as f:
            f.write(data)
        
        # 清晰度代理（stdev，若固件不支持则 getattr 返回 None，自动跳过）
        sharp = None
        try:
            st_fn = getattr(img.get_statistics(), "stdev", None)
            if st_fn is not None and callable(st_fn):
                sharp = st_fn()
        except Exception:
            pass
        sharp_vals.append(sharp)
        
        # 自动画框：灰度多级阈值最大 blob → YOLO 归一化框 sidecar（class 恒 0）
        # sidecar 必须与 jpg 同名（YOLO 配对），模糊标记另记在 blur.txt，不改文件名
        try:
            gray = img.to_grayscale()
            st = gray.get_statistics()
            mean = st.mean()
            box = largest_bean_box(gray, mean)
            if box is not None:
                x, y, w, h = box
                bw, bh = img.width(), img.height()
                mx, my = int(w * BOX_MARGIN_F), int(h * BOX_MARGIN_F)
                x0 = max(0, x - mx)
                y0 = max(0, y - my)
                x1 = min(bw, x + w + mx)
                y1 = min(bh, y + h + my)
                with open("%s/%s.txt" % (out_dir, base), "w") as f:
                    f.write("0 %.6f %.6f %.6f %.6f\n" % (
                        (x0 + x1) / 2 / bw, (y0 + y1) / 2 / bh,
                        (x1 - x0) / bw, (y1 - y0) / bh))
        except Exception as e:
            print("auto-box fail (jpg kept):", e)
        # 清晰度检测：显著低于基准则追加记录到 blur.txt（主机端筛查用）
        if sharp is not None and sharp_baseline is not None \
                and sharp < sharp_baseline * BLUR_STDEV_RATIO:
            try:
                with open(out_dir + "/blur.txt", "a") as f:
                    f.write("%s sharp=%.2f base=%.2f\n" % (base, sharp, sharp_baseline))
            except Exception:
                pass

        saved.append(base)
    
    # 第三步：集中清理，避免 GC 停顿影响前面两次 snapshot 的同步精度
    imgs = None
    data = None
    gc.collect()
    sync_fs()
    
    total_ms = time.ticks_diff(time.ticks_ms(), t_proc_start)
    return saved, total_ms, cap_interval_us, sharp_vals


def main():
    os.exitpoint(os.EXITPOINT_ENABLE)

    fpioa = FPIOA()
    fpioa.set_function(KEY1_GPIO, getattr(FPIOA, "GPIO%d" % KEY1_GPIO))
    key1 = Pin(KEY1_GPIO, Pin.IN, pull=Pin.PULL_UP, drive=7)

    root = pick_root()
    print("output root:", root)
    for vol in ("/data", "/sdcard"):
        try:
            st = os.statvfs(vol)
            if st[3] > 0:
                print("%s free: %.1f MB" % (vol, st[0] * st[3] / 1048576))
        except Exception:
            pass

    sensors = []
    osd = None
    out_dir = None
    seq = 0
    n_saved = 0
    try:
        for i, cid in enumerate(CAM_IDS):
            step("open cam%d 1280x960@90" % cid)
            s = Sensor(id=cid, width=SENSOR_W, height=SENSOR_H, fps=SENSOR_FPS)
            s.reset()
            if i == 0:
                s.set_framesize(Sensor.VGA)
                s.set_pixformat(Sensor.YUV420SP)
                Display.bind_layer(**s.bind_info(), layer=Display.LAYER_VIDEO1)
            s.set_framesize(width=SENSOR_W, height=SENSOR_H, chn=CAM_CHN_ID_1)
            s.set_pixformat(Sensor.RGB565, chn=CAM_CHN_ID_1)
            if not AUTO_EXPOSURE:
                # 手动曝光须在 run() 前关 AE（IDE 曝光例程顺序）
                try:
                    s.auto_exposure(False)
                    rng = s.get_exposure_time_range()
                    if rng:
                        print("cam%d exposure range: %s - %s us" % (cid, rng[1], rng[0]))
                        s.exposure(EXPOSURE_US)
                except Exception as e:
                    print("cam%d manual exposure unavailable: %s" % (cid, e))
            sensors.append(s)

        Display.init(DISPLAY_TYPE, width=DISPLAY_W, height=DISPLAY_H, to_ide=False, osd_num=1)
        MediaManager.init()
        sensors[0].run()          # 多摄只在第一个上 run()（已上板验证）
        time.sleep_ms(500)

        out_dir = next_drop_dir(root)
        seq = 0
        with open(out_dir + "/meta.txt", "w") as f:
            f.write("script=drop_capture_dual.py\nsensor=%dx%d@%d cams=%s\n"
                    "exposure_us=%d auto=%s\ntrigger=%s delta=%d stat=%d arm=%d cool=%d quiet=%d\n"
                    "roi=%s\n"
                    % (SENSOR_W, SENSOR_H, SENSOR_FPS, CAM_IDS,
                       EXPOSURE_US, AUTO_EXPOSURE, TRIG_MODE, TRIG_DELTA, TRIG_STAT,
                       ARM_HOLD_FRAMES, COOLDOWN_MS, ROI_QUIET_MS, ROI))
        print("out dir:", out_dir)

        osd = image.Image(DISPLAY_W, DISPLAY_H, image.ARGB8888)
        prev = None
        baseline_mean = None      # 空景 ROI 亮度均值（rolling）
        state = "IDLE"
        arm_streak = 0
        arm_entered = 0
        sharp_hist = []           # 历史清晰度代理值，取中位数作基准（>=5 个样本才启用）
        sharp_baseline = None
        intervals = []            # 每对 snapshot 间隔(us)，退出时汇总
        last_fire = 0
        quiet_since = None
        status = ""

        while True:
            os.exitpoint()
            now = time.ticks_ms()

            if key1.value() == 0:
                time.sleep_ms(20)
                if key1.value() == 0:
                    print("KEY1 -> exit")
                    break

            # 监视用 chn0（VGA YUV420SP 绑预览的那路）拿小图帧差/统计
            f0 = sensors[0].snapshot(chn=CAM_CHN_ID_0)
            if f0 is None:
                time.sleep_ms(10)
                continue
            roi = roi_rect(f0.width(), f0.height())
            if prev is None:
                prev = f0
                continue
            d = frame_diff(f0, prev, roi)
            prev = f0

            st = f0.get_statistics(roi=roi)
            m = st.mean()

            if state == "IDLE":
                # 刷新空景基线（EMA）
                if baseline_mean is None:
                    baseline_mean = m
                else:
                    baseline_mean = baseline_mean * 0.9 + m * 0.1
                status = "baseline %.1f  diff %.1f" % (baseline_mean, d)
                if d > TRIG_DELTA:
                    arm_streak += 1
                    if arm_streak >= ARM_HOLD_FRAMES:
                        state = "ARM"
                        arm_entered = now
                        status = "ARMED (diff %.1f)" % d
                else:
                    arm_streak = 0

            elif state == "ARM":
                # 有物确认：ROI 亮度均值偏离空景
                if baseline_mean is not None and abs(m - baseline_mean) > TRIG_STAT:
                    state = "FIRE"
                elif time.ticks_diff(now, arm_entered) > ARM_TIMEOUT_MS:
                    # 超时仍未确认：强制回落，避免卡死在 ARM；打印便于标定 TRIG_STAT
                    print("ARM timeout: |m-base|=%.1f (TRIG_STAT=%d) d=%.1f"
                          % (abs(m - (baseline_mean or m)), TRIG_STAT, d))
                    state = "IDLE"
                    arm_streak = 0
                elif d < TRIG_DELTA * 0.5:
                    state = "IDLE"   # 假武装回落
                    arm_streak = 0

            if state == "FIRE":
                saved, ms, cap_us, sharps = save_pair(sensors, out_dir, seq, sharp_baseline)
                seq += 1
                n_saved += 1
                intervals.append(cap_us)
                for v in sharps:
                    if v is not None:
                        sharp_hist.append(v)
                if len(sharp_hist) >= 5:
                    sh = sorted(sharp_hist)
                    sharp_baseline = sh[len(sh) // 2]
                print("[%03d] pair %04d  snap gap %d us  encode+write %d ms  sharp %s"
                      % (n_saved, seq, cap_us, ms, sharps))
                state = "COOL"
                last_fire = now
                quiet_since = None

            elif state == "COOL":
                if now - last_fire >= COOLDOWN_MS:
                    if d < TRIG_DELTA * 0.5 and abs(m - (baseline_mean or m)) < TRIG_STAT * 0.6:
                        if quiet_since is None:
                            quiet_since = now
                        elif now - quiet_since >= ROI_QUIET_MS:
                            state = "IDLE"
                            arm_streak = 0

            draw_osd(osd, state, seq, n_saved, status)
            Display.show_image(osd, 0, 0, Display.LAYER_OSD1)
            time.sleep_ms(20)

    except KeyboardInterrupt:
        print("user stop")
    except BaseException as e:
        import sys
        sys.print_exception(e)
    finally:
        print("---- summary ----")
        print("saved pairs: %d" % n_saved)
        print("out dir:", out_dir)
        try:
            if intervals:
                iv = sorted(intervals)
                msg = "snapshot gap us: median=%d max=%d (n=%d)" % (iv[len(iv) // 2], iv[-1], len(iv))
                print(msg)
                with open(out_dir + "/done.txt", "w") as f:
                    f.write("pairs=%d\n%s\n" % (n_saved, msg))
        except Exception:
            pass
        for s in sensors:
            try:
                s.stop()
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


main()
gc.collect()
