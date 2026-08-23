import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/access/farm_access.dart';
import '../../../../core/theme/theme.dart';

/// Каркас с четырьмя вкладками и кнопкой быстрой записи.
class MainNavigationScreen extends ConsumerWidget {
  final Widget child;
  final String currentPath;

  const MainNavigationScreen({
    super.key,
    required this.currentPath,
    required this.child,
  });

  static const _tabs = [
    (path: '/today', icon: Icons.today_outlined, active: Icons.today, label: 'Сегодня'),
    (path: '/rabbits', icon: Icons.pets_outlined, active: Icons.pets, label: 'Кролики'),
    (path: '/tasks', icon: Icons.checklist_outlined, active: Icons.checklist, label: 'Задачи'),
    (path: '/menu', icon: Icons.menu, active: Icons.menu_open, label: 'Меню'),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final index = _selectedIndex(currentPath);
    final role = ref.watch(farmRoleProvider);

    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: (i) => context.go(_tabs[i].path),
        destinations: [
          for (final tab in _tabs)
            NavigationDestination(
              icon: Icon(tab.icon),
              selectedIcon: Icon(tab.active),
              label: tab.label,
            ),
        ],
      ),
      floatingActionButton: _fab(context, index, role),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  int _selectedIndex(String path) {
    if (path.startsWith('/rabbits')) return 1;
    if (path.startsWith('/tasks')) return 2;
    if (path.startsWith('/menu') || path.startsWith('/more')) return 3;
    return 0;
  }

  Widget? _fab(BuildContext context, int index, FarmRoleAccess role) {
    if (index == 3) return null;

    if (index == 2) {
      return FloatingActionButton(
        tooltip: 'Новая задача',
        onPressed: () => context.push('/tasks/form'),
        child: const Icon(Icons.add, size: 28),
      );
    }

    final actions =
        _quickActions(index).where((a) => role.can(a.capability)).toList();
    // Работнику нечего создавать на вкладке «Кролики»: поголовье и клетки
    // заводит управляющий. Кнопка, которая открывает пустой список или
    // приводит к отказу сервера, хуже её отсутствия.
    if (actions.isEmpty) return null;

    return FloatingActionButton(
      tooltip: 'Быстрая запись',
      onPressed: () => _showQuickActions(context, actions),
      child: const Icon(Icons.add, size: 28),
    );
  }

  List<_QuickAction> _quickActions(int index) => switch (index) {
        0 => const [
            _QuickAction(
              icon: Icons.restaurant_outlined,
              label: 'Записать кормление',
              route: '/feeding-records/form',
              domain: AppDomain.feeding,
              capability: FarmCapability.recordDailyWork,
            ),
            _QuickAction(
              icon: Icons.vaccines_outlined,
              label: 'Записать вакцинацию',
              route: '/vaccinations/form',
              domain: AppDomain.health,
              capability: FarmCapability.recordDailyWork,
            ),
            _QuickAction(
              icon: Icons.add_task,
              label: 'Создать задачу',
              route: '/tasks/form',
              domain: AppDomain.tasks,
              capability: FarmCapability.recordDailyWork,
            ),
          ],
        1 => const [
            _QuickAction(
              icon: Icons.pets_outlined,
              label: 'Добавить кролика',
              route: '/rabbits/new',
              domain: AppDomain.livestock,
              capability: FarmCapability.manageLivestock,
            ),
            _QuickAction(
              icon: Icons.child_care_outlined,
              label: 'Записать окрол',
              route: '/births/new',
              domain: AppDomain.breeding,
              capability: FarmCapability.manageLivestock,
            ),
            _QuickAction(
              icon: Icons.grid_view_outlined,
              label: 'Добавить клетку',
              route: '/cages/form',
              domain: AppDomain.livestock,
              capability: FarmCapability.manageLivestock,
            ),
          ],
        _ => const [],
      };

  void _showQuickActions(BuildContext context, List<_QuickAction> actions) {
    showModalBottomSheet(
      context: context,
      builder: (context) => _QuickActionsSheet(actions: actions),
    );
  }
}

class _QuickAction {
  final IconData icon;
  final String label;
  final String route;
  final AppDomain domain;
  final FarmCapability capability;

  const _QuickAction({
    required this.icon,
    required this.label,
    required this.route,
    required this.domain,
    required this.capability,
  });
}

class _QuickActionsSheet extends StatelessWidget {
  final List<_QuickAction> actions;

  const _QuickActionsSheet({required this.actions});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.xl,
              0,
              AppSpacing.xl,
              AppSpacing.lg,
            ),
            child: Text(
              'Что записать',
              style: AppTypography.titleLg
                  .copyWith(color: context.colors.onSurface),
            ),
          ),
          for (final action in actions)
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.xl,
                0,
                AppSpacing.xl,
                AppSpacing.sm,
              ),
              child: _ActionRow(action: action),
            ),
          const SizedBox(height: AppSpacing.lg),
        ],
      ),
    );
  }
}

class _ActionRow extends StatelessWidget {
  final _QuickAction action;

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
              Container(
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: AppRadius.smAll,
                ),
                child: Icon(action.icon, color: color, size: 22),
              ),
              const SizedBox(width: AppSpacing.lg),
              Expanded(
                child: Text(
                  action.label,
                  style: AppTypography.titleMd
                      .copyWith(color: context.colors.onSurface),
                ),
              ),
              Icon(Icons.chevron_right, size: 20, color: color),
            ],
          ),
        ),
      ),
    );
  }
}
