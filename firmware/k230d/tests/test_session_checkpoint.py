import unittest

from session_helpers import Env, read


def checkpointed_beans(session):
    """磁盘上最近一次 checkpoint 记录的豆粒总数（外部可见行为，不看内存）。"""
    return read(session.checkpoint_file)["bean_count_total"]


class CheckpointByCountTest(unittest.TestCase):
    def setUp(self):
        self.env = Env(self)

    def test_default_thresholds_are_30_beans_and_5_seconds(self):
        s = self.env.new_session()
        self.assertEqual(s.checkpoint_every_beans, 30)
        self.assertEqual(s.checkpoint_interval_s, 5)

    def test_writes_exactly_on_the_30th_bean(self):
        s = self.env.session_in_state("scanning")
        for _ in range(29):
            s.record_bean()
        self.assertEqual(checkpointed_beans(s), 0)
        s.record_bean()
        self.assertEqual(checkpointed_beans(s), 30)

    def test_next_checkpoint_is_30_beans_later(self):
        s = self.env.session_in_state("scanning")
        for _ in range(59):
            s.record_bean()
        self.assertEqual(checkpointed_beans(s), 30)
        s.record_bean()
        self.assertEqual(checkpointed_beans(s), 60)

    def test_checkpoint_keeps_unpaired_and_defect_counts(self):
        s = self.env.session_in_state("scanning")
        for _ in range(28):
            s.record_bean()
        s.record_bean(unpaired=True)
        s.record_bean(defect="fungus")
        saved = read(s.checkpoint_file)
        self.assertEqual(saved["bean_count_total"], 30)
        self.assertEqual(saved["unpaired_count"], 1)
        self.assertEqual(saved["defects"]["fungus"], 1)


class CheckpointByTimeTest(unittest.TestCase):
    def setUp(self):
        self.env = Env(self)

    def test_tick_writes_once_five_seconds_have_passed(self):
        s = self.env.session_in_state("scanning")
        for _ in range(5):
            s.record_bean()
        self.env.clock.advance(4.9)
        self.assertFalse(s.tick())
        self.assertEqual(checkpointed_beans(s), 0)
        self.env.clock.advance(0.1)
        self.assertTrue(s.tick())
        self.assertEqual(checkpointed_beans(s), 5)

    def test_record_bean_itself_also_checkpoints_when_five_seconds_passed(self):
        s = self.env.session_in_state("scanning")
        s.record_bean()
        self.env.clock.advance(5)
        s.record_bean()
        self.assertEqual(checkpointed_beans(s), 2)

    def test_idle_scanning_does_not_rewrite_unchanged_data(self):
        s = self.env.session_in_state("scanning")
        before = read(s.checkpoint_file)
        self.env.clock.advance(100)
        self.assertFalse(s.tick())
        self.assertEqual(read(s.checkpoint_file), before)

    def test_timer_restarts_from_the_last_checkpoint_whichever_came_first(self):
        s = self.env.session_in_state("scanning")
        for _ in range(30):  # 数量先到，t=0 写盘
            s.record_bean()
        self.env.clock.advance(4)
        s.record_bean()
        self.assertFalse(s.tick())  # 距上次写盘只有 4 秒
        self.assertEqual(checkpointed_beans(s), 30)
        self.env.clock.advance(1)
        self.assertTrue(s.tick())  # 满 5 秒，时间先到
        self.assertEqual(checkpointed_beans(s), 31)

    def test_time_checkpoint_resets_the_bean_counter(self):
        s = self.env.session_in_state("scanning")
        for _ in range(10):
            s.record_bean()
        self.env.clock.advance(5)
        s.tick()
        for _ in range(29):  # 时间写盘后重新累计，29 颗不应再触发
            s.record_bean()
        self.assertEqual(checkpointed_beans(s), 10)
        s.record_bean()
        self.assertEqual(checkpointed_beans(s), 40)

    def test_tick_outside_scanning_is_a_harmless_noop(self):
        for state in ("pending", "result_ready", "queued", "saved", "discarded", "incomplete"):
            s = Env(self).session_in_state(state)
            self.assertFalse(s.tick(), state)


class CheckpointConfigTest(unittest.TestCase):
    def setUp(self):
        self.env = Env(self)

    def test_bean_threshold_is_configurable(self):
        s = self.env.new_session(checkpoint_every_beans=3)
        s.start()
        s.record_bean()
        s.record_bean()
        self.assertEqual(checkpointed_beans(s), 0)
        s.record_bean()
        self.assertEqual(checkpointed_beans(s), 3)

    def test_interval_is_configurable_including_fractions(self):
        s = self.env.new_session(checkpoint_interval_s=1.5)
        s.start()
        s.record_bean()
        self.env.clock.advance(1.4)
        self.assertFalse(s.tick())
        self.env.clock.advance(0.1)
        self.assertTrue(s.tick())
        self.assertEqual(checkpointed_beans(s), 1)

    def test_invalid_thresholds_are_rejected(self):
        for kwargs in ({"checkpoint_every_beans": 0}, {"checkpoint_every_beans": -1},
                       {"checkpoint_every_beans": 2.5}, {"checkpoint_every_beans": True},
                       {"checkpoint_interval_s": 0}, {"checkpoint_interval_s": -5},
                       {"checkpoint_interval_s": "5"}, {"checkpoint_interval_s": None}):
            with self.assertRaises(ValueError, msg=str(kwargs)):
                self.env.new_session(**kwargs)

    def test_stop_always_persists_the_final_counts(self):
        s = self.env.session_in_state("scanning")
        for _ in range(7):
            s.record_bean()
        self.env.clock.advance(1)
        s.stop()
        self.assertEqual(checkpointed_beans(s), 7)


if __name__ == "__main__":
    unittest.main()
