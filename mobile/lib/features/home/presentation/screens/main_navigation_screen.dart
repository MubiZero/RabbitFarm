import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';

/// Главный экран с bottom navigation
class MainNavigationScreen extends ConsumerStatefulWidget {
  final Widget child;
  final String currentPath;

  const MainNavigationScreen({
    super.key,
    required this.child,
    required this.currentPath,
  });

  @override
  ConsumerState<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends ConsumerState<MainNavigationScreen> {
  @override
  Widget build(BuildContext context) {
    final currentIndex = _calculateSelectedIndex(widget.currentPath);

    return Scaffold(
      body: widget.child,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          child: BottomNavigationBar(
            currentIndex: currentIndex,
            onTap: (index) => _onItemTapped(index, context),
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            selectedItemColor: AppTheme.primaryColor,
            unselectedItemColor: AppTheme.textSecondary,
            selectedFontSize: 12,
            unselectedFontSize: 12,
            showUnselectedLabels: true,
            elevation: 0,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.today_outlined),
                activeIcon: Icon(Icons.today),
                label: 'Сегодня',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.pets_outlined),
                activeIcon: Icon(Icons.pets),
                label: 'Кролики',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.dashboard_outlined),
                activeIcon: Icon(Icons.dashboard),
                label: 'Обзор',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.check_circle_outline),
                activeIcon: Icon(Icons.check_circle),
                label: 'Задачи',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.menu),
                activeIcon: Icon(Icons.menu_open),
                label: 'Еще',
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: _buildFloatingActionButton(context, currentIndex),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  int _calculateSelectedIndex(String path) {
    if (path.startsWith('/today')) return 0;
    if (path.startsWith('/rabbits')) return 1;
    if (path.startsWith('/dashboard') || path == '/') return 2;
    if (path.startsWith('/tasks')) return 3;
    if (path.startsWith('/more')) return 4;
    return 2; // Default to dashboard
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go('/today');
        break;
      case 1:
        context.go('/rabbits');
        break;
      case 2:
        context.go('/dashboard');
        break;
      case 3:
        context.go('/tasks');
        break;
      case 4:
        context.go('/more');
        break;
    }
  }

  Widget? _buildFloatingActionButton(BuildContext context, int currentIndex) {
    // Показываем FAB только на определенных экранах
    if (currentIndex == 0 || currentIndex == 1 || currentIndex == 3) {
      return Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: AppTheme.primaryGradient,
          boxShadow: [
            BoxShadow(
              color: AppTheme.primaryColor.withOpacity(0.4),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: FloatingActionButton(
          onPressed: () => _showQuickActions(context, currentIndex),
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: const Icon(Icons.add, size: 32),
        ),
      );
    }
    return null;
  }

  void _showQuickActions(BuildContext context, int currentIndex) {
    List<_QuickAction> actions = [];

    switch (currentIndex) {
      case 0: // Today screen
        actions = [
          _QuickAction(
            icon: Icons.restaurant,
            label: 'Записать кормление',
            route: '/feeding-records/form',
            gradient: const LinearGradient(
              colors: [Color(0xFFF59E0B), Color(0xFFD97706)],
            ),
          ),
          _QuickAction(
            icon: Icons.vaccines,
            label: 'Записать вакцинацию',
            route: '/vaccinations/form',
            gradient: const LinearGradient(
              colors: [Color(0xFFEF4444), Color(0xFFDC2626)],
            ),
          ),
          _QuickAction(
            icon: Icons.add_task,
            label: 'Создать задачу',
            route: '/tasks/form',
            gradient: const LinearGradient(
              colors: [Color(0xFF8B5CF6), Color(0xFF7C3AED)],
            ),
          ),
        ];
        break;
      case 1: // Rabbits screen
        actions = [
          _QuickAction(
            icon: Icons.add,
            label: 'Добавить кролика',
            route: '/rabbits/new',
            gradient: AppTheme.primaryGradient,
          ),
          _QuickAction(
            icon: Icons.child_care,
            label: 'Записать рождение',
            route: '/births/new',
            gradient: const LinearGradient(
              colors: [Color(0xFFEC4899), Color(0xFFDB2777)],
            ),
          ),
          _QuickAction(
            icon: Icons.grid_view,
            label: 'Добавить клетку',
            route: '/cages/form',
            gradient: const LinearGradient(
              colors: [Color(0xFF06B6D4), Color(0xFF0891B2)],
            ),
          ),
        ];
        break;
      case 3: // Tasks screen
        actions = [
          _QuickAction(
            icon: Icons.add_task,
            label: 'Создать задачу',
            route: '/tasks/form',
            gradient: const LinearGradient(
              colors: [Color(0xFF8B5CF6), Color(0xFF7C3AED)],
            ),
          ),
        ];
        break;
    }

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _QuickActionsBottomSheet(actions: actions),
    );
  }
}

class _QuickAction {
  final IconData icon;
  final String label;
  final String route;
  final LinearGradient gradient;

  _QuickAction({
    required this.icon,
    required this.label,
    required this.route,
    required this.gradient,
  });
}

class _QuickActionsBottomSheet extends StatelessWidget {
  final List<_QuickAction> actions;

  const _QuickActionsBottomSheet({required this.actions});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
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
              color: AppTheme.textHint,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Быстрые действия',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
          ),
          const SizedBox(height: 20),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: actions.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final action = actions[index];
              return _buildActionTile(context, action);
            },
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildActionTile(BuildContext context, _QuickAction action) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.pop(context);
          context.push(action.route);
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.surfaceVariant,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: action.gradient,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: action.gradient.colors.first.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(action.icon, color: Colors.white, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  action.label,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: AppTheme.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
