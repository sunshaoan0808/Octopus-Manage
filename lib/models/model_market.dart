import 'package:octopusmanage/utils/parse_utils.dart';

class ModelMarketChannel {
  final int channelId;
  final String channelName;
  final bool enabled;
  final int enabledKeyCount;

  ModelMarketChannel({
    this.channelId = 0,
    this.channelName = '',
    this.enabled = true,
    this.enabledKeyCount = 0,
  });

  factory ModelMarketChannel.fromJson(Map<String, dynamic> json) {
    return ModelMarketChannel(
      channelId: parseInt(json['channel_id']),
      channelName: parseString(json['channel_name']),
      enabled: parseBool(json['enabled'], fallback: true),
      enabledKeyCount: parseInt(json['enabled_key_count']),
    );
  }
}

class ModelMarketItem {
  final String name;
  final double input;
  final double output;
  final double cacheRead;
  final double cacheWrite;
  final int channelCount;
  final int enabledKeyCount;
  final int averageLatencyMS;
  final double successRate;
  final int requestSuccess;
  final int requestFailed;
  final List<ModelMarketChannel> channels;

  ModelMarketItem({
    this.name = '',
    this.input = 0,
    this.output = 0,
    this.cacheRead = 0,
    this.cacheWrite = 0,
    this.channelCount = 0,
    this.enabledKeyCount = 0,
    this.averageLatencyMS = 0,
    this.successRate = 0,
    this.requestSuccess = 0,
    this.requestFailed = 0,
    List<ModelMarketChannel>? channels,
  }) : channels = channels ?? [];

  factory ModelMarketItem.fromJson(Map<String, dynamic> json) {
    return ModelMarketItem(
      name: parseString(json['name']),
      input: parseDouble(json['input']),
      output: parseDouble(json['output']),
      cacheRead: parseDouble(json['cache_read']),
      cacheWrite: parseDouble(json['cache_write']),
      channelCount: parseInt(json['channel_count']),
      enabledKeyCount: parseInt(json['enabled_key_count']),
      averageLatencyMS: parseInt(json['average_latency_ms']),
      successRate: parseDouble(json['success_rate']),
      requestSuccess: parseInt(json['request_success']),
      requestFailed: parseInt(json['request_failed']),
      channels: parseJsonMapList(json['channels'])
          .map(ModelMarketChannel.fromJson)
          .toList(),
    );
  }
}

class ModelMarketSummary {
  final int modelCount;
  final int coverageCount;
  final int uniqueChannelCount;
  final int averageLatencyMS;
  final String lastUpdateTime;

  ModelMarketSummary({
    this.modelCount = 0,
    this.coverageCount = 0,
    this.uniqueChannelCount = 0,
    this.averageLatencyMS = 0,
    this.lastUpdateTime = '',
  });

  factory ModelMarketSummary.fromJson(Map<String, dynamic> json) {
    return ModelMarketSummary(
      modelCount: parseInt(json['model_count']),
      coverageCount: parseInt(json['coverage_count']),
      uniqueChannelCount: parseInt(json['unique_channel_count']),
      averageLatencyMS: parseInt(json['average_latency_ms']),
      lastUpdateTime: parseString(json['last_update_time']),
    );
  }
}

class ModelMarketResponse {
  final ModelMarketSummary summary;
  final List<ModelMarketItem> items;

  ModelMarketResponse({
    ModelMarketSummary? summary,
    List<ModelMarketItem>? items,
  })  : summary = summary ?? ModelMarketSummary(),
        items = items ?? [];

  factory ModelMarketResponse.fromJson(Map<String, dynamic> json) {
    return ModelMarketResponse(
      summary: ModelMarketSummary.fromJson(
        parseJsonMap(json['summary']) ?? {},
      ),
      items: parseJsonMapList(json['items'])
          .map(ModelMarketItem.fromJson)
          .toList(),
    );
  }
}
