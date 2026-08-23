import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/access/farm_access.dart';
import '../../../../core/l10n/l10n_context.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/utils/format_utils.dart';
import '../../../../core/widgets/widgets.dart';
import '../../data/models/transaction_model.dart';
import '../providers/transactions_provider.dart';
import '../utils/transaction_labels.dart';
import '../../../../core/l10n/error_text.dart';

/// Ведомость доходов и расходов.
class TransactionsListScreen extends ConsumerStatefulWidget {
  const TransactionsListScreen({super.key});

  @override
  ConsumerState<TransactionsListScreen> createState() =>
      _TransactionsListScreenState();
}

class _TransactionsListScreenState
    extends ConsumerState<TransactionsListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(transactionsProvider.notifier).loadTransactions(refresh: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(transactionsProvider);
    final notifier = ref.read(transactionsProvider.notifier);
    final canManage = ref.watch(canProvider(FarmCapability.manageFinance));

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.financeTitle),
        actions: [
          IconButton(
            tooltip: context.l10n.commonSummary,
            icon: const Icon(Icons.insights_outlined),
            onPressed: () => context.push('/transactions/statistics'),
          ),
          IconButton(
            tooltip: context.l10n.commonFilters,
            icon: Icon(state.hasFilters
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
      body: PagedListView<Transaction>(
        items: state.transactions,
        isLoading: state.isLoading,
        error: state.error,
        hasMore: state.hasMore,
        onRefresh: notifier.refresh,
        onLoadMore: notifier.loadMore,
        header: _Header(state: state),
        separator: AppSpacing.sm,
        empty: state.hasFilters
            ? AppEmptyState(
                icon: Icons.filter_alt_off_outlined,
                title: context.l10n.financeNoneInView,
                subtitle: context.l10n.financeNoneInViewBody,
                actionLabel: context.l10n.commonReset,
                onAction: notifier.clearFilters,
              )
            : AppEmptyState(
                icon: Icons.account_balance_wallet_outlined,
                title: context.l10n.financeEmptyTitle,
                subtitle: context.l10n.financeEmptyBody,
                actionLabel: canManage ? context.l10n.financeAdd : null,
                onAction:
                    canManage ? () => context.push('/transactions/form') : null,
              ),
        itemBuilder: (context, transaction, _) => _TransactionCard(
          transaction: transaction,
          onTap: () => showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (_) => _DetailsSheet(transaction: transaction),
          ),
        ),
      ),
      floatingActionButton: canManage
          ? FloatingActionButton.extended(
              onPressed: () => context.push('/transactions/form'),
              icon: const Icon(Icons.add),
              label: Text(context.l10n.commonAdd),
            )
          : null,
    );
  }
}

class _Header extends ConsumerWidget {
  final TransactionsState state;

  const _Header({required this.state});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(transactionsProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Summary(state: state),
        AppFilterBar(
          chips: [
            AppFilterChipData(
              label: context.l10n.financeAll,
              isSelected: state.type == null,
              onTap: () => notifier.setFilters(
                category: state.category,
                fromDate: state.fromDate,
                toDate: state.toDate,
              ),
            ),
            AppFilterChipData(
              label: context.l10n.financeOnlyIncome,
              isSelected: state.type == TransactionType.income,
              onTap: () => notifier.setFilters(
                type: TransactionType.income,
                category: state.category,
                fromDate: state.fromDate,
                toDate: state.toDate,
              ),
              color: AppColors.success,
            ),
            AppFilterChipData(
              label: context.l10n.financeOnlyExpenses,
              isSelected: state.type == TransactionType.expense,
              onTap: () => notifier.setFilters(
                type: TransactionType.expense,
                category: state.category,
                fromDate: state.fromDate,
                toDate: state.toDate,
              ),
              color: AppColors.error,
            ),
          ],
        ),
        if (state.category != null ||
            state.fromDate != null ||
            state.toDate != null)
          _ActiveFilters(state: state),
      ],
    );
  }
}

/// Сводка за период.
///
/// Считается на сервере по тем же условиям, что и список. Раньше здесь
/// складывались только загруженные операции: при постраничной выдаче «Баланс»
/// показывал итог первого десятка записей, выдавая его за итог фермы.
class _Summary extends ConsumerWidget {
  final TransactionsState state;

