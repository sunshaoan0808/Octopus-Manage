import 'package:octopusmanage/utils/parse_utils.dart';

class RemoteSite {
  final int id;
  final String name;
  final String baseUrl;
  final String siteType;
  final String authType;
  final String accessToken;
  final String username;
  final String password;
  final double exchangeRate;
  final bool enabled;
  final String tags;
  final String notes;
  final bool pinned;
  final int sortOrder;
  final int remoteUserId;
  final String remoteUsername;
  final double quota;
  final String healthStatus;
  final String healthMessage;
  final String? lastSyncAt;
  final String createdAt;
  final String updatedAt;

  RemoteSite({
    this.id = 0,
    this.name = '',
    this.baseUrl = '',
    this.siteType = '',
    this.authType = '',
    this.accessToken = '',
    this.username = '',
    this.password = '',
    this.exchangeRate = 0,
    this.enabled = false,
    this.tags = '',
    this.notes = '',
    this.pinned = false,
    this.sortOrder = 0,
    this.remoteUserId = 0,
    this.remoteUsername = '',
    this.quota = 0,
    this.healthStatus = '',
    this.healthMessage = '',
    this.lastSyncAt,
    this.createdAt = '',
    this.updatedAt = '',
  });

  factory RemoteSite.fromJson(Map<String, dynamic> json) {
    return RemoteSite(
      id: parseInt(json['id']),
      name: parseString(json['name']),
      baseUrl: parseString(json['base_url']),
      siteType: parseString(json['site_type']),
      authType: parseString(json['auth_type']),
      accessToken: parseString(json['access_token']),
      username: parseString(json['username']),
      password: parseString(json['password']),
      exchangeRate: parseDouble(json['exchange_rate']),
      enabled: parseBool(json['enabled']),
      tags: parseString(json['tags']),
      notes: parseString(json['notes']),
      pinned: parseBool(json['pinned']),
      sortOrder: parseInt(json['sort_order']),
      remoteUserId: parseInt(json['remote_user_id']),
      remoteUsername: parseString(json['remote_username']),
      quota: parseDouble(json['quota']),
      healthStatus: parseString(json['health_status']),
      healthMessage: parseString(json['health_message']),
      lastSyncAt: json['last_sync_at'] == null ? null : parseString(json['last_sync_at']),
      createdAt: parseString(json['created_at']),
      updatedAt: parseString(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      if (name.isNotEmpty) 'name': name,
      if (baseUrl.isNotEmpty) 'base_url': baseUrl,
      if (siteType.isNotEmpty) 'site_type': siteType,
      if (authType.isNotEmpty) 'auth_type': authType,
      if (accessToken.isNotEmpty) 'access_token': accessToken,
      if (username.isNotEmpty) 'username': username,
      if (password.isNotEmpty) 'password': password,
      'exchange_rate': exchangeRate,
      'enabled': enabled,
      if (tags.isNotEmpty) 'tags': tags,
      if (notes.isNotEmpty) 'notes': notes,
      'pinned': pinned,
      'sort_order': sortOrder,
      'remote_user_id': remoteUserId,
      if (remoteUsername.isNotEmpty) 'remote_username': remoteUsername,
      'quota': quota,
      if (healthStatus.isNotEmpty) 'health_status': healthStatus,
      if (healthMessage.isNotEmpty) 'health_message': healthMessage,
      if (lastSyncAt != null) 'last_sync_at': lastSyncAt,
      if (createdAt.isNotEmpty) 'created_at': createdAt,
      if (updatedAt.isNotEmpty) 'updated_at': updatedAt,
    };
  }
}

import 'package:octopusmanage/utils/parse_utils.dart';

class RemoteSiteCreateRequest {
  final String name;
  final String baseUrl;
  final String siteType;
  final String authType;
  final String accessToken;
  final String username;
  final String password;
  final double exchangeRate;
  final bool? enabled;
  final String tags;
  final String notes;

  RemoteSiteCreateRequest({
    this.name = '',
    this.baseUrl = '',
    this.siteType = '',
    this.authType = '',
    this.accessToken = '',
    this.username = '',
    this.password = '',
    this.exchangeRate = 0,
    this.enabled,
    this.tags = '',
    this.notes = '',
  });

  factory RemoteSiteCreateRequest.fromJson(Map<String, dynamic> json) {
    return RemoteSiteCreateRequest(
      name: parseString(json['name']),
      baseUrl: parseString(json['base_url']),
      siteType: parseString(json['site_type']),
      authType: parseString(json['auth_type']),
      accessToken: parseString(json['access_token']),
      username: parseString(json['username']),
      password: parseString(json['password']),
      exchangeRate: parseDouble(json['exchange_rate']),
      enabled: json['enabled'] == null ? null : parseBool(json['enabled']),
      tags: parseString(json['tags']),
      notes: parseString(json['notes']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (name.isNotEmpty) 'name': name,
      if (baseUrl.isNotEmpty) 'base_url': baseUrl,
      if (siteType.isNotEmpty) 'site_type': siteType,
      if (authType.isNotEmpty) 'auth_type': authType,
      if (accessToken.isNotEmpty) 'access_token': accessToken,
      if (username.isNotEmpty) 'username': username,
      if (password.isNotEmpty) 'password': password,
      'exchange_rate': exchangeRate,
      if (enabled != null) 'enabled': enabled,
      if (tags.isNotEmpty) 'tags': tags,
      if (notes.isNotEmpty) 'notes': notes,
    };
  }
}

import 'package:octopusmanage/utils/parse_utils.dart';

class RemoteSiteDetectRequest {
  final String baseUrl;
  final String accessToken;

  RemoteSiteDetectRequest({
    this.baseUrl = '',
    this.accessToken = '',
  });

