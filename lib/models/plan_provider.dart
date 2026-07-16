import 'package:octopusmanage/utils/parse_utils.dart';

class PlanProviderCategoryInfo {
  final PlanProviderCategory category;
  final String name;
  final PlanProviderType type;
  final String baseUrl;
  final String models;
  final String description;
  final String helpUrl;

  PlanProviderCategoryInfo({
    this.category = null,
    this.name = '',
    this.type = null,
    this.baseUrl = '',
    this.models = '',
    this.description = '',
    this.helpUrl = '',
  });

  factory PlanProviderCategoryInfo.fromJson(Map<String, dynamic> json) {
    return PlanProviderCategoryInfo(
      category: PlanProviderCategory.fromJson(parseJsonMap(json['category'])),
      name: parseString(json['name']),
      type: PlanProviderType.fromJson(parseJsonMap(json['type'])),
      baseUrl: parseString(json['base_url']),
      models: parseString(json['models']),
      description: parseString(json['description']),
      helpUrl: parseString(json['help_url']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'category': category.toJson(),
      if (name.isNotEmpty) 'name': name,
      'type': type.toJson(),
      if (baseUrl.isNotEmpty) 'base_url': baseUrl,
      if (models.isNotEmpty) 'models': models,
      if (description.isNotEmpty) 'description': description,
      if (helpUrl.isNotEmpty) 'help_url': helpUrl,
    };
  }
}

import 'package:octopusmanage/utils/parse_utils.dart';

class PlanProvider {
  final int id;
  final String name;
  final PlanProviderCategory category;
  final PlanProviderType providerType;
  final String apiKey;
  final String forwardApiKey;
  final String baseUrl;
  final int channelId;
  final double balance;
  final double balanceUsed;
  final 专用
	QuotaTotal    float64 quotaTotal;
  final double quotaUsed;
  final String? quotaResetAt;
  final double weeklyTotal;
  final double weeklyUsed;
  final String? weeklyResetAt;
  final String status;
  final String? lastRefresh;
  final String createdAt;
  final String updatedAt;

  PlanProvider({
    this.id = 0,
    this.name = '',
    this.category = null,
    this.providerType = null,
    this.apiKey = '',
    this.forwardApiKey = '',
    this.baseUrl = '',
    this.channelId = 0,
    this.balance = 0,
    this.balanceUsed = 0,
    this.quotaTotal = null,
    this.quotaUsed = 0,
    this.quotaResetAt,
    this.weeklyTotal = 0,
    this.weeklyUsed = 0,
    this.weeklyResetAt,
    this.status = '',
    this.lastRefresh,
    this.createdAt = '',
    this.updatedAt = '',
  });

  factory PlanProvider.fromJson(Map<String, dynamic> json) {
    return PlanProvider(
      id: parseInt(json['id']),
      name: parseString(json['name']),
      category: PlanProviderCategory.fromJson(parseJsonMap(json['category'])),
      providerType: PlanProviderType.fromJson(parseJsonMap(json['provider_type'])),
      apiKey: parseString(json['api_key']),
      forwardApiKey: parseString(json['forward_api_key']),
      baseUrl: parseString(json['base_url']),
      channelId: parseInt(json['channel_id']),
      balance: parseDouble(json['balance']),
      balanceUsed: parseDouble(json['balance_used']),
      quotaTotal: 专用
	QuotaTotal    float64.fromJson(parseJsonMap(json['quota_total'])),
      quotaUsed: parseDouble(json['quota_used']),
      quotaResetAt: json['quota_reset_at'] == null ? null : parseString(json['quota_reset_at']),
      weeklyTotal: parseDouble(json['weekly_total']),
      weeklyUsed: parseDouble(json['weekly_used']),
      weeklyResetAt: json['weekly_reset_at'] == null ? null : parseString(json['weekly_reset_at']),
      status: parseString(json['status']),
      lastRefresh: json['last_refresh'] == null ? null : parseString(json['last_refresh']),
      createdAt: parseString(json['created_at']),
      updatedAt: parseString(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      if (name.isNotEmpty) 'name': name,
      'category': category.toJson(),
      'provider_type': providerType.toJson(),
      if (apiKey.isNotEmpty) 'api_key': apiKey,
      if (forwardApiKey.isNotEmpty) 'forward_api_key': forwardApiKey,
      if (baseUrl.isNotEmpty) 'base_url': baseUrl,
      'channel_id': channelId,
      'balance': balance,
      'balance_used': balanceUsed,
      'quota_total': quotaTotal.toJson(),
      'quota_used': quotaUsed,
      if (quotaResetAt != null) 'quota_reset_at': quotaResetAt,
      'weekly_total': weeklyTotal,
      'weekly_used': weeklyUsed,
      if (weeklyResetAt != null) 'weekly_reset_at': weeklyResetAt,
      if (status.isNotEmpty) 'status': status,
      if (lastRefresh != null) 'last_refresh': lastRefresh,
      if (createdAt.isNotEmpty) 'created_at': createdAt,
      if (updatedAt.isNotEmpty) 'updated_at': updatedAt,
    };
  }
}

import 'package:octopusmanage/utils/parse_utils.dart';

class PlanProviderListItem {
  final Models         string models;
  final Channel 继承的模型
	ChannelName    string channelName;
  final ChannelEnabled bool channelEnabled;

  PlanProviderListItem({
    this.models = null,
    this.channelName = null,
    this.channelEnabled = null,
  });

  factory PlanProviderListItem.fromJson(Map<String, dynamic> json) {
    return PlanProviderListItem(
      models: Models         string.fromJson(parseJsonMap(json['models'])),
      channelName: Channel 继承的模型
	ChannelName    string.fromJson(parseJsonMap(json['channel_name'])),
      channelEnabled: ChannelEnabled bool.fromJson(parseJsonMap(json['channel_enabled'])),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'models': models.toJson(),
      'channel_name': channelName.toJson(),
      'channel_enabled': channelEnabled.toJson(),
    };
  }
}

