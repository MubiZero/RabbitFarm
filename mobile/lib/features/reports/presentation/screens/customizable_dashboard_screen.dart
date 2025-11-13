import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/models/dashboard_config.dart';
import '../providers/dashboard_config_provider.dart';
import '../providers/reports_provider.dart';
import '../widgets/modern_stat_card.dart';
import '../widgets/quick_action_button.dart';
import '../widgets/alert_banner.dart';
import '../widgets/mini_chart_card.dart';
import '../widgets/progress_ring_card.dart';

/// Кастомизируемый дашборд
class CustomizableDashboardScreen extends ConsumerWidget {
  const CustomizableDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardAsync = ref.watch(dashboardReportProvider);
    final configAsync = ref.watch(dashboardConfigProvider);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.backgroundGradient,
        ),
        child: dashboardAsync.when(
          data: (dashboard) {
            return configAsync.when(
              data: (config) => _buildDashboard(context, ref, dashboard, config),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => _buildError(context, ref, error),
            );
          },
          loading: () => const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
            ),
          ),
          error: (error, stack) => _buildError(context, ref, error),
        ),
      ),
    );
  }

  Widget _buildDashboard(
    BuildContext context,
    WidgetRef ref,
    dynamic dashboard,
    DashboardConfig config,
  ) {
    return CustomScrollView(
      slivers: [
        _buildAppBar(context, ref),
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              _buildAlerts(context, dashboard),
              const SizedBox(height: 20),
              _buildQuickActions(context, config),
              const SizedBox(height: 24),
              ..._buildCustomizableWidgets(context, dashboard, config),
              const SizedBox(height: 40),
            ]),
          ),
        ),
      ],
    );
  }

  Widget _buildAppBar(BuildContext context, WidgetRef ref) {
    return SliverAppBar(
      expandedHeight: 120,
      floating: false,
      pinned: true,
      elevation: 0,
      backgroundColor: Colors.transparent,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
        title: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'RabbitFarm',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            Text(
              'Управление фермой',
              style: const TextStyle(
                fontSize: 13,
                color: AppTheme.textSecondary,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
      actions: [
        IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: AppTheme.cardShadow,
            ),
            child: const Icon(
              Icons.settings,
              color: AppTheme.textPrimary,
              size: 22,
            ),
          ),
          onPressed: () {
            context.push('/dashboard/settings');
          },
          tooltip: 'Настроить дашборд',
        ),
        const SizedBox(width: 8),
        IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: AppTheme.cardShadow,
            ),
            child: const Icon(
              Icons.refresh,
              color: AppTheme.textPrimary,
              size: 22,
            ),
          ),
          onPressed: () {
            ref.invalidate(dashboardReportProvider);
          },
        ),
        const SizedBox(width: 16),
      ],
    );
  }

  Widget _buildAlerts(BuildContext context, dynamic dashboard) {
    final alerts = <Widget>[];

    if (dashboard.health.overdueVaccinations > 0) {
      alerts.add(
        AlertBanner(
          title: 'Просроченные вакцинации',
          message:
              '${dashboard.health.overdueVaccinations} кроликов нуждаются в срочной вакцинации',
          type: AlertType.error,
          onTap: () => context.push('/vaccinations'),
        ),
      );
    }

    if (dashboard.tasks.overdue > 0) {
      alerts.add(
        AlertBanner(
          title: 'Просроченные задачи',
          message: '${dashboard.tasks.overdue} задач требуют внимания',
          type: AlertType.warning,
          onTap: () => context.push('/tasks'),
        ),
      );
    }

    if (dashboard.inventory.lowStockFeeds > 0) {
      alerts.add(
        AlertBanner(
          title: 'Низкий запас корма',
          message:
              '${dashboard.inventory.lowStockFeeds} видов корма заканчиваются',
          type: AlertType.warning,
          onTap: () => context.push('/feeds'),
        ),
      );
    }

    if (dashboard.health.upcomingVaccinations > 0) {
      alerts.add(
        AlertBanner(
          title: 'Предстоящие вакцинации',
          message:
              '${dashboard.health.upcomingVaccinations} вакцинаций запланировано',
          type: AlertType.info,
          onTap: () => context.push('/vaccinations'),
        ),
      );
    }

    if (alerts.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(children: alerts);
  }

  Widget _buildQuickActions(BuildContext context, DashboardConfig config) {
    final visibleActions = config.quickActions
        .where((action) => action.isVisible)
        .toList()
      ..sort((a, b) => a.order.compareTo(b.order));

    if (visibleActions.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 4),
          child: Text(
            'Быстрые действия',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 120,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: visibleActions.length,
            separatorBuilder: (context, index) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final action = visibleActions[index];
              return QuickActionButton(
                icon: _getIconForAction(action.type),
                label: action.type.title,
                gradient: _getGradientForAction(action.type),
                onTap: () => context.push(action.type.route),
              );
            },
          ),
        ),
      ],
    );
  }

  List<Widget> _buildCustomizableWidgets(
    BuildContext context,
    dynamic dashboard,
    DashboardConfig config,
  ) {
    final visibleWidgets = config.widgets
        .where((widget) => widget.isVisible)
        .toList()
      ..sort((a, b) => a.order.compareTo(b.order));

    final widgets = <Widget>[];

    for (final widgetConfig in visibleWidgets) {
      Widget? widget;

      switch (widgetConfig.type) {
        case WidgetType.overview:
          widget = _buildOverviewSection(context, dashboard);
          break;
        case WidgetType.finance:
          widget = _buildFinanceSection(context, dashboard);
          break;
        case WidgetType.health:
          widget = _buildHealthSection(context, dashboard);
          break;
        case WidgetType.operations:
          widget = _buildOperationsSection(context, dashboard);
          break;
        case WidgetType.resources:
          widget = _buildResourcesSection(context, dashboard);
          break;
      }

      if (widget != null) {
        widgets.add(widget);
        widgets.add(const SizedBox(height: 24));
      }
    }

    return widgets;
  }

  Widget _buildOverviewSection(BuildContext context, dynamic dashboard) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 4),
          child: Text(
            'Обзор фермы',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: MiniChartCard(
                title: 'Всего кроликов',
                value: '${dashboard.rabbits.total}',
                subtitle: '${dashboard.rabbits.male}М / ${dashboard.rabbits.female}Ж',
                data: [20, 25, 22, 30, 35, 32, dashboard.rabbits.total.toDouble()],
                color: AppTheme.primaryColor,
                onTap: () => context.push('/rabbits'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: MiniChartCard(
                title: 'Рождений',
                value: '${dashboard.breeding.recentBirths}',
                subtitle: 'За 30 дней',
                data: [3, 5, 2, 7, 4, 6, dashboard.breeding.recentBirths.toDouble()],
                color: AppTheme.accentColor,
                onTap: () => context.push('/births'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ModernStatCard(
          title: 'Клетки',
          icon: Icons.grid_view,
          gradient: AppTheme.secondaryGradient,
          route: '/cages',
          stats: [
            StatItem(
              label: 'Всего клеток',
              value: '${dashboard.cages.total}',
              icon: Icons.apps,
            ),
            StatItem(
              label: 'Занято',
              value: '${dashboard.cages.occupied}',
              valueColor: AppTheme.textPrimary,
              icon: Icons.check_box,
            ),
            StatItem(
              label: 'Свободно',
              value: '${dashboard.cages.available}',
              valueColor: AppTheme.successColor,
              icon: Icons.check_box_outline_blank,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFinanceSection(BuildContext context, dynamic dashboard) {
    final profit = double.parse(dashboard.finance.profit30days.toString());
    final income = double.parse(dashboard.finance.income30days.toString());
    final expenses = double.parse(dashboard.finance.expenses30days.toString());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 4),
          child: Text(
            'Финансы',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
        ),
        const SizedBox(height: 16),
        ModernStatCard(
          title: 'Финансовая сводка (30 дней)',
          icon: Icons.account_balance_wallet,
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF10B981), Color(0xFF059669)],
          ),
          route: '/transactions',
          stats: [
            StatItem(
              label: 'Доход',
              value: '${income.toStringAsFixed(0)} ₽',
              valueColor: AppTheme.successColor,
              icon: Icons.arrow_upward,
            ),
            StatItem(
              label: 'Расход',
              value: '${expenses.toStringAsFixed(0)} ₽',
              valueColor: AppTheme.errorColor,
              icon: Icons.arrow_downward,
            ),
            StatItem(
              label: 'Прибыль',
              value: '${profit.toStringAsFixed(0)} ₽',
              valueColor: profit >= 0 ? AppTheme.successColor : AppTheme.errorColor,
              icon: profit >= 0 ? Icons.trending_up : Icons.trending_down,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildHealthSection(BuildContext context, dynamic dashboard) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 4),
          child: Text(
            'Здоровье',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
        ),
        const SizedBox(height: 16),
        ModernStatCard(
          title: 'Вакцинации',
          icon: Icons.medical_services,
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFEF4444), Color(0xFFDC2626)],
          ),
          route: '/vaccinations',
          stats: [
            StatItem(
              label: 'Предстоящие',
              value: '${dashboard.health.upcomingVaccinations}',
              valueColor: AppTheme.warningColor,
              icon: Icons.schedule,
            ),
            StatItem(
              label: 'Просрочены',
              value: '${dashboard.health.overdueVaccinations}',
              valueColor: dashboard.health.overdueVaccinations > 0
                  ? AppTheme.errorColor
                  : AppTheme.successColor,
              icon: dashboard.health.overdueVaccinations > 0
                  ? Icons.warning
                  : Icons.check_circle,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildOperationsSection(BuildContext context, dynamic dashboard) {
    final totalTasks = dashboard.tasks.pending + dashboard.tasks.overdue;
    final completionRate = totalTasks > 0
        ? (dashboard.tasks.pending / totalTasks).clamp(0.0, 1.0)
        : 1.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 4),
          child: Text(
            'Операции',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: ProgressRingCard(
                title: 'Задачи',
                progress: 1.0 - completionRate,
                centerText: '${dashboard.tasks.pending}',
                bottomText: 'Активных задач',
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF8B5CF6), Color(0xFF7C3AED)],
                ),
                onTap: () => context.push('/tasks'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ModernStatCard(
                title: 'Статус задач',
                icon: Icons.assignment,
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF8B5CF6), Color(0xFF7C3AED)],
                ),
                route: '/tasks',
                stats: [
                  StatItem(
                    label: 'Ожидают',
                    value: '${dashboard.tasks.pending}',
                    icon: Icons.pending_actions,
                  ),
                  StatItem(
                    label: 'Просрочены',
                    value: '${dashboard.tasks.overdue}',
                    valueColor: dashboard.tasks.overdue > 0
                        ? AppTheme.errorColor
                        : AppTheme.successColor,
                    icon: Icons.warning_amber,
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildResourcesSection(BuildContext context, dynamic dashboard) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 4),
          child: Text(
            'Ресурсы',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
        ),
        const SizedBox(height: 16),
        ModernStatCard(
          title: 'Инвентарь и корма',
          icon: Icons.inventory_2,
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFF59E0B), Color(0xFFD97706)],
          ),
          route: '/feeds',
          stats: [
            StatItem(
              label: 'Корма с низким запасом',
              value: '${dashboard.inventory.lowStockFeeds}',
              valueColor: dashboard.inventory.lowStockFeeds > 0
                  ? AppTheme.errorColor
                  : AppTheme.successColor,
              icon: dashboard.inventory.lowStockFeeds > 0
                  ? Icons.warning
                  : Icons.check_circle,
            ),
          ],
        ),
      ],
    );
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

  Widget _buildError(BuildContext context, WidgetRef ref, Object error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppTheme.errorColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.error_outline,
                size: 64,
                color: AppTheme.errorColor,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Ошибка загрузки',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '$error',
              style: const TextStyle(
                fontSize: 14,
                color: AppTheme.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                ref.invalidate(dashboardReportProvider);
                ref.invalidate(dashboardConfigProvider);
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Повторить'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
