import 'package:octopusmanage/utils/parse_utils.dart';

class AnalyticsMetrics {
  final int requestCount;
  final int totalTokens;
  final int inputTokens;
  final int outputTokens;
  final double totalCost;
  final double successRate;

  AnalyticsMetrics({
    this.requestCount = 0,
    this.totalTokens = 0,
    this.inputTokens = 0,
    this.outputTokens = 0,
    this.totalCost = 0,
    this.successRate = 0,
  });

  factory AnalyticsMetrics.fromJson(Map<String, dynamic> json) {
    return AnalyticsMetrics(
      requestCount: parseInt(json['request_count']),
      totalTokens: parseInt(json['total_tokens']),
      inputTokens: parseInt(json['input_tokens']),
      outputTokens: parseInt(json['output_tokens']),
      totalCost: parseDouble(json['total_cost']),
      successRate: parseDouble(json['success_rate']),
    );
  }
}

class AnalyticsOverview {
  final AnalyticsMetrics metrics;
  final int providerCount;
  final int apiKeyCount;
  final int modelCount;
  final double fallbackRate;

  AnalyticsOverview({
    AnalyticsMetrics? metrics,
    this.providerCount = 0,
    this.apiKeyCount = 0,
    this.modelCount = 0,
    this.fallbackRate = 0,
  }) : metrics = metrics ?? AnalyticsMetrics();

  factory AnalyticsOverview.fromJson(Map<String, dynamic> json) {
    return AnalyticsOverview(
      metrics: AnalyticsMetrics.fromJson(json),
      providerCount: parseInt(json['provider_count']),
      apiKeyCount: parseInt(json['api_key_count']),
      modelCount: parseInt(json['model_count']),
      fallbackRate: parseDouble(json['fallback_rate']),
    );
  }
}

class AutoStrategySnapshotItem {
  final String model;
  final String bestChannel;
  final double bestScore;
  final String reason;

  AutoStrategySnapshotItem({
    this.model = '',
    this.bestChannel = '',
    this.bestScore = 0,
    this.reason = '',
  });

  factory AutoStrategySnapshotItem.fromJson(Map<String, dynamic> json) {
    return AutoStrategySnapshotItem(
      model: parseString(json['model']),
      bestChannel: parseString(json['best_channel']),
      bestScore: parseDouble(json['best_score']),
      reason: parseString(json['reason']),
    );
  }
}

class AnalyticsGroupHealthItem {
  final int groupId;
  final String groupName;
  final String endpointType;
  final int itemCount;
  final int enabledItemCount;
  final int disabledItemCount;
  final int failureCount;
  final int lastFailureAt;
  final int healthScore;
  final String status;
  final List<String> failingChannels;
  final String mode;
  final List<int> channelIds;
  final List<AutoStrategySnapshotItem> autoItems;

  AnalyticsGroupHealthItem({
    this.groupId = 0,
    this.groupName = '',
    this.endpointType = '',
    this.itemCount = 0,
    this.enabledItemCount = 0,
    this.disabledItemCount = 0,
    this.failureCount = 0,
    this.lastFailureAt = 0,
    this.healthScore = 0,
    this.status = '',
    List<String>? failingChannels,
    this.mode = '',
    List<int>? channelIds,
    List<AutoStrategySnapshotItem>? autoItems,
  })  : failingChannels = failingChannels ?? [],
        channelIds = channelIds ?? [],
        autoItems = autoItems ?? [];

  factory AnalyticsGroupHealthItem.fromJson(Map<String, dynamic> json) {
    return AnalyticsGroupHealthItem(
      groupId: parseInt(json['group_id']),
      groupName: parseString(json['group_name']),
      endpointType: parseString(json['endpoint_type']),
      itemCount: parseInt(json['item_count']),
      enabledItemCount: parseInt(json['enabled_item_count']),
      disabledItemCount: parseInt(json['disabled_item_count']),
      failureCount: parseInt(json['failure_count']),
      lastFailureAt: parseInt(json['last_failure_at']),
      healthScore: parseInt(json['health_score']),
      status: parseString(json['status']),
      failingChannels: parseStringList(json['failing_channels']),
      mode: parseString(json['mode']),
      channelIds: parseIntList(json['channel_ids']),
      autoItems: parseJsonMapList(json['auto_items'])
          .map(AutoStrategySnapshotItem.fromJson)
          .toList(),
    );
  }
}

class AnalyticsBreakdownItem {
  final int channelId;
  final String channelName;
  final bool enabled;
  final String modelName;
  final int? apiKeyId;
  final String name;
  final AnalyticsMetrics metrics;

  AnalyticsBreakdownItem({
    this.channelId = 0,
    this.channelName = '',
    this.enabled = true,
    this.modelName = '',
    this.apiKeyId,
    this.name = '',
    AnalyticsMetrics? metrics,
  }) : metrics = metrics ?? AnalyticsMetrics();

