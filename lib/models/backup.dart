import 'package:octopusmanage/utils/parse_utils.dart';

class DBDump {
  final int version;
  final String exportedAt;
  final bool includeLogs;
  final bool includeStats;
  final List<Channel> channels;
  final List<ChannelKey> channelKeys;
  final List<ChannelGroup> channelGroups;
  final List<Group> groups;
  final List<GroupItem> groupItems;
  final List<LLMInfo> llmInfos;
  final List<APIKey> apiKeys;
  final List<User> users;
  final List<Setting> settings;
  final List<AlertRule> alertRules;
  final List<AlertNotifChannel> alertNotifChannels;
  final List<AlertStateRecord> alertStateRecords;
  final List<AlertHistory> alertHistory;
  final List<Notification> notifications;
  final List<NotificationDelivery> notificationDeliveries;
  final List<NotificationPreference> notificationPreferences;
  final List<NotificationPolicy> notificationPolicies;
  final List<AuditLog> auditLogs;
  final List<AutoStrategyState> runtimeStates;
  final List<CircuitBreakerState> circuitBreakerStates;
  final List<StatsTotal> statsTotal;
  final List<StatsDaily> statsDaily;
  final List<StatsHourly> statsHourly;
  final List<StatsModel> statsModel;
  final List<StatsChannel> statsChannel;
  final List<StatsAPIKey> statsApiKey;
  final List<RelayLog> relayLogs;
  final tables
	RemoteSites           []RemoteSite remoteSites;
  final List<BalanceSnapshot> balanceSnapshots;
  final List<CheckInRecord> checkInRecords;
  final List<APICredentialProfile> apiCredentialProfiles;
  final List<SiteAnnouncement> siteAnnouncements;
  final List<RemoteSiteToken> remoteSiteTokens;
  final tables (upstream platform multi-account management)
	Sites               []Site sites;
  final List<SiteAccount> siteAccounts;
  final List<SiteToken> siteTokens;
  final List<SiteUserGroup> siteUserGroups;
  final List<SiteModel> siteModels;
  final List<SiteChannelBinding> siteChannelBindings;

  DBDump({
    this.version = 0,
    this.exportedAt = '',
    this.includeLogs = false,
    this.includeStats = false,
    this.channels = const [],
    this.channelKeys = const [],
    this.channelGroups = const [],
    this.groups = const [],
    this.groupItems = const [],
    this.llmInfos = const [],
    this.apiKeys = const [],
    this.users = const [],
    this.settings = const [],
    this.alertRules = const [],
    this.alertNotifChannels = const [],
    this.alertStateRecords = const [],
    this.alertHistory = const [],
    this.notifications = const [],
    this.notificationDeliveries = const [],
    this.notificationPreferences = const [],
    this.notificationPolicies = const [],
    this.auditLogs = const [],
    this.runtimeStates = const [],
    this.circuitBreakerStates = const [],
    this.statsTotal = const [],
    this.statsDaily = const [],
    this.statsHourly = const [],
    this.statsModel = const [],
    this.statsChannel = const [],
    this.statsApiKey = const [],
    this.relayLogs = const [],
    this.remoteSites = null,
    this.balanceSnapshots = const [],
    this.checkInRecords = const [],
    this.apiCredentialProfiles = const [],
    this.siteAnnouncements = const [],
    this.remoteSiteTokens = const [],
    this.sites = null,
    this.siteAccounts = const [],
    this.siteTokens = const [],
    this.siteUserGroups = const [],
    this.siteModels = const [],
    this.siteChannelBindings = const [],
  });

