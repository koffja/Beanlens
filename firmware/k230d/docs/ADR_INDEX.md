# 架构决策记录（ADR）索引

票 08 期间确认的架构决策，作为后续开发（票 09 LVGL 渲染、票 10 上板集成）的稳定接口契约。

## ADR-0001：预览计点只用于屏显，不写进记录体

**背景**：点数当量规则可能变更，已保存的记录需要用最新规则重算。

**决策**：
- 结果页显示「预览计点」和「临时规则」角标，明确告知用户这不是最终成绩
- 记录体（queue / saved / report）只保存 16 类原始计数，不写 `preview_points`、`grade`、`rule_version` 等派生字段
- 服务端收到记录后用最新规则计算最终点数与等级

**依据**：test_ui_result.py::test_save_local_record_has_no_points_or_grade

---

## ADR-0002：16 类之和不得大于豆粒总数

**背景**：每颗豆只能计入一个瑕疵类别，配对不明不计入任何类别。

**决策**：
- 保存前检查 `sum(defect_counts.values()) + unpaired_count <= bean_count_total`
- 自检失败时不入队，停留在结果页并显示「计数不自洽，请联系技术支持」
- 这是计数链路 bug 的兜底，不应出现在正常流程

**依据**：
- test_ui_result.py::test_inconsistent_counts_block_saving_and_show_the_reason
- test_scan_session.py::test_sixteen_plus_unpaired_must_not_exceed_the_total

---

## ADR-0003：结果已冻结，补豆只能新开会话

**背景**：早期原型曾有「继续扫描」功能，但会导致时间戳和中间快照语义混乱。

**决策**：
- 停止扫描后会话进入 `result_ready`，计数永久冻结
- 结果页只有「本地保存」「放弃」两个按钮，没有「继续扫描」
- 样品不足时用户应放弃当前会话，补齐样品后重新开始

**依据**：
- test_ui_result.py::test_there_is_no_continue_scanning_entry
- test_ui_result.py::test_exactly_save_and_discard_buttons

---

## ADR-0004：UI 逻辑层与业务层完全解耦

**背景**：测试覆盖率和代码可移植性要求。

**决策**：
- 业务模块（app/core）不导入 UI 模块（app/ui）
- UI 模块不导入硬件模块（lvgl / machine / sensor / media / nncase / network）
- UI 层通过工厂函数、依赖注入获取会话对象，不直接创建硬件资源

**依据**：
- test_ui_flow.py::BoundaryTest（7 个约束测试）
- test_ui_flow.py::test_core_modules_load_without_pulling_in_the_ui_package

---

## ADR-0005：扫描中页无相机预览，诊断页 2fps 静态抓帧

**背景**：K230D 算力有限，推理与实时预览同开会拖慢扫描。

**决策**：
- 扫描中页只显示 3 个大数字（豆粒总数 / 瑕疵豆总数 / 配对不明），无相机预览
- 诊断页提供双摄静态抓帧预览（2fps）与检测框叠加，用于对准检查和光照调试
- 诊断页在票 10 上板时补全，票 08 只放占位方法签名

**依据**：
- test_ui_scanning.py::test_no_camera_preview_anywhere_in_state
- test_ui_settings.py::test_preview_rate_is_two_fps_per_architecture

---

## ADR-0006：v1 不含联网入口

**背景**：WiFi 配网、账号绑定、二维码扫描留给 v2。

**决策**：
- UI 所有模块不含 `wifi` / `ssid` / `password` / `qrcode` / `bind` / `pair` / `配对` / `绑定` 等关键词
- 待机页和设置页不提供配网或绑定按钮
- 队列触顶时提示「恢复网络后再扫描」只是占位文案，v1 用户需手动清理

**依据**：
- test_ui_settings.py::test_settings_has_no_network_or_pairing_entry
- test_ui_flow.py::BoundaryTest::test_ui_code_has_no_wifi_pairing_or_binding_entry

---

## 后续票据

- **票 09**：LVGL 渲染层，消费上述 state() 字典绘制 UI
- **票 10**：上板集成，接入双摄采集、模型推理、checkpoint 节奏和诊断预览
