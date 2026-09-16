import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/theme/theme.dart';

/// Карточка-ответ в знакомстве: крупная цель, которую видно и в которую
/// попадают даже в перчатках.
///
/// 64 точки высоты вместо материаловских 48: в этот экран человек тычет,
/// стоя где угодно, и промах здесь стоит не опечатки, а брошенного
/// знакомства.
class OnboardingChoiceCard extends StatefulWidget {
  const OnboardingChoiceCard({
    super.key,
    required this.label,
    required this.onTap,
    this.description,
    this.icon,
    this.selected = false,
  });

  final String label;
  final String? description;
  final IconData? icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  State<OnboardingChoiceCard> createState() => _OnboardingChoiceCardState();
}

class _OnboardingChoiceCardState extends State<OnboardingChoiceCard> {
  bool _pressed = false;

  void _setPressed(bool value) {
    if (_pressed == value) return;
    setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final selected = widget.selected;

    final border = selected ? colors.primary : colors.outline;
    final background = selected ? colors.primaryContainer : colors.surface;
    // Текст выбранного варианта остаётся обычным цветом, а не акцентным:
    // акцент на тёмной подложке контрастирует слабее белого (5.7:1 против
    // 13.3:1), и выбранный ответ выглядел бы бледнее невыбранных — ровно
    // наоборот тому, что он значит. Выбор показывают рамка, фон и галочка.
    final foreground = colors.onSurface;

    return Semantics(
      button: true,
      selected: selected,
      label: widget.label,
      child: GestureDetector(
        onTapDown: (_) => _setPressed(true),
        onTapUp: (_) => _setPressed(false),
        onTapCancel: () => _setPressed(false),
        onTap: () {
          // Щелчок подтверждает выбор раньше, чем глаз заметит подсветку:
          // на ощупь ответ засчитан мгновенно.
          HapticFeedback.selectionClick();
          widget.onTap();
        },
        child: AnimatedScale(
          scale: _pressed && !context.reduceMotion ? 0.97 : 1,
          duration: AppDuration.instant,
          curve: AppDuration.curve,
          child: AnimatedContainer(
            duration: AppDuration.fast,
            curve: AppDuration.curve,
            constraints: const BoxConstraints(minHeight: 64),
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.md,
            ),
            decoration: BoxDecoration(
              color: background,
              borderRadius: AppRadius.lgAll,
              border: Border.all(color: border, width: selected ? 2 : 1),
            ),
            child: Row(
              children: [
                if (widget.icon != null) ...[
                  Icon(widget.icon, size: 24, color: foreground),
                  const SizedBox(width: AppSpacing.lg),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.label,
                        style: AppTypography.titleMd.copyWith(
                          color: foreground,
                        ),
                      ),
                      if (widget.description != null) ...[
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          widget.description!,
                          style: AppTypography.bodyMd.copyWith(
                            color: colors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (selected) ...[
                  const SizedBox(width: AppSpacing.md),
                  Icon(Icons.check_circle, size: 24, color: colors.primary),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
