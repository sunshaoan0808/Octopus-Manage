import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:octopusmanage/l10n/app_localizations.dart';
import 'package:octopusmanage/models/user.dart';
import 'package:octopusmanage/providers/app_provider.dart';
import 'package:octopusmanage/theme/app_theme.dart';
import 'package:octopusmanage/widgets/app_chips.dart';
import 'package:octopusmanage/widgets/app_dialogs.dart';
import 'package:octopusmanage/widgets/app_empty_state.dart';
import 'package:octopusmanage/widgets/app_error_dialog.dart';
import 'package:octopusmanage/widgets/app_list_tile.dart';
import 'package:provider/provider.dart';

const _roles = ['admin', 'editor', 'viewer'];

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  List<User> _users = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    if (!mounted) return;
    setState(() => _loading = true);
    try {
      final api = context.read<AppProvider>().api;
      _users = await api.getUsers();
    } catch (e) {
      if (mounted) {
        showErrorDialog(context, e.toString());
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _deleteUser(User user, AppLocalizations loc) async {
    final confirmed = await AppConfirmDialog.show(
      context: context,
      title: loc.t('delete_user'),
      content: loc.t('delete_confirm', {'name': user.username}),
      confirmText: loc.t('delete'),
      cancelText: loc.t('cancel'),
      isDanger: true,
    );
    if (!confirmed) return;
    try {
      if (!mounted) return;
      final api = context.read<AppProvider>().api;
      await api.deleteUser(user.id);
      _loadUsers();
    } catch (e) {
      if (mounted) {
        showErrorDialog(context, e.toString());
      }
    }
  }

  Future<void> _changeRole(User user, AppLocalizations loc) async {
    String selectedRole = user.role;
    await showCupertinoModalPopup(
      context: context,
      builder: (ctx) => CupertinoActionSheet(
        title: Text(loc.t('change_role_for', {'name': user.username})),
        message: Text(loc.t('current_role', {'role': loc.t('role_$selectedRole')})),
        actions: _roles.map((role) {
          final isCurrent = role == user.role;
          return CupertinoActionSheetAction(
            onPressed: () {
              selectedRole = role;
              Navigator.pop(ctx);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (isCurrent)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Icon(CupertinoIcons.checkmark_alt, size: 18,
                      color: CupertinoTheme.of(ctx).primaryColor),
                  ),
                Text(loc.t('role_$role')),
              ],
            ),
          );
        }).toList()
          ..add(
            CupertinoActionSheetAction(
              isDefaultAction: true,
              onPressed: () => Navigator.pop(ctx),
              child: Text(loc.t('cancel')),
            ),
          ),
      ),
    );

    if (selectedRole == user.role) return;
    try {
      if (!mounted) return;
      final api = context.read<AppProvider>().api;
      await api.updateUserRole(user.id, selectedRole);
      _loadUsers();
    } catch (e) {
      if (mounted) {
        showErrorDialog(context, e.toString());
      }
    }
  }

  Future<void> _showCreateUserDialog() async {
    final loc = context.read<AppProvider>().loc;
    final usernameCtl = TextEditingController();
    final passwordCtl = TextEditingController();
    String role = 'viewer';

    final result = await showCupertinoDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => CupertinoAlertDialog(
          title: Text(loc.t('create_user')),
          content: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Material(
              color: Colors.transparent,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CupertinoTextField(
                    controller: usernameCtl,
                    placeholder: loc.t('username'),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: CupertinoColors.systemGrey5.resolveFrom(ctx),
                      borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacingMd),
                  CupertinoTextField(
                    controller: passwordCtl,
                    placeholder: loc.t('password'),
                    obscureText: true,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: CupertinoColors.systemGrey5.resolveFrom(ctx),
                      borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacingMd),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(loc.t('role')),
                      CupertinoSegmentedControl<String>(
                        groupValue: role,
                        onValueChanged: (v) => setDialogState(() => role = v),
                        children: {
                          for (final r in _roles)
                            r: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              child: Text(loc.t('role_$r'), style: const TextStyle(fontSize: 13)),
                            ),
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          actions: [
            CupertinoDialogAction(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text(loc.t('cancel')),
            ),
            CupertinoDialogAction(
              isDefaultAction: true,
              onPressed: () => Navigator.pop(ctx, true),
              child: Text(loc.t('create')),
            ),
          ],
        ),
      ),
    );

    final username = usernameCtl.text.trim();
    final password = passwordCtl.text;

    usernameCtl.dispose();
    passwordCtl.dispose();

    if (result != true || username.isEmpty || password.isEmpty) return;

    try {
      if (!mounted) return;
      final api = context.read<AppProvider>().api;
      await api.createUser(username, password, role);
      _loadUsers();
    } catch (e) {
      if (mounted) {
        showErrorDialog(context, e.toString());
      }
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
        bottom: false,
        child: Stack(
          children: [
            CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              slivers: [
                CupertinoSliverNavigationBar(
                  largeTitle: Text(loc.t('users')),
                  backgroundColor: AppTheme.getSurfaceLowest(colorScheme)
                      .withValues(alpha: 0.85),
                  border: null,
                ),
                CupertinoSliverRefreshControl(onRefresh: _loadUsers),
                if (_loading)
                  const SliverFillRemaining(
                    hasScrollBody: false,
                    child: AppLoadingState(),
                  )
                else if (_users.isEmpty)
                  SliverFillRemaining(
                    child: AppEmptyState(
                      icon: CupertinoIcons.person_2,
                      title: loc.t('no_users'),
                      subtitle: loc.t('create_first_user'),
                      action: CupertinoButton.filled(
                        onPressed: _showCreateUserDialog,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(CupertinoIcons.add, size: 18),
                            const SizedBox(width: 4),
                            Text(loc.t('create_user')),
                          ],
                        ),
                      ),
                    ),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.only(bottom: 96),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final user = _users[index];
                        return AppListTile(
                          margin: const EdgeInsets.fromLTRB(
                            AppTheme.spacingLg,
                            AppTheme.spacingSm,
                            AppTheme.spacingLg,
                            0,
                          ),
                          leading: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: AppTheme.getRoleColor(user.role)
                                  .withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                            ),
                            child: Center(
                              child: Text(
                                user.username.isNotEmpty
                                    ? user.username[0].toUpperCase()
                                    : '?',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.getRoleColor(user.role),
                                ),
                              ),
                            ),
                          ),
                          title: Text(
                            user.username,
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w500,
                              color: colorScheme.onSurface,
                            ),
                          ),
                          subtitle: AppInfoChip(
                            icon: CupertinoIcons.shield,
                            label: loc.t('role_${user.role}'),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              GestureDetector(
                                onTap: () => _changeRole(user, loc),
                                child: Icon(
                                  CupertinoIcons.pencil,
                                  size: 20,
                                  color: colorScheme.primary,
                                ),
                              ),
                              const SizedBox(width: AppTheme.spacingMd),
                              GestureDetector(
                                onTap: () => _deleteUser(user, loc),
                                child: Icon(
                                  CupertinoIcons.delete,
                                  size: 20,
                                  color: colorScheme.error,
                                ),
                              ),
                            ],
                          ),
                        );
                      }, childCount: _users.length),
                    ),
                  ),
              ],
            ),
            if (!_loading)
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
                    onPressed: _showCreateUserDialog,
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
                          loc.t('create_user'),
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
}
