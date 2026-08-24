import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/access/farm_access.dart';
import '../../../../core/l10n/l10n_context.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../rabbits/data/models/rabbit_model.dart';
import '../../../rabbits/presentation/widgets/rabbit_picker.dart';
import '../providers/health_journal_provider.dart';
import '../utils/medical_labels.dart';

/// Здоровье — одна история болезней стада.
///
/// Раньше в «Хозяйстве» под заголовком «Здоровье» стояли две строки: отдельно
/// прививки, отдельно лечение. Фермер же помнит не разделы, а животное: «что
/// было с этой крольчихой и когда её прививать снова». Ответ на такой вопрос
/// приходилось собирать из двух списков в голове. Здесь прививки и лечение
/// идут одной лентой, свежее сверху, а выбор вида записи и кролика — фильтр
/// поверх ленты, а не разные экраны.
class HealthJournalScreen extends ConsumerStatefulWidget {
  const HealthJournalScreen({super.key});

  @override
  ConsumerState<HealthJournalScreen> createState() =>
      _HealthJournalScreenState();
}

class _HealthJournalScreenState extends ConsumerState<HealthJournalScreen> {
  HealthEntryKind? _kind;
  RabbitModel? _rabbit;

  int? get _rabbitId => _rabbit?.id;

  Future<void> _refresh() async {
    ref.invalidate(healthJournalProvider(_rabbitId));
    await ref.read(healthJournalProvider(_rabbitId).future);
  }

  /// Кролика ищем в той же шторке, что и в формах: на ферме в триста голов
  /// выпадающий список из первой загруженной страницы половину животных
  /// просто не показывает.
  Future<void> _pickRabbit() async {
    final picked = await showModalBottomSheet<RabbitModel>(
      context: context,
      isScrollControlled: true,
      builder: (_) => const RabbitPickerSheet(),
    );
    if (picked == null || !mounted) return;
    setState(() => _rabbit = picked);
  }

  /// Записывать идём в те же формы, что и раньше. Когда открыт один вид
  /// записей, вопрос «что записать» уже отвечен видимой выборкой.
  Future<void> _record() async {
    final selected = _kind;
    if (selected != null) {
      context.push(selected.formRoute);
      return;
    }

    await showModalBottomSheet<void>(
      context: context,
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screenH,
                AppSpacing.lg,
                AppSpacing.screenH,
                AppSpacing.sm,
              ),
              child: Text(
                context.l10n.healthRecordTitle,
                style: AppTypography.titleLg
                    .copyWith(color: context.colors.onSurface),
              ),
            ),
            _recordTile(
              sheetContext,
              icon: Icons.vaccines_outlined,
              label: context.l10n.healthRecordVaccination,
              kind: HealthEntryKind.vaccination,
            ),
            _recordTile(
              sheetContext,
              icon: Icons.medical_services_outlined,
              label: context.l10n.healthRecordTreatment,
              kind: HealthEntryKind.treatment,
            ),
            const SizedBox(height: AppSpacing.sm),
          ],
        ),
      ),
    );
  }

  Widget _recordTile(
    BuildContext sheetContext, {
    required IconData icon,
    required String label,
    required HealthEntryKind kind,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppDomain.health.color(context)),
      title: Text(
        label,
        style: AppTypography.bodyLg.copyWith(color: context.colors.onSurface),
      ),
      onTap: () {
        Navigator.pop(sheetContext);
        context.push(kind.formRoute);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final canRecord = ref.watch(canProvider(FarmCapability.recordDailyWork));

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.healthTitle),
        actions: [
          IconButton(
            tooltip: context.l10n.healthPickRabbit,
            icon: Icon(_rabbit == null ? Icons.pets_outlined : Icons.pets),
            onPressed: _pickRabbit,
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: AppAsyncView<List<HealthEntry>>(
          value: ref.watch(healthJournalProvider(_rabbitId)),
          onRetry: _refresh,
          skeleton: (_) => const SkeletonList(count: 6, itemHeight: 104),
          builder: _loaded,
        ),
      ),
      floatingActionButton: canRecord
          ? FloatingActionButton(
              tooltip: context.l10n.navRecord,
              onPressed: _record,
              child: const Icon(Icons.add, size: 28),
            )
          : null,
    );
  }

  Widget _loaded(List<HealthEntry> entries) {
    final visible = _kind == null
        ? entries
        : [for (final entry in entries) if (entry.kind == _kind) entry];

    return RefreshIndicator(
      onRefresh: _refresh,
      child: CustomScrollView(
        // Тянуть для обновления нужно и на пустой ленте.
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          if (_rabbit != null) SliverToBoxAdapter(child: _rabbitFilter()),
          if (entries.isNotEmpty)
            SliverToBoxAdapter(child: _kindFilter(entries)),
          if (visible.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: entries.isEmpty && _rabbit == null
                  ? _nothingRecorded()
                  : _nothingInView(),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screenH,
                AppSpacing.md,
                AppSpacing.screenH,
                // Под круглой кнопкой «Записать» не должна прятаться последняя
                // запись ленты.
                AppSpacing.fabSafeBottom,
              ),
              sliver: SliverList.separated(
                itemCount: visible.length,
                separatorBuilder: (_, __) =>
                    const SizedBox(height: AppSpacing.md),
                itemBuilder: (context, i) => _EntryCard(entry: visible[i]),
              ),
            ),
        ],
      ),
    );
  }

  /// Чипы видов показываются, только когда в ленте есть оба: фильтр «Лечение»
  /// там, где никого не лечили, ведёт лишь на пустоту.
  Widget _kindFilter(List<HealthEntry> entries) {
    final kinds = [
      for (final kind in HealthEntryKind.values)
        if (entries.any((entry) => entry.kind == kind)) kind,
    ];
    if (kinds.length < 2) return const SizedBox.shrink();

    return AppFilterBar(
      chips: [
        AppFilterChipData(
          label: context.l10n.healthKindAll,
          isSelected: _kind == null,
          onTap: () => setState(() => _kind = null),
        ),
        for (final kind in kinds)
          AppFilterChipData(
            label: _kindFilterLabel(context, kind),
            isSelected: _kind == kind,
            onTap: () => setState(() => _kind = kind),
          ),
      ],
    );
  }

  /// Выбранный кролик виден отдельным ярлыком: иначе полупустая лента
  /// выглядит как потерянные записи, а не как выборка по одному животному.
  Widget _rabbitFilter() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenH,
        AppSpacing.md,
        AppSpacing.screenH,
        0,
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: InputChip(
          avatar: const Icon(Icons.pets_outlined, size: 18),
          label: Text(_rabbit!.label),
          deleteIcon: const Icon(Icons.close, size: 16),
          onDeleted: () => setState(() => _rabbit = null),
        ),
      ),
    );
  }

  Widget _nothingRecorded() {
    final canRecord = ref.watch(canProvider(FarmCapability.recordDailyWork));

    return AppEmptyState(
      icon: Icons.health_and_safety_outlined,
      title: context.l10n.healthEmptyTitle,
      subtitle: context.l10n.healthEmptyBody,
      actionLabel: canRecord ? context.l10n.navRecord : null,
      onAction: canRecord ? _record : null,
    );
  }

  Widget _nothingInView() {
    return AppEmptyState(
      icon: Icons.filter_alt_off_outlined,
      title: _rabbit == null
          ? context.l10n.healthNoneInViewTitle
          : context.l10n.healthNoneForRabbitTitle(_rabbit!.label),
      subtitle: context.l10n.healthNoneInViewBody,
      actionLabel: context.l10n.commonReset,
      onAction: () => setState(() {
        _kind = null;
        _rabbit = null;
      }),
    );
  }
}

