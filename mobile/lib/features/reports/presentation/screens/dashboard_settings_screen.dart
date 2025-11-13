import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/models/dashboard_config.dart';
import '../providers/dashboard_config_provider.dart';

/// Экран настроек дашборда
class DashboardSettingsScreen extends ConsumerWidget {
  const DashboardSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final configAsync = ref.watch(dashboardConfigProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Настройка дашборда'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              _showResetDialog(context, ref);
            },
            tooltip: 'Сбросить к дефолту',
          ),
        ],
      ),
      body: configAsync.when(
        data: (config) => _buildSettings(context, ref, config),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text('Ошибка: $error'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettings(BuildContext context, WidgetRef ref, DashboardConfig config) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          Container(
            color: AppTheme.surfaceVariant,
            child: const TabBar(
              labelColor: AppTheme.primaryColor,
              unselectedLabelColor: AppTheme.textSecondary,
              indicatorColor: AppTheme.primaryColor,
              tabs: [
                Tab(text: 'Виджеты', icon: Icon(Icons.dashboard)),
                Tab(text: 'Быстрые действия', icon: Icon(Icons.flash_on)),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              children: [
                _buildWidgetsTab(context, ref, config),
                _buildQuickActionsTab(context, ref, config),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWidgetsTab(BuildContext context, WidgetRef ref, DashboardConfig config) {
    final sortedWidgets = List<WidgetConfig>.from(config.widgets)
      ..sort((a, b) => a.order.compareTo(b.order));

    return ReorderableListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: sortedWidgets.length,
      onReorder: (oldIndex, newIndex) {
        final widgets = List<WidgetConfig>.from(sortedWidgets);
        if (newIndex > oldIndex) {
          newIndex -= 1;
        }
        final item = widgets.removeAt(oldIndex);
        widgets.insert(newIndex, item);

        ref.read(dashboardConfigProvider.notifier).updateWidgetsOrder(widgets);
      },
      itemBuilder: (context, index) {
        final widget = sortedWidgets[index];
        return _buildWidgetTile(context, ref, widget, key: ValueKey(widget.type));
      },
    );
  }

  Widget _buildWidgetTile(
    BuildContext context,
    WidgetRef ref,
    WidgetConfig widget, {
    required Key key,
  }) {
    return Container(
      key: key,
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppTheme.cardShadow,
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            gradient: AppTheme.primaryGradient,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.dashboard, color: Colors.white, size: 24),
        ),
        title: Text(
          widget.type.title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimary,
          ),
        ),
        subtitle: Text(
          widget.type.description,
          style: const TextStyle(
            fontSize: 13,
            color: AppTheme.textSecondary,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Switch(
              value: widget.isVisible,
              onChanged: (value) {
                ref
                    .read(dashboardConfigProvider.notifier)
                    .toggleWidgetVisibility(widget.type);
              },
              activeColor: AppTheme.primaryColor,
            ),
            const SizedBox(width: 8),
            const Icon(Icons.drag_handle, color: AppTheme.textHint),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionsTab(
    BuildContext context,
    WidgetRef ref,
    DashboardConfig config,
  ) {
    final sortedActions = List<QuickActionConfig>.from(config.quickActions)
      ..sort((a, b) => a.order.compareTo(b.order));

    return ReorderableListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: sortedActions.length,
      onReorder: (oldIndex, newIndex) {
        final actions = List<QuickActionConfig>.from(sortedActions);
        if (newIndex > oldIndex) {
          newIndex -= 1;
        }
        final item = actions.removeAt(oldIndex);
        actions.insert(newIndex, item);

        ref.read(dashboardConfigProvider.notifier).updateQuickActionsOrder(actions);
      },
      itemBuilder: (context, index) {
        final action = sortedActions[index];
        return _buildQuickActionTile(
          context,
          ref,
          action,
          key: ValueKey(action.type),
        );
      },
    );
  }

  Widget _buildQuickActionTile(
    BuildContext context,
    WidgetRef ref,
    QuickActionConfig action, {
    required Key key,
  }) {
    return Container(
      key: key,
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppTheme.cardShadow,
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            gradient: _getGradientForAction(action.type),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(_getIconForAction(action.type), color: Colors.white, size: 24),
        ),
        title: Text(
          action.type.title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimary,
          ),
        ),
        subtitle: action.isVisible
            ? const Text(
                'Отображается в быстрых действиях',
                style: TextStyle(fontSize: 13, color: AppTheme.textSecondary),
              )
            : const Text(
                'Скрыто',
                style: TextStyle(fontSize: 13, color: AppTheme.textHint),
              ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Switch(
              value: action.isVisible,
              onChanged: (value) {
                ref
                    .read(dashboardConfigProvider.notifier)
                    .toggleQuickActionVisibility(action.type);
              },
              activeColor: AppTheme.primaryColor,
            ),
            const SizedBox(width: 8),
            const Icon(Icons.drag_handle, color: AppTheme.textHint),
          ],
        ),
      ),
    );
  }

  LinearGradient _getGradientForAction(QuickActionType type) {
    switch (type) {
      case QuickActionType.addRabbit:
        return AppTheme.primaryGradient;
      case QuickActionType.addVaccination:
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFEF4444), Color(0xFFDC2626)],
        );
      case QuickActionType.addFeeding:
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFF59E0B), Color(0xFFD97706)],
        );
      case QuickActionType.addTask:
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF8B5CF6), Color(0xFF7C3AED)],
        );
      case QuickActionType.addBirth:
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFEC4899), Color(0xFFDB2777)],
        );
      case QuickActionType.addTransaction:
        return AppTheme.secondaryGradient;
      case QuickActionType.addCage:
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF06B6D4), Color(0xFF0891B2)],
        );
      case QuickActionType.addBreed:
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF84CC16), Color(0xFF65A30D)],
        );
      case QuickActionType.addMedicalRecord:
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFF97316), Color(0xFFEA580C)],
        );
    }
  }

  IconData _getIconForAction(QuickActionType type) {
    switch (type) {
      case QuickActionType.addRabbit:
        return Icons.add;
      case QuickActionType.addVaccination:
        return Icons.vaccines;
      case QuickActionType.addFeeding:
        return Icons.restaurant;
      case QuickActionType.addTask:
        return Icons.add_task;
      case QuickActionType.addBirth:
        return Icons.child_care;
      case QuickActionType.addTransaction:
        return Icons.attach_money;
      case QuickActionType.addCage:
        return Icons.grid_view;
      case QuickActionType.addBreed:
        return Icons.pets;
      case QuickActionType.addMedicalRecord:
        return Icons.medical_services;
    }
  }

  void _showResetDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Сбросить настройки?'),
        content: const Text(
          'Все настройки дашборда будут сброшены к значениям по умолчанию.',
        ),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(dashboardConfigProvider.notifier).resetToDefault();
              context.pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Настройки сброшены')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorColor,
            ),
            child: const Text('Сбросить'),
          ),
        ],
      ),
    );
  }
}
