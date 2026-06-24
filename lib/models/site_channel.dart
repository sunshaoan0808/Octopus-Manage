import 'package:octopusmanage/utils/parse_utils.dart';

class SiteChannelCard {
  final int id;
  final int siteId;
  final int accountId;
  final int channelId;
  final String channelName;
  final String groupName;
  final String modelName;
  final String routeType;
  final bool enabled;

  const SiteChannelCard({
    this.id = 0,
    this.siteId = 0,
    this.accountId = 0,
    this.channelId = 0,
    this.channelName = '',
    this.groupName = '',
    this.modelName = '',
    this.routeType = '',
    this.enabled = true,
  });

  factory SiteChannelCard.fromJson(Map<String, dynamic> json) {
    return SiteChannelCard(
      id: parseInt(json['id']),
      siteId: parseInt(json['site_id']),
      accountId: parseInt(json['account_id']),
      channelId: parseInt(json['channel_id']),
      channelName: parseString(json['channel_name']),
      groupName: parseString(json['group_name']),
      modelName: parseString(json['model_name']),
      routeType: parseString(json['route_type']),
      enabled: parseBool(json['enabled'], fallback: true),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id > 0) 'id': id,
      'site_id': siteId,
      'account_id': accountId,
      'channel_id': channelId,
      'channel_name': channelName,
      'group_name': groupName,
      'model_name': modelName,
      'route_type': routeType,
      'enabled': enabled,
    };
  }
}

class SiteChannelAccount {
  final int id;
  final int siteId;
  final String name;
  final String email;
  final String status;
  final int channelCount;

  const SiteChannelAccount({
    this.id = 0,
    this.siteId = 0,
    this.name = '',
    this.email = '',
    this.status = 'active',
    this.channelCount = 0,
  });

  factory SiteChannelAccount.fromJson(Map<String, dynamic> json) {
    return SiteChannelAccount(
      id: parseInt(json['id']),
      siteId: parseInt(json['site_id']),
      name: parseString(json['name']),
      email: parseString(json['email']),
      status: parseString(json['status'], fallback: 'active'),
      channelCount: parseInt(json['channel_count']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id > 0) 'id': id,
      'site_id': siteId,
      'name': name,
      'email': email,
      'status': status,
    };
  }
}

class SiteChannelGroup {
  final int id;
  final String name;
  final int channelId;
  final String modelName;
  final String routeType;

  const SiteChannelGroup({
    this.id = 0,
    this.name = '',
    this.channelId = 0,
    this.modelName = '',
    this.routeType = '',
  });

  factory SiteChannelGroup.fromJson(Map<String, dynamic> json) {
    return SiteChannelGroup(
      id: parseInt(json['id']),
      name: parseString(json['name']),
      channelId: parseInt(json['channel_id']),
      modelName: parseString(json['model_name']),
      routeType: parseString(json['route_type']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id > 0) 'id': id,
      'name': name,
      'channel_id': channelId,
      'model_name': modelName,
      'route_type': routeType,
    };
  }
}

class SiteChannelModel {
  final String modelName;
  final int channelId;
  final String routeType;
  final bool enabled;

  const SiteChannelModel({
    this.modelName = '',
    this.channelId = 0,
    this.routeType = '',
    this.enabled = true,
  });

  factory SiteChannelModel.fromJson(Map<String, dynamic> json) {
    return SiteChannelModel(
      modelName: parseString(json['model_name']),
      channelId: parseInt(json['channel_id']),
      routeType: parseString(json['route_type']),
      enabled: parseBool(json['enabled'], fallback: true),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'model_name': modelName,
      'channel_id': channelId,
      'route_type': routeType,
      'enabled': enabled,
    };
  }
}
