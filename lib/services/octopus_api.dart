import 'dart:convert';
import 'package:octopusmanage/models/ai_route.dart';
import 'package:octopusmanage/models/alert.dart';
import 'package:octopusmanage/models/analytics.dart';
import 'package:octopusmanage/models/api_key.dart';
import 'package:octopusmanage/models/audit_log.dart';
import 'package:octopusmanage/models/model_market.dart';
import 'package:octopusmanage/models/channel.dart';
import 'package:octopusmanage/models/channel_probe.dart';
import 'package:octopusmanage/models/group.dart';
import 'package:octopusmanage/models/group_probe.dart';
import 'package:octopusmanage/models/llm.dart';
import 'package:octopusmanage/models/ops.dart';
import 'package:octopusmanage/models/relay_log.dart';
import 'package:octopusmanage/models/setting.dart';
import 'package:octopusmanage/models/stats.dart';
import 'package:octopusmanage/models/user.dart';
import 'package:octopusmanage/utils/parse_utils.dart';
import 'api_service.dart';

class OctopusApi {
  final ApiService _api;
  OctopusApi(this._api);

  // ====== Auth ======
  Future<Map<String, dynamic>> login(
    String username,
    String password, {
    int expire = -1,
  }) async {
    final res = await _api.post(
      '/api/v1/user/login',
      body: {'username': username, 'password': password, 'expire': expire},
    );
    return parseJsonMap(res['data']) ?? {};
  }

  Future<void> changeUsername(String newUsername) async {
    await _api.post(
      '/api/v1/user/change-username',
      body: {'new_username': newUsername},
    );
  }

  Future<void> changePassword(String oldPassword, String newPassword) async {
    await _api.post(
      '/api/v1/user/change-password',
      body: {'old_password': oldPassword, 'new_password': newPassword},
    );
  }

  Future<Map<String, dynamic>> checkBootstrap() async {
    final res = await _api.get('/api/v1/bootstrap/status');
    return parseJsonMap(res['data']) ?? {};
  }

  Future<bool> createAdmin(String username, String password) async {
    final res = await _api.post(
      '/api/v1/bootstrap/create-admin',
      body: {'username': username, 'password': password},
    );
    final data = parseJsonMap(res['data']) ?? {};
    return parseBool(data['initialized']);
  }

  // ====== User ======
  Future<List<User>> getUsers() async {
    final res = await _api.get('/api/v1/user/list');
    return parseJsonMapList(res['data']).map(User.fromJson).toList();
  }

  Future<void> createUser(String username, String password, String role) async {
    await _api.post(
      '/api/v1/user/create',
      body: {'username': username, 'password': password, 'role': role},
    );
  }

  Future<void> updateUserRole(int id, String role) async {
    await _api.post(
      '/api/v1/user/update-role',
      body: {'id': id, 'role': role},
    );
  }

  Future<void> deleteUser(int id) async {
    await _api.delete('/api/v1/user/delete/$id');
  }

  Future<bool> checkUserStatus() async {
    final res = await _api.get('/api/v1/user/status');
    return res['data'] == 'ok';
  }

  // ====== Stats ======
  Future<StatsMetrics> getStatsToday() async {
    final res = await _api.get('/api/v1/stats/today');
    return StatsMetrics.fromJson(parseJsonMap(res['data']) ?? {});
  }

  Future<StatsMetrics> getStatsTotal() async {
    final res = await _api.get('/api/v1/stats/total');
    return StatsMetrics.fromJson(parseJsonMap(res['data']) ?? {});
  }

  Future<List<StatsDaily>> getStatsDaily() async {
    final res = await _api.get('/api/v1/stats/daily');
    return parseJsonMapList(res['data']).map(StatsDaily.fromJson).toList();
  }

  Future<List<StatsHourly>> getStatsHourly() async {
    final res = await _api.get('/api/v1/stats/hourly');
    return parseJsonMapList(res['data']).map(StatsHourly.fromJson).toList();
  }

  Future<List<StatsAPIKeyEntry>> getStatsApiKey() async {
    final res = await _api.get('/api/v1/stats/apikey');
    return parseJsonMapList(
      res['data'],
    ).map(StatsAPIKeyEntry.fromJson).toList();
  }

