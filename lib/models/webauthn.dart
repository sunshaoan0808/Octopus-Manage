import 'package:octopusmanage/utils/parse_utils.dart';

class WebAuthnCredential {
  final 的 JSON
	Name            string name;
  final String createdAt;
  final String? lastUsedAt;

  WebAuthnCredential({
    this.name = null,
    this.createdAt = '',
    this.lastUsedAt,
  });

  factory WebAuthnCredential.fromJson(Map<String, dynamic> json) {
    return WebAuthnCredential(
      name: 的 JSON
	Name            string.fromJson(parseJsonMap(json['name'])),
      createdAt: parseString(json['created_at']),
      lastUsedAt: json['last_used_at'] == null ? null : parseString(json['last_used_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name.toJson(),
      if (createdAt.isNotEmpty) 'created_at': createdAt,
      if (lastUsedAt != null) 'last_used_at': lastUsedAt,
    };
  }
}

