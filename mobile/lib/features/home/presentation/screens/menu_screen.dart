import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

class MenuScreen extends ConsumerWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final user = authState.user;

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
                child: Text(
                  'Меню',
                  style: AppTypography.displayMd.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
            ),

            // Profile card
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: Material(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  child: InkWell(
                    onTap: () => context.push('/settings'),
                    borderRadius: BorderRadius.circular(16),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Container(
                            width: 52,
                            height: 52,
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.15),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                _initials(user?.fullName),
                                style: AppTypography.titleLg.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  user?.fullName ?? 'Пользователь',
                                  style: AppTypography.titleMd.copyWith(
                                    color: Theme.of(context).colorScheme.onSurface,
                                  ),
                                ),
                                if (user?.email != null)
                                  Text(
                                    user!.email,
                                    style: AppTypography.bodyMd.copyWith(
                                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          Icon(
                            Icons.chevron_right,
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Здоровье
            _SectionHeader(title: 'Здоровье'),
            _SectionList(items: [
              _MenuItem(
                icon: Icons.vaccines,
                label: 'Вакцинации',
                color: AppColors.error,
                onTap: () => context.push('/vaccinations'),
              ),
              _MenuItem(
                icon: Icons.medical_services_outlined,
                label: 'Мед. карты',
                color: const Color(0xFFF97316),
                onTap: () => context.push('/medical-records'),
              ),
            ]),

            // Разведение
            _SectionHeader(title: 'Разведение'),
            _SectionList(items: [
              _MenuItem(
                icon: Icons.favorite_outline,
                label: 'Вязки',
                color: AppColors.accentRose,
                onTap: () => context.push('/breeding'),
              ),
              _MenuItem(
                icon: Icons.child_care,
                label: 'Роды',
                color: AppColors.accentRose,
                onTap: () => context.push('/births'),
              ),
              _MenuItem(
                icon: Icons.pets,
                label: 'Породы',
                color: const Color(0xFF84CC16),
                onTap: () => context.push('/breeds'),
              ),
              _MenuItem(
                icon: Icons.grid_view_outlined,
                label: 'Клетки',
                color: AppColors.info,
                onTap: () => context.push('/cages'),
              ),
            ]),

            // Управление
            _SectionHeader(title: 'Управление'),
            _SectionList(items: [
              _MenuItem(
                icon: Icons.inventory_2_outlined,
                label: 'Корма',
                color: AppColors.warning,
                onTap: () => context.push('/feeds'),
              ),
              _MenuItem(
                icon: Icons.restaurant_outlined,
                label: 'Кормления',
                color: AppColors.warning,
                onTap: () => context.push('/feeding-records'),
              ),
              _MenuItem(
                icon: Icons.attach_money,
                label: 'Финансы',
                color: AppColors.accentEmerald,
                onTap: () => context.push('/transactions'),
              ),
              _MenuItem(
                icon: Icons.bar_chart_outlined,
                label: 'Отчеты',
                color: AppColors.accentOcean,
                onTap: () => context.push('/reports'),
              ),
            ]),

            // Настройки
            _SectionHeader(title: 'Настройки'),
            _SectionList(items: [
              _MenuItem(
                icon: Icons.dashboard_customize_outlined,
                label: 'Настройка дашборда',
                color: AppColors.accentViolet,
                onTap: () => context.push('/dashboard/settings'),
              ),
              _MenuItem(
                icon: Icons.settings_outlined,
                label: 'Настройки приложения',
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                onTap: () => context.push('/settings'),
              ),
              _MenuItem(
                icon: Icons.info_outline,
                label: 'О приложении',
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                onTap: () => _showAboutDialog(context),
              ),
            ]),

            // Logout
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
                child: Material(
                  color: AppColors.error.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12),
                  child: InkWell(
                    onTap: () => _showLogoutDialog(context, ref),
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Icon(Icons.logout, color: AppColors.error, size: 22),
                          const SizedBox(width: 16),
                          Text(
                            'Выйти',
                            style: AppTypography.titleMd.copyWith(
                              color: AppColors.error,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _initials(String? name) {
    if (name == null || name.isEmpty) return '?';
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name[0].toUpperCase();
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('О приложении'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('RabbitFarm', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('Версия: 1.0.0'),
            SizedBox(height: 16),
            Text('Профессиональная система управления кролиководческой фермой.'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: const Text('Закрыть'),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Выйти из аккаунта?'),
        content: const Text('Вы действительно хотите выйти?'),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () async {
              context.pop();
              await ref.read(authProvider.notifier).logout();
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Выйти'),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
        child: Text(
          title,
          style: AppTypography.labelLg.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }
}

class _SectionList extends StatelessWidget {
  final List<_MenuItem> items;

  const _SectionList({required this.items});

  @override
  Widget build(BuildContext context) {
    final surface = Theme.of(context).colorScheme.surface;
    final outline = Theme.of(context).colorScheme.outline;

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Material(
          color: surface,
          borderRadius: BorderRadius.circular(12),
          child: Column(
            children: items.asMap().entries.map((entry) {
              final i = entry.key;
              final item = entry.value;
              return Column(
                children: [
                  InkWell(
                    onTap: item.onTap,
                    borderRadius: BorderRadius.vertical(
                      top: i == 0 ? const Radius.circular(12) : Radius.zero,
                      bottom: i == items.length - 1
                          ? const Radius.circular(12)
                          : Radius.zero,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 14),
                      child: Row(
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: item.color.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(item.icon, color: item.color, size: 20),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Text(
                              item.label,
                              style: AppTypography.bodyLg.copyWith(
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                          ),
                          Icon(
                            Icons.chevron_right,
                            size: 20,
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (i < items.length - 1)
                    Divider(
                      height: 1,
                      indent: 66,
                      color: outline.withValues(alpha: 0.4),
                    ),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

class _MenuItem {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _MenuItem({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });
}
