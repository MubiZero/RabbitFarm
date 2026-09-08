import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/l10n/l10n_context.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../../data/models/platform_admin_models.dart';
import '../providers/platform_admin_provider.dart';
import 'plan_summary.dart';

/// Выбор тарифа для фермы.
///
/// Возвращает выбор или `null`, если лист закрыли, ничего не выбрав. Отличать
/// одно от другого обязательно: «без тарифа» — это тоже осознанный выбор, а
/// не отказ от него.
Future<({int? planId})?> showPlanPicker(
  BuildContext context, {
  required PlatformFarm farm,
}) {
  return showModalBottomSheet<({int? planId})>(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    builder: (_) => _PlanPickerSheet(farm: farm),
  );
}

class _PlanPickerSheet extends ConsumerWidget {
  const _PlanPickerSheet({required this.farm});

  final PlatformFarm farm;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(bottom: AppSpacing.sm),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screenH,
                0,
                AppSpacing.screenH,
                AppSpacing.md,
              ),
              child: Text(
                context.l10n.platformPlanSheetTitle(farm.name),
                style: AppTypography.titleMd
                    .copyWith(color: context.colors.onSurface),
              ),
            ),
            Flexible(
              child: AppAsyncView<List<Plan>>(
                value: ref.watch(platformPlansProvider),
                onRetry: () => ref.invalidate(platformPlansProvider),
                builder: (plans) => _PlanOptions(farm: farm, plans: plans),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PlanOptions extends StatelessWidget {
  const _PlanOptions({required this.farm, required this.plans});

  final PlatformFarm farm;
  final List<Plan> plans;

  @override
  Widget build(BuildContext context) {
    final currentId = farm.plan?.id;

    // Выключенный тариф выдать нельзя (сервер откажет), но у фермы, которой
    // его уже назначили, он остаётся — и в списке должен быть виден, иначе
    // текущий выбор выглядел бы как «без тарифа».
    final selectable = [
      for (final plan in plans)
        if (plan.isActive || plan.id == currentId) plan,
    ];

    return ListView(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      children: [
        ListTile(
          leading: Icon(
            currentId == null
                ? Icons.radio_button_checked
                : Icons.radio_button_unchecked,
            color: currentId == null
                ? context.accent
                : context.colors.onSurfaceVariant,
          ),
          title: Text(context.l10n.platformPlanOff),
          onTap: () => Navigator.pop(context, (planId: null)),
        ),
        for (final plan in selectable)
          ListTile(
            enabled: plan.isActive,
            leading: Icon(
              plan.id == currentId
                  ? Icons.radio_button_checked
                  : Icons.radio_button_unchecked,
              color: plan.id == currentId
                  ? context.accent
                  : context.colors.onSurfaceVariant,
            ),
            title: Text(plan.isActive
                ? plan.name
                : '${plan.name} · ${context.l10n.platformPlanInactive}'),
            subtitle: Text(planLimitsSummary(context, plan)),
            trailing: Text(
              planPriceLabel(context, plan),
              style: AppTypography.labelLg
                  .copyWith(color: context.colors.onSurfaceVariant),
            ),
            onTap: plan.isActive
                ? () => Navigator.pop(context, (planId: plan.id))
                : null,
          ),
      ],
    );
  }
}
