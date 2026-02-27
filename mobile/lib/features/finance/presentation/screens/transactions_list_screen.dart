import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../data/models/transaction_model.dart';
import '../providers/transactions_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_card.dart';

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
    final primary = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Финансы'),
        centerTitle: true,
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
          _buildQuickFilters(primary),

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
            Container(width: 1, height: 40, color: AppColors.darkBorder),
            _buildSummaryItem(
              context,
              label: 'Расходы',
              amount: expense,
              color: AppColors.error,
              icon: Icons.arrow_downward,
            ),
            Container(width: 1, height: 40, color: AppColors.darkBorder),
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
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.darkTextSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickFilters(Color primary) {
    return SizedBox(
      height: 50,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        children: [
          _buildFilterChip(
            'Все',
            _selectedType == null,
            primary: primary,
            onTap: () {
              setState(() => _selectedType = null);
              _applyFilters();
            },
          ),
          const SizedBox(width: 8),
          _buildFilterChip(
            'Доходы',
            _selectedType == TransactionType.income,
            primary: AppColors.success,
            onTap: () {
              setState(() {
                _selectedType = _selectedType == TransactionType.income
                    ? null
                    : TransactionType.income;
              });
              _applyFilters();
            },
          ),
          const SizedBox(width: 8),
          _buildFilterChip(
            'Расходы',
            _selectedType == TransactionType.expense,
            primary: AppColors.error,
            onTap: () {
              setState(() {
                _selectedType = _selectedType == TransactionType.expense
                    ? null
                    : TransactionType.expense;
              });
              _applyFilters();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(
    String label,
    bool isSelected, {
    required Color primary,
    required VoidCallback onTap,
  }) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => onTap(),
      backgroundColor: Theme.of(context).colorScheme.surface,
      selectedColor: primary.withValues(alpha: 0.2),
      checkmarkColor: primary,
      labelStyle: TextStyle(
        color: isSelected ? primary : AppColors.darkTextSecondary,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: isSelected ? primary : AppColors.darkBorder),
      ),
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
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: AppColors.error),
            const SizedBox(height: 16),
            Text(
              'Ошибка: ${transactionsState.error}',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () =>
                  ref.read(transactionsProvider.notifier).refresh(),
              child: const Text('Повторить'),
            ),
          ],
        ),
      );
    }

    if (transactionsState.transactions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.account_balance_wallet_outlined,
                size: 64, color: AppColors.darkTextHint),
            const SizedBox(height: 16),
            const Text(
              'Транзакций не найдено',
              style: TextStyle(fontSize: 18, color: AppColors.darkTextSecondary),
            ),
            const SizedBox(height: 8),
            const Text(
              'Добавьте первую транзакцию',
              style: TextStyle(color: AppColors.darkTextSecondary),
            ),
          ],
        ),
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
        onTap: () => _showTransactionForm(context, transaction),
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
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: AppColors.darkTextPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    DateFormat('dd MMM yyyy', 'ru_RU')
                        .format(transaction.transactionDate),
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.darkTextSecondary,
                    ),
                  ),
                  if (transaction.description != null &&
                      transaction.description!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(
                        transaction.description!,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.darkTextHint,
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
                  border: OutlineInputBorder(),
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
