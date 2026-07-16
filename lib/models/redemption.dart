import 'package:octopusmanage/utils/parse_utils.dart';

class RedemptionRecord {
  final int id;
  final int remoteSiteId;
  final String code;
  final String status;
  final QuotaAwarded float64 quotaAwarded;
  final String message;
  final String executedAt;

  RedemptionRecord({
    this.id = 0,
    this.remoteSiteId = 0,
    this.code = '',
    this.status = '',
    this.quotaAwarded = null,
    this.message = '',
    this.executedAt = '',
  });

  factory RedemptionRecord.fromJson(Map<String, dynamic> json) {
    return RedemptionRecord(
      id: parseInt(json['id']),
      remoteSiteId: parseInt(json['remote_site_id']),
      code: parseString(json['code']),
      status: parseString(json['status']),
      quotaAwarded: QuotaAwarded float64.fromJson(parseJsonMap(json['quota_awarded'])),
      message: parseString(json['message']),
      executedAt: parseString(json['executed_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'remote_site_id': remoteSiteId,
      if (code.isNotEmpty) 'code': code,
      if (status.isNotEmpty) 'status': status,
      'quota_awarded': quotaAwarded.toJson(),
      if (message.isNotEmpty) 'message': message,
      if (executedAt.isNotEmpty) 'executed_at': executedAt,
    };
  }
}

import 'package:octopusmanage/utils/parse_utils.dart';

class RedemptionRequest {
  final int siteId;
  final List<String> codes;

  RedemptionRequest({
    this.siteId = 0,
    this.codes = const [],
  });

  factory RedemptionRequest.fromJson(Map<String, dynamic> json) {
    return RedemptionRequest(
      siteId: parseInt(json['site_id']),
      codes: parseJsonMapList(json['codes']).map(String.fromJson).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'site_id': siteId,
      'codes': codes.map((e) => e.toJson()).toList(),
    };
  }
}

import 'package:octopusmanage/utils/parse_utils.dart';

class RedemptionBatchResult {
  final int totalCodes;
  final int successCount;
  final int failedCount;
  final List<RedemptionRecord> results;

  RedemptionBatchResult({
    this.totalCodes = 0,
    this.successCount = 0,
    this.failedCount = 0,
    this.results = const [],
  });

  factory RedemptionBatchResult.fromJson(Map<String, dynamic> json) {
    return RedemptionBatchResult(
      totalCodes: parseInt(json['total_codes']),
      successCount: parseInt(json['success_count']),
      failedCount: parseInt(json['failed_count']),
      results: parseJsonMapList(json['results']).map(RedemptionRecord.fromJson).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_codes': totalCodes,
      'success_count': successCount,
      'failed_count': failedCount,
      'results': results.map((e) => e.toJson()).toList(),
    };
  }
}

