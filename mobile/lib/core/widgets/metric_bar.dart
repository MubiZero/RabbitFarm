import 'package:flutter/material.dart';
import '../theme/app_typography.dart';

/// Строка разбивки: подпись, точное значение и полоса, показывающая долю
/// от максимума в наборе. Полоса нужна для сравнения на глаз, число — чтобы
/// не заставлять пользователя измерять полосу линейкой.
class MetricBar extends StatelessWidget {
  final String label;
  final String value;

  /// Доля от максимального значения в наборе, 0..1.
  final double fraction;
  final Color color;
  final IconData? icon;

  const MetricBar({
    super.key,
    required this.label,
    required this.value,
    required this.fraction,
    required this.color,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final reduceMotion = MediaQuery.of(context).disableAnimations;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (icon != null) ...[
                Icon(icon, size: 16, color: cs.onSurfaceVariant),
                const SizedBox(width: 8),
              ],
              Expanded(
                child: Text(
                  label,
                  style: AppTypography.bodyMd.copyWith(color: cs.onSurface),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                value,
                style: AppTypography.labelLg.copyWith(color: cs.onSurface),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: fraction.clamp(0.0, 1.0)),
              duration: Duration(milliseconds: reduceMotion ? 0 : 300),
              curve: Curves.easeOutCubic,
              builder: (context, width, _) => LinearProgressIndicator(
                value: width,
                minHeight: 6,
                backgroundColor: cs.surfaceContainerHighest,
                valueColor: AlwaysStoppedAnimation(color),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
