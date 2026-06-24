import 'package:octopusmanage/utils/parse_utils.dart';

class OpsCacheStatus {
  final bool enabled;
  final bool runtimeEnabled;
  final int ttlSeconds;
  final int threshold;
  final int maxEntries;
  final int currentEntries;
  final int hits;
  final int misses;
  final double hitRate;
  final double usageRate;

  OpsCacheStatus({
    this.enabled = false,
    this.runtimeEnabled = false,
    this.ttlSeconds = 0,
    this.threshold = 0,
    this.maxEntries = 0,
    this.currentEntries = 0,
    this.hits = 0,
    this.misses = 0,
    this.hitRate = 0,
    this.usageRate = 0,
  });

  factory OpsCacheStatus.fromJson(Map<String, dynamic> json) {
    return OpsCacheStatus(
      enabled: parseBool(json['enabled']),
      runtimeEnabled: parseBool(json['runtime_enabled']),
      ttlSeconds: parseInt(json['ttl_seconds']),
      threshold: parseInt(json['threshold']),
      maxEntries: parseInt(json['max_entries']),
      currentEntries: parseInt(json['current_entries']),
      hits: parseInt(json['hits']),
      misses: parseInt(json['misses']),
      hitRate: parseDouble(json['hit_rate']),
      usageRate: parseDouble(json['usage_rate']),
    );
  }
}

class OpsQuotaSummary {
  final int totalKeyCount;
  final int enabledKeyCount;
  final int availableKeyCount;
  final int expiredKeyCount;
  final int limitedKeyCount;
  final int unlimitedKeyCount;
  final int exhaustedKeyCount;
  final int perModelQuotaKeyCount;
  final int activeUsageKeyCount;
  final int totalRPM;
  final int totalTPM;
  final double totalMaxCost;

  OpsQuotaSummary({
    this.totalKeyCount = 0,
    this.enabledKeyCount = 0,
    this.availableKeyCount = 0,
    this.expiredKeyCount = 0,
    this.limitedKeyCount = 0,
    this.unlimitedKeyCount = 0,
    this.exhaustedKeyCount = 0,
    this.perModelQuotaKeyCount = 0,
    this.activeUsageKeyCount = 0,
    this.totalRPM = 0,
    this.totalTPM = 0,
    this.totalMaxCost = 0,
  });

  factory OpsQuotaSummary.fromJson(Map<String, dynamic> json) {
    return OpsQuotaSummary(
      totalKeyCount: parseInt(json['total_key_count']),
      enabledKeyCount: parseInt(json['enabled_key_count']),
      availableKeyCount: parseInt(json['available_key_count']),
      expiredKeyCount: parseInt(json['expired_key_count']),
      limitedKeyCount: parseInt(json['limited_key_count']),
      unlimitedKeyCount: parseInt(json['unlimited_key_count']),
      exhaustedKeyCount: parseInt(json['exhausted_key_count']),
      perModelQuotaKeyCount: parseInt(json['per_model_quota_key_count']),
      activeUsageKeyCount: parseInt(json['active_usage_key_count']),
      totalRPM: parseInt(json['total_rpm']),
      totalTPM: parseInt(json['total_tpm']),
      totalMaxCost: parseDouble(json['total_max_cost']),
    );
  }
}

class OpsHealthStatus {
  final bool databaseOK;
  final bool cacheOK;
  final bool taskRuntimeOK;
  final int recentErrorCount;
  final int healthyGroupCount;
  final int warningGroupCount;
  final int degradedGroupCount;
  final int downGroupCount;
  final int emptyGroupCount;
  final int checkedAt;

  OpsHealthStatus({
    this.databaseOK = false,
    this.cacheOK = false,
    this.taskRuntimeOK = false,
    this.recentErrorCount = 0,
    this.healthyGroupCount = 0,
    this.warningGroupCount = 0,
    this.degradedGroupCount = 0,
    this.downGroupCount = 0,
    this.emptyGroupCount = 0,
    this.checkedAt = 0,
  });

  factory OpsHealthStatus.fromJson(Map<String, dynamic> json) {
    return OpsHealthStatus(
      databaseOK: parseBool(json['database_ok']),
      cacheOK: parseBool(json['cache_ok']),
      taskRuntimeOK: parseBool(json['task_runtime_ok']),
      recentErrorCount: parseInt(json['recent_error_count']),
      healthyGroupCount: parseInt(json['healthy_group_count']),
      warningGroupCount: parseInt(json['warning_group_count']),
      degradedGroupCount: parseInt(json['degraded_group_count']),
      downGroupCount: parseInt(json['down_group_count']),
      emptyGroupCount: parseInt(json['empty_group_count']),
      checkedAt: parseInt(json['checked_at']),
    );
  }
}

class OpsSystemSummary {
  final String version;
  final String commit;
  final String buildTime;
  final String databaseType;
  final String publicAPIBaseURL;
  final String proxyURL;
  final bool relayLogKeepEnabled;
  final int relayLogKeepDays;
  final int statsSaveIntervalMinutes;
  final int syncLLMIntervalHours;
  final int modelInfoUpdateIntervalHours;
  final int channelCount;
  final int groupCount;
  final int apiKeyCount;
  final int aiRouteServiceCount;

  OpsSystemSummary({
    this.version = '',
    this.commit = '',
    this.buildTime = '',
    this.databaseType = '',
    this.publicAPIBaseURL = '',
    this.proxyURL = '',
    this.relayLogKeepEnabled = false,
    this.relayLogKeepDays = 0,
    this.statsSaveIntervalMinutes = 0,
    this.syncLLMIntervalHours = 0,
    this.modelInfoUpdateIntervalHours = 0,
    this.channelCount = 0,
    this.groupCount = 0,
    this.apiKeyCount = 0,
    this.aiRouteServiceCount = 0,
  });

  factory OpsSystemSummary.fromJson(Map<String, dynamic> json) {
    return OpsSystemSummary(
      version: parseString(json['version']),
      commit: parseString(json['commit']),
      buildTime: parseString(json['build_time']),
      databaseType: parseString(json['database_type']),
      publicAPIBaseURL: parseString(json['public_api_base_url']),
      proxyURL: parseString(json['proxy_url']),
      relayLogKeepEnabled: parseBool(json['relay_log_keep_enabled']),
      relayLogKeepDays: parseInt(json['relay_log_keep_days']),
      statsSaveIntervalMinutes: parseInt(json['stats_save_interval_minutes']),
      syncLLMIntervalHours: parseInt(json['sync_llm_interval_hours']),
      modelInfoUpdateIntervalHours: parseInt(
        json['model_info_update_interval_hours'],
      ),
      channelCount: parseInt(json['channel_count']),
      groupCount: parseInt(json['group_count']),
      apiKeyCount: parseInt(json['api_key_count']),
      aiRouteServiceCount: parseInt(json['ai_route_service_count']),
    );
  }
}
