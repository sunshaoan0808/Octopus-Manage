import 'package:octopusmanage/utils/parse_utils.dart';

class AlertRule {
  final int id;
  final String name;
  final bool enabled;
  final String conditionType;
  final double threshold;
  final String conditionJson;
  final int notifChannelId;
  final int cooldownSec;
  final int scopeChannelId;
  final int scopeApiKeyId;

  AlertRule({
    this.id = 0,
    this.name = '',
    this.enabled = true,
    this.conditionType = 'error_rate',
    this.threshold = 0,
    this.conditionJson = '',
    this.notifChannelId = 0,
    this.cooldownSec = 300,
    this.scopeChannelId = 0,
    this.scopeApiKeyId = 0,
  });

  factory AlertRule.fromJson(Map<String, dynamic> json) {
    return AlertRule(
      id: parseInt(json['id']),
      name: parseString(json['name']),
      enabled: parseBool(json['enabled'], fallback: true),
      conditionType: parseString(json['condition_type'], fallback: 'error_rate'),
      threshold: parseDouble(json['threshold']),
      conditionJson: parseString(json['condition_json']),
      notifChannelId: parseInt(json['notif_channel_id']),
      cooldownSec: parseInt(json['cooldown_sec'], fallback: 300),
      scopeChannelId: parseInt(json['scope_channel_id']),
      scopeApiKeyId: parseInt(json['scope_api_key_id']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id > 0) 'id': id,
      'name': name,
      'enabled': enabled,
      'condition_type': conditionType,
      'threshold': threshold,
      if (conditionJson.isNotEmpty) 'condition_json': conditionJson,
      'notif_channel_id': notifChannelId,
      if (cooldownSec != 300) 'cooldown_sec': cooldownSec,
      if (scopeChannelId > 0) 'scope_channel_id': scopeChannelId,
      if (scopeApiKeyId > 0) 'scope_api_key_id': scopeApiKeyId,
    };
  }
}

class AlertNotifChannel {
  final int id;
  final String name;
  final String type;
  final String url;
  final String secret;
  final String headers;
  final String config;

  AlertNotifChannel({
    this.id = 0,
    this.name = '',
    this.type = 'webhook',
    this.url = '',
    this.secret = '',
    this.headers = '',
    this.config = '',
  });

  factory AlertNotifChannel.fromJson(Map<String, dynamic> json) {
    return AlertNotifChannel(
      id: parseInt(json['id']),
      name: parseString(json['name']),
      type: parseString(json['type'], fallback: 'webhook'),
      url: parseString(json['url']),
      secret: parseString(json['secret']),
      headers: parseString(json['headers']),
      config: parseString(json['config']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id > 0) 'id': id,
      'name': name,
      'type': type,
      if (url.isNotEmpty) 'url': url,
      if (secret.isNotEmpty) 'secret': secret,
      if (headers.isNotEmpty) 'headers': headers,
      if (config.isNotEmpty) 'config': config,
    };
  }
}

class AlertHistory {
  final int id;
  final int ruleId;
  final String ruleName;
  final int state;
  final String message;
  final String detailJson;
  final int time;

  AlertHistory({
    this.id = 0,
    this.ruleId = 0,
    this.ruleName = '',
    this.state = 0,
    this.message = '',
    this.detailJson = '',
    this.time = 0,
  });

  factory AlertHistory.fromJson(Map<String, dynamic> json) {
    return AlertHistory(
      id: parseInt(json['id']),
      ruleId: parseInt(json['rule_id']),
      ruleName: parseString(json['rule_name']),
      state: parseInt(json['state']),
      message: parseString(json['message']),
      detailJson: parseString(json['detail_json']),
      time: parseInt(json['time']),
    );
  }
}
