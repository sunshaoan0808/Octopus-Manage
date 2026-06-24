import 'package:octopusmanage/utils/parse_utils.dart';

class LLMInfo {
  final String name;
  final double input;
  final double output;
  final double cacheRead;
  final double cacheWrite;

  LLMInfo({
    required this.name,
    this.input = 0,
    this.output = 0,
    this.cacheRead = 0,
    this.cacheWrite = 0,
  });

  factory LLMInfo.fromJson(Map<String, dynamic> json) {
    final price = parseJsonMap(json['LLMPrice']);
    return LLMInfo(
      name: parseString(json['name']),
      input: json['input'] != null
          ? parseDouble(json['input'])
          : parseDouble(price?['input']),
      output: json['output'] != null
          ? parseDouble(json['output'])
          : parseDouble(price?['output']),
      cacheRead: json['cache_read'] != null
          ? parseDouble(json['cache_read'])
          : parseDouble(price?['cache_read']),
      cacheWrite: json['cache_write'] != null
          ? parseDouble(json['cache_write'])
          : parseDouble(price?['cache_write']),
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'input': input,
    'output': output,
    'cache_read': cacheRead,
    'cache_write': cacheWrite,
  };
}

class LLMChannel {
  final String name;
  final bool enabled;
  final int channelId;
  final String channelName;

  LLMChannel({
    required this.name,
    this.enabled = true,
    this.channelId = 0,
    this.channelName = '',
  });

  factory LLMChannel.fromJson(Map<String, dynamic> json) {
    return LLMChannel(
      name: parseString(json['name']),
      enabled: parseBool(json['enabled'], fallback: true),
      channelId: parseInt(json['channel_id']),
      channelName: parseString(json['channel_name']),
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'enabled': enabled,
    'channel_id': channelId,
    'channel_name': channelName,
  };
}
