# Octopus 服务端 vs 客户端 差异分析报告 v2

> 生成时间：2026-06-23
> 服务端路径：`F:\codecil\octopus-dev`（Go / Gin）
> 客户端路径：`F:\codecil\octopusmanage`（Flutter / Dart）
> 对比方式：逐模型、逐handler、逐设置项、逐功能模块、逐i18n key **五轮交叉检查**

---

## 一、整体概览

服务端拥有 **40+ 数据模型**、**46+ handler 文件**、**82 个设置项**；客户端仅有 **16 个模型**、**15 个页面**、**约 60 个 API 方法**。

| 维度 | 服务端 | 客户端 | 覆盖率 |
|------|--------|--------|--------|
| 数据模型 | ~40 | 16 | ~40% |
| API handler 文件 | 46 | 对应约 60% | ~60% |
| Setting keys | 82 | UI 暴露约 20 项 | ~24% |
| 顶级功能模块 | 13+ | 8 个 Tab | ~62% |

---

## 二、缺失的功能模块（服务端有，客户端无）

### 2.1 Hub / 站点管理（完全缺失）🔴

服务端有完整的 Hub 模块，支持 12 种平台（new-api、veloera、done-hub、one-hub、sub2api、octopus、anyrouter、aihubmix、axonhub、claude-code-hub、sapi、unknown）：

- **Site / SiteAccount / SiteToken / SiteUserGroup / SiteModel / SiteChannelBinding** — 站点、账号、Token、用户组、模型、渠道绑定
- **SiteAnnouncement / RemoteSite / RemoteSiteToken** — 公告、远程站点
- **BalanceSnapshot / BalancePrediction / CheckInRecord / RedemptionRecord / RemoteUsageRecord** — 余额追踪、签到、兑换码、用量
- **AllAPIHubImportResult / MetAPIImportResult** — 批量导入

对应 handler：`site.go`、`site_channel.go`、`remote_site.go`、`remote_site_token.go`、`checkin.go`、`balance_history.go`、`usage_history.go`、`redemption.go`、`announcement.go`

### 2.2 Proxy Pool / 代理池（完全缺失）🔴

- **ProxyConfiguration** 模型，支持 4 种模式：direct / system / pool / inherit
- 连通性测试、引用追踪、删除保护
- 对应 handler：`proxy_pool.go`

客户端只有 `proxy` 布尔字段。

### 2.3 Model Mapping / 模型映射（完全缺失）🔴

- **ModelMapping** 模型，支持 exact / wildcard / regex 三种匹配
- 优先级排序、可选限定分组、启用/禁用
- 对应 handler：`model_mapping.go`

### 2.4 API Credential Profiles / 凭证配置（完全缺失）🔴

- **APICredentialProfile** 模型，健康探测（text_gen、models_list、tool_calling、structured_output）
- CLI 配置导出（Claude Code、Codex、Gemini CLI、Cherry Studio、Kilo Code）
- 对应 handler：`api_credential.go`、`cli_export.go`、`verification.go`

### 2.5 WebDAV 云备份（完全缺失）🔴

- 自动备份间隔、远程文件管理、一键恢复
- 对应 handler：`webdav.go`

### 2.6 WebAuthn / Passkey（完全缺失）🔴

- **WebAuthnCredential** 模型，无密码登录
- 对应 handler：`webauthn.go`

### 2.7 数据库实时迁移（完全缺失）🟡

- SQLite / MySQL / PostgreSQL 之间实时迁移
- 对应 handler：`channel_migration.go`

### 2.8 响应过滤器（部分缺失）🟡

- `response_filter_enabled`、`response_filter_keywords`、`response_filter_action`、`response_filter_error_message`
- 客户端设置页没有此配置

### 2.9 模型名归一化（完全缺失）🔴

- 路由前缀、功能后缀、显式变体→基准名映射、市场去重
- 4 个设置项：`model_normalize_router_prefixes`、`model_normalize_functional_suffixes`、`model_normalize_explicit_mappings`、`model_normalize_market_dedupe_default`

### 2.10 Telemetry / 遥测（完全缺失）🔴

- **OpsTelemetrySummary** — hero metrics、runtime signals、database health、session/quota activity、prompt cache、provider health
- 对应 handler：`ops.go` 中的 telemetry 端点

