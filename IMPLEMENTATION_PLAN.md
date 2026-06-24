# Octopus Manager 客户端完善实施计划

> 基于 `server_client_diff_report_v2.md` 七轮扫描结果生成
> 预估总工作量：约 40-60 人天

---

## Phase 1：阻断修复（P0）— 预估 3 天

### 1.1 Channel 增量更新适配

**问题**：服务端 `POST /api/v1/channel/update` 已改用 `ChannelUpdateRequest`（增量更新），客户端仍发送完整 Channel 对象。

**改动范围**：
- `lib/models/channel.dart` — 新增 `ChannelUpdateRequest` 类
- `lib/services/octopus_api.dart` — 修改 `updateChannel` 方法签名
- `lib/pages/channel_page.dart` — 编辑逻辑改为 diff 后发送增量

**任务清单**：
1. 在 `channel.dart` 新增 `ChannelUpdateRequest` 类（参考服务端 `model/channel.go` 的 `ChannelUpdateRequest`）
2. 实现 `ChannelUpdateRequest.fromDiff(Channel previous, Channel next)` 静态方法
3. 修改 `octopus_api.dart` 的 `updateChannel` 接受 `ChannelUpdateRequest`
4. 修改 `channel_page.dart` 编辑流程：保存前先 diff，再发增量
5. 同步新增字段：`group_id`、`skip_model_test`、`request_rewrite`、`proxy_mode`、`proxy_config_id`

### 1.2 APIKey 安全字段补齐

**问题**：客户端缺少 `allowed_ips`、`tags`、`excluded_channels` 三个安全相关字段。

**改动范围**：
- `lib/models/api_key.dart` — 新增 3 个字段
- `lib/pages/api_key_page.dart` — 编辑表单新增 3 个输入框
- `lib/l10n/app_localizations.dart` — 新增翻译 key

**任务清单**：
1. `api_key.dart` 新增 `allowed_ips`、`tags`、`excluded_channels` 字段及 fromJson/toJson
2. `api_key_page.dart` 编辑弹窗新增 IP 白名单输入（逗号分隔）、标签输入、排除渠道多选
3. i18n 新增：`allowed_ips`、`tags`、`excluded_channels` 及对应 hint 文案

---

## Phase 2：核心数据补齐（P1）— 预估 7 天

### 2.1 StatsMetrics 延迟/FTUT/直方图字段

**改动范围**：
- `lib/models/stats.dart` — 新增 12 个字段
- `lib/pages/dashboard_page.dart` — 展示延迟数据
- `lib/widgets/stats_card.dart` — 可选：新增延迟指标卡片

**任务清单**：
1. `stats.dart` 的 `StatsMetrics` 新增：`latencyP50`、`latencyP95`、`latencyP99`、`ftutAvg`、`ftutP50`、`ftutP95`、`ftutP99`、`histogramLt100`、`histogram100to500`、`histogram500to1k`、`histogram1kto5k`、`histogramGt5k`
2. Dashboard 概览卡片增加"平均延迟"和"P95 延迟"指标
3. 可选：新增延迟直方图组件（柱状图）

### 2.2 RelayLog 详细信息补齐

**改动范围**：
- `lib/models/relay_log.dart` — 新增 8 个字段 + `ChannelAttempt` 类
- `lib/pages/log_page.dart` — 日志详情展示 attempts

**任务清单**：
1. 新增 `ChannelAttempt` 类（channel_id、channel_name、model_name、attempt_num、status、duration、msg）
2. `RelayLog` 新增：`requestApiKeyId`、`clientIp`、`endpointType`、`semanticCacheHit`、`cacheReadTokens`、`attempts`、`totalAttempts`、`isTest`
3. 日志详情弹窗增加"尝试记录"折叠面板
4. 日志列表增加 endpoint_type 和 semantic_cache_hit 过滤

### 2.3 Group 高级字段补齐

