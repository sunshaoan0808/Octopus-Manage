# Octopus 服务端 vs 客户端差异分析

> 生成日期: 2026-06-24
> 更新日期: 2026-06-24 (三轮深查后更新)
> 服务端: F:\codecil\octopus-dev (Go / Gin)
> 客户端: F:\codecil\octopusmanage (Flutter / Dart)

---

## 一、总览

| 维度 | 服务端 | 客户端 | 差距 |
|------|--------|--------|------|
| 管理 API 路由组 | ~34 组 | ~20 组 | 缺少 14 组 |
| 管理 API 端点总数 | ~145 | ~55 | 缺少 ~90 个端点 |
| 数据模型数 | ~30+ 结构体 | 18 个 Dart 类 | 缺少 ~12 个模型 |
| 页面数 | — | 13 个 | 需新增 ~8+ 页面 |
| RBAC 权限体系 | 8 类权限 | 无 | 完全缺失 |
| SSE 实时推送 | 支持 | 不支持 | 缺失 |

---

## 二、完全缺失的功能模块（客户端未覆盖）

### 2.1 🔑 WebAuthn / Passkey 认证 (7 个端点)

**服务端端点:**
- `GET  /api/v1/webauthn/status`
- `POST /api/v1/webauthn/login/begin`
- `POST /api/v1/webauthn/login/finish`
- `GET  /api/v1/webauthn/credentials`
- `POST /api/v1/webauthn/register/begin`
- `POST /api/v1/webauthn/register/finish`
- `DELETE /api/v1/webauthn/credentials/:id`

**服务端模型:** `WebAuthnCredential` — id, user_id, name, created_at, last_used_at

**客户端状态:** 完全缺失，无模型、无页面、无 API 封装

---

### 2.2 🌐 Remote Site / 站点管理 (22 个端点)

**服务端端点:**
- `GET/POST /api/v1/remote-site/list|create|update|delete|refresh|refresh-all|detect`
- `GET /api/v1/remote-site/models/:id|pricing/:id|site-types`
- `GET/POST /api/v1/site/list|archived|create|update|enable|detect|batch|delete|archive|restore`
- `POST /api/v1/site/import/all-api-hub|metapi`
- `POST /api/v1/site/account/sync|checkin|create|update|enable|delete`
- `POST /api/v1/site/sync-all|checkin-all`
- `GET /api/v1/site/:id/available-models`

**服务端模型:** RemoteSite, Site, SiteAccount 等

**客户端状态:** 完全缺失

---

### 2.3 🔗 Site Channel / 站点渠道映射 (13 个端点)

**服务端端点:**
- `GET  /api/v1/site-channel/list`
- `GET  /api/v1/site-channel/:siteId`
- `GET  /api/v1/site-channel/:siteId/account/:accountId`
- `GET  /api/v1/site-channel/:siteId/account/:accountId/model-history`
- `POST /api/v1/site-channel/:siteId/account/:accountId/keys`
- `PUT  /api/v1/site-channel/:siteId/account/:accountId/source-keys`
- `PUT  /api/v1/site-channel/:siteId/account/:accountId/group-projection`
- `PUT  /api/v1/site-channel/:siteId/account/:accountId/model-routes`
- `PUT  /api/v1/site-channel/:siteId/account/:accountId/model-disabled`
- `PUT  /api/v1/site-channel/:siteId/account/:accountId/projected-channel-settings`
- `POST /api/v1/site-channel/:siteId/account/:accountId/manual-models`
- `POST /api/v1/site-channel/:siteId/account/:accountId/manual-models/delete`
- `POST /api/v1/site-channel/:siteId/account/:accountId/model-routes/reset`

**客户端状态:** 完全缺失

---

### 2.4 💰 Balance History / 余额历史 (4 个端点)

**服务端端点:**
- `GET  /api/v1/balance-history/list/:site_id`
- `GET  /api/v1/balance-history/chart/:site_id`
- `POST /api/v1/balance-history/capture/:site_id`
- `GET  /api/v1/balance-history/prediction/:site_id`

**客户端状态:** 完全缺失

---

### 2.5 ✅ Checkin / 签到 (4 个端点)

**服务端端点:**
- `GET  /api/v1/checkin/status/:site_id`
- `POST /api/v1/checkin/execute/:site_id`
- `POST /api/v1/checkin/execute-all`
- `GET  /api/v1/checkin/history/:site_id`

**客户端状态:** 完全缺失

---

### 2.6 🎁 Redemption / 兑换码 (3 个端点)

**服务端端点:**
- `POST /api/v1/redemption/redeem`
- `POST /api/v1/redemption/redeem-all`
- `GET  /api/v1/redemption/history/:site_id`

**客户端状态:** 完全缺失

---

### 2.7 📊 Usage History / 用量历史 (6 个端点)

**服务端端点:**
- `GET  /api/v1/usage-history`
- `GET  /api/v1/usage-history/summary`
- `GET  /api/v1/usage-history/hourly`
- `GET  /api/v1/usage-history/models/:site_id`
- `POST /api/v1/usage-history/sync/:site_id`
- `POST /api/v1/usage-history/sync-all`