  // ====== Stats ======
  // (existing stats methods above)

  Future<List<StatsChannel>> getStatsChannel() async {
    final res = await _api.get('/api/v1/stats/channel');
    return parseJsonMapList(res['data']).map(StatsChannel.fromJson).toList();
  }

  // ====== Channel ======
  Future<List<Channel>> getChannels() async {
    final res = await _api.get('/api/v1/channel/list');
    return parseJsonMapList(res['data']).map(Channel.fromJson).toList();
  }

  Future<Channel> createChannel(Channel channel) async {
    final res = await _api.post(
      '/api/v1/channel/create',
      body: channel.toJson(),
    );
    return Channel.fromJson(parseJsonMap(res['data']) ?? {});
  }

  Future<Channel> updateChannel(ChannelUpdateRequest request) async {
    final res = await _api.post(
      '/api/v1/channel/update',
      body: request.toJson(),
    );
    return Channel.fromJson(parseJsonMap(res['data']) ?? {});
  }

  Future<void> enableChannel(int id, bool enabled) async {
    await _api.post(
      '/api/v1/channel/enable',
      body: {'id': id, 'enabled': enabled},
    );
  }

  Future<void> deleteChannel(int id) async {
    await _api.delete('/api/v1/channel/delete/$id');
  }

  Future<List<String>> fetchModels(Channel channel) async {
    final res = await _api.post(
      '/api/v1/channel/fetch-model',
      body: channel.toJson(),
    );
    return parseStringList(res['data']);
  }

  Future<void> syncChannels() async {
    await _api.post('/api/v1/channel/sync');
  }

  Future<ChannelTestSummary> testChannel(Channel channel) async {
    final res = await _api.post('/api/v1/channel/test', body: channel.toJson());
    return ChannelTestSummary.fromJson(parseJsonMap(res['data']) ?? {});
  }

  Future<String> getLastSyncTime() async {
    final res = await _api.get('/api/v1/channel/last-sync-time');
    return res['data']?.toString() ?? '';
  }

  // ====== Group ======
  Future<List<Group>> getGroups() async {
    final res = await _api.get('/api/v1/group/list');
    return parseJsonMapList(res['data']).map(Group.fromJson).toList();
  }

  Future<Group> createGroup(Group group) async {
    final res = await _api.post('/api/v1/group/create', body: group.toJson());
    return Group.fromJson(parseJsonMap(res['data']) ?? {});
  }

  Future<Group> updateGroup(Object payload) async {
    final body = switch (payload) {
      Group group => group.toJson(),
      GroupUpdateRequest request => request.toJson(),
      Map<String, dynamic> map => map,
      _ => throw ArgumentError('Unsupported group update payload: $payload'),
    };
    final res = await _api.post('/api/v1/group/update', body: body);
    return Group.fromJson(parseJsonMap(res['data']) ?? {});
  }

  Future<void> deleteGroup(int id) async {
    await _api.delete('/api/v1/group/delete/$id');
  }

  Future<void> deleteAllGroups() async {
    await _api.delete('/api/v1/group/delete-all');
  }

  Future<AutoGroupResult> autoGroupModels() async {
    final res = await _api.post('/api/v1/group/auto-group');
    return AutoGroupResult.fromJson(parseJsonMap(res['data']) ?? {});
  }

  Future<GroupModelTestProgress> startGroupTest(int groupId) async {
    final res = await _api.post(
      '/api/v1/group/test',
      body: {'group_id': groupId},
    );
    return GroupModelTestProgress.fromJson(parseJsonMap(res['data']) ?? {});
  }

  Future<GroupModelTestProgress> getGroupTestProgress(String id) async {
    final res = await _api.get('/api/v1/group/test/progress/$id');
    return GroupModelTestProgress.fromJson(parseJsonMap(res['data']) ?? {});
  }

  Future<AIRouteProgress> generateAIRoute({
    required AIRouteScope scope,
    int? groupId,
  }) async {
    final res = await _api.post(
      '/api/v1/route/ai-generate',
      body: {
        'scope': scope.value,
        if (scope == AIRouteScope.group && groupId != null) 'group_id': groupId,
      },
    );
    return AIRouteProgress.fromJson(parseJsonMap(res['data']) ?? {});
  }