  const _Summary({required this.state});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(financialStatisticsProvider(
      (fromDate: state.fromDate, toDate: state.toDate),
    ));

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenH,
        AppSpacing.md,
        AppSpacing.screenH,
        0,
      ),
      child: AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              state.fromDate != null || state.toDate != null
                  ? context.l10n.financeSummaryFiltered
                  : context.l10n.financeSummaryPeriod,
              style: AppTypography.labelSm
                  .copyWith(color: context.colors.onSurfaceVariant),
            ),
            const SizedBox(height: AppSpacing.md),
            statsAsync.when(
              data: (stats) => _SummaryRow(
                income: stats.totalIncome,
                expenses: stats.totalExpenses,
                profit: stats.netProfit,
              ),
              loading: () => const SkeletonBox(height: 44),
              error: (_, __) => Text(
                context.l10n.commonLoadFailed,
                style: AppTypography.bodyMd
                    .copyWith(color: context.colors.onSurfaceVariant),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final double income;
  final double expenses;
  final double profit;

  const _SummaryRow({
    required this.income,
    required this.expenses,
    required this.profit,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _SummaryItem(
          label: context.l10n.financeIncome,
          amount: income,
          color: AppColors.success,
        ),
        _Divider(),
        _SummaryItem(
          label: context.l10n.financeExpenses,
          amount: expenses,
          color: AppColors.error,
        ),
        _Divider(),
        _SummaryItem(
          label: context.l10n.financeBalance,
          amount: profit,
          color: profit >= 0 ? AppColors.success : AppColors.error,
        ),
      ],
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
        width: 1,
        height: 36,
        color: context.colors.outlineVariant,
      );
}

class _SummaryItem extends StatelessWidget {
  final String label;
  final double amount;
  final Color color;

  const _SummaryItem({
    required this.label,
    required this.amount,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            label,
            style: AppTypography.labelSm
                .copyWith(color: context.colors.onSurfaceVariant),
          ),
          const SizedBox(height: AppSpacing.xs),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              formatMoney(amount),
              style: AppTypography.titleMd.copyWith(color: color),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActiveFilters extends ConsumerWidget {
  final TransactionsState state;

  const _ActiveFilters({required this.state});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(transactionsProvider.notifier);
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
        children: [
          if (state.category != null)
            InputChip(
              label: Text(transactionCategoryLabel(context, state.category!)),
              deleteIcon: const Icon(Icons.close, size: 16),
              onDeleted: () => notifier.setFilters(
                type: state.type,
                fromDate: state.fromDate,
                toDate: state.toDate,
              ),
            ),
          if (state.fromDate != null || state.toDate != null)
            InputChip(
              label: Text([
                if (state.fromDate != null) format.format(state.fromDate!),
                if (state.toDate != null) format.format(state.toDate!),
              ].join(' — ')),
              deleteIcon: const Icon(Icons.close, size: 16),
              onDeleted: () => notifier.setFilters(
                type: state.type,
                category: state.category,
              ),
            ),
        ],
      ),
    );
  }
}

class _TransactionCard extends StatelessWidget {
  final Transaction transaction;
  final VoidCallback onTap;

