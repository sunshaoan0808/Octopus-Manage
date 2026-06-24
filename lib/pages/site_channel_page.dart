import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:octopusmanage/l10n/app_localizations.dart';
import 'package:octopusmanage/models/site_channel.dart';
import 'package:octopusmanage/providers/app_provider.dart';
import 'package:octopusmanage/theme/app_theme.dart';
import 'package:octopusmanage/widgets/app_card.dart';
import 'package:octopusmanage/widgets/app_chips.dart';
import 'package:octopusmanage/widgets/app_dialogs.dart';
import 'package:octopusmanage/widgets/app_empty_state.dart';
import 'package:octopusmanage/widgets/app_error_dialog.dart';
import 'package:provider/provider.dart';

class SiteChannelPage extends StatefulWidget {
  final int siteId;
  final String siteName;

  const SiteChannelPage({
    super.key,
    required this.siteId,
    required this.siteName,
  });

  @override
  State<SiteChannelPage> createState() => _SiteChannelPageState();
}

class _SiteChannelPageState extends State<SiteChannelPage> {
  List<SiteChannelCard> _channels = [];
  bool _loading = true;
  final Set<int> _expandedChannels = {};

  @override
  void initState() {
    super.initState();
    _loadChannels();
  }

  Future<void> _loadChannels() async {
    if (!mounted) return;
    setState(() => _loading = true);
    try {
      final api = context.read<AppProvider>().api;
      _channels = await api.getSiteChannels(widget.siteId);
      _channels.sort((a, b) => a.channelName.compareTo(b.channelName));
    } catch (e) {
      if (mounted) {
        await showErrorDialog(context, e.toString());
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _loadModelRoutes(
      int channelId, AppLocalizations loc) async {
    try {
      final api = context.read<AppProvider>().api;
      final models =
          await api.getSiteChannelModelRoutes(widget.siteId, channelId);
      if (!mounted) return;
      await _showModelRoutesSheet(channelId, models, loc);
    } catch (e) {
      if (mounted) {
        await showErrorDialog(context, e.toString());
      }
    }
  }

  Future<void> _showModelRoutesSheet(
    int channelId,
    List<SiteChannelModel> models,
    AppLocalizations loc,
  ) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _ModelRoutesSheet(
        siteId: widget.siteId,
        channelId: channelId,
        models: models,
        loc: loc,
        onRefresh: () => _loadModelRoutes(channelId, loc),
        onDelete: (modelName) =>
            _deleteManualModel(channelId, modelName, loc),
      ),
    );
  }

  Future<void> _addManualModel(
      int channelId, AppLocalizations loc) async {
    final modelName = await AppInputDialog.show(
      context: context,
      title: loc.t('site_channel_add_model'),
      hint: loc.t('site_channel_model_name_hint'),
      confirmText: loc.t('add'),
      cancelText: loc.t('cancel'),
    );
    if (modelName == null || modelName.isEmpty || !mounted) return;
    try {
      final api = context.read<AppProvider>().api;
      await api.addSiteChannelManualModel(
          widget.siteId, channelId, modelName);
      if (mounted) {
        await _loadModelRoutes(channelId, loc);
      }
    } catch (e) {
      if (mounted) {
        await showErrorDialog(context, e.toString());
      }
    }
  }

  Future<void> _deleteManualModel(
    int channelId,
    String modelName,
    AppLocalizations loc,
  ) async {
    final confirmed = await AppConfirmDialog.show(
      context: context,
      title: loc.t('site_channel_delete_model'),
      content:
          loc.t('site_channel_delete_model_confirm', {'name': modelName}),
      confirmText: loc.t('delete'),
      cancelText: loc.t('cancel'),
      isDanger: true,
    );
    if (!confirmed || !mounted) return;
    try {
      final api = context.read<AppProvider>().api;
      await api.deleteSiteChannelManualModel(
          widget.siteId, channelId, modelName);
      if (mounted) {
        await _loadModelRoutes(channelId, loc);
      }
    } catch (e) {
      if (mounted) {
        await showErrorDialog(context, e.toString());
      }
    }
  }

  void _toggleExpanded(int channelId) {
    setState(() {
      if (_expandedChannels.contains(channelId)) {
        _expandedChannels.remove(channelId);
      } else {
        _expandedChannels.add(channelId);
      }
    });
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
              largeTitle: Text(loc.t('site_channel_projection')),
              backgroundColor: AppTheme.getSurfaceLowest(colorScheme)
                  .withValues(alpha: 0.85),
              border: null,
              trailing: GestureDetector(
                onTap: () {
                  // Import placeholder
                  _showImportPlaceholder(loc);
                },
                child: Icon(
                  CupertinoIcons.square_arrow_down,
                  size: 22,
                  color: colorScheme.primary,
                ),
              ),
            ),
            CupertinoSliverRefreshControl(onRefresh: _loadChannels),
            if (_loading)
              const SliverFillRemaining(
                hasScrollBody: false,
                child: AppLoadingState(),
              )
            else if (_channels.isEmpty)
              SliverFillRemaining(
                child: AppEmptyState(
                  icon: CupertinoIcons.arrow_3_trianglepath,
                  title: loc.t('site_channel_no_channels'),
                  subtitle: loc.t('site_channel_all_api_hub'),
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.only(bottom: 96),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final channel = _channels[index];
                      final isExpanded =
                          _expandedChannels.contains(channel.channelId);
                      return AppCard(
                        margin: const EdgeInsets.fromLTRB(
                          AppTheme.spacingLg,
                          AppTheme.spacingSm,
                          AppTheme.spacingLg,
                          0,
                        ),
                        padding:
                            const EdgeInsets.all(AppTheme.spacingLg),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildChannelHeader(channel, loc, colorScheme),
                            const SizedBox(height: AppTheme.spacingSm),
                            _buildChannelInfo(channel, loc, colorScheme),
                            if (isExpanded) ...[
                              const SizedBox(height: AppTheme.spacingMd),
                              _buildChannelActions(
                                  channel, loc, colorScheme),
                            ],
                          ],
                        ),
                      );
                    },
                    childCount: _channels.length,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildChannelHeader(
    SiteChannelCard channel,
    AppLocalizations loc,
    ColorScheme colorScheme,
  ) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                channel.channelName,
                style: theme.textTheme.heading,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              if (channel.groupName.isNotEmpty)
                Padding(
                  padding:
                      const EdgeInsets.only(top: AppTheme.spacingXs),
                  child: Text(
                    channel.groupName,
                    style: theme.textTheme.caption,
                  ),
                ),
            ],
          ),
        ),
        CupertinoSwitch(
          value: channel.enabled,
          onChanged: (_) => _toggleExpanded(channel.channelId),
        ),
        const SizedBox(width: AppTheme.spacingSm),
        GestureDetector(
          onTap: () => _toggleExpanded(channel.channelId),
          child: Icon(
            isExpanded(channel.channelId)
                ? CupertinoIcons.chevron_up
                : CupertinoIcons.chevron_down,
            size: 18,
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  bool isExpanded(int channelId) {
    return _expandedChannels.contains(channelId);
  }

  Widget _buildChannelInfo(
    SiteChannelCard channel,
    AppLocalizations loc,
    ColorScheme colorScheme,
  ) {
    return Wrap(
      spacing: AppTheme.spacingSm,
      runSpacing: AppTheme.spacingXs,
      children: [
        if (channel.modelName.isNotEmpty)
          AppInfoChip(
            icon: CupertinoIcons.cube_box,
            label: channel.modelName,
          ),
        if (channel.routeType.isNotEmpty)
          AppTypeChip(
            label: channel.routeType,
            color: _routeTypeColor(channel.routeType),
          ),
        AppInfoChip(
          icon: CupertinoIcons.person,
          label: '${loc.t('site_channel_account')} #${channel.accountId}',
        ),
      ],
    );
  }

  Widget _buildChannelActions(
    SiteChannelCard channel,
    AppLocalizations loc,
    ColorScheme colorScheme,
  ) {
    return Row(
      children: [
        Expanded(
          child: CupertinoButton(
            padding: const EdgeInsets.symmetric(
              horizontal: AppTheme.spacingMd,
              vertical: AppTheme.spacingSm,
            ),
            color: colorScheme.primary.withValues(alpha: 0.1),
            onPressed: () =>
                _loadModelRoutes(channel.channelId, loc),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  CupertinoIcons.arrow_branch,
                  size: 16,
                  color: colorScheme.primary,
                ),
                const SizedBox(width: AppTheme.spacingXs),
                Text(
                  loc.t('site_channel_route'),
                  style: TextStyle(
                    color: colorScheme.primary,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: AppTheme.spacingSm),
        Expanded(
          child: CupertinoButton(
            padding: const EdgeInsets.symmetric(
              horizontal: AppTheme.spacingMd,
              vertical: AppTheme.spacingSm,
            ),
            color: AppTheme.colorGreen.withValues(alpha: 0.1),
            onPressed: () =>
                _addManualModel(channel.channelId, loc),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  CupertinoIcons.add,
                  size: 16,
                  color: AppTheme.colorGreen,
                ),
                const SizedBox(width: AppTheme.spacingXs),
                Text(
                  loc.t('site_channel_add_model'),
                  style: const TextStyle(
                    color: AppTheme.colorGreen,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Color _routeTypeColor(String routeType) {
    switch (routeType.toLowerCase()) {
      case 'auto':
        return AppTheme.colorBlue;
      case 'manual':
        return AppTheme.colorOrange;
      case 'disabled':
        return AppTheme.colorRed;
      default:
        return AppTheme.colorGray;
    }
  }

  void _showImportPlaceholder(AppLocalizations loc) {
    showCupertinoDialog(
      context: context,
      builder: (ctx) => CupertinoAlertDialog(
        title: Text(loc.t('site_channel_import')),
        content: Text(loc.t('site_channel_import_placeholder')),
        actions: [
          CupertinoDialogAction(
            child: Text(loc.t('ok')),
            onPressed: () => Navigator.pop(ctx),
          ),
        ],
      ),
    );
  }
}

class _ModelRoutesSheet extends StatefulWidget {
  final int siteId;
  final int channelId;
  final List<SiteChannelModel> models;
  final AppLocalizations loc;
  final VoidCallback onRefresh;
  final Future<void> Function(String modelName) onDelete;

  const _ModelRoutesSheet({
    required this.siteId,
    required this.channelId,
    required this.models,
    required this.loc,
    required this.onRefresh,
    required this.onDelete,
  });

  @override
  State<_ModelRoutesSheet> createState() => _ModelRoutesSheetState();
}

class _ModelRoutesSheetState extends State<_ModelRoutesSheet> {
  late List<SiteChannelModel> _models;

  @override
  void initState() {
    super.initState();
    _models = List.from(widget.models);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: BoxDecoration(
        color: AppTheme.getSurfaceLowest(colorScheme),
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppTheme.radiusXXLarge),
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(
              AppTheme.spacingLg,
              AppTheme.spacingLg,
              AppTheme.spacingLg,
              AppTheme.spacingSm,
            ),
            child: Row(
              children: [
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: () => Navigator.pop(context),
                  child: Text(widget.loc.t('cancel')),
                ),
                const Spacer(),
                Text(
                  widget.loc.t('site_channel_route'),
                  style: Theme.of(context).textTheme.heading,
                ),
                const Spacer(),
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: () => Navigator.pop(context),
                  child: Text(widget.loc.t('ok')),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: _models.isEmpty
                ? AppEmptyState(
                    icon: CupertinoIcons.cube_box,
                    title: widget.loc.t('site_channel_no_models'),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(AppTheme.spacingLg),
                    itemCount: _models.length,
                    itemBuilder: (ctx, index) {
                      final model = _models[index];
                      return AppListItemCard(
                        margin: const EdgeInsets.only(
                            bottom: AppTheme.spacingSm),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    model.modelName,
                                    style: Theme.of(context)
                                        .textTheme
                                        .label,
                                  ),
                                  const SizedBox(
                                      height: AppTheme.spacingXs),
                                  AppTypeChip(
                                    label: model.routeType.isEmpty
                                        ? 'auto'
                                        : model.routeType,
                                    color: _routeTypeColor(
                                        model.routeType),
                                  ),
                                ],
                              ),
                            ),
                            if (model.enabled)
                              const Icon(
                                CupertinoIcons.checkmark_circle_fill,
                                color: AppTheme.colorGreen,
                                size: 20,
                              )
                            else
                              Icon(
                                CupertinoIcons.xmark_circle_fill,
                                color: AppTheme.colorRed
                                    .withValues(alpha: 0.5),
                                size: 20,
                              ),
                            const SizedBox(width: AppTheme.spacingSm),
                            GestureDetector(
                              onTap: () async {
                                await widget.onDelete(model.modelName);
                                setState(() {
                                  _models.removeAt(index);
                                });
                              },
                              child: const Icon(
                                CupertinoIcons.trash,
                                color: AppTheme.colorRed,
                                size: 18,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Color _routeTypeColor(String routeType) {
    switch (routeType.toLowerCase()) {
      case 'auto':
        return AppTheme.colorBlue;
      case 'manual':
        return AppTheme.colorOrange;
      case 'disabled':
        return AppTheme.colorRed;
      default:
        return AppTheme.colorGray;
    }
  }
}
