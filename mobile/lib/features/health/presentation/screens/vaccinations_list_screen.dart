import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/access/farm_access.dart';
import '../../../../core/l10n/l10n_context.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../../data/models/vaccination_model.dart';
import '../providers/vaccinations_provider.dart';

/// Список прививок.
class VaccinationsListScreen extends ConsumerWidget {
  const VaccinationsListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(vaccinationsProvider);
    final notifier = ref.read(vaccinationsProvider.notifier);
    final canRecord = ref.watch(canProvider(FarmCapability.recordDailyWork));

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.vaccinationsTitle),
        actions: [
          IconButton(
            tooltip: context.l10n.vaccinationsStats,
            icon: const Icon(Icons.insights_outlined),
            onPressed: () => showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (_) => const _StatisticsSheet(),
            ),
          ),
          IconButton(
            tooltip: context.l10n.tasksFilters,
            icon: Icon(state.typeFilter != null
                ? Icons.filter_list_alt
                : Icons.filter_list),
            onPressed: () => showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (_) => const _FiltersSheet(),
            ),
          ),
        ],
      ),
      body: PagedListView<Vaccination>(
        items: state.vaccinations,
        isLoading: state.isLoading,
        error: state.error,
        onRefresh: notifier.load,
        header: _ViewTabs(state: state),
        empty: state.hasFilters
            ? AppEmptyState(
                icon: Icons.filter_alt_off_outlined,
                title: context.l10n.vaccinationsNoneInView,
                subtitle: context.l10n.vaccinationsNoneInViewBody,
                actionLabel: context.l10n.tasksFiltersReset,
                onAction: notifier.clearFilters,
              )
            : AppEmptyState(
                icon: Icons.vaccines_outlined,
                title: context.l10n.vaccinationsEmptyTitle,
                subtitle: context.l10n.vaccinationsEmptyBody,
                actionLabel: canRecord
                    ? context.l10n.vaccinationsEmptyAction
                    : null,
                onAction: canRecord
                    ? () => context.push('/vaccinations/form')
                    : null,
              ),
        itemBuilder: (context, vaccination, _) => _VaccinationCard(
          vaccination: vaccination,
          onTap: () => showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (_) => _DetailsSheet(vaccination: vaccination),
          ),
        ),
      ),
      floatingActionButton: canRecord
          ? FloatingActionButton(
              tooltip: context.l10n.vaccinationsEmptyAction,
              onPressed: () => context.push('/vaccinations/form'),
              child: const Icon(Icons.add, size: 28),
            )
          : null,
    );
  }
}

/// Вкладки выборки. Выбранная подсвечена — раньше это были обычные кнопки без
/// состояния, и понять, какая выборка показана, было нельзя.
class _ViewTabs extends ConsumerWidget {
  final VaccinationsState state;

  const _ViewTabs({required this.state});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(vaccinationsProvider.notifier);
    final l10n = context.l10n;

    final tabs = <(VaccinationView, String)>[
      (VaccinationView.all, l10n.vaccinationsViewAll),
      (VaccinationView.upcoming, l10n.vaccinationsViewUpcoming),
      (VaccinationView.overdue, l10n.vaccinationsViewOverdue),
      (VaccinationView.last30Days, l10n.vaccinationsViewLast30),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppFilterBar(
          chips: [
            for (final (view, label) in tabs)
              AppFilterChipData(
                label: label,
                isSelected: state.view == view,
                onTap: () => notifier.setView(view),
                color: view == VaccinationView.overdue ? AppColors.error : null,
              ),
          ],
        ),
        if (state.typeFilter != null ||
            state.fromDateFilter != null ||
            state.toDateFilter != null)
          _ActiveFilters(state: state),
      ],
    );
  }
}

class _ActiveFilters extends ConsumerWidget {
  final VaccinationsState state;