  Future<AIRouteProgress> getAIRouteProgress(String id) async {
    final res = await _api.get('/api/v1/route/ai-generate/progress/$id');
    return AIRouteProgress.fromJson(parseJsonMap(res['data']) ?? {});
  }

  Future<AIRouteProgress> getAIRouteStatus(String id) async {
    final res = await _api.get('/api/v1/route/ai-generate/status/$id');
    return AIRouteProgress.fromJson(parseJsonMap(res['data']) ?? {});
  }

  Future<AIRouteProgress> getAIRouteResult(String id) async {
    final res = await _api.get('/api/v1/route/ai-generate/result/$id');
    return AIRouteProgress.fromJson(parseJsonMap(res['data']) ?? {});
  }

  // ====== API Key ======
  Future<List<APIKey>> getApiKeys() async {
    final res = await _api.get('/api/v1/apikey/list');
    return parseJsonMapList(res['data']).map(APIKey.fromJson).toList();
  }

  Future<APIKey> createApiKey(APIKey apiKey) async {
    final res = await _api.post('/api/v1/apikey/create', body: apiKey.toJson());
    return APIKey.fromJson(parseJsonMap(res['data']) ?? {});
  }

  Future<APIKey> updateApiKey(APIKey apiKey) async {
    final res = await _api.post('/api/v1/apikey/update', body: apiKey.toJson());
    return APIKey.fromJson(parseJsonMap(res['data']) ?? {});
  }

  Future<void> deleteApiKey(int id) async {
    await _api.delete('/api/v1/apikey/delete/$id');
  }

  // ====== Model / Price ======
  Future<List<LLMInfo>> getModels() async {
    final res = await _api.get('/api/v1/model/list');
    return parseJsonMapList(res['data']).map(LLMInfo.fromJson).toList();
  }

  Future<LLMInfo> createModel(LLMInfo model) async {
    final res = await _api.post('/api/v1/model/create', body: model.toJson());
    return LLMInfo.fromJson(parseJsonMap(res['data']) ?? {});
  }

  Future<LLMInfo> updateModel(LLMInfo model) async {
    final res = await _api.post('/api/v1/model/update', body: model.toJson());
    return LLMInfo.fromJson(parseJsonMap(res['data']) ?? {});
  }

  Future<void> deleteModel(String name) async {
    await _api.post('/api/v1/model/delete', body: {'name': name});
  }

  Future<List<LLMChannel>> getModelChannels() async {
    final res = await _api.get('/api/v1/model/channel');
    // 后端可能返回 Map（以 key 为名称的对象）或 List，两种格式都支持
    final data = res['data'];
    if (data is List) {
      return parseJsonMapList(data).map(LLMChannel.fromJson).toList();
    } else if (data is Map) {
      return data.entries
          .map((entry) {
            final item = parseJsonMap(entry.value);
            if (item == null) return null;
            return LLMChannel.fromJson({'name': entry.key.toString(), ...item});
          })
          .whereType<LLMChannel>()
          .toList();
    }
    return [];
  }

  Future<void> updateModelPrice() async {
    await _api.post('/api/v1/model/update-price');
  }

  Future<String> getLastModelUpdateTime() async {
    final res = await _api.get('/api/v1/model/last-update-time');
    return res['data']?.toString() ?? '';
  }

  Future<ModelMarketResponse> getModelMarket() async {
    final res = await _api.get('/api/v1/model/market');
    return ModelMarketResponse.fromJson(parseJsonMap(res['data']) ?? {});
  }

  // ====== Log ======
  Future<List<RelayLog>> getLogs({int page = 1, int pageSize = 20}) async {
    final res = await _api.get(
      '/api/v1/log/list',
      query: {'page': '$page', 'page_size': '$pageSize'},
    );
    return parseJsonMapList(res['data']).map(RelayLog.fromJson).toList();
  }

  Future<RelayLog> getLogDetail(int id) async {
    final res = await _api.get('/api/v1/log/detail', query: {'id': '$id'});
    return RelayLog.fromJson(parseJsonMap(res['data']) ?? {});
  }

  Future<void> clearLogs() async {
    await _api.delete('/api/v1/log/clear');
  }

