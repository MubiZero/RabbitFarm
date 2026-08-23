import 'package:flutter/material.dart';

import '../theme/theme.dart';
import '../l10n/l10n_context.dart';

/// Экран с ошибкой загрузки.
///
/// Всегда даёт кнопку «Повторить»: экран, с которого невозможно выбраться, —
/// это тупик, а не сообщение об ошибке.
class AppErrorState extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const AppErrorState({
    super.key,
    required this.message,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 72, color: AppColors.error),
            const SizedBox(height: AppSpacing.lg),
            Text(
              context.l10n.commonLoadFailed,
              style: AppTypography.titleMd
                  .copyWith(color: context.colors.onSurface),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              _humanize(context, message),
              style: AppTypography.bodyMd
                  .copyWith(color: context.colors.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: AppSpacing.xl),
              OutlinedButton.icon(
                onPressed: onRetry,
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(0, 48),
                  padding:
                      const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                ),
                icon: const Icon(Icons.refresh),
                label: Text(context.l10n.commonRetry),
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Убирает из текста служебную обёртку Dart.
  ///
  /// Ошибки приезжают сюда через `toString()` исключения, поэтому фермеру
  /// показывалось «Exception: Нет связи с сервером». Слово `Exception`
  /// ничего ему не сообщает и выглядит как сбой приложения.
  static String _humanize(BuildContext context, String message) {
    var text = message.trim();
    for (final prefix in const ['Exception: ', 'DioException: ', 'Error: ']) {
      if (text.startsWith(prefix)) text = text.substring(prefix.length);
    }
    return text.isEmpty ? context.l10n.commonUnknownError : text;
  }
}
