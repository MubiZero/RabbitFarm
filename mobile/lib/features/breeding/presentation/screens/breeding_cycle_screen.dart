import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/access/farm_access.dart';
import '../../../../core/l10n/l10n_context.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../rabbits/data/models/breeding_model.dart';
import '../../../rabbits/data/models/rabbit_model.dart';
import '../../domain/breeding_cycle.dart';
import '../providers/breeding_provider.dart';

/// Разведение — одна лента цикла от случки до отсадки.
///
/// Фермер думает «самка №12, 25-й день, пора ставить маточник», а не «мне
/// нужен раздел Окролы». Раньше одна и та же беременность была разрезана на
/// три экрана в разных углах приложения — «Случки», «Окролы» и «Подбор пар»,
/// — и ни один из них не отвечал на единственный важный вопрос: что делать
/// сегодня. Здесь строка на случку показывает стадию и ближайшее дело с
/// датой, просроченное — выше предстоящего.
///
/// Прежний список случек этот экран поглотил: те же записи, тот же провайдер,
/// но с ответом «что дальше» вместо одного статуса, поэтому отдельного
/// экрана «Случки» больше нет.
class BreedingCycleScreen extends ConsumerWidget {
  const BreedingCycleScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(breedingListProvider);
    final notifier = ref.read(breedingListProvider.notifier);
    final canManage = ref.watch(canProvider(FarmCapability.manageLivestock));

    // Одно «сейчас» на весь кадр: иначе соседние строки могут посчитать
    // стадию от разных секунд и разъехаться на границе суток.
    final now = DateTime.now();
    final items = sortedByNextAction(state.breedings, now: now);

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _Header(canManage: canManage),
            Expanded(
              child: PagedListView<BreedingModel>(
                items: items,
                isLoading: state.isLoading,
                error: state.error,
                hasMore: state.hasMore,
                onRefresh: notifier.refresh,
                onLoadMore: notifier.loadMore,
                // Заглушка повторяет геометрию готовых карточек, включая
                // запас под круглую кнопку: список не дёргается, когда
                // приезжают данные.
                skeleton: (_) => const SkeletonList(
                  itemHeight: 148,
                  padding: EdgeInsets.fromLTRB(
                    AppSpacing.screenH,
                    AppSpacing.lg,
                    AppSpacing.screenH,
                    AppSpacing.fabSafeBottom,
                  ),
                ),
                empty: AppEmptyState(
                  icon: Icons.favorite_border,
                  title: context.l10n.breedingEmptyTitle,
                  subtitle: context.l10n.breedingEmptyBody,
                  actionLabel:
                      canManage ? context.l10n.breedingEmptyAction : null,
                  onAction:
                      canManage ? () => context.push('/breeding/new') : null,
                ),
                itemBuilder: (context, breeding, _) => _CycleTile(
                  breeding: breeding,
                  status: breedingCycleStatus(breeding, now: now),
                  canManage: canManage,
                  now: now,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Шапка ленты. Подбор пар — часть той же работы: чтобы записать случку,
/// сначала выбирают, кого с кем крыть, и раньше до этого экрана из
/// «Разведения» было не дотянуться.
class _Header extends StatelessWidget {
  final bool canManage;

  const _Header({required this.canManage});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenH,
        AppSpacing.lg,
        AppSpacing.sm,
        AppSpacing.sm,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              context.l10n.cycleTitle,
              style: AppTypography.displayMd
                  .copyWith(color: context.colors.onSurface),
            ),
          ),
          if (canManage)
            TextButton.icon(
              onPressed: () => context.push('/breeding/planner'),
              icon: const Icon(Icons.favorite_outline, size: 18),
              label: Text(context.l10n.cycleFindPair),
            ),
        ],
      ),
    );
  }
}

/// Строка ленты: кто, какой день цикла и что делать дальше.
class _CycleTile extends StatelessWidget {
  final BreedingModel breeding;
  final BreedingCycleStatus status;
  final bool canManage;
  final DateTime now;

  const _CycleTile({
    required this.breeding,
    required this.status,
    required this.canManage,
    required this.now,
  });

