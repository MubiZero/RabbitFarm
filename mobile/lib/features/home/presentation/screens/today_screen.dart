import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_theme.dart';

/// Экран "Сегодня" - основной рабочий экран для ежедневных задач
class TodayScreen extends ConsumerWidget {
  const TodayScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final now = DateTime.now();
    final dateFormat = DateFormat('d MMMM, EEEE', 'ru');

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Header
            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: AppTheme.primaryGradient,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Сегодня',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      dateFormat.format(now),
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Daily Summary Cards
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildSummaryCard(
                        context,
                        'Задачи',
                        '3',
                        'из 5',
                        Icons.check_circle,
                        const LinearGradient(
                          colors: [Color(0xFF8B5CF6), Color(0xFF7C3AED)],
                        ),
                        () => context.go('/tasks'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildSummaryCard(
                        context,
                        'Кормления',
                        '2',
                        'сегодня',
                        Icons.restaurant,
                        const LinearGradient(
                          colors: [Color(0xFFF59E0B), Color(0xFFD97706)],
                        ),
                        () => context.push('/feeding-records'),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Priority Alerts
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Требует внимания',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildAlertCard(
                      context,
                      'Вакцинация',
                      'Кролик #123 - вакцинация просрочена на 2 дня',
                      Icons.vaccines,
                      const Color(0xFFEF4444),
                      () => context.push('/vaccinations'),
                    ),
                    const SizedBox(height: 8),
                    _buildAlertCard(
                      context,
                      'Роды',
                      'Крольчиха #45 - ожидаемые роды сегодня',
                      Icons.child_care,
                      const Color(0xFFEC4899),
                      () => context.push('/births'),
                    ),
                    const SizedBox(height: 8),
                    _buildAlertCard(
                      context,
                      'Корм',
                      'Заканчивается корм: Комбикорм (осталось 5 кг)',
                      Icons.inventory,
                      const Color(0xFFF59E0B),
                      () => context.push('/feeds'),
                    ),
                  ],
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 24)),

            // Today's Schedule
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Расписание на сегодня',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    TextButton(
                      onPressed: () => context.go('/tasks'),
                      child: const Text('Все задачи'),
                    ),
                  ],
                ),
              ),
            ),

            // Schedule Items
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  _buildScheduleItem(
                    context,
                    '08:00',
                    'Утреннее кормление',
                    'Кормление всех кроликов утренней порцией',
                    Icons.restaurant,
                    true,
                    const LinearGradient(
                      colors: [Color(0xFFF59E0B), Color(0xFFD97706)],
                    ),
                  ),
                  _buildScheduleItem(
                    context,
                    '10:00',
                    'Осмотр клеток',
                    'Проверить чистоту и состояние клеток в секторе А',
                    Icons.grid_view,
                    true,
                    const LinearGradient(
                      colors: [Color(0xFF06B6D4), Color(0xFF0891B2)],
                    ),
                  ),
                  _buildScheduleItem(
                    context,
                    '14:00',
                    'Вакцинация',
                    'Вакцинация кроликов #23, #45, #67',
                    Icons.vaccines,
                    false,
                    const LinearGradient(
                      colors: [Color(0xFFEF4444), Color(0xFFDC2626)],
                    ),
                  ),
                  _buildScheduleItem(
                    context,
                    '18:00',
                    'Вечернее кормление',
                    'Кормление всех кроликов вечерней порцией',
                    Icons.restaurant,
                    false,
                    const LinearGradient(
                      colors: [Color(0xFFF59E0B), Color(0xFFD97706)],
                    ),
                  ),
                  _buildScheduleItem(
                    context,
                    '20:00',
                    'Финальный осмотр',
                    'Проверка всех кроликов перед закрытием',
                    Icons.search,
                    false,
                    AppTheme.primaryGradient,
                  ),
                  const SizedBox(height: 100), // Space for FAB
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(
    BuildContext context,
    String title,
    String value,
    String subtitle,
    IconData icon,
    LinearGradient gradient,
    VoidCallback onTap,
  ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: AppTheme.cardShadow,
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: gradient,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: Colors.white, size: 28),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppTheme.textSecondary,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAlertCard(
    BuildContext context,
    String title,
    String description,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: color.withOpacity(0.3), width: 1),
            boxShadow: AppTheme.cardShadow,
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: color,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      description,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, size: 16, color: color),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScheduleItem(
    BuildContext context,
    String time,
    String title,
    String description,
    IconData icon,
    bool isCompleted,
    LinearGradient gradient,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Time
          SizedBox(
            width: 60,
            child: Text(
              time,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isCompleted
                    ? AppTheme.textSecondary
                    : AppTheme.primaryColor,
              ),
            ),
          ),
          // Timeline
          Column(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isCompleted ? AppTheme.successColor : Colors.white,
                  border: Border.all(
                    color:
                        isCompleted ? AppTheme.successColor : AppTheme.primaryColor,
                    width: 2,
                  ),
                ),
                child: isCompleted
                    ? const Icon(Icons.check, size: 8, color: Colors.white)
                    : null,
              ),
              Container(
                width: 2,
                height: 80,
                color: AppTheme.textHint.withOpacity(0.3),
              ),
            ],
          ),
          const SizedBox(width: 16),
          // Card
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: AppTheme.cardShadow,
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      gradient: gradient,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icon, color: Colors.white, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textPrimary,
                            decoration: isCompleted
                                ? TextDecoration.lineThrough
                                : null,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          description,
                          style: TextStyle(
                            fontSize: 13,
                            color: AppTheme.textSecondary,
                            decoration: isCompleted
                                ? TextDecoration.lineThrough
                                : null,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (!isCompleted)
                    IconButton(
                      icon: const Icon(Icons.check_circle_outline),
                      color: AppTheme.primaryColor,
                      onPressed: () {
                        // TODO: Mark as completed
                      },
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