**客户端状态:** 完全缺失

---

### 2.8 📢 Announcement / 公告 (4 个端点)

**服务端端点:**
- `GET  /api/v1/announcement/list`
- `GET  /api/v1/announcement/list/:site_id`
- `POST /api/v1/announcement/refresh/:site_id`
- `POST /api/v1/announcement/refresh-all`

**客户端状态:** 完全缺失

---

### 2.9 🔄 Channel Migration / 渠道迁移 (2 个端点)

**服务端端点:**
- `POST /api/v1/channel-migration/migrate`
- `POST /api/v1/channel-migration/migrate-all`

**客户端状态:** 完全缺失

---

### 2.10 🗺️ Model Mapping / 模型映射 (5 个端点)

**服务端端点:**
- `GET    /api/v1/model-mapping`
- `GET    /api/v1/model-mapping/:id`
- `POST   /api/v1/model-mapping`
- `PUT    /api/v1/model-mapping/:id`
- `DELETE /api/v1/model-mapping/:id`

**客户端状态:** 完全缺失

---

### 2.11 🔐 API Credential / 凭证管理 (6 个端点)

**服务端端点:**
- `GET  /api/v1/api-credential/list`
- `POST /api/v1/api-credential/create`
- `POST /api/v1/api-credential/update`
- `DELETE /api/v1/api-credential/delete/:id`
- `GET  /api/v1/api-credential/api-types`
- `GET  /api/v1/api-credential/cli-tools`

**客户端状态:** 完全缺失

---

### 2.12 🔍 Verification / 验证探测 (3 个端点)

**服务端端点:**
- `POST /api/v1/verification/run`
- `POST /api/v1/verification/run-for/:id`
- `GET  /api/v1/verification/probes`

**客户端状态:** 完全缺失

---

### 2.13 💾 WebDAV Backup / 备份 (7 个端点)

**服务端端点:**
- `GET    /api/v1/backup/webdav/config`
- `POST   /api/v1/backup/webdav/config`
- `POST   /api/v1/backup/webdav/test`
- `POST   /api/v1/backup/webdav/backup`
- `POST   /api/v1/backup/webdav/restore`
- `GET    /api/v1/backup/webdav/list`
- `DELETE /api/v1/backup/webdav/delete`

**客户端状态:** 完全缺失（客户端仅有 JSON 导出/导入）

---

### 2.14 🖥️ Proxy Pool / 代理池 (6 个端点)

**服务端端点:**
- `GET    /api/v1/proxy-pool/list`
- `GET    /api/v1/proxy-pool/references/:id`
- `DELETE /api/v1/proxy-pool/delete/:id`
- `POST   /api/v1/proxy-pool/create`
- `POST   /api/v1/proxy-pool/update`
- `POST   /api/v1/proxy-pool/test`

**客户端状态:** 完全缺失

---

### 2.15 📡 CLI Export (1 个端点)

**服务端端点:**
- `POST /api/v1/cli-export/generate`

**客户端状态:** 完全缺失

---

### 2.16 📡 Site Discovery (1 个端点)

**服务端端点:**
- `GET /api/v1/site-discovery/discover`

**客户端状态:** 完全缺失

---

### 2.17 🔑 Remote Site Token (4 个端点)

**服务端端点:**
- `GET  /api/v1/remote-site-token/list/:site_id`
- `POST /api/v1/remote-site-token/sync/:site_id`
- `POST /api/v1/remote-site-token/sync-to-channel`
- `GET  /api/v1/remote-site-token/export/:site_id`

**客户端状态:** 完全缺失

---

## 三、已有模块中缺失的端点

### 3.1 Channel 模块

| 缺失端点 | 方法 | 说明 |
|----------|------|------|
| `/api/v1/channel/check-keys/:id` | POST | 检查已保存渠道的所有 Key |
| `/api/v1/channel/test-model` | POST | 测试渠道上的特定模型 |
| `/api/v1/channel/group/*` | — | 渠道分组管理（4 个端点） |

### 3.2 Group 模块

| 缺失端点 | 方法 | 说明 |
|----------|------|------|
| `/api/v1/group/test-draft` | POST | 测试草稿分组 |
| `/api/v1/group/purge-unavailable` | POST | 清除不可用的分组项 |

### 3.3 Log 模块

| 缺失端点 | 方法 | 说明 |
|----------|------|------|
| `/api/v1/log/stream` | GET | SSE 实时日志流 |

### 3.4 Alert 模块

| 缺失端点 | 方法 | 说明 |
|----------|------|------|
| `/api/v1/alert/notif/test` | POST | 测试通知渠道 |

### 3.5 Ops 模块

| 缺失端点 | 方法 | 说明 |
|----------|------|------|
| `/api/v1/ops/telemetry` | GET | 遥测概览（全新子系统） |

### 3.6 Analytics 模块

