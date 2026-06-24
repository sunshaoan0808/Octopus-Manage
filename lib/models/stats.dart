import 'package:octopusmanage/utils/parse_utils.dart';

class StatsMetrics {
  final int inputToken;
  final int outputToken;
  final double inputCost;
  final double outputCost;
  final int waitTime;
  final int requestSuccess;
  final int requestFailed;

  // Phase 2.1: Latency metrics (ms)
  final double latencyP50;
  final double latencyP95;
  final double latencyP99;

  // Phase 2.1: FTUT (First Token Use Time) metrics (ms)
  final double ftutAvg;
  final double ftutP50;
  final double ftutP95;
  final double ftutP99;

  // Phase 2.1: Latency histogram buckets
  final int histogramLt100;
  final int histogram100to500;
  final int histogram500to1k;
  final int histogram1kto5k;
  final int histogramGt5k;

  StatsMetrics({
    this.inputToken = 0,
    this.outputToken = 0,
    this.inputCost = 0,
    this.outputCost = 0,
    this.waitTime = 0,
    this.requestSuccess = 0,
    this.requestFailed = 0,
    this.latencyP50 = 0,
    this.latencyP95 = 0,
    this.latencyP99 = 0,
    this.ftutAvg = 0,
    this.ftutP50 = 0,
    this.ftutP95 = 0,
    this.ftutP99 = 0,
    this.histogramLt100 = 0,
    this.histogram100to500 = 0,
    this.histogram500to1k = 0,
    this.histogram1kto5k = 0,
    this.histogramGt5k = 0,
  });

  double get totalCost => inputCost + outputCost;
  int get totalTokens => inputToken + outputToken;
  int get totalRequests => requestSuccess + requestFailed;
  double get successRate =>
      totalRequests > 0 ? requestSuccess / totalRequests : 0;

  factory StatsMetrics.fromJson(Map<String, dynamic> json) {
    return StatsMetrics(
      inputToken: parseInt(json['input_token']),
      outputToken: parseInt(json['output_token']),
      inputCost: parseDouble(json['input_cost']),
      outputCost: parseDouble(json['output_cost']),
      waitTime: parseInt(json['wait_time']),
      requestSuccess: parseInt(json['request_success']),
      requestFailed: parseInt(json['request_failed']),
      // Phase 2.1: Latency metrics
      latencyP50: parseDouble(json['latency_p50']),
      latencyP95: parseDouble(json['latency_p95']),
      latencyP99: parseDouble(json['latency_p99']),
      // Phase 2.1: FTUT metrics
      ftutAvg: parseDouble(json['ftut_avg']),
      ftutP50: parseDouble(json['ftut_p50']),
      ftutP95: parseDouble(json['ftut_p95']),
      ftutP99: parseDouble(json['ftut_p99']),
      // Phase 2.1: Latency histogram
      histogramLt100: parseInt(json['histogram_lt_100']),
      histogram100to500: parseInt(json['histogram_100_to_500']),
      histogram500to1k: parseInt(json['histogram_500_to_1k']),
      histogram1kto5k: parseInt(json['histogram_1k_to_5k']),
      histogramGt5k: parseInt(json['histogram_gt_5k']),
    );
  }

  Map<String, dynamic> toJson() => {
    'input_token': inputToken,
    'output_token': outputToken,
    'input_cost': inputCost,
    'output_cost': outputCost,
    'wait_time': waitTime,
    'request_success': requestSuccess,
    'request_failed': requestFailed,
    // Phase 2.1: Latency metrics
    'latency_p50': latencyP50,
    'latency_p95': latencyP95,
    'latency_p99': latencyP99,
    // Phase 2.1: FTUT metrics
    'ftut_avg': ftutAvg,
    'ftut_p50': ftutP50,
    'ftut_p95': ftutP95,
    'ftut_p99': ftutP99,
    // Phase 2.1: Latency histogram
    'histogram_lt_100': histogramLt100,
    'histogram_100_to_500': histogram100to500,
    'histogram_500_to_1k': histogram500to1k,
    'histogram_1k_to_5k': histogram1kto5k,
    'histogram_gt_5k': histogramGt5k,
  };
}

class StatsDaily {
  final String date;
  final StatsMetrics metrics;

  StatsDaily({required this.date, required this.metrics});

  factory StatsDaily.fromJson(Map<String, dynamic> json) {
    return StatsDaily(
      date: parseString(json['date']),
      metrics: StatsMetrics.fromJson(json),
    );
  }

  Map<String, dynamic> toJson() => {'date': date, ...metrics.toJson()};
}

class StatsHourly {
  final int hour;
  final String date;
  final StatsMetrics metrics;

  StatsHourly({required this.hour, required this.date, required this.metrics});

  factory StatsHourly.fromJson(Map<String, dynamic> json) {
    return StatsHourly(
      hour: parseInt(json['hour']),
      date: parseString(json['date']),
      metrics: StatsMetrics.fromJson(json),
    );
  }

  Map<String, dynamic> toJson() => {
    'hour': hour,
    'date': date,
    ...metrics.toJson(),
  };
}

class StatsAPIKeyEntry {
  final int apiKeyId;
  final StatsMetrics metrics;

  StatsAPIKeyEntry({required this.apiKeyId, required this.metrics});

  factory StatsAPIKeyEntry.fromJson(Map<String, dynamic> json) {
    return StatsAPIKeyEntry(
      apiKeyId: parseInt(json['api_key_id']),
      metrics: StatsMetrics.fromJson(json),
    );
  }

  Map<String, dynamic> toJson() => {
    'api_key_id': apiKeyId,
    ...metrics.toJson(),
  };
}
