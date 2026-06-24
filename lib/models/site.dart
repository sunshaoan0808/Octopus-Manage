import 'package:octopusmanage/utils/parse_utils.dart';

class Site {
  final int id;
  final String name;
  final String platform;
  final String baseUrl;
  final String apiKey;
  final bool enabled;
  final bool proxyEnabled;
  final String? proxyUrl;
  final String authType;
  final String? oauthClientId;
  final String? oauthClientSecret;
  final String? oauthTokenUrl;
  final String status;
  final int accountId;
  final String? accountName;
  final int channelCount;
  final int modelCount;
  final double totalCost;
  final int totalRequests;
  final double successRate;
  final int lastSyncAt;
  final String? errorMessage;
  final String createdAt;
  final String updatedAt;
  final Map<String, dynamic>? metadata;

  const Site({
    this.id = 0,
    this.name = '',
    this.platform = 'custom',
    this.baseUrl = '',
    this.apiKey = '',
    this.enabled = true,
    this.proxyEnabled = false,
    this.proxyUrl,
    this.authType = 'api_key',
    this.oauthClientId,
    this.oauthClientSecret,
    this.oauthTokenUrl,
    this.status = 'active',
    this.accountId = 0,
    this.accountName,
    this.channelCount = 0,
    this.modelCount = 0,
    this.totalCost = 0,
    this.totalRequests = 0,
    this.successRate = 0,
    this.lastSyncAt = 0,
    this.errorMessage,
    this.createdAt = '',
    this.updatedAt = '',
    this.metadata,
  });

  factory Site.fromJson(Map<String, dynamic> json) {
    return Site(
      id: parseInt(json['id']),
      name: parseString(json['name']),
      platform: parseString(json['platform'], fallback: 'custom'),
      baseUrl: parseString(json['base_url']),
      apiKey: parseString(json['api_key']),
      enabled: parseBool(json['enabled'], fallback: true),
      proxyEnabled: parseBool(json['proxy_enabled']),
      proxyUrl: json['proxy_url'] == null ? null : parseString(json['proxy_url']),
      authType: parseString(json['auth_type'], fallback: 'api_key'),
      oauthClientId: json['oauth_client_id'] == null
          ? null
          : parseString(json['oauth_client_id']),
      oauthClientSecret: json['oauth_client_secret'] == null
          ? null
          : parseString(json['oauth_client_secret']),
      oauthTokenUrl: json['oauth_token_url'] == null
          ? null
          : parseString(json['oauth_token_url']),
      status: parseString(json['status'], fallback: 'active'),
      accountId: parseInt(json['account_id']),
      accountName: json['account_name'] == null
          ? null
          : parseString(json['account_name']),
      channelCount: parseInt(json['channel_count']),
      modelCount: parseInt(json['model_count']),
      totalCost: parseDouble(json['total_cost']),
      totalRequests: parseInt(json['total_requests']),
      successRate: parseDouble(json['success_rate']),
      lastSyncAt: parseInt(json['last_sync_at']),
      errorMessage: json['error_message'] == null
          ? null
          : parseString(json['error_message']),
      createdAt: parseString(json['created_at']),
      updatedAt: parseString(json['updated_at']),
      metadata: parseJsonMap(json['metadata']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id > 0) 'id': id,
      'name': name,
      'platform': platform,
      'base_url': baseUrl,
      'api_key': apiKey,
      'enabled': enabled,
      'proxy_enabled': proxyEnabled,
      if (proxyUrl != null) 'proxy_url': proxyUrl,
      'auth_type': authType,
      if (oauthClientId != null) 'oauth_client_id': oauthClientId,
      if (oauthClientSecret != null) 'oauth_client_secret': oauthClientSecret,
      if (oauthTokenUrl != null) 'oauth_token_url': oauthTokenUrl,
      'status': status,
      'account_id': accountId,
      if (accountName != null) 'account_name': accountName,
      if (metadata != null) 'metadata': metadata,
    };
  }
}

class SiteAccount {
  final int id;
  final int siteId;
  final String name;
  final String email;
  final String status;
  final double balance;
  final double totalSpent;
  final String? plan;
  final int requestLimit;
  final int requestsUsed;
  final int expiresAt;
  final String lastLoginAt;
  final Map<String, dynamic>? metadata;