  // ====== Setting ======
  Future<List<Setting>> getSettings() async {
    final res = await _api.get('/api/v1/setting/list');
    return parseJsonMapList(res['data']).map(Setting.fromJson).toList();
  }

  Future<void> setSetting(String key, String value) async {
    await _api.post('/api/v1/setting/set', body: {'key': key, 'value': value});
  }

  Future<String> exportSettings({
    bool includeLogs = false,
    bool includeStats = false,
  }) async {
    final res = await _api.get(
      '/api/v1/setting/export',
      query: {
        'include_logs': includeLogs.toString(),
        'include_stats': includeStats.toString(),
      },
    );
    // export returns JSON as a string
    return jsonEncode(res);
  }

  Future<Map<String, dynamic>> importSettings(String jsonData) async {
    final res = await _api.post(
      '/api/v1/setting/import',
      body: jsonData,
      contentType: 'application/json',
    );
    if (res is String) {
      final decoded = parseJsonMap(jsonDecode(res)) ?? {};
      return parseJsonMap(decoded['data']) ?? decoded;
    }
    if (res is Map<String, dynamic>) {
      return parseJsonMap(res['data']) ?? res;
    }
    return {};
  }

  // ====== Alert ======
  Future<List<AlertRule>> getAlertRules() async {
    final res = await _api.get('/api/v1/alert/rule/list');
    return parseJsonMapList(res['data']).map(AlertRule.fromJson).toList();
  }

  Future<AlertRule> createAlertRule(AlertRule rule) async {
    final res = await _api.post(
      '/api/v1/alert/rule/create',
      body: rule.toJson(),
    );
    return AlertRule.fromJson(parseJsonMap(res['data']) ?? {});
  }

  Future<void> updateAlertRule(AlertRule rule) async {
    await _api.post('/api/v1/alert/rule/update', body: rule.toJson());
  }

  Future<void> deleteAlertRule(int id) async {
    await _api.delete('/api/v1/alert/rule/delete/$id');
  }

  Future<List<AlertNotifChannel>> getNotifChannels() async {
    final res = await _api.get('/api/v1/alert/notif/list');
    return parseJsonMapList(res['data'])
        .map(AlertNotifChannel.fromJson)
        .toList();
  }

  Future<AlertNotifChannel> createNotifChannel(AlertNotifChannel ch) async {
    final res = await _api.post('/api/v1/alert/notif/create', body: ch.toJson());
    return AlertNotifChannel.fromJson(parseJsonMap(res['data']) ?? {});
  }

  Future<void> updateNotifChannel(AlertNotifChannel ch) async {
    await _api.post('/api/v1/alert/notif/update', body: ch.toJson());
  }

  Future<void> deleteNotifChannel(int id) async {
    await _api.delete('/api/v1/alert/notif/delete/$id');
  }

  Future<List<AlertHistory>> getAlertHistory({int limit = 100}) async {
    final res = await _api.get(
      '/api/v1/alert/history',
      query: {'limit': '$limit'},
    );
    return parseJsonMapList(res['data']).map(AlertHistory.fromJson).toList();
  }

  // ====== Ops ======
  Future<OpsCacheStatus> getOpsCache() async {
    final res = await _api.get('/api/v1/ops/cache');
    return OpsCacheStatus.fromJson(parseJsonMap(res['data']) ?? {});
  }

  Future<OpsQuotaSummary> getOpsQuota() async {
    final res = await _api.get('/api/v1/ops/quota');
    return OpsQuotaSummary.fromJson(parseJsonMap(res['data']) ?? {});
  }

  Future<OpsHealthStatus> getOpsHealth() async {
    final res = await _api.get('/api/v1/ops/health');
    return OpsHealthStatus.fromJson(parseJsonMap(res['data']) ?? {});
  }

  Future<OpsSystemSummary> getOpsSystem() async {
    final res = await _api.get('/api/v1/ops/system');
    return OpsSystemSummary.fromJson(parseJsonMap(res['data']) ?? {});
  }

  // ====== Analytics ======
  Future<AnalyticsOverview> getAnalyticsOverview({String range = '7d'}) async {
    final res = await _api.get(
      '/api/v1/analytics/overview',
      query: {'range': range},
    );
    return AnalyticsOverview.fromJson(parseJsonMap(res['data']) ?? {});
  }

