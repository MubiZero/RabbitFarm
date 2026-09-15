import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/access/farm_access.dart';
import '../../../../core/l10n/l10n_context.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../../data/first_steps.dart';
import '../providers/activation_checklist_provider.dart';
import '../providers/first_steps_provider.dart';
import '../providers/onboarding_provider.dart';

/// Чек-лист первых шагов на «Сегодня»: вместо тура по пустым виджетам —
/// настоящие действия, которыми ферма и правда начинается. Каждый пункт
/// ведёт на экран, где его можно выполнить, и отмечается сам, как только
/// действие сделано, — без отдельного «готово», которое можно забыть нажать.
///
/// Состав шагов берётся из ответов на знакомстве: человеку, который сказал,
/// что ведёт случки, незачем первым делом предлагать продажи.
///
/// Первый пункт отмечен сразу: ферма и правда уже создана. Начатое дело
/// хочется закончить, а нетронутый список из одних пустых кружков выглядит
/// работой, которую ещё не начинали.
///
/// Пропадает, когда все шаги пройдены, или когда человек явно скрыл его
/// кнопкой «Скрыть» — тогда не возвращается даже недоделанным.
class ActivationChecklistCard extends ConsumerWidget {
  final int cagesTotal;
  final int rabbitsTotal;

  const ActivationChecklistCard({
    super.key,
    required this.cagesTotal,
    required this.rabbitsTotal,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Клетки и кроликов заводит тот, кто распоряжается поголовьем — у
    // работника этого права нет, и чек-лист ему бы только мешал.
    if (!ref.watch(canProvider(FarmCapability.manageLivestock))) {
      return const SizedBox.shrink();
    }

    final dismissed =
        ref.watch(activationChecklistDismissedProvider).value ?? true;
    if (dismissed) return const SizedBox.shrink();

    final answers = ref.watch(onboardingAnswersProvider).value;
    if (answers == null) return const SizedBox.shrink();

    final steps = onboardingFirstSteps(answers);
    final done = {
      for (final step in steps)
        step: switch (step) {
          FirstStep.cages => cagesTotal > 0,
          FirstStep.rabbits => rabbitsTotal > 0,
          // Пока ответ не пришёл, пункт показываем невыполненным: мигать
          // галочкой на каждом обновлении хуже, чем показать её на секунду
          // позже.
          _ => ref.watch(firstStepDoneProvider(step)).value ?? false,
        },
    };

    if (done.values.every((value) => value)) return const SizedBox.shrink();

    final l10n = context.l10n;
    // Созданная ферма — тоже сделанный шаг, и он идёт в счёт наравне с
    // остальными.
    final total = steps.length + 1;
    final completed = done.values.where((value) => value).length + 1;

    // Отступ снизу живёт здесь же, а не рядом в `_content`: карточка часто
    // не рисуется вовсе (роль, отказ, все шаги пройдены), и внешний
    // фиксированный `SizedBox` над невидимым виджетом оставлял бы двойной
    // просвет между приветствием и списком дел.
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xl),
      child: AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppSectionTitle(
              l10n.activationChecklistTitle,
              actionLabel: l10n.activationChecklistDismiss,
              onAction: () => ref
                  .read(activationChecklistDismissedProvider.notifier)
                  .dismiss(),
            ),
            _Progress(completed: completed, total: total),
            const SizedBox(height: AppSpacing.md),
            _ChecklistItem(
              done: true,
              label: l10n.activationChecklistFarmCreated,
            ),
            for (final step in steps) ...[
              const SizedBox(height: AppSpacing.xs),
              _ChecklistItem(
                done: done[step]!,
                label: step.label(context),
                onTap: () => context.push(step.route),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// «2 из 5» и полоска под ней.
///
/// Число само по себе не показывает, много ли осталось; полоска показывает,
/// но не говорит, сколько именно. Вместе они отвечают на оба вопроса.
class _Progress extends StatelessWidget {
  const _Progress({required this.completed, required this.total});

  final int completed;
  final int total;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.activationChecklistProgress(completed, total),
          style: AppTypography.labelSm.copyWith(color: colors.onSurfaceVariant),
        ),
        const SizedBox(height: AppSpacing.sm),
        ClipRRect(
          borderRadius: AppRadius.pillAll,
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: completed / total),
            duration: context.reduceMotion ? Duration.zero : AppDuration.normal,
            curve: AppDuration.curve,
            builder: (context, value, _) => LinearProgressIndicator(
              value: value,
              minHeight: 6,
              backgroundColor: colors.surfaceContainerHighest,
              color: AppColors.success,
            ),
          ),
        ),
      ],
    );
  }
}

class _ChecklistItem extends StatelessWidget {
  final bool done;
  final String label;
  final VoidCallback? onTap;

  const _ChecklistItem({required this.done, required this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        // Пункт остаётся кликабельным и после отметки: перейти на клетки
        // повторно (завести вторую) — обычное дело, а не ошибка.
        onTap: onTap,
        child: Padding(
          // Вертикальный отступ подобран так, чтобы строка была не меньше
          // 48dp — минимальный тач-таргет Material для надёжного попадания
          // пальцем.
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xs,
            vertical: AppSpacing.md,
          ),
          child: Row(
            children: [
              Icon(
                done ? Icons.check_circle : Icons.radio_button_unchecked,
                color:
                    done ? AppColors.success : context.colors.onSurfaceVariant,
                size: 24,
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(
                  label,
                  style: AppTypography.bodyMd.copyWith(
                    color: done
                        ? context.colors.onSurfaceVariant
                        : context.colors.onSurface,
                    decoration: done ? TextDecoration.lineThrough : null,
                  ),
                ),
              ),
              if (onTap != null)
                Icon(
                  Icons.chevron_right,
                  color: context.colors.onSurfaceVariant,
                  size: 20,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
