import 'package:octopusmanage/utils/parse_utils.dart';

/// Represents a single channel attempt during relay.
class ChannelAttempt {
  final int channelId;
  final String channelName;
  final String modelName;
  final int attemptNum;
  final String status;
  final int duration;
  final String msg;

  ChannelAttempt({
    this.channelId = 0,
    this.channelName = '',
    this.modelName = '',
    this.attemptNum = 0,
    this.status = '',
    this.duration = 0,
    this.msg = '',
  });

  factory ChannelAttempt.fromJson(Map<String, dynamic> json) {
    return ChannelAttempt(
      channelId: parseInt(json['channel_id']),
      channelName: parseString(json['channel_name']),
      modelName: parseString(json['model_name']),
      attemptNum: parseInt(json['attempt_num']),
      status: parseString(json['status']),
      duration: parseInt(json['duration']),
      msg: parseString(json['msg']),
    );
  }

  Map<String, dynamic> toJson() => {
    'channel_id': channelId,
    'channel_name': channelName,
    'model_name': modelName,
    'attempt_num': attemptNum,
    'status': status,
    'duration': duration,
    'msg': msg,
  };
}

class RelayLog {
  final int id;
  final int time;
  final String requestModelName;
  final String requestApiKeyName;
  final int channelId;
  final String channelName;
  final String actualModelName;
  final int inputTokens;
  final int outputTokens;
  final int ftut;
  final int useTime;
  final double cost;
  final String error;

  // Phase 2.2: New fields
  final int requestApiKeyId;
  final String clientIp;
  final String endpointType;
  final bool semanticCacheHit;
  final int cacheReadTokens;
  final List<ChannelAttempt> attempts;
  final int totalAttempts;
  final bool isTest;

  RelayLog({
    required this.id,
    this.time = 0,
    this.requestModelName = '',
    this.requestApiKeyName = '',
    this.channelId = 0,
    this.channelName = '',
    this.actualModelName = '',
    this.inputTokens = 0,
    this.outputTokens = 0,
    this.ftut = 0,
    this.useTime = 0,
    this.cost = 0,
    this.error = '',
    this.requestApiKeyId = 0,
    this.clientIp = '',
    this.endpointType = '',
    this.semanticCacheHit = false,
    this.cacheReadTokens = 0,
    this.attempts = const [],
    this.totalAttempts = 0,
    this.isTest = false,
  });

  factory RelayLog.fromJson(Map<String, dynamic> json) {
    return RelayLog(
      id: parseInt(json['id']),
      time: parseInt(json['time']),
      requestModelName: parseString(json['request_model_name']),
      requestApiKeyName: parseString(json['request_api_key_name']),
      channelId: parseInt(json['channel_id'] ?? json['channel']),
      channelName: parseString(json['channel_name']),
      actualModelName: parseString(json['actual_model_name']),
      inputTokens: parseInt(json['input_tokens']),
      outputTokens: parseInt(json['output_tokens']),
      ftut: parseInt(json['ftut']),
      useTime: parseInt(json['use_time']),
      cost: parseDouble(json['cost']),
      error: parseString(json['error']),
      // Phase 2.2: New fields
      requestApiKeyId: parseInt(json['request_api_key_id']),
      clientIp: parseString(json['client_ip']),
      endpointType: parseString(json['endpoint_type']),
      semanticCacheHit: parseBool(json['semantic_cache_hit']),
      cacheReadTokens: parseInt(json['cache_read_tokens']),
      attempts: parseJsonMapList(json['attempts'])
          .map(ChannelAttempt.fromJson)
          .toList(),
      totalAttempts: parseInt(json['total_attempts']),
      isTest: parseBool(json['is_test']),
    );
  }

  bool get hasError => error.isNotEmpty;

  Map<String, dynamic> toJson() => {
    'id': id,
    'time': time,
    'request_model_name': requestModelName,
    'request_api_key_name': requestApiKeyName,
    'channel_id': channelId,
    'channel_name': channelName,
    'actual_model_name': actualModelName,
    'input_tokens': inputTokens,
    'output_tokens': outputTokens,
    'ftut': ftut,
    'use_time': useTime,
    'cost': cost,
    'error': error,
    // Phase 2.2: New fields
    'request_api_key_id': requestApiKeyId,
    'client_ip': clientIp,
    'endpoint_type': endpointType,
    'semantic_cache_hit': semanticCacheHit,
    'cache_read_tokens': cacheReadTokens,
    'attempts': attempts.map((e) => e.toJson()).toList(),
    'total_attempts': totalAttempts,
    'is_test': isTest,
  };
}
