import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n_context.dart';
import '../../../../core/theme/theme.dart';

/// Диалог собирает только причину входа — она обязательна для журнала (см.
/// docs/plans/PLATFORM-ADMIN.md, 3.2). Сам запрос и переключение сессии
/// делает вызвавший экран: в отличие от удаления фермы, здесь нет
/// серверной ошибки, которую нужно показать прямо под полем, — обычной
/// снекбар-ошибки после закрытия диалога достаточно.
///
/// Возвращает набранную причину (обрезанную по краям) или `null`, если
/// админ передумал.
Future<String?> showFarmImpersonateDialog(
  BuildContext context, {
  required String farmName,
}) {
  return showDialog<String>(
    context: context,
    builder: (_) => _FarmImpersonateDialog(farmName: farmName),
  );
}

class _FarmImpersonateDialog extends StatefulWidget {
  const _FarmImpersonateDialog({required this.farmName});

  final String farmName;

  @override
  State<_FarmImpersonateDialog> createState() =>
      _FarmImpersonateDialogState();
}

class _FarmImpersonateDialogState extends State<_FarmImpersonateDialog> {
  final _reason = TextEditingController();
  bool _showRequired = false;

  @override
  void dispose() {
    _reason.dispose();
    super.dispose();
  }

  void _submit() {
    final reason = _reason.text.trim();
    if (reason.isEmpty) {
      setState(() => _showRequired = true);
      return;
    }
    Navigator.pop(context, reason);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return AlertDialog(
      icon: const Icon(Icons.visibility_outlined),
      title: Text(l10n.platformFarmImpersonateTitle),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              l10n.platformFarmImpersonateBody(widget.farmName),
              style: AppTypography.bodyMd
                  .copyWith(color: context.colors.onSurfaceVariant),
            ),
            const SizedBox(height: AppSpacing.lg),
            TextField(
              controller: _reason,
              autofocus: true,
              onChanged: (_) {
                if (_showRequired) setState(() => _showRequired = false);
              },
              onSubmitted: (_) => _submit(),
              decoration: InputDecoration(
                labelText: l10n.platformFarmImpersonateReasonLabel,
                hintText: l10n.platformFarmImpersonateReasonHint,
                errorText: _showRequired
                    ? l10n.platformFarmImpersonateReasonRequired
                    : null,
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.commonCancel),
        ),
        TextButton(
          onPressed: _submit,
          child: Text(l10n.platformFarmImpersonateConfirm),
        ),
      ],
    );
  }
}