  const SiteAccount({
    this.id = 0,
    this.siteId = 0,
    this.name = '',
    this.email = '',
    this.status = 'active',
    this.balance = 0,
    this.totalSpent = 0,
    this.plan,
    this.requestLimit = 0,
    this.requestsUsed = 0,
    this.expiresAt = 0,
    this.lastLoginAt = '',
    this.metadata,
  });

  factory SiteAccount.fromJson(Map<String, dynamic> json) {
    return SiteAccount(
      id: parseInt(json['id']),
      siteId: parseInt(json['site_id']),
      name: parseString(json['name']),
      email: parseString(json['email']),
      status: parseString(json['status'], fallback: 'active'),
      balance: parseDouble(json['balance']),
      totalSpent: parseDouble(json['total_spent']),
      plan: json['plan'] == null ? null : parseString(json['plan']),
      requestLimit: parseInt(json['request_limit']),
      requestsUsed: parseInt(json['requests_used']),
      expiresAt: parseInt(json['expires_at']),
      lastLoginAt: parseString(json['last_login_at']),
      metadata: parseJsonMap(json['metadata']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id > 0) 'id': id,
      'site_id': siteId,
      'name': name,
      'email': email,
      'status': status,
      'balance': balance,
      'total_spent': totalSpent,
      if (plan != null) 'plan': plan,
      'request_limit': requestLimit,
      'requests_used': requestsUsed,
      'expires_at': expiresAt,
      'last_login_at': lastLoginAt,
      if (metadata != null) 'metadata': metadata,
    };
  }
}

class SiteToken {
  final int id;
  final int siteId;
  final String name;
  final String tokenMasked;
  final bool enabled;
  final int expiresAt;
  final String createdAt;

  const SiteToken({
    this.id = 0,
    this.siteId = 0,
    this.name = '',
    this.tokenMasked = '',
    this.enabled = true,
    this.expiresAt = 0,
    this.createdAt = '',
  });

  factory SiteToken.fromJson(Map<String, dynamic> json) {
    return SiteToken(
      id: parseInt(json['id']),
      siteId: parseInt(json['site_id']),
      name: parseString(json['name']),
      tokenMasked: parseString(json['token_masked']),
      enabled: parseBool(json['enabled'], fallback: true),
      expiresAt: parseInt(json['expires_at']),
      createdAt: parseString(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id > 0) 'id': id,
      'site_id': siteId,
      'name': name,
      'token_masked': tokenMasked,
      'enabled': enabled,
      'expires_at': expiresAt,
      'created_at': createdAt,
    };
  }
}

class SiteModel {
  final int id;
  final int siteId;
  final String modelName;
  final String provider;
  final bool enabled;
  final double inputPrice;
  final double outputPrice;
  final int contextWindow;

  const SiteModel({
    this.id = 0,
    this.siteId = 0,
    this.modelName = '',
    this.provider = '',
    this.enabled = true,
    this.inputPrice = 0,
    this.outputPrice = 0,
    this.contextWindow = 0,
  });

  factory SiteModel.fromJson(Map<String, dynamic> json) {
    return SiteModel(
      id: parseInt(json['id']),
      siteId: parseInt(json['site_id']),
      modelName: parseString(json['model_name']),
      provider: parseString(json['provider']),
      enabled: parseBool(json['enabled'], fallback: true),
      inputPrice: parseDouble(json['input_price']),
      outputPrice: parseDouble(json['output_price']),
      contextWindow: parseInt(json['context_window']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id > 0) 'id': id,
      'site_id': siteId,
      'model_name': modelName,
      'provider': provider,
      'enabled': enabled,
      'input_price': inputPrice,
      'output_price': outputPrice,
      'context_window': contextWindow,
    };
  }
}

class CheckInRecord {
  final int id;
  final int siteId;
  final int accountId;
  final String status;
  final double? reward;
  final String? rewardType;
  final String checkedAt;
  final String? message;

  const CheckInRecord({
    this.id = 0,
    this.siteId = 0,
    this.accountId = 0,
    this.status = 'success',
    this.reward,
    this.rewardType,
    this.checkedAt = '',
    this.message,
  });

