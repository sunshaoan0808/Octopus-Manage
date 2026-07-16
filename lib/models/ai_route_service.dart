import 'package:octopusmanage/utils/parse_utils.dart';

class AIRouteServiceConfig {
  final String name;
  final String baseUrl;
  final String apiKey;
  final String model;
  final bool? enabled;

  AIRouteServiceConfig({
    this.name = '',
    this.baseUrl = '',
    this.apiKey = '',
    this.model = '',
    this.enabled,
  });

  factory AIRouteServiceConfig.fromJson(Map<String, dynamic> json) {
    return AIRouteServiceConfig(
      name: parseString(json['name']),
      baseUrl: parseString(json['base_url']),
      apiKey: parseString(json['api_key']),
      model: parseString(json['model']),
      enabled: json['enabled'] == null ? null : parseBool(json['enabled']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (name.isNotEmpty) 'name': name,
      if (baseUrl.isNotEmpty) 'base_url': baseUrl,
      if (apiKey.isNotEmpty) 'api_key': apiKey,
      if (model.isNotEmpty) 'model': model,
      if (enabled != null) 'enabled': enabled,
    };
  }
}