| 缺失端点 | 方法 | 说明 |
|----------|------|------|
| `/api/v1/analytics/channel-model` | GET | 渠道×模型交叉分析 |
| `/api/v1/analytics/auto-strategy` | GET | Auto 策略实时快照 |
| `/api/v1/analytics/latency-distribution` | GET | 延迟分布直方图 |

### 3.7 Setting 模块

| 缺失端点 | 方法 | 说明 |
|----------|------|------|
| `/api/v1/setting/database/test` | POST | 测试数据库连接 |
| `/api/v1/setting/database/migrate` | POST | 数据库迁移 |

### 3.8 API Key 模块

| 缺失端点 | 方法 | 说明 |
|----------|------|------|
| `/api/v1/apikey/stats` | GET | 当前 API Key 自身统计 |
| `/api/v1/apikey/login` | GET | API Key 验证 |

### 3.9 Model 模块

| 缺失端点 | 方法 | 说明 |
|----------|------|------|
| `/api/v1/model/capabilities` | GET | 模型跨分组能力查询 |

### 3.10 Route (AI Route) 模块

| 缺失端点 | 方法 | 说明 |
|----------|------|------|
| `/api/v1/route/ai-generate/stream/:id` | GET | SSE 实时进度流 |

---

## 四、数据模型差异

### 4.1 Channel 模型 — 新增字段

| 字段 | 类型 | 说明 | 客户端状态 |
|------|------|------|-----------|
| `group_id` | int | 所属渠道分组 ID | ❌ 缺失 |
| `proxy_mode` | string | 代理模式 (direct/pool/config) | ❌ 缺失 |
| `proxy_config_id` | *int | 代理池配置 ID | ❌ 缺失 |
| `skip_model_test` | bool | 跳过模型测试 | ❌ 缺失 |
| `request_rewrite` | object | 请求重写配置 | ❌ 缺失 |
| `managed` | bool | 是否为托管渠道 | ❌ 缺失 |
| `managed_source` | object | 托管来源信息 | ❌ 缺失 |
| `base_urls[].suffix_mode` | string | URL 后缀模式 | ❌ 缺失 |

**请求重写配置 (`RequestRewriteConfig`):**
- `enabled` — 是否启用
- `profile` — 重写配置 (preserve / openai_chat_compat / codex)
- `tool_role_strategy` — 工具角色策略 (keep / stringify_to_user)
- `system_message_strategy` — 系统消息策略 (keep / merge)
- `header_profile` — 请求头配置

**渠道更新请求差异:**
- 服务端支持增量更新 (`ChannelUpdateRequest`): `keys_to_add`, `keys_to_update`, `keys_to_delete`
- 客户端目前只支持全量替换

---

### 4.2 APIKey 模型 — 新增字段

| 字段 | 类型 | 说明 | 客户端状态 |
|------|------|------|-----------|
| `allowed_ips` | string | 允许的 IP/CIDR 列表 | ❌ 缺失 |
| `tags` | string | 标签（分类与检索） | ❌ 缺失 |
| `excluded_channels` | string | 排除的渠道 ID 列表 | ❌ 缺失 |

---

### 4.3 Group 模型 — 新增字段

| 字段 | 类型 | 说明 | 客户端状态 |
|------|------|------|-----------|
| `endpoint_provider` | string | 端点提供方 | ❌ 缺失 |
| `outbound_format` | string | 出站格式 (auto/chat/responses) | ❌ 缺失 |
| `condition` | string | 条件路由 JSON | ❌ 缺失 |

---

### 4.4 RelayLog 模型 — 新增字段

| 字段 | 类型 | 说明 | 客户端状态 |
|------|------|------|-----------|
| `client_ip` | string | 客户端 IP | ❌ 缺失 |
| `endpoint_type` | string | 命中的端点分类 | ❌ 缺失 |
| `semantic_cache_hit` | bool | 语义缓存命中 | ❌ 缺失 |
| `cache_read_tokens` | int | 提供方缓存命中 Token | ❌ 缺失 |
| `request_content` | string | 请求内容 | ❌ 缺失 |
| `response_content` | string | 响应内容 | ❌ 缺失 |
| `attempts` | []ChannelAttempt | 所有尝试记录 | ❌ 缺失 |
| `total_attempts` | int | 总尝试次数 | ❌ 缺失 |
| `is_test` | bool | 是否为测试日志 | ❌ 缺失 |

**全新: `ChannelAttempt` 结构:**
- `channel_id`, `channel_key_id`, `channel_name`, `model_name`
- `adapter_type` — 适配器类型
- `attempt_num` — 尝试序号
- `status` — success/failed/circuit_break/skipped
- `duration` — 耗时
- `sticky` — 是否粘性会话

**全新: `RelayLogListItem` 轻量列表条目** — 排除 request_content/response_content 大字段

---

### 4.5 Ops 模型 — 新增字段和子系统

**OpsCacheStatus 新增:**
- `provider_prompt_cache` — 提供方提示缓存统计（含 providers 列表和 trend 趋势）

**OpsQuotaSummary 新增:**
- `keys` 字段 — 每个 Key 的详细配额状态列表 (`OpsQuotaKeyItem`)

