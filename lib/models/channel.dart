import 'package:octopusmanage/utils/parse_utils.dart';

class Channel {
  final int id;
  final String name;
  final int type;
  final bool enabled;
  final List<BaseUrl> baseUrls;
  final List<ChannelKey> keys;
  final String model;
  final String customModel;
  final bool proxy;
  final bool autoSync;
  final int autoGroup;
  final List<CustomHeader> customHeader;
  final String? paramOverride;
  final String? channelProxy;
  final StatsChannel? stats;
  final String? matchRegex;

  Channel({
    required this.id,
    required this.name,
    required this.type,
    required this.enabled,
    this.baseUrls = const [],
    this.keys = const [],
    this.model = '',
    this.customModel = '',
    this.proxy = false,
    this.autoSync = false,
    this.autoGroup = 0,
    this.customHeader = const [],
    this.paramOverride,
    this.channelProxy,
    this.stats,
    this.matchRegex,
  });

  factory Channel.fromJson(Map<String, dynamic> json) {
    return Channel(
      id: parseInt(json['id']),
      name: parseString(json['name']),
      type: parseInt(json['type']),
      enabled: parseBool(json['enabled'], fallback: true),
      baseUrls: parseJsonMapList(
        json['base_urls'],
      ).map(BaseUrl.fromJson).toList(),
      keys: parseJsonMapList(json['keys']).map(ChannelKey.fromJson).toList(),
      model: parseString(json['model']),
      customModel: parseString(json['custom_model']),
      proxy: parseBool(json['proxy']),
      autoSync: parseBool(json['auto_sync']),
      autoGroup: parseInt(json['auto_group']),
      customHeader: parseJsonMapList(
        json['custom_header'],
      ).map(CustomHeader.fromJson).toList(),
      paramOverride: json['param_override'] == null
          ? null
          : parseString(json['param_override']),
      channelProxy: json['channel_proxy'] == null
          ? null
          : parseString(json['channel_proxy']),
      stats: parseJsonMap(json['stats']) != null
          ? StatsChannel.fromJson(parseJsonMap(json['stats'])!)
          : null,
      matchRegex: json['match_regex'] == null
          ? null
          : parseString(json['match_regex']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id > 0) 'id': id,
      'name': name,
      'type': type,
      'enabled': enabled,
      'base_urls': baseUrls.map((e) => e.toJson()).toList(),
      'keys': keys.map((e) => e.toJson()).toList(),
      'model': model,
      'custom_model': customModel,
      'proxy': proxy,
      'auto_sync': autoSync,
      'auto_group': autoGroup,
      'custom_header': customHeader.map((e) => e.toJson()).toList(),
      if (paramOverride != null) 'param_override': paramOverride,
      if (channelProxy != null) 'channel_proxy': channelProxy,
      if (matchRegex != null) 'match_regex': matchRegex,
    };
  }
}

class BaseUrl {
  final String url;
  final int delay;

  BaseUrl({required this.url, this.delay = 0});

  factory BaseUrl.fromJson(Map<String, dynamic> json) {
    return BaseUrl(
      url: parseString(json['url']),
      delay: parseInt(json['delay']),
    );
  }

  Map<String, dynamic> toJson() => {'url': url, 'delay': delay};
}

class CustomHeader {
  final String headerKey;
  final String headerValue;

  CustomHeader({required this.headerKey, required this.headerValue});

  factory CustomHeader.fromJson(Map<String, dynamic> json) {
    return CustomHeader(
      headerKey: parseString(json['header_key']),
      headerValue: parseString(json['header_value']),
    );
  }

  Map<String, dynamic> toJson() => {
    'header_key': headerKey,
    'header_value': headerValue,
  };
}

class ChannelKey {
  final int id;
  final int channelId;
  final bool enabled;
  final String channelKey;
  final int statusCode;
  final int lastUseTimeStamp;
  final double totalCost;
  final String remark;

  ChannelKey({
    required this.id,
    this.channelId = 0,
    this.enabled = true,
    this.channelKey = '',
    this.statusCode = 0,
    this.lastUseTimeStamp = 0,
    this.totalCost = 0,
    this.remark = '',
  });

  factory ChannelKey.fromJson(Map<String, dynamic> json) {
    return ChannelKey(
      id: parseInt(json['id']),
      channelId: parseInt(json['channel_id']),
      enabled: parseBool(json['enabled'], fallback: true),
      channelKey: parseString(json['channel_key']),
      statusCode: parseInt(json['status_code']),
      lastUseTimeStamp: parseInt(json['last_use_time_stamp']),
      totalCost: parseDouble(json['total_cost']),
      remark: parseString(json['remark']),
    );
  }

  Map<String, dynamic> toJson() => {
    if (id > 0) 'id': id,
    'channel_id': channelId,
    'enabled': enabled,
    'channel_key': channelKey,
    'status_code': statusCode,
    'remark': remark,
  };
}

class StatsChannel {
  final int channelId;
  final int inputToken;
  final int outputToken;
  final double inputCost;
  final double outputCost;
  final int waitTime;
  final int requestSuccess;
  final int requestFailed;

  StatsChannel({
    this.channelId = 0,
    this.inputToken = 0,
    this.outputToken = 0,
    this.inputCost = 0,
    this.outputCost = 0,
    this.waitTime = 0,
    this.requestSuccess = 0,
    this.requestFailed = 0,
  });

  factory StatsChannel.fromJson(Map<String, dynamic> json) {
    return StatsChannel(
      channelId: parseInt(json['channel_id']),
      inputToken: parseInt(json['input_token']),
      outputToken: parseInt(json['output_token']),
      inputCost: parseDouble(json['input_cost']),
      outputCost: parseDouble(json['output_cost']),
      waitTime: parseInt(json['wait_time']),
      requestSuccess: parseInt(json['request_success']),
      requestFailed: parseInt(json['request_failed']),
    );
  }

  Map<String, dynamic> toJson() => {
    'channel_id': channelId,
    'input_token': inputToken,
    'output_token': outputToken,
    'input_cost': inputCost,
    'output_cost': outputCost,
    'wait_time': waitTime,
    'request_success': requestSuccess,
    'request_failed': requestFailed,
  };
}
