import 'package:octopusmanage/utils/parse_utils.dart';

// ====== Group Test ======

class GroupModelTestResult {
  final int itemId;
  final int channelId;
  final String channelName;
  final String modelName;
  final bool passed;
  final int attempts;
  final int statusCode;
  final String responseText;
  final String message;

  GroupModelTestResult({
    this.itemId = 0,
    this.channelId = 0,
    this.channelName = '',
    this.modelName = '',
    this.passed = false,
    this.attempts = 0,
    this.statusCode = 0,
    this.responseText = '',
    this.message = '',
  });

  factory GroupModelTestResult.fromJson(Map<String, dynamic> json) {
    return GroupModelTestResult(
      itemId: parseInt(json['item_id']),
      channelId: parseInt(json['channel_id']),
      channelName: parseString(json['channel_name']),
      modelName: parseString(json['model_name']),
      passed: parseBool(json['passed']),
      attempts: parseInt(json['attempts']),
      statusCode: parseInt(json['status_code']),
      responseText: parseString(json['response_text']),
      message: parseString(json['message']),
    );
  }

  Map<String, dynamic> toJson() => {
    'item_id': itemId,
    'channel_id': channelId,
    'channel_name': channelName,
    'model_name': modelName,
    'passed': passed,
    'attempts': attempts,
    'status_code': statusCode,
    'response_text': responseText,
    'message': message,
  };
}

class GroupModelTestProgress {
  final String id;
  final bool passed;
  final int completed;
  final int total;
  final bool done;
  final List<GroupModelTestResult> results;
  final String message;

  GroupModelTestProgress({
    this.id = '',
    this.passed = false,
    this.completed = 0,
    this.total = 0,
    this.done = false,
    this.results = const [],
    this.message = '',
  });

  factory GroupModelTestProgress.fromJson(Map<String, dynamic> json) {
    return GroupModelTestProgress(
      id: parseString(json['id']),
      passed: parseBool(json['passed']),
      completed: parseInt(json['completed']),
      total: parseInt(json['total']),
      done: parseBool(json['done']),
      results: parseJsonMapList(
        json['results'],
      ).map(GroupModelTestResult.fromJson).toList(),
      message: parseString(json['message']),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'passed': passed,
    'completed': completed,
    'total': total,
    'done': done,
    'results': results.map((e) => e.toJson()).toList(),
    'message': message,
  };
}

// ====== Auto Group ======

class AutoGroupResult {
  final int totalChannels;
  final int totalModelsSeen;
  final int totalDistinctRawModels;
  final int totalCandidates;
  final int createdGroups;
  final int skippedExistingGroups;
  final int skippedCoveredModels;
  final int failedGroups;
  final List<AutoGroupCreatedItem> created;
  final List<AutoGroupSkippedItem> skipped;

  AutoGroupResult({
    this.totalChannels = 0,
    this.totalModelsSeen = 0,
    this.totalDistinctRawModels = 0,
    this.totalCandidates = 0,
    this.createdGroups = 0,
    this.skippedExistingGroups = 0,
    this.skippedCoveredModels = 0,
    this.failedGroups = 0,
    this.created = const [],
    this.skipped = const [],
  });

  factory AutoGroupResult.fromJson(Map<String, dynamic> json) {
    return AutoGroupResult(
      totalChannels: parseInt(json['total_channels']),
      totalModelsSeen: parseInt(json['total_models_seen']),
      totalDistinctRawModels: parseInt(json['total_distinct_raw_models']),
      totalCandidates: parseInt(json['total_candidates']),
      createdGroups: parseInt(json['created_groups']),
      skippedExistingGroups: parseInt(json['skipped_existing_groups']),
      skippedCoveredModels: parseInt(json['skipped_covered_models']),
      failedGroups: parseInt(json['failed_groups']),
      created: parseJsonMapList(
        json['created'],
      ).map(AutoGroupCreatedItem.fromJson).toList(),
      skipped: parseJsonMapList(
        json['skipped'],
      ).map(AutoGroupSkippedItem.fromJson).toList(),
    );
  }

  int get groupsAffected => createdGroups;
  int get itemsAdded =>
      created.fold<int>(0, (total, item) => total + item.matchedModels.length);
}

class AutoGroupCreatedItem {
  final String name;
  final String endpointType;
  final List<String> matchedModels;

  AutoGroupCreatedItem({
    this.name = '',
    this.endpointType = '*',
    this.matchedModels = const [],
  });

  factory AutoGroupCreatedItem.fromJson(Map<String, dynamic> json) {
    return AutoGroupCreatedItem(
      name: parseString(json['name']),
      endpointType: parseString(json['endpoint_type'], fallback: '*'),
      matchedModels: parseStringList(json['matched_models']),
    );
  }
}

class AutoGroupSkippedItem {
  final String name;
  final String endpointType;
  final String reason;

  AutoGroupSkippedItem({
    this.name = '',
    this.endpointType = '*',
    this.reason = '',
  });

  factory AutoGroupSkippedItem.fromJson(Map<String, dynamic> json) {
    return AutoGroupSkippedItem(
      name: parseString(json['name']),
      endpointType: parseString(json['endpoint_type'], fallback: '*'),
      reason: parseString(json['reason']),
    );
  }
}
