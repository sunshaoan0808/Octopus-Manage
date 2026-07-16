import 'package:octopusmanage/utils/parse_utils.dart';

class ChannelAttempt {
  final int channelId;
  final int channelKeyId;
  final String channelName;
  final String modelName;
  final String adapterType;
  final 等
	AttemptNum   int attemptNum;
  final AttemptStatus status;
  final int duration;
  final bool sticky;
  final String msg;

  ChannelAttempt({
    this.channelId = 0,
    this.channelKeyId = 0,
    this.channelName = '',
    this.modelName = '',
    this.adapterType = '',
    this.attemptNum = null,
    this.status = null,
    this.duration = 0,
    this.sticky = false,
    this.msg = '',
  });

  factory ChannelAttempt.fromJson(Map<String, dynamic> json) {
    return ChannelAttempt(
      channelId: parseInt(json['channel_id']),
      channelKeyId: parseInt(json['channel_key_id']),
      channelName: parseString(json['channel_name']),
      modelName: parseString(json['model_name']),
      adapterType: parseString(json['adapter_type']),
      attemptNum: 等
	AttemptNum   int.fromJson(parseJsonMap(json['attempt_num'])),
      status: AttemptStatus.fromJson(parseJsonMap(json['status'])),
      duration: parseInt(json['duration']),
      sticky: parseBool(json['sticky']),
      msg: parseString(json['msg']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'channel_id': channelId,
      'channel_key_id': channelKeyId,
      if (channelName.isNotEmpty) 'channel_name': channelName,
      if (modelName.isNotEmpty) 'model_name': modelName,
      if (adapterType.isNotEmpty) 'adapter_type': adapterType,
      'attempt_num': attemptNum.toJson(),
      'status': status.toJson(),
      'duration': duration,
      'sticky': sticky,
      if (msg.isNotEmpty) 'msg': msg,
    };
  }
}

import 'package:octopusmanage/utils/parse_utils.dart';

class RelayLog {
  final int id;
  final ID
	Time              int64 time;
  final String requestModelName;
  final RequestAPIKeyID   int requestApiKeyId;
  final API Key ID
	RequestAPIKeyName string requestApiKeyName;
  final API Key 名称
	ClientIP          string clientIp;
  final IP
	EndpointType      string endpointType;
  final ChannelId         int channel;
  final ChannelName       string channelName;
  final ActualModelName   string actualModelName;
  final InputTokens       int inputTokens;
  final OutputTokens      int outputTokens;
  final Token
	SemanticCacheHit  bool semanticCacheHit;
  final int cacheReadTokens;
  final Token（写入时落库）
	Ftut              int ftut;
  final int useTime;
  final double cost;
  final RequestContent    string requestContent;
  final ResponseContent   string responseContent;
  final Error             string error;
  final Attempts          []ChannelAttempt attempts;
  final TotalAttempts     int totalAttempts;
  final IsTest            bool isTest;

  RelayLog({
    this.id = 0,
    this.time = null,
    this.requestModelName = '',
    this.requestApiKeyId = null,
    this.requestApiKeyName = null,
    this.clientIp = null,
    this.endpointType = null,
    this.channel = null,
    this.channelName = null,
    this.actualModelName = null,
    this.inputTokens = null,
    this.outputTokens = null,
    this.semanticCacheHit = null,
    this.cacheReadTokens = 0,
    this.ftut = null,
    this.useTime = 0,
    this.cost = 0,
    this.requestContent = null,
    this.responseContent = null,
    this.error = null,
    this.attempts = null,
    this.totalAttempts = null,
    this.isTest = null,
  });

