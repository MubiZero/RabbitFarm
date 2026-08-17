import 'package:flutter/material.dart';
import '../theme/app_typography.dart';
import 'app_card.dart';

/// Крупная метрика: значение на первом плане, подпись — вторым.
/// Рассчитана на строку из 2-3 плиток (`Expanded`), поэтому текст переносится
/// и обрезается, а не ломает раскладку.
class StatTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  /// Цвет значения и иконки. По умолчанию — акцент темы.
  final Color? accent;

  const StatTile({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.accent,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final color = accent ?? cs.primary;

    return AppCard(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 18, color: color),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: AppTypography.titleLg.copyWith(color: color),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: AppTypography.labelSm.copyWith(color: cs.onSurfaceVariant),
            maxLines: 2,
          ),
        ],
      ),
    );
  }
}
