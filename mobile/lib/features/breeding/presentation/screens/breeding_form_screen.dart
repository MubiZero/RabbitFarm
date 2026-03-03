import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/breeding_provider.dart';
import '../../../rabbits/presentation/providers/rabbits_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_date_field.dart';
import '../../../../core/widgets/app_form_section.dart';

class BreedingFormScreen extends ConsumerStatefulWidget {
  final Map<String, dynamic>? initialData;

  const BreedingFormScreen({super.key, this.initialData});

  @override
  ConsumerState<BreedingFormScreen> createState() => _BreedingFormScreenState();
}

class _BreedingFormScreenState extends ConsumerState<BreedingFormScreen> {
  final _formKey = GlobalKey<FormState>();

  int? _selectedMaleId;
  int? _selectedFemaleId;
  DateTime _breedingDate = DateTime.now();
  String _status = 'planned';
  String _notes = '';
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialData != null) {
      _selectedMaleId = widget.initialData!['male_id'] as int?;
      _selectedFemaleId = widget.initialData!['female_id'] as int?;
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    _formKey.currentState!.save();

    setState(() => _isSubmitting = true);

    try {
      final repository = ref.read(breedingRepositoryProvider);

      await repository.createBreeding({
        'male_id': _selectedMaleId,
        'female_id': _selectedFemaleId,
        'breeding_date': _breedingDate.toIso8601String().split('T')[0],
        'status': _status,
        'notes': _notes.isNotEmpty ? _notes : null,
      });

      if (mounted) {
        ref.invalidate(breedingListProvider);
        context.pop(true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Ошибка: ${e.toString().replaceAll('Exception: ', '')}'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final rabbitsState = ref.watch(rabbitsListProvider);
    final males = rabbitsState.rabbits.where((r) => r.sex == 'male').toList();
    final females =
        rabbitsState.rabbits.where((r) => r.sex == 'female').toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Новая случка'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
          children: [
            if (widget.initialData?['analysis'] != null)
              Card(
                color: AppColors.accentOcean.withValues(alpha: 0.08),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, color: AppColors.accentOcean),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          'Данные предзаполнены из планировщика случек',
                          style: TextStyle(fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            if (widget.initialData?['analysis'] != null)
              const SizedBox(height: 8),

            AppFormSection(
              title: 'Пара',
              children: [
                DropdownButtonFormField<int>(
                  value: _selectedMaleId,
                  decoration: const InputDecoration(
                    labelText: 'Самец *',
                    prefixIcon: Icon(Icons.male, color: AppColors.accentOcean),
                  ),
                  items: males.map((rabbit) {
                    return DropdownMenuItem(
                      value: rabbit.id,
                      child: Text('${rabbit.name} (${rabbit.tagId})'),
                    );
                  }).toList(),
                  onChanged: (value) => setState(() => _selectedMaleId = value),
                  validator: (value) =>
                      value == null ? 'Выберите самца' : null,
                ),
                DropdownButtonFormField<int>(
                  value: _selectedFemaleId,
                  decoration: const InputDecoration(
                    labelText: 'Самка *',
                    prefixIcon: Icon(Icons.female, color: AppColors.accentRose),
                  ),
                  items: females.map((rabbit) {
                    return DropdownMenuItem(
                      value: rabbit.id,
                      child: Text('${rabbit.name} (${rabbit.tagId})'),
                    );
                  }).toList(),
                  onChanged: (value) =>
                      setState(() => _selectedFemaleId = value),
                  validator: (value) =>
                      value == null ? 'Выберите самку' : null,
                ),
              ],
            ),

            AppFormSection(
              title: 'Детали',
              children: [
                AppDateField(
                  label: 'Дата случки *',
                  value: _breedingDate,
                  onChanged: (date) => setState(() => _breedingDate = date),
                  prefixIcon: Icons.calendar_today,
                  firstDate: DateTime.now().subtract(const Duration(days: 365)),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                ),
                DropdownButtonFormField<String>(
                  value: _status,
                  decoration: const InputDecoration(
                    labelText: 'Статус *',
                    prefixIcon: Icon(Icons.flag_outlined),
                  ),
                  items: const [
                    DropdownMenuItem(
                        value: 'planned', child: Text('Запланирована')),
                    DropdownMenuItem(
                        value: 'completed', child: Text('Завершена')),
                    DropdownMenuItem(
                        value: 'failed', child: Text('Неудачная')),
                    DropdownMenuItem(
                        value: 'cancelled', child: Text('Отменена')),
                  ],
                  onChanged: (value) {
                    if (value != null) setState(() => _status = value);
                  },
                ),
              ],
            ),

            AppFormSection(
              title: 'Заметки',
              children: [
                TextFormField(
                  initialValue: _notes,
                  decoration: const InputDecoration(
                    labelText: 'Заметки',
                    hintText: 'Дополнительная информация...',
                    prefixIcon: Icon(Icons.notes),
                  ),
                  maxLines: 3,
                  onSaved: (value) => _notes = value ?? '',
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
                  : const Text('Сохранить'),
            ),
          ),
        ),
      ),
    );
  }
}
