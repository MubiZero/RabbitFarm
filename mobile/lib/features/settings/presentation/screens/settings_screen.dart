import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../../core/providers/theme_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/string_utils.dart';
import '../../../../shared/widgets/logout_dialog.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final themeState = ref.watch(themeProvider);
    final user = authState.user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Настройки'),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 16),
        children: [
          // Profile card
          _GroupCard(
            context: context,
            children: [_ProfileCard(user?.fullName, user?.email)],
          ),
          const SizedBox(height: 24),

          // Appearance
          _SectionLabel('Внешний вид'),
          _GroupCard(
            context: context,
            children: [
              _SettingsTile(
                icon: Icons.brightness_6_outlined,
                label: 'Тема',
                trailing: _ThemeModeToggle(
                  mode: themeState.mode,
                  onChanged: (m) =>
                      ref.read(themeProvider.notifier).setMode(m),
                ),
              ),
              _SettingsTile(
                icon: Icons.palette_outlined,
                label: 'Цвет акцента',
                trailing: _AccentPicker(
                  selectedIndex: themeState.accentIndex,
                  onChanged: (i) =>
                      ref.read(themeProvider.notifier).setAccent(i),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Dashboard
          _SectionLabel('Дашборд'),
          _GroupCard(
            context: context,
            children: [
              _SettingsTile(
                icon: Icons.dashboard_customize_outlined,
                label: 'Настройка виджетов',
                onTap: () => context.push('/dashboard/settings'),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // About
          _SectionLabel('О приложении'),
          _GroupCard(
            context: context,
            children: [
              _SettingsTile(
                icon: Icons.info_outline,
                label: 'Версия',
                trailing: Text(
                  '1.0.0',
                  style: AppTypography.bodyMd.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),

          // Logout
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: OutlinedButton.icon(
              onPressed: () => showLogoutDialog(context, ref),
              icon: const Icon(Icons.logout, color: AppColors.error),
              label: Text(
                'Выйти из аккаунта',
                style: AppTypography.titleMd.copyWith(color: AppColors.error),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.error),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

}

// ─── Helpers ───────────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
      child: Text(
        text,
        style: AppTypography.labelLg.copyWith(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}

class _GroupCard extends StatelessWidget {
  final BuildContext context;
  final List<Widget> children;
  const _GroupCard({required this.context, required this.children});

  @override
  Widget build(BuildContext ctx) {
    final surface = Theme.of(ctx).colorScheme.surface;
    final outline = Theme.of(ctx).colorScheme.outline;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Material(
        color: surface,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          children: children.asMap().entries.map((e) {
            final i = e.key;
            return Column(
              children: [
                e.value,
                if (i < children.length - 1)
                  Divider(
                    height: 1,
                    indent: 52,
                    color: outline.withValues(alpha: 0.4),
                  ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _ProfileCard extends StatelessWidget {
  final String? name;
  final String? email;
  const _ProfileCard(this.name, this.email);

  @override
  Widget build(BuildContext context) {
    final accent = Theme.of(context).colorScheme.primary;
    final displayName = name ?? 'Пользователь';
    final userInitials = initials(displayName);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                userInitials,
                style: AppTypography.titleLg.copyWith(color: accent),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  displayName,
                  style: AppTypography.titleMd.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                if (email != null && email!.isNotEmpty)
                  Text(
                    email!,
                    style: AppTypography.bodyMd.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _SettingsTile({
    required this.icon,
    required this.label,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(
              icon,
              size: 22,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: AppTypography.bodyLg.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
            if (trailing != null) trailing!,
            if (trailing == null && onTap != null)
              Icon(
                Icons.chevron_right,
                size: 20,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
          ],
        ),
      ),
    );
  }
}

class _ThemeModeToggle extends StatelessWidget {
  final ThemeMode mode;
  final ValueChanged<ThemeMode> onChanged;

  const _ThemeModeToggle({required this.mode, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<ThemeMode>(
      segments: const [
        ButtonSegment(
          value: ThemeMode.light,
          icon: Icon(Icons.light_mode, size: 16),
          tooltip: 'Светлая',
        ),
        ButtonSegment(
          value: ThemeMode.system,
          icon: Icon(Icons.brightness_auto, size: 16),
          tooltip: 'Авто',
        ),
        ButtonSegment(
          value: ThemeMode.dark,
          icon: Icon(Icons.dark_mode, size: 16),
          tooltip: 'Тёмная',
        ),
      ],
      selected: {mode},
      onSelectionChanged: (s) => onChanged(s.first),
      style: const ButtonStyle(
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        visualDensity: VisualDensity.compact,
      ),
    );
  }
}

class _AccentPicker extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  const _AccentPicker({
    required this.selectedIndex,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(AppColors.accentOptions.length, (i) {
        final color = AppColors.accentOptions[i];
        final selected = i == selectedIndex;
        return GestureDetector(
          onTap: () => onChanged(i),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.only(left: 6),
            width: selected ? 26 : 20,
            height: selected ? 26 : 20,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: selected
                  ? Border.all(
                      color: Theme.of(context).colorScheme.onSurface,
                      width: 2,
                    )
                  : null,
            ),
          ),
        );
      }),
    );
  }
}