**改动范围**：
- `lib/models/group.dart` — 新增 3 个字段
- `lib/pages/group_page.dart` — 编辑表单新增字段

**任务清单**：
1. `Group` 新增 `endpointProvider`、`outboundFormat`、`condition` 字段
2. `GroupUpdateRequest` 同步新增
3. 编辑弹窗新增：端点提供方下拉、出站格式下拉、条件 JSON 输入

### 2.4 Channel 高级字段补齐

**改动范围**：
- `lib/models/channel.dart` — 新增字段 + 新枚举
- `lib/pages/channel_page.dart` — 编辑表单扩展

**任务清单**：
1. 新增 `ProxyUsageMode` 枚举（direct/system/pool/inherit）
2. 新增 `RequestRewriteConfig` 类
3. `Channel` 新增：`groupId`、`proxyMode`、`proxyConfigId`、`skipModelTest`、`requestRewrite`、`managed`、`managedSource`
4. `BaseUrl` 新增 `suffixMode` 字段
5. 编辑弹窗：代理模式下拉、跳过模型测试开关、请求重写配置区

---

## Phase 3：Analytics 独立页面 + Ops Telemetry（P1）— 预估 10 天

### 3.1 Analytics 独立页面

**新增文件**：
- `lib/pages/analytics_page.dart` — 主页面，含 Tab 切换
- `lib/models/analytics.dart` — 扩展模型

**任务清单**：
1. 新增 `AnalyticsChannelModelItem` 模型
2. 新增 `AnalyticsLatencyDistribution` 模型（含 HistogramBucket）
3. 新增 `AutoStrategySnapshotItem` 模型
4. 扩展 `AnalyticsGroupHealthItem`：新增 `failingChannels`、`mode`、`channelIds`、`autoItems`
5. 创建 `AnalyticsPage`，6 个 Tab：
   - Channel×Model（渠道×模型矩阵）
   - Usage Breakdown（供应商/模型/Key 分析）
   - Route Health（分组健康）
   - Latency（延迟分布）
   - Evaluation（评估入口）
   - Cache（语义缓存）
6. `octopus_api.dart` 新增 API 方法：`getAnalyticsChannelModel`、`getAnalyticsLatencyDistribution`、`getAnalyticsAutoStrategy`
7. `home_page.dart` 新增 Analytics Tab

### 3.2 Ops Telemetry 页面

**新增文件**：
- `lib/pages/telemetry_page.dart`（或扩展 `ops_page.dart`）

**任务清单**：
1. 新增 `OpsTelemetrySummary` 及子模型（HeroMetrics、RuntimeSignals、DatabaseHealth、SessionQuotaActivity、PromptCache、ProviderHealth、ProviderItem）
2. `octopus_api.dart` 新增 `getOpsTelemetry` 方法
3. Ops 页面新增 Telemetry Tab：
   - Hero 指标卡片（uptime、total requests、avg latency、error rate、active connections、memory）
   - Provider Health 表格（可排序）
   - Prompt Cache 概览
4. `OpsSystemSummary` 补齐缺失字段（`relayRetryCount`、`circuitBreaker*`、`responseFilter*`、`aiRoute*`）

---

## Phase 4：Hub 站点管理（P2）— 预估 15 天

### 4.1 子阶段 A：基础 CRUD（5 天）

**新增文件**：
- `lib/models/site.dart` — Site、SiteAccount、SiteToken、SiteModel、SiteChannelBinding
- `lib/pages/site_page.dart` — 站点列表页
- `lib/pages/site_detail_page.dart` — 站点详情/编辑

**任务清单**：
1. 新增 `Site` 模型（25+ 字段）
2. 新增 `SiteAccount` 模型（30+ 字段）
3. 新增 `SiteToken`、`SiteModel`、`SiteChannelBinding` 模型
4. `octopus_api.dart` 新增站点 CRUD 方法（list、create、update、delete、enable、detect、batch、archive、restore）
5. 站点列表页：卡片网格展示，支持搜索/筛选
6. 站点创建/编辑弹窗：平台选择、Base URL、认证方式、代理配置
7. 站点详情页：账号列表、Token 列表、模型列表

