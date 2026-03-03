import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../data/models/cage_model.dart';
import '../providers/cages_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_form_section.dart';

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
    {'value': 'single', 'label': 'Одиночная'},
    {'value': 'group', 'label': 'Групповая'},
    {'value': 'maternity', 'label': 'Для окрола'},
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
                  controller: _numberController,
                  decoration: const InputDecoration(
                    labelText: 'Номер клетки *',
                    hintText: 'Например: A-1',
                    prefixIcon: Icon(Icons.tag),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Введите номер клетки';
                    }
                    return null;
                  },
                ),
                DropdownButtonFormField<String>(
                  value: _selectedType,
                  decoration: const InputDecoration(
                    labelText: 'Тип клетки *',
                    prefixIcon: Icon(Icons.category),
                  ),
                  items: _types.map((type) {
                    return DropdownMenuItem(
                      value: type['value'],
                      child: Text(type['label']!),
                    );
                  }).toList(),
                  onChanged: (value) => setState(() => _selectedType = value!),
                ),
                TextFormField(
                  controller: _capacityController,
                  decoration: const InputDecoration(
                    labelText: 'Вместимость *',
                    hintText: 'Количество кроликов',
                    prefixIcon: Icon(Icons.people),
                    suffixText: 'кроликов',
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
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
              ],
            ),
            AppFormSection(
              title: 'Дополнительно',
              children: [
                TextFormField(
                  controller: _sizeController,
                  decoration: const InputDecoration(
                    labelText: 'Размер',
                    hintText: 'Например: 60x80x45',
                    prefixIcon: Icon(Icons.straighten),
                    suffixText: 'см',
                  ),
                ),
                TextFormField(
                  controller: _locationController,
                  decoration: const InputDecoration(
                    labelText: 'Расположение',
                    hintText: 'Например: Сарай 1, Ряд A',
                    prefixIcon: Icon(Icons.location_on),
                  ),
                ),
                DropdownButtonFormField<String>(
                  value: _selectedCondition,
                  decoration: const InputDecoration(
                    labelText: 'Состояние *',
                    prefixIcon: Icon(Icons.build),
                  ),
                  items: _conditions.map((condition) {
                    return DropdownMenuItem(
                      value: condition['value'],
                      child: Text(condition['label']!),
                    );
                  }).toList(),
                  onChanged: (value) => setState(() => _selectedCondition = value!),
                ),
              ],
            ),
            AppFormSection(
              title: 'Заметки',
              children: [
                TextFormField(
                  controller: _notesController,
                  decoration: const InputDecoration(
                    labelText: 'Заметки',
                    hintText: 'Дополнительная информация',
                    prefixIcon: Icon(Icons.notes),
                  ),
                  maxLines: 4,
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
              onPressed: _isSubmitting ? null : _submitForm,
              child: _isSubmitting
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(isEditing ? 'Сохранить' : 'Добавить'),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isSubmitting = true);

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

    final isEditing = widget.cage != null;
    bool success;

    if (isEditing) {
      success = await ref
          .read(cagesProvider.notifier)
          .updateCage(widget.cage!.id, cageData);
    } else {
      success = await ref.read(cagesProvider.notifier).createCage(cageData);
    }

    setState(() => _isSubmitting = false);

    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isEditing
                  ? 'Клетка "${_numberController.text}" обновлена'
                  : 'Клетка "${_numberController.text}" добавлена',
            ),
          ),
        );
        context.pop();
      } else {
        final error = ref.read(cagesProvider).error;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error ?? 'Ошибка сохранения клетки'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }
}
