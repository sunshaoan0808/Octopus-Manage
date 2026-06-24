import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:octopusmanage/l10n/app_localizations.dart';
import 'package:octopusmanage/models/site.dart';
import 'package:octopusmanage/providers/app_provider.dart';
import 'package:octopusmanage/theme/app_theme.dart';
import 'package:octopusmanage/widgets/app_card.dart';
import 'package:octopusmanage/widgets/app_chips.dart';
import 'package:octopusmanage/widgets/app_empty_state.dart';
import 'package:octopusmanage/widgets/app_error_dialog.dart';
import 'package:provider/provider.dart';

class SiteDetailPage extends StatefulWidget {
  final Site site;

  const SiteDetailPage({super.key, required this.site});

  @override
  State<SiteDetailPage> createState() => _SiteDetailPageState();
}

class _SiteDetailPageState extends State<SiteDetailPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late Site _site;
  List<SiteAccount> _accounts = [];
  List<SiteToken> _tokens = [];
  List<SiteModel> _models = [];
  bool _loadingAccounts = false;
  bool _loadingTokens = false;
  bool _loadingModels = false;
  bool _syncing = false;

  @override
  void initState() {
    super.initState();
    _site = widget.site;
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(_onTabChanged);
    _loadTabData(0);
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    super.dispose();
  }

  void _onTabChanged() {
    if (!_tabController.indexIsChanging) return;
    _loadTabData(_tabController.index);
  }

  Future<void> _loadTabData(int index) async {
    if (!mounted) return;
    final api = context.read<AppProvider>().api;

    switch (index) {
      case 0:
        // Overview - refresh site data
        try {
          final updated = await api.getSite(_site.id);
          if (mounted) setState(() => _site = updated);
        } catch (_) {}
        break;
      case 1:
        if (_accounts.isNotEmpty) return;
        setState(() => _loadingAccounts = true);
        try {
          final data = await api.getSiteAccounts(_site.id);
          if (mounted) setState(() => _accounts = data);
        } catch (e) {
          if (mounted) await showErrorDialog(context, e.toString());
        } finally {
          if (mounted) setState(() => _loadingAccounts = false);
        }
        break;
      case 2:
        if (_tokens.isNotEmpty) return;
        setState(() => _loadingTokens = true);
        try {
          final data = await api.getSiteTokens(_site.id);
          if (mounted) setState(() => _tokens = data);
        } catch (e) {
          if (mounted) await showErrorDialog(context, e.toString());
        } finally {
          if (mounted) setState(() => _loadingTokens = false);
        }
        break;
      case 3:
        if (_models.isNotEmpty) return;
        setState(() => _loadingModels = true);
        try {
          final data = await api.getSiteModels(_site.id);
          if (mounted) setState(() => _models = data);
        } catch (e) {
          if (mounted) await showErrorDialog(context, e.toString());
        } finally {
          if (mounted) setState(() => _loadingModels = false);
        }
        break;
    }
  }

  Future<void> _syncSite(AppLocalizations loc) async {
    if (_syncing) return;
    setState(() => _syncing = true);
    try {
      final api = context.read<AppProvider>().api;
      final updated = await api.getSite(_site.id);
      if (mounted) {
        setState(() => _site = updated);
        // Reload current tab data
        _accounts = [];
        _tokens = [];
        _models = [];
        _loadTabData(_tabController.index);
      }
    } catch (e) {
      if (mounted) {
        await showErrorDialog(context, e.toString());
      }
    } finally {
      if (mounted) setState(() => _syncing = false);
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

  @override
  Widget build(BuildContext context) {
    final loc = context.watch<AppProvider>().loc;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return CupertinoPageScaffold(
      backgroundColor: AppTheme.getSurfaceLowest(colorScheme),
      child: SafeArea(
        child: Column(
          children: [
            // Header
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
                    child: Icon(
                      CupertinoIcons.back,
                      color: colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: AppTheme.spacingSm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _site.name,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            AppTypeChip(
                              label: _site.platform.toUpperCase(),
                              color: AppTheme.colorBlue,
                            ),
                            const SizedBox(width: AppTheme.spacingXs),
                            AppTypeChip(
                              label: _statusLabel(_site.status, loc),
                              color: _statusColor(_site.status),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: _syncing ? null : () => _syncSite(loc),
                    child: _syncing
                        ? const CupertinoActivityIndicator(radius: 10)
                        : Icon(
                            CupertinoIcons.refresh,
                            size: 22,
                            color: colorScheme.primary,
                          ),
                  ),
                ],
              ),
            ),
            // Tab bar
            Container(
              decoration: BoxDecoration(
                color: AppTheme.getSurfaceLow(colorScheme),
                border: Border(
                  bottom: BorderSide(
                    color: colorScheme.outlineVariant.withValues(alpha: 0.3),
                    width: 0.5,
                  ),
                ),
              ),
              child: TabBar(
                controller: _tabController,
                labelColor: colorScheme.primary,
                unselectedLabelColor: colorScheme.onSurfaceVariant,
                indicatorColor: colorScheme.primary,
                indicatorSize: TabBarIndicatorSize.label,
                labelStyle: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                ),
                tabs: [
                  Tab(text: loc.t('overview')),
                  Tab(text: loc.t('site_accounts')),
                  Tab(text: loc.t('site_tokens')),
                  Tab(text: loc.t('site_models')),
                ],
              ),
            ),
            // Tab content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildOverviewTab(loc, colorScheme),
                  _buildAccountsTab(loc, colorScheme),
                  _buildTokensTab(loc, colorScheme),
                  _buildModelsTab(loc, colorScheme),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewTab(AppLocalizations loc, ColorScheme colorScheme) {
    return ListView(
      padding: const EdgeInsets.all(AppTheme.spacingLg),
      children: [
        _InfoCard(
          title: loc.t('overview'),
          children: [
            _InfoRow(label: loc.t('site_name'), value: _site.name),
            _InfoRow(label: loc.t('site_platform'), value: _site.platform),
            _InfoRow(label: loc.t('site_base_url'), value: _site.baseUrl),
            _InfoRow(label: loc.t('site_auth_type'), value: _site.authType),
            _InfoRow(
              label: loc.t('enabled'),
              value: _site.enabled ? loc.t('enabled') : loc.t('disabled'),
            ),
            if (_site.proxyEnabled)
              _InfoRow(label: loc.t('site_proxy_url'), value: _site.proxyUrl ?? loc.t('not_set')),
          ],
        ),
        const SizedBox(height: AppTheme.spacingLg),
        _InfoCard(
          title: loc.t('dashboard'),
          children: [
            _InfoRow(
              label: loc.t('site_channel_count'),
              value: '${_site.channelCount}',
            ),
            _InfoRow(
              label: loc.t('site_model_count'),
              value: '${_site.modelCount}',
            ),
            _InfoRow(
              label: loc.t('site_total_cost'),
              value: _site.totalCost.toStringAsFixed(2),
            ),
            _InfoRow(
              label: loc.t('site_total_requests'),
              value: '${_site.totalRequests}',
            ),
            _InfoRow(
              label: loc.t('site_success_rate'),
              value: '${(_site.successRate * 100).toStringAsFixed(1)}%',
            ),
            _InfoRow(
              label: loc.t('site_last_sync'),
              value: _site.lastSyncAt > 0
                  ? DateTime.fromMillisecondsSinceEpoch(
                      _site.lastSyncAt * 1000,
                    ).toString()
                  : loc.t('never'),
            ),
          ],
        ),
        if (_site.status == 'error' && _site.errorMessage != null) ...[
          const SizedBox(height: AppTheme.spacingLg),
          _InfoCard(
            title: loc.t('site_error_message'),
            children: [
              Text(
                _site.errorMessage!,
                style: TextStyle(
                  fontSize: 14,
                  color: colorScheme.error,
                ),
              ),
            ],
          ),
        ],
        const SizedBox(height: AppTheme.spacingLg),
        _InfoCard(
          title: loc.t('settings'),
          children: [
            _InfoRow(
              label: loc.t('site_oauth_client_id'),
              value: _site.oauthClientId ?? loc.t('not_set'),
            ),
            _InfoRow(
              label: loc.t('site_oauth_token_url'),
              value: _site.oauthTokenUrl ?? loc.t('not_set'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAccountsTab(AppLocalizations loc, ColorScheme colorScheme) {
    if (_loadingAccounts) {
      return const Center(child: CupertinoActivityIndicator());
    }
    if (_accounts.isEmpty) {
      return AppEmptyState(
        icon: CupertinoIcons.person_2,
        title: loc.t('no_data'),
        subtitle: loc.t('site_accounts'),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(AppTheme.spacingLg),
      itemCount: _accounts.length,
      itemBuilder: (context, index) {
        final account = _accounts[index];
        return AppCard(
          margin: const EdgeInsets.only(bottom: AppTheme.spacingMd),
          padding: const EdgeInsets.all(AppTheme.spacingLg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      account.name,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ),
                  AppTypeChip(
                    label: account.status,
                    color: account.status == 'active'
                        ? AppTheme.colorGreen
                        : AppTheme.colorGray,
                  ),
                ],
              ),
              const SizedBox(height: AppTheme.spacingSm),
              _InfoRow(label: loc.t('username'), value: account.email),
              if (account.plan != null)
                _InfoRow(label: loc.t('site_account_plan'), value: account.plan!),
              _InfoRow(
                label: loc.t('site_account_balance'),
                value: account.balance.toStringAsFixed(2),
              ),
              _InfoRow(
                label: loc.t('site_account_total_spent'),
                value: account.totalSpent.toStringAsFixed(2),
              ),
              _InfoRow(
                label: loc.t('site_account_requests_used'),
                value: '${account.requestsUsed} / ${account.requestLimit}',
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTokensTab(AppLocalizations loc, ColorScheme colorScheme) {
    if (_loadingTokens) {
      return const Center(child: CupertinoActivityIndicator());
    }
    if (_tokens.isEmpty) {
      return AppEmptyState(
        icon: CupertinoIcons.lock,
        title: loc.t('no_data'),
        subtitle: loc.t('site_tokens'),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(AppTheme.spacingLg),
      itemCount: _tokens.length,
      itemBuilder: (context, index) {
        final token = _tokens[index];
        return AppCard(
          margin: const EdgeInsets.only(bottom: AppTheme.spacingMd),
          padding: const EdgeInsets.all(AppTheme.spacingLg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      token.name,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ),
                  CupertinoSwitch(
                    value: token.enabled,
                    onChanged: null, // Read-only in detail view
                  ),
                ],
              ),
              const SizedBox(height: AppTheme.spacingSm),
              _InfoRow(
                label: loc.t('site_token_masked'),
                value: token.tokenMasked,
              ),
              _InfoRow(
                label: loc.t('site_token_expires'),
                value: token.expiresAt > 0
                    ? DateTime.fromMillisecondsSinceEpoch(
                        token.expiresAt * 1000,
                      ).toString()
                    : loc.t('never'),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildModelsTab(AppLocalizations loc, ColorScheme colorScheme) {
    if (_loadingModels) {
      return const Center(child: CupertinoActivityIndicator());
    }
    if (_models.isEmpty) {
      return AppEmptyState(
        icon: CupertinoIcons.cube_box,
        title: loc.t('no_data'),
        subtitle: loc.t('site_models'),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(AppTheme.spacingLg),
      itemCount: _models.length,
      itemBuilder: (context, index) {
        final model = _models[index];
        return AppCard(
          margin: const EdgeInsets.only(bottom: AppTheme.spacingMd),
          padding: const EdgeInsets.all(AppTheme.spacingLg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      model.modelName,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ),
                  AppTypeChip(
                    label: model.provider,
                    color: AppTheme.colorBlue,
                  ),
                ],
              ),
              const SizedBox(height: AppTheme.spacingSm),
              _InfoRow(
                label: loc.t('site_model_input_price'),
                value: model.inputPrice.toStringAsFixed(6),
              ),
              _InfoRow(
                label: loc.t('site_model_output_price'),
                value: model.outputPrice.toStringAsFixed(6),
              ),
              _InfoRow(
                label: loc.t('site_model_context_window'),
                value: '${model.contextWindow}',
              ),
            ],
          ),
        );
      },
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _InfoCard({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AppCard(
      padding: const EdgeInsets.all(AppTheme.spacingLg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.footnote?.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppTheme.spacingMd),
          ...children,
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppTheme.spacingSm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: theme.textTheme.caption?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                color: colorScheme.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
