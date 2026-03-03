import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../data/models/feed_model.dart';
import '../../data/models/feeding_record_model.dart';
import '../providers/feeds_provider.dart';
import '../providers/feeding_records_provider.dart';
import '../../../rabbits/presentation/providers/rabbits_provider.dart';
import '../../../cages/presentation/providers/cages_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_date_field.dart';
import '../../../../core/widgets/app_form_section.dart';

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
  DateTime _fedAt = DateTime.now();
  bool _isLoading = false;

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
      _fedAt = widget.record!.fedAt;

      if (_selectedRabbitId != null) {
        _feedingMode = 'rabbit';
      } else if (_selectedCageId != null) {
        _feedingMode = 'cage';
      }
    }

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
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
          children: [
            AppFormSection(
              title: 'Кормление',
              children: [
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
                if (_feedingMode == 'rabbit')
                  _buildRabbitSelector(rabbitsState)
                else
                  _buildCageSelector(cagesState),
                _buildFeedSelector(context, feedsState),
              ],
            ),
            AppFormSection(
              title: 'Детали',
              children: [
                TextFormField(
                  controller: _quantityController,
                  decoration: const InputDecoration(
                    labelText: 'Количество *',
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
                AppDateField(
                  label: 'Дата и время *',
                  value: _fedAt,
                  onChanged: (date) => setState(() => _fedAt = date),
                  prefixIcon: Icons.calendar_today,
                  lastDate: DateTime.now(),
                  showTime: true,
                ),
              ],
            ),
            AppFormSection(
              title: 'Заметки',
              children: [
                TextFormField(
                  controller: _notesController,
                  decoration: const InputDecoration(
                    labelText: 'Примечания',
                    prefixIcon: Icon(Icons.note_outlined),
                  ),
                  maxLines: 3,
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
              onPressed: _isLoading ? null : _saveRecord,
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(widget.record == null ? 'Создать' : 'Сохранить'),
            ),
          ),
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
        prefixIcon: Icon(Icons.pets),
      ),
      items: rabbitsState.rabbits.map((rabbit) {
        return DropdownMenuItem(
          value: rabbit.id,
          child: Text(
              '${rabbit.name} (${rabbit.tagId.isEmpty ? "без бирки" : rabbit.tagId})'),
        );
      }).toList(),
      onChanged: (value) => setState(() => _selectedRabbitId = value),
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
        prefixIcon: Icon(Icons.home),
      ),
      items: cagesState.cages.map((cage) {
        return DropdownMenuItem(
          value: cage.id,
          child: Text('Клетка ${cage.number}'),
        );
      }).toList(),
      onChanged: (value) => setState(() => _selectedCageId = value),
      validator: (value) {
        if (_feedingMode == 'cage' && value == null) {
          return 'Выберите клетку';
        }
        return null;
      },
    );
  }

  Widget _buildFeedSelector(BuildContext context, FeedsState feedsState) {
    if (feedsState.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final cs = Theme.of(context).colorScheme;
    return DropdownButtonFormField<int>(
      value: _selectedFeedId,
      decoration: const InputDecoration(
        labelText: 'Корм *',
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
                  color: hasLowStock ? AppColors.error : cs.onSurfaceVariant,
                ),
              ),
            ],
          ),
        );
      }).toList(),
      onChanged: (value) => setState(() => _selectedFeedId = value),
      validator: (value) {
        if (value == null) {
          return 'Выберите корм';
        }
        return null;
      },
    );
  }

  Future<void> _saveRecord() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      final quantity = double.parse(_quantityController.text);

      if (widget.record == null) {
        final recordCreate = FeedingRecordCreate(
          rabbitId: _feedingMode == 'rabbit' ? _selectedRabbitId : null,
          cageId: _feedingMode == 'cage' ? _selectedCageId : null,
          feedId: _selectedFeedId!,
          quantity: quantity,
          fedAt: _fedAt,
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
        final recordUpdate = FeedingRecordUpdate(
          rabbitId: _feedingMode == 'rabbit' ? _selectedRabbitId : null,
          cageId: _feedingMode == 'cage' ? _selectedCageId : null,
          feedId: _selectedFeedId!,
          quantity: quantity,
          fedAt: _fedAt,
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
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
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