  Future<List<AnalyticsBreakdownItem>> getAnalyticsProviderBreakdown({
    String range = '7d',
  }) async {
    final res = await _api.get(
      '/api/v1/analytics/provider-breakdown',
      query: {'range': range},
    );
    return parseJsonMapList(res['data'])
        .map(AnalyticsBreakdownItem.fromProviderJson)
        .toList();
  }

  Future<List<AnalyticsBreakdownItem>> getAnalyticsModelBreakdown({
    String range = '7d',
  }) async {
    final res = await _api.get(
      '/api/v1/analytics/model-breakdown',
      query: {'range': range},
    );
    return parseJsonMapList(res['data'])
        .map(AnalyticsBreakdownItem.fromModelJson)
        .toList();
  }

  Future<List<AnalyticsBreakdownItem>> getAnalyticsApiKeyBreakdown({
    String range = '7d',
  }) async {
    final res = await _api.get(
      '/api/v1/analytics/apikey-breakdown',
      query: {'range': range},
    );
    return parseJsonMapList(res['data'])
        .map(AnalyticsBreakdownItem.fromApiKeyJson)
        .toList();
  }

  Future<List<AnalyticsGroupHealthItem>> getAnalyticsGroupHealth() async {
    final res = await _api.get('/api/v1/analytics/group-health');
    return parseJsonMapList(res['data'])
        .map(AnalyticsGroupHealthItem.fromJson)
        .toList();
  }

  Future<AnalyticsUtilization> getAnalyticsUtilization({
    String range = '7d',
  }) async {
    final res = await _api.get(
      '/api/v1/analytics/utilization',
      query: {'range': range},
    );
    return AnalyticsUtilization.fromJson(parseJsonMap(res['data']) ?? {});
  }

  Future<AnalyticsEvaluationSummary> getAnalyticsEvaluation() async {
    final res = await _api.get('/api/v1/analytics/evaluation');
    final data = parseJsonMap(res['data']) ?? {};
    return AnalyticsEvaluationSummary.fromJson(
      parseJsonMap(data['semantic_cache']) ?? {},
    );
  }

  Future<List<AnalyticsChannelModelItem>> getAnalyticsChannelModel({
    String range = '7d',
  }) async {
    final res = await _api.get(
      '/api/v1/analytics/channel-model',
      query: {'range': range},
    );
    return parseJsonMapList(res['data'])
        .map(AnalyticsChannelModelItem.fromJson)
        .toList();
  }

  Future<AnalyticsLatencyDistribution> getAnalyticsLatencyDistribution({
    String range = '7d',
  }) async {
    final res = await _api.get(
      '/api/v1/analytics/latency-distribution',
      query: {'range': range},
    );
    return AnalyticsLatencyDistribution.fromJson(
      parseJsonMap(res['data']) ?? {},
    );
  }

  Future<List<AutoStrategySnapshotItem>> getAnalyticsAutoStrategy() async {
    final res = await _api.get('/api/v1/analytics/auto-strategy');
    return parseJsonMapList(res['data'])
        .map(AutoStrategySnapshotItem.fromJson)
        .toList();
  }

  // ====== Audit ======
  Future<List<AuditLog>> getAuditLogs({int page = 1, int pageSize = 50}) async {
    final res = await _api.get(
      '/api/v1/audit/list',
      query: {'page': '$page', 'page_size': '$pageSize'},
    );
    return parseJsonMapList(res['data']).map(AuditLog.fromJson).toList();
  }

  Future<AuditLog> getAuditLogDetail(int id) async {
    final res = await _api.get('/api/v1/audit/detail', query: {'id': '$id'});
    return AuditLog.fromJson(parseJsonMap(res['data']) ?? {});
  }

  // ====== Update ======
  Future<String> getCurrentVersion() async {
    final res = await _api.get('/api/v1/update/now-version');
    return res['data']?.toString() ?? 'unknown';
  }

  Future<Map<String, dynamic>> checkUpdate() async {
    final res = await _api.get('/api/v1/update');
    return parseJsonMap(res['data']) ?? {};
  }

  Future<void> updateCore() async {
    await _api.post('/api/v1/update');
  }
}
