# 完整扫描会话主循环骨架（票 09 草稿）。
#   session.start（由 UI 的「开始」触发）
#     -> 循环：采集（CaptureManager）-> 配对（StreamPairer）-> 推理（detector）-> session.record_bean
#              -> session.tick（checkpoint 节奏）-> UI 刷新
#     -> finish：flush 配对缓冲 -> 处理剩余 -> session.stop（由 UI 的「停止」触发）
# - 本模块不 import app.ui：UI 刷新通过 ui_refresh 回调传入，run_scan_cycle 里的 ui 是鸭子类型。
# - 豆粒总数 = 配对成功 + 配对不明，由 record_bean 逐颗累加，与模型输出无关（ADR 0002）。
# - 配对不明不计入任何瑕疵类别；拒判（成像不足）算配对成功，bean +1 且不跑推理，单独计数在 stats()。
# - 没检出瑕疵不等于正常豆：record_bean() 不带类别，正常豆数由三项差值得到。
# - 推理异常：runner.error 记录原因并停止继续处理；run_scan_cycle 据此把会话转为 incomplete，
#   保留已完成计数，不发新的送料许可（k230d/AGENTS.md）。
# - 板侧调用（真实相机、KPU、LVGL 刷新）都不在本模块，只在 camera / detection / UI 层的注释里。
# 只用标准库子集，按 MicroPython 可用的写法编写（未在 CanMV 板上验证）。
from app.capture import detection
from app.capture import stream_pairing

DEFAULT_MIN_SCORE = 0.3  # 假设值，待上板对照后写回配置


class ScanRunner:
    def __init__(self, session, manager, detector, tolerance_ms, clock_ms,
                 ui_refresh=None, min_score=DEFAULT_MIN_SCORE,
                 batch_max=detection.BATCH_MAX, min_sharpness=None):
        """session: 已 start() 的 ScanSession；manager: CaptureManager；detector: BaseDetector；
        clock_ms: 返回毫秒数的无参函数；min_sharpness 为 None 时不判拒判（阈值待上板标定）。"""
        self.session = session
        self.manager = manager
        self.detector = detector
        self.clock_ms = clock_ms
        self.ui_refresh = ui_refresh
        self.min_score = min_score
        self.batch_max = batch_max
        self.min_sharpness = min_sharpness
        self.pairer = stream_pairing.StreamPairer(tolerance_ms)
        self.error = None
        self.steps = 0
        self.fade_count = 0
        self.rejected_count = 0

    # ---- 单步 ----

    def step(self):
        """跑一轮。返回 False 表示已出错（runner.error 非空），调用方应停止循环。"""
        if self.error is not None:
            return False
        self.manager.poll_once()
        front = self.manager.drain(stream_pairing.SIDE_FRONT)
        rear = self.manager.drain(stream_pairing.SIDE_REAR)
        self._mark_insufficient(front)
        self._mark_insufficient(rear)
        events = self.pairer.step(front, rear, self.clock_ms())
        self._process(events)
        self.steps += 1
        self.session.tick()
        self._refresh()
        return self.error is None

    def finish(self):
        """停止前调用：把缓冲里剩下的候选结算掉，返回 stats()。出错后也会结算配对不明。"""
        events = self.pairer.flush()
        self._process(events)
        self._refresh()
        return self.stats()

    def stats(self):
        summary = self.pairer.summary()
        return {
            "steps": self.steps,
            "paired_count": summary["paired_count"],
            "unpaired_count": summary["unpaired_count"],
            "rejected_count": self.rejected_count,
            "fade_count": self.fade_count,
            "bean_count_total": summary["bean_count_total"],
            "pairing_alert": summary["alert"],
            "error": self.error,
        }

    # ---- 内部 ----

    def _mark_insufficient(self, candidates):
        if self.min_sharpness is None:
            return
        for cand in candidates:
            cand["insufficient"] = cand["sharpness"] < self.min_sharpness

    def _refresh(self):
        if self.ui_refresh is not None:
            self.ui_refresh()

    def _process(self, events):
        for cand in events["unpaired"]:
            self.session.record_bean(unpaired=True)
        classifiable = []
        for pair in events["paired"]:
            if pair["rejected"]:
                # 拒判：成像不足以定类，算配对成功，不跑推理，不计入任何瑕疵类别。
                self.session.record_bean()
                self.rejected_count += 1
            else:
                classifiable.append(pair)
        if self.error is not None:
            # 推理已出错：这些豆未判定，不记入会话（不能当正常豆），由 run_scan_cycle 转 incomplete。
            return
        for batch in detection.split_batches(classifiable, self.batch_max):
            self._classify_batch(batch)
            if self.error is not None:
                break

    def _classify_batch(self, batch):
        crops = []
        for pair in batch:
            crops.append(pair["front"]["crop"])
            crops.append(pair["rear"]["crop"])
        try:
            outputs = self.detector.infer(crops)
            if len(outputs) != len(crops):
                raise ValueError("检测器返回 %d 项，应为 %d 项" % (len(outputs), len(crops)))
        except Exception as e:
            self.error = "推理失败: %s" % (e,)
            return
        index = 0
        for _pair in batch:
            verdict = detection.classify_bean(outputs[index], outputs[index + 1], self.min_score)
            index += 2
            if verdict["fade"]:
                self.fade_count += 1
            self.session.record_bean(defect=verdict["defect"])


def run_scan_cycle(ui, build_runner, should_stop, max_steps=100000):
    """一次完整扫描：ui.start_scan -> 循环 -> finish -> ui.stop。ui 是 UIController 形状的对象。

    build_runner(session, ui_refresh) 返回 ScanRunner；should_stop(runner) 返回 True 时结束。
    返回 {"started", "stopped", "incomplete", "stats", "message"}。
    出错时不调 ui.stop，而是 session.mark_incomplete()，永不入队。
    """
    started = ui.start_scan()
    if not started["started"]:
        return {"started": False, "stopped": False, "incomplete": False,
                "stats": None, "message": started["message"]}
    session = started["session"]
    runner = build_runner(session, ui.state)
    count = 0
    while count < max_steps and not should_stop(runner):
        if not runner.step():
            break
        count += 1
    stats = runner.finish()
    if runner.error is not None:
        session.mark_incomplete()
        return {"started": True, "stopped": False, "incomplete": True,
                "stats": stats, "message": runner.error}
    ui.stop()
    return {"started": True, "stopped": True, "incomplete": False,
            "stats": stats, "message": ""}
