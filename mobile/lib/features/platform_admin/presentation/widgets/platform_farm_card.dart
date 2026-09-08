import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n_context.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../../data/models/platform_admin_models.dart';

/// Одна ферма в платформенной админке: чья она, на каком тарифе и сколько уже
/// израсходовала из своих пределов.
///
/// Потребление показано полосой рядом с точным числом, а не одним числом:
/// «48 из 200» и «48 из 50» читаются одинаково, пока не сравнишь их
/// глазами, — а именно это и есть вопрос админа, кому пора менять тариф.
class PlatformFarmCard extends StatelessWidget {
  const PlatformFarmCard({
    super.key,
    required this.farm,
    required this.onChangePlan,
  });

  final PlatformFarm farm;
  final VoidCallback onChangePlan;

  @override
  Widget build(BuildContext context) {
    final owner = farm.owner;

    return AppCard(
      variant:
          farm.isAtLimit ? AppCardVariant.error : AppCardVariant.default_,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  farm.name,
                  style: AppTypography.titleMd
                      .copyWith(color: context.colors.onSurface),
                  maxLines: 2,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              _PlanChip(plan: farm.plan),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            // Владельца может не быть ровно один момент — между созданием
            // фермы и созданием её хозяина при регистрации.
            owner == null
                ? context.l10n.platformOwnerMissing
                : [owner.fullName, owner.email, owner.phone]
                    .whereType<String>()
                    .where((part) => part.trim().isNotEmpty)
                    .join(' · '),
            style: AppTypography.labelSm
                .copyWith(color: context.colors.onSurfaceVariant),
          ),
          const SizedBox(height: AppSpacing.lg),
          _UsageRow(
            icon: Icons.pets_outlined,
            label: context.l10n.platformRabbits,
            used: farm.rabbitsCount,
            limit: farm.plan?.maxRabbits,
          ),
          _UsageRow(
            icon: Icons.groups_outlined,
            label: context.l10n.platformStaff,
            used: farm.staffCount,
            limit: farm.plan?.maxStaff,
          ),
          if (farm.isAtLimit || farm.isNearLimit) ...[
            const SizedBox(height: AppSpacing.sm),
            _LimitNote(atLimit: farm.isAtLimit),
          ],
          const SizedBox(height: AppSpacing.sm),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: onChangePlan,
              icon: const Icon(Icons.sell_outlined, size: 18),
              label: Text(farm.plan == null
                  ? context.l10n.platformAssignPlan
                  : context.l10n.platformChangePlan),
            ),
          ),
        ],
      ),
    );
  }
}

/// Тариф фермы ярлыком. Без тарифа — тоже состояние, и молчать о нём нельзя:
/// такая ферма работает без ограничений.
class _PlanChip extends StatelessWidget {
  const _PlanChip({required this.plan});

  final Plan? plan;

  @override
  Widget build(BuildContext context) {
    final color =
        plan == null ? context.colors.onSurfaceVariant : context.accent;
    final label = plan == null
        ? context.l10n.platformNoPlan
        : plan!.isActive
            ? plan!.name
            : '${plan!.name} · ${context.l10n.platformPlanInactive}';

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: AppTypography.labelSm.copyWith(color: color),
      ),
    );
  }
}

/// Расход одного ресурса. Полоса рисуется только когда есть от чего считать
/// долю: у фермы без предела делить не на что, и пустая полоса читалась бы
/// как «ничего не израсходовано».
class _UsageRow extends StatelessWidget {
  const _UsageRow({
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

class _LimitNote extends StatelessWidget {
  const _LimitNote({required this.atLimit});

  final bool atLimit;

  @override
  Widget build(BuildContext context) {
    final color = atLimit ? AppColors.error : AppColors.warning;

    return Row(
      children: [
        Icon(Icons.warning_amber_rounded, size: 16, color: color),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Text(
            atLimit
                ? context.l10n.platformAtLimit
                : context.l10n.platformNearLimit,
            style: AppTypography.labelSm.copyWith(color: color),
          ),
        ),
      ],
    );
  }
}