  factory DBDump.fromJson(Map<String, dynamic> json) {
    return DBDump(
      version: parseInt(json['version']),
      exportedAt: parseString(json['exported_at']),
      includeLogs: parseBool(json['include_logs']),
      includeStats: parseBool(json['include_stats']),
      channels: parseJsonMapList(json['channels']).map(Channel.fromJson).toList(),
      channelKeys: parseJsonMapList(json['channel_keys']).map(ChannelKey.fromJson).toList(),
      channelGroups: parseJsonMapList(json['channel_groups']).map(ChannelGroup.fromJson).toList(),
      groups: parseJsonMapList(json['groups']).map(Group.fromJson).toList(),
      groupItems: parseJsonMapList(json['group_items']).map(GroupItem.fromJson).toList(),
      llmInfos: parseJsonMapList(json['llm_infos']).map(LLMInfo.fromJson).toList(),
      apiKeys: parseJsonMapList(json['api_keys']).map(APIKey.fromJson).toList(),
      users: parseJsonMapList(json['users']).map(User.fromJson).toList(),
      settings: parseJsonMapList(json['settings']).map(Setting.fromJson).toList(),
      alertRules: parseJsonMapList(json['alert_rules']).map(AlertRule.fromJson).toList(),
      alertNotifChannels: parseJsonMapList(json['alert_notif_channels']).map(AlertNotifChannel.fromJson).toList(),
      alertStateRecords: parseJsonMapList(json['alert_state_records']).map(AlertStateRecord.fromJson).toList(),
      alertHistory: parseJsonMapList(json['alert_history']).map(AlertHistory.fromJson).toList(),
      notifications: parseJsonMapList(json['notifications']).map(Notification.fromJson).toList(),
      notificationDeliveries: parseJsonMapList(json['notification_deliveries']).map(NotificationDelivery.fromJson).toList(),
      notificationPreferences: parseJsonMapList(json['notification_preferences']).map(NotificationPreference.fromJson).toList(),
      notificationPolicies: parseJsonMapList(json['notification_policies']).map(NotificationPolicy.fromJson).toList(),
      auditLogs: parseJsonMapList(json['audit_logs']).map(AuditLog.fromJson).toList(),
      runtimeStates: parseJsonMapList(json['runtime_states']).map(AutoStrategyState.fromJson).toList(),
      circuitBreakerStates: parseJsonMapList(json['circuit_breaker_states']).map(CircuitBreakerState.fromJson).toList(),
      statsTotal: parseJsonMapList(json['stats_total']).map(StatsTotal.fromJson).toList(),
      statsDaily: parseJsonMapList(json['stats_daily']).map(StatsDaily.fromJson).toList(),
      statsHourly: parseJsonMapList(json['stats_hourly']).map(StatsHourly.fromJson).toList(),
      statsModel: parseJsonMapList(json['stats_model']).map(StatsModel.fromJson).toList(),
      statsChannel: parseJsonMapList(json['stats_channel']).map(StatsChannel.fromJson).toList(),
      statsApiKey: parseJsonMapList(json['stats_api_key']).map(StatsAPIKey.fromJson).toList(),
      relayLogs: parseJsonMapList(json['relay_logs']).map(RelayLog.fromJson).toList(),
      remoteSites: tables
	RemoteSites           []RemoteSite.fromJson(parseJsonMap(json['remote_sites'])),
      balanceSnapshots: parseJsonMapList(json['balance_snapshots']).map(BalanceSnapshot.fromJson).toList(),
      checkInRecords: parseJsonMapList(json['check_in_records']).map(CheckInRecord.fromJson).toList(),
      apiCredentialProfiles: parseJsonMapList(json['api_credential_profiles']).map(APICredentialProfile.fromJson).toList(),
      siteAnnouncements: parseJsonMapList(json['site_announcements']).map(SiteAnnouncement.fromJson).toList(),
      remoteSiteTokens: parseJsonMapList(json['remote_site_tokens']).map(RemoteSiteToken.fromJson).toList(),
      sites: tables (upstream platform multi-account management)
	Sites               []Site.fromJson(parseJsonMap(json['sites'])),
      siteAccounts: parseJsonMapList(json['site_accounts']).map(SiteAccount.fromJson).toList(),
      siteTokens: parseJsonMapList(json['site_tokens']).map(SiteToken.fromJson).toList(),
      siteUserGroups: parseJsonMapList(json['site_user_groups']).map(SiteUserGroup.fromJson).toList(),
      siteModels: parseJsonMapList(json['site_models']).map(SiteModel.fromJson).toList(),
      siteChannelBindings: parseJsonMapList(json['site_channel_bindings']).map(SiteChannelBinding.fromJson).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'version': version,
      if (exportedAt.isNotEmpty) 'exported_at': exportedAt,
      'include_logs': includeLogs,
      'include_stats': includeStats,
      'channels': channels.map((e) => e.toJson()).toList(),
      'channel_keys': channelKeys.map((e) => e.toJson()).toList(),
      'channel_groups': channelGroups.map((e) => e.toJson()).toList(),
      'groups': groups.map((e) => e.toJson()).toList(),
      'group_items': groupItems.map((e) => e.toJson()).toList(),
      'llm_infos': llmInfos.map((e) => e.toJson()).toList(),
      'api_keys': apiKeys.map((e) => e.toJson()).toList(),
      'users': users.map((e) => e.toJson()).toList(),
      'settings': settings.map((e) => e.toJson()).toList(),
      'alert_rules': alertRules.map((e) => e.toJson()).toList(),
      'alert_notif_channels': alertNotifChannels.map((e) => e.toJson()).toList(),
      'alert_state_records': alertStateRecords.map((e) => e.toJson()).toList(),
      'alert_history': alertHistory.map((e) => e.toJson()).toList(),
      'notifications': notifications.map((e) => e.toJson()).toList(),
      'notification_deliveries': notificationDeliveries.map((e) => e.toJson()).toList(),
      'notification_preferences': notificationPreferences.map((e) => e.toJson()).toList(),
      'notification_policies': notificationPolicies.map((e) => e.toJson()).toList(),
      'audit_logs': auditLogs.map((e) => e.toJson()).toList(),
      'runtime_states': runtimeStates.map((e) => e.toJson()).toList(),
      'circuit_breaker_states': circuitBreakerStates.map((e) => e.toJson()).toList(),
      'stats_total': statsTotal.map((e) => e.toJson()).toList(),
      'stats_daily': statsDaily.map((e) => e.toJson()).toList(),
      'stats_hourly': statsHourly.map((e) => e.toJson()).toList(),
      'stats_model': statsModel.map((e) => e.toJson()).toList(),
      'stats_channel': statsChannel.map((e) => e.toJson()).toList(),
      'stats_api_key': statsApiKey.map((e) => e.toJson()).toList(),
      'relay_logs': relayLogs.map((e) => e.toJson()).toList(),
      'remote_sites': remoteSites.toJson(),
      'balance_snapshots': balanceSnapshots.map((e) => e.toJson()).toList(),
      'check_in_records': checkInRecords.map((e) => e.toJson()).toList(),
      'api_credential_profiles': apiCredentialProfiles.map((e) => e.toJson()).toList(),
      'site_announcements': siteAnnouncements.map((e) => e.toJson()).toList(),
      'remote_site_tokens': remoteSiteTokens.map((e) => e.toJson()).toList(),
      'sites': sites.toJson(),
      'site_accounts': siteAccounts.map((e) => e.toJson()).toList(),
      'site_tokens': siteTokens.map((e) => e.toJson()).toList(),
      'site_user_groups': siteUserGroups.map((e) => e.toJson()).toList(),
      'site_models': siteModels.map((e) => e.toJson()).toList(),
      'site_channel_bindings': siteChannelBindings.map((e) => e.toJson()).toList(),
    };
  }
}

