import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:octopusmanage/models/ops.dart';
import 'package:octopusmanage/providers/app_provider.dart';
import 'package:octopusmanage/theme/app_theme.dart';
import 'package:octopusmanage/widgets/app_card.dart';
import 'package:octopusmanage/widgets/app_chips.dart';
import 'package:octopusmanage/widgets/app_empty_state.dart';
import 'package:octopusmanage/widgets/app_error_dialog.dart';
import 'package:provider/provider.dart';

class OpsPage extends StatefulWidget {
  const OpsPage({super.key});

  @override
  State<OpsPage> createState() => _OpsPageState();
}

class _OpsPageState extends State<OpsPage> {
  OpsSystemSummary? _system;
  OpsCacheStatus? _cache;
  OpsHealthStatus? _health;
  OpsQuotaSummary? _quota;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadAll();
  }

  Future<void> _loadAll() async {
    if (!mounted) return;
    setState(() => _loading = true);
    try {
      final api = context.read<AppProvider>().api;
      final results = await Future.wait([
        api.getOpsSystem(),
        api.getOpsCache(),
        api.getOpsHealth(),
        api.getOpsQuota(),
      ]);
      if (mounted) {
        _system = results[0] as OpsSystemSummary;
        _cache = results[1] as OpsCacheStatus;
        _health = results[2] as OpsHealthStatus;
        _quota = results[3] as OpsQuotaSummary;
      }
    } catch (e) {
      if (mounted) {
        showErrorDialog(context, e.toString());
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Widget _statusIcon(bool ok) {
    return Icon(
      ok ? CupertinoIcons.checkmark_circle_fill : CupertinoIcons.xmark_circle_fill,
      size: 16,
      color: ok ? AppTheme.colorGreen : AppTheme.colorRed,
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = context.watch<AppProvider>().loc;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return CupertinoPageScaffold(
      backgroundColor: AppTheme.getSurfaceLowest(colorScheme),
      child: SafeArea(
        bottom: false,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          slivers: [
            CupertinoSliverNavigationBar(
              largeTitle: Text(loc.t('ops')),
              backgroundColor: AppTheme.getSurfaceLowest(colorScheme)
                  .withValues(alpha: 0.85),
              border: null,
            ),
            CupertinoSliverRefreshControl(onRefresh: _loadAll),
            if (_loading)
              const SliverFillRemaining(
                hasScrollBody: false,
                child: AppLoadingState(),
              )
            else ...[
              // System Card
              SliverToBoxAdapter(
                child: AppCard(
                  margin: const EdgeInsets.fromLTRB(
                    AppTheme.spacingLg, AppTheme.spacingSm,
                    AppTheme.spacingLg, 0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(loc.t('ops_system'),
                        style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600,
                          color: colorScheme.onSurface)),
                      const SizedBox(height: AppTheme.spacingMd),
                      _infoRow(loc.t('server_version'), _system?.version ?? '-'),
                      _infoRow(loc.t('database_type'), _system?.databaseType ?? '-'),
                      _infoRow(loc.t('channels'), '${_system?.channelCount ?? 0}'),
                      _infoRow(loc.t('groups'), '${_system?.groupCount ?? 0}'),
                      _infoRow(loc.t('api_keys'), '${_system?.apiKeyCount ?? 0}'),
                      if ((_system?.proxyURL ?? '').isNotEmpty)
                        _infoRow(loc.t('setting_proxy_url'), _system!.proxyURL),
                      _infoRow(loc.t('ops_build_time'), _system?.buildTime ?? '-'),
                    ],
                  ),
                ),
              ),
              // Health Card
              SliverToBoxAdapter(
                child: AppCard(
                  margin: const EdgeInsets.fromLTRB(
                    AppTheme.spacingLg, AppTheme.spacingMd,
                    AppTheme.spacingLg, 0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(loc.t('ops_health'),
                        style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600,
                          color: colorScheme.onSurface)),
                      const SizedBox(height: AppTheme.spacingMd),
                      Row(children: [
                        _statusIcon(_health?.databaseOK ?? false),
                        const SizedBox(width: 8),
                        Text(loc.t('ops_db_status')),
                        const Spacer(),
                        Text(_health?.databaseOK == true ? loc.t('ops_ok') : loc.t('ops_fail'),
                          style: TextStyle(color: _health?.databaseOK == true
                            ? AppTheme.colorGreen : AppTheme.colorRed)),
                      ]),
                      const SizedBox(height: AppTheme.spacingSm),
                      Row(children: [
                        _statusIcon(_health?.cacheOK ?? false),
                        const SizedBox(width: 8),
                        Text(loc.t('ops_cache_status')),
                        const Spacer(),
                        Text(_health?.cacheOK == true ? loc.t('ops_ok') : loc.t('ops_fail'),
                          style: TextStyle(color: _health?.cacheOK == true
                            ? AppTheme.colorGreen : AppTheme.colorRed)),
                      ]),
                      const SizedBox(height: AppTheme.spacingSm),
                      Row(children: [
                        _statusIcon(_health?.taskRuntimeOK ?? false),
                        const SizedBox(width: 8),
                        Text(loc.t('ops_task_status')),
                        const Spacer(),
                        Text(_health?.taskRuntimeOK == true ? loc.t('ops_ok') : loc.t('ops_fail'),
                          style: TextStyle(color: _health?.taskRuntimeOK == true
                            ? AppTheme.colorGreen : AppTheme.colorRed)),
                      ]),
                      const SizedBox(height: AppTheme.spacingMd),
                      _infoRow(loc.t('ops_healthy_groups'), '${_health?.healthyGroupCount ?? 0}'),
                      _infoRow(loc.t('ops_warning_groups'), '${_health?.warningGroupCount ?? 0}'),
                      _infoRow(loc.t('ops_degraded_groups'), '${_health?.degradedGroupCount ?? 0}'),
                      _infoRow(loc.t('ops_down_groups'), '${_health?.downGroupCount ?? 0}'),
                      _infoRow(loc.t('ops_empty_groups'), '${_health?.emptyGroupCount ?? 0}'),
                    ],
                  ),
                ),
              ),
              // Cache Card
              SliverToBoxAdapter(
                child: AppCard(
                  margin: const EdgeInsets.fromLTRB(
                    AppTheme.spacingLg, AppTheme.spacingMd,
                    AppTheme.spacingLg, 0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        Text(loc.t('ops_cache'),
                          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600,
                            color: colorScheme.onSurface)),
                        const Spacer(),
                        AppInfoChip(
                          icon: _cache?.runtimeEnabled == true
                            ? CupertinoIcons.checkmark_circle
                            : CupertinoIcons.xmark_circle,
                          label: _cache?.runtimeEnabled == true
                            ? loc.t('enabled') : loc.t('disabled'),
                        ),
                      ]),
                      const SizedBox(height: AppTheme.spacingMd),
                      _infoRow(loc.t('ops_cache_entries'),
                        '${_cache?.currentEntries ?? 0} / ${_cache?.maxEntries ?? 0}'),
                      _infoRow(loc.t('ops_cache_hits'), '${_cache?.hits ?? 0}'),
                      _infoRow(loc.t('ops_cache_misses'), '${_cache?.misses ?? 0}'),
                      _infoRow(loc.t('ops_cache_hit_rate'),
                        '${(_cache?.hitRate ?? 0).toStringAsFixed(1)}%'),
                      _infoRow(loc.t('ops_cache_usage_rate'),
                        '${(_cache?.usageRate ?? 0).toStringAsFixed(1)}%'),
                    ],
                  ),
                ),
              ),
              // Quota Card
              SliverToBoxAdapter(
                child: AppCard(
                  margin: const EdgeInsets.fromLTRB(
                    AppTheme.spacingLg, AppTheme.spacingMd,
                    AppTheme.spacingLg, AppTheme.spacingMd,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(loc.t('ops_quota'),
                        style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600,
                          color: colorScheme.onSurface)),
                      const SizedBox(height: AppTheme.spacingMd),
                      _infoRow(loc.t('ops_total_keys'), '${_quota?.totalKeyCount ?? 0}'),
                      _infoRow(loc.t('ops_enabled_keys'), '${_quota?.enabledKeyCount ?? 0}'),
                      _infoRow(loc.t('ops_available_keys'), '${_quota?.availableKeyCount ?? 0}'),
                      _infoRow(loc.t('ops_expired_keys'), '${_quota?.expiredKeyCount ?? 0}'),
                      _infoRow(loc.t('ops_limited_keys'), '${_quota?.limitedKeyCount ?? 0}'),
                      _infoRow(loc.t('ops_exhausted_keys'), '${_quota?.exhaustedKeyCount ?? 0}'),
                      _infoRow(loc.t('ops_total_rpm'), '${_quota?.totalRPM ?? 0}'),
                      _infoRow(loc.t('ops_total_tpm'), '${_quota?.totalTPM ?? 0}'),
                    ],
                  ),
                ),
              ),
              const SliverPadding(padding: EdgeInsets.only(bottom: 32)),
            ],
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: AppTheme.spacingSm),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(label,
              style: TextStyle(fontSize: 14, color: theme.colorScheme.onSurfaceVariant)),
          ),
          Expanded(
            flex: 3,
            child: Text(value,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500,
                color: theme.colorScheme.onSurface)),
          ),
        ],
      ),
    );
  }
}
