import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/l10n/l10n_context.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/utils/farm_status_labels.dart';
import '../../data/models/platform_admin_models.dart';

final _dayFormat = DateFormat('dd.MM.yyyy');

/// Состояние фермы ярлыком в списке: удалена или закрыта.
///
/// Раньше список молчал об обоих: включённый срез «Доступ закрыт» давал
/// строки, внешне неотличимые от обычных, — а решить, сработал ли фильтр,
/// было нечем, кроме как заходить в каждую ферму по очереди.
///
/// Работающая ферма ярлыка не получает вовсе: подписывать норму значит
/// приучать глаз пролистывать ярлыки мимо.
class FarmStateChip extends StatelessWidget {
  const FarmStateChip({super.key, required this.farm, this.compact = false});

  final PlatformFarm farm;

  /// Табличная строка на широком экране: там на ярлык остаётся полколонки,
  /// и дата удаления в неё уже не влезает.
  final bool compact;

  /// Ферме есть что сообщить о своём состоянии — иначе рисовать нечего.
  static bool hasState(PlatformFarm farm) => farm.isDeleted || !farm.isActive;

  @override
  Widget build(BuildContext context) {
    if (!hasState(farm)) return const SizedBox.shrink();

    // Удаление важнее доступа: у удалённой фермы статус остаётся прежним, но
    // говорить о нём уже поздно — счёт идёт до окончательной зачистки.
    final (label, color) = farm.isDeleted
        ? (
            compact
                ? context.l10n.platformFilterDeleted
                : context.l10n.platformFarmDeletedShort(
                    _dayFormat.format(farm.deletedAt!)),
            AppColors.error,
          )
        : (
            farmStatusLabel(context, farm.status),
            farmStatusColor(context, farm.status),
          );

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            farm.isDeleted
                ? Icons.delete_forever_outlined
                : farmStatusIcon(farm.status),
            size: 14,
            color: color,
          ),
          const SizedBox(width: AppSpacing.xs),
          Flexible(
            child: Text(
              label,
              style: AppTypography.labelSm.copyWith(color: color),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