  factory CheckInRecord.fromJson(Map<String, dynamic> json) {
    return CheckInRecord(
      id: parseInt(json['id']),
      siteId: parseInt(json['site_id']),
      accountId: parseInt(json['account_id']),
      status: parseString(json['status'], fallback: 'success'),
      reward: json['reward'] == null ? null : parseDouble(json['reward']),
      rewardType: json['reward_type'] == null
          ? null
          : parseString(json['reward_type']),
      checkedAt: parseString(json['checked_at']),
      message: json['message'] == null
          ? null
          : parseString(json['message']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id > 0) 'id': id,
      'site_id': siteId,
      'account_id': accountId,
      'status': status,
      if (reward != null) 'reward': reward,
      if (rewardType != null) 'reward_type': rewardType,
      'checked_at': checkedAt,
      if (message != null) 'message': message,
    };
  }
}

class RedemptionRecord {
  final int id;
  final int siteId;
  final int accountId;
  final String code;
  final String status;
  final double? value;
  final String? description;
  final String redeemedAt;

  const RedemptionRecord({
    this.id = 0,
    this.siteId = 0,
    this.accountId = 0,
    this.code = '',
    this.status = 'success',
    this.value,
    this.description,
    this.redeemedAt = '',
  });

  factory RedemptionRecord.fromJson(Map<String, dynamic> json) {
    return RedemptionRecord(
      id: parseInt(json['id']),
      siteId: parseInt(json['site_id']),
      accountId: parseInt(json['account_id']),
      code: parseString(json['code']),
      status: parseString(json['status'], fallback: 'success'),
      value: json['value'] == null ? null : parseDouble(json['value']),
      description: json['description'] == null
          ? null
          : parseString(json['description']),
      redeemedAt: parseString(json['redeemed_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id > 0) 'id': id,
      'site_id': siteId,
      'account_id': accountId,
      'code': code,
      'status': status,
      if (value != null) 'value': value,
      if (description != null) 'description': description,
      'redeemed_at': redeemedAt,
    };
  }
}

class BalanceSnapshot {
  final int id;
  final int siteId;
  final int accountId;
  final double balance;
  final double? dailyUsage;
  final double? weeklyUsage;
  final double? monthlyUsage;
  final int recordedAt;

  const BalanceSnapshot({
    this.id = 0,
    this.siteId = 0,
    this.accountId = 0,
    this.balance = 0,
    this.dailyUsage,
    this.weeklyUsage,
    this.monthlyUsage,
    this.recordedAt = 0,
  });

  factory BalanceSnapshot.fromJson(Map<String, dynamic> json) {
    return BalanceSnapshot(
      id: parseInt(json['id']),
      siteId: parseInt(json['site_id']),
      accountId: parseInt(json['account_id']),
      balance: parseDouble(json['balance']),
      dailyUsage: json['daily_usage'] == null
          ? null
          : parseDouble(json['daily_usage']),
      weeklyUsage: json['weekly_usage'] == null
          ? null
          : parseDouble(json['weekly_usage']),
      monthlyUsage: json['monthly_usage'] == null
          ? null
          : parseDouble(json['monthly_usage']),
      recordedAt: parseInt(json['recorded_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id > 0) 'id': id,
      'site_id': siteId,
      'account_id': accountId,
      'balance': balance,
      if (dailyUsage != null) 'daily_usage': dailyUsage,
      if (weeklyUsage != null) 'weekly_usage': weeklyUsage,
      if (monthlyUsage != null) 'monthly_usage': monthlyUsage,
      'recorded_at': recordedAt,
    };
  }
}

class BalancePrediction {
  final double currentBalance;
  final double dailyAverage;
  final double weeklyAverage;
  final int estimatedDaysRemaining;
  final String? recommendation;

  const BalancePrediction({
    this.currentBalance = 0,
    this.dailyAverage = 0,
    this.weeklyAverage = 0,
    this.estimatedDaysRemaining = 0,
    this.recommendation,
  });

  factory BalancePrediction.fromJson(Map<String, dynamic> json) {
    return BalancePrediction(
      currentBalance: parseDouble(json['current_balance']),
      dailyAverage: parseDouble(json['daily_average']),
      weeklyAverage: parseDouble(json['weekly_average']),
      estimatedDaysRemaining: parseInt(json['estimated_days_remaining']),
      recommendation: json['recommendation'] == null
          ? null
          : parseString(json['recommendation']),
    );
  }
}