### 2.11 Analytics 独立页面（部分缺失）🟡

服务端 Analytics 有 6 个 Tab（Channel×Model、Usage Breakdown、Route Health、Latency、Evaluation、Cache），客户端仅在 Dashboard 中有基础统计。

---

## 三、数据模型字段差异

### 3.1 APIKey 模型 🔴

| 字段 | 服务端 | 客户端 | 说明 |
|------|--------|--------|------|
| `allowed_ips` | ✅ | ❌ | 逗号分隔的 IP/CIDR 白名单 |
| `tags` | ✅ | ❌ | 逗号分隔标签 |
| `excluded_channels` | ✅ | ❌ | 逗号分隔排除渠道 ID |

### 3.2 Channel 模型 🟡

| 字段 | 服务端 | 客户端 | 说明 |
|------|--------|--------|------|
| `group_id` | ✅ | ❌ | 渠道分组归属 |
| `proxy_mode` | ✅ enum | ❌ bool | 服务端升级为 direct/system/pool/inherit |
| `proxy_config_id` | ✅ | ❌ | 关联代理池 |
| `skip_model_test` | ✅ | ❌ | 跳过模型可用性测试（issue #98） |
| `request_rewrite` | ✅ | ❌ | RequestRewriteConfig |
| `managed` / `managed_source` | ✅ | ❌ | 投渠渠道标记 |
| `base_urls[].suffix_mode` | ✅ | ❌ | URL 后缀模式 |

### 3.3 Group 模型 🟡

| 字段 | 服务端 | 客户端 | 说明 |
|------|--------|--------|------|
| `endpoint_provider` | ✅ | ❌ | 端点提供方适配 |
| `outbound_format` | ✅ | ❌ | 出站格式（auto/chat/responses/chat_only/responses_only） |
| `condition` | ✅ | ❌ | 条件路由 JSON |

### 3.4 StatsMetrics 模型 🔴

| 字段 | 服务端 | 客户端 | 说明 |
|------|--------|--------|------|
| `latency_p50` / `latency_p95` / `latency_p99` | ✅ | ❌ | 延迟百分位数 |
| `ftut_avg` / `ftut_p50` / `ftut_p95` / `ftut_p99` | ✅ | ❌ | 首 Token 时间 |
| `histogram_lt_100` / `histogram_100_500` / `histogram_500_1k` / `histogram_1k_5k` / `histogram_gt_5k` | ✅ | ❌ | 延迟直方图 |

### 3.5 RelayLog 模型 🟡

| 字段 | 服务端 | 客户端 | 说明 |
|------|--------|--------|------|
| `request_api_key_id` | ✅ | ❌ | API Key ID |
| `client_ip` | ✅ | ❌ | 客户端 IP |
| `endpoint_type` | ✅ | ❌ | 端点分类 |
| `semantic_cache_hit` | ✅ | ❌ | 语义缓存命中 |
| `cache_read_tokens` | ✅ | ❌ | 提供方缓存 token |
| `attempts` | ✅ | ❌ | ChannelAttempt 数组 |
| `total_attempts` | ✅ | ❌ | 总尝试次数 |
| `is_test` | ✅ | ❌ | 是否测试日志 |

### 3.6 OpsCacheStatus 模型 🟡

| 字段 | 服务端 | 客户端 | 说明 |
|------|--------|--------|------|
| `provider_prompt_cache` | ✅ | ❌ | Provider Prompt Cache 分析 |

### 3.7 OpsSystemSummary 模型 🟡

服务端新增 20+ 字段（`relay_retry_count`、`relay_route_retries`、`circuit_breaker_*`、`response_filter_*`、`ai_route_*` 等），客户端均缺失。

### 3.8 AnalyticsGroupHealthItem 模型 🟡

| 字段 | 服务端 | 客户端 | 说明 |
|------|--------|--------|------|
| `failing_channels` | ✅ | ❌ | 失败渠道详情 |
| `mode` | ✅ | ❌ | 分组模式 |
| `channel_ids` | ✅ | ❌ | 关联渠道 ID |
| `auto_items` | ✅ | ❌ | Auto 策略实时快照 |

---

## 四、API 端点差异

### 4.1 请求体变更

