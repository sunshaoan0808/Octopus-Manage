import 'package:octopusmanage/utils/parse_utils.dart';

class ModelMapping {
  final int id;
  final String name;
  final String pattern;
  final String matchType;
  final String targetModel;
  final int priority;
  final int? groupId;
  final bool enabled;
  final String createdAt;
  final String updatedAt;

  const ModelMapping({
    this.id = 0,
    this.name = '',
    this.pattern = '',
    this.matchType = 'exact',
    this.targetModel = '',
    this.priority = 0,
    this.groupId,
    this.enabled = true,
    this.createdAt = '',
    this.updatedAt = '',
  });

  factory ModelMapping.fromJson(Map<String, dynamic> json) {
    return ModelMapping(
      id: parseInt(json['id']),
      name: parseString(json['name']),
      pattern: parseString(json['pattern']),
      matchType: parseString(json['match_type'], fallback: 'exact'),
      targetModel: parseString(json['target_model']),
      priority: parseInt(json['priority']),
      groupId:
          json['group_id'] == null ? null : parseInt(json['group_id']),
      enabled: parseBool(json['enabled'], fallback: true),
      createdAt: parseString(json['created_at']),
      updatedAt: parseString(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id > 0) 'id': id,
      'name': name,
      'pattern': pattern,
      'match_type': matchType,
      'target_model': targetModel,
      'priority': priority,
      if (groupId != null) 'group_id': groupId,
      'enabled': enabled,
    };
  }
}
