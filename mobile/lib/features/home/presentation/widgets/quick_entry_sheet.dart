import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/access/farm_access.dart';
import '../../../../core/l10n/l10n_context.dart';
import '../../../../core/theme/theme.dart';

/// Всё, что человек может записать, в одном списке.
///
/// Раньше круглая кнопка вела себя по-разному на каждой вкладке: на «Сегодня»
/// открывала один лист из трёх пунктов, на «Кроликах» — другой из трёх, на
/// «Задачах» сразу форму, в меню её не было вовсе. Приходилось помнить, с
/// какой вкладки что записывается. Теперь поведение одно: словарь записей
/// целиком, лишнее скрыто по роли.
class QuickEntryAction {
  final IconData icon;
  final String label;
  final String route;
  final AppDomain domain;
  final FarmCapability capability;

  const QuickEntryAction({
    required this.icon,
    required this.label,
    required this.route,
    required this.domain,
    required this.capability,
  });
}

/// Группа записей: ежедневная работа отделена от того, что делают редко.
class QuickEntryGroup {
  final String title;
  final List<QuickEntryAction> actions;

  const QuickEntryGroup({required this.title, required this.actions});
}

List<QuickEntryGroup> quickEntryGroups(BuildContext context) {
  final l10n = context.l10n;
  return [
    QuickEntryGroup(
      title: l10n.quickGroupDaily,
      actions: [
        QuickEntryAction(
          icon: Icons.restaurant_outlined,
          label: l10n.quickRecordFeeding,
          route: '/feeding-records/form',
          domain: AppDomain.feeding,
          capability: FarmCapability.recordDailyWork,
        ),
        QuickEntryAction(
          icon: Icons.medical_services_outlined,
          label: l10n.quickRecordTreatment,
          route: '/medical-records/form',
          domain: AppDomain.health,
          capability: FarmCapability.recordDailyWork,
        ),
        QuickEntryAction(
          icon: Icons.vaccines_outlined,
          label: l10n.quickRecordVaccination,
          route: '/vaccinations/form',
          domain: AppDomain.health,
          capability: FarmCapability.recordDailyWork,
        ),
        QuickEntryAction(
          icon: Icons.add_task,
          label: l10n.quickCreateTask,
          route: '/tasks/form',
          domain: AppDomain.tasks,
          capability: FarmCapability.recordDailyWork,
        ),
      ],
    ),
    QuickEntryGroup(
      title: l10n.quickGroupHerd,
      actions: [
        QuickEntryAction(
          icon: Icons.favorite_outline,
          label: l10n.quickRecordBreeding,
          route: '/breeding/new',
          domain: AppDomain.breeding,
          capability: FarmCapability.manageLivestock,
        ),
        QuickEntryAction(
          icon: Icons.child_care_outlined,
          label: l10n.quickRecordBirth,
          route: '/births/new',
          domain: AppDomain.breeding,
          capability: FarmCapability.manageLivestock,
        ),
        QuickEntryAction(
          icon: Icons.pets_outlined,
          label: l10n.quickAddRabbit,
          route: '/rabbits/new',
          domain: AppDomain.livestock,
          capability: FarmCapability.manageLivestock,
        ),
        QuickEntryAction(
          icon: Icons.grid_view_outlined,
          label: l10n.quickAddCage,
          route: '/cages/form',
          domain: AppDomain.livestock,
          capability: FarmCapability.manageLivestock,
        ),
      ],
    ),
    QuickEntryGroup(
      title: l10n.quickGroupFarm,
      actions: [
        QuickEntryAction(
          icon: Icons.inventory_2_outlined,
          label: l10n.quickAddFeed,
          route: '/feeds/form',
          domain: AppDomain.feeding,
          capability: FarmCapability.manageStock,
        ),
        QuickEntryAction(
          icon: Icons.account_balance_wallet_outlined,
          label: l10n.quickRecordTransaction,
          route: '/transactions/form',
          domain: AppDomain.admin,
          capability: FarmCapability.manageFinance,
        ),
      ],
    ),
  ];
}

/// Открывает лист записей. Пустые по роли группы не показываются.
Future<void> showQuickEntrySheet(BuildContext context, FarmRoleAccess role) {
  final groups = [
    for (final group in quickEntryGroups(context))
      if (group.actions.any((a) => role.can(a.capability)))
        QuickEntryGroup(
          title: group.title,
          actions:
              group.actions.where((a) => role.can(a.capability)).toList(),
        ),
  ];

  return showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    builder: (context) => _QuickEntrySheet(groups: groups),
  );
}

class _QuickEntrySheet extends StatelessWidget {
  final List<QuickEntryGroup> groups;

  const _QuickEntrySheet({required this.groups});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.xl,
                0,
                AppSpacing.xl,
                AppSpacing.md,
              ),
              child: Text(
                context.l10n.navQuickTitle,
                style: AppTypography.titleLg
                    .copyWith(color: context.colors.onSurface),
              ),
            ),
            for (final group in groups) ...[
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.xl,
                  AppSpacing.sm,
                  AppSpacing.xl,
                  AppSpacing.sm,
                ),
                child: Text(
                  group.title,
                  style: AppTypography.labelLg
                      .copyWith(color: context.colors.onSurfaceVariant),
                ),
              ),
              for (final action in group.actions)
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.xl,
                    0,
                    AppSpacing.xl,
                    AppSpacing.sm,
                  ),
                  child: _ActionRow(action: action),
                ),
            ],
            const SizedBox(height: AppSpacing.lg),
          ],
        ),
      ),
    );
  }
}

class _ActionRow extends StatelessWidget {
  final QuickEntryAction action;

  const _ActionRow({required this.action});

  @override
  Widget build(BuildContext context) {
    final color = action.domain.color(context);

    return Material(
      color: color.withValues(alpha: 0.08),
      borderRadius: AppRadius.mdAll,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          Navigator.pop(context);
          context.push(action.route);
        },
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Row(
            children: [
              Icon(action.icon, color: color, size: 22),
              const SizedBox(width: AppSpacing.lg),
              Expanded(
                child: Text(
                  action.label,
                  style: AppTypography.titleMd
                      .copyWith(color: context.colors.onSurface),
                ),
              ),
              Icon(Icons.chevron_right,
                  size: 20, color: context.colors.onSurfaceVariant),
            ],
          ),
        ),
      ),
    );
  }
}
