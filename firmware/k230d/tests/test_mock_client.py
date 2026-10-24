"""票 05：mock 客户端。可编程返回 200/400/401/403/429/5xx，不做任何真实网络调用。"""
import os
import unittest

from app.core import mock_client
from app.core.mock_client import MockSubmitClient

RECORD = {"operation_id": "K230D:DEV0000:scan:0000abcd", "bean_count_total": 3}


class MockClientTest(unittest.TestCase):
    def test_default_response_is_200_with_a_record_id(self):
        client = MockSubmitClient()
        response = client.submit(RECORD)
        self.assertEqual(response.status, 200)
        self.assertTrue(response.record_id)
        self.assertIsNone(response.message)

    def test_each_supported_status_is_returned_as_programmed(self):
        for status in (200, 400, 401, 403, 429, 500, 502, 503, 504):
            with self.subTest(status=status):
                client = MockSubmitClient()
                client.set_status(status)
                response = client.submit(RECORD)
                self.assertEqual(response.status, status)
                if status == 200:
                    self.assertTrue(response.record_id)
                else:
                    self.assertIsNone(response.record_id)
                    self.assertTrue(response.message)

    def test_set_status_stays_until_changed(self):
        client = MockSubmitClient()
        client.set_status(503)
        self.assertEqual(client.submit(RECORD).status, 503)
        self.assertEqual(client.submit(RECORD).status, 503)
        client.set_status(200)
        self.assertEqual(client.submit(RECORD).status, 200)

    def test_script_is_consumed_in_order_then_falls_back_to_default(self):
        client = MockSubmitClient()
        client.script(429, 503, 200)
        client.set_status(400)
        got = [client.submit(RECORD).status for _ in range(5)]
        self.assertEqual(got, [429, 503, 200, 400, 400])

    def test_unsupported_status_is_refused(self):
        client = MockSubmitClient()
        for bad in (0, 201, 404, 302, 600, None, "503", True):
            with self.subTest(bad=bad):
                with self.assertRaises(ValueError):
                    client.set_status(bad)
                with self.assertRaises(ValueError):
                    client.script(200, bad)

    def test_calls_are_recorded_with_operation_id_and_a_copy_of_the_body(self):
        client = MockSubmitClient()
        record = {"operation_id": "K230D:DEV0000:scan:11111111", "bean_count_total": 7}
        client.submit(record)
        record["bean_count_total"] = 99  # 事后改动不应影响已记录的调用
        self.assertEqual(len(client.calls), 1)
        self.assertEqual(client.calls[0]["operation_id"], "K230D:DEV0000:scan:11111111")
        self.assertEqual(client.calls[0]["record"]["bean_count_total"], 7)

    def test_each_200_gets_a_distinct_record_id(self):
        client = MockSubmitClient()
        a = client.submit(RECORD).record_id
        b = client.submit(RECORD).record_id
        self.assertNotEqual(a, b)

    def test_module_does_no_networking(self):
        source_path = mock_client.__file__
        self.assertTrue(os.path.isfile(source_path))
        with open(source_path) as f:
            source = f.read()
        for banned in ("socket", "urllib", "http", "requests", "network", "ssl"):
            self.assertNotIn("import " + banned, source)
            self.assertNotIn("from " + banned, source)


if __name__ == "__main__":
    unittest.main()
