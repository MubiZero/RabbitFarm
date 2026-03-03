import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../data/models/breed_model.dart';
import '../providers/breeds_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_form_section.dart';

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
    _descriptionController =
        TextEditingController(text: widget.breed?.description ?? '');
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
                    labelText: 'Название породы *',
                    hintText: 'Например: Калифорнийский',
                    prefixIcon: Icon(Icons.pets),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Введите название породы';
                    }
                    return null;
                  },
                ),
                DropdownButtonFormField<String>(
                  value: _selectedPurpose,
                  decoration: const InputDecoration(
                    labelText: 'Назначение',
                    prefixIcon: Icon(Icons.category),
                  ),
                  items: _purposes.map((purpose) {
                    return DropdownMenuItem(
                      value: purpose['value'],
                      child: Text(purpose['label']!),
                    );
                  }).toList(),
                  onChanged: (value) => setState(() => _selectedPurpose = value),
                ),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Описание',
                    hintText: 'Краткое описание породы',
                    prefixIcon: Icon(Icons.description_outlined),
                  ),
                  maxLines: 3,
                ),
              ],
            ),
            AppFormSection(
              title: 'Характеристики',
              children: [
                TextFormField(
                  controller: _averageWeightController,
                  decoration: const InputDecoration(
                    labelText: 'Средний вес',
                    hintText: 'Например: 4.5',
                    prefixIcon: Icon(Icons.monitor_weight_outlined),
                    suffixText: 'кг',
                  ),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
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
                TextFormField(
                  controller: _averageLitterSizeController,
                  decoration: const InputDecoration(
                    labelText: 'Средний размер помёта',
                    hintText: 'Например: 8',
                    prefixIcon: Icon(Icons.family_restroom),
                    suffixText: 'крольчат',
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
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
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

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

    final isEditing = widget.breed != null;
    bool success;

    if (isEditing) {
      success = await ref
          .read(breedsProvider.notifier)
          .updateBreed(widget.breed!.id, breedData);
    } else {
      success =
          await ref.read(breedsProvider.notifier).createBreed(breedData);
    }

    setState(() => _isSubmitting = false);

    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isEditing
                  ? 'Порода "${_nameController.text}" обновлена'
                  : 'Порода "${_nameController.text}" добавлена',
            ),
          ),
        );
        context.pop();
      } else {
        final error = ref.read(breedsProvider).error;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error ?? 'Ошибка сохранения породы'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }
}
