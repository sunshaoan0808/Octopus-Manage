import 'package:octopusmanage/utils/parse_utils.dart';

class AllAPIHubImportResult {
  final int createdSites;
  final int reusedSites;
  final int createdAccounts;
  final int updatedAccounts;
  final int skippedAccounts;
  final int scheduledSyncAccounts;
  final List<String> warnings;

  AllAPIHubImportResult({
    this.createdSites = 0,
    this.reusedSites = 0,
    this.createdAccounts = 0,
    this.updatedAccounts = 0,
    this.skippedAccounts = 0,
    this.scheduledSyncAccounts = 0,
    this.warnings = const [],
  });

  factory AllAPIHubImportResult.fromJson(Map<String, dynamic> json) {
    return AllAPIHubImportResult(
      createdSites: parseInt(json['created_sites']),
      reusedSites: parseInt(json['reused_sites']),
      createdAccounts: parseInt(json['created_accounts']),
      updatedAccounts: parseInt(json['updated_accounts']),
      skippedAccounts: parseInt(json['skipped_accounts']),
      scheduledSyncAccounts: parseInt(json['scheduled_sync_accounts']),
      warnings: parseJsonMapList(json['warnings']).map(String.fromJson).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'created_sites': createdSites,
      'reused_sites': reusedSites,
      'created_accounts': createdAccounts,
      'updated_accounts': updatedAccounts,
      'skipped_accounts': skippedAccounts,
      'scheduled_sync_accounts': scheduledSyncAccounts,
      'warnings': warnings.map((e) => e.toJson()).toList(),
    };
  }
}

import 'package:octopusmanage/utils/parse_utils.dart';

class MetAPIImportResult {
  final int createdSites;
  final int reusedSites;
  final int createdAccounts;
  final int updatedAccounts;
  final int skippedAccounts;
  final int importedTokens;
  final int importedGroups;
  final int importedModels;
  final int disabledModels;
  final List<String> warnings;

  MetAPIImportResult({
    this.createdSites = 0,
    this.reusedSites = 0,
    this.createdAccounts = 0,
    this.updatedAccounts = 0,
    this.skippedAccounts = 0,
    this.importedTokens = 0,
    this.importedGroups = 0,
    this.importedModels = 0,
    this.disabledModels = 0,
    this.warnings = const [],
  });

  factory MetAPIImportResult.fromJson(Map<String, dynamic> json) {
    return MetAPIImportResult(
      createdSites: parseInt(json['created_sites']),
      reusedSites: parseInt(json['reused_sites']),
      createdAccounts: parseInt(json['created_accounts']),
      updatedAccounts: parseInt(json['updated_accounts']),
      skippedAccounts: parseInt(json['skipped_accounts']),
      importedTokens: parseInt(json['imported_tokens']),
      importedGroups: parseInt(json['imported_groups']),
      importedModels: parseInt(json['imported_models']),
      disabledModels: parseInt(json['disabled_models']),
      warnings: parseJsonMapList(json['warnings']).map(String.fromJson).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'created_sites': createdSites,
      'reused_sites': reusedSites,
      'created_accounts': createdAccounts,
      'updated_accounts': updatedAccounts,
      'skipped_accounts': skippedAccounts,
      'imported_tokens': importedTokens,
      'imported_groups': importedGroups,
      'imported_models': importedModels,
      'disabled_models': disabledModels,
      'warnings': warnings.map((e) => e.toJson()).toList(),
    };
  }
}

