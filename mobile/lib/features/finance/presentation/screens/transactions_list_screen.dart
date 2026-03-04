import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../data/models/transaction_model.dart';
import '../providers/transactions_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_error_state.dart';
import '../../../../core/widgets/app_filter_bar.dart';

/// Экран списка финансовых транзакций
class TransactionsListScreen extends ConsumerStatefulWidget {
  const TransactionsListScreen({super.key});

  @override
  ConsumerState<TransactionsListScreen> createState() =>
      _TransactionsListScreenState();
}

class _TransactionsListScreenState
    extends ConsumerState<TransactionsListScreen> {
  TransactionType? _selectedType;
  TransactionCategory? _selectedCategory;
  DateTime? _fromDate;
  DateTime? _toDate;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(transactionsProvider.notifier).loadTransactions(refresh: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final transactionsState = ref.watch(transactionsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Финансы'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilters(context),
          ),
          IconButton(
            icon: const Icon(Icons.analytics_outlined),
            onPressed: () => context.push('/transactions/statistics'),
          ),
        ],
      ),
      body: Column(
        children: [
          // Summary banner
          if (transactionsState.transactions.isNotEmpty)
            _buildSummaryBanner(context, transactionsState.transactions),

          // Quick filters
          _buildQuickFilters(),

          // Active filters
          if (_selectedType != null ||
              _selectedCategory != null ||
              _fromDate != null ||
              _toDate != null)
            _buildActiveFilters(),

          // List
          Expanded(
            child: _buildTransactionsList(context, transactionsState),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showTransactionForm(context, null),
        icon: const Icon(Icons.add),
        label: const Text('Добавить'),
      ),
    );
  }

  Widget _buildSummaryBanner(BuildContext context, List<Transaction> txs) {
    double income = 0;
    double expense = 0;
    for (final t in txs) {
      if (t.type == TransactionType.income) {
        income += t.amount;
      } else {
        expense += t.amount;
      }
    }
    final balance = income - expense;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: AppCard(
        child: Row(
          children: [
            _buildSummaryItem(
              context,
              label: 'Доходы',
              amount: income,
              color: AppColors.success,
              icon: Icons.arrow_upward,
            ),
            Container(width: 1, height: 40, color: Theme.of(context).colorScheme.outlineVariant),
            _buildSummaryItem(
              context,
              label: 'Расходы',
              amount: expense,
              color: AppColors.error,
              icon: Icons.arrow_downward,
            ),
            Container(width: 1, height: 40, color: Theme.of(context).colorScheme.outlineVariant),
            _buildSummaryItem(
              context,
              label: 'Баланс',
              amount: balance,
              color: balance >= 0 ? AppColors.success : AppColors.error,
              icon: Icons.account_balance_wallet_outlined,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(
    BuildContext context, {
    required String label,
    required double amount,
    required Color color,
    required IconData icon,
  }) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(height: 4),
          Text(
            '${amount.toStringAsFixed(0)} ₽',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickFilters() {
    return AppFilterBar(
      chips: [
        AppFilterChipData(
          label: 'Все',
          isSelected: _selectedType == null,
          onTap: () {
            setState(() => _selectedType = null);
            _applyFilters();
          },
        ),
        AppFilterChipData(
          label: 'Доходы',
          isSelected: _selectedType == TransactionType.income,
          onTap: () {
            setState(() {
              _selectedType = _selectedType == TransactionType.income
                  ? null
                  : TransactionType.income;
            });
            _applyFilters();
          },
          color: AppColors.success,
        ),
        AppFilterChipData(
          label: 'Расходы',
          isSelected: _selectedType == TransactionType.expense,
          onTap: () {
            setState(() {
              _selectedType = _selectedType == TransactionType.expense
                  ? null
                  : TransactionType.expense;
            });
            _applyFilters();
          },
          color: AppColors.error,
        ),
      ],
    );
  }

  void _applyFilters() {
    ref.read(transactionsProvider.notifier).loadTransactions(
          refresh: true,
          type: _selectedType,
          category: _selectedCategory,
          fromDate: _fromDate,
          toDate: _toDate,
        );
  }

  Widget _buildActiveFilters() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Wrap(
        spacing: 8,
        children: [
          if (_selectedType != null)
            Chip(
              label: Text(_getTypeName(_selectedType!)),
              onDeleted: () {
                setState(() => _selectedType = null);
                _applyFilters();
              },
            ),
          if (_selectedCategory != null)
            Chip(
              label: Text(_getCategoryName(_selectedCategory!)),
              onDeleted: () {
                setState(() => _selectedCategory = null);
                _applyFilters();
              },
            ),
          if (_fromDate != null)
            Chip(
              label: Text('С ${DateFormat('dd.MM.yyyy').format(_fromDate!)}'),
              onDeleted: () {
                setState(() => _fromDate = null);
                _applyFilters();
              },
            ),
          if (_toDate != null)
            Chip(
              label: Text('До ${DateFormat('dd.MM.yyyy').format(_toDate!)}'),
              onDeleted: () {
                setState(() => _toDate = null);
                _applyFilters();
              },
            ),
        ],
      ),
    );
  }

  Widget _buildTransactionsList(
      BuildContext context, TransactionsState transactionsState) {
    if (transactionsState.isLoading && transactionsState.transactions.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (transactionsState.error != null &&
        transactionsState.transactions.isEmpty) {
      return AppErrorState(
        message: transactionsState.error!,
        onRetry: () => ref.read(transactionsProvider.notifier).refresh(),
      );
    }

    if (transactionsState.transactions.isEmpty) {
      return const AppEmptyState(
        icon: Icons.account_balance_wallet_outlined,
        title: 'Транзакций не найдено',
        subtitle: 'Добавьте первую транзакцию',
      );
    }

    return RefreshIndicator(
      onRefresh: () => ref.read(transactionsProvider.notifier).refresh(),
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: transactionsState.transactions.length +
            (transactionsState.hasMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == transactionsState.transactions.length) {
            if (transactionsState.hasMore && !transactionsState.isLoading) {
              Future.microtask(
                  () => ref.read(transactionsProvider.notifier).loadMore());
            }
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: CircularProgressIndicator(),
              ),
            );
          }
          return _buildTransactionCard(
              context, transactionsState.transactions[index]);
        },
      ),
    );
  }

  Widget _buildTransactionCard(BuildContext context, Transaction transaction) {
    final isIncome = transaction.type == TransactionType.income;
    final color = isIncome ? AppColors.success : AppColors.error;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: AppCard(
        onTap: () => _showTransactionDetail(context, transaction),
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Type icon
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
            const SizedBox(width: 12),
            // Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _getCategoryName(transaction.category),
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    DateFormat('dd MMM yyyy', 'ru_RU')
                        .format(transaction.transactionDate),
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  if (transaction.description != null &&
                      transaction.description!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(
                        transaction.description!,
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          fontStyle: FontStyle.italic,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                ],
              ),
            ),
            // Amount
            Text(
              '${isIncome ? '+' : '−'}${transaction.amount.toStringAsFixed(2)} ₽',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showTransactionDetail(BuildContext context, Transaction transaction) {
    final isIncome = transaction.type == TransactionType.income;
    final color = isIncome ? AppColors.success : AppColors.error;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.fromLTRB(
            24, 24, 24, 24 + MediaQuery.of(ctx).viewInsets.bottom),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.outlineVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
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
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    '${isIncome ? '+' : '−'}${transaction.amount.toStringAsFixed(2)} ₽',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit_outlined),
                  onPressed: () {
                    Navigator.pop(ctx);
                    _showTransactionForm(context, transaction);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete_outline, color: AppColors.error),
                  onPressed: () {
                    Navigator.pop(ctx);
                    _deleteTransaction(context, transaction);
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            _txDetailRow(Icons.category_outlined, 'Категория', _getCategoryName(transaction.category)),
            _txDetailRow(Icons.swap_horiz, 'Тип', isIncome ? 'Доход' : 'Расход'),
            _txDetailRow(
              Icons.calendar_today,
              'Дата',
              DateFormat('dd MMM yyyy', 'ru_RU').format(transaction.transactionDate),
            ),
            if (transaction.description != null && transaction.description!.isNotEmpty)
              _txDetailRow(Icons.notes, 'Описание', transaction.description!),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _txDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Theme.of(context).colorScheme.onSurfaceVariant),
          const SizedBox(width: 12),
          Text(
            '$label: ',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontSize: 14,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteTransaction(
      BuildContext context, Transaction transaction) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Удалить транзакцию?'),
        content: const Text('Транзакция будет удалена безвозвратно.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Удалить'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      try {
        await ref.read(deleteTransactionProvider(transaction.id).future);
        if (mounted) {
          ref.read(transactionsProvider.notifier).removeTransaction(transaction.id);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Транзакция удалена')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Ошибка удаления: $e'),
              backgroundColor: AppColors.error,
            ),
          );
        }
      }
    }
  }

  void _showTransactionForm(BuildContext context, Transaction? transaction) {
    context.push('/transactions/form', extra: transaction);
  }

  void _showFilters(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Фильтры'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<TransactionCategory>(
                value: _selectedCategory,
                decoration: const InputDecoration(
                  labelText: 'Категория',
                ),
                items: TransactionCategory.values.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(_getCategoryName(category)),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() => _selectedCategory = value);
                },
              ),
              const SizedBox(height: 16),
              ListTile(
                title: const Text('Дата начала'),
                subtitle: Text(
                  _fromDate != null
                      ? DateFormat('dd.MM.yyyy').format(_fromDate!)
                      : 'Не выбрана',
                ),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: _fromDate ?? DateTime.now(),
                    firstDate: DateTime(2020),
                    lastDate: DateTime.now(),
                  );
                  if (date != null) setState(() => _fromDate = date);
                },
              ),
              ListTile(
                title: const Text('Дата окончания'),
                subtitle: Text(
                  _toDate != null
                      ? DateFormat('dd.MM.yyyy').format(_toDate!)
                      : 'Не выбрана',
                ),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: _toDate ?? DateTime.now(),
                    firstDate: DateTime(2020),
                    lastDate: DateTime.now(),
                  );
                  if (date != null) setState(() => _toDate = date);
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                _selectedCategory = null;
                _fromDate = null;
                _toDate = null;
              });
              Navigator.pop(context);
              _applyFilters();
            },
            child: const Text('Сбросить'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _applyFilters();
            },
            child: const Text('Применить'),
          ),
        ],
      ),
    );
  }

  String _getTypeName(TransactionType type) => switch (type) {
        TransactionType.income  => 'Доход',
        TransactionType.expense => 'Расход',
      };

  String _getCategoryName(TransactionCategory category) => switch (category) {
        TransactionCategory.saleRabbit   => 'Продажа кролика',
        TransactionCategory.saleMeat     => 'Продажа мяса',
        TransactionCategory.saleFur      => 'Продажа меха',
        TransactionCategory.breedingFee  => 'Плата за случку',
        TransactionCategory.feed         => 'Корм',
        TransactionCategory.veterinary   => 'Ветеринария',
        TransactionCategory.equipment    => 'Оборудование',
        TransactionCategory.utilities    => 'Коммунальные услуги',
        TransactionCategory.other        => 'Другое',
      };
}
