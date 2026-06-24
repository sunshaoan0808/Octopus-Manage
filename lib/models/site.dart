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
