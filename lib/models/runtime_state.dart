import 'package:octopusmanage/utils/parse_utils.dart';

class AutoStrategyRecord {
  final int timestamp;
  final bool success;

  AutoStrategyRecord({
    this.timestamp = 0,
    this.success = false,
  });

  factory AutoStrategyRecord.fromJson(Map<String, dynamic> json) {
    return AutoStrategyRecord(
      timestamp: parseInt(json['timestamp']),
      success: parseBool(json['success']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'timestamp': timestamp,
      'success': success,
    };
  }
}

import 'package:octopusmanage/utils/parse_utils.dart';

class AutoStrategyState {
  final String key;
  final int channelId;
  final String modelName;
  final List<AutoStrategyRecord> records;
  final int updatedAt;

  AutoStrategyState({
    this.key = '',
    this.channelId = 0,
    this.modelName = '',
    this.records = const [],
    this.updatedAt = 0,
  });

  factory AutoStrategyState.fromJson(Map<String, dynamic> json) {
    return AutoStrategyState(
      key: parseString(json['key']),
      channelId: parseInt(json['channel_id']),
      modelName: parseString(json['model_name']),
      records: parseJsonMapList(json['records']).map(AutoStrategyRecord.fromJson).toList(),
      updatedAt: parseInt(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (key.isNotEmpty) 'key': key,
      'channel_id': channelId,
      if (modelName.isNotEmpty) 'model_name': modelName,
      'records': records.map((e) => e.toJson()).toList(),
      'updated_at': updatedAt,
    };
  }
}

import 'package:octopusmanage/utils/parse_utils.dart';

class CircuitBreakerState {
  final String key;
  final int channelId;
  final int channelKeyId;
  final String modelName;
  final int state;
  final int consecutiveFailures;
  final int lastFailureTime;
  final int tripCount;
  final int updatedAt;

  CircuitBreakerState({
    this.key = '',
    this.channelId = 0,
    this.channelKeyId = 0,
    this.modelName = '',
    this.state = 0,
    this.consecutiveFailures = 0,
    this.lastFailureTime = 0,
    this.tripCount = 0,
    this.updatedAt = 0,
  });

  factory CircuitBreakerState.fromJson(Map<String, dynamic> json) {
    return CircuitBreakerState(
      key: parseString(json['key']),
      channelId: parseInt(json['channel_id']),
      channelKeyId: parseInt(json['channel_key_id']),
      modelName: parseString(json['model_name']),
      state: parseInt(json['state']),
      consecutiveFailures: parseInt(json['consecutive_failures']),
      lastFailureTime: parseInt(json['last_failure_time']),
      tripCount: parseInt(json['trip_count']),
      updatedAt: parseInt(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (key.isNotEmpty) 'key': key,
      'channel_id': channelId,
      'channel_key_id': channelKeyId,
      if (modelName.isNotEmpty) 'model_name': modelName,
      'state': state,
      'consecutive_failures': consecutiveFailures,
      'last_failure_time': lastFailureTime,
      'trip_count': tripCount,
      'updated_at': updatedAt,
    };
  }
}