  factory RemoteSiteDetectRequest.fromJson(Map<String, dynamic> json) {
    return RemoteSiteDetectRequest(
      baseUrl: parseString(json['base_url']),
      accessToken: parseString(json['access_token']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (baseUrl.isNotEmpty) 'base_url': baseUrl,
      if (accessToken.isNotEmpty) 'access_token': accessToken,
    };
  }
}

import 'package:octopusmanage/utils/parse_utils.dart';

class BalanceSnapshot {
  final int id;
  final int remoteSiteId;
  final String dayKey;
  final Quota        float64 quota;
  final String capturedAt;
  final String source;

  BalanceSnapshot({
    this.id = 0,
    this.remoteSiteId = 0,
    this.dayKey = '',
    this.quota = null,
    this.capturedAt = '',
    this.source = '',
  });

  factory BalanceSnapshot.fromJson(Map<String, dynamic> json) {
    return BalanceSnapshot(
      id: parseInt(json['id']),
      remoteSiteId: parseInt(json['remote_site_id']),
      dayKey: parseString(json['day_key']),
      quota: Quota        float64.fromJson(parseJsonMap(json['quota'])),
      capturedAt: parseString(json['captured_at']),
      source: parseString(json['source']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'remote_site_id': remoteSiteId,
      if (dayKey.isNotEmpty) 'day_key': dayKey,
      'quota': quota.toJson(),
      if (capturedAt.isNotEmpty) 'captured_at': capturedAt,
      if (source.isNotEmpty) 'source': source,
    };
  }
}

import 'package:octopusmanage/utils/parse_utils.dart';

class BalanceChartPoint {
  final String dayKey;
  final double quota;

  BalanceChartPoint({
    this.dayKey = '',
    this.quota = 0,
  });

  factory BalanceChartPoint.fromJson(Map<String, dynamic> json) {
    return BalanceChartPoint(
      dayKey: parseString(json['day_key']),
      quota: parseDouble(json['quota']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (dayKey.isNotEmpty) 'day_key': dayKey,
      'quota': quota,
    };
  }
}

import 'package:octopusmanage/utils/parse_utils.dart';

class BalancePrediction {
  final double dailyBurnRate;
  final daily consumption (7-day weighted)
	DaysRemaining    int daysRemaining;
  final days until quota reaches 0
	EstimatedZeroAt  string estimatedZeroAt;
  final when quota hits 0
	SevenDayAvgBurn  float64 sevenDayAvgBurn;
  final average daily burn
	ThirtyDayAvgBurn float64 thirtyDayAvgBurn;
  final average daily burn
	CurrentQuota     float64 currentQuota;
  final quota
	TrendPoints      []BalanceChartPoint trendPoints;

  BalancePrediction({
    this.dailyBurnRate = 0,
    this.daysRemaining = null,
    this.estimatedZeroAt = null,
    this.sevenDayAvgBurn = null,
    this.thirtyDayAvgBurn = null,
    this.currentQuota = null,
    this.trendPoints = null,
  });

  factory BalancePrediction.fromJson(Map<String, dynamic> json) {
    return BalancePrediction(
      dailyBurnRate: parseDouble(json['daily_burn_rate']),
      daysRemaining: daily consumption (7-day weighted)
	DaysRemaining    int.fromJson(parseJsonMap(json['days_remaining'])),
      estimatedZeroAt: days until quota reaches 0
	EstimatedZeroAt  string.fromJson(parseJsonMap(json['estimated_zero_at'])),
      sevenDayAvgBurn: when quota hits 0
	SevenDayAvgBurn  float64.fromJson(parseJsonMap(json['seven_day_avg_burn'])),
      thirtyDayAvgBurn: average daily burn
	ThirtyDayAvgBurn float64.fromJson(parseJsonMap(json['thirty_day_avg_burn'])),
      currentQuota: average daily burn
	CurrentQuota     float64.fromJson(parseJsonMap(json['current_quota'])),
      trendPoints: quota
	TrendPoints      []BalanceChartPoint.fromJson(parseJsonMap(json['trend_points'])),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'daily_burn_rate': dailyBurnRate,
      'days_remaining': daysRemaining.toJson(),
      'estimated_zero_at': estimatedZeroAt.toJson(),
      'seven_day_avg_burn': sevenDayAvgBurn.toJson(),
      'thirty_day_avg_burn': thirtyDayAvgBurn.toJson(),
      'current_quota': currentQuota.toJson(),
      'trend_points': trendPoints.toJson(),
    };
  }
}

import 'package:octopusmanage/utils/parse_utils.dart';

class CheckInRecord {
  final int id;
  final int remoteSiteId;
  final String checkInDate;
  final Status       string status;
  final Message      string message;
  final double quotaAwarded;
  final String executedAt;

  CheckInRecord({
    this.id = 0,
    this.remoteSiteId = 0,
    this.checkInDate = '',
    this.status = null,
    this.message = null,
    this.quotaAwarded = 0,
    this.executedAt = '',
  });

  factory CheckInRecord.fromJson(Map<String, dynamic> json) {
    return CheckInRecord(
      id: parseInt(json['id']),
      remoteSiteId: parseInt(json['remote_site_id']),
      checkInDate: parseString(json['check_in_date']),
      status: Status       string.fromJson(parseJsonMap(json['status'])),
      message: Message      string.fromJson(parseJsonMap(json['message'])),
      quotaAwarded: parseDouble(json['quota_awarded']),
      executedAt: parseString(json['executed_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'remote_site_id': remoteSiteId,
      if (checkInDate.isNotEmpty) 'check_in_date': checkInDate,
      'status': status.toJson(),
      'message': message.toJson(),
      'quota_awarded': quotaAwarded,
      if (executedAt.isNotEmpty) 'executed_at': executedAt,
    };
  }
}

