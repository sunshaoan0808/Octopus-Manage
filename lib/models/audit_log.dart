import 'package:octopusmanage/utils/parse_utils.dart';

class AuditLog {
  final int id;
  final int userId;
  final String username;
  final String action;
  final String method;
  final String path;
  final int statusCode;
  final String target;
  final int createdAt;

  AuditLog({
    this.id = 0,
    this.userId = 0,
    this.username = '',
    this.action = '',
    this.method = '',
    this.path = '',
    this.statusCode = 0,
    this.target = '',
    this.createdAt = 0,
  });

  factory AuditLog.fromJson(Map<String, dynamic> json) {
    return AuditLog(
      id: parseInt(json['id']),
      userId: parseInt(json['user_id']),
      username: parseString(json['username']),
      action: parseString(json['action']),
      method: parseString(json['method']),
      path: parseString(json['path']),
      statusCode: parseInt(json['status_code']),
      target: parseString(json['target']),
      createdAt: parseInt(json['created_at']),
    );
  }
}