  const _ActiveFilters({required this.state});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(vaccinationsProvider.notifier);
    final format = DateFormat('d MMM y', 'ru');

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenH,
        0,
        AppSpacing.screenH,
        AppSpacing.sm,
      ),
      child: Wrap(
        spacing: AppSpacing.sm,
        runSpacing: AppSpacing.sm,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          if (state.typeFilter != null)
            InputChip(
              label: Text(state.typeFilter!.displayName),
              deleteIcon: const Icon(Icons.close, size: 16),
              onDeleted: () => notifier.setTypeFilter(null),
            ),
          if (state.fromDateFilter != null)
            InputChip(
              label: Text(
                  '${context.l10n.vaccinationsFrom} ${format.format(state.fromDateFilter!)}'),
              deleteIcon: const Icon(Icons.close, size: 16),
              onDeleted: () =>
                  notifier.setDateFilter(null, state.toDateFilter),
            ),
          if (state.toDateFilter != null)
            InputChip(
              label: Text(
                  '${context.l10n.vaccinationsTo} ${format.format(state.toDateFilter!)}'),
              deleteIcon: const Icon(Icons.close, size: 16),
              onDeleted: () =>
                  notifier.setDateFilter(state.fromDateFilter, null),
            ),
          TextButton.icon(
            onPressed: notifier.clearFilters,
            icon: const Icon(Icons.clear_all, size: 18),
            label: Text(context.l10n.vaccinationsResetAll),
          ),
        ],
      ),
    );
  }
}

class _VaccinationCard extends StatelessWidget {
  final Vaccination vaccination;
  final VoidCallback onTap;

  const _VaccinationCard({required this.vaccination, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final next = vaccination.nextVaccinationDate;
    final overdue = next != null && next.isBefore(DateTime.now());
    final format = DateFormat('d MMMM y', 'ru');

    return AppCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  vaccination.vaccineName,
                  style: AppTypography.titleMd
                      .copyWith(color: context.colors.onSurface),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              _TypeChip(type: vaccination.vaccineType),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          if (vaccination.rabbit != null)
            _Line(
              icon: Icons.pets_outlined,
              text: vaccination.rabbit!.name,
              strong: true,
            ),
          _Line(
            icon: Icons.event_available_outlined,
            text: format.format(vaccination.vaccinationDate),
          ),
          if (next != null)
            _Line(
              icon: overdue ? Icons.event_busy_outlined : Icons.event_outlined,
              text: context.l10n.vaccinationsNext(format.format(next)),
              color: overdue ? AppColors.error : AppColors.success,
              trailing: overdue
                  ? _Badge(
                      label: context.l10n.vaccinationsOverdueBadge,
                      color: AppColors.error,
                    )
                  : vaccination.daysUntil != null
                      ? _Badge(
                          label: context.l10n
                              .vaccinationsInDays(vaccination.daysUntil!),
                          color: AppColors.success,
                        )
                      : null,
            ),
          if (vaccination.veterinarian?.trim().isNotEmpty == true)
            _Line(
              icon: Icons.person_outline,
              text: vaccination.veterinarian!.trim(),
            ),
        ],
      ),
    );
  }
}

class _Line extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color? color;
  final bool strong;
  final Widget? trailing;

  const _Line({
    required this.icon,
    required this.text,
    this.color,
    this.strong = false,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final effective = color ?? context.colors.onSurfaceVariant;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        children: [
          Icon(icon, size: 16, color: effective),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              text,
              style: (strong ? AppTypography.bodyLg : AppTypography.bodyMd)
                  .copyWith(
                color: strong ? context.colors.onSurface : effective,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String label;
  final Color color;

  const _Badge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: AppRadius.pillAll,
      ),
      child: Text(label, style: AppTypography.labelSm.copyWith(color: color)),
    );
  }
}

class _TypeChip extends StatelessWidget {
  final VaccineType type;

  const _TypeChip({required this.type});

