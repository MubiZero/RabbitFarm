import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../data/models/feed_model.dart';
import '../providers/feeds_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_form_section.dart';

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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.feed == null ? 'Новый корм' : 'Редактировать корм'),
        actions: [
          if (widget.feed != null)
            IconButton(
              icon: const Icon(Icons.delete),
              color: AppColors.error,
              onPressed: _confirmDelete,
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
          children: [
            AppFormSection(
              title: 'Основное',
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Название *',
                    prefixIcon: Icon(Icons.label),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Введите название корма';
                    }
                    return null;
                  },
                ),
                DropdownButtonFormField<FeedType>(
                  value: _selectedType,
                  decoration: const InputDecoration(
                    labelText: 'Тип корма *',
                    prefixIcon: Icon(Icons.category),
                  ),
                  items: FeedType.values.map((type) {
                    return DropdownMenuItem(
                      value: type,
                      child: Text(_getFeedTypeName(type)),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) setState(() => _selectedType = value);
                  },
                ),
                DropdownButtonFormField<FeedUnit>(
                  value: _selectedUnit,
                  decoration: const InputDecoration(
                    labelText: 'Единица измерения *',
                    prefixIcon: Icon(Icons.straighten),
                  ),
                  items: FeedUnit.values.map((unit) {
                    return DropdownMenuItem(
                      value: unit,
                      child: Text(_getFeedUnitName(unit)),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) setState(() => _selectedUnit = value);
                  },
                ),
              ],
            ),
            AppFormSection(
              title: 'Склад',
              children: [
                TextFormField(
                  controller: _currentStockController,
                  decoration: InputDecoration(
                    labelText: 'Текущий остаток *',
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
                TextFormField(
                  controller: _minStockController,
                  decoration: InputDecoration(
                    labelText: 'Минимальный остаток *',
                    prefixIcon: const Icon(Icons.warning_amber_outlined),
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
                TextFormField(
                  controller: _costPerUnitController,
                  decoration: InputDecoration(
                    labelText: 'Стоимость за единицу',
                    prefixIcon: const Icon(Icons.payments_outlined),
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
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: SizedBox(
            height: 52,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _saveFeed,
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(widget.feed == null ? 'Создать' : 'Сохранить'),
            ),
          ),
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
          type: _selectedType.name,
          unit: _selectedUnit.name,
          currentStock: currentStock,
          minStock: minStock,
          costPerUnit: costPerUnit,
        );

        await ref.read(createFeedProvider(feedCreate).future);

        if (mounted) {
          ref.read(feedsProvider.notifier).refresh();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Корм успешно создан')),
          );
          context.pop();
        }
      } else {
        // Обновление существующего корма
        final feedUpdate = FeedUpdate(
          name: _nameController.text,
          type: _selectedType.name,
          unit: _selectedUnit.name,
          currentStock: currentStock,
          minStock: minStock,
          costPerUnit: costPerUnit,
        );

        await ref.read(
          updateFeedProvider((id: widget.feed!.id, update: feedUpdate)).future,
        );

        if (mounted) {
          ref.read(feedsProvider.notifier).refresh();
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
            backgroundColor: AppColors.error,
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
        await ref.read(deleteFeedProvider(widget.feed!.id).future);

        if (mounted) {
          ref.read(feedsProvider.notifier).refresh();
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
              backgroundColor: AppColors.error,
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