**OpsHealthStatus 新增:**
- `failing_groups` — 失败分组详情列表 (`OpsHealthGroupItem`)

**OpsSystemSummary 新增字段:**
- `repo`, `relay_log_keep_count`, `import_enabled`, `export_enabled`
- `ai_route_legacy_mode`, `ai_route_enabled_service_count`, `ai_route_services`
- `relay_route_retries`, `ratelimit_cooldown_sec`
- `circuit_breaker_enabled`, `circuit_breaker_threshold`, `circuit_breaker_cooldown`, `circuit_breaker_max_cooldown`
- `response_filter_enabled`, `response_filter_action`, `response_filter_keyword_count`

**全新: `OpsTelemetrySummary` 遥测子系统:**
- `hero` — 运行时间、总请求、平均延迟、错误率、活跃连接、内存
- `runtime_signals` — P95 延迟、吞吐量 RPS、内存趋势
- `database_health` — 数据库健康状态
- `session_quota_activity` — 会话/配额活动
- `prompt_cache` — 提示缓存统计
- `provider_health` — 提供方健康列表
- `drilldown_shortcuts` — 下钻快捷入口

---

### 4.6 Analytics 模型 — 新增

**全新: `AnalyticsChannelModelItem`** — 渠道×模型交叉维度统计

**全新: `AutoStrategySnapshotItem`** — Auto 策略实时快照:
- `success_rate`, `sample_count`, `avg_latency_ms`, `last_active_at`, `min_samples_met`

**全新: `LatencyDistribution`** — 延迟分布:
- `avg_ms`, `p50_ms`, `p95_ms`, `p99_ms`
- `ftut_avg_ms`, `ftut_p50_ms`, `ftut_p95_ms`, `ftut_p99_ms`
- `buckets` — 直方图桶

**AnalyticsRange 扩展:**
- 服务端新增: `ytd` (年初至今), `all` (全部)
- 客户端仅支持: `1d`, `7d`, `30d`, `90d`

**AnalyticsGroupHealthItem 新增字段:**
- `failing_channels` — 失败渠道详情列表
- `mode` — 分组模式
- `channel_ids` — 渠道 ID 列表
- `auto_items` — Auto 策略实时快照列表

---

## 五、架构层面差异

### 5.1 RBAC 权限体系

服务端实现了完整的 RBAC 权限中间件 (`RequirePermission`)，共 8 类权限:
- `PermChannelsRead` / `PermChannelsWrite`
- `PermGroupsRead` / `PermGroupsWrite`
- `PermAPIKeysRead` / `PermAPIKeysWrite`
- `PermSettingsRead` / `PermSettingsWrite`
- `PermStatsRead`
- `PermLogsRead` / `PermLogsWrite`
- `PermSitesRead` / `PermSitesWrite`
- `PermUsersRead` / `PermUsersWrite`

**客户端状态:** 无权限控制，所有功能对所有用户可见

### 5.2 SSE 实时推送

服务端支持 3 个 SSE 端点:
- `/api/v1/log/stream` — 实时日志流
- `/api/v1/route/ai-generate/stream/:id` — AI Route 进度流

**客户端状态:** 使用轮询方式（Timer.periodic），未实现 SSE

### 5.3 登录限流

服务端有 `LoginRateLimit` 中间件保护登录端点。

**客户端状态:** 无对应处理

### 5.4 审计日志

服务端有 `AuditManagementWrite` 中间件自动记录管理操作。

**客户端状态:** 有审计日志页面但可能缺少完整的操作覆盖

### 5.5 安全头

服务端有 `SecurityHeaders` 中间件。

**客户端状态:** 不适用（客户端不处理 HTTP 响应头）

---

## 六、优先级建议

### P0 — 核心功能补全（影响日常使用）

1. **APIKey 新字段** — `allowed_ips`, `tags`, `excluded_channels` 需要体现在创建/编辑表单中
2. **Channel 新字段** — `proxy_mode`, `request_rewrite`, `skip_model_test` 需要在高级设置中展示
3. **Group 新字段** — `endpoint_provider`, `outbound_format`, `condition` 需要在分组编辑中支持
4. **RelayLog 新字段** — `attempts`, `client_ip`, `endpoint_type` 需要在日志详情中展示
5. **已有模块缺失端点** — channel/check-keys, channel/test-model, group/purge-unavailable, alert/notif/test

### P1 — 重要新功能

6. **Remote Site 管理** — 全新的站点管理系统（22 个端点），需要新建页面
7. **Site Channel 映射** — 站点渠道映射管理（13 个端点）
8. **Model Mapping** — 模型映射管理（5 个端点）
9. **API Credential** — 凭证管理（6 个端点）
10. **Proxy Pool** — 代理池管理（6 个端点）

### P2 — 运维增强

11. **Ops Telemetry** — 全新遥测子系统
12. **Analytics 新端点** — channel-model, auto-strategy, latency-distribution
13. **WebDAV Backup** — WebDAV 备份管理
14. **Balance History** — 余额历史追踪
15. **Usage History** — 用量历史同步