  @override
  Widget build(BuildContext context) {
    // Цвет и текст берутся из одной пары, поэтому подпись всегда читается:
    // раньше текст оставался тёмным на любой подложке.
    final color = switch (type) {
      VaccineType.vhd => AppColors.error,
      VaccineType.myxomatosis => AppColors.info,
      VaccineType.pasteurellosis => AppColors.warning,
      VaccineType.other => context.colors.onSurfaceVariant,
    };

    return _Badge(label: type.displayName, color: color);
  }
}

class _FiltersSheet extends ConsumerStatefulWidget {
  const _FiltersSheet();

  @override
  ConsumerState<_FiltersSheet> createState() => _FiltersSheetState();
}

class _FiltersSheetState extends ConsumerState<_FiltersSheet> {
  VaccineType? _type;
  DateTime? _from;
  DateTime? _to;

  @override
  void initState() {
    super.initState();
    final state = ref.read(vaccinationsProvider);
    _type = state.typeFilter;
    _from = state.fromDateFilter;
    _to = state.toDateFilter;
  }

  Future<void> _pick({required bool isFrom}) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: (isFrom ? _from : _to) ?? DateTime.now(),
      firstDate: isFrom ? DateTime(2000) : (_from ?? DateTime(2000)),
      lastDate: DateTime.now(),
    );
    if (picked == null) return;
    setState(() => isFrom ? _from = picked : _to = picked);
  }

  @override
  Widget build(BuildContext context) {
    final format = DateFormat('d MMM y', 'ru');

    return SafeArea(
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
              context.l10n.tasksFilters,
              style: AppTypography.titleLg
                  .copyWith(color: context.colors.onSurface),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              context.l10n.vaccinationsFilterType,
              style: AppTypography.labelLg
                  .copyWith(color: context.colors.onSurfaceVariant),
            ),
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: [
                for (final type in VaccineType.values)
                  ChoiceChip(
                    label: Text(type.displayName),
                    selected: _type == type,
                    onSelected: (selected) =>
                        setState(() => _type = selected ? type : null),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),
            Text(
              context.l10n.vaccinationsFilterPeriod,
              style: AppTypography.labelLg
                  .copyWith(color: context.colors.onSurfaceVariant),
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _pick(isFrom: true),
                    icon: const Icon(Icons.calendar_today, size: 18),
                    label: Text(_from == null
                        ? context.l10n.vaccinationsFrom
                        : format.format(_from!)),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _pick(isFrom: false),
                    icon: const Icon(Icons.calendar_today, size: 18),
                    label: Text(_to == null
                        ? context.l10n.vaccinationsTo
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
                      ref.read(vaccinationsProvider.notifier).clearFilters();
                      Navigator.pop(context);
                    },
                    child: Text(context.l10n.tasksFiltersReset),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: FilledButton(
                    onPressed: () {
                      final notifier =
                          ref.read(vaccinationsProvider.notifier);
                      notifier.setTypeFilter(_type);
                      notifier.setDateFilter(_from, _to);
                      Navigator.pop(context);
                    },
                    child: Text(context.l10n.tasksFiltersApply),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatisticsSheet extends ConsumerWidget {
  const _StatisticsSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(vaccinationStatisticsProvider);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.screenH,
          0,
          AppSpacing.screenH,
          AppSpacing.lg,
        ),
        child: AppAsyncView<VaccinationStatistics>(
          value: statsAsync,
          onRetry: () => ref.invalidate(vaccinationStatisticsProvider),
          skeleton: (_) => const Padding(
            padding: EdgeInsets.symmetric(vertical: AppSpacing.xl),
            child: SkeletonStatRow(count: 3, height: 64),
          ),
          builder: (stats) => Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppSectionTitle(context.l10n.vaccinationsStats),
              _StatRow(
                icon: Icons.vaccines_outlined,
                label: context.l10n.vaccinationsStatTotal,
                value: '${stats.totalVaccinations}',
                color: AppColors.domainHealth,
              ),
              _StatRow(
                icon: Icons.calendar_month_outlined,
                label: context.l10n.vaccinationsStatThisYear,
                value: '${stats.thisYear}',
                color: AppColors.domainHealth,
              ),
              _StatRow(
                icon: Icons.history,
                label: context.l10n.vaccinationsStatLast30,
                value: '${stats.last30Days}',
                color: AppColors.domainHealth,
              ),
              const Divider(height: AppSpacing.xxl),
              AppSectionTitle(context.l10n.vaccinationsStatUpcoming),
              _StatRow(
                icon: Icons.event_available_outlined,
                label: context.l10n.vaccinationsStatNext30,
                value: '${stats.upcoming.next30Days}',
                color: AppColors.success,
              ),
              _StatRow(
                icon: Icons.event_busy_outlined,
                label: context.l10n.vaccinationsStatOverdue,
                value: '${stats.upcoming.overdue}',
                color: AppColors.error,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              label,
              style: AppTypography.bodyMd
                  .copyWith(color: context.colors.onSurface),
            ),
          ),
          Text(
            value,
            style: AppTypography.titleLg.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}

class _DetailsSheet extends ConsumerWidget {
  final Vaccination vaccination;

  const _DetailsSheet({required this.vaccination});

  Future<void> _delete(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l10n.vaccinationsDeleteTitle),
        content: Text(context.l10n.vaccinationsDeleteBody),
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
    final done = context.l10n.vaccinationsDeleted;
    final failed = context.l10n.vaccinationsDeleteFailed;

    final success = await ref
        .read(vaccinationsProvider.notifier)
        .deleteVaccination(vaccination.id);

    // Раньше при неудаче не происходило ничего: шторка оставалась открытой,
    // и было непонятно, удалилось или нет.
    if (success) {
      navigator.pop();
      messenger.showSnackBar(SnackBar(content: Text(done)));
    } else {
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
                      vaccination.vaccineName,
                      style: AppTypography.displayMd
                          .copyWith(color: context.colors.onSurface),
                    ),
                  ),
                  if (canRecord)
                    IconButton(
                      tooltip: context.l10n.commonSave,
                      icon: const Icon(Icons.edit_outlined),
                      onPressed: () {
                        Navigator.pop(context);
                        context.push('/vaccinations/form', extra: vaccination);
                      },
                    ),
                  if (canDelete)
                    IconButton(
                      tooltip: context.l10n.commonDelete,
                      icon: const Icon(Icons.delete_outline),
                      color: AppColors.error,
                      onPressed: () => _delete(context, ref),
                    ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              _DetailRow(
                icon: Icons.category_outlined,
                label: context.l10n.vaccinationsTypeLabel,
                value: vaccination.vaccineType.fullName,
              ),
              if (vaccination.rabbit != null)
                _DetailRow(
                  icon: Icons.pets_outlined,
                  label: context.l10n.navRabbits,
                  value: vaccination.rabbit!.name,
                ),
              _DetailRow(
                icon: Icons.event_available_outlined,
                label: context.l10n.vaccinationsDate,
                value: format.format(vaccination.vaccinationDate),
              ),
              if (vaccination.nextVaccinationDate != null)
                _DetailRow(
                  icon: Icons.event_outlined,
                  label: context.l10n.vaccinationsNextLabel,
                  value: format.format(vaccination.nextVaccinationDate!),
                ),
              if (vaccination.batchNumber?.trim().isNotEmpty == true)
                _DetailRow(
                  icon: Icons.tag,
                  label: context.l10n.vaccinationsBatchLabel,
                  value: vaccination.batchNumber!.trim(),
                ),
              if (vaccination.veterinarian?.trim().isNotEmpty == true)
                _DetailRow(
                  icon: Icons.person_outline,
                  label: context.l10n.vaccinationsVet,
                  value: vaccination.veterinarian!.trim(),
                ),
              if (vaccination.notes?.trim().isNotEmpty == true)
                _DetailRow(
                  icon: Icons.sticky_note_2_outlined,
                  label: context.l10n.vaccinationsNotesLabel,
                  value: vaccination.notes!.trim(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: context.colors.onSurfaceVariant),
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
                      .copyWith(color: context.colors.onSurface),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
