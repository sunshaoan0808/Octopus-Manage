import 'package:octopusmanage/utils/parse_utils.dart';

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
  };
}
