import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/format_utils.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_error_state.dart';
import '../../../../core/widgets/metric_bar.dart';
import '../../../../core/widgets/skeleton.dart';
import '../../../../core/widgets/stat_tile.dart';
import '../../../../core/widgets/stats_period.dart';
import '../../data/models/feed_model.dart';
import '../../data/models/feeding_record_model.dart';
import '../providers/feeding_records_provider.dart';
import '../utils/feed_labels.dart';

/// Аналитика кормлений: сколько раз кормили, чем и на какую сумму.
class FeedingStatisticsScreen extends ConsumerStatefulWidget {
  const FeedingStatisticsScreen({super.key});

  @override
  ConsumerState<FeedingStatisticsScreen> createState() =>
      _FeedingStatisticsScreenState();
}

class _FeedingStatisticsScreenState
    extends ConsumerState<FeedingStatisticsScreen> {
  StatsPeriod _period = StatsPeriod.month;

  ({DateTime? fromDate, DateTime? toDate}) get _params =>
      (fromDate: _period.fromDate, toDate: null);

  @override
  Widget build(BuildContext context) {
    final statsAsync = ref.watch(feedingStatisticsProvider(_params));

    return Scaffold(
      appBar: AppBar(title: const Text('Аналитика кормлений')),
      body: Column(
        children: [
          StatsPeriodBar(
            selected: _period,
            onChanged: (period) => setState(() => _period = period),
          ),
          Expanded(
            child: statsAsync.when(
              loading: () => const _FeedingStatisticsSkeleton(),
              error: (error, _) => AppErrorState(
                message: error.toString(),
                onRetry: () =>
                    ref.invalidate(feedingStatisticsProvider(_params)),
              ),
              data: (stats) => _buildContent(stats),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(FeedingStatistics stats) {
    if (stats.totalFeedings == 0) {
      return AppEmptyState(
        icon: Icons.restaurant_outlined,
        title: 'За этот период кормлений не было',
        subtitle: 'Выберите период шире или запишите кормление — '
            'расход корма и затраты посчитаются сами.',
        actionLabel: 'Записать кормление',
        onAction: () => context.push('/feeding-records/form'),
      );
    }

    final byType = <FeedType, double>{
      FeedType.pellets: stats.byFeedType.pellets,
      FeedType.hay: stats.byFeedType.hay,
      FeedType.vegetables: stats.byFeedType.vegetables,
      FeedType.grain: stats.byFeedType.grain,
      FeedType.supplements: stats.byFeedType.supplements,
      FeedType.other: stats.byFeedType.other,
    };
    final presentTypes = byType.entries.where((e) => e.value > 0).toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final maxByType = presentTypes.isEmpty ? 0.0 : presentTypes.first.value;

    final byFeed = stats.byFeed.entries.toList()
      ..sort((a, b) => b.value.quantity.compareTo(a.value.quantity));

    return RefreshIndicator(
      onRefresh: () async => ref.invalidate(feedingStatisticsProvider(_params)),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        children: [
          Row(
            children: [
              Expanded(
                child: StatTile(
                  icon: Icons.restaurant,
                  label: 'Кормлений',
                  value: '${stats.totalFeedings}',
                  accent: AppColors.accentOcean,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: StatTile(
                  icon: Icons.payments_outlined,
                  label: 'Затраты на корм',
                  value: formatMoney(stats.totalCost),
                  accent: AppColors.accentSunset,
                ),
              ),
            ],
          ),
          if (presentTypes.isNotEmpty) ...[
            const SizedBox(height: 24),
            _SectionTitle('Расход по типам корма'),
            const SizedBox(height: 12),
            AppCard(
              child: Column(
                children: [
                  for (final entry in presentTypes)
                    MetricBar(
                      icon: entry.key.icon,
                      label: entry.key.displayName,
                      value: formatQuantity(entry.value),
                      fraction: maxByType == 0 ? 0 : entry.value / maxByType,
                      color: entry.key.color,
                    ),
                ],
              ),
            ),
          ],
          if (byFeed.isNotEmpty) ...[
            const SizedBox(height: 24),
            _SectionTitle('По кормам'),
            const SizedBox(height: 12),
            AppCard(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Column(
                children: [
                  for (final entry in byFeed)
                    _FeedUsageRow(name: entry.key, usage: entry.value),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Text(
      title.toUpperCase(),
      style: AppTypography.labelSm.copyWith(
        color: Theme.of(context).colorScheme.onSurfaceVariant,
        letterSpacing: 1.2,
      ),
    );
  }
}

class _FeedUsageRow extends StatelessWidget {
  final String name;
  final FeedingByFeed usage;

  const _FeedUsageRow({required this.name, required this.usage});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: Text(
              name,
              style: AppTypography.bodyMd.copyWith(color: cs.onSurface),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                formatQuantity(usage.quantity, usage.unit),
                style: AppTypography.labelLg.copyWith(color: cs.onSurface),
              ),
              if (usage.cost > 0)
                Text(
                  formatMoney(usage.cost),
                  style:
                      AppTypography.labelSm.copyWith(color: cs.onSurfaceVariant),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FeedingStatisticsSkeleton extends StatelessWidget {
  const _FeedingStatisticsSkeleton();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
      children: const [
        Row(
          children: [
            Expanded(child: SkeletonBox(height: 104)),
            SizedBox(width: 12),
            Expanded(child: SkeletonBox(height: 104)),
          ],
        ),
        SizedBox(height: 24),
        SkeletonBox(width: 180, height: 12),
        SizedBox(height: 12),
        SkeletonBox(height: 180),
        SizedBox(height: 24),
        SkeletonBox(width: 120, height: 12),
        SizedBox(height: 12),
        SkeletonBox(height: 160),
      ],
    );
  }
}
