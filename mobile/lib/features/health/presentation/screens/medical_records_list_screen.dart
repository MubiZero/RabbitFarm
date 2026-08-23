import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/access/farm_access.dart';
import '../../../../core/l10n/l10n_context.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/utils/format_utils.dart';
import '../../../../core/widgets/widgets.dart';
import '../../data/models/medical_record_model.dart';
import '../providers/medical_records_provider.dart';
import '../utils/medical_labels.dart';

/// Карты лечения.
class MedicalRecordsListScreen extends ConsumerStatefulWidget {
  const MedicalRecordsListScreen({super.key});

  @override
  ConsumerState<MedicalRecordsListScreen> createState() =>
      _MedicalRecordsListScreenState();
}

class _MedicalRecordsListScreenState
    extends ConsumerState<MedicalRecordsListScreen> {
  MedicalOutcome? _outcome;
  DateTime? _from;
  DateTime? _to;

  bool get _hasFilters => _outcome != null || _from != null || _to != null;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  Future<void> _load() => ref
      .read(medicalRecordsProvider.notifier)
      .loadMedicalRecords(
        outcome: _outcome == null ? null : medicalOutcomeValue(_outcome!),
        fromDate: _from,
        toDate: _to,
        sortBy: 'started_at',
        sortOrder: 'DESC',
      );

  void _setOutcome(MedicalOutcome? outcome) {
    setState(() => _outcome = outcome);
    _load();
  }

  @override
  Widget build(BuildContext context) {
    final recordsAsync = ref.watch(medicalRecordsProvider);
    final canRecord = ref.watch(canProvider(FarmCapability.recordDailyWork));

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.medTitle),
        actions: [
          IconButton(
            tooltip: context.l10n.medStats,
            icon: const Icon(Icons.insights_outlined),
            onPressed: () => showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (_) => const _StatisticsSheet(),
            ),
          ),
          IconButton(
            tooltip: context.l10n.tasksFilters,
            icon: Icon(_from != null || _to != null
                ? Icons.filter_list_alt
                : Icons.filter_list),
            onPressed: _showPeriodFilter,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _load,
        child: Column(
          children: [
            _OutcomeTabs(selected: _outcome, onSelect: _setOutcome),
            Expanded(
              child: AppAsyncView<List<MedicalRecord>>(
                value: recordsAsync,
                onRetry: _load,
                skeleton: (_) => const SkeletonList(itemHeight: 130),
                builder: (records) => records.isEmpty
                    ? _empty(canRecord)
                    : ListView.separated(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.fromLTRB(
                          AppSpacing.screenH,
                          AppSpacing.md,
                          AppSpacing.screenH,
                          AppSpacing.fabSafeBottom,
                        ),
                        itemCount: records.length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(height: AppSpacing.md),
                        itemBuilder: (context, i) => _RecordCard(
                          record: records[i],
                          onTap: () => showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            builder: (_) => _DetailsSheet(record: records[i]),
                          ),
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: canRecord
          ? FloatingActionButton(
              tooltip: context.l10n.medEmptyAction,
              onPressed: () => context.push('/medical-records/form'),
              child: const Icon(Icons.add),
            )
          : null,
    );
  }

  Widget _empty(bool canRecord) {
    // Отсутствие записей на новой ферме и пустая выборка под фильтром — разные
    // ситуации, и подсказка в них нужна разная.
    if (_hasFilters) {
      return AppEmptyState(
        icon: Icons.filter_alt_off_outlined,
        title: context.l10n.medNoneInView,
        subtitle: context.l10n.medNoneInViewBody,
        actionLabel: context.l10n.tasksFiltersReset,
        onAction: () {
          setState(() {
            _outcome = null;
            _from = null;
            _to = null;
          });
          _load();
        },
      );
    }
    return AppEmptyState(
      icon: Icons.medical_information_outlined,
      title: context.l10n.medEmptyTitle,
      subtitle: context.l10n.medEmptyBody,
      actionLabel: canRecord ? context.l10n.medEmptyAction : null,
      onAction:
          canRecord ? () => context.push('/medical-records/form') : null,
    );
  }

  Future<void> _showPeriodFilter() async {
    final format = DateFormat('d MMM y', 'ru');

    await showModalBottomSheet<void>(
      context: context,
      builder: (sheetContext) => StatefulBuilder(
        builder: (sheetContext, setSheetState) => SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.screenH,
              0,
              AppSpacing.screenH,
              AppSpacing.lg,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.vaccinationsFilterPeriod,
                  style: AppTypography.titleLg
                      .copyWith(color: context.colors.onSurface),
                ),
                const SizedBox(height: AppSpacing.lg),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () async {
                          final picked = await showDatePicker(
                            context: sheetContext,
                            initialDate: _from ?? DateTime.now(),
                            firstDate: DateTime(2020),
                            lastDate: DateTime.now(),
                          );
                          if (picked != null) {
                            setSheetState(() => _from = picked);
                          }
                        },
                        icon: const Icon(Icons.calendar_today, size: 18),
                        label: Text(_from == null
                            ? context.l10n.medPeriodFrom
                            : format.format(_from!)),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () async {
                          final picked = await showDatePicker(
                            context: sheetContext,
                            initialDate: _to ?? DateTime.now(),
                            firstDate: _from ?? DateTime(2020),
                            lastDate: DateTime.now(),
                          );
                          if (picked != null) {
                            setSheetState(() => _to = picked);
                          }
                        },
                        icon: const Icon(Icons.calendar_today, size: 18),
                        label: Text(_to == null
                            ? context.l10n.medPeriodTo
                            : format.format(_to!)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xl),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          setSheetState(() {
                            _from = null;
                            _to = null;
                          });
                          Navigator.pop(sheetContext);
                        },
                        child: Text(context.l10n.tasksFiltersReset),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: FilledButton(
                        onPressed: () => Navigator.pop(sheetContext),
                        child: Text(context.l10n.tasksFiltersApply),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );

    if (mounted) {
      setState(() {});
      await _load();
    }
  }
}

class _OutcomeTabs extends StatelessWidget {
  final MedicalOutcome? selected;
  final ValueChanged<MedicalOutcome?> onSelect;

  const _OutcomeTabs({required this.selected, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return AppFilterBar(
      chips: [
        AppFilterChipData(
          label: context.l10n.medViewAll,
          isSelected: selected == null,
          onTap: () => onSelect(null),
        ),
        for (final outcome in MedicalOutcome.values)
          AppFilterChipData(
            label: medicalOutcomeLabel(context, outcome),
            isSelected: selected == outcome,
            onTap: () => onSelect(outcome),
            color: medicalOutcomeColor(context, outcome),
          ),
      ],
    );
  }
}

class _RecordCard extends StatelessWidget {
  final MedicalRecord record;
  final VoidCallback onTap;

  const _RecordCard({required this.record, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final color = medicalOutcomeColor(context, record.outcome);

    return AppCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(medicalOutcomeIcon(record.outcome), size: 18, color: color),
              const SizedBox(width: AppSpacing.sm),
              Text(
                medicalOutcomeLabel(context, record.outcome),
                style: AppTypography.labelSm.copyWith(color: color),
              ),
              const Spacer(),
              Text(
                DateFormat('d MMM y', 'ru').format(record.startedAt),
                style: AppTypography.labelSm
                    .copyWith(color: context.colors.onSurfaceVariant),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          if (record.rabbit != null)
            Text(
              record.rabbit!.name,
              style: AppTypography.titleMd
                  .copyWith(color: context.colors.onSurface),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            record.diagnosis?.trim().isNotEmpty == true
                ? record.diagnosis!.trim()
                : context.l10n.medNoDiagnosis,
            style: AppTypography.bodyLg.copyWith(
              color: record.diagnosis?.trim().isNotEmpty == true
                  ? context.colors.onSurface
                  : context.colors.onSurfaceVariant,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            record.symptoms,
            style: AppTypography.bodyMd
                .copyWith(color: context.colors.onSurfaceVariant),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          if (record.cost != null || record.veterinarian != null) ...[
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                if (record.cost != null) ...[
                  Icon(Icons.payments_outlined,
                      size: 16, color: context.colors.onSurfaceVariant),
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    formatMoney(record.cost!),
                    style: AppTypography.labelSm
                        .copyWith(color: context.colors.onSurfaceVariant),
                  ),
                  const SizedBox(width: AppSpacing.lg),
                ],
                if (record.veterinarian?.trim().isNotEmpty == true) ...[
                  Icon(Icons.person_outline,
                      size: 16, color: context.colors.onSurfaceVariant),
                  const SizedBox(width: AppSpacing.xs),
                  Expanded(
                    child: Text(
                      record.veterinarian!.trim(),
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
        ],
      ),
    );
  }
}

class _DetailsSheet extends ConsumerWidget {
  final MedicalRecord record;

  const _DetailsSheet({required this.record});

  Future<void> _delete(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l10n.medDeleteTitle),
        content: Text(context.l10n.medDeleteBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(context.l10n.commonCancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: Text(context.l10n.commonDelete),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;

    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    final done = context.l10n.medDeleted;
    final failed = context.l10n.medDeleteFailed;

    try {
      await ref
          .read(medicalRecordsProvider.notifier)
          .deleteMedicalRecord(record.id);
      navigator.pop();
      messenger.showSnackBar(SnackBar(content: Text(done)));
    } catch (_) {
      messenger.showSnackBar(
        SnackBar(content: Text(failed), backgroundColor: AppColors.error),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final format = DateFormat('d MMMM y', 'ru');
    final canRecord = ref.watch(canProvider(FarmCapability.recordDailyWork));
    final canDelete = ref.watch(canProvider(FarmCapability.deleteRecords));

    return SafeArea(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * 0.8,
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.screenH,
            0,
            AppSpacing.screenH,
            AppSpacing.lg,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      record.rabbit?.name ?? context.l10n.navRabbits,
                      style: AppTypography.displayMd
                          .copyWith(color: context.colors.onSurface),
                    ),
                  ),
                  if (canRecord)
                    IconButton(
                      icon: const Icon(Icons.edit_outlined),
                      onPressed: () {
                        Navigator.pop(context);
                        context.push('/medical-records/form', extra: record);
                      },
                    ),
                  if (canDelete)
                    IconButton(
                      icon: const Icon(Icons.delete_outline),
                      color: AppColors.error,
                      onPressed: () => _delete(context, ref),
                    ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              _Row(
                icon: medicalOutcomeIcon(record.outcome),
                label: context.l10n.medFormOutcome,
                value: medicalOutcomeLabel(context, record.outcome),
                color: medicalOutcomeColor(context, record.outcome),
              ),
              if (record.diagnosis?.trim().isNotEmpty == true)
                _Row(
                  icon: Icons.medical_information_outlined,
                  label: context.l10n.medDiagnosis,
                  value: record.diagnosis!.trim(),
                ),
              _Row(
                icon: Icons.sick_outlined,
                label: context.l10n.medSymptoms,
                value: record.symptoms,
              ),
              if (record.treatment?.trim().isNotEmpty == true)
                _Row(
                  icon: Icons.healing_outlined,
                  label: context.l10n.medTreatment,
                  value: record.treatment!.trim(),
                ),
              if (record.medication?.trim().isNotEmpty == true)
                _Row(
                  icon: Icons.medication_outlined,
                  label: context.l10n.medMedication,
                  value: record.medication!.trim(),
                ),
              _Row(
                icon: Icons.event_available_outlined,
                label: context.l10n.medStarted,
                value: format.format(record.startedAt),
              ),
              if (record.endedAt != null)
                _Row(
                  icon: Icons.event_outlined,
                  label: context.l10n.medEnded,
                  value: format.format(record.endedAt!),
                ),
              if (record.cost != null)
                _Row(
                  icon: Icons.payments_outlined,
                  label: context.l10n.medCost,
                  value: formatMoney(record.cost!),
                ),
              if (record.veterinarian?.trim().isNotEmpty == true)
                _Row(
                  icon: Icons.person_outline,
                  label: context.l10n.medVet,
                  value: record.veterinarian!.trim(),
                ),
              if (record.notes?.trim().isNotEmpty == true)
                _Row(
                  icon: Icons.sticky_note_2_outlined,
                  label: context.l10n.medNotes,
                  value: record.notes!.trim(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? color;

  const _Row({
    required this.icon,
    required this.label,
    required this.value,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: color ?? context.colors.onSurfaceVariant),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTypography.labelSm
                      .copyWith(color: context.colors.onSurfaceVariant),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  value,
                  style: AppTypography.bodyLg
                      .copyWith(color: color ?? context.colors.onSurface),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatisticsSheet extends ConsumerWidget {
  const _StatisticsSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(medicalStatisticsProvider);

    return SafeArea(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * 0.8,
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.screenH,
            0,
            AppSpacing.screenH,
            AppSpacing.lg,
          ),
          child: AppAsyncView<MedicalStatistics>(
            value: statsAsync,
            onRetry: () => ref.invalidate(medicalStatisticsProvider),
            skeleton: (_) => const Padding(
              padding: EdgeInsets.symmetric(vertical: AppSpacing.xl),
              child: SkeletonStatRow(count: 3, height: 64),
            ),
            builder: (stats) => Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppSectionTitle(context.l10n.medStats),
                _StatLine(
                  label: context.l10n.medStatTotal,
                  value: '${stats.totalRecords}',
                ),
                _StatLine(
                  label: medicalOutcomeLabel(context, MedicalOutcome.ongoing),
                  value: '${stats.byOutcome.ongoing}',
                  color: AppColors.warning,
                ),
                _StatLine(
                  label:
                      medicalOutcomeLabel(context, MedicalOutcome.recovered),
                  value: '${stats.byOutcome.recovered}',
                  color: AppColors.success,
                ),
                _StatLine(
                  label: medicalOutcomeLabel(context, MedicalOutcome.died),
                  value: '${stats.byOutcome.died}',
                  color: AppColors.error,
                ),
                _StatLine(
                  label:
                      medicalOutcomeLabel(context, MedicalOutcome.euthanized),
                  value: '${stats.byOutcome.euthanized}',
                ),
                const Divider(height: AppSpacing.xxl),
                _StatLine(
                  label: context.l10n.medStatCost,
                  value: formatMoney(stats.totalCost),
                ),
                _StatLine(
                  label: context.l10n.medStatThisYear,
                  value: '${stats.thisYear}',
                ),
                _StatLine(
                  label: context.l10n.medStatLastMonth,
                  value: '${stats.lastMonth}',
                ),
                if (stats.ongoingTreatments.isNotEmpty) ...[
                  const Divider(height: AppSpacing.xxl),
                  AppSectionTitle(context.l10n.medStatOngoing),
                  for (final treatment in stats.ongoingTreatments.take(5))
                    Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.md),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  treatment.rabbitName ??
                                      context.l10n.breedingNameMissing,
                                  style: AppTypography.bodyLg.copyWith(
                                      color: context.colors.onSurface),
                                ),
                                Text(
                                  treatment.diagnosis?.trim().isNotEmpty == true
                                      ? treatment.diagnosis!.trim()
                                      : context.l10n.medNoDiagnosis,
                                  style: AppTypography.labelSm.copyWith(
                                      color: context.colors.onSurfaceVariant),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            context.l10n.medDaysOngoing(treatment.daysOngoing),
                            style: AppTypography.labelLg
                                .copyWith(color: AppColors.warning),
                          ),
                        ],
                      ),
                    ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StatLine extends StatelessWidget {
  final String label;
  final String value;
  final Color? color;

  const _StatLine({required this.label, required this.value, this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTypography.bodyMd
                .copyWith(color: context.colors.onSurface),
          ),
          Text(
            value,
            style: AppTypography.labelLg
                .copyWith(color: color ?? context.colors.onSurface),
          ),
        ],
      ),
    );
  }
}
