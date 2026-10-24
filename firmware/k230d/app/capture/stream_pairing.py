# 流式配对（票 09 草稿）：在扫描过程中分批接收两路新候选，复用票 04 的 pair_tracks 做一对一配对。
# - 已配对的 track 立即消费，不会被配对两次。
# - 暂时没有对端的 track 先留在缓冲里；等它的时间戳比 now_ms 早 ΔT 以上（对端已不可能再来）
#   才算配对不明。假设值：对端候选的到达延迟小于 ΔT，待上板实测。
# - 每路缓冲有上限（buffer_max），溢出时把最旧的直接算配对不明，不无限增长。
# - flush() 在停止时调用，把仍在缓冲里的全部算配对不明。
# - 不修改 pairing.py；术语沿用 CONTEXT.md：配对成功 / 配对不明 / 拒判（配对成功的子集）。
# 只用标准库子集，按 MicroPython 可用的写法编写（未在 CanMV 板上验证）。
from app.capture import pairing

SIDE_FRONT = "front"
SIDE_REAR = "rear"
DEFAULT_BUFFER_MAX = 6


class StreamPairer:
    def __init__(self, tolerance_ms, buffer_max=DEFAULT_BUFFER_MAX):
        if isinstance(tolerance_ms, bool) or not isinstance(tolerance_ms, (int, float)) or tolerance_ms < 0:
            raise ValueError("tolerance_ms 必须是 >= 0 的数字")
        if isinstance(buffer_max, bool) or not isinstance(buffer_max, int) or buffer_max < 1:
            raise ValueError("buffer_max 必须是 >= 1 的整数")
        self.tolerance_ms = tolerance_ms
        self.buffer_max = buffer_max
        self._buf = {SIDE_FRONT: [], SIDE_REAR: []}
        self.paired_count = 0
        self.unpaired_count = 0
        self.rejected_count = 0
        self.overflow_count = 0

    def buffered(self, side):
        return len(self._buf[side])

    def summary(self):
        """累计的配对统计（豆粒总数、配对率、告警），形状同 pairing.summarize_counts。"""
        return pairing.summarize_counts(self.paired_count, self.unpaired_count, self.rejected_count)

    def step(self, front_new, rear_new, now_ms):
        """接收两路新候选并配对。返回 {"paired": [...], "unpaired": [...]}。

        paired 每项 {"front": 候选, "rear": 候选, "rejected": bool}；
        unpaired 每项是单个候选（带 side 字段）。
        """
        for cand in front_new:
            self._buf[SIDE_FRONT].append(cand)
        for cand in rear_new:
            self._buf[SIDE_REAR].append(cand)
        return self._resolve(now_ms, False)

    def flush(self):
        """停止时调用：缓冲里还没配上的全部算配对不明。"""
        return self._resolve(None, True)

    def _tracks(self, side):
        out = []
        for cand in self._buf[side]:
            out.append(pairing.make_track(cand["track_id"], cand["t_ms"],
                                          cand.get("insufficient", False)))
        return out

    def _resolve(self, now_ms, flush):
        fmap = {}
        for cand in self._buf[SIDE_FRONT]:
            fmap[cand["track_id"]] = cand
        rmap = {}
        for cand in self._buf[SIDE_REAR]:
            rmap[cand["track_id"]] = cand
        result = pairing.pair_tracks(self._tracks(SIDE_FRONT), self._tracks(SIDE_REAR),
                                     self.tolerance_ms)

        paired = []
        for pair in result["pairs"]:
            paired.append({"front": fmap[pair["front_id"]], "rear": rmap[pair["rear_id"]],
                           "rejected": pair["rejected"]})
            self.paired_count += 1
            if pair["rejected"]:
                self.rejected_count += 1

        unpaired = []
        remaining = {SIDE_FRONT: [], SIDE_REAR: []}
        for track_id in result["unpaired_front_ids"]:
            self._settle(fmap[track_id], SIDE_FRONT, now_ms, flush, unpaired, remaining)
        for track_id in result["unpaired_rear_ids"]:
            self._settle(rmap[track_id], SIDE_REAR, now_ms, flush, unpaired, remaining)

        for side in (SIDE_FRONT, SIDE_REAR):
            kept = remaining[side]
            kept.sort(key=lambda c: c["t_ms"])
            while len(kept) > self.buffer_max:
                unpaired.append(kept.pop(0))
                self.unpaired_count += 1
                self.overflow_count += 1
            self._buf[side] = kept
        return {"paired": paired, "unpaired": unpaired}

    def _settle(self, cand, side, now_ms, flush, unpaired, remaining):
        if flush or now_ms - cand["t_ms"] > self.tolerance_ms:
            unpaired.append(cand)
            self.unpaired_count += 1
        else:
            remaining[side].append(cand)
