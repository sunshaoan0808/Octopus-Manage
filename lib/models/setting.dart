import 'package:octopusmanage/utils/parse_utils.dart';

class Setting {
  final String key;
  final String value;

  Setting({required this.key, required this.value});

  factory Setting.fromJson(Map<String, dynamic> json) {
    return Setting(
      key: parseString(json['key']),
      value: parseString(json['value']),
    );
  }

  Map<String, dynamic> toJson() => {'key': key, 'value': value};
}
