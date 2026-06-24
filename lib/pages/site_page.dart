import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:octopusmanage/l10n/app_localizations.dart';
import 'package:octopusmanage/models/site.dart';
import 'package:octopusmanage/pages/site_detail_page.dart';
import 'package:octopusmanage/providers/app_provider.dart';
import 'package:octopusmanage/theme/app_theme.dart';
import 'package:octopusmanage/widgets/app_card.dart';
import 'package:octopusmanage/widgets/app_chips.dart';
import 'package:octopusmanage/widgets/app_dialogs.dart';
import 'package:octopusmanage/widgets/app_empty_state.dart';
import 'package:octopusmanage/widgets/app_error_dialog.dart';
import 'package:provider/provider.dart';

class SitePage extends StatefulWidget {
  const SitePage({super.key});

  @override
  State<SitePage> createState() => _SitePageState();
}

class _SitePageState extends State<SitePage> {
  List<Site> _sites = [];
  List<Site> _filteredSites = [];
  bool _loading = true;
  String _searchQuery = '';
  String _filterStatus = 'all';

  @override
  void initState() {
    super.initState();
    _loadSites();
  }

  Future<void> _loadSites() async {
    if (!mounted) return;
    setState(() => _loading = true);
    try {
      final api = context.read<AppProvider>().api;
      _sites = await api.getSites();
      _sites.sort((a, b) => a.name.compareTo(b.name));
      _applyFilters();
    } catch (e) {
      if (mounted) {
        await showErrorDialog(context, e.toString());
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _applyFilters() {
    _filteredSites = _sites.where((site) {
      final matchesSearch = _searchQuery.isEmpty ||
          site.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          site.platform.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          site.baseUrl.toLowerCase().contains(_searchQuery.toLowerCase());

      final matchesFilter = _filterStatus == 'all' ||
          site.status == _filterStatus;

      return matchesSearch && matchesFilter;
    }).toList();
  }

  Future<void> _toggleEnabled(Site site) async {
    try {
      final api = context.read<AppProvider>().api;
      await api.enableSite(site.id, !site.enabled);
      await _loadSites();
    } catch (e) {
      if (mounted) {
        await showErrorDialog(context, e.toString());
      }
    }
  }

  Future<void> _deleteSite(Site site, AppLocalizations loc) async {
    final confirmed = await AppConfirmDialog.show(
      context: context,
      title: loc.t('delete_site'),
      content: loc.t('site_confirm_delete', {'name': site.name}),
      confirmText: loc.t('delete'),
      cancelText: loc.t('cancel'),
      isDanger: true,
    );
    if (!confirmed || !mounted) return;
    try {
      final api = context.read<AppProvider>().api;
      await api.deleteSite(site.id);
      await _loadSites();
    } catch (e) {
      if (mounted) {
        await showErrorDialog(context, e.toString());
      }
    }
  }

  Future<void> _archiveSite(Site site, AppLocalizations loc) async {
    final confirmed = await AppConfirmDialog.show(
      context: context,
      title: loc.t('site_archive'),
      content: loc.t('site_confirm_archive', {'name': site.name}),
      confirmText: loc.t('site_archive'),
      cancelText: loc.t('cancel'),
    );
    if (!confirmed || !mounted) return;
    try {
      final api = context.read<AppProvider>().api;
      await api.archiveSite(site.id);
      await _loadSites();
    } catch (e) {
      if (mounted) {
        await showErrorDialog(context, e.toString());
      }
    }
  }

  Future<void> _restoreSite(Site site, AppLocalizations loc) async {
    final confirmed = await AppConfirmDialog.show(
      context: context,
      title: loc.t('site_restore'),
      content: loc.t('site_confirm_restore', {'name': site.name}),
      confirmText: loc.t('site_restore'),
      cancelText: loc.t('cancel'),
    );
    if (!confirmed || !mounted) return;
    try {
      final api = context.read<AppProvider>().api;
      await api.restoreSite(site.id);
      await _loadSites();
    } catch (e) {
      if (mounted) {
        await showErrorDialog(context, e.toString());
      }
    }
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'active':
        return AppTheme.colorGreen;
      case 'inactive':
        return AppTheme.colorGray;
      case 'error':
        return AppTheme.colorRed;
      case 'archived':
        return AppTheme.colorOrange;
      default:
        return AppTheme.colorGray;
    }
  }

  String _statusLabel(String status, AppLocalizations loc) {
    switch (status) {
      case 'active':
        return loc.t('site_status_active');
      case 'inactive':
        return loc.t('site_status_inactive');
      case 'error':
        return loc.t('site_status_error');
      case 'archived':
        return loc.t('site_status_archived');
      default:
        return status;
    }
  }

  Color _platformColor(String platform) {
    switch (platform) {
      case 'openai':
        return AppTheme.colorGreen;
      case 'anthropic':
        return AppTheme.colorIndigo;
      case 'google':
        return AppTheme.colorBlue;
      case 'azure':
        return AppTheme.colorTeal;
      case 'custom':
        return AppTheme.colorPurple;
      default:
        return AppTheme.colorGray;
    }
  }

  void _openSiteDetail(Site site) {
    Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (ctx) => SiteDetailPage(site: site),
      ),
    ).then((_) => _loadSites());
  }

