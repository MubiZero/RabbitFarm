import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/access/farm_access.dart';
import '../../../../core/l10n/l10n_context.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../../data/models/journal_entry.dart';
import '../providers/journal_provider.dart';
import '../widgets/quick_entry_sheet.dart';

/// Журнал — что записано за смену.
///
/// Работник записывает кормление, лечение, прививки и закрывает задачи, но
/// увидеть сделанное мог только по частям: история кормлений лежала на одном
/// экране, прививки на другом, закрытые задачи не показывались нигде. Вопрос
/// «я это записал или мне кажется?» приходилось проверять в четырёх местах.
/// Здесь всё сделанное идёт одной лентой, свежее сверху.
class JournalScreen extends ConsumerStatefulWidget {
  const JournalScreen({super.key});

  @override
  ConsumerState<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends ConsumerState<JournalScreen> {
  JournalPeriod _period = JournalPeriod.today;
  JournalKind? _kind;

  Future<void> _refresh() async {
    ref.invalidate(journalFeedProvider(_period));
    await ref.read(journalFeedProvider(_period).future);
  }

  void _setPeriod(JournalPeriod period) {
    // Виды записей за неделю и за сегодня разные, и оставленный фильтр увёл бы
    // человека на пустой список сразу после переключения срока.
    setState(() {
      _period = period;
      _kind = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.journalTitle)),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            _PeriodSwitch(selected: _period, onChanged: _setPeriod),
            Expanded(
              child: AppAsyncView<List<JournalEntry>>(
                value: ref.watch(journalFeedProvider(_period)),
                onRetry: _refresh,
                skeleton: (_) => const SkeletonList(count: 6),
                builder: _loaded,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _loaded(List<JournalEntry> entries) {
    final visible = _kind == null
        ? entries
        : [for (final entry in entries) if (entry.kind == _kind) entry];

    return RefreshIndicator(
      onRefresh: _refresh,
      child: CustomScrollView(
        // Тянуть для обновления нужно и на пустом журнале.
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          // Фильтр показывается только тогда, когда есть что фильтровать:
          // над подсказкой «запишите первое» он был бы просто шумом.
          if (entries.isNotEmpty)
            SliverToBoxAdapter(child: _kindFilter(entries)),
          if (visible.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: entries.isEmpty ? _nothingRecorded() : _nothingInView(),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screenH,
                AppSpacing.md,
                AppSpacing.screenH,
                AppSpacing.fabSafeBottom,
              ),
              sliver: SliverList.separated(
                itemCount: visible.length,
                separatorBuilder: (_, __) =>
                    const SizedBox(height: AppSpacing.md),
                itemBuilder: (context, i) => _EntryCard(
                  entry: visible[i],
                  period: _period,
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// Чипы только тех видов, которые в этом сроке встречаются: фильтр по
  /// прививкам в день, когда никого не прививали, ведёт только на пустоту.
  Widget _kindFilter(List<JournalEntry> entries) {
    final kinds = [
      for (final kind in JournalKind.values)
        if (entries.any((entry) => entry.kind == kind)) kind,
    ];
    if (kinds.length < 2) return const SizedBox.shrink();

    return AppFilterBar(
      chips: [
        AppFilterChipData(
          label: context.l10n.journalKindAll,
          isSelected: _kind == null,
          onTap: () => setState(() => _kind = null),
        ),
        for (final kind in kinds)
          AppFilterChipData(
            label: _kindLabel(context, kind),
            isSelected: _kind == kind,
            onTap: () => setState(() => _kind = kind),
            color: kind.domain.color(context),
          ),
      ],
    );
  }

  Widget _nothingRecorded() {
    final role = ref.watch(farmRoleProvider);
    final canRecord = role.can(FarmCapability.recordDailyWork);

    return AppEmptyState(
      icon: Icons.assignment_outlined,
      title: _period == JournalPeriod.today
          ? context.l10n.journalEmptyTodayTitle
          : context.l10n.journalEmptyWeekTitle,
      subtitle: context.l10n.journalEmptyBody,
      actionLabel: canRecord ? context.l10n.navRecord : null,
      onAction: canRecord ? () => showQuickEntrySheet(context, role) : null,
    );
  }

  Widget _nothingInView() {
    return AppEmptyState(
      icon: Icons.filter_alt_off_outlined,
      title: context.l10n.journalNoneInViewTitle,
      subtitle: context.l10n.journalNoneInViewBody,
      actionLabel: context.l10n.commonReset,
      onAction: () => setState(() => _kind = null),
    );
  }
}

/// Срок, за который показывать записи.
///
/// Отдельный переключатель, а не общий [StatsPeriodBar]: тот считает
/// месяцами и годами для отчётов, а журнал отвечает на вопрос про смену.
/// Вид у него тоже другой — это выбор одного из двух режимов, а не фильтр,
/// и чипами рядом с чипами видов записей их было бы не различить.
class _PeriodSwitch extends StatelessWidget {
  final JournalPeriod selected;
  final ValueChanged<JournalPeriod> onChanged;

  const _PeriodSwitch({required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenH,
        AppSpacing.md,
        AppSpacing.screenH,
        0,
      ),
      child: SegmentedButton<JournalPeriod>(
        segments: [
          ButtonSegment(
            value: JournalPeriod.today,
            label: Text(context.l10n.journalPeriodToday),
          ),
          ButtonSegment(
            value: JournalPeriod.week,
            label: Text(context.l10n.journalPeriodWeek),
          ),
        ],
        selected: {selected},
        showSelectedIcon: false,
        onSelectionChanged: (values) => onChanged(values.first),
      ),
    );
  }
}

/// Одна запись ленты.
class _EntryCard extends ConsumerWidget {
  final JournalEntry entry;
  final JournalPeriod period;

  const _EntryCard({required this.entry, required this.period});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final canRecord = ref.watch(canProvider(FarmCapability.recordDailyWork));
    final color = entry.kind.domain.color(context);

    return AppCard(
      onTap: canRecord
          ? () => context.push(entry.kind.formRoute, extra: entry.formArgs)
          : null,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: AppRadius.smAll,
            ),
            child: Icon(entry.kind.icon, color: color, size: 20),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.title ?? context.l10n.feedingUnknownFeed,
                  style: AppTypography.titleMd
                      .copyWith(color: context.colors.onSurface),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  _what(context),
                  style: AppTypography.bodyMd
                      .copyWith(color: context.colors.onSurfaceVariant),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSpacing.xs),
                Row(
                  children: [
                    Icon(Icons.schedule,
                        size: 14, color: context.colors.onSurfaceVariant),
                    const SizedBox(width: AppSpacing.xs),
                    Text(
                      _when(),
                      style: AppTypography.labelSm
                          .copyWith(color: context.colors.onSurfaceVariant),
                    ),
                    if (entry.author != null) ...[
                      const SizedBox(width: AppSpacing.lg),
                      Icon(Icons.person_outline,
                          size: 14, color: context.colors.onSurfaceVariant),
                      const SizedBox(width: AppSpacing.xs),
                      Expanded(
                        child: Text(
                          entry.author!,
                          style: AppTypography.labelSm
                              .copyWith(color: context.colors.onSurfaceVariant),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Вид записи и кому она относится. Вид назван словом, а не только цветом
  /// значка: примерно каждый двенадцатый мужчина не отличит зелёный кружок
  /// от красного, а на ферме таких пользователей большинство.
  String _what(BuildContext context) {
    final kind = _kindLabel(context, entry.kind);

    final target = entry.rabbitName != null
        ? context.l10n.feedingForRabbit(entry.rabbitName!)
        : entry.cageNumber != null
            ? context.l10n.feedingForCage(entry.cageNumber!)
            : entry.kind == JournalKind.feeding
                ? context.l10n.feedingForFarm
                : null;

    return target == null ? kind : '$kind · $target';
  }

  /// В ленте за сегодня дата у всех одна и та же, и повторять её в каждой
  /// строке незачем. У прививки и лечения времени в данных нет вовсе.
  String _when() {
    if (!entry.hasTime) return DateFormat('d MMMM', 'ru').format(entry.at);
    if (period == JournalPeriod.today) {
      return DateFormat('HH:mm', 'ru').format(entry.at);
    }
    return DateFormat('d MMM, HH:mm', 'ru').format(entry.at);
  }
}

String _kindLabel(BuildContext context, JournalKind kind) => switch (kind) {
      JournalKind.feeding => context.l10n.journalKindFeeding,
      JournalKind.treatment => context.l10n.journalKindTreatment,
      JournalKind.vaccination => context.l10n.journalKindVaccination,
      JournalKind.task => context.l10n.journalKindTask,
    };

extension _JournalKindVisuals on JournalKind {
  AppDomain get domain => switch (this) {
        JournalKind.feeding => AppDomain.feeding,
        JournalKind.treatment => AppDomain.health,
        JournalKind.vaccination => AppDomain.health,
        JournalKind.task => AppDomain.tasks,
      };

  IconData get icon => switch (this) {
        JournalKind.feeding => Icons.restaurant_outlined,
        JournalKind.treatment => Icons.medical_services_outlined,
        JournalKind.vaccination => Icons.vaccines_outlined,
        JournalKind.task => Icons.check_circle_outline,
      };
}
