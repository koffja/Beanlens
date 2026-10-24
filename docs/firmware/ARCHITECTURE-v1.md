# BeanLens BOX 固件架构总览 v1

文档版本：0.2（2026-10-24，v1 不含 C6 桥/配网/配对/真实上报；实现顺序以 .scratch 票据为准）
固件目标版本：v1 联调期（P1–P2）

---

## 一、目标与约束

### 交付目标
- 在 K230D BOX 上验证：双摄采集 → 配对 → 16 类计数 → 本地保存 → 队列的完整闭环（v1 无网络）；
- 操作员通过 640×480 触屏完成：开始扫描 → 停止 → 查看结果 → 本地保存或放弃；
- 断电/崩溃后能恢复队列和未完成会话，不丢记录。

### 已知简化（ADR 0005）
- v1 无批次关联、无证据图、无实时相机预览、无二维码配对、无 softAP；
- v1 无 C6 网络桥、无配网、无配对、无实际上报（队列管理在本地 mock 环境完整验证）；
- 扫描结果只保存为本地 JSON（16 类计数 + 元数据），不传图；P2 起才上报。

### 硬件约束（BRINGUP）
- K230D BOX 自身无 WiFi，C6 网络桥延后实施（ADR 0003 v1 不做）；
- 双摄 CSI1/CSI2 非硬同步，配对靠时间戳+轨迹（ADR 0002）；
- TF 卡持久化：队列、配置、未完成会话；
- CanMV 1.3 + LVGL，屏分辨率 640×480。

---

## 二、分层架构

```
┌─────────────────────────────────── UI 层（LVGL） ──────────────────────────────────┐
│  待机页 │ 扫描中页 │ 结果确认页 │ 设置页 │ 队列管理页 │ 诊断页（双摄预览）            │
└──────────────────────────────────────┬─────────────────────────────────────────────┘
                                       │
┌─────────────────────────────────── 业务层（Python） ────────────────────────────────┐
│  scan_session.py      会话状态机：待机/扫描中/结果待确认/已放弃/已保存              │
│  queue.py             队列管理：持久化/加载/重试退避/状态转换/容量阈值               │
│  report.py            上报编排（mock版）：本地测试桩验证队列逻辑                     │
│  counting.py          计数逻辑：豆粒总数/瑕疵分类/配对不明/预览计点（SCA规则）      │
│  config_manager.py    配置读写：样品重量/批次默认/队列路径                          │
└──────────────────────────────────────┬─────────────────────────────────────────────┘
                                       │
┌─────────────────────────────────── 采集层（Python + K230 SDK） ─────────────────────┐
│  capture.py           双摄管理：CSI1/CSI2 连拍触发、ROI 队列、帧时间戳              │
│  pairing.py           时空配对：时间戳容差ΔT、track 一对一消费、配对不明计数        │
│  detection.py         推理调度：YOLOv8n 16 类检测、批量推理、NMS/track ID 关联      │
│  preprocessing.py     裁剪/清晰度：对配对成功豆裁剪 ROI、拉普拉斯方差排序          │
└─────────────────────────────────────────────────────────────────────────────────────┘
```

---

## 三、核心模块职责

### 3.1 UI 层（`ui/`）

**待机页** `ui/home.py`
- 显示：剩余配额占位（"v1 本地验证"）、队列积压条数；
- 大按钮：「开始扫描」/ 「设置」；
- 启动时检测未完成会话 → 横幅提示"上次扫描未完成（12:31，约 340 颗），查看 / 丢弃"。

**扫描中页** `ui/scanning.py`
- 三个大数字：豆粒总数、瑕疵豆总数、配对不明；
- 大按钮：「停止」（红色）；
- 无实时相机预览（ADR 0005，避管线冲突）。

**结果确认页** `ui/result.py`
- 豆粒总数 / 瑕疵豆总数 / 一类瑕疵点数 / 二类瑕疵点数 / 预览计点（带"临时规则"角标）；
- 16 类分组列表（一类 6 项 / 二类 10 项），默认只显示非零项，零项折叠（可展开）；
- 底部按钮：「本地保存」（绿）「放弃」（灰，二次确认）。

**设置页** `ui/settings.py`
- 样品重量（默认 350g，范围 300–400）；
- 队列管理入口：积压条数、清空已保存、查看被拒项；
- 诊断入口：手动开启双摄预览（静态抓帧，2fps）。

