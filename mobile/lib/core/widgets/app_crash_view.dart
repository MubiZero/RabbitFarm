import 'package:flutter/material.dart';

import '../../l10n/generated/app_localizations.dart';
import '../theme/theme.dart';

/// Заглушка на месте виджета, который не смог собраться.
///
/// В релизе Flutter по умолчанию рисует здесь серо-красный экран с текстом
/// исключения — для фермера это выглядит как поломка телефона и вдобавок
/// показывает служебные подробности. Визуальный язык тот же, что у
/// [AppEmptyState] и [AppErrorState]: значок, заголовок, подсказка.
class AppCrashView extends StatelessWidget {
  const AppCrashView({super.key});

  // Этот виджет подставляется вместо упавшего, а упасть может и сам каркас
  // приложения — тогда над нами нет ни `Localizations`, ни `Directionality`,
  // и `context.l10n` бросил бы вторую ошибку прямо внутри обработчика первой.
  // Поэтому переводы берутся мягко, с запасным русским текстом.
  static const _fallbackTitle = 'Что-то пошло не так';
  static const _fallbackHint = 'Не удалось показать этот экран. '
      'Вернитесь назад или перезапустите приложение.';

  @override
  Widget build(BuildContext context) {
    final l10n = Localizations.of<AppLocalizations>(context, AppLocalizations);
    final colors = Theme.of(context).colorScheme;

    return Directionality(
      textDirection: Directionality.maybeOf(context) ?? TextDirection.ltr,
      child: ColoredBox(
        color: colors.surface,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.xxl),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.sentiment_dissatisfied_outlined,
                  size: 72,
                  color: colors.onSurfaceVariant.withValues(alpha: 0.4),
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  l10n?.commonSomethingWrong ?? _fallbackTitle,
                  style: AppTypography.titleMd.copyWith(color: colors.onSurface),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  l10n?.commonSomethingWrongHint ?? _fallbackHint,
                  style: AppTypography.bodyMd
                      .copyWith(color: colors.onSurfaceVariant),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
