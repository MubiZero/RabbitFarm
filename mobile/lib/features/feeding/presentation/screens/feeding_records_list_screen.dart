import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/access/farm_access.dart';
import '../../../../core/l10n/l10n_context.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/utils/format_utils.dart';
import '../../../../core/widgets/widgets.dart';
import '../../data/models/feed_model.dart';
import '../../data/models/feeding_record_model.dart';
import '../providers/feeding_records_provider.dart';

/// История кормлений.
class FeedingRecordsListScreen extends ConsumerStatefulWidget {
  const FeedingRecordsListScreen({super.key});

  @override
  ConsumerState<FeedingRecordsListScreen> createState() =>
      _FeedingRecordsListScreenState();
}

class _FeedingRecordsListScreenState
    extends ConsumerState<FeedingRecordsListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(feedingRecordsProvider.notifier)
          .loadFeedingRecords(refresh: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(feedingRecordsProvider);
    final notifier = ref.read(feedingRecordsProvider.notifier);
    final canRecord = ref.watch(canProvider(FarmCapability.recordDailyWork));

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.feedingTitle),
        actions: [
          IconButton(
            tooltip: context.l10n.commonSummary,
            icon: const Icon(Icons.insights_outlined),
            onPressed: () => context.push('/feeding-records/statistics'),
          ),
          IconButton(
            tooltip: context.l10n.commonPeriod,
            icon: Icon(state.hasFilters
                ? Icons.filter_list_alt
                : Icons.filter_list),
            onPressed: () => _showPeriodPicker(context),
          ),
        ],
      ),
      body: PagedListView<FeedingRecord>(
        items: state.records,
        isLoading: state.isLoading,
        error: state.error,
        hasMore: state.hasMore,
        onRefresh: notifier.refresh,
        onLoadMore: notifier.loadMore,
        header: state.hasFilters ? _PeriodChips(state: state) : null,
        empty: state.hasFilters
            ? AppEmptyState(
                icon: Icons.event_busy_outlined,
                title: context.l10n.feedingNoneInView,
                subtitle: context.l10n.feedingNoneInViewBody,
                actionLabel: context.l10n.commonReset,
                onAction: () => notifier.setPeriod(null, null),
              )
            : AppEmptyState(
                icon: Icons.restaurant_outlined,
                title: context.l10n.feedingEmptyTitle,
                subtitle: context.l10n.feedingEmptyBody,
                actionLabel: canRecord ? context.l10n.feedingAdd : null,
                onAction: canRecord
                    ? () => context.push('/feeding-records/form')
                    : null,
              ),
        itemBuilder: (context, record, _) => _RecordCard(
          record: record,
          canRecord: canRecord,
          onTap: canRecord
              ? () => context.push('/feeding-records/form', extra: record)
              : null,
          onDelete: () => _delete(record),
        ),
      ),
      floatingActionButton: canRecord
          ? FloatingActionButton.extended(
              onPressed: () => context.push('/feeding-records/form'),
              icon: const Icon(Icons.add),
              label: Text(context.l10n.feedingAdd),
            )
          : null,
    );
  }

  Future<void> _delete(FeedingRecord record) async {
    final messenger = ScaffoldMessenger.of(context);
    final done = context.l10n.feedingDeleted;
    final failed = context.l10n.feedingDeleteFailed;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l10n.feedingDeleteTitle),
        content: Text(context.l10n.feedingDeleteBody),
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
    if (confirmed != true) return;

    final error =
        await ref.read(feedingRecordsProvider.notifier).deleteRecord(record.id);
    messenger.showSnackBar(
      error == null
          ? SnackBar(content: Text(done))
          : SnackBar(
              content: Text('$failed: $error'),
              backgroundColor: AppColors.error,
            ),
    );
  }

  Future<void> _showPeriodPicker(BuildContext context) async {
    final state = ref.read(feedingRecordsProvider);
    final range = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: state.fromDate != null && state.toDate != null
          ? DateTimeRange(start: state.fromDate!, end: state.toDate!)
          : null,
      // Один выбор диапазона вместо двух отдельных календарей: раньше начало
      // и конец периода выбирались в разных диалогах, и перепутать их местами
      // ничего не мешало.
      helpText: context.l10n.commonPeriod,
    );
    if (range == null) return;
    await ref
        .read(feedingRecordsProvider.notifier)
        .setPeriod(range.start, range.end);
  }
}

class _PeriodChips extends ConsumerWidget {
  final FeedingRecordsState state;

  const _PeriodChips({required this.state});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final format = DateFormat('d MMM y', 'ru');
    final from = state.fromDate;
    final to = state.toDate;

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
          label: Text([
            if (from != null) format.format(from),
            if (to != null) format.format(to),
          ].join(' — ')),
          deleteIcon: const Icon(Icons.close, size: 16),
          onDeleted: () => ref
              .read(feedingRecordsProvider.notifier)
              .setPeriod(null, null),
        ),
      ),
    );
  }
}

class _RecordCard extends StatelessWidget {
  final FeedingRecord record;
  final bool canRecord;
  final VoidCallback? onTap;
  final VoidCallback onDelete;

  const _RecordCard({
    required this.record,
    required this.canRecord,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    // Раньше при отсутствии связанного корма показывался номер записи в базе
    // («Корм #17») — для фермера это не подсказка.
    final feedName = record.feed?.name ?? context.l10n.feedingUnknownFeed;
    final unit = record.feed?.unit.displayName;

    final target = record.rabbit != null
        ? context.l10n.feedingForRabbit(record.rabbit!.name)
        : record.cage != null
            ? context.l10n.feedingForCage(record.cage!.number)
            : context.l10n.feedingForFarm;

    return AppCard(
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: AppColors.domainFeeding.withValues(alpha: 0.12),
              borderRadius: AppRadius.smAll,
            ),
            child: const Icon(Icons.restaurant_outlined,
                color: AppColors.domainFeeding, size: 20),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  feedName,
                  style: AppTypography.titleMd
                      .copyWith(color: context.colors.onSurface),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  target,
                  style: AppTypography.bodyMd
                      .copyWith(color: context.colors.onSurfaceVariant),
                ),
                const SizedBox(height: AppSpacing.xs),
                Row(
                  children: [
                    Icon(Icons.scale_outlined,
                        size: 14, color: context.colors.onSurfaceVariant),
                    const SizedBox(width: AppSpacing.xs),
                    Text(
                      formatQuantity(record.quantity, unit),
                      style: AppTypography.labelLg
                          .copyWith(color: context.colors.onSurface),
                    ),
                    const SizedBox(width: AppSpacing.lg),
                    Icon(Icons.schedule,
                        size: 14, color: context.colors.onSurfaceVariant),
                    const SizedBox(width: AppSpacing.xs),
                    Expanded(
                      child: Text(
                        DateFormat('d MMM, HH:mm', 'ru').format(record.fedAt),
                        style: AppTypography.labelSm
                            .copyWith(color: context.colors.onSurfaceVariant),
                      ),
                    ),
                  ],
                ),
                if (record.notes?.trim().isNotEmpty == true) ...[
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    record.notes!.trim(),
                    style: AppTypography.bodyMd
                        .copyWith(color: context.colors.onSurfaceVariant),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
          if (canRecord)
            IconButton(
              tooltip: context.l10n.commonDelete,
              icon: const Icon(Icons.delete_outline),
              color: context.colors.onSurfaceVariant,
              onPressed: onDelete,
            ),
        ],
      ),
    );
  }
}
