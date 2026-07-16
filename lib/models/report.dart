import 'package:octopusmanage/utils/parse_utils.dart';

class ReportSchedule {
  final int id;
  final String name;
  final bool enabled;
  final ReportType type;
  final String metrics;
  final array of ReportMetric
	NotifChannelID int notifChannelId;
  final int sendHour;
  final of day to send (in stats timezone)
	SendDayOfWeek  int sendDayOfWeek;
  final weekly reports
	SendDayOfMonth int sendDayOfMonth;
  final monthly reports
	LastSentAt     int64 lastSentAt;

  ReportSchedule({
    this.id = 0,
    this.name = '',
    this.enabled = false,
    this.type = null,
    this.metrics = '',
    this.notifChannelId = null,
    this.sendHour = 0,
    this.sendDayOfWeek = null,
    this.sendDayOfMonth = null,
    this.lastSentAt = null,
  });

  factory ReportSchedule.fromJson(Map<String, dynamic> json) {
    return ReportSchedule(
      id: parseInt(json['id']),
      name: parseString(json['name']),
      enabled: parseBool(json['enabled']),
      type: ReportType.fromJson(parseJsonMap(json['type'])),
      metrics: parseString(json['metrics']),
      notifChannelId: array of ReportMetric
	NotifChannelID int.fromJson(parseJsonMap(json['notif_channel_id'])),
      sendHour: parseInt(json['send_hour']),
      sendDayOfWeek: of day to send (in stats timezone)
	SendDayOfWeek  int.fromJson(parseJsonMap(json['send_day_of_week'])),
      sendDayOfMonth: weekly reports
	SendDayOfMonth int.fromJson(parseJsonMap(json['send_day_of_month'])),
      lastSentAt: monthly reports
	LastSentAt     int64.fromJson(parseJsonMap(json['last_sent_at'])),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      if (name.isNotEmpty) 'name': name,
      'enabled': enabled,
      'type': type.toJson(),
      if (metrics.isNotEmpty) 'metrics': metrics,
      'notif_channel_id': notifChannelId.toJson(),
      'send_hour': sendHour,
      'send_day_of_week': sendDayOfWeek.toJson(),
      'send_day_of_month': sendDayOfMonth.toJson(),
      'last_sent_at': lastSentAt.toJson(),
    };
  }
}

import 'package:octopusmanage/utils/parse_utils.dart';

class ReportHistory {
  final int id;
  final int scheduleId;
  final String scheduleName;
  final ReportType type;
  final String title;
  final String content;
  final report text
	SendStatus   string sendStatus;
  final / failed / skipped
	SendDetail   string sendDetail;
  final name or error message
	SentAt       int64 sentAt;

  ReportHistory({
    this.id = 0,
    this.scheduleId = 0,
    this.scheduleName = '',
    this.type = null,
    this.title = '',
    this.content = '',
    this.sendStatus = null,
    this.sendDetail = null,
    this.sentAt = null,
  });

  factory ReportHistory.fromJson(Map<String, dynamic> json) {
    return ReportHistory(
      id: parseInt(json['id']),
      scheduleId: parseInt(json['schedule_id']),
      scheduleName: parseString(json['schedule_name']),
      type: ReportType.fromJson(parseJsonMap(json['type'])),
      title: parseString(json['title']),
      content: parseString(json['content']),
      sendStatus: report text
	SendStatus   string.fromJson(parseJsonMap(json['send_status'])),
      sendDetail: / failed / skipped
	SendDetail   string.fromJson(parseJsonMap(json['send_detail'])),
      sentAt: name or error message
	SentAt       int64.fromJson(parseJsonMap(json['sent_at'])),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'schedule_id': scheduleId,
      if (scheduleName.isNotEmpty) 'schedule_name': scheduleName,
      'type': type.toJson(),
      if (title.isNotEmpty) 'title': title,
      if (content.isNotEmpty) 'content': content,
      'send_status': sendStatus.toJson(),
      'send_detail': sendDetail.toJson(),
      'sent_at': sentAt.toJson(),
    };
  }
}

