# UI 主控制器（票 08）：聚合所有页面对象，维护当前页面与会话指针，提供一致的导航接口。
# 每个页面的业务逻辑在各自模块里；控制器负责路由和状态切换。
# - 页面间跳转：start_scan / stop / save_local / discard / open_settings / open_diagnostics / back
# - press(button_id)：按按钮 id 派发到对应方法
# - state()：当前页面的完整状态字典
# - session / store / queue：透传给测试与上层
# 只用标准库子集，按 MicroPython 可用的写法编写（未在 CanMV 板上验证）。
from app.ui.diagnostics import DiagnosticsPage
from app.ui.home import HomePage
from app.ui.result import ResultPage
from app.ui.scanning import ScanningPage
from app.ui.settings import SettingsPage

PAGE_HOME = "home"
PAGE_SCANNING = "scanning"
PAGE_RESULT = "result"
PAGE_SETTINGS = "settings"
PAGE_DIAGNOSTICS = "diagnostics"


class UIController:
    def __init__(self, queue, store, config, session_factory, diagnostics_factory=None):
        """queue / store / config: 队列、会话存储、配置；session_factory: 无参函数，返回 pending 会话；
        diagnostics_factory: 可选，无参函数，返回 DiagnosticsPage（板侧注入双摄与检测器；
        不传就是票 08 的占位桩，主机测试沿用）。"""
        self.queue = queue
        self.store = store
        self.config = config
        self._session_factory = session_factory
        self._diagnostics_factory = diagnostics_factory
        self.page_name = PAGE_HOME
        self.session = None
        self._home = None
        self._scanning = None
        self._result = None
        self._settings = None
        self._diagnostics = None
        self._history = []

    def _home_page(self):
        if self._home is None:
            self._home = HomePage(self.queue, self.store, self._session_factory)
        return self._home

    def state(self):
        """当前页面的完整状态字典。"""
        if self.page_name == PAGE_HOME:
            return self._home_page().state()
        if self.page_name == PAGE_SCANNING:
            return self._scanning.state()
        if self.page_name == PAGE_RESULT:
            return self._result.state()
        if self.page_name == PAGE_SETTINGS:
            if self._settings is None:
                self._settings = SettingsPage(self.config, self.queue)
            return self._settings.state()
        if self.page_name == PAGE_DIAGNOSTICS:
            if self._diagnostics is None:
                self._diagnostics = self._new_diagnostics()
            return self._diagnostics.state()
        raise ValueError("未知页面: %s" % self.page_name)

    def _switch(self, page, push_history=False):
        if push_history:
            self._history.append(self.page_name)
        self.page_name = page

    # ---- 导航 ----

    def start_scan(self):
        """开始扫描。成功返回 {"started": True, "session": 会话, "message": ""}，否则 started=False 并给出原因。"""
        if self.page_name != PAGE_HOME:
            raise ValueError("只能从待机页开始扫描")
        result = self._home_page().start_scan()
        if result["started"]:
            self.session = result["session"]
            self._scanning = ScanningPage(self.session)
            self._switch(PAGE_SCANNING)
        return result

    def stop(self):
        """停止扫描，冻结结果。"""
        if self.page_name != PAGE_SCANNING:
            raise ValueError("只能在扫描中停止")
        self._scanning.stop()
        self._result = ResultPage(self.session, self.queue)
        self._switch(PAGE_RESULT)

    def save_local(self):
        """结果页点「本地保存」。成功返回 {"saved": True, "next_page": "home", "message": ""}，失败则 saved=False 并给出原因。"""
        if self.page_name != PAGE_RESULT:
            raise ValueError("只能在结果页保存")
        result = self._result.save_local()
        if result["saved"]:
            self._switch(PAGE_HOME)
        return result

    def request_discard(self):
        """结果页点「放弃」第一步：返回确认对话框内容，不改状态。"""
        if self.page_name != PAGE_RESULT:
            raise ValueError("只能在结果页放弃")
        return self._result.request_discard()

    def discard(self, confirmed=False):
        """确认后放弃，回待机页。confirmed 必须是 True，否则抛 DiscardNotConfirmed。"""
        if self.page_name != PAGE_RESULT:
            raise ValueError("只能在结果页放弃")
        self._result.discard(confirmed=confirmed)
        self._switch(PAGE_HOME)

    def open_settings(self):
        """从待机页打开设置。"""
        if self.page_name != PAGE_HOME:
            raise ValueError("只能从待机页打开设置")
        self._switch(PAGE_SETTINGS, push_history=True)

    def open_diagnostics(self):
        """从设置页打开诊断。"""
        if self.page_name != PAGE_SETTINGS:
            raise ValueError("只能从设置页打开诊断")
        self._diagnostics = self._new_diagnostics()
        self._switch(PAGE_DIAGNOSTICS, push_history=True)

    def _new_diagnostics(self):
        if self._diagnostics_factory is not None:
            return self._diagnostics_factory()
        return DiagnosticsPage()

    def diagnostics_open(self):
        """诊断页点「开启预览」（手动开启）。返回 {"started", "message"}。"""
        if self.page_name != PAGE_DIAGNOSTICS:
            raise ValueError("只能在诊断页开启预览")
        return self._diagnostics.open()

    def diagnostics_tick(self, now_ms):
        """主循环在诊断页时调用；返回双摄帧与检测框，或 None（未到 500ms / 未开启）。"""
        if self.page_name != PAGE_DIAGNOSTICS:
            return None
        return self._diagnostics.tick(now_ms)

    def back(self):
        """返回上一页（设置 / 诊断导航栈）。离开诊断页时立即关闭预览，释放采集资源。"""
        if self.page_name == PAGE_DIAGNOSTICS and self._diagnostics is not None:
            self._diagnostics.close()
        if self._history:
            self._switch(self._history.pop())

    # ---- 按钮派发 ----

    def press(self, button_id):
        """按当前页面上的某个按钮。找不到或不在当前页面抛 ValueError。"""
        ids = [b["id"] for b in self.state()["buttons"]]
        if button_id not in ids:
            raise ValueError("按钮 %s 不在 %s 页面上" % (button_id, self.page_name))
        # 特殊映射：discard 按钮对应 request_discard 方法（二次确认第一步）
        if button_id == "discard":
            return self.request_discard()
        # 其他按钮 id 与方法同名，直接派发
        method = getattr(self, button_id, None)
        if method is None:
            raise ValueError("按钮 %s 没有对应的方法" % button_id)
        return method()

    # ---- 代理：未完成会话横幅 ----

    def dismiss_banner(self, session_id):
        self._home_page().dismiss_banner(session_id)

    def view_incomplete(self, session_id):
        return self._home_page().view_incomplete(session_id)

    def discard_incomplete(self, session_id, confirmed=False):
        self._home_page().discard_incomplete(session_id, confirmed=confirmed)

    # ---- 设置页代理 ----

    def set_sample_weight(self, value):
        if self.page_name != PAGE_SETTINGS:
            raise ValueError("只能在设置页修改样品重量")
        return self._settings.set_sample_weight(value)

    def rejected_items(self):
        if self.page_name != PAGE_SETTINGS:
            raise ValueError("只能在设置页查看被拒项")
        return self._settings.rejected_items()

    def clear_saved(self):
        if self.page_name != PAGE_SETTINGS:
            raise ValueError("只能在设置页清空已保存项")
        return self._settings.clear_saved()