import 'package:octopusmanage/utils/parse_utils.dart';

class DBImportResult {
  final contains the rows affected for each table.
	RowsAffected map[string]int64 rowsAffected;
  final List<DBImportStep> progress;

  DBImportResult({
    this.rowsAffected = null,
    this.progress = const [],
  });

  factory DBImportResult.fromJson(Map<String, dynamic> json) {
    return DBImportResult(
      rowsAffected: contains the rows affected for each table.
	RowsAffected map[string]int64.fromJson(parseJsonMap(json['rows_affected'])),
      progress: parseJsonMapList(json['progress']).map(DBImportStep.fromJson).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'rows_affected': rowsAffected.toJson(),
      'progress': progress.map((e) => e.toJson()).toList(),
    };
  }
}

import 'package:octopusmanage/utils/parse_utils.dart';

class DBImportStep {
  final String table;
  final String mode;
  final "insert"
	RowsAffected int64 rowsAffected;
  final bool ok;
  final String error;

  DBImportStep({
    this.table = '',
    this.mode = '',
    this.rowsAffected = null,
    this.ok = false,
    this.error = '',
  });

  factory DBImportStep.fromJson(Map<String, dynamic> json) {
    return DBImportStep(
      table: parseString(json['table']),
      mode: parseString(json['mode']),
      rowsAffected: "insert"
	RowsAffected int64.fromJson(parseJsonMap(json['rows_affected'])),
      ok: parseBool(json['ok']),
      error: parseString(json['error']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (table.isNotEmpty) 'table': table,
      if (mode.isNotEmpty) 'mode': mode,
      'rows_affected': rowsAffected.toJson(),
      'ok': ok,
      if (error.isNotEmpty) 'error': error,
    };
  }
}

import 'package:octopusmanage/utils/parse_utils.dart';

class DatabaseMigrationRequest {
  final String type;
  final String path;
  final bool includeLogs;
  final bool includeStats;

  DatabaseMigrationRequest({
    this.type = '',
    this.path = '',
    this.includeLogs = false,
    this.includeStats = false,
  });