### P3 — 辅助功能

16. **WebAuthn / Passkey** — 无密码认证
17. **Checkin / Redemption** — 签到与兑换码
18. **Announcement** — 公告管理
19. **Channel Migration** — 渠道迁移工具
20. **CLI Export** — CLI 配置导出
21. **Verification** — 验证探测
22. **Site Discovery** — 站点发现
23. **Database Test/Migrate** — 数据库管理

---

## 七、新页面规划建议

| 页面 | 对应模块 | 端点数 | 优先级 |
|------|---------|--------|--------|
| SitePage | Remote Site + Site | 22+ | P1 |
| SiteChannelPage | Site Channel | 13 | P1 |
| ModelMappingPage | Model Mapping | 5 | P1 |
| ApiCredentialPage | API Credential | 6 | P1 |
| ProxyPoolPage | Proxy Pool | 6 | P1 |
| WebDAVBackupPage | WebDAV Backup | 7 | P2 |
| TelemetryPage | Ops Telemetry | 1 | P2 |
| UsageHistoryPage | Usage History | 6 | P2 |
| BalanceHistoryPage | Balance History | 4 | P2 |
| WebAuthnPage | Passkey 管理 | 7 | P3 |
| AnnouncementPage | 公告管理 | 4 | P3 |
| VerificationPage | 验证探测 | 3 | P3 |

---

## 八、Setting Key 差异（三轮深查新增）

服务端定义了 **60+ 个 SettingKey**，客户端仅覆盖约 30 个。以下为客户端缺失的 setting key：

### 8.1 安全与认证相关

| SettingKey | 说明 | 客户端状态 |
|-----------|------|-----------|
| `jwt_default_expiry_minutes` | JWT 默认过期时间（分钟） | ❌ 缺失 |
| `jwt_remember_me_expiry_days` | 记住我 JWT 过期时间（天） | ❌ 缺失 |
| `login_rate_limit_window` | 登录限流时间窗口（分钟） | ❌ 缺失 |
| `login_rate_limit_max_failed` | 登录限流最大失败次数 | ❌ 缺失 |
| `webauthn_rp_id` | WebAuthn RP ID | ❌ 缺失 |
| `webauthn_rp_name` | WebAuthn RP 展示名 | ❌ 缺失 |
| `webauthn_origins` | WebAuthn 允许的 Origin 列表 | ❌ 缺失 |

### 8.2 流会话相关

| SettingKey | 说明 | 客户端状态 |
|-----------|------|-----------|
| `stream_session_ttl_minutes` | 流会话 TTL（分钟） | ❌ 缺失 |
| `stream_session_max_events` | 流会话最大事件数 | ❌ 缺失 |
| `stream_session_max_bytes_mb` | 流会话最大字节数（MB） | ❌ 缺失 |

### 8.3 通知与告警相关

| SettingKey | 说明 | 客户端状态 |
|-----------|------|-----------|
| `notify_http_timeout_seconds` | 通知 HTTP 请求超时（秒） | ❌ 缺失 |
| `failure_hint_ttl_unauthorized` | 认证失败提示缓存 TTL | ❌ 缺失 |
| `failure_hint_ttl_rate_limit` | 限流失败提示缓存 TTL | ❌ 缺失 |
| `failure_hint_ttl_network` | 网络失败提示缓存 TTL | ❌ 缺失 |

### 8.4 站点管理相关

| SettingKey | 说明 | 客户端状态 |
|-----------|------|-----------|
| `site_sync_interval` | 站点账号同步间隔（小时） | ❌ 缺失 |
| `site_checkin_interval` | 站点自动签到间隔（小时） | ❌ 缺失 |
| `stats_site_model_backfilled` | 站点模型统计回填标记 | ❌ 缺失 |
| `projected_channel_auto_group_enabled` | 站点投影渠道自动分组全局开关 | ❌ 缺失 |

### 8.5 输出过滤相关

| SettingKey | 说明 | 客户端状态 |
|-----------|------|-----------|
| `response_filter_enabled` | 输出结果关键词拦截开关 | ❌ 缺失 |
| `response_filter_keywords` | 拦截关键词列表（JSON 数组） | ❌ 缺失 |
| `response_filter_action` | 拦截动作: block/replace | ❌ 缺失 |
| `response_filter_error_message` | 阻断时返回的错误信息 | ❌ 缺失 |

### 8.6 日志与调试相关

| SettingKey | 说明 | 客户端状态 |
|-----------|------|-----------|
| `log_level` | 应用日志级别: debug/info/warn/error | ❌ 缺失 |
| `log_excluded_groups` | 日志列表中屏蔽的分组名称列表 | ❌ 缺失 |

### 8.7 模型归一化相关

| SettingKey | 说明 | 客户端状态 |
|-----------|------|-----------|
| `model_normalize_router_prefixes` | 路由商/平台前缀列表 | ❌ 缺失 |
| `model_normalize_functional_suffixes` | 功能性后缀列表 | ❌ 缺失 |
| `model_normalize_explicit_mappings` | 显式变体→基准名映射 | ❌ 缺失 |
| `model_normalize_market_dedupe_default` | 模型广场默认开启归一化去重 | ❌ 缺失 |