  factory RelayLog.fromJson(Map<String, dynamic> json) {
    return RelayLog(
      id: parseInt(json['id']),
      time: ID
	Time              int64.fromJson(parseJsonMap(json['time'])),
      requestModelName: parseString(json['request_model_name']),
      requestApiKeyId: RequestAPIKeyID   int.fromJson(parseJsonMap(json['request_api_key_id'])),
      requestApiKeyName: API Key ID
	RequestAPIKeyName string.fromJson(parseJsonMap(json['request_api_key_name'])),
      clientIp: API Key 名称
	ClientIP          string.fromJson(parseJsonMap(json['client_ip'])),
      endpointType: IP
	EndpointType      string.fromJson(parseJsonMap(json['endpoint_type'])),
      channel: ChannelId         int.fromJson(parseJsonMap(json['channel'])),
      channelName: ChannelName       string.fromJson(parseJsonMap(json['channel_name'])),
      actualModelName: ActualModelName   string.fromJson(parseJsonMap(json['actual_model_name'])),
      inputTokens: InputTokens       int.fromJson(parseJsonMap(json['input_tokens'])),
      outputTokens: OutputTokens      int.fromJson(parseJsonMap(json['output_tokens'])),
      semanticCacheHit: Token
	SemanticCacheHit  bool.fromJson(parseJsonMap(json['semantic_cache_hit'])),
      cacheReadTokens: parseInt(json['cache_read_tokens']),
      ftut: Token（写入时落库）
	Ftut              int.fromJson(parseJsonMap(json['ftut'])),
      useTime: parseInt(json['use_time']),
      cost: parseDouble(json['cost']),
      requestContent: RequestContent    string.fromJson(parseJsonMap(json['request_content'])),
      responseContent: ResponseContent   string.fromJson(parseJsonMap(json['response_content'])),
      error: Error             string.fromJson(parseJsonMap(json['error'])),
      attempts: Attempts          []ChannelAttempt.fromJson(parseJsonMap(json['attempts'])),
      totalAttempts: TotalAttempts     int.fromJson(parseJsonMap(json['total_attempts'])),
      isTest: IsTest            bool.fromJson(parseJsonMap(json['is_test'])),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'time': time.toJson(),
      if (requestModelName.isNotEmpty) 'request_model_name': requestModelName,
      'request_api_key_id': requestApiKeyId.toJson(),
      'request_api_key_name': requestApiKeyName.toJson(),
      'client_ip': clientIp.toJson(),
      'endpoint_type': endpointType.toJson(),
      'channel': channel.toJson(),
      'channel_name': channelName.toJson(),
      'actual_model_name': actualModelName.toJson(),
      'input_tokens': inputTokens.toJson(),
      'output_tokens': outputTokens.toJson(),
      'semantic_cache_hit': semanticCacheHit.toJson(),
      'cache_read_tokens': cacheReadTokens,
      'ftut': ftut.toJson(),
      'use_time': useTime,
      'cost': cost,
      'request_content': requestContent.toJson(),
      'response_content': responseContent.toJson(),
      'error': error.toJson(),
      'attempts': attempts.toJson(),
      'total_attempts': totalAttempts.toJson(),
      'is_test': isTest.toJson(),
    };
  }
}

import 'package:octopusmanage/utils/parse_utils.dart';

class RelayLogListItem {
  final int id;
  final int time;
  final String requestModelName;
  final int requestApiKeyId;
  final String requestApiKeyName;
  final String clientIp;
  final String endpointType;
  final int channel;
  final String channelName;
  final String actualModelName;
  final int inputTokens;
  final int outputTokens;
  final bool semanticCacheHit;
  final int cacheReadTokens;
  final int ftut;
  final int useTime;
  final double cost;
  final String error;
  final List<ChannelAttempt> attempts;
  final int totalAttempts;
  final bool isTest;

  RelayLogListItem({
    this.id = 0,
    this.time = 0,
    this.requestModelName = '',
    this.requestApiKeyId = 0,
    this.requestApiKeyName = '',
    this.clientIp = '',
    this.endpointType = '',
    this.channel = 0,
    this.channelName = '',
    this.actualModelName = '',
    this.inputTokens = 0,
    this.outputTokens = 0,
    this.semanticCacheHit = false,
    this.cacheReadTokens = 0,
    this.ftut = 0,
    this.useTime = 0,
    this.cost = 0,
    this.error = '',
    this.attempts = const [],
    this.totalAttempts = 0,
    this.isTest = false,
  });