  factory DatabaseMigrationRequest.fromJson(Map<String, dynamic> json) {
    return DatabaseMigrationRequest(
      type: parseString(json['type']),
      path: parseString(json['path']),
      includeLogs: parseBool(json['include_logs']),
      includeStats: parseBool(json['include_stats']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (type.isNotEmpty) 'type': type,
      if (path.isNotEmpty) 'path': path,
      'include_logs': includeLogs,
      'include_stats': includeStats,
    };
  }
}

import 'package:octopusmanage/utils/parse_utils.dart';

class DatabaseMigrationResult {
  final String type;
  final String path;
  final bool includeLogs;
  final bool includeStats;
  final bool restartNeeded;
  final 迁移成功后已删除的旧 SQLite 文件路径（issue #118）。
	// 仅当源库为 SQLite、目标库为非 SQLite 时非空。
	CleanedFiles []string cleanedFiles;
  final DBImportResult importResult;

  DatabaseMigrationResult({
    this.type = '',
    this.path = '',
    this.includeLogs = false,
    this.includeStats = false,
    this.restartNeeded = false,
    this.cleanedFiles = null,
    this.importResult = null,
  });

  factory DatabaseMigrationResult.fromJson(Map<String, dynamic> json) {
    return DatabaseMigrationResult(
      type: parseString(json['type']),
      path: parseString(json['path']),
      includeLogs: parseBool(json['include_logs']),
      includeStats: parseBool(json['include_stats']),
      restartNeeded: parseBool(json['restart_needed']),
      cleanedFiles: 迁移成功后已删除的旧 SQLite 文件路径（issue #118）。
	// 仅当源库为 SQLite、目标库为非 SQLite 时非空。
	CleanedFiles []string.fromJson(parseJsonMap(json['cleaned_files'])),
      importResult: DBImportResult.fromJson(parseJsonMap(json['import_result'])),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (type.isNotEmpty) 'type': type,
      if (path.isNotEmpty) 'path': path,
      'include_logs': includeLogs,
      'include_stats': includeStats,
      'restart_needed': restartNeeded,
      'cleaned_files': cleanedFiles.toJson(),
      'import_result': importResult.toJson(),
    };
  }
}

import 'package:octopusmanage/utils/parse_utils.dart';

class CacheConfig {
  final String type;
  final CacheRedisConfig redis;

  CacheConfig({
    this.type = '',
    this.redis = null,
  });

  factory CacheConfig.fromJson(Map<String, dynamic> json) {
    return CacheConfig(
      type: parseString(json['type']),
      redis: CacheRedisConfig.fromJson(parseJsonMap(json['redis'])),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (type.isNotEmpty) 'type': type,
      'redis': redis.toJson(),
    };
  }
}

import 'package:octopusmanage/utils/parse_utils.dart';

class CacheRedisConfig {
  final String addr;
  final String password;
  final String username;
  final int db;
  final int poolSize;
  final String dialTimeout;
  final String readTimeout;

  CacheRedisConfig({
    this.addr = '',
    this.password = '',
    this.username = '',
    this.db = 0,
    this.poolSize = 0,
    this.dialTimeout = '',
    this.readTimeout = '',
  });

  factory CacheRedisConfig.fromJson(Map<String, dynamic> json) {
    return CacheRedisConfig(
      addr: parseString(json['addr']),
      password: parseString(json['password']),
      username: parseString(json['username']),
      db: parseInt(json['db']),
      poolSize: parseInt(json['pool_size']),
      dialTimeout: parseString(json['dial_timeout']),
      readTimeout: parseString(json['read_timeout']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (addr.isNotEmpty) 'addr': addr,
      if (password.isNotEmpty) 'password': password,
      if (username.isNotEmpty) 'username': username,
      'db': db,
      'pool_size': poolSize,
      if (dialTimeout.isNotEmpty) 'dial_timeout': dialTimeout,
      if (readTimeout.isNotEmpty) 'read_timeout': readTimeout,
    };
  }
}

import 'package:octopusmanage/utils/parse_utils.dart';

class CacheConfigRequest {
  final String type;
  final CacheRedisConfig redis;

  CacheConfigRequest({
    this.type = '',
    this.redis = null,
  });

  factory CacheConfigRequest.fromJson(Map<String, dynamic> json) {
    return CacheConfigRequest(
      type: parseString(json['type']),
      redis: CacheRedisConfig.fromJson(parseJsonMap(json['redis'])),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (type.isNotEmpty) 'type': type,
      'redis': redis.toJson(),
    };
  }
}

import 'package:octopusmanage/utils/parse_utils.dart';

class CacheConfigResult {
  final String type;
  final bool restartNeeded;

  CacheConfigResult({
    this.type = '',
    this.restartNeeded = false,
  });

  factory CacheConfigResult.fromJson(Map<String, dynamic> json) {
    return CacheConfigResult(
      type: parseString(json['type']),
      restartNeeded: parseBool(json['restart_needed']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (type.isNotEmpty) 'type': type,
      'restart_needed': restartNeeded,
    };
  }
}

