import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../l10n/l10n_context.dart';
import '../theme/theme.dart';

/// Экран обязательного обновления — версия приложения ниже минимальной,
/// которую ещё принимает бэкенд (см. `AppVersionInterceptor`,
/// `middleware/appVersion.js`). Не диалог поверх экрана: закрыть его нельзя,
/// а WillPopScope/PopScope здесь не нужен — экран сам ничего не пушит и
/// системная кнопка «назад» на нём просто не на чем сработать.
class ForceUpdateScreen extends StatelessWidget {
  const ForceUpdateScreen({super.key});

  // TODO(store-links): подставить настоящие ссылки, когда приложение
  // опубликовано в App Store/Google Play.
  static const _storeUrl = 'https://rabbitfarm.mubi.dev';

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colors.surface,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.screenH),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.system_update_outlined, size: 72, color: colors.primary),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  context.l10n.forceUpdateTitle,
                  style: AppTypography.titleMd,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  context.l10n.forceUpdateHint,
                  style: AppTypography.bodyMd.copyWith(color: colors.onSurfaceVariant),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.lg),
                FilledButton(
                  onPressed: () => launchUrl(
                    Uri.parse(_storeUrl),
                    mode: LaunchMode.externalApplication,
                  ),
                  child: Text(context.l10n.forceUpdateButton),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
