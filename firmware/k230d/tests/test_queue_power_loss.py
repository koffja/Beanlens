"""票 05：队列崩溃恢复。沿用 test_session_power_loss 的办法：在每一次 rename / remove / sync 之前
各断电一次（sync 那档把 .tmp 截半），然后“重启”（新队列对象 + recover），断言：
  1. 目录里没有损坏的 JSON（.tmp 不算，它永远不会被读）；
  2. 被操作的那条恰好处于「旧状态」或「新状态」之一，正文与状态匹配，不丢、不重复；
  3. 旁观的其他条目一字不变；
  4. 重启后没有任何条目停在 saving（回到可重新提交的 pending）。
"""
import json
import os
import unittest

from app.core.queue import (
    ALL_STATES,
    STATE_FAILED_REJECTED,
    STATE_FAILED_RETRIABLE,
    STATE_PENDING,
    STATE_SAVED,
    STATE_SAVING,
    SubmissionQueue,
)
from app.core.mock_client import MockSubmitClient
from app.core.report import ReportOrchestrator
from queue_helpers import enqueue_new
from session_helpers import Env
from test_session_power_loss import sweep


def restart(env):
    """模拟重启：全新队列对象 + 启动恢复。"""
    q = SubmissionQueue(base_dir=env.dir, clock=env.clock)
    report = q.recover()
    return q, report


def copy_of(obj):
    return json.loads(json.dumps(obj))