  factory AnalyticsBreakdownItem.fromProviderJson(Map<String, dynamic> json) {
    return AnalyticsBreakdownItem(
      channelId: parseInt(json['channel_id']),
      channelName: parseString(json['channel_name']),
      enabled: parseBool(json['enabled'], fallback: true),
      metrics: AnalyticsMetrics.fromJson(json),
    );
  }

  factory AnalyticsBreakdownItem.fromModelJson(Map<String, dynamic> json) {
    return AnalyticsBreakdownItem(
      modelName: parseString(json['model_name']),
      metrics: AnalyticsMetrics.fromJson(json),
    );
  }

  factory AnalyticsBreakdownItem.fromApiKeyJson(Map<String, dynamic> json) {
    return AnalyticsBreakdownItem(
      apiKeyId: json['api_key_id'] as int?,
      name: parseString(json['name']),
      metrics: AnalyticsMetrics.fromJson(json),
    );
  }
}

class AnalyticsUtilization {
  final List<AnalyticsBreakdownItem> providerBreakdown;
  final List<AnalyticsBreakdownItem> modelBreakdown;
  final List<AnalyticsBreakdownItem> apiKeyBreakdown;

  AnalyticsUtilization({
    List<AnalyticsBreakdownItem>? providerBreakdown,
    List<AnalyticsBreakdownItem>? modelBreakdown,
    List<AnalyticsBreakdownItem>? apiKeyBreakdown,
  })  : providerBreakdown = providerBreakdown ?? [],
        modelBreakdown = modelBreakdown ?? [],
        apiKeyBreakdown = apiKeyBreakdown ?? [];

  factory AnalyticsUtilization.fromJson(Map<String, dynamic> json) {
    return AnalyticsUtilization(
      providerBreakdown: parseJsonMapList(json['provider_breakdown'])
          .map(AnalyticsBreakdownItem.fromProviderJson)
          .toList(),
      modelBreakdown: parseJsonMapList(json['model_breakdown'])
          .map(AnalyticsBreakdownItem.fromModelJson)
          .toList(),
      apiKeyBreakdown: parseJsonMapList(json['apikey_breakdown'])
          .map(AnalyticsBreakdownItem.fromApiKeyJson)
          .toList(),
    );
  }
}

class AnalyticsEvaluationSummary {
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
  final int evaluatedRequests;
  final int cacheHitResponses;
  final int cacheMissRequests;
  final int bypassedRequests;
  final int storedResponses;

  AnalyticsEvaluationSummary({
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
    this.evaluatedRequests = 0,
    this.cacheHitResponses = 0,
    this.cacheMissRequests = 0,
    this.bypassedRequests = 0,
    this.storedResponses = 0,
  });

  factory AnalyticsEvaluationSummary.fromJson(Map<String, dynamic> json) {
    return AnalyticsEvaluationSummary(
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
      evaluatedRequests: parseInt(json['evaluated_requests']),
      cacheHitResponses: parseInt(json['cache_hit_responses']),
      cacheMissRequests: parseInt(json['cache_miss_requests']),
      bypassedRequests: parseInt(json['bypassed_requests']),
      storedResponses: parseInt(json['stored_responses']),
    );
  }
}

class AnalyticsChannelModelItem {
  final int channelId;
  final String channelName;
  final String modelName;
  final int requestCount;
  final double successRate;
  final double avgLatency;

  AnalyticsChannelModelItem({
    this.channelId = 0,
    this.channelName = '',
    this.modelName = '',
    this.requestCount = 0,
    this.successRate = 0,
    this.avgLatency = 0,
  });

  factory AnalyticsChannelModelItem.fromJson(Map<String, dynamic> json) {
    return AnalyticsChannelModelItem(
      channelId: parseInt(json['channel_id']),
      channelName: parseString(json['channel_name']),
      modelName: parseString(json['model_name']),
      requestCount: parseInt(json['request_count']),
      successRate: parseDouble(json['success_rate']),
      avgLatency: parseDouble(json['avg_latency']),
    );
  }
}

class HistogramBucket {
  final String bucketLabel;
  final int count;

  HistogramBucket({
    this.bucketLabel = '',
    this.count = 0,
  });

  factory HistogramBucket.fromJson(Map<String, dynamic> json) {
    return HistogramBucket(
      bucketLabel: parseString(json['bucket_label']),
      count: parseInt(json['count']),
    );
  }
}

class AnalyticsLatencyDistribution {
  final List<HistogramBucket> buckets;
  final double p50;
  final double p95;
  final double p99;

  AnalyticsLatencyDistribution({
    List<HistogramBucket>? buckets,
    this.p50 = 0,
    this.p95 = 0,
    this.p99 = 0,
  }) : buckets = buckets ?? [];

  factory AnalyticsLatencyDistribution.fromJson(Map<String, dynamic> json) {
    return AnalyticsLatencyDistribution(
      buckets: parseJsonMapList(json['buckets'])
          .map(HistogramBucket.fromJson)
          .toList(),
      p50: parseDouble(json['p50']),
      p95: parseDouble(json['p95']),
      p99: parseDouble(json['p99']),
    );
  }
}
