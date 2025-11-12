import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../data/models/transaction_model.dart';
import '../../../rabbits/data/models/rabbit_model.dart';
import '../providers/transactions_provider.dart';
import '../../../rabbits/presentation/providers/rabbits_provider.dart';

/// Экран создания/редактирования транзакции
class TransactionFormScreen extends ConsumerStatefulWidget {
  final Transaction? transaction;

  const TransactionFormScreen({super.key, this.transaction});

  @override
  ConsumerState<TransactionFormScreen> createState() =>
      _TransactionFormScreenState();
}

class _TransactionFormScreenState extends ConsumerState<TransactionFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _amountController;
  late TextEditingController _descriptionController;

  TransactionType _selectedType = TransactionType.expense;
  TransactionCategory _selectedCategory = TransactionCategory.feed;
  DateTime _selectedDate = DateTime.now();
  int? _selectedRabbitId;
  bool _isLoading = false;

  // Категории доходов
  final List<TransactionCategory> _incomeCategories = [
    TransactionCategory.saleRabbit,
    TransactionCategory.saleMeat,
    TransactionCategory.saleFur,
    TransactionCategory.breedingFee,
  ];

  // Категории расходов
  final List<TransactionCategory> _expenseCategories = [
    TransactionCategory.feed,
    TransactionCategory.veterinary,
    TransactionCategory.equipment,
    TransactionCategory.utilities,
    TransactionCategory.other,
  ];

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController(
      text: widget.transaction?.amount.toString() ?? '',
    );
    _descriptionController = TextEditingController(
      text: widget.transaction?.description ?? '',
    );

    if (widget.transaction != null) {
      _selectedType = widget.transaction!.type;
      _selectedCategory = widget.transaction!.category;
      _selectedDate = widget.transaction!.transactionDate;
      _selectedRabbitId = widget.transaction!.rabbitId;
    }

    // Загружаем список кроликов
    Future.microtask(() {
      ref.read(rabbitsListProvider.notifier).loadRabbits();
    });
  }

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final rabbitsState = ref.watch(rabbitsListProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.transaction == null
            ? 'Новая транзакция'
            : 'Редактировать транзакцию'),
        centerTitle: true,
        backgroundColor: Colors.blue[700],
        actions: [
          if (widget.transaction != null)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: _confirmDelete,
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Тип транзакции
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Тип транзакции',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: RadioListTile<TransactionType>(
                            title: const Text('Доход'),
                            subtitle: const Text('Продажа, услуги'),
                            value: TransactionType.income,
                            groupValue: _selectedType,
                            onChanged: (value) {
                              setState(() {
                                _selectedType = value!;
                                // Сбросить категорию при смене типа
                                _selectedCategory = value == TransactionType.income
                                    ? _incomeCategories.first
                                    : _expenseCategories.first;
                              });
                            },
                          ),
                        ),
                        Expanded(
                          child: RadioListTile<TransactionType>(
                            title: const Text('Расход'),
                            subtitle: const Text('Покупки, услуги'),
                            value: TransactionType.expense,
                            groupValue: _selectedType,
                            onChanged: (value) {
                              setState(() {
                                _selectedType = value!;
                                _selectedCategory = value == TransactionType.income
                                    ? _incomeCategories.first
                                    : _expenseCategories.first;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Категория
            DropdownButtonFormField<TransactionCategory>(
              value: _selectedCategory,
              decoration: const InputDecoration(
                labelText: 'Категория *',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.category),
              ),
              items: (_selectedType == TransactionType.income
                      ? _incomeCategories
                      : _expenseCategories)
                  .map((category) {
                return DropdownMenuItem(
                  value: category,
                  child: Text(_getCategoryName(category)),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedCategory = value;
                  });
                }
              },
            ),
            const SizedBox(height: 16),

            // Сумма
            TextFormField(
              controller: _amountController,
              decoration: const InputDecoration(
                labelText: 'Сумма *',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.attach_money),
                suffixText: '₽',
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Введите сумму';
                }
                final number = double.tryParse(value);
                if (number == null || number <= 0) {
                  return 'Введите корректную сумму';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Дата
            ListTile(
              title: const Text('Дата транзакции'),
              subtitle: Text(DateFormat('dd.MM.yyyy').format(_selectedDate)),
              leading: const Icon(Icons.calendar_today),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(color: Colors.grey[300]!),
              ),
              onTap: () => _selectDate(context),
            ),
            const SizedBox(height: 16),

            // Кролик (опционально)
            if (rabbitsState.rabbits.isNotEmpty)
              DropdownButtonFormField<int>(
                value: _selectedRabbitId,
                decoration: const InputDecoration(
                  labelText: 'Кролик (опционально)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.pets),
                  helperText: 'Привязать транзакцию к кролику',
                ),
                items: [
                  const DropdownMenuItem<int>(
                    value: null,
                    child: Text('Не выбран'),
                  ),
                  ...rabbitsState.rabbits.map((rabbit) {
                    return DropdownMenuItem(
                      value: rabbit.id,
                      child: Text('${rabbit.name} (${rabbit.tagId ?? "без бирки"})'),
                    );
                  }).toList(),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedRabbitId = value;
                  });
                },
              ),
            const SizedBox(height: 16),

            // Описание
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Описание',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.description),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 24),

            // Кнопка сохранения
            ElevatedButton(
              onPressed: _isLoading ? null : _saveTransaction,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[700],
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : Text(
                      widget.transaction == null ? 'Создать' : 'Сохранить',
                      style: const TextStyle(fontSize: 16),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (date != null) {
      setState(() {
        _selectedDate = date;
      });
    }
  }

  Future<void> _saveTransaction() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final amount = double.parse(_amountController.text);

      if (widget.transaction == null) {
        // Создание новой транзакции
        final transactionCreate = TransactionCreate(
          type: _selectedType,
          category: _selectedCategory,
          amount: amount,
          transactionDate: _selectedDate,
          rabbitId: _selectedRabbitId,
          description: _descriptionController.text.isNotEmpty
              ? _descriptionController.text
              : null,
        );

        await ref.read(createTransactionProvider(transactionCreate).future);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Транзакция успешно создана')),
          );
          context.pop();
        }
      } else {
        // Обновление существующей транзакции
        final transactionUpdate = TransactionUpdate(
          type: _selectedType,
          category: _selectedCategory,
          amount: amount,
          transactionDate: _selectedDate,
          rabbitId: _selectedRabbitId,
          description: _descriptionController.text.isNotEmpty
              ? _descriptionController.text
              : null,
        );

        await ref.read(
          updateTransactionProvider(
            (id: widget.transaction!.id, update: transactionUpdate),
          ).future,
        );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Транзакция успешно обновлена')),
          );
          context.pop();
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ошибка: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _confirmDelete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Удалить транзакцию?'),
        content: const Text('Вы уверены, что хотите удалить эту транзакцию?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Удалить'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      try {
        await ref.read(deleteTransactionProvider(widget.transaction!.id).future);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Транзакция успешно удалена')),
          );
          context.pop();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Ошибка при удалении: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
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
