import 'package:octopusmanage/utils/parse_utils.dart';

class RemoteUsageRecord {
  final int id;
  final int remoteSiteId;
  final String dayKey;
  final Hour             int hour;
  final ModelName        string modelName;
  final String tokenName;
  final int requestCount;
  final int promptTokens;
  final int completionTokens;
  final int totalTokens;
  final double quotaConsumed;
  final int remoteLogId;
  final log ID from remote site
	Fingerprint      string fingerprint;
  final key
	SyncedAt         time.Time syncedAt;

  RemoteUsageRecord({
    this.id = 0,
    this.remoteSiteId = 0,
    this.dayKey = '',
    this.hour = null,
    this.modelName = null,
    this.tokenName = '',
    this.requestCount = 0,
    this.promptTokens = 0,
    this.completionTokens = 0,
    this.totalTokens = 0,
    this.quotaConsumed = 0,
    this.remoteLogId = 0,
    this.fingerprint = null,
    this.syncedAt = null,
  });

  factory RemoteUsageRecord.fromJson(Map<String, dynamic> json) {
    return RemoteUsageRecord(
      id: parseInt(json['id']),
      remoteSiteId: parseInt(json['remote_site_id']),
      dayKey: parseString(json['day_key']),
      hour: Hour             int.fromJson(parseJsonMap(json['hour'])),
      modelName: ModelName        string.fromJson(parseJsonMap(json['model_name'])),
      tokenName: parseString(json['token_name']),
      requestCount: parseInt(json['request_count']),
      promptTokens: parseInt(json['prompt_tokens']),
      completionTokens: parseInt(json['completion_tokens']),
      totalTokens: parseInt(json['total_tokens']),
      quotaConsumed: parseDouble(json['quota_consumed']),
      remoteLogId: parseInt(json['remote_log_id']),
      fingerprint: log ID from remote site
	Fingerprint      string.fromJson(parseJsonMap(json['fingerprint'])),
      syncedAt: key
	SyncedAt         time.Time.fromJson(parseJsonMap(json['synced_at'])),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'remote_site_id': remoteSiteId,
      if (dayKey.isNotEmpty) 'day_key': dayKey,
      'hour': hour.toJson(),
      'model_name': modelName.toJson(),
      if (tokenName.isNotEmpty) 'token_name': tokenName,
      'request_count': requestCount,
      'prompt_tokens': promptTokens,
      'completion_tokens': completionTokens,
      'total_tokens': totalTokens,
      'quota_consumed': quotaConsumed,
      'remote_log_id': remoteLogId,
      'fingerprint': fingerprint.toJson(),
      'synced_at': syncedAt.toJson(),
    };
  }
}

import 'package:octopusmanage/utils/parse_utils.dart';

class RemoteUsageSummary {
  final String dayKey;
  final String modelName;
  final String tokenName;
  final int requestCount;
  final int promptTokens;
  final int completionTokens;
  final int totalTokens;
  final double quotaConsumed;

  RemoteUsageSummary({
    this.dayKey = '',
    this.modelName = '',
    this.tokenName = '',
    this.requestCount = 0,
    this.promptTokens = 0,
    this.completionTokens = 0,
    this.totalTokens = 0,
    this.quotaConsumed = 0,
  });

  factory RemoteUsageSummary.fromJson(Map<String, dynamic> json) {
    return RemoteUsageSummary(
      dayKey: parseString(json['day_key']),
      modelName: parseString(json['model_name']),
      tokenName: parseString(json['token_name']),
      requestCount: parseInt(json['request_count']),
      promptTokens: parseInt(json['prompt_tokens']),
      completionTokens: parseInt(json['completion_tokens']),
      totalTokens: parseInt(json['total_tokens']),
      quotaConsumed: parseDouble(json['quota_consumed']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (dayKey.isNotEmpty) 'day_key': dayKey,
      if (modelName.isNotEmpty) 'model_name': modelName,
      if (tokenName.isNotEmpty) 'token_name': tokenName,
      'request_count': requestCount,
      'prompt_tokens': promptTokens,
      'completion_tokens': completionTokens,
      'total_tokens': totalTokens,
      'quota_consumed': quotaConsumed,
    };
  }
}

import 'package:octopusmanage/utils/parse_utils.dart';

class RemoteUsageHourly {
  final int hour;
  final int requestCount;
  final int promptTokens;
  final int completionTokens;
  final int totalTokens;

  RemoteUsageHourly({
    this.hour = 0,
    this.requestCount = 0,
    this.promptTokens = 0,
    this.completionTokens = 0,
    this.totalTokens = 0,
  });

  factory RemoteUsageHourly.fromJson(Map<String, dynamic> json) {
    return RemoteUsageHourly(
      hour: parseInt(json['hour']),
      requestCount: parseInt(json['request_count']),
      promptTokens: parseInt(json['prompt_tokens']),
      completionTokens: parseInt(json['completion_tokens']),
      totalTokens: parseInt(json['total_tokens']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'hour': hour,
      'request_count': requestCount,
      'prompt_tokens': promptTokens,
      'completion_tokens': completionTokens,
      'total_tokens': totalTokens,
    };
  }
}

import 'package:octopusmanage/utils/parse_utils.dart';

class RemoteUsageQuery {
  final int siteId;
  final String dayFrom;
  final DayTo     string dayTo;
  final ModelName string modelName;
  final String tokenName;
  final int limit;
  final int offset;

  RemoteUsageQuery({
    this.siteId = 0,
    this.dayFrom = '',
    this.dayTo = null,
    this.modelName = null,
    this.tokenName = '',
    this.limit = 0,
    this.offset = 0,
  });

  factory RemoteUsageQuery.fromJson(Map<String, dynamic> json) {
    return RemoteUsageQuery(
      siteId: parseInt(json['site_id']),
      dayFrom: parseString(json['day_from']),
      dayTo: DayTo     string.fromJson(parseJsonMap(json['day_to'])),
      modelName: ModelName string.fromJson(parseJsonMap(json['model_name'])),
      tokenName: parseString(json['token_name']),
      limit: parseInt(json['limit']),
      offset: parseInt(json['offset']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'site_id': siteId,
      if (dayFrom.isNotEmpty) 'day_from': dayFrom,
      'day_to': dayTo.toJson(),
      'model_name': modelName.toJson(),
      if (tokenName.isNotEmpty) 'token_name': tokenName,
      'limit': limit,
      'offset': offset,
    };
  }
}

