import 'package:flutter/material.dart';
import '../l10n/l10n_context.dart';
import '../theme/app_colors.dart';

/// Экран отказа по лимиту тарифа — вместо сырого текста ошибки.
///
/// `RABBIT_LIMIT_REACHED`/`STAFF_LIMIT_REACHED` не чинятся повтором запроса:
/// ферме нужен другой тариф. Показывать их в снекбаре как обычную ошибку
/// было бы честно, но бесполезно — человек не поймёт, что делать дальше.
Future<void> showPlanLimitReachedDialog(
  BuildContext context, {
  required String title,
  required String body,
}) {
  return showDialog<void>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      icon: const Icon(Icons.lock_outline, color: AppColors.warning),
      title: Text(title),
      content: Text(body),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext),
          child: Text(dialogContext.l10n.commonClose),
        ),
      ],
    ),
  );
}
