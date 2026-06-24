import 'package:octopusmanage/utils/parse_utils.dart';

class ProxyConfiguration {
  final int id;
  final String name;
  final String url;
  final String type;
  final bool enabled;
  final String authType;
  final String? username;
  final String? password;
  final int referenceCount;
  final String createdAt;
  final String updatedAt;

  const ProxyConfiguration({
    this.id = 0,
    this.name = '',
    this.url = '',
    this.type = 'http',
    this.enabled = true,
    this.authType = 'none',
    this.username,
    this.password,
    this.referenceCount = 0,
    this.createdAt = '',
    this.updatedAt = '',
  });

  factory ProxyConfiguration.fromJson(Map<String, dynamic> json) {
    return ProxyConfiguration(
      id: parseInt(json['id']),
      name: parseString(json['name']),
      url: parseString(json['url']),
      type: parseString(json['type'], fallback: 'http'),
      enabled: parseBool(json['enabled'], fallback: true),
      authType: parseString(json['auth_type'], fallback: 'none'),
      username:
          json['username'] == null ? null : parseString(json['username']),
      password:
          json['password'] == null ? null : parseString(json['password']),
      referenceCount: parseInt(json['reference_count']),
      createdAt: parseString(json['created_at']),
      updatedAt: parseString(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id > 0) 'id': id,
      'name': name,
      'url': url,
      'type': type,
      'enabled': enabled,
      'auth_type': authType,
      if (username != null) 'username': username,
      if (password != null) 'password': password,
    };
  }
}
