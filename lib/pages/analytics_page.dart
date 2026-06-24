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
      ]);
      if (mounted) {
        _overview = results[0] as AnalyticsOverview;
        _providers = results[1] as List<AnalyticsBreakdownItem>;
        _models = results[2] as List<AnalyticsBreakdownItem>;
        _apiKeys = results[3] as List<AnalyticsBreakdownItem>;
        _groupHealth = results[4] as List<AnalyticsGroupHealthItem>;
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
              // Group Health
              if (_groupHealth.isNotEmpty)
                SliverToBoxAdapter(
                  child: AppCard(
                    margin: const EdgeInsets.fromLTRB(AppTheme.spacingLg, AppTheme.spacingMd, AppTheme.spacingLg, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(loc.t('analytics_group_health'), style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: colorScheme.onSurface)),
                        const SizedBox(height: AppTheme.spacingSm),
                        ..._groupHealth.take(5).map((g) => Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Row(children: [
                            Icon(g.status == 'healthy' ? CupertinoIcons.checkmark_circle_fill : CupertinoIcons.exclamationmark_circle_fill,
                              size: 14, color: g.status == 'healthy' ? AppTheme.colorGreen : AppTheme.colorOrange),
                            const SizedBox(width: 6),
                            Expanded(child: Text(g.groupName, style: const TextStyle(fontSize: 14))),
                            Text('${g.healthScore}%', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14,
                              color: g.healthScore >= 80 ? AppTheme.colorGreen : AppTheme.colorOrange)),
                          ]),
                        )),
                      ],
                    ),
                  ),
                ),
              // Breakdown tabs
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(AppTheme.spacingLg, AppTheme.spacingMd, AppTheme.spacingLg, 0),
                  child: CupertinoSegmentedControl<int>(
                    groupValue: _tab,
                    onValueChanged: (v) => setState(() => _tab = v),
                    children: {
                      0: Padding(padding: const EdgeInsets.all(8), child: Text(loc.t('analytics_providers'), style: const TextStyle(fontSize: 12))),
                      1: Padding(padding: const EdgeInsets.all(8), child: Text(loc.t('analytics_models'), style: const TextStyle(fontSize: 12))),
                      2: Padding(padding: const EdgeInsets.all(8), child: Text(loc.t('api_keys'), style: const TextStyle(fontSize: 12))),
                    },
                  ),
                ),
              ),
              if (_tab == 0) _buildBreakdownList(_providers.map((p) => (p.channelName, p.enabled, p.metrics)).toList()),
              if (_tab == 1) _buildBreakdownList(_models.map((m) => (m.modelName, true, m.metrics)).toList()),
              if (_tab == 2) _buildBreakdownList(_apiKeys.map((k) => (k.name.isNotEmpty ? k.name : 'Key #${k.apiKeyId}', true, k.metrics)).toList()),
              const SliverPadding(padding: EdgeInsets.only(bottom: 32)),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildBreakdownList(List<(String, bool, AnalyticsMetrics)> items) {
    final loc = context.read<AppProvider>().loc;
    if (items.isEmpty) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: AppEmptyState(icon: CupertinoIcons.chart_bar, title: loc.t('no_data')),
      );
    }
    return SliverList(
      delegate: SliverChildBuilderDelegate((ctx, i) {
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
      }, childCount: items.length),
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