/// Одна запись ленты: что было, кому, когда и чем кончилось.
class _EntryCard extends ConsumerWidget {
  final HealthEntry entry;

  const _EntryCard({required this.entry});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final canRecord = ref.watch(canProvider(FarmCapability.recordDailyWork));
    final color = AppDomain.health.color(context);

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
            child: Icon(_icon, color: color, size: 20),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.title,
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
                    Icon(Icons.event_outlined,
                        size: 14, color: context.colors.onSurfaceVariant),
                    const SizedBox(width: AppSpacing.xs),
                    Text(
                      DateFormat('d MMMM y', 'ru').format(entry.at),
                      style: AppTypography.labelSm
                          .copyWith(color: context.colors.onSurfaceVariant),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                _outcome(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData get _icon => switch (entry.kind) {
        HealthEntryKind.vaccination => Icons.vaccines_outlined,
        HealthEntryKind.treatment => Icons.medical_services_outlined,
      };

  /// Вид записи и кому она относится. Вид назван словом, а не только цветом
  /// значка: прививка и лечение в этой ленте одного цвета — это одна область.
  String _what(BuildContext context) {
    final kind = _kindLabel(context, entry.kind);
    final name = entry.rabbitName?.trim();

    // Кличку сервер присылает, но модель записи её не разбирает. Пока это так,
    // строка честно остаётся без адресата — см. HealthEntry.rabbitName.
    if (name == null || name.isEmpty) return kind;
    return '$kind · ${context.l10n.feedingForRabbit(name)}';
  }

  /// Чем кончилось: у лечения — исход, у прививки — когда колоть снова.
  /// Ради этой строки журнал и открывают, поэтому она заметна цветом.
  Widget _outcome(BuildContext context) {
    final format = DateFormat('d MMM y', 'ru');

    if (entry.kind == HealthEntryKind.treatment) {
      final outcome = entry.outcome;
      if (outcome == null) return const SizedBox.shrink();

      final ended = entry.endedAt;
      final label = medicalOutcomeLabel(context, outcome);

      return _StatusLine(
        icon: medicalOutcomeIcon(outcome),
        text: ended == null ? label : '$label · ${format.format(ended)}',
        color: medicalOutcomeColor(context, outcome),
      );
    }

    final next = entry.nextDate;
    if (next == null) return const SizedBox.shrink();

    final overdue = next.isBefore(DateTime.now());
    final label = context.l10n.vaccinationsNext(format.format(next));

    return _StatusLine(
      icon: overdue ? Icons.event_busy_outlined : Icons.event_repeat_outlined,
      text: overdue
          ? '$label · ${context.l10n.vaccinationsOverdueBadge}'
          : label,
      color: overdue ? AppColors.error : AppColors.success,
    );
  }
}

class _StatusLine extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;

  const _StatusLine({
    required this.icon,
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: AppSpacing.xs),
        Expanded(
          child: Text(
            text,
            style: AppTypography.labelSm.copyWith(color: color),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

/// Вид записи в строке ленты — единственное число: речь об одной записи.
String _kindLabel(BuildContext context, HealthEntryKind kind) =>
    switch (kind) {
      HealthEntryKind.vaccination => context.l10n.healthEntryVaccination,
      HealthEntryKind.treatment => context.l10n.healthEntryTreatment,
    };

/// Вид записи на чипе фильтра — множественное: чип отбирает все такие записи.
String _kindFilterLabel(BuildContext context, HealthEntryKind kind) =>
    switch (kind) {
      HealthEntryKind.vaccination => context.l10n.healthKindVaccination,
      HealthEntryKind.treatment => context.l10n.healthKindTreatment,
    };
