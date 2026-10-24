# 02 — 会话状态机与断电恢复

**What to build:** 扫描会话有完整的 7 态生命周期，并且扫描中途断电后，重启能把它找回来标成「未完成会话」，只能查看或丢弃，永不进队列。

**Blocked by:** 01

**Status:** done（主机检查：`rtk python3 -m unittest discover -s tests -v`，Ran 181 tests, OK；未上板运行）

- [x] 7 个状态（pending / scanning / result_ready / queued / saved / discarded / incomplete）的合法转换全部可达；非法转换（例如结果页「继续扫描」补豆）被拒绝并有明确错误（`InvalidTransition`，测试：`test_session_state_machine.py`）
- [x] 扫描中每累计 30 颗或每过 5 秒写一次 checkpoint，先到先写；两个阈值可配置（`checkpoint_every_beans` / `checkpoint_interval_s`，时钟可注入；测试：`test_session_checkpoint.py`）
- [x] 模拟扫描中非正常退出后重新启动：该会话变成 incomplete，保留已 checkpoint 的计数，标记为不可保存入队（`SessionStore.recover()`，`saveable=False`；测试：`test_session_store.py`）
- [x] 未完成会话可以查看和丢弃；单独存放，不计入队列条数；最多保留 20 条，超出滚动删除最旧的并留日志（`list_incomplete` / `get_incomplete` / `discard_incomplete`，日志 `logs/session_store.log`）
- [x] 放弃会话需二次确认标志才生效，放弃后本地保留 7 天，到期清理（`discard(confirmed=True)`，`purge_expired_discarded()`）
- [x] 断电模拟覆盖：checkpoint 写入中途、状态转换中途，重启后数据不损坏、状态一致（`test_session_power_loss.py`：对每一次 rename / remove / sync 各断电一次，sync 档同时把 .tmp 截半）
- [x] 状态转换穷举测试：每条合法路径断言前置条件和后置状态（7 态 × 7 操作全组合 + 7×7 状态对转换表）

**未验证（需上板）：** TF 卡（FAT/exFAT）上 `os.rename` / `os.remove` / `os.sync` 的实际行为、含冒号的文件名、checkpoint 实际写入耗时，均只做了主机模拟。
