# BeanLens BOX ↔ C6 网络桥协议 v0.1

状态：初稿（2026-10-23），**独立于豆路开闸协议**，仅管理 WiFi/配对/令牌/上报。

---

## 职责边界

### BOX 端（CanMV/MicroPython）
- 维护配对状态、令牌、记录队列（TF 卡持久化）；
- 拥有 UI（640×480 LVGL 触屏）与操作员交互；
- 生成幂等键、记录 JSON、调度队列上传。

### C6 端（ESP-IDF/C）
- 执行 WiFi 连接（WPA2-PSK）；
- 代发 HTTPS 请求到 TasterMatrix API，返 status + body；
- 1.47 寸屏只显示网络状态灯（WiFi/API/令牌/配额）。

**C6 不做**：不理解 TasterMatrix 的业务逻辑、不解析记录 JSON、不做配额判断、不做队列重试决策。

---

## 物理与帧格式

- UART 3.3V，115200 8N1（GPIO 引脚见硬件基线或 BRINGUP）；
- 一行一个 JSON，UTF-8 编码，LF 结束，最大 2048 字节（v1 记录体积预估 <1KB）；
- 分包累积到完整行再解析；粘包逐行处理；
- 超长行丢弃至下一 LF 并记错，不无限扩大缓存；
- 无帧级 CRC（首版走快速验证，若实测噪声多再加）。

---

## 会话与版本

- C6 启动时生成新的桥会话 ID（`bridge_session`，8 位 hex）；BOX 收到 `BRIDGE_READY` 后采用该会话；
- C6 重启 → 新会话；BOX 重启 → 主动 `BRIDGE_HELLO` 询问 C6 当前会话；
- 协议版本 `proto_v` 在 `HELLO`/`READY` 交换，不兼容拒绝工作并提示。

---

## 消息清单

### 双向

| 消息 | 方向 | 作用 |
|---|---|---|
| `BRIDGE_HELLO` | BOX→C6（启动/重启后） | 询问 C6 会话与协议版本 |
| `BRIDGE_READY` | C6→BOX | 回执会话 ID、协议版本、固件版本 |
| `HEARTBEAT` | 双向 | 在线确认与故障广播 |

### WiFi 配网

| 消息 | 方向 | 作用 |
|---|---|---|
| `WIFI_SCAN` | BOX→C6 | 扫描周边 SSID 列表（可选，v1 不做） |
| `WIFI_SCAN_RESULT` | C6→BOX | 返回 SSID 数组 |
| `WIFI_CONNECT` | BOX→C6 | 连接指定 SSID + 密码 |
| `WIFI_STATUS` | C6→BOX | 连接结果：成功（IP+RSSI）/ 失败（原因） |
| `WIFI_DISCONNECT` | BOX→C6 | 主动断开 WiFi（设置页操作） |

### 设备配对与令牌

| 消息 | 方向 | 作用 |
|---|---|---|
| `PAIR_START` | BOX→C6 | 发起配对，取配对码（携带 `device_id`/`model`/`fw`） |
| `PAIR_CODE` | C6→BOX | 返回配对码 + device_code + TTL（5 分钟） |
| `PAIR_POLL` | BOX→C6 | 轮询配对状态（携带 device_code） |
| `PAIR_TOKEN` | C6→BOX | 返回令牌 + refresh token + 用户信息 + 配额（成功）/ PENDING（未确认）/ EXPIRED（超时） |
| `TOKEN_REFRESH` | BOX→C6 | 刷新令牌 |
| `TOKEN_REFRESHED` | C6→BOX | 返回新令牌 + 新 refresh token |

### 记录上报

| 消息 | 方向 | 作用 |
|---|---|---|
| `RECORD_SUBMIT` | BOX→C6 | 上报一条记录（完整 JSON body + access token） |
| `RECORD_RESULT` | C6→BOX | 返回 HTTP status + 完整响应 body（成功/失败） |

### 设备自检

| 消息 | 方向 | 作用 |
|---|---|---|
| `DEVICE_ME` | BOX→C6 | 查询绑定用户/配额余量/服务可达（调 `/api/device/me`） |
| `DEVICE_ME_RESULT` | C6→BOX | 返回用户昵称、配额、绑定状态 |

### 故障