### 8.8 导航与统计相关

| SettingKey | 说明 | 客户端状态 |
|-----------|------|-----------|
| `nav_order` | 顶级页面顺序（JSON 数组） | ❌ 缺失 |
| `nav_visible` | 顶级页面显示状态（JSON 数组） | ❌ 缺失 |
| `stats_timezone_offset` | 统计时区偏移（小时） | ❌ 缺失 |
| `relay_log_keep_count` | 日志保留条数（0=不按条数） | ❌ 缺失 |
| `relay_route_retries` | 路由级最大重试次数 | ❌ 缺失 |
| `semantic_cache_embedding_timeout_seconds` | 语义缓存 embedding 请求超时 | ❌ 缺失 |
| `ai_route_timeout_seconds` | AI Route 单次请求超时 | ❌ 缺失 |
| `ai_route_parallelism` | AI Route 批次最大并发数 | ❌ 缺失 |
| `ai_route_services` | AI Route 服务池（JSON） | ❌ 缺失 |

---

## 九、RBAC 权限体系差异（三轮深查新增）

### 9.1 权限列表（15 个权限）

| 权限 | 说明 | admin | editor | viewer |
|------|------|:-----:|:------:|:------:|
| `channels:read` | 渠道读取 | ✅ | ✅ | ✅ |
| `channels:write` | 渠道写入 | ✅ | ✅ | ❌ |
| `groups:read` | 分组读取 | ✅ | ✅ | ✅ |
| `groups:write` | 分组写入 | ✅ | ✅ | ❌ |
| `apikeys:read` | API Key 读取 | ✅ | ✅ | ✅ |
| `apikeys:write` | API Key 写入 | ✅ | ✅ | ❌ |
| `settings:read` | 设置读取 | ✅ | ✅ | ✅ |
| `settings:write` | 设置写入 | ✅ | ✅ | ❌ |
| `logs:read` | 日志读取 | ✅ | ✅ | ✅ |
| `logs:write` | 日志写入 | ✅ | ✅ | ❌ |
| `stats:read` | 统计读取 | ✅ | ✅ | ✅ |
| `users:read` | 用户读取 | ✅ | ❌ | ❌ |
| `users:write` | 用户写入 | ✅ | ❌ | ❌ |
| `sites:read` | 站点读取 | ✅ | ✅ | ✅ |
| `sites:write` | 站点写入 | ✅ | ✅ | ❌ |

### 9.2 Viewer 角色数据脱敏

服务端对 Viewer 角色实施数据脱敏（`redact.go`）：
- 渠道 BaseURL 域名被替换为 `***`
- Remote Site BaseURL 域名被替换为 `***`
- API Credential Profile BaseURL 域名被替换为 `***`
- Site BaseURL 域名被替换为 `***`
- 设置中的 URL 类字段（proxy_url, public_api_base_url 等）被替换为 `***`

**客户端状态:** 完全缺失 RBAC 和数据脱敏

---

## 十、Endpoint Type 差异（三轮深查新增）

服务端定义了 **16 种 Endpoint Type**：

| Endpoint Type | 说明 | 客户端 l10n 覆盖 |
|--------------|------|-----------------|
| `*` | 全部 | ✅ endpoint_all |
| `chat` | Chat | ✅ endpoint_chat |
| `deepseek` | DeepSeek | ❌ 缺失 |
| `mimo` | Mimo | ❌ 缺失 |
| `responses` | OpenAI Response | ❌ 缺失 |
| `messages` | Anthropic Messages | ❌ 缺失 |
| `embeddings` | Embeddings | ✅ endpoint_embeddings |
| `rerank` | Rerank | ✅ endpoint_rerank |
| `moderations` | Moderations | ✅ endpoint_moderations |
| `image_generation` | 图片生成 | ✅ endpoint_image_generation |
| `audio_speech` | 语音合成 | ✅ endpoint_audio_speech |
| `audio_transcription` | 音频转写 | ✅ endpoint_audio_transcription |
| `video_generation` | 视频生成 | ✅ endpoint_video_generation |
| `music_generation` | 音乐生成 | ✅ endpoint_music_generation |
| `search` | 搜索 | ✅ endpoint_search |

---

## 十一、Outbound Type 差异（三轮深查新增）

服务端支持 **8 种 Outbound 适配器类型**：

| OutboundType | 说明 | 客户端渠道类型 |
|-------------|------|---------------|
| `OpenAIChat` | OpenAI Chat | ✅ type_openai_chat |
| `OpenAIResponse` | OpenAI Response | ✅ type_openai_response |
| `Anthropic` | Anthropic | ✅ type_anthropic |
| `Gemini` | Gemini | ✅ type_gemini |
| `Volcengine` | 火山引擎 | ✅ type_volcengine |
| `OpenAIEmbedding` | OpenAI Embedding | ❌ 缺失类型标签 |
| `Mimo` | Mimo | ✅ type_mimo |
| `Cloudflare` | Cloudflare Workers AI | ❌ 完全缺失 |

