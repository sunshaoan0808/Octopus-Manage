import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:octopusmanage/l10n/app_localizations.dart';
import 'package:octopusmanage/models/analytics.dart';
import 'package:octopusmanage/providers/app_provider.dart';
import 'package:octopusmanage/theme/app_theme.dart';
import 'package:octopusmanage/widgets/app_card.dart';
import 'package:octopusmanage/widgets/app_empty_state.dart';
import 'package:octopusmanage/widgets/app_error_dialog.dart';
import 'package:octopusmanage/widgets/app_list_tile.dart';
import 'package:provider/provider.dart';

class AnalyticsPage extends StatefulWidget {
  const AnalyticsPage({super.key});

  @override
  State<AnalyticsPage> createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends State<AnalyticsPage> {
  int _tab = 0;
  String _range = '7d';
  AnalyticsOverview? _overview;
  List<AnalyticsBreakdownItem> _providers = [];
  List<AnalyticsBreakdownItem> _models = [];
  List<AnalyticsBreakdownItem> _apiKeys = [];
  List<AnalyticsGroupHealthItem> _groupHealth = [];
  List<AnalyticsChannelModelItem> _channelModelItems = [];
  AnalyticsLatencyDistribution? _latencyDistribution;
  List<AutoStrategySnapshotItem> _autoStrategyItems = [];
  AnalyticsEvaluationSummary? _evaluation;
  int _usageSubTab = 0;
  bool _loading = true;

  static const _ranges = ['1d', '7d', '30d', '90d'];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    if (!mounted) return;
    setState(() => _loading = true);
    try {
      final api = context.read<AppProvider>().api;
      final results = await Future.wait([
        api.getAnalyticsOverview(range: _range),
        api.getAnalyticsProviderBreakdown(range: _range),
        api.getAnalyticsModelBreakdown(range: _range),
        api.getAnalyticsApiKeyBreakdown(range: _range),
        api.getAnalyticsGroupHealth(),
        api.getAnalyticsChannelModel(range: _range),
        api.getAnalyticsLatencyDistribution(range: _range),
        api.getAnalyticsAutoStrategy(),
        api.getAnalyticsEvaluation(),
      ]);
      if (mounted) {
        _overview = results[0] as AnalyticsOverview;
        _providers = results[1] as List<AnalyticsBreakdownItem>;
        _models = results[2] as List<AnalyticsBreakdownItem>;
        _apiKeys = results[3] as List<AnalyticsBreakdownItem>;
        _groupHealth = results[4] as List<AnalyticsGroupHealthItem>;
        _channelModelItems = results[5] as List<AnalyticsChannelModelItem>;
        _latencyDistribution = results[6] as AnalyticsLatencyDistribution;
        _autoStrategyItems = results[7] as List<AutoStrategySnapshotItem>;
        _evaluation = results[8] as AnalyticsEvaluationSummary;
      }
    } catch (e) {
      if (mounted) showErrorDialog(context, e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  String _fmtCount(int n) {
    if (n >= 1000000) return '${(n / 1000000).toStringAsFixed(1)}M';
    if (n >= 1000) return '${(n / 1000).toStringAsFixed(1)}K';
    return n.toString();
  }

  String _fmtCost(double c) {
    if (c >= 100) return '\$${c.toStringAsFixed(0)}';
    if (c >= 1) return '\$${c.toStringAsFixed(1)}';
    if (c > 0) return '\$${c.toStringAsFixed(3)}';
    return '\$0';
  }

  String _fmtLatency(double ms) {
    if (ms >= 1000) return '${(ms / 1000).toStringAsFixed(2)}s';
    return '${ms.toStringAsFixed(0)}ms';
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
          physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
          slivers: [
            CupertinoSliverNavigationBar(
              largeTitle: Text(loc.t('analytics')),
              backgroundColor: AppTheme.getSurfaceLowest(colorScheme).withValues(alpha: 0.85),
              border: null,
            ),
            CupertinoSliverRefreshControl(onRefresh: _load),
            SliverPersistentHeader(
              pinned: true,
              delegate: _RangeHeaderDelegate(
                child: Container(
                  color: AppTheme.getSurfaceLowest(colorScheme),
                  padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingLg, vertical: 4),
                  child: Row(
                    children: [
                      Text(loc.t('analytics_range'), style: const TextStyle(fontSize: 13)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: CupertinoSlidingSegmentedControl<String>(
                          groupValue: _range,
                          onValueChanged: (v) {
                            setState(() => _range = v ?? _range);
                            _load();
                          },
                          children: {
                            for (final r in _ranges)
                              r: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
                                child: Text(loc.t('analytics_range_$r'), style: const TextStyle(fontSize: 11)),
                              ),
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (_loading)
              const SliverFillRemaining(hasScrollBody: false, child: AppLoadingState())
            else ...[
              // Overview Card
              SliverToBoxAdapter(
                child: AppCard(
                  margin: const EdgeInsets.fromLTRB(AppTheme.spacingLg, AppTheme.spacingSm, AppTheme.spacingLg, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(loc.t('overview'), style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: colorScheme.onSurface)),
                      const SizedBox(height: AppTheme.spacingMd),
                      _metricRow(loc, _overview?.metrics.requestCount ?? 0, _fmtCost(_overview?.metrics.totalCost ?? 0),
                        _overview?.metrics.totalTokens ?? 0, _overview?.metrics.successRate ?? 0),
                    ],
                  ),
                ),
              ),
              // 6-tab segmented control
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(AppTheme.spacingLg, AppTheme.spacingMd, AppTheme.spacingLg, 0),
                  child: CupertinoSegmentedControl<int>(
                    groupValue: _tab,
                    onValueChanged: (v) => setState(() => _tab = v),
                    children: {
                      0: Padding(padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8), child: Text(loc.t('analytics_channel_model'), style: const TextStyle(fontSize: 11))),
                      1: Padding(padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8), child: Text(loc.t('analytics_providers'), style: const TextStyle(fontSize: 11))),
                      2: Padding(padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8), child: Text(loc.t('analytics_route_health'), style: const TextStyle(fontSize: 11))),
                      3: Padding(padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8), child: Text(loc.t('analytics_latency'), style: const TextStyle(fontSize: 11))),
                      4: Padding(padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8), child: Text(loc.t('analytics_evaluation'), style: const TextStyle(fontSize: 11))),
                      5: Padding(padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8), child: Text(loc.t('analytics_cache'), style: const TextStyle(fontSize: 11))),
                    },
                  ),
                ),
              ),
              // Tab content
              if (_tab == 0) _buildChannelModelTab(),
              if (_tab == 1) _buildUsageTab(),
              if (_tab == 2) _buildRouteHealthTab(),
              if (_tab == 3) _buildLatencyTab(),
              if (_tab == 4) _buildEvaluationTab(),
              if (_tab == 5) _buildCacheTab(),
              const SliverPadding(padding: EdgeInsets.only(bottom: 32)),
            ],
          ],
        ),
      ),
    );
  }

  // ── Tab 0: Channel×Model matrix ──
  Widget _buildChannelModelTab() {
    final loc = context.read<AppProvider>().loc;
    if (_channelModelItems.isEmpty) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: AppEmptyState(icon: CupertinoIcons.chart_bar, title: loc.t('no_data')),
      );
    }
    return SliverList(
      delegate: SliverChildBuilderDelegate((ctx, i) {
        final item = _channelModelItems[i];
        final cs = Theme.of(context).colorScheme;
        return AppListTile(
          margin: const EdgeInsets.fromLTRB(AppTheme.spacingLg, 2, AppTheme.spacingLg, 0),
          title: Row(children: [
            Expanded(child: Text('${item.channelName} → ${item.modelName}',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: cs.onSurface))),
          ]),
          subtitle: Row(children: [
            Text('${_fmtCount(item.requestCount)} req', style: TextStyle(fontSize: 12, color: cs.onSurfaceVariant)),
            const SizedBox(width: 8),
            Text(_fmtLatency(item.avgLatency), style: TextStyle(fontSize: 12, color: cs.onSurfaceVariant)),
            const SizedBox(width: 8),
            Text('${item.successRate.toStringAsFixed(1)}%', style: TextStyle(fontSize: 12,
              color: item.successRate >= 95 ? AppTheme.colorGreen : AppTheme.colorOrange)),
          ]),
        );
      }, childCount: _channelModelItems.length),
    );
  }

  // ── Tab 1: Usage breakdown (existing Providers/Models/APIKeys) ──
  Widget _buildUsageTab() {
    final loc = context.read<AppProvider>().loc;
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(AppTheme.spacingLg, AppTheme.spacingSm, AppTheme.spacingLg, 0),
            child: CupertinoSlidingSegmentedControl<int>(
              groupValue: _usageSubTab,
              onValueChanged: (v) => setState(() => _usageSubTab = v ?? 0),
              children: {
                0: Padding(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6), child: Text(loc.t('analytics_providers'), style: const TextStyle(fontSize: 11))),
                1: Padding(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6), child: Text(loc.t('analytics_models'), style: const TextStyle(fontSize: 11))),
                2: Padding(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6), child: Text(loc.t('api_keys'), style: const TextStyle(fontSize: 11))),
              },
            ),
          ),
          if (_usageSubTab == 0) _buildBreakdownColumn(_providers.map((p) => (p.channelName, p.enabled, p.metrics)).toList()),
          if (_usageSubTab == 1) _buildBreakdownColumn(_models.map((m) => (m.modelName, true, m.metrics)).toList()),
          if (_usageSubTab == 2) _buildBreakdownColumn(_apiKeys.map((k) => (k.name.isNotEmpty ? k.name : 'Key #${k.apiKeyId}', true, k.metrics)).toList()),
        ],
      ),
    );
  }

  Widget _buildBreakdownColumn(List<(String, bool, AnalyticsMetrics)> items) {
    final loc = context.read<AppProvider>().loc;
    if (items.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 48),
        child: AppEmptyState(icon: CupertinoIcons.chart_bar, title: loc.t('no_data')),
      );
    }
    return Column(
      children: List.generate(items.length, (i) {
        final (name, enabled, metrics) = items[i];
        final cs = Theme.of(context).colorScheme;
        return AppListTile(
          margin: const EdgeInsets.fromLTRB(AppTheme.spacingLg, 2, AppTheme.spacingLg, 0),
          title: Row(children: [
            if (!enabled)
              Padding(padding: const EdgeInsets.only(right: 6),
                child: Icon(CupertinoIcons.xmark_circle, size: 14, color: cs.error)),
            Expanded(child: Text(name, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: cs.onSurface))),
          ]),
          subtitle: Row(children: [
            Text('${_fmtCount(metrics.requestCount)} req', style: TextStyle(fontSize: 12, color: cs.onSurfaceVariant)),
            const SizedBox(width: 8),
            Text(_fmtCost(metrics.totalCost), style: TextStyle(fontSize: 12, color: cs.onSurfaceVariant)),
            const SizedBox(width: 8),
            Text('${metrics.successRate.toStringAsFixed(1)}%', style: TextStyle(fontSize: 12,
              color: metrics.successRate >= 95 ? AppTheme.colorGreen : AppTheme.colorOrange)),
          ]),
        );
      }),
    );
  }

  // ── Tab 2: Route Health (existing group health + auto strategy) ──
  Widget _buildRouteHealthTab() {
    final loc = context.read<AppProvider>().loc;
    final cs = Theme.of(context).colorScheme;
    if (_groupHealth.isEmpty) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: AppEmptyState(icon: CupertinoIcons.heart, title: loc.t('no_data')),
      );
    }
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ..._groupHealth.map((g) => AppCard(
            margin: const EdgeInsets.fromLTRB(AppTheme.spacingLg, AppTheme.spacingSm, AppTheme.spacingLg, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Icon(g.status == 'healthy' ? CupertinoIcons.checkmark_circle_fill : CupertinoIcons.exclamationmark_circle_fill,
                    size: 16, color: g.status == 'healthy' ? AppTheme.colorGreen : AppTheme.colorOrange),
                  const SizedBox(width: 6),
                  Expanded(child: Text(g.groupName, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: cs.onSurface))),
                  Text('${g.healthScore}%', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15,
                    color: g.healthScore >= 80 ? AppTheme.colorGreen : AppTheme.colorOrange)),
                ]),
                if (g.mode.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text('${loc.t('mode')}: ${g.mode}', style: TextStyle(fontSize: 12, color: cs.onSurfaceVariant)),
                ],
                if (g.failingChannels.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text('${loc.t('analytics_failing_channels')}: ${g.failingChannels.join(', ')}',
                    style: TextStyle(fontSize: 12, color: cs.error)),
                ],
                if (g.autoItems.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(loc.t('analytics_auto_strategy'), style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: cs.onSurface)),
                  ...g.autoItems.map((a) => Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Row(children: [
                      Expanded(child: Text(a.model, style: TextStyle(fontSize: 12, color: cs.onSurfaceVariant))),
                      Text(a.bestChannel, style: TextStyle(fontSize: 12, color: cs.onSurfaceVariant)),
                      const SizedBox(width: 8),
                      Text(a.reason, style: TextStyle(fontSize: 11, color: cs.onSurfaceVariant)),
                    ]),
                  )),
                ],
              ],
            ),
          )),
          // Global auto strategy snapshot
          if (_autoStrategyItems.isNotEmpty)
            AppCard(
              margin: const EdgeInsets.fromLTRB(AppTheme.spacingLg, AppTheme.spacingSm, AppTheme.spacingLg, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(loc.t('analytics_auto_strategy'), style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: cs.onSurface)),
                  const SizedBox(height: AppTheme.spacingSm),
                  ..._autoStrategyItems.map((a) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(children: [
                      Expanded(child: Text(a.model, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: cs.onSurface))),
                      Text(a.bestChannel, style: TextStyle(fontSize: 12, color: AppTheme.colorBlue)),
                      const SizedBox(width: 8),
                      Text(a.reason, style: TextStyle(fontSize: 11, color: cs.onSurfaceVariant)),
                    ]),
                  )),
                ],
              ),
            ),
        ],
      ),
    );
  }

  // ── Tab 3: Latency distribution ──
  Widget _buildLatencyTab() {
    final loc = context.read<AppProvider>().loc;
    final cs = Theme.of(context).colorScheme;
    final dist = _latencyDistribution;
    if (dist == null || dist.buckets.isEmpty) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: AppEmptyState(icon: CupertinoIcons.clock, title: loc.t('no_data')),
      );
    }

    final maxCount = dist.buckets.fold<int>(0, (m, b) => b.count > m ? b.count : m);

    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Percentile summary card
          AppCard(
            margin: const EdgeInsets.fromLTRB(AppTheme.spacingLg, AppTheme.spacingSm, AppTheme.spacingLg, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(loc.t('analytics_latency'), style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: cs.onSurface)),
                const SizedBox(height: AppTheme.spacingMd),
                Row(children: [
                  _metricBox(loc.t('analytics_p50'), _fmtLatency(dist.p50)),
                  _metricBox(loc.t('analytics_p95'), _fmtLatency(dist.p95)),
                  _metricBox(loc.t('analytics_p99'), _fmtLatency(dist.p99)),
                ]),
              ],
            ),
          ),
          // Histogram
          AppCard(
            margin: const EdgeInsets.fromLTRB(AppTheme.spacingLg, AppTheme.spacingSm, AppTheme.spacingLg, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(loc.t('analytics_distribution'), style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: cs.onSurface)),
                const SizedBox(height: AppTheme.spacingSm),
                ...dist.buckets.map((b) {
                  final ratio = maxCount > 0 ? b.count / maxCount : 0.0;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Row(children: [
                      SizedBox(width: 70, child: Text(b.bucketLabel, style: TextStyle(fontSize: 12, color: cs.onSurfaceVariant))),
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: ratio,
                            minHeight: 14,
                            backgroundColor: cs.surfaceContainerHighest,
                            valueColor: AlwaysStoppedAnimation<Color>(AppTheme.colorBlue),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      SizedBox(width: 48, child: Text(_fmtCount(b.count), style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: cs.onSurface), textAlign: TextAlign.right)),
                    ]),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Tab 4: Evaluation ──
  Widget _buildEvaluationTab() {
    final loc = context.read<AppProvider>().loc;
    final cs = Theme.of(context).colorScheme;
    final ev = _evaluation;
    if (ev == null) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: AppEmptyState(icon: CupertinoIcons.checkmark_seal, title: loc.t('no_data')),
      );
    }
    return SliverToBoxAdapter(
      child: AppCard(
        margin: const EdgeInsets.fromLTRB(AppTheme.spacingLg, AppTheme.spacingSm, AppTheme.spacingLg, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Text(loc.t('analytics_evaluation'), style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: cs.onSurface)),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: ev.enabled ? AppTheme.colorGreen.withValues(alpha: 0.15) : cs.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(ev.enabled ? loc.t('enabled') : loc.t('disabled'),
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600,
                    color: ev.enabled ? AppTheme.colorGreen : cs.onSurfaceVariant)),
              ),
            ]),
            const SizedBox(height: AppTheme.spacingMd),
            _infoRow(loc.t('evaluated_requests'), _fmtCount(ev.evaluatedRequests)),
            _infoRow(loc.t('cache_hit_responses'), _fmtCount(ev.cacheHitResponses)),
            _infoRow(loc.t('cache_miss_requests'), _fmtCount(ev.cacheMissRequests)),
            _infoRow(loc.t('bypassed_requests'), _fmtCount(ev.bypassedRequests)),
            _infoRow(loc.t('stored_responses'), _fmtCount(ev.storedResponses)),
          ],
        ),
      ),
    );
  }

  // ── Tab 5: Cache (semantic cache stats) ──
  Widget _buildCacheTab() {
    final loc = context.read<AppProvider>().loc;
    final cs = Theme.of(context).colorScheme;
    final ev = _evaluation;
    if (ev == null) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: AppEmptyState(icon: CupertinoIcons.archivebox, title: loc.t('no_data')),
      );
    }
    return SliverToBoxAdapter(
      child: AppCard(
        margin: const EdgeInsets.fromLTRB(AppTheme.spacingLg, AppTheme.spacingSm, AppTheme.spacingLg, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Text(loc.t('analytics_cache'), style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: cs.onSurface)),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: ev.runtimeEnabled ? AppTheme.colorGreen.withValues(alpha: 0.15) : cs.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(ev.runtimeEnabled ? loc.t('enabled') : loc.t('disabled'),
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600,
                    color: ev.runtimeEnabled ? AppTheme.colorGreen : cs.onSurfaceVariant)),
              ),
            ]),
            const SizedBox(height: AppTheme.spacingMd),
            Row(children: [
              _metricBox(loc.t('ops_cache_entries'), _fmtCount(ev.currentEntries)),
              _metricBox(loc.t('ops_cache_hit_rate'), '${(ev.hitRate * 100).toStringAsFixed(1)}%'),
              _metricBox(loc.t('ops_cache_usage_rate'), '${(ev.usageRate * 100).toStringAsFixed(1)}%'),
            ]),
            const SizedBox(height: AppTheme.spacingMd),
            _infoRow(loc.t('ops_cache_hits'), _fmtCount(ev.hits)),
            _infoRow(loc.t('ops_cache_misses'), _fmtCount(ev.misses)),
            _infoRow('TTL', '${ev.ttlSeconds}s'),
            _infoRow(loc.t('setting_semantic_cache_max_entries'), _fmtCount(ev.maxEntries)),
          ],
        ),
      ),
    );
  }

  // ── Shared helpers ──

  Widget _infoRow(String label, String value) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 13, color: cs.onSurfaceVariant)),
          Text(value, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: cs.onSurface)),
        ],
      ),
    );
  }

  Widget _metricRow(AppLocalizations loc, int requests, String cost, int tokens, double successRate) {
    return Row(
      children: [
        _metricBox(loc.t('requests'), _fmtCount(requests)),
        _metricBox(loc.t('cost'), cost),
        _metricBox(loc.t('tokens'), _fmtCount(tokens)),
        _metricBox(loc.t('success_rate'), '${successRate.toStringAsFixed(1)}%'),
      ],
    );
  }

  Widget _metricBox(String label, String value) {
    return Expanded(
      child: Column(children: [
        Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Theme.of(context).colorScheme.onSurface)),
        Text(label, style: TextStyle(fontSize: 11, color: Theme.of(context).colorScheme.onSurfaceVariant)),
      ]),
    );
  }
}

class _RangeHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  _RangeHeaderDelegate({required this.child});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) => child;

  @override
  double get maxExtent => 38;

  @override
  double get minExtent => 38;

  @override
  bool shouldRebuild(covariant _RangeHeaderDelegate oldDelegate) => child != oldDelegate.child;
}
