import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../data/models/cage_model.dart';
import '../providers/cages_provider.dart';

/// Экран формы добавления/редактирования клетки
class CageFormScreen extends ConsumerStatefulWidget {
  final CageModel? cage;

  const CageFormScreen({
    super.key,
    this.cage,
  });

  @override
  ConsumerState<CageFormScreen> createState() => _CageFormScreenState();
}

class _CageFormScreenState extends ConsumerState<CageFormScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _numberController;
  late TextEditingController _sizeController;
  late TextEditingController _capacityController;
  late TextEditingController _locationController;
  late TextEditingController _notesController;

  String _selectedType = 'single';
  String _selectedCondition = 'good';
  bool _isSubmitting = false;

  final List<Map<String, String>> _types = [
    {'value': 'single', 'label': 'Одиночная', 'icon': 'home'},
    {'value': 'group', 'label': 'Групповая', 'icon': 'home_work'},
    {'value': 'maternity', 'label': 'Для окрола', 'icon': 'child_care'},
  ];

  final List<Map<String, String>> _conditions = [
    {'value': 'good', 'label': 'Хорошее'},
    {'value': 'needs_repair', 'label': 'Нужен ремонт'},
    {'value': 'broken', 'label': 'Сломана'},
  ];

  @override
  void initState() {
    super.initState();
    _numberController = TextEditingController(text: widget.cage?.number ?? '');
    _sizeController = TextEditingController(text: widget.cage?.size ?? '');
    _capacityController = TextEditingController(
      text: widget.cage?.capacity.toString() ?? '1',
    );
    _locationController = TextEditingController(text: widget.cage?.location ?? '');
    _notesController = TextEditingController(text: widget.cage?.notes ?? '');

    if (widget.cage != null) {
      _selectedType = widget.cage!.type;
      _selectedCondition = widget.cage!.condition;
    }
  }

  @override
  void dispose() {
    _numberController.dispose();
    _sizeController.dispose();
    _capacityController.dispose();
    _locationController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.cage != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Редактировать клетку' : 'Добавить клетку'),
        centerTitle: true,
        backgroundColor: Colors.orange[700],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Номер клетки
              TextFormField(
                controller: _numberController,
                decoration: InputDecoration(
                  labelText: 'Номер клетки *',
                  hintText: 'Например: A-1',
                  prefixIcon: const Icon(Icons.tag),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Введите номер клетки';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Тип клетки
              DropdownButtonFormField<String>(
                value: _selectedType,
                decoration: InputDecoration(
                  labelText: 'Тип клетки *',
                  prefixIcon: const Icon(Icons.category),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                items: _types.map((type) {
                  return DropdownMenuItem(
                    value: type['value'],
                    child: Text(type['label']!),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedType = value!;
                  });
                },
              ),

              const SizedBox(height: 16),

              // Вместимость
              TextFormField(
                controller: _capacityController,
                decoration: InputDecoration(
                  labelText: 'Вместимость *',
                  hintText: 'Количество кроликов',
                  prefixIcon: const Icon(Icons.people),
                  suffixText: 'кроликов',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Введите вместимость';
                  }
                  final capacity = int.tryParse(value);
                  if (capacity == null || capacity < 1) {
                    return 'Вместимость должна быть минимум 1';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Размер
              TextFormField(
                controller: _sizeController,
                decoration: InputDecoration(
                  labelText: 'Размер',
                  hintText: 'Например: 60x80x45',
                  prefixIcon: const Icon(Icons.straighten),
                  suffixText: 'см',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Локация
              TextFormField(
                controller: _locationController,
                decoration: InputDecoration(
                  labelText: 'Расположение',
                  hintText: 'Например: Сарай 1, Ряд A',
                  prefixIcon: const Icon(Icons.location_on),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Состояние
              DropdownButtonFormField<String>(
                value: _selectedCondition,
                decoration: InputDecoration(
                  labelText: 'Состояние *',
                  prefixIcon: const Icon(Icons.build),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                items: _conditions.map((condition) {
                  return DropdownMenuItem(
                    value: condition['value'],
                    child: Text(condition['label']!),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCondition = value!;
                  });
                },
              ),

              const SizedBox(height: 16),

              // Заметки
              TextFormField(
                controller: _notesController,
                decoration: InputDecoration(
                  labelText: 'Заметки',
                  hintText: 'Дополнительная информация',
                  prefixIcon: const Icon(Icons.notes),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignLabelWithHint: true,
                ),
                maxLines: 4,
              ),

              const SizedBox(height: 24),

              // Информационная карточка
              _buildInfoCard(),

              const SizedBox(height: 32),

              // Кнопки действий
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _isSubmitting
                          ? null
                          : () => Navigator.of(context).pop(),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Отмена'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: _isSubmitting ? null : _submitForm,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Colors.orange[700],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: _isSubmitting
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Text(isEditing ? 'Сохранить' : 'Добавить'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    return Card(
      color: Colors.blue[50],
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.info_outline, color: Colors.blue[700]),
                const SizedBox(width: 8),
                Text(
                  'Подсказка',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[700],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '• Номер клетки должен быть уникальным\n'
              '• Одиночные клетки обычно имеют вместимость 1-2\n'
              '• Групповые клетки - для молодняка (3-10)\n'
              '• Клетки для окрола - для самок с крольчатами',
              style: TextStyle(
                fontSize: 13,
                color: Colors.blue[900],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    final cageData = {
      'number': _numberController.text.trim(),
      'type': _selectedType,
      'capacity': int.parse(_capacityController.text),
      'condition': _selectedCondition,
      if (_sizeController.text.trim().isNotEmpty)
        'size': _sizeController.text.trim(),
      if (_locationController.text.trim().isNotEmpty)
        'location': _locationController.text.trim(),
      if (_notesController.text.trim().isNotEmpty)
        'notes': _notesController.text.trim(),
    };

    bool success;
    final isEditing = widget.cage != null;

    if (isEditing) {
      success = await ref
          .read(cagesProvider.notifier)
          .updateCage(widget.cage!.id, cageData);
    } else {
      success = await ref.read(cagesProvider.notifier).createCage(cageData);
    }

    setState(() {
      _isSubmitting = false;
    });

    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isEditing
                  ? 'Клетка "${_numberController.text}" обновлена'
                  : 'Клетка "${_numberController.text}" добавлена',
            ),
            backgroundColor: Colors.green,
          ),
        );
        context.pop();
      } else {
        final error = ref.read(cagesProvider).error;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error ?? 'Ошибка сохранения клетки'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
