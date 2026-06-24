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
  final int relayRetryCount;
  final bool circuitBreakerEnabled;
  final int circuitBreakerThreshold;
  final int circuitBreakerRecoveryMs;
  final bool responseFilterEnabled;
  final int responseFilterRules;
  final bool aiRouteEnabled;
  final String aiRouteDefaultStrategy;

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
    this.relayRetryCount = 0,
    this.circuitBreakerEnabled = false,
    this.circuitBreakerThreshold = 0,
    this.circuitBreakerRecoveryMs = 0,
    this.responseFilterEnabled = false,
    this.responseFilterRules = 0,
    this.aiRouteEnabled = false,
    this.aiRouteDefaultStrategy = '',
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
      relayRetryCount: parseInt(json['relay_retry_count']),
      circuitBreakerEnabled: parseBool(json['circuit_breaker_enabled']),
      circuitBreakerThreshold: parseInt(json['circuit_breaker_threshold']),
      circuitBreakerRecoveryMs: parseInt(json['circuit_breaker_recovery_ms']),
      responseFilterEnabled: parseBool(json['response_filter_enabled']),
      responseFilterRules: parseInt(json['response_filter_rules']),
      aiRouteEnabled: parseBool(json['ai_route_enabled']),
      aiRouteDefaultStrategy: parseString(json['ai_route_default_strategy']),
    );
  }
}

// ====== Telemetry Models ======

class OpsTelemetrySummary {
  final OpsHeroMetrics heroMetrics;
  final OpsRuntimeSignals runtimeSignals;
  final OpsDatabaseHealth databaseHealth;
  final OpsSessionQuotaActivity sessionQuotaActivity;
  final OpsPromptCache promptCache;
  final OpsProviderHealth providerHealth;

  OpsTelemetrySummary({
    OpsHeroMetrics? heroMetrics,
    OpsRuntimeSignals? runtimeSignals,
    OpsDatabaseHealth? databaseHealth,
    OpsSessionQuotaActivity? sessionQuotaActivity,
    OpsPromptCache? promptCache,
    OpsProviderHealth? providerHealth,
  })  : heroMetrics = heroMetrics ?? OpsHeroMetrics(),
        runtimeSignals = runtimeSignals ?? OpsRuntimeSignals(),
        databaseHealth = databaseHealth ?? OpsDatabaseHealth(),
        sessionQuotaActivity = sessionQuotaActivity ?? OpsSessionQuotaActivity(),
        promptCache = promptCache ?? OpsPromptCache(),
        providerHealth = providerHealth ?? OpsProviderHealth();

  factory OpsTelemetrySummary.fromJson(Map<String, dynamic> json) {
    return OpsTelemetrySummary(
      heroMetrics: OpsHeroMetrics.fromJson(parseJsonMap(json['hero_metrics']) ?? {}),
      runtimeSignals: OpsRuntimeSignals.fromJson(parseJsonMap(json['runtime_signals']) ?? {}),
      databaseHealth: OpsDatabaseHealth.fromJson(parseJsonMap(json['database_health']) ?? {}),
      sessionQuotaActivity: OpsSessionQuotaActivity.fromJson(parseJsonMap(json['session_quota_activity']) ?? {}),
      promptCache: OpsPromptCache.fromJson(parseJsonMap(json['prompt_cache']) ?? {}),
      providerHealth: OpsProviderHealth.fromJson(parseJsonMap(json['provider_health']) ?? {}),
    );
  }
}

class OpsHeroMetrics {
  final String uptime;
  final int totalRequests;
  final double avgLatency;
  final double errorRate;
  final int activeConnections;
  final double memoryUsageMB;

  OpsHeroMetrics({
    this.uptime = '',
    this.totalRequests = 0,
    this.avgLatency = 0,
    this.errorRate = 0,
    this.activeConnections = 0,
    this.memoryUsageMB = 0,
  });

  factory OpsHeroMetrics.fromJson(Map<String, dynamic> json) {
    return OpsHeroMetrics(
      uptime: parseString(json['uptime']),
      totalRequests: parseInt(json['total_requests']),
      avgLatency: parseDouble(json['avg_latency']),
      errorRate: parseDouble(json['error_rate']),
      activeConnections: parseInt(json['active_connections']),
      memoryUsageMB: parseDouble(json['memory_usage_mb']),
    );
  }
}

