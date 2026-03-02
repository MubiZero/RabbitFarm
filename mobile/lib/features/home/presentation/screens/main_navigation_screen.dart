import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

/// Главный экран с bottom navigation (4 tabs: Сегодня, Кролики, Задачи, Меню)
class MainNavigationScreen extends ConsumerWidget {
  final Widget child;
  final String currentPath;

  const MainNavigationScreen({
    super.key,
    required this.currentPath,
    required this.child,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = _calculateSelectedIndex(currentPath);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: child,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: colorScheme.outline.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
        ),
        child: NavigationBar(
          selectedIndex: currentIndex,
          onDestinationSelected: (index) => _onItemTapped(index, context),
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.today_outlined),
              selectedIcon: Icon(Icons.today),
              label: 'Сегодня',
            ),
            NavigationDestination(
              icon: Icon(Icons.pets_outlined),
              selectedIcon: Icon(Icons.pets),
              label: 'Кролики',
            ),
            NavigationDestination(
              icon: Icon(Icons.check_box_outline_blank),
              selectedIcon: Icon(Icons.check_box),
              label: 'Задачи',
            ),
            NavigationDestination(
              icon: Icon(Icons.menu),
              selectedIcon: Icon(Icons.menu_open),
              label: 'Меню',
            ),
          ],
        ),
      ),
      floatingActionButton: _buildFab(context, currentIndex),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  int _calculateSelectedIndex(String path) {
    if (path.startsWith('/today')) return 0;
    if (path.startsWith('/rabbits')) return 1;
    if (path.startsWith('/tasks')) return 2;
    if (path.startsWith('/menu') || path.startsWith('/more')) return 3;
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go('/today');
      case 1:
        context.go('/rabbits');
      case 2:
        context.go('/tasks');
      case 3:
        context.go('/menu');
    }
  }

  Widget? _buildFab(BuildContext context, int currentIndex) {
    final accent = Theme.of(context).colorScheme.primary;

    switch (currentIndex) {
      case 0:
      case 1:
        return FloatingActionButton(
          onPressed: () => _showQuickActions(context, currentIndex),
          backgroundColor: accent,
          child: const Icon(Icons.add, size: 28, color: Colors.white),
        );
      case 2:
        return FloatingActionButton(
          onPressed: () => context.push('/tasks/form'),
          backgroundColor: accent,
          child: const Icon(Icons.add, size: 28, color: Colors.white),
        );
      default:
        return null;
    }
  }

  void _showQuickActions(BuildContext context, int currentIndex) {
    final List<_QuickAction> actions = switch (currentIndex) {
      0 => [
          _QuickAction(
            icon: Icons.restaurant,
            label: 'Записать кормление',
            route: '/feeding-records/form',
            color: AppColors.warning,
          ),
          _QuickAction(
            icon: Icons.vaccines,
            label: 'Записать вакцинацию',
            route: '/vaccinations/form',
            color: AppColors.error,
          ),
          _QuickAction(
            icon: Icons.add_task,
            label: 'Создать задачу',
            route: '/tasks/form',
            color: AppColors.accentViolet,
          ),
        ],
      1 => [
          _QuickAction(
            icon: Icons.add,
            label: 'Добавить кролика',
            route: '/rabbits/new',
            color: AppColors.accentEmerald,
          ),
          _QuickAction(
            icon: Icons.child_care,
            label: 'Записать рождение',
            route: '/births/new',
            color: AppColors.accentRose,
          ),
          _QuickAction(
            icon: Icons.grid_view,
            label: 'Добавить клетку',
            route: '/cages/form',
            color: AppColors.info,
          ),
        ],
      _ => [],
    };

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _QuickActionsSheet(actions: actions),
    );
  }
}

class _QuickAction {
  final IconData icon;
  final String label;
  final String route;
  final Color color;

  const _QuickAction({
    required this.icon,
    required this.label,
    required this.route,
    required this.color,
  });
}

class _QuickActionsSheet extends StatelessWidget {
  final List<_QuickAction> actions;

  const _QuickActionsSheet({required this.actions});

  @override
  Widget build(BuildContext context) {
    final surface = Theme.of(context).colorScheme.surface;
    final outline = Theme.of(context).colorScheme.outline;
    final onSurface = Theme.of(context).colorScheme.onSurface;

    return Container(
      decoration: BoxDecoration(
        color: surface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: outline,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Быстрые действия',
                style: AppTypography.titleLg.copyWith(color: onSurface),
              ),
            ),
          ),
          const SizedBox(height: 16),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: actions.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final action = actions[index];
              return Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    context.push(action.route);
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: action.color.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: action.color.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(action.icon, color: action.color, size: 22),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            action.label,
                            style: AppTypography.titleMd.copyWith(color: onSurface),
                          ),
                        ),
                        Icon(Icons.arrow_forward_ios, size: 14, color: action.color),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
