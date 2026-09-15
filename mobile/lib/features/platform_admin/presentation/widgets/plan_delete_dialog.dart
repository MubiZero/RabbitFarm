import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n_context.dart';
import '../../../../core/theme/theme.dart';
import '../../data/models/platform_admin_models.dart';

/// Подтверждение удаления тарифа: что именно произойдёт и чего уже не
/// отменить.
///
/// Тариф стирается физически, `plan_id` у ферм обнуляется, обратного хода
/// нет — поэтому подтверждение перечисляет последствия, а не спрашивает
/// «удалить?» одним словом.
///
/// Отдельно предупреждает про тариф по умолчанию: его удаление задевает не
/// только нынешние фермы, но и все будущие регистрации — они останутся вовсе
/// без тарифа, пока таким не отмечен другой (`planService.getDefault`).
///
/// Сколько ферм сейчас на этом тарифе, здесь не написано намеренно: сервер
/// такого числа не отдаёт ни в списке тарифов, ни в сводке, а придумывать
/// его — хуже, чем промолчать.
Future<bool> showPlanDeleteDialog(BuildContext context,
    {required Plan plan}) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (dialogContext) {
      final l10n = dialogContext.l10n;

      return AlertDialog(
        title: Text(l10n.platformPlanDeleteTitle),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.platformPlanDeleteBody(plan.name)),
            if (plan.isDefault) ...[
              const SizedBox(height: AppSpacing.md),
              _Warning(l10n.platformPlanDeleteDefaultWarning),
            ],
            const SizedBox(height: AppSpacing.md),
            Text(
              l10n.platformPlanDeleteIrreversible,
              style: AppTypography.labelSm
                  .copyWith(color: dialogContext.colors.onSurfaceVariant),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(l10n.commonCancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: Text(l10n.commonDelete),
          ),
        ],
      );
    },
  );

  return confirmed == true;
}

/// Последствие, которое легко пропустить глазами, — со значком и цветом.
class _Warning extends StatelessWidget {
  const _Warning(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.warning_amber_rounded,
            size: 18, color: AppColors.warning),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Text(
            text,
            style: AppTypography.bodyMd.copyWith(color: AppColors.warning),
          ),
        ),
      ],
    );
  }
}
