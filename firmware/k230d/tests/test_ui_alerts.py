import unittest

from app.ui import alerts


class PairingAlertTest(unittest.TestCase):
    def test_no_beans_means_no_alert(self):
        self.assertIsNone(alerts.pairing_alert(0, 0))

    def test_all_paired_has_no_alert(self):
        self.assertIsNone(alerts.pairing_alert(100, 0))

    def test_exactly_eighty_percent_pairing_rate_has_no_alert(self):
        # 配对率 80%、配对不明 20%：边界值不提示（"低于 80%" / "超过 20%" 才提示）。
        self.assertIsNone(alerts.pairing_alert(100, 20))
        self.assertIsNone(alerts.pairing_alert(5, 1))

    def test_unpaired_over_twenty_percent_alerts(self):
        alert = alerts.pairing_alert(100, 21)
        self.assertIsNotNone(alert)
        self.assertEqual(alert["kind"], "pairing")
        self.assertEqual(alert["level"], "warning")
        self.assertIn("豆路对准或光照异常", alert["message"])

    def test_pairing_rate_below_eighty_percent_alerts(self):
        # 配对率 = 配对成功 / 豆粒总数 = (总数 - 配对不明) / 总数
        alert = alerts.pairing_alert(10, 3)
        self.assertIsNotNone(alert)
        self.assertAlmostEqual(alert["pairing_rate"], 0.7)
        self.assertAlmostEqual(alert["unpaired_ratio"], 0.3)

    def test_just_over_the_line_with_large_counts_alerts(self):
        # 20.1% 不能被取整吃掉
        self.assertIsNotNone(alerts.pairing_alert(1000, 201))
        self.assertIsNone(alerts.pairing_alert(1000, 200))

    def test_message_shows_the_percentages(self):
        alert = alerts.pairing_alert(10, 3)
        self.assertIn("70.0%", alert["message"])
        self.assertIn("30.0%", alert["message"])

    def test_rate_is_none_when_no_beans(self):
        self.assertIsNone(alerts.pairing_rate(0, 0))
        self.assertAlmostEqual(alerts.pairing_rate(10, 2), 0.8)

    def test_unpaired_cannot_exceed_total(self):
        with self.assertRaises(ValueError):
            alerts.pairing_alert(5, 6)

    def test_negative_or_non_int_counts_rejected(self):
        for total, unpaired in ((-1, 0), (5, -1), (5.5, 1), ("5", 1), (True, 0)):
            with self.assertRaises(ValueError):
                alerts.pairing_alert(total, unpaired)


if __name__ == "__main__":
    unittest.main()
