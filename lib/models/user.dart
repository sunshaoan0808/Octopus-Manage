import 'package:octopusmanage/utils/parse_utils.dart';

class User {
  final int id;
  final String username;
  final String role;

  User({
    this.id = 0,
    required this.username,
    this.role = 'viewer',
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: parseInt(json['id']),
      username: parseString(json['username']),
      role: parseString(json['role'], fallback: 'viewer'),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id > 0) 'id': id,
      'username': username,
      'role': role,
    };
  }
}
