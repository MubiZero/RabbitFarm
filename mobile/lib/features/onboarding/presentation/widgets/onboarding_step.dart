import 'package:flutter/material.dart';

import '../../../../core/theme/theme.dart';

/// Полоска пройденного пути.
///
/// Показывает, что вопросов конечное число и их немного: без неё любой опрос
/// ощущается бездонным, и человек уходит на втором экране.
class OnboardingProgress extends StatelessWidget {
  const OnboardingProgress({
    super.key,
    required this.step,
    required this.total,
  });

  final int step;
  final int total;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Semantics(
      label: '$step / $total',
      child: ClipRRect(
        borderRadius: AppRadius.pillAll,
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: step / total),
          duration: context.reduceMotion ? Duration.zero : AppDuration.normal,
          curve: AppDuration.curve,
          builder: (context, value, _) => LinearProgressIndicator(
            value: value,
            minHeight: 8,
            backgroundColor: colors.surfaceContainerHighest,
            color: colors.primary,
          ),
        ),
      ),
    );
  }
}

/// Один шаг знакомства: вопрос сверху, ответы под ним, необязательное
/// действие внизу.
///
/// Заголовок и ответы прокручиваются вместе: при системном увеличении шрифта
/// и на маленьком экране вопрос из трёх строк иначе выдавил бы последний
/// вариант за край.
class OnboardingStep extends StatelessWidget {
  const OnboardingStep({
    super.key,
    required this.title,
    required this.children,
    this.subtitle,
    this.footer,
  });

  final String title;
  final String? subtitle;
  final List<Widget> children;
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          // Вопрос с тремя ответами занимает половину экрана, и прижатый к
          // верху он оставлял под собой пустое поле в пол-телефона. Пока
          // содержимое помещается — оно стоит по центру; переросло экран —
          // прокручивается, как обычный список.
          child: LayoutBuilder(
            builder: (context, constraints) => SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight - AppSpacing.xl * 2,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(title, style: AppTypography.displayMd),
                    if (subtitle != null) ...[
                      const SizedBox(height: AppSpacing.md),
                      Text(
                        subtitle!,
                        style: AppTypography.bodyLg.copyWith(
                          color: context.colors.onSurfaceVariant,
                        ),
                      ),
                    ],
                    const SizedBox(height: AppSpacing.xl),
                    ...children,
                  ],
                ),
              ),
            ),
          ),
        ),
        if (footer != null) ...[const SizedBox(height: AppSpacing.lg), footer!],
      ],
    );
  }
}
