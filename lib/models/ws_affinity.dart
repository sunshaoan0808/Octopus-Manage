import 'package:octopusmanage/utils/parse_utils.dart';

class WSResponseAffinity {
  final uint id;
  final int apiKeyId;
  final int groupId;
  final String requestModel;
  final String responseIdHash;
  final int channelId;
  final int channelKeyId;
  final String upstreamModel;
  final String expiresAt;
  final String createdAt;
  final String updatedAt;

  WSResponseAffinity({
    this.id = null,
    this.apiKeyId = 0,
    this.groupId = 0,
    this.requestModel = '',
    this.responseIdHash = '',
    this.channelId = 0,
    this.channelKeyId = 0,
    this.upstreamModel = '',
    this.expiresAt = '',
    this.createdAt = '',
    this.updatedAt = '',
  });

  factory WSResponseAffinity.fromJson(Map<String, dynamic> json) {
    return WSResponseAffinity(
      id: uint.fromJson(parseJsonMap(json['id'])),
      apiKeyId: parseInt(json['api_key_id']),
      groupId: parseInt(json['group_id']),
      requestModel: parseString(json['request_model']),
      responseIdHash: parseString(json['response_id_hash']),
      channelId: parseInt(json['channel_id']),
      channelKeyId: parseInt(json['channel_key_id']),
      upstreamModel: parseString(json['upstream_model']),
      expiresAt: parseString(json['expires_at']),
      createdAt: parseString(json['created_at']),
      updatedAt: parseString(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id.toJson(),
      'api_key_id': apiKeyId,
      'group_id': groupId,
      if (requestModel.isNotEmpty) 'request_model': requestModel,
      if (responseIdHash.isNotEmpty) 'response_id_hash': responseIdHash,
      'channel_id': channelId,
      'channel_key_id': channelKeyId,
      if (upstreamModel.isNotEmpty) 'upstream_model': upstreamModel,
      if (expiresAt.isNotEmpty) 'expires_at': expiresAt,
      if (createdAt.isNotEmpty) 'created_at': createdAt,
      if (updatedAt.isNotEmpty) 'updated_at': updatedAt,
    };
  }
}

