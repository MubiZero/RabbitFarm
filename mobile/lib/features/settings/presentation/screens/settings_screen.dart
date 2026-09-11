import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../auth/presentation/providers/pin_provider.dart';
import '../../../../core/providers/theme_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/string_utils.dart';
import '../../../../shared/widgets/logout_dialog.dart';
import '../../../../core/l10n/error_text.dart';
import '../../../../core/l10n/l10n_context.dart';
import '../../../../core/providers/locale_provider.dart';
import '../../../../core/widgets/language_picker.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final themeState = ref.watch(themeProvider);
    final pin = ref.watch(pinProvider);
    final user = authState.user;

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.settingsTitle),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 16),
        children: [
          // Profile card
          _GroupCard(
            context: context,
            children: [_ProfileCard(user?.fullName, user?.contact)],
          ),
          const SizedBox(height: 24),

          // Appearance
          _SectionLabel(context.l10n.settingsAppearance),
          _GroupCard(
            context: context,
            children: [
              _SettingsTile(
                icon: Icons.brightness_6_outlined,
                label: context.l10n.settingsTheme,
                trailing: _ThemeModeToggle(
                  mode: themeState.mode,
                  onChanged: (m) =>
                      ref.read(themeProvider.notifier).setMode(m),
                ),
              ),
              _SettingsTile(
                icon: Icons.palette_outlined,
                label: context.l10n.settingsAccent,
                trailing: _AccentPicker(
                  selectedIndex: themeState.accentIndex,
                  onChanged: (i) =>
                      ref.read(themeProvider.notifier).setAccent(i),
                ),
              ),
              _SettingsTile(
                icon: Icons.language,
                label: context.l10n.settingsLanguage,
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      localeEndonym(
                        ref.watch(localeProvider).value ?? const Locale('ru'),
                      ),
                      style: AppTypography.bodyMd.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const Icon(Icons.chevron_right),
                  ],
                ),
                onTap: () => showLanguagePicker(context, ref),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Замок приложения. Код живёт только на этом телефоне — потому и
          // настройка устройства, а не профиля (см. `PinRepository`).
          _SectionLabel(context.l10n.settingsPinTitle),
          _GroupCard(
            context: context,
            children: [
              _SettingsTile(
                icon: Icons.lock_outline,
                label: pin.isSet
                    ? context.l10n.settingsPinOn
                    : context.l10n.settingsPinOff,
                trailing: Switch(
                  value: pin.isSet,
                  onChanged: (value) async {
                    if (value) {
                      context.push('/pin/setup', extra: true);
                    } else {
                      await ref.read(pinProvider.notifier).disable();
                    }
                  },
                ),
              ),
              if (pin.isSet)
                _SettingsTile(
                  icon: Icons.password_outlined,
                  label: context.l10n.settingsPinChange,
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.push('/pin/setup', extra: true),
                ),
            ],
          ),
          const SizedBox(height: 24),

          // Уведомления. Один переключатель, без канала и категории —
          // остальное по факту жалоб, когда появятся (см.
          // docs/plans/BEST-PRACTICES-BACKLOG.md, «Уведомления»).
          _SectionLabel(context.l10n.settingsNotifications),
          _GroupCard(
            context: context,
            children: [
              _SettingsTile(
                icon: Icons.notifications_outlined,
                label: context.l10n.settingsDigestToggle,
                trailing: Switch(
                  value: user?.digestEnabled ?? true,
                  onChanged: (value) async {
                    final l10n = context.l10n;
                    final messenger = ScaffoldMessenger.of(context);
                    final error =
                        await ref.read(authProvider.notifier).setDigestEnabled(value);
                    if (error != null) {
                      messenger.showSnackBar(
                        SnackBar(
                          content: Text(errorText(l10n, error)),
                          backgroundColor: AppColors.error,
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Тариф — своя оплата, только у владельца (см.
          // docs/plans/PLATFORM-ADMIN.md, 4.1): ферма сама себе план не
          // выбирает, но продлить уже назначенный может.
          if (user?.role == 'owner') ...[
            _GroupCard(
              context: context,
              children: [
                _SettingsTile(
                  icon: Icons.workspace_premium_outlined,
                  label: context.l10n.settingsSubscription,
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.push('/subscription'),
                ),
              ],
            ),
            const SizedBox(height: 24),
          ],

          // About
          _SectionLabel(context.l10n.settingsAbout),
          _GroupCard(
            context: context,
            children: [
              _SettingsTile(
                icon: Icons.support_agent_outlined,
                label: context.l10n.settingsSupport,
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.push('/support'),
              ),
              _SettingsTile(
                icon: Icons.info_outline,
                label: context.l10n.settingsVersion,
                trailing: Text(
                  '1.0.0',
                  style: AppTypography.bodyMd.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              _SettingsTile(
                icon: Icons.privacy_tip_outlined,
                label: context.l10n.settingsPrivacyPolicy,
                trailing: const Icon(Icons.open_in_new, size: 18),
                // Страница живёт на домене веб-сборки (nginx отдаёт статику
                // из mobile/web/), а не на домене API — поэтому не через
                // ApiEndpoints.baseUrl, у него другой хост.
                onTap: () => launchUrl(
                  Uri.parse('https://rabbitfarm.mubi.dev/privacy.html'),
                  mode: LaunchMode.externalApplication,
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
                context.l10n.settingsLogout,
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
    final displayName = name ?? context.l10n.menuProfile;
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
    final content = Padding(
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
        ],
      ),
    );

    return onTap == null ? content : InkWell(onTap: onTap, child: content);
  }
}

class _ThemeModeToggle extends StatelessWidget {
  final ThemeMode mode;
  final ValueChanged<ThemeMode> onChanged;

  const _ThemeModeToggle({required this.mode, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<ThemeMode>(
      segments: [
        ButtonSegment(
          value: ThemeMode.light,
          icon: const Icon(Icons.light_mode, size: 16),
          tooltip: context.l10n.settingsThemeLight,
        ),
        ButtonSegment(
          value: ThemeMode.system,
          icon: const Icon(Icons.brightness_auto, size: 16),
          tooltip: context.l10n.settingsThemeSystem,
        ),
        ButtonSegment(
          value: ThemeMode.dark,
          icon: const Icon(Icons.dark_mode, size: 16),
          tooltip: context.l10n.settingsThemeDark,
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
