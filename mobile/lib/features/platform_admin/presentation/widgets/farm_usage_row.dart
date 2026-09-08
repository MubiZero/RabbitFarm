import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n_context.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';

/// Расход одного ресурса фермы против её предела.
///
/// Полоса рисуется только когда есть от чего считать долю: у фермы без предела
/// делить не на что, и пустая полоса читалась бы как «ничего не израсходовано».
///
/// Общая для списка ферм и карточки одной фермы: там и там вопрос один и тот
/// же — кому пора менять тариф, — и подписи расходиться не должны.
class FarmUsageRow extends StatelessWidget {
  const FarmUsageRow({
    super.key,
    required this.icon,
    required this.label,
    required this.used,
    required this.limit,
  });

  final IconData icon;
  final String label;
  final int used;
  final int? limit;

  @override
  Widget build(BuildContext context) {
    if (limit == null || limit! <= 0) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
        child: Row(
          children: [
            Icon(icon, size: 16, color: context.colors.onSurfaceVariant),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                label,
                style: AppTypography.bodyMd
                    .copyWith(color: context.colors.onSurface),
              ),
            ),
            Text(
              context.l10n.platformUsageUnlimited(used),
              style: AppTypography.labelLg
                  .copyWith(color: context.colors.onSurfaceVariant),
            ),
          ],
        ),
      );
    }

    final fraction = used / limit!;

    return MetricBar(
      icon: icon,
      label: label,
      value: context.l10n.platformUsageOfLimit(used, limit!),
      fraction: fraction,
      color: fraction >= 1
          ? AppColors.error
          : fraction >= 0.8
              ? AppColors.warning
              : context.accent,
    );
  }
}
