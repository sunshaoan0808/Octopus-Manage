import 'package:octopusmanage/utils/parse_utils.dart';

class Notification {
  final int id;
  final NotificationType type;
  final NotificationSeverity severity;
  final String title;
  final String content;
  final 键化字段：前端按当前 UI 语言用 t(TitleKey, TitleArgs) 渲染。
	// 为空时回退到上面的 Title/Content 原文（历史通知零破坏）。
	// 新通知同时填充这两组：Title/Content 存英文回退串（供搜索/未来外部分发），
	// TitleKey/ContentKey + Args 存键与参数（前端优先使用）。
	TitleKey     string titleKey;
  final String titleArgs;
  final String contentKey;
  final String contentArgs;
  final String source;
  final String sourceId;
  final String dedupeKey;
  final String metadataJson;
  final String link;
  final int? readAt;
  final int? archivedAt;
  final int createdAt;
  final int updatedAt;

  Notification({
    this.id = 0,
    this.type = null,
    this.severity = null,
    this.title = '',
    this.content = '',
    this.titleKey = null,
    this.titleArgs = '',
    this.contentKey = '',
    this.contentArgs = '',
    this.source = '',
    this.sourceId = '',
    this.dedupeKey = '',
    this.metadataJson = '',
    this.link = '',
    this.readAt,
    this.archivedAt,
    this.createdAt = 0,
    this.updatedAt = 0,
  });