  @override
  Widget build(BuildContext context) {
    final overdue = status.isOverdue(now: now);
    final accent = overdue ? AppColors.error : _stageColor(context);
    final day = status.dayOfCycle;

    return AppCard(
      onTap: () => context.push('/breeding/${breeding.id}'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.female,
                  size: 18, color: AppColors.domainBreeding),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: Text(
                  _rabbitLabel(context, breeding.female),
                  style: AppTypography.titleMd
                      .copyWith(color: context.colors.onSurface),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              // День цикла — то, чем фермер меряет беременность. У записей,
              // по которым делать уже нечего, он только сбивает с толку.
              if (day != null && day > 0 && status.actionDate != null) ...[
                const SizedBox(width: AppSpacing.sm),
                Text(
                  context.l10n.cycleDay(day),
                  style: AppTypography.labelSm
                      .copyWith(color: context.colors.onSurfaceVariant),
                ),
              ],
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Padding(
            padding: const EdgeInsets.only(left: AppSpacing.xl),
            child: Text(
              context.l10n.cycleMaleLine(_rabbitLabel(context, breeding.male)),
              style: AppTypography.labelSm
                  .copyWith(color: context.colors.onSurfaceVariant),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const Divider(height: AppSpacing.xl),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(_stageIcon, size: 18, color: accent),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _stageLabel(context),
                      style: AppTypography.bodyMd.copyWith(color: accent),
                    ),
                    if (status.actionDate != null) ...[
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        _whenLabel(context, status.actionDate!),
                        style: AppTypography.labelSm
                            .copyWith(color: context.colors.onSurfaceVariant),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          // Окрол заводит только тот, кому это разрешено на сервере: кнопка,
          // которая приводит к отказу, читается как поломка приложения.
          if (canManage &&
              status.stage == BreedingCycleStage.birthExpected) ...[
            const SizedBox(height: AppSpacing.sm),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: () =>
                    context.push('/births/new', extra: breeding),
                icon: const Icon(Icons.add, size: 18),
                label: Text(context.l10n.cycleRecordBirth),
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _rabbitLabel(BuildContext context, RabbitModel? rabbit) {
    final name = rabbit?.name?.trim();
    if (name != null && name.isNotEmpty) return name;

    // Имени может не быть, а бирка есть почти всегда — по ней кролика и
    // находят в крольчатнике.
    final tag = rabbit?.tagId?.trim();
    if (tag != null && tag.isNotEmpty) return context.l10n.breedingTag(tag);

    return context.l10n.commonNameMissing;
  }

  String _stageLabel(BuildContext context) => switch (status.stage) {
        BreedingCycleStage.pregnancyCheck => context.l10n.cycleStageCheck,
        BreedingCycleStage.birthExpected => context.l10n.cycleStageBirth,
        BreedingCycleStage.weaning => context.l10n.cycleStageWeaning,
        BreedingCycleStage.weaned => context.l10n.cycleStageWeaned,
        BreedingCycleStage.notPregnant => context.l10n.cycleStageNotPregnant,
        BreedingCycleStage.failed => context.l10n.cycleStageFailed,
        BreedingCycleStage.cancelled => context.l10n.cycleStageCancelled,
        BreedingCycleStage.closed => context.l10n.cycleStageClosed,
      };

  IconData get _stageIcon => switch (status.stage) {
        BreedingCycleStage.pregnancyCheck => Icons.fact_check_outlined,
        BreedingCycleStage.birthExpected => Icons.child_care_outlined,
        BreedingCycleStage.weaning => Icons.pets_outlined,
        BreedingCycleStage.weaned => Icons.task_alt,
        BreedingCycleStage.notPregnant => Icons.remove_circle_outline,
        BreedingCycleStage.failed => Icons.error_outline,
        BreedingCycleStage.cancelled => Icons.cancel_outlined,
        BreedingCycleStage.closed => Icons.check_circle_outline,
      };

  Color _stageColor(BuildContext context) => switch (status.stage) {
        BreedingCycleStage.pregnancyCheck => AppColors.info,
        BreedingCycleStage.birthExpected => AppColors.domainBreeding,
        BreedingCycleStage.weaning => AppColors.domainLivestock,
        // Отсаженный молодняк — единственный по-настоящему хороший исход
        // цикла, и в ленте он должен читаться иначе, чем «ничего не вышло».
        BreedingCycleStage.weaned => AppColors.success,
        BreedingCycleStage.notPregnant => AppColors.warning,
        BreedingCycleStage.failed => AppColors.error,
        BreedingCycleStage.cancelled ||
        BreedingCycleStage.closed =>
          context.colors.onSurfaceVariant,
      };

  /// Дата плюс ответ «далеко ли это»: «12 сентября» само по себе заставляет
  /// фермера считать дни в уме.
  String _whenLabel(BuildContext context, DateTime date) {
    final l10n = context.l10n;
    final days = date.difference(DateTime(now.year, now.month, now.day)).inDays;

    final relative = days < 0
        ? l10n.cycleOverdueDays(-days)
        : days == 0
            ? l10n.cycleDueToday
            : days == 1
                ? l10n.cycleDueTomorrow
                : l10n.cycleInDays(days);

    final formatted = DateFormat('d MMMM', 'ru').format(date);
    // «Примерно» стоит ровно там, где дата и правда посчитана от события,
    // которое ещё не случилось. Рядом с точным сроком это слово так же врёт,
    // как его отсутствие рядом с оценкой.
    final dateText =
        status.isEstimated ? l10n.cycleApproxDate(formatted) : formatted;

    return l10n.cycleActionWhen(dateText, relative);
  }
}
