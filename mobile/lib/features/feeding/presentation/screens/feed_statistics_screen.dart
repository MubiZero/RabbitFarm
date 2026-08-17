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
import '../../data/models/feed_model.dart';
import '../providers/feeds_provider.dart';
import '../utils/feed_labels.dart';

/// Аналитика склада кормов: состав запаса, его стоимость и что заканчивается.
class FeedStatisticsScreen extends ConsumerWidget {
  const FeedStatisticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(feedStatisticsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Аналитика склада')),
      body: statsAsync.when(
        loading: () => const _FeedStatisticsSkeleton(),
        error: (error, _) => AppErrorState(
          message: error.toString(),
          onRetry: () => ref.invalidate(feedStatisticsProvider),
        ),
        data: (stats) => _buildContent(context, ref, stats),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    WidgetRef ref,
    FeedStatistics stats,
  ) {
    if (stats.totalFeeds == 0) {
      return AppEmptyState(
        icon: Icons.inventory_2_outlined,
        title: 'Склад пока пуст',
        subtitle: 'Добавьте корма — здесь появится состав запаса, '
            'его стоимость и предупреждения об остатках.',
        actionLabel: 'Добавить корм',
        onAction: () => context.push('/feeds/form'),
      );
    }

    final byType = <FeedType, int>{
      FeedType.pellets: stats.byType.pellets,
      FeedType.hay: stats.byType.hay,
      FeedType.vegetables: stats.byType.vegetables,
      FeedType.grain: stats.byType.grain,
      FeedType.supplements: stats.byType.supplements,
      FeedType.other: stats.byType.other,
    };
    final presentTypes = byType.entries.where((e) => e.value > 0).toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final maxCount = presentTypes.isEmpty ? 0 : presentTypes.first.value;

    final hasLowStock = stats.lowStockCount > 0;

    return RefreshIndicator(
      onRefresh: () async => ref.invalidate(feedStatisticsProvider),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        children: [
          Row(
            children: [
              Expanded(
                child: StatTile(
                  icon: Icons.inventory_2_outlined,
                  label: 'Позиций на складе',
                  value: '${stats.totalFeeds}',
                  accent: AppColors.accentOcean,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: StatTile(
                  icon: Icons.warning_amber_rounded,
                  label: 'Заканчивается',
                  value: '${stats.lowStockCount}',
                  accent: hasLowStock ? AppColors.warning : AppColors.success,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          AppCard(
            child: Row(
              children: [
                Icon(
                  Icons.account_balance_wallet_outlined,
                  size: 28,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Стоимость запаса',
                        style: AppTypography.labelSm.copyWith(
                          color:
                              Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        formatMoney(stats.totalStockValue),
                        style: AppTypography.displayMd.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (presentTypes.isNotEmpty) ...[
            const SizedBox(height: 24),
            _SectionTitle('Состав по типам'),
            const SizedBox(height: 12),
            AppCard(
              child: Column(
                children: [
                  for (final entry in presentTypes)
                    MetricBar(
                      icon: entry.key.icon,
                      label: entry.key.displayName,
                      value: '${entry.value}',
                      fraction: maxCount == 0 ? 0 : entry.value / maxCount,
                      color: entry.key.color,
                    ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 24),
          _SectionTitle('Остатки на исходе'),
          const SizedBox(height: 12),
          if (hasLowStock)
            AppCard(
              variant: AppCardVariant.error,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Column(
                children: [
                  for (final item in stats.lowStockItems)
                    _LowStockRow(item: item),
                ],
              ),
            )
          else
            AppCard(
              child: Row(
                children: [
                  const Icon(
                    Icons.check_circle_outline,
                    color: AppColors.success,
                    size: 22,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Запасов хватает по всем позициям',
                      style: AppTypography.bodyMd.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ),
                ],
              ),
            ),
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

class _LowStockRow extends StatelessWidget {
  final LowStockItem item;

  const _LowStockRow({required this.item});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    // Доля от минимального остатка: чем короче полоса, тем срочнее закупка.
    final fraction = item.minStock <= 0 ? 1.0 : item.currentStock / item.minStock;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  item.name,
                  style: AppTypography.bodyMd.copyWith(color: cs.onSurface),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                formatQuantity(item.currentStock, item.unit),
                style: AppTypography.labelLg.copyWith(color: AppColors.warning),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: fraction.clamp(0.0, 1.0),
                    minHeight: 6,
                    backgroundColor: cs.surfaceContainerHighest,
                    valueColor:
                        const AlwaysStoppedAnimation(AppColors.warning),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'минимум ${formatQuantity(item.minStock, item.unit)}',
                style: AppTypography.labelSm.copyWith(
                  color: cs.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FeedStatisticsSkeleton extends StatelessWidget {
  const _FeedStatisticsSkeleton();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      children: const [
        Row(
          children: [
            Expanded(child: SkeletonBox(height: 104)),
            SizedBox(width: 12),
            Expanded(child: SkeletonBox(height: 104)),
          ],
        ),
        SizedBox(height: 12),
        SkeletonBox(height: 84),
        SizedBox(height: 24),
        SkeletonBox(width: 140, height: 12),
        SizedBox(height: 12),
        SkeletonBox(height: 180),
        SizedBox(height: 24),
        SkeletonBox(width: 140, height: 12),
        SizedBox(height: 12),
        SkeletonBox(height: 120),
      ],
    );
  }
}