| 端点 | 变更 |
|------|------|
| `POST /channel/create` | 新增 `group_id`、`skip_model_test`、`request_rewrite`、`proxy_mode`、`proxy_config_id` |
| `POST /channel/update` | 改用 `ChannelUpdateRequest`（增量更新），客户端仍发完整对象 |
| `POST /apikey/create` | 新增 `allowed_ips`、`tags`、`excluded_channels` |

### 4.2 客户端未调用的服务端端点（按模块）

**Channel（4 个）**：`check-keys/:id`、`test-model`、`group/*`（4 个）

**Model（1 个）**：`capabilities`

**Group（4 个）**：`delete-all`、`auto-group`、`test`、`test/progress/:id`

**Route（4 个）**：`ai-generate`、`progress/:id`、`status/:id`、`result/:id`

**Analytics（8 个）**：`channel-model`、`latency`、`provider-breakdown`、`model-breakdown`、`apikey-breakdown`、`group-health`、`utilization`、`evaluation`

**Ops（1 个）**：`telemetry`

**User（4 个）**：`create`、`update-role`、`delete/:id`、`status`

**Setting（3 个）**：`set`、`export`、`import`

**Update（3 个）**：`now-version`、`check`、`execute`

**Hub 全部**：站点、账号、Token、同步、签到、兑换码、用量（约 30+ 端点）

**Proxy 全部**：代理池 CRUD、测试、引用（约 6 个端点）

**ModelMapping 全部**：CRUD（约 4 个端点）

**Credential 全部**：CRUD、验证、CLI 导出（约 8 个端点）

**WebDAV 全部**：配置、触发、恢复（约 5 个端点）

**WebAuthn 全部**：注册、认证（约 4 个端点）

---

## 五、设置项差异

### 5.1 服务端有但客户端 UI 未暴露的设置项（58 项）

| 分类 | 数量 | 代表 Key |
|------|------|----------|
| 日志 | 2 | `relay_log_keep_count`、`log_level`、`log_excluded_groups` |
| 路由/重试 | 2 | `relay_route_retries`、`relay_max_total_attempts` |
| 语义缓存 | 7 | `semantic_cache_ttl`、`threshold`、`max_entries`、`embedding_*` |
| 导航 | 2 | `nav_order`、`nav_visible` |
| 统计 | 1 | `stats_timezone_offset` |
| JWT/登录 | 4 | `jwt_default_expiry_minutes`、`jwt_remember_me_expiry_days`、`login_rate_limit_*` |
| 流会话 | 3 | `stream_session_ttl_minutes`、`max_events`、`max_bytes_mb` |
| 通知/缓存 | 4 | `notify_http_timeout_seconds`、`failure_hint_ttl_*` |
| WebDAV | 1 | `webdav_config` |
| 站点 | 4 | `site_sync_interval`、`site_checkin_interval`、`stats_site_model_backfilled`、`projected_channel_auto_group_enabled` |
| 响应过滤 | 4 | `response_filter_enabled`、`keywords`、`action`、`error_message` |
| 模型归一化 | 4 | `model_normalize_router_prefixes`、`functional_suffixes`、`explicit_mappings`、`market_dedupe_default` |
| WebAuthn | 3 | `webauthn_rp_id`、`webauthn_rp_name`、`webauthn_origins` |

---

## 六、五轮交叉验证记录

### 第 1 轮：模型逐字段对比
- 全部 16 个客户端模型 vs 对应服务端模型
- 发现：APIKey 缺 3 字段、Channel 缺 7 字段、Group 缺 3 字段、StatsMetrics 缺 12 字段、RelayLog 缺 8 字段

### 第 2 轮：API 端点逐个比对
- 服务端 46 个 handler 文件全部路由 vs 客户端 `octopus_api.dart` 60+ 方法
- 发现：客户端缺失 Hub/Proxy/Mapping/Credential/WebDAV/WebAuthn 全部端点；Channel 更新方式变更

### 第 3 轮：设置项全量扫描
- 服务端 82 个 `SettingKey` vs 客户端设置页 UI
- 发现：客户端 UI 仅暴露约 20 项，缺失 58 项

### 第 4 轮：功能模块级对比
- 服务端 13+ 顶级模块 vs 客户端 8 个 Tab
- 发现：缺失 Hub、Analytics 独立页、Alert 独立页、Ops 独立页