---

## 十二、通知渠道类型差异（三轮深查新增）

服务端支持 **8 种告警通知渠道类型**：

| 类型 | 说明 | 客户端状态 |
|------|------|-----------|
| `webhook` | Webhook | ✅ 已覆盖 |
| `gotify` | Gotify 推送 | ❌ 缺失配置 UI |
| `email` | 邮件（SMTP） | ❌ 缺失配置 UI |
| `telegram` | Telegram Bot | ❌ 缺失配置 UI |
| `feishu` | 飞书 | ❌ 缺失配置 UI |
| `dingtalk` | 钉钉 | ❌ 缺失配置 UI |
| `wecom` | 企业微信 | ❌ 缺失配置 UI |
| `ntfy` | ntfy 推送 | ❌ 缺失配置 UI |

每种通知渠道都有专属配置结构体（GotifyConfig, EmailConfig, TelegramConfig, FeishuConfig, DingTalkConfig, WeComConfig, NtfyConfig）。

---

## 十三、StatsMetrics 差异（三轮深查新增）

服务端 `StatsMetrics` 新增了 **延迟分布和直方图** 字段：

| 字段 | 类型 | 说明 | 客户端状态 |
|------|------|------|-----------|
| `latency_p50` | int64 | P50 延迟（毫秒） | ❌ 缺失 |
| `latency_p95` | int64 | P95 延迟（毫秒） | ❌ 缺失 |
| `latency_p99` | int64 | P99 延迟（毫秒） | ❌ 缺失 |
| `ftut_avg` | int64 | 首 Token 平均时间 | ❌ 缺失 |
| `ftut_p50` | int64 | 首 Token P50 | ❌ 缺失 |
| `ftut_p95` | int64 | 首 Token P95 | ❌ 缺失 |
| `ftut_p99` | int64 | 首 Token P99 | ❌ 缺失 |
| `histogram_lt_100` | int64 | <100ms 请求数 | ❌ 缺失 |
| `histogram_100_500` | int64 | 100-500ms 请求数 | ❌ 缺失 |
| `histogram_500_1k` | int64 | 500ms-1s 请求数 | ❌ 缺失 |
| `histogram_1k_5k` | int64 | 1s-5s 请求数 | ❌ 缺失 |
| `histogram_gt_5k` | int64 | >5s 请求数 | ❌ 缺失 |

此外，服务端新增 `StatsModel`（按模型统计）和 `StatsSiteModelHourly`（站点模型小时统计）表。

---

## 十四、Background Tasks 差异（三轮深查新增）

服务端注册了 **12 个后台定时任务**：

| 任务名 | 间隔 | 说明 |
|--------|------|------|
| `price_update` | 可配置 | 更新 LLM 价格信息 |
| `base_url_delay` | 1 小时 | 测试渠道 BaseURL 延迟 |
| `sync_llm` | 可配置 | 同步 LLM 模型列表 |
| `stats_save` | 可配置 | 保存统计信息到数据库 |
| `runtime_state_save` | 可配置 | 保存运行时状态（Auto 策略/熔断器） |
| `relay_log_save` | 10 分钟 | 保存转发日志 + 清理过期缓存 |
| `alert_evaluate` | 60 秒 | 评估告警规则 |
| `hub_balance_capture` | 6 小时 | 捕获远程站点余额快照 |
| `hub_auto_checkin` | 12 小时 | 远程站点自动签到 |
| `hub_announcement_fetch` | 4 小时 | 获取远程站点公告 |
| `hub_usage_history_sync` | 6 小时 | 同步远程站点用量历史 |
| `webdav_backup` | 6 小时 | WebDAV 云备份 |

**客户端状态:** 客户端仅有仪表盘自动刷新（可配置 15/30/60 秒），无后台任务概念。

---

## 十五、Channel 渠道类型差异（三轮深查新增）

### 15.1 渠道类型常量

服务端支持的渠道类型（`OutboundType`）：
- OpenAI Chat (0)
- OpenAI Response (1)
- Anthropic (2)
- Gemini (3)
- Volcengine (4)
- OpenAI Embedding (5)
- Mimo (6)
- **Cloudflare (7)** ← 客户端缺失

### 15.2 渠道新特性

| 特性 | 说明 | 客户端状态 |
|------|------|-----------|
| `proxy_mode` | 代理模式: direct/system/pool/inherit | ❌ 缺失 |
| `proxy_config_id` | 代理池配置 ID | ❌ 缺失 |
| `skip_model_test` | 跳过模型测试 | ❌ 缺失 |
| `request_rewrite` | 请求重写配置 | ❌ 缺失 |
| `managed` | 是否为托管渠道 | ❌ 缺失 |
| `managed_source` | 托管来源信息 | ❌ 缺失 |
| `suffix_mode` | BaseURL 后缀模式 | ❌ 缺失 |
| `group_id` | 所属渠道分组 ID | ❌ 缺失 |