| 消息 | 方向 | 作用 |
|---|---|---|
| `FAULT` | 任一→另一 | 广播异常：WiFi 断开、API 不可达、C6 内存不足、协议解析失败 |

---

## 消息格式示例

### `BRIDGE_HELLO`（BOX→C6）
```json
{"type":"BRIDGE_HELLO","proto_v":"0.1","device_id":"TM0007","fw":"fw@0.9.2"}
```

### `BRIDGE_READY`（C6→BOX）
```json
{"type":"BRIDGE_READY","bridge_session":"a3f1e8c9","proto_v":"0.1","c6_fw":"c6@0.2.1"}
```

### `WIFI_CONNECT`（BOX→C6）
```json
{"type":"WIFI_CONNECT","ssid":"MyWiFi","password":"12345678","seq":1}
```

### `WIFI_STATUS`（C6→BOX）
```json
{"type":"WIFI_STATUS","status":"connected","ip":"192.168.1.42","rssi":-58,"seq":1}
```
或失败：
```json
{"type":"WIFI_STATUS","status":"failed","reason":"AUTH_FAIL","seq":1}
```

### `PAIR_START`（BOX→C6）
```json
{"type":"PAIR_START","device_id":"TM0007","model":"beanlens-k230d-rev1","fw":"fw@0.9.2","seq":2}
```

### `PAIR_CODE`（C6→BOX）
```json
{"type":"PAIR_CODE","pairing_code":"827354","device_code":"dc_a3f1e8c9","ttl_s":300,"seq":2}
```

### `PAIR_POLL`（BOX→C6）
```json
{"type":"PAIR_POLL","device_code":"dc_a3f1e8c9","seq":3}
```

### `PAIR_TOKEN`（C6→BOX）
成功：
```json
{"type":"PAIR_TOKEN","status":"ok","token":"eyJ...","refresh_token":"rt_...","user_name":"张三","quota_used":12,"quota_total":100,"seq":3}
```
未确认：
```json
{"type":"PAIR_TOKEN","status":"pending","seq":3}
```
过期：
```json
{"type":"PAIR_TOKEN","status":"expired","seq":3}
```

### `RECORD_SUBMIT`（BOX→C6）
```json
{"type":"RECORD_SUBMIT","token":"eyJ...","body":{<完整记录 JSON，按 §5.2 格式>},"seq":10}
```

### `RECORD_RESULT`（C6→BOX）
成功：
```json
{"type":"RECORD_RESULT","status":200,"body":{"code":0,"message":"ok","data":{"record_id":"rec_...","quota":{"remaining":88},"...":"..."}},"seq":10}
```
失败：
```json
{"type":"RECORD_RESULT","status":400,"body":{"code":"VALIDATION_ERROR","message":"defects 缺少 full_black 键"},"seq":10}
```

### `HEARTBEAT`（双向）
```json
{"type":"HEARTBEAT","uptime_s":3821,"free_heap_kb":42}
```

### `FAULT`（任一→另一）
```json
{"type":"FAULT","reason":"WIFI_LOST","detail":"连接断开"}
```

---

## 序号与幂等

- BOX 端为每条需要响应的指令分配单调递增 `seq`；C6 回执时原样返回 `seq`；
- 相同 `seq` 重复到达 → C6 返回已有响应（缓存最近 10 条）；
- C6 响应超时（默认 30s）→ BOX 标记网络异常，UI 提示。

---

## 实现前待补全

1. 错误码枚举（WiFi 失败原因、API 错误分类）；
2. `RECORD_SUBMIT` 的 body 大小上限（v1 无图，预估 <1KB；P2 加图后要分段或走独立通道）；
3. HTTPS 证书校验由 C6 负责（CA 证书由 C6 固件内置或从 BOX 下发）；
4. 心跳超时策略：C6 断线多久 BOX 才报"网络不可用"？
5. C6 内存不足时拒收策略（最大排队请求数）。

---

## 与豆路开闸协议的关系

本协议**不管理**豆路开闸/称重/机械动作。那些由 `PROTOCOL-v0.1-DRAFT.md` 的 `GRANT`/`CLOSED`/`RESULT`/`WEIGHT`/`FINAL` 负责，两个协议并行运行，不互相依赖（C6 物理上有两个 UART 或一个 UART 多路复用，联调时确认）。