**队列管理页** `ui/queue.py`
- 列表：待处理 / 本地已保存 / 被拒（mock 模拟 400/403），每项显示时间戳、豆粒数、状态；
- 操作：查看详情、删除、全部重试（模拟场景）。

**诊断页** `ui/diagnostics.py`
- 左右分屏：CSI1（前摄）/ CSI2（后摄）各 2fps 静态刷新；
- 显示当前检测框（瑕疵类别 + 置信度）；
- 仅供装调，平时不进入。

---

### 3.2 业务层（`core/`）

**会话状态机** `core/scan_session.py`
```python
class ScanSession:
    状态：pending / scanning / result_ready / discarded / queued / saved / incomplete
    数据：
      - session_id: 会话唯一标识（本地生成）
      - operation_id: 幂等键（K230D:<device_id>:scan:<8位hex>）
      - start_time / end_time / duration_s
      - bean_count_total / defect_counts[16] / unpaired_count
      - sample_weight_g
      - captured_at（Unix 秒）
      - checkpoint_file（JSON 持久化路径）
    
    方法：
      - start() → 生成 operation_id + session_id、启动计时
      - update_counts(bean_total, defects, unpaired) → checkpoint 触发（30颗/5秒）
      - stop() → 冻结计数、计算 duration_s、状态→result_ready
      - discard() → 二次确认后状态→discarded、保留 7 天
      - to_record_json() → 按 §5.2 格式生成完整记录 JSON（v1 本地保存）
      - from_checkpoint(path) → 断电恢复（恢复为 incomplete 或 result_ready）
```

**队列管理** `core/queue.py`
```python
class SubmissionQueue:
    持久化：~/.beanlens/queue/*.json（每条记录一个文件）
    状态枚举：pending / saving / saved / failed_retriable / failed_rejected（模拟网络场景）
    
    每项：
      - operation_id（文件名 prefix）
      - record_json（完整 body）
      - state / retry_count / last_attempt_at / error_code / error_message
      - created_at
    
    方法：
      - enqueue(session: ScanSession) → 写文件、标 pending
      - next_pending() → 返回最早的 pending 项
      - mark_saving(operation_id)
      - mark_saved(operation_id, record_id) → 改状态、删 record_json（只留元数据）
      - mark_failed(operation_id, http_status, error) → 按状态码分类（模拟）：400/403→rejected，429/5xx→retriable
      - retry_backoff(operation_id) → 指数退避：30s * 2^retry_count，上限 15min
      - list_rejected() → 列出所有 failed_rejected 项供 UI 显示
      - purge_saved() → 删除已保存元数据（仅保留最近 50 条）
      - capacity_check() → 返回 (count, total_size_mb)，触顶时阻断新扫描
```

**上报编排（mock版）** `core/report.py`
```python
class ReportOrchestrator:
    依赖：SubmissionQueue / MockSubmitClient
    
    方法：
      - submit_next() → 主循环入口（本地测试桩）：
          1. queue.next_pending()
          2. mock_client.submit(record_json) → 模拟 200/400/403/429/5xx
          3. 解析响应：200→mark_saved / 400→mark_failed_rejected / 429/5xx→mark_failed_retriable
          4. 返回结果供 UI 显示
      - background_worker() → 独立线程/协程，每 10s 调一次 submit_next()（可选，验证后台逻辑）
```

**计数与规则** `core/counting.py`
```python
# 当量不写死在代码里：从 app/config/rules_sca_provisional.json 读取（见 §6）。
# 值为整数比例 N，表示 N 颗 = 1 个 full defect（ADR 0001，规则版本 sca-provisional）：
#   类别一：full_black / full_sour / pod_dried_cherry / fungus / foreign_matter = 1，insect_severe = 5
#   类别二：partial_black / partial_sour = 3；parchment / floater / immature / withered /
#           shell / broken_chipped / hull_husk = 5；insect_mild = 10

def load_rules(path=None) -> dict
def preview_points(defect_counts, rules=None) -> dict
    """返回 {rule_version, provisional, provisional_label, category1_points,
    category2_points, preview_points}。仅供屏显参考，不进记录体，不含等级。"""
```

---

### 3.3 采集层（`capture/`）

---

## 四、数据持久化