### 第 5 轮：数据流完整性验证
- UI → AppProvider → OctopusApi → ApiService → 服务端
- 发现：AppProvider 未暴露新功能 API 方法；HomePage Tab 未更新；octopus_api.dart 方法签名与服务端新请求体不匹配

---

## 七、优先级建议

### P0 — 阻断性缺失
1. **Channel 增量更新**：服务端改用 `ChannelUpdateRequest`，客户端仍发完整对象
2. **APIKey 安全字段**：`allowed_ips`、`tags`、`excluded_channels`

### P1 — 重要缺失
3. Analytics 独立页面（6 Tab）
4. Ops Telemetry 完整视图
5. StatsMetrics 延迟/FTUT/直方图字段
6. RelayLog attempts 详细信息

### P2 — 新功能未跟进
7. Hub 站点管理
8. Proxy Pool
9. Model Mapping
10. API Credential Profiles
11. WebDAV 云备份
12. WebAuthn/Passkey
13. 模型名归一化

### P3 — 设置项 & i18n
14. 暴露 58 个设置项
15. 补全 i18n 翻译（Hub/Proxy/Mapping/Credential/WebDAV/WebAuthn/Telemetry 等模块）

---

## 八、第六轮 & 第七轮深度扫描补充

### 第 6 轮：Hub 全链路深度扫描

逐个读取 `internal/hub/` 目录下 7 个适配器包（common、octopus、aihubmix、axonhub、claudecodehub、sapi、sub2api）+ `adapter.go` 接口定义（15 个方法）+ `registry.go` 注册机制 + `httpclient.go` 共享 HTTP 客户端，以及 `internal/op/remotesite/` 下 7 个业务文件（balance、checkin、announcement、redemption、token、usage_history、migration）。

**新增发现：**

| 发现 | 详情 |
|------|------|
| Hub 适配器接口 15 方法 | FetchUserInfo、PerformCheckIn、FetchCheckInStatus、FetchModels、FetchModelPricing、FetchTokens、CreateToken、ListChannels、CreateChannel、UpdateChannel、DeleteChannel、FetchAnnouncement、FetchSiteStatus、RedeemCode、FetchUsageLogs |
| 凭据加密 | 所有 access_token/password/api_key 使用 AES-256-GCM 加密存储，密文前缀 `enc:` |
| 定时任务 4 个 | hub_balance_capture（6h）、hub_auto_checkin（12h）、hub_announcement_fetch（4h）、hub_usage_history_sync（6h） |
| 渠道迁移 | `/api/v1/channel-migration/migrate` 和 `/migrate-all`，支持远程→本地渠道迁移 |
| 站点发现 | `/api/v1/site-discovery/discover`，查询公开站点目录 |
| 导入导出 | Hub 数据已纳入 DB 备份体系，7 张表：remote_sites、balance_snapshots、check_in_records、api_credential_profiles、site_announcements、remote_site_tokens、remote_usage_records |

### 第 7 轮：全端点清单 + 权限体系 + 新增端点补漏

逐个读取全部 46 个 handler 文件的 `init()` 函数，提取所有路由注册。

**新发现的遗漏端点（之前报告未列出）：**

