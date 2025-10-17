import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../data/models/breed_model.dart';
import '../providers/breeds_provider.dart';

/// Экран формы добавления/редактирования породы
class BreedFormScreen extends ConsumerStatefulWidget {
  final BreedModel? breed;

  const BreedFormScreen({
    super.key,
    this.breed,
  });

  @override
  ConsumerState<BreedFormScreen> createState() => _BreedFormScreenState();
}

class _BreedFormScreenState extends ConsumerState<BreedFormScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _averageWeightController;
  late TextEditingController _averageLitterSizeController;

  String? _selectedPurpose;
  bool _isSubmitting = false;

  final List<Map<String, String>> _purposes = [
    {'value': 'meat', 'label': 'Мясная'},
    {'value': 'fur', 'label': 'Пуховая'},
    {'value': 'decorative', 'label': 'Декоративная'},
    {'value': 'combined', 'label': 'Мясо-шкурковая'},
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.breed?.name ?? '');
    _descriptionController = TextEditingController(text: widget.breed?.description ?? '');
    _averageWeightController = TextEditingController(
      text: widget.breed?.averageWeight?.toString() ?? '',
    );
    _averageLitterSizeController = TextEditingController(
      text: widget.breed?.averageLitterSize?.toString() ?? '',
    );
    _selectedPurpose = widget.breed?.purpose;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _averageWeightController.dispose();
    _averageLitterSizeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.breed != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Редактировать породу' : 'Добавить породу'),
        centerTitle: true,
        backgroundColor: Colors.brown[700],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Название породы
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Название породы *',
                  hintText: 'Например: Калифорнийский',
                  prefixIcon: const Icon(Icons.pets),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Введите название породы';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Назначение
              DropdownButtonFormField<String>(
                value: _selectedPurpose,
                decoration: InputDecoration(
                  labelText: 'Назначение',
                  prefixIcon: const Icon(Icons.category),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                items: _purposes.map((purpose) {
                  return DropdownMenuItem(
                    value: purpose['value'],
                    child: Text(purpose['label']!),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedPurpose = value;
                  });
                },
              ),

              const SizedBox(height: 16),

              // Описание
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Описание',
                  hintText: 'Краткое описание породы',
                  prefixIcon: const Icon(Icons.description),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                maxLines: 3,
              ),

              const SizedBox(height: 24),

              // Заголовок характеристик
              Text(
                'Характеристики',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),

              const SizedBox(height: 16),

              // Средний вес
              TextFormField(
                controller: _averageWeightController,
                decoration: InputDecoration(
                  labelText: 'Средний вес (кг)',
                  hintText: 'Например: 4.5',
                  prefixIcon: const Icon(Icons.monitor_weight),
                  suffixText: 'кг',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                ],
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    final weight = double.tryParse(value);
                    if (weight == null || weight <= 0) {
                      return 'Введите корректный вес';
                    }
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Средний размер помёта
              TextFormField(
                controller: _averageLitterSizeController,
                decoration: InputDecoration(
                  labelText: 'Средний размер помёта',
                  hintText: 'Например: 8',
                  prefixIcon: const Icon(Icons.family_restroom),
                  suffixText: 'крольчат',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    final size = int.tryParse(value);
                    if (size == null || size <= 0) {
                      return 'Введите корректное число';
                    }
                  }
                  return null;
                },
              ),

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
                        backgroundColor: Colors.brown[700],
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

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    final breedData = {
      'name': _nameController.text.trim(),
      if (_descriptionController.text.trim().isNotEmpty)
        'description': _descriptionController.text.trim(),
      if (_selectedPurpose != null) 'purpose': _selectedPurpose,
      if (_averageWeightController.text.isNotEmpty)
        'average_weight': double.parse(_averageWeightController.text),
      if (_averageLitterSizeController.text.isNotEmpty)
        'average_litter_size': int.parse(_averageLitterSizeController.text),
    };

    bool success;
    final isEditing = widget.breed != null;

    if (isEditing) {
      success = await ref
          .read(breedsProvider.notifier)
          .updateBreed(widget.breed!.id, breedData);
    } else {
      success = await ref.read(breedsProvider.notifier).createBreed(breedData);
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
                  ? 'Порода "${_nameController.text}" обновлена'
                  : 'Порода "${_nameController.text}" добавлена',
            ),
            backgroundColor: Colors.green,
          ),
        );
        context.pop();
      } else {
        final error = ref.read(breedsProvider).error;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error ?? 'Ошибка сохранения породы'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
