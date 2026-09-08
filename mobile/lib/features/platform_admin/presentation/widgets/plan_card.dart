import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n_context.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../../data/models/platform_admin_models.dart';
import 'plan_summary.dart';

/// Тариф в списке платформенной админки.
class PlanCard extends StatelessWidget {
  const PlanCard({
    super.key,
    required this.plan,
    required this.onEdit,
    required this.onDelete,
  });

  final Plan plan;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    // Выключенный тариф приглушён целиком: он остаётся в списке, но выдавать
    // его нельзя, и выглядеть наравне с рабочими он не должен.
    final titleColor = plan.isActive
        ? context.colors.onSurface
        : context.colors.onSurfaceVariant;

    return AppCard(
      onTap: onEdit,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        plan.name,
                        style: AppTypography.titleMd.copyWith(color: titleColor),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (!plan.isActive) ...[
                      const SizedBox(width: AppSpacing.sm),
                      Text(
                        context.l10n.platformPlanInactive,
                        style: AppTypography.labelSm
                            .copyWith(color: AppColors.warning),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  planLimitsSummary(context, plan),
                  style: AppTypography.bodyMd
                      .copyWith(color: context.colors.onSurfaceVariant),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Text(
            planPriceLabel(context, plan),
            style: AppTypography.labelLg.copyWith(color: titleColor),
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'edit') onEdit();
              if (value == 'delete') onDelete();
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'edit',
                child: Text(context.l10n.platformPlanEdit),
              ),
              PopupMenuItem(
                value: 'delete',
                child: Text(
                  context.l10n.commonDelete,
                  style: const TextStyle(color: AppColors.error),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