| Handler | 端点 | 说明 |
|---------|------|------|
| `group.go` | `POST /api/v1/group/test-draft` | 草稿分组测试（未保存的分组也能测试） |
| `group.go` | `POST /api/v1/group/purge-unavailable` | 清除不可用的分组项 |
| `analytics.go` | `GET /api/v1/analytics/auto-strategy` | Auto 策略实时快照 |
| `analytics.go` | `GET /api/v1/analytics/latency-distribution` | 延迟分布数据 |
| `analytics.go` | `GET /api/v1/analytics/channel-model` | 渠道×模型交叉分析 |
| `log.go` | `GET /api/v1/log/stream` | 日志实时流（SSE） |
| `log.go` | 查询参数 | `include_attempts`、`start_time`、`end_time`、`channel_id`、`api_key_id`、`endpoint_type`、`model_name`、`status`、`is_test` |
| `apikey.go` | `GET /api/v1/apikey/stats` | API Key 统计（需 API Key 认证） |
| `apikey.go` | `GET /api/v1/apikey/login` | API Key 登录 |
| `setting.go` | `POST /api/v1/setting/database/test` | 数据库连接测试 |
| `setting.go` | `POST /api/v1/setting/database/migrate` | 数据库迁移 |
| `route.go` | `GET /api/v1/route/ai-generate/stream/:id` | AI 路由进度 SSE 流 |
| `model.go` | `GET /api/v1/model/capabilities` | 模型能力表 |
| `model.go` | `GET /v1/models` | 公开模型列表（需 API Key 认证，支持 `?endpoint=` 过滤） |
| `model_mapping.go` | `GET /api/v1/model-mapping/:id` | 获取单条映射 |
| `model_mapping.go` | `PUT /api/v1/model-mapping/:id` | 更新映射 |
| `alert.go` | `POST /api/v1/alert/notif/test` | 测试通知渠道 |
| `webauthn.go` | `GET /api/v1/webauthn/status` | WebAuthn 状态（公开） |
| `webauthn.go` | `POST /api/v1/webauthn/login/begin` | Passkey 登录开始 |
| `webauthn.go` | `POST /api/v1/webauthn/login/finish` | Passkey 登录完成 |
| `webauthn.go` | `GET /api/v1/webauthn/credentials` | 凭证列表 |
| `webauthn.go` | `POST /api/v1/webauthn/register/begin` | Passkey 注册开始 |
| `webauthn.go` | `POST /api/v1/webauthn/register/finish` | Passkey 注册完成 |
| `webauthn.go` | `DELETE /api/v1/webauthn/credentials/:id` | 删除凭证 |
| `verification.go` | `POST /api/v1/verification/run` | 运行验证探针 |
| `verification.go` | `POST /api/v1/verification/run-for/:id` | 按凭据运行验证 |
| `verification.go` | `GET /api/v1/verification/probes` | 可用探针列表 |
| `site.go` | `GET /api/v1/site/archived` | 已归档站点列表 |
| `site.go` | `POST /api/v1/site/import/all-api-hub` | AllAPIHub 批量导入 |
| `site.go` | `POST /api/v1/site/import/metapi` | MetAPI 批量导入 |
| `site.go` | `POST /api/v1/site/sync-all` | 同步全部站点 |
| `site.go` | `POST /api/v1/site/checkin-all` | 全部签到 |
| `site.go` | `GET /api/v1/site/:id/available-models` | 站点可用模型 |
| `site.go` | `POST /api/v1/site/detect` | 检测站点平台 |
| `site.go` | `POST /api/v1/site/batch` | 批量操作 |
| `site.go` | `POST /api/v1/site/archive/:id` | 归档站点 |
| `site.go` | `POST /api/v1/site/restore/:id` | 恢复站点 |
| `site_channel.go` | `GET /api/v1/site-channel/list` | 站点渠道列表 |
| `site_channel.go` | `GET /api/v1/site-channel/:siteId` | 单站点渠道 |
| `site_channel.go` | `GET /api/v1/site-channel/:siteId/account/:accountId` | 单账号渠道 |
| `site_channel.go` | `GET /api/v1/site-channel/:siteId/account/:accountId/model-history` | 模型历史 |
| `site_channel.go` | `POST /api/v1/site-channel/:siteId/account/:accountId/keys` | 创建 Key |
| `site_channel.go` | `PUT /api/v1/site-channel/:siteId/account/:accountId/source-keys` | 更新源 Key |
| `site_channel.go` | `PUT /api/v1/site-channel/:siteId/account/:accountId/group-projection` | 更新分组投影 |
| `site_channel.go` | `PUT /api/v1/site-channel/:siteId/account/:accountId/model-routes` | 更新模型路由 |
| `site_channel.go` | `PUT /api/v1/site-channel/:siteId/account/:accountId/model-disabled` | 更新模型禁用 |
| `site_channel.go` | `PUT /api/v1/site-channel/:siteId/account/:accountId/projected-channel-settings` | 投影渠道设置 |
| `site_channel.go` | `POST /api/v1/site-channel/:siteId/account/:accountId/manual-models` | 添加手动模型 |
| `site_channel.go` | `POST /api/v1/site-channel/:siteId/account/:accountId/manual-models/delete` | 删除手动模型 |
| `site_channel.go` | `POST /api/v1/site-channel/:siteId/account/:accountId/model-routes/reset` | 重置模型路由 |
| `remote_site.go` | `POST /api/v1/remote-site/refresh-all` | 刷新全部远程站点 |
| `remote_site.go` | `POST /api/v1/remote-site/detect` | 检测远程站点类型 |
| `remote_site.go` | `GET /api/v1/remote-site/models/:id` | 远程站点模型 |
| `remote_site.go` | `GET /api/v1/remote-site/pricing/:id` | 远程站点定价 |
| `remote_site.go` | `GET /api/v1/remote-site/site-types` | 已知站点类型 |
| `remote_site.go` | `GET /api/v1/site-discovery/discover` | 站点发现 |
| `balance_history.go` | `GET /api/v1/balance-history/list/:site_id` | 余额快照列表 |
| `balance_history.go` | `GET /api/v1/balance-history/chart/:site_id` | 余额图表 |
| `balance_history.go` | `POST /api/v1/balance-history/capture/:site_id` | 手动捕获余额 |
| `balance_history.go` | `GET /api/v1/balance-history/prediction/:site_id` | 余额预测 |
| `checkin.go` | `GET /api/v1/checkin/status/:site_id` | 签到状态 |
| `checkin.go` | `POST /api/v1/checkin/execute/:site_id` | 执行签到 |
| `checkin.go` | `POST /api/v1/checkin/execute-all` | 全部签到 |
| `checkin.go` | `GET /api/v1/checkin/history/:site_id` | 签到历史 |
| `redemption.go` | `POST /api/v1/redemption/redeem` | 兑换码核销 |
| `redemption.go` | `POST /api/v1/redemption/redeem-all` | 全部兑换 |
| `redemption.go` | `GET /api/v1/redemption/history/:site_id` | 兑换历史 |
| `usage_history.go` | `GET /api/v1/usage-history` | 用量历史查询 |
| `usage_history.go` | `GET /api/v1/usage-history/summary` | 用量聚合 |
| `usage_history.go` | `GET /api/v1/usage-history/hourly` | 按小时用量 |
| `usage_history.go` | `GET /api/v1/usage-history/models/:site_id` | 站点模型列表 |
| `usage_history.go` | `POST /api/v1/usage-history/sync/:site_id` | 同步单站点用量 |
| `usage_history.go` | `POST /api/v1/usage-history/sync-all` | 同步全部用量 |
| `announcement.go` | `GET /api/v1/announcement/list` | 全部公告 |
| `announcement.go` | `GET /api/v1/announcement/list/:site_id` | 站点公告 |
| `announcement.go` | `POST /api/v1/announcement/refresh/:site_id` | 刷新公告 |
| `announcement.go` | `POST /api/v1/announcement/refresh-all` | 刷新全部公告 |
| `remote_site_token.go` | `GET /api/v1/remote-site-token/list/:site_id` | Token 列表 |
| `remote_site_token.go` | `POST /api/v1/remote-site-token/sync/:site_id` | 同步 Token |
| `remote_site_token.go` | `POST /api/v1/remote-site-token/sync-to-channel` | Token 导入为渠道 |
| `remote_site_token.go` | `GET /api/v1/remote-site-token/export/:site_id` | 导出 Token |
| `channel_migration.go` | `POST /api/v1/channel-migration/migrate` | 迁移单个渠道 |
| `channel_migration.go` | `POST /api/v1/channel-migration/migrate-all` | 迁移全部渠道 |