  @override
  Widget build(BuildContext context) {
    final loc = context.watch<AppProvider>().loc;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isCompact = Responsive.isCompact(context);

    return CupertinoPageScaffold(
      backgroundColor: AppTheme.getSurfaceLowest(colorScheme),
      child: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              slivers: [
                CupertinoSliverNavigationBar(
                  largeTitle: Text(loc.t('sites')),
                  backgroundColor: AppTheme.getSurfaceLowest(
                    colorScheme,
                  ).withValues(alpha: 0.85),
                  border: null,
                ),
                CupertinoSliverRefreshControl(onRefresh: _loadSites),
                if (_loading)
                  const SliverFillRemaining(
                    hasScrollBody: false,
                    child: AppLoadingState(),
                  )
                else if (_sites.isEmpty)
                  SliverFillRemaining(
                    child: AppEmptyState(
                      icon: CupertinoIcons.globe,
                      title: loc.t('no_sites'),
                      subtitle: loc.t('create_first_site'),
                      action: CupertinoButton.filled(
                        onPressed: () => _openSiteEditor(),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(CupertinoIcons.add, size: 18),
                            const SizedBox(width: 4),
                            Text(loc.t('create_site')),
                          ],
                        ),
                      ),
                    ),
                  )
                else ...[
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(
                        AppTheme.spacingLg,
                        AppTheme.spacingSm,
                        AppTheme.spacingLg,
                        AppTheme.spacingSm,
                      ),
                      child: Column(
                        children: [
                          CupertinoSearchTextField(
                            placeholder: loc.t('site_search_hint'),
                            onChanged: (value) {
                              setState(() {
                                _searchQuery = value;
                                _applyFilters();
                              });
                            },
                            backgroundColor: AppTheme.getInputBackground(colorScheme),
                            borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                          ),
                          const SizedBox(height: AppTheme.spacingSm),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                _FilterChip(
                                  label: loc.t('site_filter_all'),
                                  selected: _filterStatus == 'all',
                                  onTap: () => setState(() {
                                    _filterStatus = 'all';
                                    _applyFilters();
                                  }),
                                ),
                                const SizedBox(width: AppTheme.spacingSm),
                                _FilterChip(
                                  label: loc.t('site_filter_active'),
                                  selected: _filterStatus == 'active',
                                  color: AppTheme.colorGreen,
                                  onTap: () => setState(() {
                                    _filterStatus = 'active';
                                    _applyFilters();
                                  }),
                                ),
                                const SizedBox(width: AppTheme.spacingSm),
                                _FilterChip(
                                  label: loc.t('site_filter_inactive'),
                                  selected: _filterStatus == 'inactive',
                                  color: AppTheme.colorGray,
                                  onTap: () => setState(() {
                                    _filterStatus = 'inactive';
                                    _applyFilters();
                                  }),
                                ),
                                const SizedBox(width: AppTheme.spacingSm),
                                _FilterChip(
                                  label: loc.t('site_filter_error'),
                                  selected: _filterStatus == 'error',
                                  color: AppTheme.colorRed,
                                  onTap: () => setState(() {
                                    _filterStatus = 'error';
                                    _applyFilters();
                                  }),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.only(bottom: 96),
                    sliver: SliverGrid(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: isCompact ? 1 : Responsive.getGridCrossCount(context),
                        childAspectRatio: isCompact ? 2.2 : 1.8,
                        crossAxisSpacing: AppTheme.spacingSm,
                        mainAxisSpacing: AppTheme.spacingSm,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final site = _filteredSites[index];
                          return _SiteCard(
                            site: site,
                            statusColor: _statusColor(site.status),
                            statusLabel: _statusLabel(site.status, loc),
                            platformColor: _platformColor(site.platform),
                            loc: loc,
                            onTap: () => _openSiteDetail(site),
                            onToggle: () => _toggleEnabled(site),
                            onEdit: () => _openSiteEditor(existing: site),
                            onDelete: () => _deleteSite(site, loc),
                            onArchive: site.status != 'archived'
                                ? () => _archiveSite(site, loc)
                                : null,
                            onRestore: site.status == 'archived'
                                ? () => _restoreSite(site, loc)
                                : null,
                          );
                        },
                        childCount: _filteredSites.length,
                      ),
                    ),
                  ),
                ],
              ],
            ),
            if (!_loading && _sites.isNotEmpty)
              Positioned(
                right: AppTheme.spacingLg,
                bottom: 24,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: AppTheme.getShadowMedium(colorScheme),
                  ),
                  child: CupertinoButton(
                    padding: EdgeInsets.zero,
                    borderRadius: BorderRadius.circular(28),
                    color: colorScheme.primary,
                    onPressed: () => _openSiteEditor(),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(width: 16),
                        const Icon(
                          CupertinoIcons.add,
                          size: 22,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          loc.t('create_site'),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 16),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _openSiteEditor({Site? existing}) async {
    final site = await showModalBottomSheet<Site>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _SiteEditorSheet(existing: existing),
    );
    if (site == null || !mounted) return;

    try {
      final api = context.read<AppProvider>().api;
      if (existing == null) {
        await api.createSite(site);
      } else {
        await api.updateSite(site);
      }
      await _loadSites();
    } catch (e) {
      if (mounted) {
        await showErrorDialog(context, e.toString());
      }
    }
  }
}

