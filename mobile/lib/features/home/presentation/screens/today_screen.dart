import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/alert_card.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../reports/presentation/providers/reports_provider.dart';

/// Экран "Сегодня" — основной рабочий экран
class TodayScreen extends ConsumerWidget {
  const TodayScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final now = DateTime.now();
    final dateFormat = DateFormat('d MMMM, EEEE', 'ru');
    final dashboardAsync = ref.watch(dashboardReportProvider);
    final authState = ref.watch(authProvider);
    final greeting = _greeting(now, authState.user?.fullName);

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Header — flat, no gradient
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      greeting,
                      style: AppTypography.displayMd.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      dateFormat.format(now),
                      style: AppTypography.bodyMd.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Summary cards row
            SliverToBoxAdapter(
              child: dashboardAsync.when(
                data: (dashboard) => Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: Row(
                    children: [
                      Expanded(
                        child: _SummaryCard(
                          label: 'Задачи',
                          value: '${dashboard.tasks.pending}',
                          sublabel: 'ожидают',
                          icon: Icons.check_circle_outline,
                          color: AppColors.accentViolet,
                          onTap: () => context.go('/tasks'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _SummaryCard(
                          label: 'Низкий запас',
                          value: '${dashboard.inventory.lowStockFeeds}',
                          sublabel: 'видов корма',
                          icon: Icons.inventory_2_outlined,
                          color: AppColors.warning,
                          onTap: () => context.push('/feeds'),
                        ),
                      ),
                    ],
                  ),
                ),
                loading: () => const Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (_, __) => const SizedBox(),
              ),
            ),

            // Alerts section
            SliverToBoxAdapter(
              child: dashboardAsync.when(
                data: (dashboard) {
                  final alerts = <Widget>[];

                  if (dashboard.tasks.urgent > 0) {
                    alerts.add(AlertCard(
                      title: 'Срочные задачи',
                      description: 'Срочных задач: ${dashboard.tasks.urgent}',
                      icon: Icons.priority_high,
                      color: AppColors.error,
                      onTap: () => context.go('/tasks'),
                    ));
                  }
                  if (dashboard.health.overdueVaccinations > 0) {
                    alerts.add(AlertCard(
                      title: 'Вакцинация',
                      description:
                          'Просрочено: ${dashboard.health.overdueVaccinations}',
                      icon: Icons.vaccines,
                      color: AppColors.error,
                      onTap: () => context.push('/vaccinations'),
                    ));
                  }
                  if (dashboard.breeding.recentBirths > 0) {
                    alerts.add(AlertCard(
                      title: 'Роды',
                      description:
                          'Рождений за 30 дней: ${dashboard.breeding.recentBirths}',
                      icon: Icons.child_care,
                      color: AppColors.accentRose,
                      onTap: () => context.push('/births'),
                    ));
                  }
                  if (dashboard.inventory.lowStockFeeds > 0) {
                    alerts.add(AlertCard(
                      title: 'Запас корма',
                      description:
                          'Низкий запас: ${dashboard.inventory.lowStockFeeds} видов',
                      icon: Icons.inventory_2_outlined,
                      color: AppColors.warning,
                      onTap: () => context.push('/feeds'),
                    ));
                  }

                  if (alerts.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                      child: AppCard(
                        child: Row(
                          children: [
                            const Icon(Icons.check_circle,
                                color: AppColors.success, size: 28),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Всё под контролем — срочных задач нет',
                                style: AppTypography.bodyMd.copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurfaceVariant,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  return Padding(
                    padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Требует внимания',
                          style: AppTypography.titleLg.copyWith(
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ...alerts.map((w) => Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: w,
                            )),
                      ],
                    ),
                  );
                },
                loading: () =>
                    const Center(child: CircularProgressIndicator()),
                error: (_, __) => const SizedBox(),
              ),
            ),

            // Quick actions
            SliverToBoxAdapter(
              child: dashboardAsync.when(
                data: (dashboard) => Padding(
                  padding: const EdgeInsets.fromLTRB(16, 24, 16, 100),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Быстрые действия',
                            style: AppTypography.titleLg.copyWith(
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                          TextButton(
                            onPressed: () => context.go('/tasks'),
                            child: const Text('Все задачи'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _QuickActionRow(
                        title: 'Задачи',
                        description: 'Просмотреть и управлять задачами',
                        badge: '${dashboard.tasks.pending} ожидают',
                        icon: Icons.check_circle_outline,
                        color: AppColors.accentViolet,
                        onTap: () => context.go('/tasks'),
                      ),
                      const SizedBox(height: 8),
                      _QuickActionRow(
                        title: 'Кролики',
                        description: 'Управление поголовьем',
                        badge: 'Всего: ${dashboard.rabbits.total}',
                        icon: Icons.pets_outlined,
                        color: AppColors.accentEmerald,
                        onTap: () => context.push('/rabbits'),
                      ),
                      const SizedBox(height: 8),
                      _QuickActionRow(
                        title: 'Корма',
                        description: 'Управление запасами',
                        badge: 'Низкий запас: ${dashboard.inventory.lowStockFeeds}',
                        icon: Icons.inventory_2_outlined,
                        color: AppColors.warning,
                        onTap: () => context.push('/feeds'),
                      ),
                    ],
                  ),
                ),
                loading: () =>
                    const Center(child: CircularProgressIndicator()),
                error: (_, __) => const SizedBox(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _greeting(DateTime now, String? name) {
    final hour = now.hour;
    final String base;
    if (hour >= 6 && hour < 12) {
      base = 'Доброе утро';
    } else if (hour >= 12 && hour < 18) {
      base = 'Добрый день';
    } else if (hour >= 18 && hour < 23) {
      base = 'Добрый вечер';
    } else {
      base = 'Доброй ночи';
    }
    if (name != null && name.isNotEmpty) {
      final firstName = name.trim().split(' ').first;
      return '$base, $firstName!';
    }
    return '$base!';
  }
}

class _SummaryCard extends StatelessWidget {
  final String label;
  final String value;
  final String sublabel;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _SummaryCard({
    required this.label,
    required this.value,
    required this.sublabel,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(height: 12),
          Text(
            label,
            style: AppTypography.labelSm.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 2),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value,
                style: AppTypography.displayMd.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(width: 4),
              Padding(
                padding: const EdgeInsets.only(bottom: 3),
                child: Text(
                  sublabel,
                  style: AppTypography.labelSm.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _QuickActionRow extends StatelessWidget {
  final String title;
  final String description;
  final String badge;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionRow({
    required this.title,
    required this.description,
    required this.badge,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.titleMd.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                Text(
                  description,
                  style: AppTypography.bodyMd.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  badge,
                  style: AppTypography.labelSm.copyWith(color: color),
                ),
              ],
            ),
          ),
          Icon(
            Icons.arrow_forward_ios,
            size: 14,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ],
      ),
    );
  }
}