class QueuePowerLossTest(unittest.TestCase):
    def assert_no_corrupt_json(self, env):
        for root, _dirs, files in os.walk(env.dir):
            for name in files:
                if name.endswith(".tmp") or name.endswith(".log"):
                    continue
                full = os.path.join(root, name)
                with open(full) as f:
                    try:
                        json.loads(f.read())
                    except ValueError:
                        self.fail("损坏的 JSON: %s" % os.path.relpath(full, env.dir))

    def assert_queue_sane(self, q):
        """重启后：每条状态合法、没有 saving、operation_id 与文件名一致。"""
        for entry in q.list_all():
            self.assertIn(entry["state"], ALL_STATES)
            self.assertNotEqual(entry["state"], STATE_SAVING)
            self.assertEqual(q.get_entry(entry["operation_id"]), entry)

    def build_pair(self, prepare=None):
        """造一条被操作的条目 op 和一条旁观的 pending 条目 other。返回 (op, other, other 的快照)。"""
        def build(env):
            op = enqueue_new(env)
            if prepare is not None:
                prepare(env.queue, op)
            other = enqueue_new(env)
            return op, other, copy_of(env.queue.get_entry(other))
        return build

    # ---- 状态转换中途断电 ----

    def test_power_cut_while_marking_saving_returns_to_pending_after_restart(self):
        def operate(env, ctx):
            env.queue.mark_saving(ctx[0])

        def check(env, ctx, cut_at):
            op, other, other_snapshot = ctx
            q, _report = restart(env)
            self.assert_no_corrupt_json(env)
            self.assert_queue_sane(q)
            entry = q.get_entry(op)
            self.assertEqual(entry["state"], STATE_PENDING)  # 没写成是 pending，写成了 saving 被恢复也是 pending
            self.assertEqual(entry["record"]["operation_id"], op)
            self.assertEqual(q.get_entry(other), other_snapshot)
            self.assertEqual(q.next_pending()["operation_id"], op)  # 仍是最早的，可重新提交

        sweep(self, self.build_pair(), operate, check)

    def test_power_cut_while_marking_saved(self):
        original = {}

        def prepare(q, op):
            original["record"] = copy_of(q.get_entry(op)["record"])
            q.mark_saving(op)

        def operate(env, ctx):
            env.queue.mark_saved(ctx[0], "rec-9")

        def check(env, ctx, cut_at):
            op, other, other_snapshot = ctx
            q, _report = restart(env)
            self.assert_no_corrupt_json(env)
            self.assert_queue_sane(q)
            entry = q.get_entry(op)
            self.assertIn(entry["state"], (STATE_PENDING, STATE_SAVED))
            if entry["state"] == STATE_SAVED:
                self.assertNotIn("record", entry)
                self.assertEqual(entry["record_id"], "rec-9")
                self.assertEqual(entry["metadata"]["session_id"], original["record"]["session_id"])
                self.assertEqual(entry["metadata"]["bean_count_total"],
                                 original["record"]["bean_count_total"])
            else:
                # 没写成：正文必须完整，用同一个 operation_id 重新提交是幂等的。
                self.assertEqual(entry["record"], original["record"])
            if cut_at is None:
                self.assertEqual(entry["state"], STATE_SAVED)
            self.assertEqual(q.get_entry(other), other_snapshot)

        sweep(self, self.build_pair(prepare), operate, check)

    def test_power_cut_while_marking_failed_retriable(self):
        def prepare(q, op):
            q.mark_saving(op)

        def operate(env, ctx):
            env.queue.mark_failed(ctx[0], 503, "boom")

        def check(env, ctx, cut_at):
            op, other, other_snapshot = ctx
            q, _report = restart(env)
            self.assert_no_corrupt_json(env)
            self.assert_queue_sane(q)
            entry = q.get_entry(op)
            self.assertIn(entry["state"], (STATE_PENDING, STATE_FAILED_RETRIABLE))
            if entry["state"] == STATE_FAILED_RETRIABLE:
                self.assertEqual(entry["retry_count"], 1)
                self.assertEqual(entry["error_code"], 503)
            else:
                self.assertEqual(entry["retry_count"], 0)
                self.assertNotIn("error_code", entry)
            self.assertEqual(entry["record"]["operation_id"], op)
            if cut_at is None:
                self.assertEqual(entry["state"], STATE_FAILED_RETRIABLE)
            self.assertEqual(q.get_entry(other), other_snapshot)

        sweep(self, self.build_pair(prepare), operate, check)

    def test_power_cut_while_marking_failed_rejected(self):
        def prepare(q, op):
            q.mark_saving(op)

        def operate(env, ctx):
            env.queue.mark_failed(ctx[0], 400, "bad")

        def check(env, ctx, cut_at):
            op, other, other_snapshot = ctx
            q, _report = restart(env)
            self.assert_no_corrupt_json(env)
            self.assert_queue_sane(q)
            entry = q.get_entry(op)
            self.assertIn(entry["state"], (STATE_PENDING, STATE_FAILED_REJECTED))
            if entry["state"] == STATE_FAILED_REJECTED:
                self.assertEqual(entry["error_code"], 400)
                self.assertEqual([e["operation_id"] for e in q.list_rejected()], [op])
            else:
                self.assertEqual(q.list_rejected(), [])
            self.assertEqual(entry["retry_count"], 0)
            if cut_at is None:
                self.assertEqual(entry["state"], STATE_FAILED_REJECTED)
            self.assertEqual(q.get_entry(other), other_snapshot)

        sweep(self, self.build_pair(prepare), operate, check)

    def test_power_cut_while_resubmitting_a_rejected_entry(self):
        data = {}

        def prepare(q, op):
            q.mark_saving(op)
            q.mark_failed(op, 400, "bad")
            data["old"] = copy_of(q.get_entry(op)["record"])
            new = copy_of(data["old"])
            new["bean_count_total"] = 10
            new["defects"]["full_black"] = 2
            data["new"] = new

        def operate(env, ctx):
            env.queue.resubmit_rejected(ctx[0], data["new"])

        def check(env, ctx, cut_at):
            op, other, other_snapshot = ctx
            q, _report = restart(env)
            self.assert_no_corrupt_json(env)
            self.assert_queue_sane(q)
            entry = q.get_entry(op)
            self.assertEqual(entry["operation_id"], op)
            self.assertIn(entry["state"], (STATE_FAILED_REJECTED, STATE_PENDING))
            if entry["state"] == STATE_PENDING:  # 新状态必须配新正文
                self.assertEqual(entry["record"], data["new"])
                self.assertEqual(entry["retry_count"], 0)
                self.assertNotIn("error_code", entry)
            else:  # 旧状态必须配旧正文和拒收原因
                self.assertEqual(entry["record"], data["old"])
                self.assertEqual(entry["error_code"], 400)
            if cut_at is None:
                self.assertEqual(entry["state"], STATE_PENDING)
            self.assertEqual(len(q.list_all()), 2)  # 不多不少，没有因换 id 产生副本
            self.assertEqual(q.get_entry(other), other_snapshot)

        sweep(self, self.build_pair(prepare), operate, check)

    def test_power_cut_while_purging_old_saved_metadata(self):
        def build(env):
            ops = []
            for i in range(4):
                op = enqueue_new(env)
                env.queue.mark_saving(op)
                env.queue.mark_saved(op, "rec-%d" % i)
                ops.append(op)
            return ops

        def operate(env, ops):
            env.queue.purge_saved(keep=2)

        def check(env, ops, cut_at):
            q, _report = restart(env)
            self.assert_no_corrupt_json(env)
            self.assert_queue_sane(q)
            present = [op for op in ops if q.get_entry(op) is not None]
            # 永远从最旧的开始删：最近 2 条一定在，已删的不会“复活”。
            self.assertIn(present, (ops, ops[1:], ops[2:]))
            for op in ops[2:]:
                self.assertEqual(q.get_entry(op)["state"], STATE_SAVED)
                self.assertNotIn("record", q.get_entry(op))
            q.purge_saved(keep=2)  # 重启后补完上一次没做完的清理
            self.assertEqual([e["operation_id"] for e in q.list_all()], ops[2:])

        sweep(self, build, operate, check)

    def test_power_cut_while_enqueueing_next_to_an_existing_entry(self):
        def build(env):
            existing = enqueue_new(env)
            session = env.session_in_state("result_ready")
            return existing, session, copy_of(env.queue.get_entry(existing))

        def operate(env, ctx):
            ctx[1].save_to_queue(env.queue)

        def check(env, ctx, cut_at):
            existing, session, existing_snapshot = ctx
            q, _report = restart(env)
            self.assert_no_corrupt_json(env)
            self.assert_queue_sane(q)
            self.assertEqual(q.get_entry(existing), existing_snapshot)
            added = q.get_entry(session.operation_id)
            if added is None:
                self.assertIsNotNone(cut_at)
                self.assertEqual(len(q.list_all()), 1)
            else:
                self.assertEqual(added["state"], STATE_PENDING)
                self.assertEqual(added["record"]["session_id"], session.session_id)
                self.assertEqual(len(q.list_all()), 2)
            if cut_at is None:
                self.assertIsNotNone(added)

        sweep(self, build, operate, check)

    # ---- recover 本身 ----

    def test_recover_requeues_only_saving_entries_and_reports_them(self):
        env = Env(self)
        saving = enqueue_new(env)
        env.queue.mark_saving(saving)
        pending = enqueue_new(env)
        rejected = enqueue_new(env)
        env.queue.mark_saving(rejected)
        env.queue.mark_failed(rejected, 403, "quota")
        retriable = enqueue_new(env)
        env.queue.mark_saving(retriable)
        env.queue.mark_failed(retriable, 503, "x")
        before = {}
        for op in (pending, rejected, retriable):
            before[op] = copy_of(env.queue.get_entry(op))
        saving_before = copy_of(env.queue.get_entry(saving))

        q, report = restart(env)

        self.assertEqual(report["requeued"], [saving])
        entry = q.get_entry(saving)
        self.assertEqual(entry["state"], STATE_PENDING)
        self.assertEqual(entry["record"], saving_before["record"])
        self.assertEqual(entry["created_at"], saving_before["created_at"])
        self.assertEqual(entry["retry_count"], saving_before["retry_count"])
        for op in before:
            self.assertEqual(q.get_entry(op), before[op])

    def test_recover_is_idempotent(self):
        env = Env(self)
        op = enqueue_new(env)
        env.queue.mark_saving(op)
        restart(env)
        tree = env.tree()
        _q, report = restart(env)
        self.assertEqual(report["requeued"], [])
        self.assertEqual(env.tree(), tree)

    def test_recover_on_missing_queue_dir_is_a_noop(self):
        env = Env(self)
        _q, report = restart(env)
        self.assertEqual(report["requeued"], [])
        self.assertEqual(report["cleaned_tmp"], [])
        self.assertEqual(report["unreadable"], [])

    def test_recover_removes_half_written_tmp_files(self):
        env = Env(self)
        op = enqueue_new(env)
        tmp = os.path.join(env.dir, "queue", "K230D:DEV0000:scan:0badf00d.json.tmp")
        with open(tmp, "w") as f:
            f.write('{"half')
        q, report = restart(env)
        self.assertFalse(os.path.exists(tmp))
        self.assertEqual(report["cleaned_tmp"], ["K230D:DEV0000:scan:0badf00d.json.tmp"])
        self.assertEqual([e["operation_id"] for e in q.list_all()], [op])

    def test_recover_reports_unreadable_entry_and_leaves_it_alone(self):
        env = Env(self)
        op = enqueue_new(env)
        broken = os.path.join(env.dir, "queue", "K230D:DEV0000:scan:00000000.json")
        with open(broken, "w") as f:
            f.write("{not json")
        q, report = restart(env)  # 不能因为一个坏文件整体崩溃
        self.assertEqual(report["unreadable"], ["K230D:DEV0000:scan:00000000.json"])
        self.assertTrue(os.path.exists(broken))
        self.assertEqual([e["operation_id"] for e in q.list_all()], [op])

    def test_entry_with_only_prev_left_is_recovered_from_prev(self):
        """rename 中途断电：主文件已改名成 .prev、新文件还没就位。恢复后读回旧内容并回到 pending。"""
        env = Env(self)
        op = enqueue_new(env)
        env.queue.mark_saving(op)
        main = os.path.join(env.dir, "queue", op + ".json")
        os.rename(main, main + ".prev")
        q, report = restart(env)
        self.assertEqual(report["requeued"], [op])
        self.assertEqual(q.get_entry(op)["state"], STATE_PENDING)

    def test_after_restart_the_orchestrator_resubmits_the_same_operation_id(self):
        env = Env(self)
        first = enqueue_new(env)
        second = enqueue_new(env)
        env.queue.mark_saving(first)  # 提交到一半崩溃：状态停在 saving
        q, _report = restart(env)
        client = MockSubmitClient()
        orch = ReportOrchestrator(q, client)
        result = orch.submit_next()
        self.assertEqual(result["operation_id"], first)
        self.assertEqual(client.calls[0]["operation_id"], first)
        self.assertEqual(orch.submit_next()["operation_id"], second)


if __name__ == "__main__":
    unittest.main()