### 15.3 请求重写配置（RequestRewriteConfig）

| 字段 | 说明 | 可选值 |
|------|------|--------|
| `enabled` | 是否启用 | true/false |
| `profile` | 重写配置 | preserve / openai_chat_compat / codex |
| `tool_role_strategy` | 工具角色策略 | keep / stringify_to_user |
| `system_message_strategy` | 系统消息策略 | keep / merge |
| `header_profile` | 请求头配置 | 字符串 |

---

## 十六、Channel Group 渠道分组（三轮深查新增）

服务端有独立的 `ChannelGroup` 模型：
- `id`, `name`, `is_default`, `created_at`, `updated_at`
- 提供 4 个端点：list, create, update, delete

**客户端状态:** 完全缺失

---

## 十七、Import/Export 差异（三轮深查新增）

### 17.1 DBDump 结构差异

服务端 `DBDump` 包含 **25+ 个数据表**，客户端仅支持基础表：

| 数据表 | 服务端 | 客户端 |
|--------|:------:|:------:|
| channels | ✅ | ✅ |
| channel_keys | ✅ | ✅ |
| channel_groups | ✅ | ❌ |
| groups | ✅ | ✅ |
| group_items | ✅ | ✅ |
| llm_infos | ✅ | ✅ |
| api_keys | ✅ | ✅ |
| users | ✅ | ❌ |
| settings | ✅ | ✅ |
| alert_rules | ✅ | ❌ |
| alert_notif_channels | ✅ | ❌ |
| alert_state_records | ✅ | ❌ |
| alert_history | ✅ | ❌ |
| audit_logs | ✅ | ❌ |
| runtime_states | ✅ | ❌ |
| circuit_breaker_states | ✅ | ❌ |
| stats_total | ✅ | ❌ |
| stats_daily | ✅ | ✅ |
| stats_hourly | ✅ | ❌ |
| stats_model | ✅ | ❌ |
| stats_channel | ✅ | ❌ |
| stats_api_key | ✅ | ❌ |
| relay_logs | ✅ | ❌ |
| remote_sites | ✅ | ❌ |
| balance_snapshots | ✅ | ❌ |
| check_in_records | ✅ | ❌ |
| api_credential_profiles | ✅ | ❌ |
| site_announcements | ✅ | ❌ |
| remote_site_tokens | ✅ | ❌ |

### 17.2 Import Mode

服务端支持两种导入模式：
- `incremental` — 插入新记录，跳过已存在的
- `full` — 删除所有数据后插入

客户端仅支持单一导入模式。

### 17.3 Database Migration

服务端支持数据库迁移（`/api/v1/setting/database/migrate`）：
- 支持 SQLite ↔ MySQL/PostgreSQL 迁移
- 支持选择性迁移（include_logs, include_stats）

**客户端状态:** 完全缺失

---

## 十八、Site 平台类型差异（三轮深查新增）

服务端支持 **9 种站点平台**：

| 平台 | 说明 |
|------|------|
| `new-api` | New API |
| `anyrouter` | AnyRouter |
| `one-api` | One API |
| `one-hub` | One Hub |
| `done-hub` | Done Hub |
| `sub2api` | Sub2API |
| `openai` | OpenAI 官方 |
| `claude` | Claude 官方 |
| `gemini` | Gemini 官方 |

---

## 十九、站点模型路由类型差异（三轮深查新增）

服务端定义了 **7 种站点模型路由类型**：

| 路由类型 | 说明 |
|---------|------|
| `openai_chat` | OpenAI Chat |
| `openai_response` | OpenAI Response |
| `anthropic` | Anthropic |
| `gemini` | Gemini |
| `volcengine` | Volcengine |
| `openai_embedding` | OpenAI Embedding |
| `unknown` | 未知 |

路由来源类型：`sync_inferred` / `manual_override` / `runtime_learned` / `default_assigned`

---

## 二十、总结统计

| 维度 | 服务端 | 客户端 | 差距 |
|------|--------|--------|------|
| 管理 API 路由组 | ~34 组 | ~20 组 | 缺少 14 组 |
| 管理 API 端点总数 | ~145 | ~55 | 缺少 ~90 个端点 |
| 数据模型数 | ~40+ 结构体 | 18 个 Dart 类 | 缺少 ~22 个模型 |
| Setting Key | 60+ | ~30 | 缺少 ~30 个 |
| RBAC 权限 | 15 个 | 0 | 完全缺失 |
| 通知渠道类型 | 8 种 | 1 种 | 缺少 7 种 |
| 渠道类型 | 8 种 | 7 种 | 缺少 Cloudflare |
| 站点平台类型 | 9 种 | 0 | 完全缺失 |
| Endpoint Type | 16 种 | ~10 种 | 缺少 6 种 |
| 后台任务 | 12 个 | 0 | 完全缺失 |
| SSE 端点 | 3 个 | 0 | 完全缺失 |
| 导出数据表 | 25+ | ~8 | 缺少 17+ 表 |
