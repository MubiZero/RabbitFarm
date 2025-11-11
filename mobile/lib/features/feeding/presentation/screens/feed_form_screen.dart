import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../data/models/feed_model.dart';
import '../providers/feeds_provider.dart';

/// Экран создания/редактирования корма
class FeedFormScreen extends ConsumerStatefulWidget {
  final Feed? feed;

  const FeedFormScreen({super.key, this.feed});

  @override
  ConsumerState<FeedFormScreen> createState() => _FeedFormScreenState();
}

class _FeedFormScreenState extends ConsumerState<FeedFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _currentStockController;
  late TextEditingController _minStockController;
  late TextEditingController _costPerUnitController;
  late TextEditingController _supplierController;
  late TextEditingController _descriptionController;

  FeedType _selectedType = FeedType.pellets;
  FeedUnit _selectedUnit = FeedUnit.kg;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.feed?.name ?? '');
    _currentStockController = TextEditingController(
      text: widget.feed?.currentStock.toString() ?? '0',
    );
    _minStockController = TextEditingController(
      text: widget.feed?.minStock.toString() ?? '0',
    );
    _costPerUnitController = TextEditingController(
      text: widget.feed?.costPerUnit?.toString() ?? '',
    );
    _supplierController = TextEditingController(text: widget.feed?.supplier ?? '');
    _descriptionController =
        TextEditingController(text: widget.feed?.description ?? '');

    if (widget.feed != null) {
      _selectedType = widget.feed!.type;
      _selectedUnit = widget.feed!.unit;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _currentStockController.dispose();
    _minStockController.dispose();
    _costPerUnitController.dispose();
    _supplierController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.feed == null ? 'Новый корм' : 'Редактировать корм'),
        centerTitle: true,
        backgroundColor: Colors.orange[700],
        actions: [
          if (widget.feed != null)
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
            // Название
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Название *',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.label),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Введите название корма';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Тип корма
            DropdownButtonFormField<FeedType>(
              value: _selectedType,
              decoration: const InputDecoration(
                labelText: 'Тип корма *',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.category),
              ),
              items: FeedType.values.map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text(_getFeedTypeName(type)),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedType = value;
                  });
                }
              },
            ),
            const SizedBox(height: 16),

            // Единица измерения
            DropdownButtonFormField<FeedUnit>(
              value: _selectedUnit,
              decoration: const InputDecoration(
                labelText: 'Единица измерения *',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.straighten),
              ),
              items: FeedUnit.values.map((unit) {
                return DropdownMenuItem(
                  value: unit,
                  child: Text(_getFeedUnitName(unit)),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedUnit = value;
                  });
                }
              },
            ),
            const SizedBox(height: 16),

            // Текущий остаток
            TextFormField(
              controller: _currentStockController,
              decoration: InputDecoration(
                labelText: 'Текущий остаток *',
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.inventory),
                suffixText: _getFeedUnitName(_selectedUnit),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Введите текущий остаток';
                }
                final number = double.tryParse(value);
                if (number == null || number < 0) {
                  return 'Введите корректное число';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Минимальный остаток
            TextFormField(
              controller: _minStockController,
              decoration: InputDecoration(
                labelText: 'Минимальный остаток *',
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.warning),
                suffixText: _getFeedUnitName(_selectedUnit),
                helperText: 'Порог для предупреждения о низком запасе',
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Введите минимальный остаток';
                }
                final number = double.tryParse(value);
                if (number == null || number < 0) {
                  return 'Введите корректное число';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Стоимость за единицу
            TextFormField(
              controller: _costPerUnitController,
              decoration: InputDecoration(
                labelText: 'Стоимость за единицу',
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.attach_money),
                suffixText: 'руб/${_getFeedUnitName(_selectedUnit)}',
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value != null && value.isNotEmpty) {
                  final number = double.tryParse(value);
                  if (number == null || number < 0) {
                    return 'Введите корректное число';
                  }
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Поставщик
            TextFormField(
              controller: _supplierController,
              decoration: const InputDecoration(
                labelText: 'Поставщик',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.business),
              ),
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
              onPressed: _isLoading ? null : _saveFeed,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange[700],
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : Text(
                      widget.feed == null ? 'Создать' : 'Сохранить',
                      style: const TextStyle(fontSize: 16),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveFeed() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final currentStock = double.parse(_currentStockController.text);
      final minStock = double.parse(_minStockController.text);
      final costPerUnit = _costPerUnitController.text.isNotEmpty
          ? double.parse(_costPerUnitController.text)
          : null;

      if (widget.feed == null) {
        // Создание нового корма
        final feedCreate = FeedCreate(
          name: _nameController.text,
          type: _selectedType,
          unit: _selectedUnit,
          currentStock: currentStock,
          minStock: minStock,
          costPerUnit: costPerUnit,
          supplier: _supplierController.text.isNotEmpty
              ? _supplierController.text
              : null,
          description: _descriptionController.text.isNotEmpty
              ? _descriptionController.text
              : null,
        );

        await ref.read(createFeedProvider(feedCreate).future);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Корм успешно создан')),
          );
          context.pop();
        }
      } else {
        // Обновление существующего корма
        final feedUpdate = FeedUpdate(
          name: _nameController.text,
          type: _selectedType,
          unit: _selectedUnit,
          currentStock: currentStock,
          minStock: minStock,
          costPerUnit: costPerUnit,
          supplier: _supplierController.text.isNotEmpty
              ? _supplierController.text
              : null,
          description: _descriptionController.text.isNotEmpty
              ? _descriptionController.text
              : null,
        );

        await ref.read(
          updateFeedProvider((id: widget.feed!.id, update: feedUpdate)).future,
        );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Корм успешно обновлен')),
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
        title: const Text('Удалить корм?'),
        content: Text(
          'Вы уверены, что хотите удалить "${widget.feed!.name}"?',
        ),
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
        await ref.read(deleteFeedProvider(widget.feed!.id).future);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Корм успешно удален')),
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

  String _getFeedTypeName(FeedType type) {
    switch (type) {
      case FeedType.pellets:
        return 'Гранулы';
      case FeedType.hay:
        return 'Сено';
      case FeedType.vegetables:
        return 'Овощи';
      case FeedType.grain:
        return 'Зерно';
      case FeedType.supplements:
        return 'Добавки';
      case FeedType.other:
        return 'Другое';
    }
  }

  String _getFeedUnitName(FeedUnit unit) {
    switch (unit) {
      case FeedUnit.kg:
        return 'кг';
      case FeedUnit.liter:
        return 'л';
      case FeedUnit.piece:
        return 'шт';
    }
  }
}