### 4.2 子阶段 B：同步/签到/兑换（5 天）

**新增文件**：
- `lib/models/checkin.dart`、`lib/models/redemption.dart`、`lib/models/balance.dart`
- `lib/widgets/site_account_card.dart`

**任务清单**：
1. 新增 `CheckInRecord`、`RedemptionRecord`、`BalanceSnapshot`、`BalancePrediction` 模型
2. `octopus_api.dart` 新增：sync、checkin、refresh、redeem、balance 相关方法
3. 站点账号卡片：内联余额、同步状态、签到状态
4. 签到功能：一键签到、全部签到
5. 兑换码：输入兑换码、批量兑换
6. 余额追踪：余额图表、余额预测

### 4.3 子阶段 C：渠道投影 + 站点渠道（5 天）

**新增文件**：
- `lib/models/site_channel.dart`
- `lib/pages/site_channel_page.dart`

**任务清单**：
1. 新增 `SiteChannelCard`、`SiteChannelAccount`、`SiteChannelGroup`、`SiteChannelModel` 模型
2. `octopus_api.dart` 新增站点渠道方法（list、get、keys、source-keys、group-projection、model-routes、manual-models）
3. 站点渠道页：按站点→账号→分组层级展示
4. 模型路由管理：查看/修改路由类型
5. 投影渠道设置：自动分组模式、参数覆盖
6. 手动模型添加/删除
7. 导入功能：AllAPIHub、MetAPI 批量导入

---

## Phase 5：工具模块（P2）— 预估 10 天

### 5.1 Proxy Pool 代理池（2 天）

**新增文件**：
- `lib/models/proxy.dart`
- `lib/pages/proxy_page.dart`（或作为设置子页面）

**任务清单**：
1. 新增 `ProxyConfiguration` 模型
2. `octopus_api.dart` 新增代理池 CRUD + test + references 方法
3. 代理池列表页：名称、URL、启用状态、引用数
4. 创建/编辑弹窗
5. 连通性测试
6. 引用追踪展示

### 5.2 Model Mapping 模型映射（2 天）

**新增文件**：
- `lib/models/model_mapping.dart`
- `lib/pages/model_mapping_page.dart`（或作为设置子页面）

**任务清单**：
1. 新增 `ModelMapping` 模型（exact/wildcard/regex）
2. `octopus_api.dart` 新增映射 CRUD 方法
3. 映射列表页：名称、模式、匹配类型、目标模型、优先级、启用状态
4. 创建/编辑弹窗

### 5.3 API Credential Profiles 凭证配置（3 天）

**新增文件**：
- `lib/models/api_credential.dart`
- `lib/pages/credential_page.dart`

**任务清单**：
1. 新增 `APICredentialProfile` 模型
2. `octopus_api.dart` 新增凭证 CRUD + verification + cli-export 方法
3. 凭证列表页：名称、API 类型、Base URL、健康状态
4. 创建/编辑弹窗
5. 健康验证：运行探针、查看结果
6. CLI 配置导出：选择工具、生成配置

### 5.4 WebDAV 云备份（2 天）

**任务清单**：
1. 设置页新增 WebDAV 卡片
2. 配置表单：Base URL、用户名、密码、远程路径、自动备份间隔、最大备份数
3. 连通性测试
4. 手动触发备份
5. 远程文件列表、恢复、删除

### 5.5 WebAuthn / Passkey（1 天）

**任务清单**：
1. 设置页新增 WebAuthn 卡片
2. 配置表单：RP ID、RP Name、允许 Origins
3. 凭证列表展示
4. 注册/删除凭证（注意：Flutter 的 WebAuthn 支持可能需要原生桥接）