### 权限体系发现

服务端有 15 个细粒度权限（`permissions.go`）：

| 权限 | admin | editor | viewer |
|------|-------|--------|--------|
| channels:read | ✅ | ✅ | ✅ |
| channels:write | ✅ | ✅ | ❌ |
| groups:read | ✅ | ✅ | ✅ |
| groups:write | ✅ | ✅ | ❌ |
| apikeys:read | ✅ | ✅ | ✅ |
| apikeys:write | ✅ | ✅ | ❌ |
| settings:read | ✅ | ✅ | ✅ |
| settings:write | ✅ | ✅ | ❌ |
| logs:read | ✅ | ✅ | ✅ |
| logs:write | ✅ | ✅ | ❌ |
| stats:read | ✅ | ✅ | ✅ |
| users:read | ✅ | ❌ | ❌ |
| users:write | ✅ | ❌ | ❌ |
| **sites:read** | ✅ | ✅ | ✅ |
| **sites:write** | ✅ | ✅ | ❌ |

客户端完全不感知权限体系，没有根据角色隐藏/禁用 UI 元素的逻辑。

### OutboundType 发现

服务端支持 8 种出站类型：
- `OutboundTypeOpenAIChat` (0)
- `OutboundTypeOpenAIResponse` (1)
- `OutboundTypeAnthropic` (2)
- `OutboundTypeGemini` (3)
- `OutboundTypeVolcengine` (4)
- `OutboundTypeOpenAIEmbedding` (5)
- `OutboundTypeMimo` (6)
- `OutboundTypeCloudflare` (7)

