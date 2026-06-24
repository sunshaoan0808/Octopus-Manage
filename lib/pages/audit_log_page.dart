import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:octopusmanage/models/audit_log.dart';
import 'package:octopusmanage/providers/app_provider.dart';
import 'package:octopusmanage/theme/app_theme.dart';
import 'package:octopusmanage/widgets/app_chips.dart';
import 'package:octopusmanage/widgets/app_empty_state.dart';
import 'package:octopusmanage/widgets/app_error_dialog.dart';
import 'package:octopusmanage/widgets/app_list_tile.dart';
import 'package:provider/provider.dart';

class AuditLogPage extends StatefulWidget {
  const AuditLogPage({super.key});

  @override
  State<AuditLogPage> createState() => _AuditLogPageState();
}

class _AuditLogPageState extends State<AuditLogPage> {
  List<AuditLog> _logs = [];
  int _page = 1;
  bool _loading = true;
  bool _hasMore = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    if (!mounted) return;
    setState(() => _loading = true);
    try {
      _logs = await context.read<AppProvider>().api.getAuditLogs();
      _hasMore = _logs.length >= 50;
      _page = 1;
    } catch (e) {
      if (mounted) showErrorDialog(context, e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _loadMore() async {
    if (_loading || !_hasMore) return;
    setState(() => _loading = true);
    try {
      final more = await context.read<AppProvider>().api.getAuditLogs(
        page: _page + 1,
      );
      if (mounted) {
        _logs.addAll(more);
        _hasMore = more.length >= 50;
        _page++;
      }
    } catch (e) {
      if (mounted) showErrorDialog(context, e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  String _formatTime(int ts) {
    final dt = DateTime.fromMillisecondsSinceEpoch(ts * 1000);
    return '${dt.month}/${dt.day} ${dt.hour}:${dt.minute.toString().padLeft(2, '0')}:${dt.second.toString().padLeft(2, '0')}';
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
              largeTitle: Text(loc.t('audit_logs')),
              backgroundColor: AppTheme.getSurfaceLowest(colorScheme).withValues(alpha: 0.85),
              border: null,
            ),
            CupertinoSliverRefreshControl(onRefresh: _load),
            if (_loading && _logs.isEmpty)
              const SliverFillRemaining(hasScrollBody: false, child: AppLoadingState())
            else if (_logs.isEmpty)
              SliverFillRemaining(
                child: AppEmptyState(
                  icon: CupertinoIcons.doc_plaintext,
                  title: loc.t('no_audit_logs'),
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.only(bottom: 32),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate((ctx, i) {
                    final log = _logs[i];
                    return AppListTile(
                      margin: const EdgeInsets.fromLTRB(AppTheme.spacingLg, AppTheme.spacingSm, AppTheme.spacingLg, 0),
                      title: Row(children: [
                        Text(log.username, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: colorScheme.onSurface)),
                        const SizedBox(width: 8),
                        AppInfoChip(icon: CupertinoIcons.tag, label: log.action),
                      ]),
                      subtitle: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text('${log.method} ${log.path}', style: TextStyle(fontSize: 12, fontFamily: 'monospace', color: colorScheme.onSurfaceVariant)),
                        if (log.target.isNotEmpty)
                          Text(log.target, style: TextStyle(fontSize: 12, color: colorScheme.onSurfaceVariant)),
                        Text(_formatTime(log.createdAt), style: const TextStyle(fontSize: 11, color: Color(0xFF8E8E93))),
                      ]),
                      trailing: AppInfoChip(
                        icon: log.statusCode < 400 ? CupertinoIcons.checkmark : CupertinoIcons.xmark,
                        label: '${log.statusCode}',
                      ),
                    );
                  }, childCount: _logs.length),
                ),
              ),
            if (_hasMore)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(AppTheme.spacingLg),
                  child: Center(
                    child: CupertinoButton(
                      onPressed: _loading ? null : _loadMore,
                      child: Text(_loading ? '...' : loc.t('load_more')),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
