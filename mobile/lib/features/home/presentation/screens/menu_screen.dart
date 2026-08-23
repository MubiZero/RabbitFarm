import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/access/farm_access.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/utils/string_utils.dart';
import '../../../../shared/widgets/logout_dialog.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

/// Меню: всё, до чего не дотянуться с четырёх основных вкладок.
///
/// Разделы сгруппированы по областям работы, и цвет значка помечает область
/// целиком. Раньше цвет выбирался у каждой строки отдельно — восемь разных
/// оттенков подряд, включая тревожный красный на обычном пункте «Вакцинации»,
/// — и подсказкой это быть переставало.
class MenuScreen extends ConsumerWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).user;
    final role = ref.watch(farmRoleProvider);

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.screenH,
            AppSpacing.xl,
            AppSpacing.screenH,
            AppSpacing.xxl,
          ),
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: AppSpacing.xs,
                bottom: AppSpacing.lg,
              ),
              child: Text(
                'Меню',
                style: AppTypography.displayMd
                    .copyWith(color: context.colors.onSurface),
              ),
            ),

            _ProfileCard(
              name: user?.fullName,
              email: user?.email,
              roleLabel: _roleLabel(role),
              onTap: () => context.push('/settings'),
            ),

            _Section(
              title: 'Поголовье',
              domain: AppDomain.livestock,
              items: [
                _Item(Icons.grid_view_outlined, 'Клетки', '/cages'),
                _Item(Icons.category_outlined, 'Породы', '/breeds'),
              ],
            ),

            _Section(
              title: 'Разведение',
              domain: AppDomain.breeding,
              items: [
                _Item(Icons.favorite_outline, 'Случки', '/breeding'),
                _Item(Icons.child_care_outlined, 'Роды', '/births'),
                // Подбор пар с проверкой на родство был написан, но не был
                // связан ни с одним экраном: попасть в него из приложения
                // было невозможно.
                _Item(Icons.hub_outlined, 'Подбор пар', '/breeding/planner'),
              ],
            ),

            _Section(
              title: 'Здоровье',
              domain: AppDomain.health,
              items: [
                _Item(Icons.vaccines_outlined, 'Вакцинации', '/vaccinations'),
                _Item(Icons.medical_services_outlined, 'Лечение',
                    '/medical-records'),
              ],
            ),

            _Section(
              title: 'Корма',
              domain: AppDomain.feeding,
              items: [
                _Item(Icons.inventory_2_outlined, 'Запасы', '/feeds'),
                _Item(Icons.restaurant_outlined, 'Кормления',
                    '/feeding-records'),
              ],
            ),

            _Section(
              title: 'Учёт',
              domain: AppDomain.admin,
              items: [
                _Item(Icons.account_balance_wallet_outlined, 'Финансы',
                    '/transactions'),
                if (role.can(FarmCapability.manageStaff))
                  _Item(Icons.groups_outlined, 'Работники', '/staff'),
              ],
            ),

            _Section(
              title: 'Приложение',
              domain: AppDomain.admin,
              items: [
                _Item(Icons.settings_outlined, 'Настройки', '/settings'),
              ],
              extra: _AboutTile(),
            ),

            const SizedBox(height: AppSpacing.xl),
            _LogoutButton(onTap: () => showLogoutDialog(context, ref)),
          ],
        ),
      ),
    );
  }

  String _roleLabel(FarmRoleAccess role) => switch (role) {
        FarmRoleAccess.owner => 'Владелец фермы',
        FarmRoleAccess.manager => 'Управляющий',
        FarmRoleAccess.worker => 'Работник',
      };
}

class _ProfileCard extends StatelessWidget {
  final String? name;
  final String? email;
  final String roleLabel;
  final VoidCallback onTap;

  const _ProfileCard({
    required this.name,
    required this.email,
    required this.roleLabel,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.colors.surface,
      borderRadius: AppRadius.lgAll,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: context.colors.primaryContainer,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    initials(name),
                    style: AppTypography.titleLg.copyWith(color: context.accent),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.lg),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name?.trim().isNotEmpty == true
                          ? name!.trim()
                          : 'Профиль',
                      style: AppTypography.titleMd
                          .copyWith(color: context.colors.onSurface),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    // Роль показана рядом с именем: от неё зависит, какие
                    // действия человеку доступны, и это стоит видеть сразу.
                    Text(
                      email?.trim().isNotEmpty == true
                          ? '$roleLabel · ${email!.trim()}'
                          : roleLabel,
                      style: AppTypography.bodyMd
                          .copyWith(color: context.colors.onSurfaceVariant),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: context.colors.onSurfaceVariant),
            ],
          ),
        ),
      ),
    );
  }
}

class _Item {
  final IconData icon;
  final String label;
  final String route;

  const _Item(this.icon, this.label, this.route);
}

class _Section extends StatelessWidget {
  final String title;
  final AppDomain domain;
  final List<_Item> items;

  /// Строка, которая ведёт не по маршруту, а открывает диалог.
  final Widget? extra;

  const _Section({
    required this.title,
    required this.domain,
    required this.items,
    this.extra,
  });

  @override
  Widget build(BuildContext context) {
    final rows = <Widget>[
      for (final item in items)
        _MenuRow(
          icon: item.icon,
          label: item.label,
          color: domain.color(context),
          onTap: () => context.push(item.route),
        ),
      if (extra != null) extra!,
    ];

    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: AppSpacing.xs,
              bottom: AppSpacing.sm,
            ),
            child: Text(
              title,
              style: AppTypography.labelLg
                  .copyWith(color: context.colors.onSurfaceVariant),
            ),
          ),
          Material(
            color: context.colors.surface,
            borderRadius: AppRadius.lgAll,
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                for (var i = 0; i < rows.length; i++) ...[
                  if (i > 0)
                    Divider(
                      height: 1,
                      indent: 68,
                      color: context.colors.outline.withValues(alpha: 0.4),
                    ),
                  rows[i],
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _MenuRow({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: AppRadius.smAll,
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: AppSpacing.lg),
            Expanded(
              child: Text(
                label,
                style: AppTypography.bodyLg
                    .copyWith(color: context.colors.onSurface),
              ),
            ),
            Icon(Icons.chevron_right,
                size: 20, color: context.colors.onSurfaceVariant),
          ],
        ),
      ),
    );
  }
}

class _AboutTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _MenuRow(
      icon: Icons.info_outline,
      label: 'О приложении',
      color: AppDomain.admin.color(context),
      onTap: () => showAboutDialog(
        context: context,
        applicationName: 'RabbitFarm',
        applicationVersion: '1.0.0',
        applicationIcon: Icon(Icons.pets, size: 40, color: context.accent),
        children: const [
          Text('Учёт поголовья, кормов, здоровья и денег кроличьей фермы.'),
        ],
      ),
    );
  }
}

class _LogoutButton extends StatelessWidget {
  final VoidCallback onTap;

  const _LogoutButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.error.withValues(alpha: 0.08),
      borderRadius: AppRadius.mdAll,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.logout, color: AppColors.error, size: 20),
              const SizedBox(width: AppSpacing.md),
              Text(
                'Выйти',
                style:
                    AppTypography.titleMd.copyWith(color: AppColors.error),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
