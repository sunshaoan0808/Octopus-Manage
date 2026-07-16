import 'package:octopusmanage/utils/parse_utils.dart';

class AIRouteTask {
  final String id;
  final AIRouteScope scope;
  final int groupId;
  final AIRouteTaskStatus status;
  final AIRouteTaskStep currentStep;
  final int progressPercent;
  final int totalBatches;
  final int completedBatches;
  final bool done;
  final bool resultReady;
  final String message;
  final String messageKey;
  final map[string]any messageArgs;
  final String errorReason;
  final String errorReasonKey;
  final map[string]any errorReasonArgs;
  final String? startedAt;
  final String? updatedAt;
  final String? heartbeatAt;
  final String? finishedAt;
  final int eventSequence;
  final GenerateAIRouteProgressSummary? summary;
  final GenerateAIRouteCurrentBatch? currentBatch;
  final List<GenerateAIRouteRunningBatch> runningBatches;
  final List<GenerateAIRouteChannelProgress> channels;
  final GenerateAIRouteResult? result;

  AIRouteTask({
    this.id = '',
    this.scope = null,
    this.groupId = 0,
    this.status = null,
    this.currentStep = null,
    this.progressPercent = 0,
    this.totalBatches = 0,
    this.completedBatches = 0,
    this.done = false,
    this.resultReady = false,
    this.message = '',
    this.messageKey = '',
    this.messageArgs = null,
    this.errorReason = '',
    this.errorReasonKey = '',
    this.errorReasonArgs = null,
    this.startedAt,
    this.updatedAt,
    this.heartbeatAt,
    this.finishedAt,
    this.eventSequence = 0,
    this.summary,
    this.currentBatch,
    this.runningBatches = const [],
    this.channels = const [],
    this.result,
  });

  factory AIRouteTask.fromJson(Map<String, dynamic> json) {
    return AIRouteTask(
      id: parseString(json['id']),
      scope: AIRouteScope.fromJson(parseJsonMap(json['scope'])),
      groupId: parseInt(json['group_id']),
      status: AIRouteTaskStatus.fromJson(parseJsonMap(json['status'])),
      currentStep: AIRouteTaskStep.fromJson(parseJsonMap(json['current_step'])),
      progressPercent: parseInt(json['progress_percent']),
      totalBatches: parseInt(json['total_batches']),
      completedBatches: parseInt(json['completed_batches']),
      done: parseBool(json['done']),
      resultReady: parseBool(json['result_ready']),
      message: parseString(json['message']),
      messageKey: parseString(json['message_key']),
      messageArgs: map[string]any.fromJson(parseJsonMap(json['message_args'])),
      errorReason: parseString(json['error_reason']),
      errorReasonKey: parseString(json['error_reason_key']),
      errorReasonArgs: map[string]any.fromJson(parseJsonMap(json['error_reason_args'])),
      startedAt: json['started_at'] == null ? null : parseString(json['started_at']),
      updatedAt: json['updated_at'] == null ? null : parseString(json['updated_at']),
      heartbeatAt: json['heartbeat_at'] == null ? null : parseString(json['heartbeat_at']),
      finishedAt: json['finished_at'] == null ? null : parseString(json['finished_at']),
      eventSequence: parseInt(json['event_sequence']),
      summary: parseJsonMap(json['summary']) != null ? GenerateAIRouteProgressSummary.fromJson(parseJsonMap(json['summary'])!) : null,
      currentBatch: parseJsonMap(json['current_batch']) != null ? GenerateAIRouteCurrentBatch.fromJson(parseJsonMap(json['current_batch'])!) : null,
      runningBatches: parseJsonMapList(json['running_batches']).map(GenerateAIRouteRunningBatch.fromJson).toList(),
      channels: parseJsonMapList(json['channels']).map(GenerateAIRouteChannelProgress.fromJson).toList(),
      result: parseJsonMap(json['result']) != null ? GenerateAIRouteResult.fromJson(parseJsonMap(json['result'])!) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id.isNotEmpty) 'id': id,
      'scope': scope.toJson(),
      'group_id': groupId,
      'status': status.toJson(),
      'current_step': currentStep.toJson(),
      'progress_percent': progressPercent,
      'total_batches': totalBatches,
      'completed_batches': completedBatches,
      'done': done,
      'result_ready': resultReady,
      if (message.isNotEmpty) 'message': message,
      if (messageKey.isNotEmpty) 'message_key': messageKey,
      'message_args': messageArgs.toJson(),
      if (errorReason.isNotEmpty) 'error_reason': errorReason,
      if (errorReasonKey.isNotEmpty) 'error_reason_key': errorReasonKey,
      'error_reason_args': errorReasonArgs.toJson(),
      if (startedAt != null) 'started_at': startedAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (heartbeatAt != null) 'heartbeat_at': heartbeatAt,
      if (finishedAt != null) 'finished_at': finishedAt,
      'event_sequence': eventSequence,
      if (summary != null) 'summary': summary!.toJson(),
      if (currentBatch != null) 'current_batch': currentBatch!.toJson(),
      'running_batches': runningBatches.map((e) => e.toJson()).toList(),
      'channels': channels.map((e) => e.toJson()).toList(),
      if (result != null) 'result': result!.toJson(),
    };
  }
}

