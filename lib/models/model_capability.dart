import 'package:octopusmanage/utils/parse_utils.dart';

class ModelCapability {
  final String name;
  final List<String> endpoints;
  final bool conversation;
  final bool available;

  ModelCapability({
    this.name = '',
    this.endpoints = const [],
    this.conversation = false,
    this.available = false,
  });

  factory ModelCapability.fromJson(Map<String, dynamic> json) {
    return ModelCapability(
      name: parseString(json['name']),
      endpoints: parseJsonMapList(json['endpoints']).map(String.fromJson).toList(),
      conversation: parseBool(json['conversation']),
      available: parseBool(json['available']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (name.isNotEmpty) 'name': name,
      'endpoints': endpoints.map((e) => e.toJson()).toList(),
      'conversation': conversation,
      'available': available,
    };
  }
}