class _SiteCard extends StatelessWidget {
  final Site site;
  final Color statusColor;
  final String statusLabel;
  final Color platformColor;
  final AppLocalizations loc;
  final VoidCallback onTap;
  final VoidCallback onToggle;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback? onArchive;
  final VoidCallback? onRestore;

  const _SiteCard({
    required this.site,
    required this.statusColor,
    required this.statusLabel,
    required this.platformColor,
    required this.loc,
    required this.onTap,
    required this.onToggle,
    required this.onEdit,
    required this.onDelete,
    this.onArchive,
    this.onRestore,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AppCard(
      margin: const EdgeInsets.fromLTRB(
        AppTheme.spacingLg,
        AppTheme.spacingSm,
        AppTheme.spacingLg,
        0,
      ),
      padding: const EdgeInsets.all(AppTheme.spacingLg),
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CupertinoSwitch(
                  value: site.enabled,
                  onChanged: (_) => onToggle(),
                ),
                const SizedBox(width: AppTheme.spacingSm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              site.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                                color: colorScheme.onSurface,
                              ),
                            ),
                          ),
                          AppTypeChip(
                            label: site.platform.toUpperCase(),
                            color: platformColor,
                          ),
                          const SizedBox(width: AppTheme.spacingXs),
                          AppTypeChip(
                            label: statusLabel,
                            color: statusColor,
                          ),
                        ],
                      ),
                      const SizedBox(height: AppTheme.spacingXs),
                      Text(
                        site.baseUrl,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.caption?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppTheme.spacingMd),
                GestureDetector(
                  onTap: onEdit,
                  child: Icon(
                    CupertinoIcons.pencil,
                    size: 20,
                    color: colorScheme.primary,
                  ),
                ),
                const SizedBox(width: AppTheme.spacingMd),
                GestureDetector(
                  onTap: onDelete,
                  child: Icon(
                    CupertinoIcons.delete,
                    size: 20,
                    color: colorScheme.error,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppTheme.spacingMd),
            Wrap(
              spacing: AppTheme.spacingSm,
              runSpacing: AppTheme.spacingXs,
              children: [
                AppInfoChip(
                  icon: CupertinoIcons.arrow_3_trianglepath,
                  label: '${loc.t('site_channel_count')}: ${site.channelCount}',
                ),
                AppInfoChip(
                  icon: CupertinoIcons.cube_box,
                  label: '${loc.t('site_model_count')}: ${site.modelCount}',
                ),
                AppInfoChip(
                  icon: CupertinoIcons.money_dollar,
                  label: '${loc.t('site_total_cost')}: ${site.totalCost.toStringAsFixed(2)}',
                ),
                AppInfoChip(
                  icon: CupertinoIcons.checkmark_circle,
                  label: '${loc.t('site_success_rate')}: ${(site.successRate * 100).toStringAsFixed(1)}%',
                  color: site.successRate >= 0.9
                      ? AppTheme.colorGreen
                      : site.successRate >= 0.7
                          ? AppTheme.colorOrange
                          : AppTheme.colorRed,
                ),
              ],
            ),
            if (site.status == 'error' && site.errorMessage != null) ...[
              const SizedBox(height: AppTheme.spacingSm),
              Text(
                site.errorMessage!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.caption?.copyWith(
                  color: colorScheme.error,
                ),
              ),
            ],
            const SizedBox(height: AppTheme.spacingSm),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (onArchive != null)
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    onPressed: onArchive,
                    child: Text(
                      loc.t('site_archive'),
                      style: TextStyle(
                        fontSize: 13,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                if (onRestore != null)
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    onPressed: onRestore,
                    child: Text(
                      loc.t('site_restore'),
                      style: TextStyle(
                        fontSize: 13,
                        color: colorScheme.primary,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final Color? color;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.selected,
    this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppTheme.spacingMd,
          vertical: AppTheme.spacingXs,
        ),
        decoration: BoxDecoration(
          color: selected
              ? (color ?? colorScheme.primary).withValues(alpha: 0.15)
              : AppTheme.getSurfaceHigh(colorScheme),
          borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
            color: selected
                ? (color ?? colorScheme.primary)
                : colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}

class _SiteEditorSheet extends StatefulWidget {
  final Site? existing;

  const _SiteEditorSheet({this.existing});

  @override
  State<_SiteEditorSheet> createState() => _SiteEditorSheetState();
}

class _SiteEditorSheetState extends State<_SiteEditorSheet> {
  late final TextEditingController _nameCtl;
  late final TextEditingController _baseUrlCtl;
  late final TextEditingController _apiKeyCtl;
  late final TextEditingController _proxyUrlCtl;
  late final TextEditingController _oauthClientIdCtl;
  late final TextEditingController _oauthClientSecretCtl;
  late final TextEditingController _oauthTokenUrlCtl;
  late String _selectedPlatform;
  late String _selectedAuthType;
  late bool _enabled;
  late bool _proxyEnabled;

  @override
  void initState() {
    super.initState();
    final existing = widget.existing;
    _nameCtl = TextEditingController(text: existing?.name ?? '');
    _baseUrlCtl = TextEditingController(text: existing?.baseUrl ?? '');
    _apiKeyCtl = TextEditingController(text: existing?.apiKey ?? '');
    _proxyUrlCtl = TextEditingController(text: existing?.proxyUrl ?? '');
    _oauthClientIdCtl = TextEditingController(text: existing?.oauthClientId ?? '');
    _oauthClientSecretCtl = TextEditingController(text: existing?.oauthClientSecret ?? '');
    _oauthTokenUrlCtl = TextEditingController(text: existing?.oauthTokenUrl ?? '');
    _selectedPlatform = existing?.platform ?? 'custom';
    _selectedAuthType = existing?.authType ?? 'api_key';
    _enabled = existing?.enabled ?? true;
    _proxyEnabled = existing?.proxyEnabled ?? false;
  }

  @override
  void dispose() {
    _nameCtl.dispose();
    _baseUrlCtl.dispose();
    _apiKeyCtl.dispose();
    _proxyUrlCtl.dispose();
    _oauthClientIdCtl.dispose();
    _oauthClientSecretCtl.dispose();
    _oauthTokenUrlCtl.dispose();
    super.dispose();
  }

  Site _buildSite() {
    return Site(
      id: widget.existing?.id ?? 0,
      name: _nameCtl.text.trim(),
      platform: _selectedPlatform,
      baseUrl: _baseUrlCtl.text.trim(),
      apiKey: _apiKeyCtl.text.trim(),
      enabled: _enabled,
      proxyEnabled: _proxyEnabled,
      proxyUrl: _proxyUrlCtl.text.trim().isEmpty ? null : _proxyUrlCtl.text.trim(),
      authType: _selectedAuthType,
      oauthClientId: _oauthClientIdCtl.text.trim().isEmpty ? null : _oauthClientIdCtl.text.trim(),
      oauthClientSecret: _oauthClientSecretCtl.text.trim().isEmpty ? null : _oauthClientSecretCtl.text.trim(),
      oauthTokenUrl: _oauthTokenUrlCtl.text.trim().isEmpty ? null : _oauthTokenUrlCtl.text.trim(),
      status: widget.existing?.status ?? 'active',
      accountId: widget.existing?.accountId ?? 0,
      accountName: widget.existing?.accountName,
      channelCount: widget.existing?.channelCount ?? 0,
      modelCount: widget.existing?.modelCount ?? 0,
      totalCost: widget.existing?.totalCost ?? 0,
      totalRequests: widget.existing?.totalRequests ?? 0,
      successRate: widget.existing?.successRate ?? 0,
      lastSyncAt: widget.existing?.lastSyncAt ?? 0,
      errorMessage: widget.existing?.errorMessage,
      createdAt: widget.existing?.createdAt ?? '',
      updatedAt: widget.existing?.updatedAt ?? '',
      metadata: widget.existing?.metadata,
    );
  }

  void _save() {
    final nextSite = _buildSite();
    if (nextSite.name.isEmpty || nextSite.baseUrl.isEmpty) return;
    Navigator.pop(context, nextSite);
  }

  @override
  Widget build(BuildContext context) {
    final loc = context.watch<AppProvider>().loc;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final isEdit = widget.existing != null;

    return AnimatedPadding(
      duration: AppTheme.animFast,
      padding: EdgeInsets.only(bottom: bottomInset),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.9,
        decoration: BoxDecoration(
          color: AppTheme.getSurfaceLowest(colorScheme),
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(AppTheme.radiusXXLarge),
          ),
        ),
        child: SafeArea(
          top: false,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppTheme.spacingLg,
                  AppTheme.spacingMd,
                  AppTheme.spacingLg,
                  AppTheme.spacingSm,
                ),
                child: Row(
                  children: [
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: () => Navigator.pop(context),
                      child: Text(loc.t('cancel')),
                    ),
                    Expanded(
                      child: Text(
                        isEdit ? loc.t('edit_site') : loc.t('create_site'),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ),
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: _save,
                      child: Text(loc.t('save')),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(
                    AppTheme.spacingLg,
                    0,
                    AppTheme.spacingLg,
                    AppTheme.spacingLg,
                  ),
                  children: [
                    _SectionTitle(title: loc.t('overview')),
                    _SheetField(
                      controller: _nameCtl,
                      placeholder: loc.t('site_name'),
                    ),
                    const SizedBox(height: AppTheme.spacingMd),
                    _PickerField<String>(
                      label: loc.t('site_platform'),
                      value: _selectedPlatform,
                      items: const {
                        'openai': 'OpenAI',
                        'anthropic': 'Anthropic',
                        'google': 'Google',
                        'azure': 'Azure',
                        'custom': 'Custom',
                      },
                      onChanged: (value) =>
                          setState(() => _selectedPlatform = value),
                    ),
                    const SizedBox(height: AppTheme.spacingMd),
                    _SheetField(
                      controller: _baseUrlCtl,
                      placeholder: loc.t('site_base_url'),
                    ),
                    const SizedBox(height: AppTheme.spacingMd),
                    _PickerField<String>(
                      label: loc.t('site_auth_type'),
                      value: _selectedAuthType,
                      items: const {
                        'api_key': 'API Key',
                        'oauth': 'OAuth',
                        'token': 'Token',
                      },
                      onChanged: (value) =>
                          setState(() => _selectedAuthType = value),
                    ),
                    const SizedBox(height: AppTheme.spacingMd),
                    if (_selectedAuthType == 'api_key') ...[
                      _SheetField(
                        controller: _apiKeyCtl,
                        placeholder: loc.t('api_key'),
                      ),
                    ] else if (_selectedAuthType == 'oauth') ...[
                      _SheetField(
                        controller: _oauthClientIdCtl,
                        placeholder: loc.t('site_oauth_client_id'),
                      ),
                      const SizedBox(height: AppTheme.spacingMd),
                      _SheetField(
                        controller: _oauthClientSecretCtl,
                        placeholder: loc.t('site_oauth_client_secret'),
                      ),
                      const SizedBox(height: AppTheme.spacingMd),
                      _SheetField(
                        controller: _oauthTokenUrlCtl,
                        placeholder: loc.t('site_oauth_token_url'),
                      ),
                    ],
                    const SizedBox(height: AppTheme.spacingLg),
                    _SectionTitle(title: loc.t('advanced_settings')),
                    _SwitchRow(
                      title: loc.t('enabled'),
                      value: _enabled,
                      onChanged: (value) => setState(() => _enabled = value),
                    ),
                    _SwitchRow(
                      title: loc.t('site_proxy_enabled'),
                      value: _proxyEnabled,
                      onChanged: (value) =>
                          setState(() => _proxyEnabled = value),
                    ),
                    if (_proxyEnabled) ...[
                      const SizedBox(height: AppTheme.spacingMd),
                      _SheetField(
                        controller: _proxyUrlCtl,
                        placeholder: loc.t('site_proxy_url'),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppTheme.spacingSm),
      child: Text(
        title,
        style: theme.textTheme.footnote?.copyWith(
          fontWeight: FontWeight.w600,
          color: colorScheme.onSurface,
        ),
      ),
    );
  }
}

class _SheetField extends StatelessWidget {
  final TextEditingController controller;
  final String placeholder;

  const _SheetField({
    required this.controller,
    required this.placeholder,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoTextField(
      controller: controller,
      placeholder: placeholder,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: CupertinoColors.systemGrey5.resolveFrom(context),
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
      ),
    );
  }
}

class _SwitchRow extends StatelessWidget {
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SwitchRow({
    required this.title,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppTheme.spacingSm),
      child: Row(
        children: [
          Expanded(child: Text(title)),
          CupertinoSwitch(value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}

class _PickerField<T> extends StatelessWidget {
  final String label;
  final T value;
  final Map<T, String> items;
  final ValueChanged<T> onChanged;

  const _PickerField({
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: AppTheme.spacingXs),
          child: Text(
            label,
            style: theme.textTheme.caption?.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: CupertinoColors.systemGrey5.resolveFrom(context),
            borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<T>(
              value: value,
              isExpanded: true,
              icon: Icon(
                Icons.arrow_drop_down,
                color: colorScheme.onSurfaceVariant,
              ),
              items: items.entries
                  .map(
                    (entry) => DropdownMenuItem<T>(
                      value: entry.key,
                      child: Text(entry.value),
                    ),
                  )
                  .toList(),
              onChanged: (nextValue) {
                if (nextValue != null) onChanged(nextValue);
              },
            ),
          ),
        ),
      ],
    );
  }
}
