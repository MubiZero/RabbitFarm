import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';

/// Экран "Еще" - доступ ко всем дополнительным функциям
class MoreScreen extends ConsumerWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Еще',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Все функции и настройки',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Health & Medical Section
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
                child: Text(
                  'Здоровье',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary.withOpacity(0.7),
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1.1,
                ),
                delegate: SliverChildListDelegate([
                  _buildFeatureTile(
                    context,
                    'Вакцинации',
                    Icons.vaccines,
                    const LinearGradient(
                      colors: [Color(0xFFEF4444), Color(0xFFDC2626)],
                    ),
                    () => context.push('/vaccinations'),
                  ),
                  _buildFeatureTile(
                    context,
                    'Мед. карты',
                    Icons.medical_services,
                    const LinearGradient(
                      colors: [Color(0xFFF97316), Color(0xFFEA580C)],
                    ),
                    () => context.push('/medical-records'),
                  ),
                ]),
              ),
            ),

            // Breeding Section
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
                child: Text(
                  'Разведение',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary.withOpacity(0.7),
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1.1,
                ),
                delegate: SliverChildListDelegate([
                  _buildFeatureTile(
                    context,
                    'Случки',
                    Icons.favorite,
                    const LinearGradient(
                      colors: [Color(0xFFEC4899), Color(0xFFDB2777)],
                    ),
                    () => context.push('/matings'),
                  ),
                  _buildFeatureTile(
                    context,
                    'Роды',
                    Icons.child_care,
                    const LinearGradient(
                      colors: [Color(0xFFEC4899), Color(0xFFBE185D)],
                    ),
                    () => context.push('/births'),
                  ),
                  _buildFeatureTile(
                    context,
                    'Породы',
                    Icons.pets,
                    const LinearGradient(
                      colors: [Color(0xFF84CC16), Color(0xFF65A30D)],
                    ),
                    () => context.push('/breeds'),
                  ),
                  _buildFeatureTile(
                    context,
                    'Клетки',
                    Icons.grid_view,
                    const LinearGradient(
                      colors: [Color(0xFF06B6D4), Color(0xFF0891B2)],
                    ),
                    () => context.push('/cages'),
                  ),
                ]),
              ),
            ),

            // Management Section
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
                child: Text(
                  'Управление',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary.withOpacity(0.7),
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1.1,
                ),
                delegate: SliverChildListDelegate([
                  _buildFeatureTile(
                    context,
                    'Корма',
                    Icons.inventory,
                    const LinearGradient(
                      colors: [Color(0xFFF59E0B), Color(0xFFD97706)],
                    ),
                    () => context.push('/feeds'),
                  ),
                  _buildFeatureTile(
                    context,
                    'Кормления',
                    Icons.restaurant,
                    const LinearGradient(
                      colors: [Color(0xFFF59E0B), Color(0xFFB45309)],
                    ),
                    () => context.push('/feeding-records'),
                  ),
                  _buildFeatureTile(
                    context,
                    'Финансы',
                    Icons.attach_money,
                    AppTheme.secondaryGradient,
                    () => context.push('/transactions'),
                  ),
                  _buildFeatureTile(
                    context,
                    'Отчеты',
                    Icons.bar_chart,
                    const LinearGradient(
                      colors: [Color(0xFF3B82F6), Color(0xFF2563EB)],
                    ),
                    () => context.push('/reports'),
                  ),
                ]),
              ),
            ),

            // Other Section
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
                child: Text(
                  'Прочее',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary.withOpacity(0.7),
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1.1,
                ),
                delegate: SliverChildListDelegate([
                  _buildFeatureTile(
                    context,
                    'Фото',
                    Icons.photo_library,
                    const LinearGradient(
                      colors: [Color(0xFF8B5CF6), Color(0xFF7C3AED)],
                    ),
                    () => context.push('/photos'),
                  ),
                  _buildFeatureTile(
                    context,
                    'Заметки',
                    Icons.note,
                    const LinearGradient(
                      colors: [Color(0xFF14B8A6), Color(0xFF0D9488)],
                    ),
                    () => context.push('/notes'),
                  ),
                ]),
              ),
            ),

            // Settings Section
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
                child: Text(
                  'Настройки',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary.withOpacity(0.7),
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  _buildListTile(
                    context,
                    'Настройка дашборда',
                    Icons.dashboard_customize,
                    () => context.push('/dashboard/settings'),
                  ),
                  const SizedBox(height: 8),
                  _buildListTile(
                    context,
                    'Профиль',
                    Icons.person,
                    () {
                      // TODO: Navigate to profile
                    },
                  ),
                  const SizedBox(height: 8),
                  _buildListTile(
                    context,
                    'Настройки приложения',
                    Icons.settings,
                    () {
                      // TODO: Navigate to settings
                    },
                  ),
                  const SizedBox(height: 8),
                  _buildListTile(
                    context,
                    'О приложении',
                    Icons.info,
                    () {
                      _showAboutDialog(context);
                    },
                  ),
                  const SizedBox(height: 8),
                  _buildListTile(
                    context,
                    'Выйти',
                    Icons.logout,
                    () {
                      _showLogoutDialog(context);
                    },
                    isDestructive: true,
                  ),
                  const SizedBox(height: 100), // Space for bottom nav
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureTile(
    BuildContext context,
    String title,
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
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: AppTheme.cardShadow,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: gradient,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: gradient.colors.first.withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Icon(icon, color: Colors.white, size: 32),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildListTile(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap, {
    bool isDestructive = false,
  }) {
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
            boxShadow: AppTheme.cardShadow,
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isDestructive
                      ? AppTheme.errorColor.withOpacity(0.1)
                      : AppTheme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: isDestructive ? AppTheme.errorColor : AppTheme.primaryColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: isDestructive ? AppTheme.errorColor : AppTheme.textPrimary,
                  ),
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: isDestructive
                    ? AppTheme.errorColor
                    : AppTheme.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
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
            Text(
              'RabbitFarm',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryColor,
              ),
            ),
            SizedBox(height: 8),
            Text('Версия: 1.0.0'),
            SizedBox(height: 16),
            Text(
              'Профессиональная система управления кролиководческой фермой.',
              style: TextStyle(fontSize: 14),
            ),
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

  void _showLogoutDialog(BuildContext context) {
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
            onPressed: () {
              context.pop();
              // TODO: Implement logout
              context.go('/login');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorColor,
            ),
            child: const Text('Выйти'),
          ),
        ],
      ),
    );
  }
}
