import 'package:flutter/cupertino.dart';
import 'package:octopusmanage/l10n/app_localizations.dart';
import 'package:octopusmanage/providers/app_provider.dart';
import 'package:provider/provider.dart';

/// Shows a simple error dialog with the given message.
/// This is a convenience method to reduce repetitive error dialog code.
Future<void> showErrorDialog(
  BuildContext context,
  String message, {
  String? title,
}) {
  final loc = _resolveLoc(context);
  return showCupertinoDialog(
    context: context,
    builder: (dialogContext) => CupertinoAlertDialog(
      title: title != null ? Text(title) : null,
      content: Text(message),
      actions: [
        CupertinoDialogAction(
          child: Text(loc.t('ok')),
          onPressed: () => Navigator.pop(dialogContext),
        ),
      ],
    ),
  );
}

/// Shows a confirmation dialog and returns true if confirmed.
Future<bool> showConfirmDialog(
  BuildContext context, {
  required String title,
  required String content,
  String? confirmText,
  String? cancelText,
  bool isDanger = false,
}) async {
  final loc = _resolveLoc(context);
  final result = await showCupertinoDialog<bool>(
    context: context,
    builder: (dialogContext) => CupertinoAlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        CupertinoDialogAction(
          child: Text(cancelText ?? loc.t('cancel')),
          onPressed: () => Navigator.pop(dialogContext, false),
        ),
        CupertinoDialogAction(
          isDestructiveAction: isDanger,
          child: Text(confirmText ?? loc.t('ok')),
          onPressed: () => Navigator.pop(dialogContext, true),
        ),
      ],
    ),
  );
  return result == true;
}

AppLocalizations _resolveLoc(BuildContext context) {
  try {
    return context.read<AppProvider>().loc;
  } on ProviderNotFoundException {
    return AppLocalizations(AppLocale.en);
  }
}
