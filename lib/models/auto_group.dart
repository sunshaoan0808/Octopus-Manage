import 'package:octopusmanage/utils/parse_utils.dart';

class ChannelModelRef {
  final int channelId;
  final String channelName;
  final String rawModel;

  ChannelModelRef({
    this.channelId = 0,
    this.channelName = '',
    this.rawModel = '',
  });

  factory ChannelModelRef.fromJson(Map<String, dynamic> json) {
    return ChannelModelRef(
      channelId: parseInt(json['channel_id']),
      channelName: parseString(json['channel_name']),
      rawModel: parseString(json['raw_model']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'channel_id': channelId,
      if (channelName.isNotEmpty) 'channel_name': channelName,
      if (rawModel.isNotEmpty) 'raw_model': rawModel,
    };
  }
}

import 'package:octopusmanage/utils/parse_utils.dart';

class ModelIdentity {
  final String raw;
  final String cleaned;
  final String canonical;
  final String endpointType;
  final String confidence;
  final String matchedRule;

  ModelIdentity({
    this.raw = '',
    this.cleaned = '',
    this.canonical = '',
    this.endpointType = '',
    this.confidence = '',
    this.matchedRule = '',
  });

  factory ModelIdentity.fromJson(Map<String, dynamic> json) {
    return ModelIdentity(
      raw: parseString(json['raw']),
      cleaned: parseString(json['cleaned']),
      canonical: parseString(json['canonical']),
      endpointType: parseString(json['endpoint_type']),
      confidence: parseString(json['confidence']),
      matchedRule: parseString(json['matched_rule']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (raw.isNotEmpty) 'raw': raw,
      if (cleaned.isNotEmpty) 'cleaned': cleaned,
      if (canonical.isNotEmpty) 'canonical': canonical,
      if (endpointType.isNotEmpty) 'endpoint_type': endpointType,
      if (confidence.isNotEmpty) 'confidence': confidence,
      if (matchedRule.isNotEmpty) 'matched_rule': matchedRule,
    };
  }
}

import 'package:octopusmanage/utils/parse_utils.dart';

class CandidateGroup {
  final String endpointType;
  final String canonical;
  final List<String> rawModels;
  final List<int> channelIds;
  final List<ChannelModelRef> refs;
  final String matchRegex;

  CandidateGroup({
    this.endpointType = '',
    this.canonical = '',
    this.rawModels = const [],
    this.channelIds = const [],
    this.refs = const [],
    this.matchRegex = '',
  });

  factory CandidateGroup.fromJson(Map<String, dynamic> json) {
    return CandidateGroup(
      endpointType: parseString(json['endpoint_type']),
      canonical: parseString(json['canonical']),
      rawModels: parseJsonMapList(json['raw_models']).map(String.fromJson).toList(),
      channelIds: parseJsonMapList(json['channel_ids']).map(int.fromJson).toList(),
      refs: parseJsonMapList(json['refs']).map(ChannelModelRef.fromJson).toList(),
      matchRegex: parseString(json['match_regex']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (endpointType.isNotEmpty) 'endpoint_type': endpointType,
      if (canonical.isNotEmpty) 'canonical': canonical,
      'raw_models': rawModels.map((e) => e.toJson()).toList(),
      'channel_ids': channelIds.map((e) => e.toJson()).toList(),
      'refs': refs.map((e) => e.toJson()).toList(),
      if (matchRegex.isNotEmpty) 'match_regex': matchRegex,
    };
  }
}

import 'package:octopusmanage/utils/parse_utils.dart';

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
      created: parseJsonMapList(json['created']).map(AutoGroupCreatedItem.fromJson).toList(),
      skipped: parseJsonMapList(json['skipped']).map(AutoGroupSkippedItem.fromJson).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_channels': totalChannels,
      'total_models_seen': totalModelsSeen,
      'total_distinct_raw_models': totalDistinctRawModels,
      'total_candidates': totalCandidates,
      'created_groups': createdGroups,
      'skipped_existing_groups': skippedExistingGroups,
      'skipped_covered_models': skippedCoveredModels,
      'failed_groups': failedGroups,
      'created': created.map((e) => e.toJson()).toList(),
      'skipped': skipped.map((e) => e.toJson()).toList(),
    };
  }
}

import 'package:octopusmanage/utils/parse_utils.dart';

class AutoGroupCreatedItem {
  final String name;
  final String endpointType;
  final String category;
  final List<String> matchedModels;

  AutoGroupCreatedItem({
    this.name = '',
    this.endpointType = '',
    this.category = '',
    this.matchedModels = const [],
  });

  factory AutoGroupCreatedItem.fromJson(Map<String, dynamic> json) {
    return AutoGroupCreatedItem(
      name: parseString(json['name']),
      endpointType: parseString(json['endpoint_type']),
      category: parseString(json['category']),
      matchedModels: parseJsonMapList(json['matched_models']).map(String.fromJson).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (name.isNotEmpty) 'name': name,
      if (endpointType.isNotEmpty) 'endpoint_type': endpointType,
      if (category.isNotEmpty) 'category': category,
      'matched_models': matchedModels.map((e) => e.toJson()).toList(),
    };
  }
}

import 'package:octopusmanage/utils/parse_utils.dart';

class AutoGroupSkippedItem {
  final String name;
  final String endpointType;
  final String reason;

  AutoGroupSkippedItem({
    this.name = '',
    this.endpointType = '',
    this.reason = '',
  });

  factory AutoGroupSkippedItem.fromJson(Map<String, dynamic> json) {
    return AutoGroupSkippedItem(
      name: parseString(json['name']),
      endpointType: parseString(json['endpoint_type']),
      reason: parseString(json['reason']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (name.isNotEmpty) 'name': name,
      if (endpointType.isNotEmpty) 'endpoint_type': endpointType,
      if (reason.isNotEmpty) 'reason': reason,
    };
  }
}