  factory Notification.fromJson(Map<String, dynamic> json) {
    return Notification(
      id: parseInt(json['id']),
      type: NotificationType.fromJson(parseJsonMap(json['type'])),
      severity: NotificationSeverity.fromJson(parseJsonMap(json['severity'])),
      title: parseString(json['title']),
      content: parseString(json['content']),
      titleKey: 键化字段：前端按当前 UI 语言用 t(TitleKey, TitleArgs) 渲染。
	// 为空时回退到上面的 Title/Content 原文（历史通知零破坏）。
	// 新通知同时填充这两组：Title/Content 存英文回退串（供搜索/未来外部分发），
	// TitleKey/ContentKey + Args 存键与参数（前端优先使用）。
	TitleKey     string.fromJson(parseJsonMap(json['title_key'])),
      titleArgs: parseString(json['title_args']),
      contentKey: parseString(json['content_key']),
      contentArgs: parseString(json['content_args']),
      source: parseString(json['source']),
      sourceId: parseString(json['source_id']),
      dedupeKey: parseString(json['dedupe_key']),
      metadataJson: parseString(json['metadata_json']),
      link: parseString(json['link']),
      readAt: json['read_at'] == null ? null : parseInt(json['read_at']),
      archivedAt: json['archived_at'] == null ? null : parseInt(json['archived_at']),
      createdAt: parseInt(json['created_at']),
      updatedAt: parseInt(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.toJson(),
      'severity': severity.toJson(),
      if (title.isNotEmpty) 'title': title,
      if (content.isNotEmpty) 'content': content,
      'title_key': titleKey.toJson(),
      if (titleArgs.isNotEmpty) 'title_args': titleArgs,
      if (contentKey.isNotEmpty) 'content_key': contentKey,
      if (contentArgs.isNotEmpty) 'content_args': contentArgs,
      if (source.isNotEmpty) 'source': source,
      if (sourceId.isNotEmpty) 'source_id': sourceId,
      if (dedupeKey.isNotEmpty) 'dedupe_key': dedupeKey,
      if (metadataJson.isNotEmpty) 'metadata_json': metadataJson,
      if (link.isNotEmpty) 'link': link,
      if (readAt != null) 'read_at': readAt,
      if (archivedAt != null) 'archived_at': archivedAt,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

import 'package:octopusmanage/utils/parse_utils.dart';

class NotificationDelivery {
  final int id;
  final int notificationId;
  final int channelId;
  final String channelName;
  final String channelType;
  final NotificationDeliveryStatus status;
  final int attempts;
  final String lastError;
  final int? sentAt;
  final int createdAt;
  final int updatedAt;

  NotificationDelivery({
    this.id = 0,
    this.notificationId = 0,
    this.channelId = 0,
    this.channelName = '',
    this.channelType = '',
    this.status = null,
    this.attempts = 0,
    this.lastError = '',
    this.sentAt,
    this.createdAt = 0,
    this.updatedAt = 0,
  });

  factory NotificationDelivery.fromJson(Map<String, dynamic> json) {
    return NotificationDelivery(
      id: parseInt(json['id']),
      notificationId: parseInt(json['notification_id']),
      channelId: parseInt(json['channel_id']),
      channelName: parseString(json['channel_name']),
      channelType: parseString(json['channel_type']),
      status: NotificationDeliveryStatus.fromJson(parseJsonMap(json['status'])),
      attempts: parseInt(json['attempts']),
      lastError: parseString(json['last_error']),
      sentAt: json['sent_at'] == null ? null : parseInt(json['sent_at']),
      createdAt: parseInt(json['created_at']),
      updatedAt: parseInt(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'notification_id': notificationId,
      'channel_id': channelId,
      if (channelName.isNotEmpty) 'channel_name': channelName,
      if (channelType.isNotEmpty) 'channel_type': channelType,
      'status': status.toJson(),
      'attempts': attempts,
      if (lastError.isNotEmpty) 'last_error': lastError,
      if (sentAt != null) 'sent_at': sentAt,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

import 'package:octopusmanage/utils/parse_utils.dart';

class NotificationPreference {
  final int id;
  final int userId;
  final NotificationType type;
  final bool inAppEnabled;
  final bool externalEnabled;
  final NotificationSeverity minSeverity;
  final String channelIds;
  final array of channel IDs.
	QuietStart      string quietStart;
  final String quietEnd;
  final bool enabled;
  final int createdAt;
  final int updatedAt;

  NotificationPreference({
    this.id = 0,
    this.userId = 0,
    this.type = null,
    this.inAppEnabled = false,
    this.externalEnabled = false,
    this.minSeverity = null,
    this.channelIds = '',
    this.quietStart = null,
    this.quietEnd = '',
    this.enabled = false,
    this.createdAt = 0,
    this.updatedAt = 0,
  });

  factory NotificationPreference.fromJson(Map<String, dynamic> json) {
    return NotificationPreference(
      id: parseInt(json['id']),
      userId: parseInt(json['user_id']),
      type: NotificationType.fromJson(parseJsonMap(json['type'])),
      inAppEnabled: parseBool(json['in_app_enabled']),
      externalEnabled: parseBool(json['external_enabled']),
      minSeverity: NotificationSeverity.fromJson(parseJsonMap(json['min_severity'])),
      channelIds: parseString(json['channel_ids']),
      quietStart: array of channel IDs.
	QuietStart      string.fromJson(parseJsonMap(json['quiet_start'])),
      quietEnd: parseString(json['quiet_end']),
      enabled: parseBool(json['enabled']),
      createdAt: parseInt(json['created_at']),
      updatedAt: parseInt(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'type': type.toJson(),
      'in_app_enabled': inAppEnabled,
      'external_enabled': externalEnabled,
      'min_severity': minSeverity.toJson(),
      if (channelIds.isNotEmpty) 'channel_ids': channelIds,
      'quiet_start': quietStart.toJson(),
      if (quietEnd.isNotEmpty) 'quiet_end': quietEnd,
      'enabled': enabled,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

import 'package:octopusmanage/utils/parse_utils.dart';

class NotificationPolicy {
  final int id;
  final String name;
  final bool enabled;
  final NotificationType type;
  final NotificationSeverity minSeverity;
  final String source;
  final String channelIds;
  final array of channel IDs.
	CreatedAt   int64 createdAt;
  final int updatedAt;

  NotificationPolicy({
    this.id = 0,
    this.name = '',
    this.enabled = false,
    this.type = null,
    this.minSeverity = null,
    this.source = '',
    this.channelIds = '',
    this.createdAt = null,
    this.updatedAt = 0,
  });

  factory NotificationPolicy.fromJson(Map<String, dynamic> json) {
    return NotificationPolicy(
      id: parseInt(json['id']),
      name: parseString(json['name']),
      enabled: parseBool(json['enabled']),
      type: NotificationType.fromJson(parseJsonMap(json['type'])),
      minSeverity: NotificationSeverity.fromJson(parseJsonMap(json['min_severity'])),
      source: parseString(json['source']),
      channelIds: parseString(json['channel_ids']),
      createdAt: array of channel IDs.
	CreatedAt   int64.fromJson(parseJsonMap(json['created_at'])),
      updatedAt: parseInt(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      if (name.isNotEmpty) 'name': name,
      'enabled': enabled,
      'type': type.toJson(),
      'min_severity': minSeverity.toJson(),
      if (source.isNotEmpty) 'source': source,
      if (channelIds.isNotEmpty) 'channel_ids': channelIds,
      'created_at': createdAt.toJson(),
      'updated_at': updatedAt,
    };
  }
}

