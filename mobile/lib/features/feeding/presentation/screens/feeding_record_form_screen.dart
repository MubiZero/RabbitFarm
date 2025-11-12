import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../data/models/feed_model.dart';
import '../../data/models/feeding_record_model.dart';
import '../../../rabbits/data/models/rabbit_model.dart';
import '../../../cages/data/models/cage_model.dart';
import '../providers/feeds_provider.dart';
import '../providers/feeding_records_provider.dart';
import '../../../rabbits/presentation/providers/rabbits_provider.dart';
import '../../../cages/presentation/providers/cages_provider.dart';

/// Экран создания/редактирования записи о кормлении
class FeedingRecordFormScreen extends ConsumerStatefulWidget {
  final FeedingRecord? record;

  const FeedingRecordFormScreen({super.key, this.record});

  @override
  ConsumerState<FeedingRecordFormScreen> createState() =>
      _FeedingRecordFormScreenState();
}

class _FeedingRecordFormScreenState
    extends ConsumerState<FeedingRecordFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _quantityController;
  late TextEditingController _notesController;

  int? _selectedFeedId;
  int? _selectedRabbitId;
  int? _selectedCageId;
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  bool _isLoading = false;

  // Режим выбора: 'rabbit' или 'cage'
  String _feedingMode = 'rabbit';

  @override
  void initState() {
    super.initState();
    _quantityController = TextEditingController(
      text: widget.record?.quantity.toString() ?? '',
    );
    _notesController = TextEditingController(text: widget.record?.notes ?? '');

    if (widget.record != null) {
      _selectedFeedId = widget.record!.feedId;
      _selectedRabbitId = widget.record!.rabbitId;
      _selectedCageId = widget.record!.cageId;
      _selectedDate = widget.record!.fedAt;
      _selectedTime = TimeOfDay.fromDateTime(widget.record!.fedAt);

      if (_selectedRabbitId != null) {
        _feedingMode = 'rabbit';
      } else if (_selectedCageId != null) {
        _feedingMode = 'cage';
      }
    }

    // Загружаем списки
    Future.microtask(() {
      ref.read(feedsProvider.notifier).loadFeeds(refresh: true);
      ref.read(rabbitsListProvider.notifier).loadRabbits();
      ref.read(cagesProvider.notifier).loadCages();
    });
  }

  @override
  void dispose() {
    _quantityController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final feedsState = ref.watch(feedsProvider);
    final rabbitsState = ref.watch(rabbitsListProvider);
    final cagesState = ref.watch(cagesProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.record == null
            ? 'Новая запись о кормлении'
            : 'Редактировать запись'),
        centerTitle: true,
        backgroundColor: Colors.orange[700],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Режим кормления: индивидуальное или групповое
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Режим кормления',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: RadioListTile<String>(
                            title: const Text('Индивидуально'),
                            subtitle: const Text('Конкретный кролик'),
                            value: 'rabbit',
                            groupValue: _feedingMode,
                            onChanged: (value) {
                              setState(() {
                                _feedingMode = value!;
                                _selectedCageId = null;
                              });
                            },
                          ),
                        ),
                        Expanded(
                          child: RadioListTile<String>(
                            title: const Text('Групповое'),
                            subtitle: const Text('Вся клетка'),
                            value: 'cage',
                            groupValue: _feedingMode,
                            onChanged: (value) {
                              setState(() {
                                _feedingMode = value!;
                                _selectedRabbitId = null;
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

            // Выбор кролика или клетки
            if (_feedingMode == 'rabbit')
              _buildRabbitSelector(rabbitsState)
            else
              _buildCageSelector(cagesState),
            const SizedBox(height: 16),

            // Выбор корма
            _buildFeedSelector(feedsState),
            const SizedBox(height: 16),

            // Количество
            TextFormField(
              controller: _quantityController,
              decoration: const InputDecoration(
                labelText: 'Количество *',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.scale),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Введите количество';
                }
                final number = double.tryParse(value);
                if (number == null || number <= 0) {
                  return 'Введите корректное число';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Дата и время
            Row(
              children: [
                Expanded(
                  child: ListTile(
                    title: const Text('Дата'),
                    subtitle: Text(DateFormat('dd.MM.yyyy').format(_selectedDate)),
                    leading: const Icon(Icons.calendar_today),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(color: Colors.grey[300]!),
                    ),
                    onTap: () => _selectDate(context),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ListTile(
                    title: const Text('Время'),
                    subtitle: Text(_selectedTime.format(context)),
                    leading: const Icon(Icons.access_time),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(color: Colors.grey[300]!),
                    ),
                    onTap: () => _selectTime(context),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Примечания
            TextFormField(
              controller: _notesController,
              decoration: const InputDecoration(
                labelText: 'Примечания',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.note),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 24),

            // Кнопка сохранения
            ElevatedButton(
              onPressed: _isLoading ? null : _saveRecord,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange[700],
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : Text(
                      widget.record == null ? 'Создать' : 'Сохранить',
                      style: const TextStyle(fontSize: 16),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRabbitSelector(RabbitsListState rabbitsState) {
    if (rabbitsState.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return DropdownButtonFormField<int>(
      value: _selectedRabbitId,
      decoration: const InputDecoration(
        labelText: 'Кролик *',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.pets),
      ),
      items: rabbitsState.rabbits.map((rabbit) {
        return DropdownMenuItem(
          value: rabbit.id,
          child: Text('${rabbit.name} (${rabbit.tagId ?? "без бирки"})'),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _selectedRabbitId = value;
        });
      },
      validator: (value) {
        if (_feedingMode == 'rabbit' && value == null) {
          return 'Выберите кролика';
        }
        return null;
      },
    );
  }

  Widget _buildCageSelector(CagesState cagesState) {
    if (cagesState.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return DropdownButtonFormField<int>(
      value: _selectedCageId,
      decoration: const InputDecoration(
        labelText: 'Клетка *',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.home),
      ),
      items: cagesState.cages.map((cage) {
        return DropdownMenuItem(
          value: cage.id,
          child: Text('Клетка ${cage.number}'),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _selectedCageId = value;
        });
      },
      validator: (value) {
        if (_feedingMode == 'cage' && value == null) {
          return 'Выберите клетку';
        }
        return null;
      },
    );
  }

  Widget _buildFeedSelector(FeedsState feedsState) {
    if (feedsState.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return DropdownButtonFormField<int>(
      value: _selectedFeedId,
      decoration: const InputDecoration(
        labelText: 'Корм *',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.inventory),
      ),
      items: feedsState.feeds.map((feed) {
        final hasLowStock = ref.watch(feedHasLowStockProvider(feed));
        return DropdownMenuItem(
          value: feed.id,
          child: Row(
            children: [
              Text(feed.name),
              const SizedBox(width: 8),
              Text(
                '(${feed.currentStock.toStringAsFixed(1)} ${_getFeedUnitName(feed.unit)})',
                style: TextStyle(
                  fontSize: 12,
                  color: hasLowStock ? Colors.red : Colors.grey,
                ),
              ),
            ],
          ),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _selectedFeedId = value;
        });
      },
      validator: (value) {
        if (value == null) {
          return 'Выберите корм';
        }
        return null;
      },
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

  Future<void> _selectTime(BuildContext context) async {
    final time = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );

    if (time != null) {
      setState(() {
        _selectedTime = time;
      });
    }
  }

  Future<void> _saveRecord() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final quantity = double.parse(_quantityController.text);

      // Комбинируем дату и время
      final fedAt = DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
        _selectedTime.hour,
        _selectedTime.minute,
      );

      if (widget.record == null) {
        // Создание новой записи
        final recordCreate = FeedingRecordCreate(
          rabbitId: _feedingMode == 'rabbit' ? _selectedRabbitId : null,
          cageId: _feedingMode == 'cage' ? _selectedCageId : null,
          feedId: _selectedFeedId!,
          quantity: quantity,
          fedAt: fedAt,
          notes: _notesController.text.isNotEmpty ? _notesController.text : null,
        );

        await ref.read(createFeedingRecordProvider(recordCreate).future);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Запись успешно создана')),
          );
          context.pop();
        }
      } else {
        // Обновление существующей записи
        final recordUpdate = FeedingRecordUpdate(
          rabbitId: _feedingMode == 'rabbit' ? _selectedRabbitId : null,
          cageId: _feedingMode == 'cage' ? _selectedCageId : null,
          feedId: _selectedFeedId!,
          quantity: quantity,
          fedAt: fedAt,
          notes: _notesController.text.isNotEmpty ? _notesController.text : null,
        );

        await ref.read(
          updateFeedingRecordProvider(
            (id: widget.record!.id, update: recordUpdate),
          ).future,
        );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Запись успешно обновлена')),
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
