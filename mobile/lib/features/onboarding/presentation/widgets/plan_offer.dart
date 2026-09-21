import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n_context.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/utils/format_utils.dart';
import '../../../subscription/data/models/plan_option.dart';

/// Тариф, подобранный по ответам знакомства.
///
/// Крупно — то, что человек хочет знать: сколько это стоит и что в него
/// помещается. Подобранный тариф выделен, но нажимаются все карточки:
/// подсказка — не приговор, хозяйство знает свои планы лучше нас.
class PlanOfferCard extends StatelessWidget {
  const PlanOfferCard({
    super.key,
    required this.plan,
    this.highlighted = true,
    this.onTap,
  });

  final PlanOption plan;
  final bool highlighted;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final cs = context.colors;

    return Material(
      color: highlighted ? cs.primaryContainer : cs.surface,
      borderRadius: AppRadius.lgAll,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.lgAll,
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            borderRadius: AppRadius.lgAll,
            border: Border.all(
              color: highlighted ? context.accent : cs.outline,
              width: highlighted ? 2 : 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (highlighted) ...[
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: AppSpacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: context.accent,
                    borderRadius: AppRadius.pillAll,
                  ),
                  child: Text(
                    l10n.onbPlanRecommended,
                    style: AppTypography.labelSm.copyWith(
                      color: AppColors.onAccent,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
              ],
              Text(
                plan.name,
                style: AppTypography.titleLg.copyWith(color: cs.onSurface),
              ),
              const SizedBox(height: AppSpacing.xs),
              _Price(plan: plan, big: highlighted),
              const SizedBox(height: AppSpacing.md),
              _Line(
                icon: Icons.pets_outlined,
                text: plan.maxRabbits == null
                    ? l10n.onbPlanRabbitsUnlimited
                    : l10n.onbPlanRabbits(plan.maxRabbits!),
              ),
              const SizedBox(height: AppSpacing.xs),
              _Line(
                icon: Icons.group_outlined,
                text: plan.maxStaff == null
                    ? l10n.onbPlanStaffUnlimited
                    : l10n.onbPlanStaff(plan.maxStaff!),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Price extends StatelessWidget {
  const _Price({required this.plan, required this.big});

  final PlanOption plan;
  final bool big;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final cs = context.colors;

    if (plan.isFree) {
      return Text(
        l10n.onbPlanFree,
        style: (big ? AppTypography.displayMd : AppTypography.titleMd)
            .copyWith(color: context.accent),
      );
    }

    // Тарифы сервиса считаются в сомони всегда: это наша валюта, а не валюта
    // хозяйства (см. FarmCurrencyScope).
    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Text(
          formatMoney(plan.price!),
          style: (big ? AppTypography.displayMd : AppTypography.titleMd)
              .copyWith(color: context.accent),
        ),
        const SizedBox(width: AppSpacing.sm),
        Text(
          l10n.onbPlanPerMonth,
          style: AppTypography.bodyMd.copyWith(color: cs.onSurfaceVariant),
        ),
      ],
    );
  }
}

class _Line extends StatelessWidget {
  const _Line({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final cs = context.colors;

    return Row(
      children: [
        Icon(icon, size: 18, color: cs.onSurfaceVariant),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Text(
            text,
            style: AppTypography.bodyMd.copyWith(color: cs.onSurface),
          ),
        ),
      ],
    );
  }
}
