import 'package:octopusmanage/utils/parse_utils.dart';

class SiteAnnouncement {
  final int id;
  final int remoteSiteId;
  final String content;
  final String fetchedAt;

  SiteAnnouncement({
    this.id = 0,
    this.remoteSiteId = 0,
    this.content = '',
    this.fetchedAt = '',
  });

  factory SiteAnnouncement.fromJson(Map<String, dynamic> json) {
    return SiteAnnouncement(
      id: parseInt(json['id']),
      remoteSiteId: parseInt(json['remote_site_id']),
      content: parseString(json['content']),
      fetchedAt: parseString(json['fetched_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'remote_site_id': remoteSiteId,
      if (content.isNotEmpty) 'content': content,
      if (fetchedAt.isNotEmpty) 'fetched_at': fetchedAt,
    };
  }
}

import 'package:octopusmanage/utils/parse_utils.dart';

class RemoteSiteToken {
  final int id;
  final int remoteSiteId;
  final int remoteTokenId;
  final String name;
  final String key;
  final int status;
  final double remainQuota;
  final double usedQuota;
  final bool unlimitedQuota;
  final String modelLimits;
  final int expiredTime;
  final int createdTime;
  final String? lastSyncAt;

  RemoteSiteToken({
    this.id = 0,
    this.remoteSiteId = 0,
    this.remoteTokenId = 0,
    this.name = '',
    this.key = '',
    this.status = 0,
    this.remainQuota = 0,
    this.usedQuota = 0,
    this.unlimitedQuota = false,
    this.modelLimits = '',
    this.expiredTime = 0,
    this.createdTime = 0,
    this.lastSyncAt,
  });

  factory RemoteSiteToken.fromJson(Map<String, dynamic> json) {
    return RemoteSiteToken(
      id: parseInt(json['id']),
      remoteSiteId: parseInt(json['remote_site_id']),
      remoteTokenId: parseInt(json['remote_token_id']),
      name: parseString(json['name']),
      key: parseString(json['key']),
      status: parseInt(json['status']),
      remainQuota: parseDouble(json['remain_quota']),
      usedQuota: parseDouble(json['used_quota']),
      unlimitedQuota: parseBool(json['unlimited_quota']),
      modelLimits: parseString(json['model_limits']),
      expiredTime: parseInt(json['expired_time']),
      createdTime: parseInt(json['created_time']),
      lastSyncAt: json['last_sync_at'] == null ? null : parseString(json['last_sync_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'remote_site_id': remoteSiteId,
      'remote_token_id': remoteTokenId,
      if (name.isNotEmpty) 'name': name,
      if (key.isNotEmpty) 'key': key,
      'status': status,
      'remain_quota': remainQuota,
      'used_quota': usedQuota,
      'unlimited_quota': unlimitedQuota,
      if (modelLimits.isNotEmpty) 'model_limits': modelLimits,
      'expired_time': expiredTime,
      'created_time': createdTime,
      if (lastSyncAt != null) 'last_sync_at': lastSyncAt,
    };
  }
}

import 'package:octopusmanage/utils/parse_utils.dart';

class SyncToChannelRequest {
  final int remoteSiteId;
  final int tokenId;
  final String channelName;
  final String models;

  SyncToChannelRequest({
    this.remoteSiteId = 0,
    this.tokenId = 0,
    this.channelName = '',
    this.models = '',
  });

  factory SyncToChannelRequest.fromJson(Map<String, dynamic> json) {
    return SyncToChannelRequest(
      remoteSiteId: parseInt(json['remote_site_id']),
      tokenId: parseInt(json['token_id']),
      channelName: parseString(json['channel_name']),
      models: parseString(json['models']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'remote_site_id': remoteSiteId,
      'token_id': tokenId,
      if (channelName.isNotEmpty) 'channel_name': channelName,
      if (models.isNotEmpty) 'models': models,
    };
  }
}

