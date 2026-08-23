import 'package:flutter/material.dart';

import '../theme/theme.dart';

/// Полоса «данные устарели».
///
/// Появляется, когда обновление не удалось, но прежние данные ещё есть. Для
/// фермы цифры минутной давности полезнее пустого экрана, однако выдавать их
/// за свежие нельзя: полоса честно говорит, что показан прошлый ответ, и
/// предлагает повторить.
class StaleDataBanner extends StatelessWidget {
  final VoidCallback? onRetry;

  const StaleDataBanner({super.key, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.warning.withValues(alpha: 0.12),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.sm,
        ),
        child: Row(
          children: [
            const Icon(Icons.cloud_off_outlined,
                size: 18, color: AppColors.warning),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                'Не удалось обновить, показаны прежние данные',
                style: AppTypography.labelSm.copyWith(color: AppColors.warning),
              ),
            ),
            if (onRetry != null)
              TextButton(
                onPressed: onRetry,
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.warning,
                  minimumSize: const Size(0, 32),
                  padding:
                      const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                ),
                child: const Text('Ещё раз'),
              ),
          ],
        ),
      ),
    );
  }
}