class OpsRuntimeSignals {
  final int goroutineCount;
  final double gcPauseMs;
  final double heapAllocMB;
  final double heapInUseMB;

  OpsRuntimeSignals({
    this.goroutineCount = 0,
    this.gcPauseMs = 0,
    this.heapAllocMB = 0,
    this.heapInUseMB = 0,
  });

  factory OpsRuntimeSignals.fromJson(Map<String, dynamic> json) {
    return OpsRuntimeSignals(
      goroutineCount: parseInt(json['goroutine_count']),
      gcPauseMs: parseDouble(json['gc_pause_ms']),
      heapAllocMB: parseDouble(json['heap_alloc_mb']),
      heapInUseMB: parseDouble(json['heap_in_use_mb']),
    );
  }
}

class OpsDatabaseHealth {
  final String type;
  final bool connected;
  final double latencyMs;
  final int activeConnections;
  final int maxConnections;

  OpsDatabaseHealth({
    this.type = '',
    this.connected = false,
    this.latencyMs = 0,
    this.activeConnections = 0,
    this.maxConnections = 0,
  });

  factory OpsDatabaseHealth.fromJson(Map<String, dynamic> json) {
    return OpsDatabaseHealth(
      type: parseString(json['type']),
      connected: parseBool(json['connected']),
      latencyMs: parseDouble(json['latency_ms']),
      activeConnections: parseInt(json['active_connections']),
      maxConnections: parseInt(json['max_connections']),
    );
  }
}

class OpsSessionQuotaActivity {
  final int activeSessions;
  final int quotaExhaustedCount;
  final int recentQuotaEvents;

  OpsSessionQuotaActivity({
    this.activeSessions = 0,
    this.quotaExhaustedCount = 0,
    this.recentQuotaEvents = 0,
  });

  factory OpsSessionQuotaActivity.fromJson(Map<String, dynamic> json) {
    return OpsSessionQuotaActivity(
      activeSessions: parseInt(json['active_sessions']),
      quotaExhaustedCount: parseInt(json['quota_exhausted_count']),
      recentQuotaEvents: parseInt(json['recent_quota_events']),
    );
  }
}

class OpsPromptCache {
  final int hits;
  final int misses;
  final double hitRate;
  final int entries;
  final int maxEntries;
  final int evictions;

  OpsPromptCache({
    this.hits = 0,
    this.misses = 0,
    this.hitRate = 0,
    this.entries = 0,
    this.maxEntries = 0,
    this.evictions = 0,
  });

  factory OpsPromptCache.fromJson(Map<String, dynamic> json) {
    return OpsPromptCache(
      hits: parseInt(json['hits']),
      misses: parseInt(json['misses']),
      hitRate: parseDouble(json['hit_rate']),
      entries: parseInt(json['entries']),
      maxEntries: parseInt(json['max_entries']),
      evictions: parseInt(json['evictions']),
    );
  }
}

class OpsProviderHealth {
  final int totalProviders;
  final int healthyProviders;
  final int degradedProviders;
  final int downProviders;
  final List<OpsProviderItem> providers;

  OpsProviderHealth({
    this.totalProviders = 0,
    this.healthyProviders = 0,
    this.degradedProviders = 0,
    this.downProviders = 0,
    this.providers = const [],
  });

  factory OpsProviderHealth.fromJson(Map<String, dynamic> json) {
    return OpsProviderHealth(
      totalProviders: parseInt(json['total_providers']),
      healthyProviders: parseInt(json['healthy_providers']),
      degradedProviders: parseInt(json['degraded_providers']),
      downProviders: parseInt(json['down_providers']),
      providers: parseJsonMapList(json['providers'])
          .map(OpsProviderItem.fromJson)
          .toList(),
    );
  }
}

class OpsProviderItem {
  final String name;
  final String status;
  final double latencyMs;
  final double errorRate;
  final String lastCheckAt;

  OpsProviderItem({
    this.name = '',
    this.status = '',
    this.latencyMs = 0,
    this.errorRate = 0,
    this.lastCheckAt = '',
  });

  factory OpsProviderItem.fromJson(Map<String, dynamic> json) {
    return OpsProviderItem(
      name: parseString(json['name']),
      status: parseString(json['status']),
      latencyMs: parseDouble(json['latency_ms']),
      errorRate: parseDouble(json['error_rate']),
      lastCheckAt: parseString(json['last_check_at']),
    );
  }
}