---

## Phase 6：权限体系 + 设置补全 + i18n（P3）— 预估 5 天

### 6.1 权限感知 UI

**改动范围**：
- `lib/providers/app_provider.dart` — 新增角色和权限管理
- 所有页面 — 根据角色隐藏/禁用写操作

**任务清单**：
1. `AppProvider` 新增 `userRole` 字段和 `hasPermission(perm)` 方法
2. 定义权限常量（与服务端 `permissions.go` 对齐）
3. 登录后获取用户角色
4. 所有页面：viewer 角色隐藏创建/编辑/删除按钮
5. Settings 页：viewer 隐藏写操作卡片

### 6.2 设置项补全

**改动范围**：
- `lib/pages/setting_page.dart` — 新增设置卡片
- `lib/services/octopus_api.dart` — 新增设置方法

**任务清单**：
1. 新增设置卡片（按优先级）：
   - 语义缓存配置（7 项）
   - 响应过滤配置（4 项）
   - 模型归一化配置（4 项）
   - 日志配置（log_level、log_excluded_groups）
   - Auto 策略配置（4 项）
   - AI Route 配置（6 项）
   - JWT/登录配置（4 项）
   - 流会话配置（3 项）
2. 设置卡片支持拖拽排序（参考服务端 `nav_order`）

### 6.3 i18n 补全

**改动范围**：
- `lib/l10n/app_localizations.dart`

**任务清单**：
1. 新增 Hub 相关翻译（~50 key）
2. 新增 Proxy Pool 翻译（~10 key）
3. 新增 Model Mapping 翻译（~10 key）
4. 新增 Credential 翻译（~15 key）
5. 新增 WebDAV 翻译（~10 key）
6. 新增 WebAuthn 翻译（~10 key）
7. 新增 Telemetry 翻译（~20 key）
8. 新增 Analytics 翻译（~20 key）
9. 新增权限相关翻译（~10 key）

---

## 执行建议

### 并行化机会

| 可并行的任务 | 说明 |
|-------------|------|
| Phase 1.1 + 1.2 | Channel 增量更新 和 APIKey 字段互不依赖 |
| Phase 2.1 + 2.2 + 2.3 + 2.4 | 四个模型补齐互相独立 |
| Phase 3.1 + 3.2 | Analytics 页 和 Ops Telemetry 互不依赖 |
| Phase 4.1 + 5.1 + 5.2 | Hub 基础 CRUD 和 Proxy/Mapping 互不依赖 |
| Phase 6.1 + 6.2 + 6.3 | 权限、设置、i18n 互不依赖 |

### 每个 Phase 的验收标准

| Phase | 验收标准 |
|-------|---------|
| Phase 1 | Channel 编辑保存不丢字段；APIKey 可配置 IP 白名单/标签/排除渠道 |
| Phase 2 | Dashboard 展示延迟指标；日志详情展示 attempts；Group/Channel 编辑支持新字段 |
| Phase 3 | Analytics 6 Tab 全部可用；Ops Telemetry 页面展示完整数据 |
| Phase 4 | Hub 站点列表/创建/编辑/删除可用；同步/签到/兑换功能正常；渠道投影可管理 |
| Phase 5 | Proxy/Mapping/Credential/WebDAV CRUD 可用 |
| Phase 6 | viewer 角色看不到写操作按钮；设置页展示全部 82 项；i18n 无缺失 |

### 风险点

1. **WebAuthn Flutter 支持**：Flutter 原生不支持 WebAuthn，可能需要 platform channel 桥接，或仅提供配置管理（不含 Passkey 登录流程）
2. **Hub 工作量最大**：80+ 端点、复杂数据模型，建议作为独立 Epic 管理
3. **Channel 增量更新**：需要仔细测试 diff 逻辑，避免丢失数据
4. **Analytics 图表**：延迟直方图、渠道×模型矩阵可能需要新的图表组件
