import 'package:flutter/material.dart';

import '../theme/theme.dart';

/// Заголовок смыслового блока внутри экрана, с необязательным действием справа.
///
/// Раньше такой заголовок был описан заново на четырёх экранах статистики и
/// работников, и они успели разойтись: где-то он был крупнее, где-то приглушён
/// цветом, а отступ снизу отличался на четыре пикселя. На соседних вкладках
/// одного раздела это заметно.
class AppSectionTitle extends StatelessWidget {
  final String title;

  /// Короткое пояснение под заголовком. Нужно только там, где без него блок
  /// непонятен, — иначе это лишний шум.
  final String? subtitle;

  /// Действие справа: «Все задачи», «Показать всё».
  final String? actionLabel;
  final VoidCallback? onAction;

  const AppSectionTitle(
    this.title, {
    super.key,
    this.subtitle,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final hasAction = actionLabel != null && onAction != null;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.titleLg
                      .copyWith(color: context.colors.onSurface),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    subtitle!,
                    style: AppTypography.bodyMd
                        .copyWith(color: context.colors.onSurfaceVariant),
                  ),
                ],
              ],
            ),
          ),
          if (hasAction)
            TextButton(onPressed: onAction, child: Text(actionLabel!)),
        ],
      ),
    );
  }
}
