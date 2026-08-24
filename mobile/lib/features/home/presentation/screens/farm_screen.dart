import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/access/farm_access.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/utils/string_utils.dart';
import '../../../../shared/widgets/logout_dialog.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../../core/l10n/l10n_context.dart';

/// Экран «Хозяйство» — то, чем на ферме управляют, а не то, что записывают
/// каждый день.
///
/// Раньше это было «Меню»: двенадцать пунктов подряд, от клеток до настроек,
/// и ничто не подсказывало, что их объединяет. Поголовье и разведение уехали
/// в свои вкладки, а здесь остались области хозяйства — деньги, корма,
/// здоровье, отчёты, люди. Цвет значка помечает область целиком: раньше он
/// выбирался у каждой строки отдельно, восемь оттенков подряд, включая
/// тревожный красный на обычном пункте «Вакцинации», — подсказкой это быть
/// переставало.
///
/// Работнику управлять нечем, поэтому у него та же вкладка подписана
/// «Профиль»: карточка, настройки и выход.
class FarmScreen extends ConsumerWidget {
  const FarmScreen({super.key});

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
            // Кнопка «Записать» висит и над этой вкладкой, поэтому последняя
            // строка списка должна из-под неё выходить.
            AppSpacing.fabSafeBottom,
          ),
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: AppSpacing.xs,
                bottom: AppSpacing.lg,
              ),
              child: Text(
                _screenTitle(context, role),
                style: AppTypography.displayMd
                    .copyWith(color: context.colors.onSurface),
              ),
            ),

            _ProfileCard(
              name: user?.fullName,
              email: user?.email,
              roleLabel: _roleLabel(context, role),
              onTap: () => context.push('/settings'),
            ),

            _Section(
              title: context.l10n.farmSectionMoney,
              domain: AppDomain.admin,
              items: [
                // Книга доходов и расходов работнику не открывается — пункт
                // без доступа привёл бы его к отказу сервера.
                if (role.can(FarmCapability.manageFinance))
                  _Item(Icons.account_balance_wallet_outlined,
                      context.l10n.farmTransactions, '/transactions'),
              ],
            ),

            _Section(
              title: context.l10n.farmSectionFeed,
              domain: AppDomain.feeding,
              items: [
                // Остаток и расход смотрят вместе: «сколько осталось» без
                // «сколько уходит в день» не говорит, когда закупаться.
                if (role.can(FarmCapability.manageStock)) ...[
                  _Item(Icons.inventory_2_outlined, context.l10n.farmFeedStock,
                      '/feeds'),
                  _Item(Icons.restaurant_outlined,
                      context.l10n.farmFeedingRecords, '/feeding-records'),
                ],
              ],
            ),

            _Section(
              title: context.l10n.farmSectionHealth,
              domain: AppDomain.health,
              items: [
                // История прививок и лечения по всему стаду — это взгляд
                // управляющего; работник свои записи вносит из «Записать».
                // Строка одна: фермер помнит «что было с этим кроликом», а не
                // «мне нужен раздел Вакцинации», и разделять эти две записи по
                // разным экранам значило бы заставлять его сводить историю в
                // голове. Названа она, как «Деньги» и «Отчёты», по содержимому,
                // а не повторяет слово из заголовка раздела.
                if (role.can(FarmCapability.manageLivestock))
                  _Item(Icons.medical_information_outlined,
                      context.l10n.healthMenuLabel, '/health'),
              ],
            ),

            _Section(
              title: context.l10n.farmSectionReports,
              domain: AppDomain.admin,
              items: [
                // Отчёты сводят деньги вместе с поголовьем, поэтому доступны
                // тому же кругу, что и деньги.
                if (role.can(FarmCapability.viewReports))
                  _Item(Icons.insights_outlined, context.l10n.farmReports,
                      '/reports'),
              ],
            ),

            _Section(
              title: context.l10n.farmSectionPeople,
              domain: AppDomain.admin,
              items: [
                if (role.can(FarmCapability.manageStaff))
                  _Item(Icons.groups_outlined, context.l10n.farmStaff, '/staff'),
              ],
            ),

            _Section(
              title: context.l10n.farmSectionApp,
              domain: AppDomain.admin,
              items: [
                _Item(Icons.settings_outlined, context.l10n.farmSettings,
                    '/settings'),
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

  /// У работника вкладка называется так же, как её подписывает нижнее меню.
  String _screenTitle(BuildContext context, FarmRoleAccess role) =>
      role == FarmRoleAccess.worker
          ? context.l10n.navProfile
          : context.l10n.farmTitle;

  String _roleLabel(BuildContext context, FarmRoleAccess role) =>
      switch (role) {
        FarmRoleAccess.owner => context.l10n.roleOwner,
        FarmRoleAccess.manager => context.l10n.roleManager,
        FarmRoleAccess.worker => context.l10n.roleWorker,
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
                          : context.l10n.navProfile,
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

    // Разделы собираются из пунктов, доступных роли. У работника пусты почти
    // все, и заголовок над пустотой выглядел бы поломкой.
    if (rows.isEmpty) return const SizedBox.shrink();

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
      label: context.l10n.farmAbout,
      color: AppDomain.admin.color(context),
      onTap: () => showAboutDialog(
        context: context,
        applicationName: context.l10n.appName,
        applicationVersion: '1.0.0',
        applicationIcon: Icon(Icons.pets, size: 40, color: context.accent),
        children: [Text(context.l10n.farmAboutBody)],
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
                context.l10n.farmLogout,
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
