import 'package:octopusmanage/utils/parse_utils.dart';

enum AIRouteScope { table, group }

extension AIRouteScopeValue on AIRouteScope {
  String get value => this == AIRouteScope.group ? 'group' : 'table';
}

AIRouteScope parseAIRouteScope(String? value) {
  return value == 'group' ? AIRouteScope.group : AIRouteScope.table;
}

class AIRouteResult {
  final AIRouteScope scope;
  final int groupId;
  final int groupCount;
  final int routeCount;
  final int itemCount;

  const AIRouteResult({
    this.scope = AIRouteScope.table,
    this.groupId = 0,
    this.groupCount = 0,
    this.routeCount = 0,
    this.itemCount = 0,
  });

  factory AIRouteResult.fromJson(Map<String, dynamic> json) {
    return AIRouteResult(
      scope: parseAIRouteScope(parseString(json['scope'])),
      groupId: parseInt(json['group_id']),
      groupCount: parseInt(json['group_count']),
      routeCount: parseInt(json['route_count']),
      itemCount: parseInt(json['item_count']),
    );
  }
}

class AIRouteProgressSummary {
  final int totalChannels;
  final int completedChannels;
  final int runningChannels;
  final int pendingChannels;
  final int failedChannels;
  final int totalModels;
  final int completedModels;

  const AIRouteProgressSummary({
    this.totalChannels = 0,
    this.completedChannels = 0,
    this.runningChannels = 0,
    this.pendingChannels = 0,
    this.failedChannels = 0,
    this.totalModels = 0,
    this.completedModels = 0,
  });

  factory AIRouteProgressSummary.fromJson(Map<String, dynamic> json) {
    return AIRouteProgressSummary(
      totalChannels: parseInt(json['total_channels']),
      completedChannels: parseInt(json['completed_channels']),
      runningChannels: parseInt(json['running_channels']),
      pendingChannels: parseInt(json['pending_channels']),
      failedChannels: parseInt(json['failed_channels']),
      totalModels: parseInt(json['total_models']),
      completedModels: parseInt(json['completed_models']),
    );
  }
}

class AIRouteBatchProgress {
  final int index;
  final int total;
  final String endpointType;
  final int modelCount;
  final List<int> channelIds;
  final List<String> channelNames;
  final String serviceName;
  final int attempt;
  final String status;
  final String message;

  const AIRouteBatchProgress({
    this.index = 0,
    this.total = 0,
    this.endpointType = '',
    this.modelCount = 0,
    this.channelIds = const [],
    this.channelNames = const [],
    this.serviceName = '',
    this.attempt = 0,
    this.status = '',
    this.message = '',
  });

  factory AIRouteBatchProgress.fromJson(Map<String, dynamic> json) {
    return AIRouteBatchProgress(
      index: parseInt(json['index']),
      total: parseInt(json['total']),
      endpointType: parseString(json['endpoint_type']),
      modelCount: parseInt(json['model_count']),
      channelIds: parseIntList(json['channel_ids']),
      channelNames: parseStringList(json['channel_names']),
      serviceName: parseString(json['service_name']),
      attempt: parseInt(json['attempt']),
      status: parseString(json['status']),
      message: parseString(json['message']),
    );
  }
}

class AIRouteChannelProgress {
  final int channelId;
  final String channelName;
  final String provider;
  final String status;
  final int totalModels;
  final int processedModels;
  final String message;

  const AIRouteChannelProgress({
    this.channelId = 0,
    this.channelName = '',
    this.provider = '',
    this.status = 'pending',
    this.totalModels = 0,
    this.processedModels = 0,
    this.message = '',
  });

  factory AIRouteChannelProgress.fromJson(Map<String, dynamic> json) {
    return AIRouteChannelProgress(
      channelId: parseInt(json['channel_id']),
      channelName: parseString(json['channel_name']),
      provider: parseString(json['provider']),
      status: parseString(json['status'], fallback: 'pending'),
      totalModels: parseInt(json['total_models']),
      processedModels: parseInt(json['processed_models']),
      message: parseString(json['message']),
    );
  }
}

class AIRouteProgress {
  final String id;
  final AIRouteScope scope;
  final int groupId;
  final String status;
  final String currentStep;
  final int progressPercent;
  final int totalBatches;
  final int completedBatches;
  final bool done;
  final bool resultReady;
  final String message;
  final String errorReason;
  final String startedAt;
  final String updatedAt;
  final String heartbeatAt;
  final String finishedAt;
  final int eventSequence;
  final AIRouteProgressSummary? summary;
  final AIRouteBatchProgress? currentBatch;
  final List<AIRouteBatchProgress> runningBatches;
  final List<AIRouteChannelProgress> channels;
  final AIRouteResult? result;

  const AIRouteProgress({
    this.id = '',
    this.scope = AIRouteScope.table,
    this.groupId = 0,
    this.status = 'queued',
    this.currentStep = 'queued',
    this.progressPercent = 0,
    this.totalBatches = 0,
    this.completedBatches = 0,
    this.done = false,
    this.resultReady = false,
    this.message = '',
    this.errorReason = '',
    this.startedAt = '',
    this.updatedAt = '',
    this.heartbeatAt = '',
    this.finishedAt = '',
    this.eventSequence = 0,
    this.summary,
    this.currentBatch,
    this.runningBatches = const [],
    this.channels = const [],
    this.result,
  });

  bool get isTerminal =>
      status == 'completed' || status == 'failed' || status == 'timeout';

  bool get isCompletedWithResult =>
      done && status == 'completed' && resultReady;

  factory AIRouteProgress.fromJson(Map<String, dynamic> json) {
    final channelList = parseJsonMapList(
      json['channels'],
    ).map(AIRouteChannelProgress.fromJson).toList();

    return AIRouteProgress(
      id: parseString(json['id']),
      scope: parseAIRouteScope(parseString(json['scope'])),
      groupId: parseInt(json['group_id']),
      status: parseString(
        json['status'],
        fallback: parseBool(json['done']) ? 'completed' : 'queued',
      ),
      currentStep: parseString(
        json['current_step'],
        fallback: parseBool(json['done']) ? 'completed' : 'queued',
      ),
      progressPercent: parseInt(json['progress_percent']),
      totalBatches: parseInt(json['total_batches']),
      completedBatches: parseInt(json['completed_batches']),
      done: parseBool(json['done']),
      resultReady: parseBool(json['result_ready']),
      message: parseString(json['message']),
      errorReason: parseString(json['error_reason']),
      startedAt: parseString(json['started_at']),
      updatedAt: parseString(json['updated_at']),
      heartbeatAt: parseString(json['heartbeat_at']),
      finishedAt: parseString(json['finished_at']),
      eventSequence: parseInt(json['event_sequence']),
      summary: parseJsonMap(json['summary']) != null
          ? AIRouteProgressSummary.fromJson(parseJsonMap(json['summary'])!)
          : null,
      currentBatch: parseJsonMap(json['current_batch']) != null
          ? AIRouteBatchProgress.fromJson(parseJsonMap(json['current_batch'])!)
          : null,
      runningBatches: parseJsonMapList(
        json['running_batches'],
      ).map(AIRouteBatchProgress.fromJson).toList(),
      channels: channelList,
      result: parseJsonMap(json['result']) != null
          ? AIRouteResult.fromJson(parseJsonMap(json['result'])!)
          : null,
    );
  }
}
