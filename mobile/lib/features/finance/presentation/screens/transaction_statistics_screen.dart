import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

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
import '../../data/models/transaction_model.dart';
import '../providers/transactions_provider.dart';
import '../utils/transaction_labels.dart';

/// Аналитика финансов: доходы, расходы, прибыль и структура по категориям.
class TransactionStatisticsScreen extends ConsumerStatefulWidget {
  const TransactionStatisticsScreen({super.key});

  @override
  ConsumerState<TransactionStatisticsScreen> createState() =>
      _TransactionStatisticsScreenState();
}

class _TransactionStatisticsScreenState
    extends ConsumerState<TransactionStatisticsScreen> {
  StatsPeriod _period = StatsPeriod.month;

  ({DateTime? fromDate, DateTime? toDate}) get _params =>
      (fromDate: _period.fromDate, toDate: null);

  @override
  Widget build(BuildContext context) {
    final statsAsync = ref.watch(financialStatisticsProvider(_params));

    return Scaffold(
      appBar: AppBar(title: const Text('Аналитика финансов')),
      body: Column(
        children: [
          StatsPeriodBar(
            selected: _period,
            onChanged: (period) => setState(() => _period = period),
          ),
          Expanded(
            child: statsAsync.when(
              loading: () => const _StatisticsSkeleton(),
              error: (error, _) => AppErrorState(
                message: error.toString(),
                onRetry: () =>
                    ref.invalidate(financialStatisticsProvider(_params)),
              ),
              data: (stats) => _buildContent(stats),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(FinancialStatistics stats) {
    if (stats.totalTransactions == 0) {
      return AppEmptyState(
        icon: Icons.query_stats,
        title: 'За этот период операций не было',
        subtitle: 'Выберите период шире или добавьте первую операцию — '
            'аналитика посчитается сама.',
        actionLabel: 'Добавить операцию',
        onAction: () => context.push('/transactions/form'),
      );
    }

    final isProfit = stats.netProfit >= 0;

    return RefreshIndicator(
      onRefresh: () async =>
          ref.invalidate(financialStatisticsProvider(_params)),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        children: [
          Row(
            children: [
              Expanded(
                child: StatTile(
                  icon: Icons.arrow_upward,
                  label: 'Доходы',
                  value: formatMoney(stats.totalIncome),
                  accent: AppColors.success,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: StatTile(
                  icon: Icons.arrow_downward,
                  label: 'Расходы',
                  value: formatMoney(stats.totalExpenses),
                  accent: AppColors.error,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          AppCard(
            variant: isProfit
                ? AppCardVariant.highlighted
                : AppCardVariant.error,
            child: Row(
              children: [
                Icon(
                  isProfit ? Icons.trending_up : Icons.trending_down,
                  color: isProfit ? AppColors.success : AppColors.error,
                  size: 28,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isProfit ? 'Прибыль' : 'Убыток',
                        style: AppTypography.labelSm.copyWith(
                          color:
                              Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        formatMoney(stats.netProfit.abs()),
                        style: AppTypography.displayMd.copyWith(
                          color: isProfit ? AppColors.success : AppColors.error,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  formatOperations(stats.totalTransactions),
                  style: AppTypography.labelSm.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          if (stats.incomeByCategory.isNotEmpty) ...[
            const SizedBox(height: 24),
            _CategoryBreakdown(
              title: 'Доходы по категориям',
              categories: stats.incomeByCategory,
              color: AppColors.success,
            ),
          ],
          if (stats.expensesByCategory.isNotEmpty) ...[
            const SizedBox(height: 24),
            _CategoryBreakdown(
              title: 'Расходы по категориям',
              categories: stats.expensesByCategory,
              color: AppColors.error,
            ),
          ],
          if (stats.recentTransactions.isNotEmpty) ...[
            const SizedBox(height: 24),
            _SectionTitle('Последние операции'),
            const SizedBox(height: 12),
            AppCard(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Column(
                children: [
                  for (final transaction in stats.recentTransactions)
                    _RecentTransactionRow(transaction: transaction),
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

class _CategoryBreakdown extends StatelessWidget {
  final String title;
  final List<CategoryStatistics> categories;
  final Color color;

  const _CategoryBreakdown({
    required this.title,
    required this.categories,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final sorted = [...categories]..sort((a, b) => b.total.compareTo(a.total));
    final max = sorted.first.total;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionTitle(title),
        const SizedBox(height: 12),
        AppCard(
          child: Column(
            children: [
              for (final item in sorted)
                MetricBar(
                  icon: item.category.icon,
                  label: item.category.label,
                  value: formatMoney(item.total),
                  fraction: max == 0 ? 0 : item.total / max,
                  color: color,
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _RecentTransactionRow extends StatelessWidget {
  final Transaction transaction;

  const _RecentTransactionRow({required this.transaction});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isIncome = transaction.type == TransactionType.income;
    final color = transaction.type.color;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Icon(transaction.category.icon, size: 20, color: color),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.category.label,
                  style: AppTypography.bodyMd.copyWith(color: cs.onSurface),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  DateFormat('dd MMM yyyy', 'ru_RU')
                      .format(transaction.transactionDate),
                  style:
                      AppTypography.labelSm.copyWith(color: cs.onSurfaceVariant),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '${isIncome ? '+' : '−'}${formatMoney(transaction.amount)}',
            style: AppTypography.labelLg.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}

/// Каркас с той же геометрией, что и загруженный экран, — контент
/// подставляется без прыжка раскладки.
class _StatisticsSkeleton extends StatelessWidget {
  const _StatisticsSkeleton();

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
        SizedBox(height: 12),
        SkeletonBox(height: 84),
        SizedBox(height: 24),
        SkeletonBox(width: 160, height: 12),
        SizedBox(height: 12),
        SkeletonBox(height: 180),
        SizedBox(height: 24),
        SkeletonBox(width: 160, height: 12),
        SizedBox(height: 12),
        SkeletonBox(height: 180),
      ],
    );
  }
}
