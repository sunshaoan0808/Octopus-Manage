import 'package:octopusmanage/utils/parse_utils.dart';

class APICredentialProfile {
  final int id;
  final String name;
  final String apiType;
  final String baseUrl;
  final String apiKey;
  final String healthStatus;
  final bool enabled;
  final String? lastHealthCheck;
  final String? healthDetails;
  final Map<String, dynamic>? metadata;
  final String createdAt;
  final String updatedAt;

  const APICredentialProfile({
    this.id = 0,
    this.name = '',
    this.apiType = 'openai',
    this.baseUrl = '',
    this.apiKey = '',
    this.healthStatus = 'unknown',
    this.enabled = true,
    this.lastHealthCheck,
    this.healthDetails,
    this.metadata,
    this.createdAt = '',
    this.updatedAt = '',
  });

  factory APICredentialProfile.fromJson(Map<String, dynamic> json) {
    return APICredentialProfile(
      id: parseInt(json['id']),
      name: parseString(json['name']),
      apiType: parseString(json['api_type'], fallback: 'openai'),
      baseUrl: parseString(json['base_url']),
      apiKey: parseString(json['api_key']),
      healthStatus:
          parseString(json['health_status'], fallback: 'unknown'),
      enabled: parseBool(json['enabled'], fallback: true),
      lastHealthCheck: json['last_health_check'] == null
          ? null
          : parseString(json['last_health_check']),
      healthDetails: json['health_details'] == null
          ? null
          : parseString(json['health_details']),
      metadata: parseJsonMap(json['metadata']),
      createdAt: parseString(json['created_at']),
      updatedAt: parseString(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id > 0) 'id': id,
      'name': name,
      'api_type': apiType,
      'base_url': baseUrl,
      if (apiKey.isNotEmpty) 'api_key': apiKey,
      'health_status': healthStatus,
      'enabled': enabled,
      if (metadata != null) 'metadata': metadata,
    };
  }
}

class VerificationProbe {
  final String name;
  final String description;

  const VerificationProbe({
    this.name = '',
    this.description = '',
  });

  factory VerificationProbe.fromJson(Map<String, dynamic> json) {
    return VerificationProbe(
      name: parseString(json['name']),
      description: parseString(json['description']),
    );
  }
}

class VerificationResult {
  final String probe;
  final String status;
  final String? message;
  final int? latencyMs;

  const VerificationResult({
    this.probe = '',
    this.status = 'unknown',
    this.message,
    this.latencyMs,
  });

  factory VerificationResult.fromJson(Map<String, dynamic> json) {
    return VerificationResult(
      probe: parseString(json['probe']),
      status: parseString(json['status'], fallback: 'unknown'),
      message:
          json['message'] == null ? null : parseString(json['message']),
      latencyMs:
          json['latency_ms'] == null ? null : parseInt(json['latency_ms']),
    );
  }
}
