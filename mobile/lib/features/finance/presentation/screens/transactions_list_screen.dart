import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../data/models/transaction_model.dart';
import '../providers/transactions_provider.dart';

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
    // Загружаем список при открытии экрана
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
        centerTitle: true,
        backgroundColor: Colors.blue[700],
        actions: [
          // Фильтры
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilters(context),
          ),
          // Статистика
          IconButton(
            icon: const Icon(Icons.analytics_outlined),
            onPressed: () => context.push('/transactions/statistics'),
          ),
        ],
      ),
      body: Column(
        children: [
          // Быстрые фильтры
          _buildQuickFilters(),

          // Активные фильтры
          if (_selectedType != null ||
              _selectedCategory != null ||
              _fromDate != null ||
              _toDate != null)
            _buildActiveFilters(),

          // Список транзакций
          Expanded(
            child: _buildTransactionsList(context, transactionsState),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showTransactionForm(context, null),
        backgroundColor: Colors.blue[700],
        icon: const Icon(Icons.add),
        label: const Text('Добавить транзакцию'),
      ),
    );
  }

  Widget _buildQuickFilters() {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildFilterChip('Все', _selectedType == null, () {
            setState(() {
              _selectedType = null;
            });
            _applyFilters();
          }),
          const SizedBox(width: 8),
          _buildFilterChip(
            'Доходы',
            _selectedType == TransactionType.income,
            () {
              setState(() {
                _selectedType = _selectedType == TransactionType.income
                    ? null
                    : TransactionType.income;
              });
              _applyFilters();
            },
            color: Colors.green,
          ),
          const SizedBox(width: 8),
          _buildFilterChip(
            'Расходы',
            _selectedType == TransactionType.expense,
            () {
              setState(() {
                _selectedType = _selectedType == TransactionType.expense
                    ? null
                    : TransactionType.expense;
              });
              _applyFilters();
            },
            color: Colors.red,
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected, VoidCallback onTap,
      {Color? color}) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => onTap(),
      backgroundColor: Colors.grey[200],
      selectedColor: color?.withOpacity(0.3) ?? Colors.blue[200],
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Wrap(
        spacing: 8,
        children: [
          if (_selectedType != null)
            Chip(
              label: Text(_getTypeName(_selectedType!)),
              onDeleted: () {
                setState(() {
                  _selectedType = null;
                });
                _applyFilters();
              },
            ),
          if (_selectedCategory != null)
            Chip(
              label: Text(_getCategoryName(_selectedCategory!)),
              onDeleted: () {
                setState(() {
                  _selectedCategory = null;
                });
                _applyFilters();
              },
            ),
          if (_fromDate != null)
            Chip(
              label: Text('С ${DateFormat('dd.MM.yyyy').format(_fromDate!)}'),
              onDeleted: () {
                setState(() {
                  _fromDate = null;
                });
                _applyFilters();
              },
            ),
          if (_toDate != null)
            Chip(
              label: Text('До ${DateFormat('dd.MM.yyyy').format(_toDate!)}'),
              onDeleted: () {
                setState(() {
                  _toDate = null;
                });
                _applyFilters();
              },
            ),
        ],
      ),
    );
  }

  Widget _buildTransactionsList(
      BuildContext context, TransactionsState transactionsState) {
    if (transactionsState.isLoading &&
        transactionsState.transactions.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (transactionsState.error != null &&
        transactionsState.transactions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
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
            Icon(Icons.account_balance_wallet_outlined,
                size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'Транзакций не найдено',
              style: TextStyle(fontSize: 18, color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            Text(
              'Добавьте первую транзакцию',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => ref.read(transactionsProvider.notifier).refresh(),
      child: ListView.builder(
        itemCount: transactionsState.transactions.length +
            (transactionsState.hasMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == transactionsState.transactions.length) {
            // Загрузка следующей страницы
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

          final transaction = transactionsState.transactions[index];
          return _buildTransactionCard(context, transaction);
        },
      ),
    );
  }

  Widget _buildTransactionCard(BuildContext context, Transaction transaction) {
    final isIncome = transaction.type == TransactionType.income;
    final color = isIncome ? Colors.green : Colors.red;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color,
          child: Icon(
            isIncome ? Icons.arrow_upward : Icons.arrow_downward,
            color: Colors.white,
          ),
        ),
        title: Text(
          _getCategoryName(transaction.category),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              DateFormat('dd.MM.yyyy').format(transaction.transactionDate),
            ),
            if (transaction.description != null &&
                transaction.description!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  transaction.description!,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontStyle: FontStyle.italic,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${isIncome ? '+' : '-'}${transaction.amount.toStringAsFixed(2)} ₽',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
        onTap: () => _showTransactionForm(context, transaction),
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
              // Категория
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
                  setState(() {
                    _selectedCategory = value;
                  });
                },
              ),
              const SizedBox(height: 16),

              // Дата начала
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
                  if (date != null) {
                    setState(() {
                      _fromDate = date;
                    });
                  }
                },
              ),

              // Дата окончания
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
                  if (date != null) {
                    setState(() {
                      _toDate = date;
                    });
                  }
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

  String _getTypeName(TransactionType type) {
    switch (type) {
      case TransactionType.income:
        return 'Доход';
      case TransactionType.expense:
        return 'Расход';
    }
  }

  String _getCategoryName(TransactionCategory category) {
    switch (category) {
      case TransactionCategory.saleRabbit:
        return 'Продажа кролика';
      case TransactionCategory.saleMeat:
        return 'Продажа мяса';
      case TransactionCategory.saleFur:
        return 'Продажа меха';
      case TransactionCategory.breedingFee:
        return 'Плата за случку';
      case TransactionCategory.feed:
        return 'Корм';
      case TransactionCategory.veterinary:
        return 'Ветеринария';
      case TransactionCategory.equipment:
        return 'Оборудование';
      case TransactionCategory.utilities:
        return 'Коммунальные услуги';
      case TransactionCategory.other:
        return 'Другое';
    }
  }
}
