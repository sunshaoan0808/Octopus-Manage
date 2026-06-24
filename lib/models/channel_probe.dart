import 'package:octopusmanage/utils/parse_utils.dart';

// ====== Channel Test ======

class ChannelTestResult {
  final String baseUrl;
  final String keyRemark;
  final String keyMasked;
  final int statusCode;
  final bool passed;
  final int latencyMs;
  final String message;
  final String responseBody;

  ChannelTestResult({
    required this.baseUrl,
    this.keyRemark = '',
    this.keyMasked = '',
    this.statusCode = 0,
    this.passed = false,
    this.latencyMs = 0,
    this.message = '',
    this.responseBody = '',
  });

  factory ChannelTestResult.fromJson(Map<String, dynamic> json) {
    return ChannelTestResult(
      baseUrl: parseString(json['base_url']),
      keyRemark: parseString(json['key_remark']),
      keyMasked: parseString(json['key_masked']),
      statusCode: parseInt(json['status_code']),
      passed: parseBool(json['passed']),
      latencyMs: parseInt(json['latency_ms']),
      message: parseString(json['message']),
      responseBody: parseString(json['response_body']),
    );
  }

  Map<String, dynamic> toJson() => {
    'base_url': baseUrl,
    'key_remark': keyRemark,
    'key_masked': keyMasked,
    'status_code': statusCode,
    'passed': passed,
    'latency_ms': latencyMs,
    'message': message,
    'response_body': responseBody,
  };
}

class ChannelTestSummary {
  final bool passed;
  final List<ChannelTestResult> results;

  ChannelTestSummary({this.passed = false, this.results = const []});

  factory ChannelTestSummary.fromJson(Map<String, dynamic> json) {
    return ChannelTestSummary(
      passed: parseBool(json['passed']),
      results: parseJsonMapList(
        json['results'],
      ).map(ChannelTestResult.fromJson).toList(),
    );
  }
}
