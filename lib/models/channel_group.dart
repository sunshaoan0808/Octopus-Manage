import 'package:octopusmanage/utils/parse_utils.dart';

class ChannelGroup {
  final int id;
  final String name;
  final bool isDefault;
  final int createdAt;
  final int updatedAt;

  ChannelGroup({
    this.id = 0,
    this.name = '',
    this.isDefault = false,
    this.createdAt = 0,
    this.updatedAt = 0,
  });

  factory ChannelGroup.fromJson(Map<String, dynamic> json) {
    return ChannelGroup(
      id: parseInt(json['id']),
      name: parseString(json['name']),
      isDefault: parseBool(json['is_default']),
      createdAt: parseInt(json['created_at']),
      updatedAt: parseInt(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      if (name.isNotEmpty) 'name': name,
      'is_default': isDefault,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