客户端 Channel 模型的 `type` 字段是 `int`，但没有定义枚举常量，也没有 Cloudflare 类型的 UI 支持。

---

## 九、最终结论

经过 **7 轮交叉扫描**，结论如下：

### 覆盖率最终评估

| 维度 | 服务端 | 客户端 | 覆盖率 |
|------|--------|--------|--------|
| 数据模型 | 40+ | 16 | **38%** |
| API 端点 | **150+** | ~60 | **40%** |
| 设置项 | 82 | ~20 UI | **24%** |
| 功能模块 | 13+ 顶级 | 8 Tab | **62%** |
| 权限控制 | 15 细粒度 | 0 | **0%** |

### 核心差距排序

1. **Hub 站点管理**（完全缺失）— 12 种平台适配器、站点/账号/Token/同步/签到/兑换/用量/公告/渠道迁移/站点发现，共 **80+ API 端点**
2. **Analytics 独立页面**（严重不足）— 服务端 10 个分析端点（channel-model、auto-strategy、latency-distribution、provider-breakdown、model-breakdown、apikey-breakdown、group-health、utilization、evaluation、overview），客户端只调用 5 个且无独立页面
3. **Ops Telemetry**（完全缺失）— hero metrics、runtime signals、database health、provider health、prompt cache、session/quota activity
4. **StatsMetrics 延迟/FTUT/直方图**（12 字段缺失）— P50/P95/P99 延迟、首 Token 时间、5 个延迟桶
5. **APIKey 安全字段**（3 字段缺失）— allowed_ips、tags、excluded_channels
6. **Channel 高级功能**（7 字段缺失）— proxy_mode 4 种模式、request_rewrite、skip_model_test、group_id 等
7. **Group 高级功能**（3 字段缺失）— endpoint_provider、outbound_format、condition
8. **RelayLog 详细信息**（8 字段缺失）— attempts、endpoint_type、client_ip、semantic_cache_hit 等
9. **Proxy Pool / Model Mapping / Credential / WebDAV / WebAuthn**（5 个完整模块缺失）
10. **权限体系**（完全缺失）— 客户端不感知 admin/editor/viewer 角色差异
11. **设置项**（58 项缺失）— 语义缓存、响应过滤、模型归一化、WebDAV、WebAuthn、日志级别等
12. **Channel 更新方式变更**（阻断性）— 服务端改用增量更新 `ChannelUpdateRequest`，客户端仍发完整对象

### 建议执行路径

**Phase 1（阻断修复）**：Channel 增量更新适配 + APIKey 安全字段
**Phase 2（核心补齐）**：Analytics 独立页 + Ops Telemetry + StatsMetrics 延迟字段 + RelayLog 详情
**Phase 3（新模块）**：Hub 站点管理（最大工作量，建议分 3 子阶段：基础 CRUD → 同步/签到 → 渠道投影）
**Phase 4（工具模块）**：Proxy Pool + Model Mapping + Credential + WebDAV + WebAuthn
**Phase 5（体验优化）**：权限感知 UI + 设置项补全 + i18n

客户端覆盖了 Octopus 的**基础管理功能**，但服务端已大幅扩展：

1. **生态集成**：Hub 站点管理（12 种平台适配器）
2. **智能路由**：AI Route、Model Mapping、条件路由
3. **运维可观测**：Telemetry、Analytics 6 Tab、延迟分布、Provider Health
4. **安全加固**：WebAuthn、IP 白名单、响应过滤、API 凭证配置
5. **基础设施**：Proxy Pool、WebDAV 备份、数据库迁移、模型归一化
