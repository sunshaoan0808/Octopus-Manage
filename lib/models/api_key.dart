import 'package:octopusmanage/utils/parse_utils.dart';

class APIKey {
  final int id;
  final String name;
  final String apiKey;
  final bool enabled;
  final int expireAt;
  final double maxCost;
  final String supportedModels;
  final int rateLimitRPM;
  final int rateLimitTPM;
  final String perModelQuotaJson;

  // Phase 1.2: Security fields
  final List<String> allowedIps;
  final List<String> tags;
  final List<int> excludedChannels;

  APIKey({
    this.id = 0,
    required this.name,
    this.apiKey = '',
    this.enabled = true,
    this.expireAt = 0,
    this.maxCost = 0,
    this.supportedModels = '',
    this.rateLimitRPM = 0,
    this.rateLimitTPM = 0,
    this.perModelQuotaJson = '',
    this.allowedIps = const [],
    this.tags = const [],
    this.excludedChannels = const [],
  });

  factory APIKey.fromJson(Map<String, dynamic> json) {
    return APIKey(
      id: parseInt(json['id']),
      name: parseString(json['name']),
      apiKey: parseString(json['api_key']),
      enabled: parseBool(json['enabled'], fallback: true),
      expireAt: parseInt(json['expire_at']),
      maxCost: parseDouble(json['max_cost']),
      supportedModels: parseString(json['supported_models']),
      rateLimitRPM: parseInt(json['rate_limit_rpm']),
      rateLimitTPM: parseInt(json['rate_limit_tpm']),
      perModelQuotaJson: parseString(json['per_model_quota_json']),
      // Phase 1.2: Security fields
      allowedIps: _parseStringList(json['allowed_ips']),
      tags: _parseStringList(json['tags']),
      excludedChannels: _parseIntList(json['excluded_channels']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id > 0) 'id': id,
      'name': name,
      if (apiKey.isNotEmpty) 'api_key': apiKey,
      'enabled': enabled,
      'expire_at': expireAt,
      'max_cost': maxCost,
      if (supportedModels.isNotEmpty) 'supported_models': supportedModels,
      'rate_limit_rpm': rateLimitRPM,
      'rate_limit_tpm': rateLimitTPM,
      if (perModelQuotaJson.isNotEmpty) 'per_model_quota_json': perModelQuotaJson,
      // Phase 1.2: Security fields
      if (allowedIps.isNotEmpty) 'allowed_ips': allowedIps,
      if (tags.isNotEmpty) 'tags': tags,
      if (excludedChannels.isNotEmpty) 'excluded_channels': excludedChannels,
    };
  }

  static List<String> _parseStringList(dynamic value) {
    if (value is List) {
      return value.map((e) => e.toString()).toList();
    }
    if (value is String && value.isNotEmpty) {
      return value.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
    }
    return [];
  }

  static List<int> _parseIntList(dynamic value) {
    if (value is List) {
      return value.map((e) => parseInt(e)).toList();
    }
    return [];
  }
}