| 路径 | 内容 | 落盘时机 | 清理规则 |
|---|---|---|---|
| `~/.beanlens/config.json` | 样品重量默认、队列路径 | 设置页保存后 | 永久保留 |
| `~/.beanlens/queue/<operation_id>.json` | 每条记录：JSON body + 状态 + 重试计数 | 会话停止、状态变更时 | 保存成功后删 body 留元数据；被拒留 30 天 |
| `~/.beanlens/sessions/incomplete/<session_id>.json` | 未完成会话 checkpoint | 每 30 颗/5 秒 | 最多 20 条滚动删除 |
| `~/.beanlens/sessions/discarded/<session_id>.json` | 已放弃会话 | 放弃确认时 | 7 天后删除 |

**原子写入**：临时文件 + rename；覆写中断会得到半个 JSON，原子替换保证"要么旧要么新"（ADR 0004）。

---

## 五、启动流程

```
1. 读 config.json → 样品重量 / 队列路径（缺失用默认值）
2. 扫描 sessions/active/ → 上次非正常退出的会话转为 incomplete
3. 校验 queue/ 各条记录，必要时用 .prev 恢复
4. 清理过期项：discarded 超 7 天、incomplete 超 20 条
5. 初始化 UI → 显示待机页（有 incomplete 会话则显示横幅）
6. （可选）启动 ReportOrchestrator.background_worker() 驱动 mock 客户端
7. 进入 LVGL 主循环
```

---

## 六、关键配置文件

### `config/capture_config.json`
```json
{
  "csi1": { "width": 640, "height": 480, "fps": 30 },
  "csi2": { "width": 640, "height": 480, "fps": 30 },
  "roi_queue_max": 3,
  "roi_size_max": [320, 320],
  "time_pair_tolerance_ms": null,
  "motion_threshold": 25,
  "trigger_cooldown_ms": 50
}
```

### `config/rules_sca_provisional.json`（预览计点用）
```json
{
  "rule_version": "sca-provisional",
  "equivalents": {
    "full_black": 1, "full_sour": 1, "pod_dried_cherry": 1, "fungus": 1, "foreign_matter": 1, "insect_severe": 5,
    "partial_black": 3, "partial_sour": 3, "parchment": 5, "floater": 5, "immature": 5,
    "withered": 5, "shell": 5, "broken_chipped": 5, "hull_husk": 5, "insect_mild": 10
  },
  "category1": ["full_black", "full_sour", "pod_dried_cherry", "fungus", "foreign_matter", "insect_severe"],
  "category2": ["partial_black", "partial_sour", "parchment", "floater", "immature", "withered", "shell", "broken_chipped", "hull_husk", "insect_mild"]
}
```

---

## 七、实现顺序建议

实现顺序与依赖以 `.scratch/beanlens-v1-firmware/issues/` 的 12 张票为准：
先 01（假会话落盘），再 02/03/04（状态机、计数、配对核心，可并行），再 05（队列与 mock 客户端）、08（界面骨架）；
06/07/09/10/11/12 需要上板。周期估算见 `NEXT_STEPS.md`。

---

## 八、测试用例基线

### 功能测试
- [ ] 扫描：开始、计数累加、停止冻结、放弃二次确认；
- [ ] 本地保存：成功入队、mock 返回 400 拒收、403 配额用尽、429/5xx 退避重试；
- [ ] 队列：持久化、重试退避、容量触顶阻断；
- [ ] 断电恢复：未完成会话提示、队列完整恢复。

### 边界测试
- [ ] 16 类全 0（合法）；
- [ ] 单类 >30%（打标不拒收）；
- [ ] 配对不明 >20%（屏上提示）；
- [ ] sum(16 类) > bean_count_total（固件自检拒绝保存）；
- [ ] 队列 100 条（触顶）。

---

## 九、未决事项

1. **时间配对容差 `ΔT` 的实测标定值**（ADR 0002 初值 = 2 帧间隔，实测后写入 `capture_config.json`）；
2. **数豆模型训练与集成时间线**（ADR 0002 目标态，不阻断 P1 但 P2 前必须完成）；
3. **SCA 当量表已核对确认**（2026-10-24，ADR 0001）；规则版本串仍为 sca-provisional，落库点值由平台重算；
4. **C6 物理接线**：v1 不做，延后 P2 评估（ADR 0003）；
5. **队列容量 100 条与 500MB 的合理性**（v1 无图，500MB 预留；若实测 TF 卡更小，降到 200MB）。
