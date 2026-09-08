import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n_context.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../../data/models/platform_admin_models.dart';
import 'farm_usage_row.dart';

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
    this.onOpen,
  });

  final PlatformFarm farm;
  final VoidCallback onChangePlan;

  /// Открыть карточку фермы. Всё, чего в строке списка нет — состав, платежи,
  /// доступ, поблажки, — живёт там.
  final VoidCallback? onOpen;

  @override
  Widget build(BuildContext context) {
    final owner = farm.owner;

    return AppCard(
      onTap: onOpen,
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
          FarmUsageRow(
            icon: Icons.pets_outlined,
            label: context.l10n.platformRabbits,
            used: farm.rabbitsCount,
            limit: farm.plan?.maxRabbits,
          ),
          FarmUsageRow(
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