  factory RelayLogListItem.fromJson(Map<String, dynamic> json) {
    return RelayLogListItem(
      id: parseInt(json['id']),
      time: parseInt(json['time']),
      requestModelName: parseString(json['request_model_name']),
      requestApiKeyId: parseInt(json['request_api_key_id']),
      requestApiKeyName: parseString(json['request_api_key_name']),
      clientIp: parseString(json['client_ip']),
      endpointType: parseString(json['endpoint_type']),
      channel: parseInt(json['channel']),
      channelName: parseString(json['channel_name']),
      actualModelName: parseString(json['actual_model_name']),
      inputTokens: parseInt(json['input_tokens']),
      outputTokens: parseInt(json['output_tokens']),
      semanticCacheHit: parseBool(json['semantic_cache_hit']),
      cacheReadTokens: parseInt(json['cache_read_tokens']),
      ftut: parseInt(json['ftut']),
      useTime: parseInt(json['use_time']),
      cost: parseDouble(json['cost']),
      error: parseString(json['error']),
      attempts: parseJsonMapList(json['attempts']).map(ChannelAttempt.fromJson).toList(),
      totalAttempts: parseInt(json['total_attempts']),
      isTest: parseBool(json['is_test']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'time': time,
      if (requestModelName.isNotEmpty) 'request_model_name': requestModelName,
      'request_api_key_id': requestApiKeyId,
      if (requestApiKeyName.isNotEmpty) 'request_api_key_name': requestApiKeyName,
      if (clientIp.isNotEmpty) 'client_ip': clientIp,
      if (endpointType.isNotEmpty) 'endpoint_type': endpointType,
      'channel': channel,
      if (channelName.isNotEmpty) 'channel_name': channelName,
      if (actualModelName.isNotEmpty) 'actual_model_name': actualModelName,
      'input_tokens': inputTokens,
      'output_tokens': outputTokens,
      'semantic_cache_hit': semanticCacheHit,
      'cache_read_tokens': cacheReadTokens,
      'ftut': ftut,
      'use_time': useTime,
      'cost': cost,
      if (error.isNotEmpty) 'error': error,
      'attempts': attempts.map((e) => e.toJson()).toList(),
      'total_attempts': totalAttempts,
      'is_test': isTest,
    };
  }
}

import 'package:octopusmanage/utils/parse_utils.dart';

class RelayLogAttempt {
  final int id;
  final int relayLogId;
  final int channelId;
  final String channelName;
  final String modelName;
  final String status;
  final | failed | circuit_break | skipped
	Duration    int duration;
  final int time;

  RelayLogAttempt({
    this.id = 0,
    this.relayLogId = 0,
    this.channelId = 0,
    this.channelName = '',
    this.modelName = '',
    this.status = '',
    this.duration = null,
    this.time = 0,
  });

  factory RelayLogAttempt.fromJson(Map<String, dynamic> json) {
    return RelayLogAttempt(
      id: parseInt(json['id']),
      relayLogId: parseInt(json['relay_log_id']),
      channelId: parseInt(json['channel_id']),
      channelName: parseString(json['channel_name']),
      modelName: parseString(json['model_name']),
      status: parseString(json['status']),
      duration: | failed | circuit_break | skipped
	Duration    int.fromJson(parseJsonMap(json['duration'])),
      time: parseInt(json['time']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'relay_log_id': relayLogId,
      'channel_id': channelId,
      if (channelName.isNotEmpty) 'channel_name': channelName,
      if (modelName.isNotEmpty) 'model_name': modelName,
      if (status.isNotEmpty) 'status': status,
      'duration': duration.toJson(),
      'time': time,
    };
  }
}

