import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/access/farm_access.dart';
import '../../../../core/l10n/l10n_context.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../feeding/presentation/providers/feeding_records_provider.dart';
import '../providers/activation_checklist_provider.dart';

/// Чек-лист первых шагов на «Сегодня»: вместо тура по пустым виджетам —
/// три настоящих действия, которыми ферма и правда начинается. Каждый пункт
/// ведёт на экран, где его можно выполнить, и отмечается сам, как только
/// действие сделано, — без отдельного «готово», которое можно забыть нажать.
///
/// Пропадает, когда все три шага пройдены, или когда человек явно скрыл его
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

    final dismissed = ref.watch(activationChecklistDismissedProvider).value ?? true;
    if (dismissed) return const SizedBox.shrink();

    final hasCage = cagesTotal > 0;
    final hasRabbit = rabbitsTotal > 0;
    // Лёгкий запрос «последняя одна запись»: считать кормления целиком ради
    // одного галочки-признака незачем.
    final hasFeeding =
        (ref.watch(recentFeedingRecordsProvider(1)).value?.isNotEmpty) ?? false;

    if (hasCage && hasRabbit && hasFeeding) return const SizedBox.shrink();

    final l10n = context.l10n;

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
            _ChecklistItem(
              done: hasCage,
              label: l10n.activationChecklistAddCage,
              onTap: () => context.push('/cages/form'),
            ),
            const SizedBox(height: AppSpacing.xs),
            _ChecklistItem(
              done: hasRabbit,
              label: l10n.activationChecklistAddRabbit,
              onTap: () => context.push('/rabbits/new'),
            ),
            const SizedBox(height: AppSpacing.xs),
            _ChecklistItem(
              done: hasFeeding,
              label: l10n.activationChecklistFirstFeeding,
              onTap: () => context.push('/feeding-records/form'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChecklistItem extends StatelessWidget {
  final bool done;
  final String label;
  final VoidCallback onTap;

  const _ChecklistItem({
    required this.done,
    required this.label,
    required this.onTap,
  });

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
                color: done ? AppColors.success : context.colors.onSurfaceVariant,
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
              Icon(Icons.chevron_right,
                  color: context.colors.onSurfaceVariant, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}