  const _TransactionCard({required this.transaction, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isIncome = transaction.type == TransactionType.income;
    final color = isIncome ? AppColors.success : AppColors.error;

    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isIncome ? Icons.arrow_upward : Icons.arrow_downward,
              color: color,
              size: 22,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transactionCategoryLabel(context, transaction.category),
                  style: AppTypography.titleMd
                      .copyWith(color: context.colors.onSurface),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  DateFormat('d MMMM y', 'ru')
                      .format(transaction.transactionDate),
                  style: AppTypography.labelSm
                      .copyWith(color: context.colors.onSurfaceVariant),
                ),
                if (transaction.description?.trim().isNotEmpty == true)
                  Text(
                    transaction.description!.trim(),
                    style: AppTypography.labelSm
                        .copyWith(color: context.colors.onSurfaceVariant),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Text(
            '${isIncome ? '+' : '−'}${formatMoney(transaction.amount)}',
            style: AppTypography.titleMd.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}

class _DetailsSheet extends ConsumerWidget {
  final Transaction transaction;

  const _DetailsSheet({required this.transaction});

  Future<void> _delete(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l10n.financeDeleteTitle),
        content: Text(context.l10n.financeDeleteBody),
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
    final done = context.l10n.financeDeleted;
    final failed = context.l10n.financeDeleteFailed;
    final l10n = context.l10n;

    try {
      await ref.read(deleteTransactionProvider(transaction.id).future);
      ref
          .read(transactionsProvider.notifier)
          .removeTransaction(transaction.id);
      navigator.pop();
      messenger.showSnackBar(SnackBar(content: Text(done)));
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(
          content: Text('$failed: ${errorText(l10n, e)}'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isIncome = transaction.type == TransactionType.income;
    final color = isIncome ? AppColors.success : AppColors.error;
    final canManage = ref.watch(canProvider(FarmCapability.manageFinance));
    final canDelete = ref.watch(canProvider(FarmCapability.deleteRecords));

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
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isIncome ? Icons.arrow_upward : Icons.arrow_downward,
                    color: color,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Text(
                    '${isIncome ? '+' : '−'}${formatMoney(transaction.amount)}',
                    style: AppTypography.displayMd.copyWith(color: color),
                  ),
                ),
                if (canManage)
                  IconButton(
                    icon: const Icon(Icons.edit_outlined),
                    onPressed: () {
                      Navigator.pop(context);
                      context.push('/transactions/form', extra: transaction);
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
            const SizedBox(height: AppSpacing.lg),
            _Row(
              icon: Icons.category_outlined,
              label: context.l10n.financeCategory,
              value: transactionCategoryLabel(context, transaction.category),
            ),
            _Row(
              icon: Icons.swap_horiz,
              label: context.l10n.financeType,
              value: isIncome
                  ? context.l10n.financeTypeIncome
                  : context.l10n.financeTypeExpense,
            ),
            _Row(
              icon: Icons.event_outlined,
              label: context.l10n.financeDate,
              value: DateFormat('d MMMM y', 'ru')
                  .format(transaction.transactionDate),
            ),
            if (transaction.description?.trim().isNotEmpty == true)
              _Row(
                icon: Icons.notes,
                label: context.l10n.financeDescription,
                value: transaction.description!.trim(),
              ),
          ],
        ),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _Row({
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

class _FiltersSheet extends ConsumerStatefulWidget {
  const _FiltersSheet();

  @override
  ConsumerState<_FiltersSheet> createState() => _FiltersSheetState();
}

class _FiltersSheetState extends ConsumerState<_FiltersSheet> {
  TransactionCategory? _category;
  DateTime? _from;
  DateTime? _to;

  @override
  void initState() {
    super.initState();
    final state = ref.read(transactionsProvider);
    _category = state.category;
    _from = state.fromDate;
    _to = state.toDate;
  }

  Future<void> _pickRange() async {
    final range = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: _from != null && _to != null
          ? DateTimeRange(start: _from!, end: _to!)
          : null,
      helpText: context.l10n.commonPeriod,
    );
    if (range == null) return;
    setState(() {
      _from = range.start;
      _to = range.end;
    });
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
              context.l10n.commonFilters,
              style: AppTypography.titleLg
                  .copyWith(color: context.colors.onSurface),
            ),
            const SizedBox(height: AppSpacing.lg),
            DropdownButtonFormField<TransactionCategory>(
              initialValue: _category,
              isExpanded: true,
              decoration: InputDecoration(
                labelText: context.l10n.financeCategory,
                prefixIcon: const Icon(Icons.category_outlined),
              ),
              items: [
                for (final category in TransactionCategory.values)
                  DropdownMenuItem(
                    value: category,
                    child: Text(transactionCategoryLabel(context, category)),
                  ),
              ],
              onChanged: (v) => setState(() => _category = v),
            ),
            const SizedBox(height: AppSpacing.md),
            OutlinedButton.icon(
              onPressed: _pickRange,
              icon: const Icon(Icons.date_range, size: 18),
              label: Text(_from == null || _to == null
                  ? context.l10n.commonPeriod
                  : '${format.format(_from!)} — ${format.format(_to!)}'),
            ),
            const SizedBox(height: AppSpacing.xl),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      ref.read(transactionsProvider.notifier).clearFilters();
                      Navigator.pop(context);
                    },
                    child: Text(context.l10n.commonReset),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: FilledButton(
                    onPressed: () {
                      ref.read(transactionsProvider.notifier).setFilters(
                            type: ref.read(transactionsProvider).type,
                            category: _category,
                            fromDate: _from,
                            toDate: _to,
                          );
                      Navigator.pop(context);
                    },
                    child: Text(context.l10n.commonApply),
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
