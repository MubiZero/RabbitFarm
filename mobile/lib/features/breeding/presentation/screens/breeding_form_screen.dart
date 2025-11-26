import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/breeding_provider.dart';
import '../../../rabbits/presentation/providers/rabbits_provider.dart';

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
    
    // Предзаполнение данными из планировщика
    if (widget.initialData != null) {
      _selectedMaleId = widget.initialData!['male_id'] as int?;
      _selectedFemaleId = widget.initialData!['female_id'] as int?;
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedMaleId == null || _selectedFemaleId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Выберите самца и самку'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

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
        // Обновить список случек
        ref.invalidate(breedingListProvider);
        
        // Вернуться назад с результатом успеха
        context.pop(true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ошибка: ${e.toString().replaceAll('Exception: ', '')}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final rabbitsState = ref.watch(rabbitsListProvider);
    final males = rabbitsState.rabbits.where((r) => r.sex == 'male').toList();
    final females = rabbitsState.rabbits.where((r) => r.sex == 'female').toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Новая случка'),
        backgroundColor: Colors.purple[700],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Информационная карточка
            if (widget.initialData?['analysis'] != null)
              Card(
                color: Colors.blue[50],
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.blue[700]),
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
            
            const SizedBox(height: 16),

            // Выбор самца
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.male, color: Colors.blue),
                        SizedBox(width: 8),
                        Text(
                          'Самец',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<int>(
                      value: _selectedMaleId,
                      decoration: const InputDecoration(
                        hintText: 'Выберите самца',
                        border: OutlineInputBorder(),
                      ),
                      items: males.map((rabbit) {
                        return DropdownMenuItem(
                          value: rabbit.id,
                          child: Text('${rabbit.name} (${rabbit.tagId})'),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() => _selectedMaleId = value);
                      },
                      validator: (value) {
                        if (value == null) return 'Выберите самца';
                        return null;
                      },
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Выбор самки
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.female, color: Colors.pink),
                        SizedBox(width: 8),
                        Text(
                          'Самка',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<int>(
                      value: _selectedFemaleId,
                      decoration: const InputDecoration(
                        hintText: 'Выберите самку',
                        border: OutlineInputBorder(),
                      ),
                      items: females.map((rabbit) {
                        return DropdownMenuItem(
                          value: rabbit.id,
                          child: Text('${rabbit.name} (${rabbit.tagId})'),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() => _selectedFemaleId = value);
                      },
                      validator: (value) {
                        if (value == null) return 'Выберите самку';
                        return null;
                      },
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Дата случки
            Card(
              child: ListTile(
                leading: const Icon(Icons.calendar_today),
                title: const Text('Дата случки'),
                subtitle: Text(
                  '${_breedingDate.day}.${_breedingDate.month}.${_breedingDate.year}',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                trailing: const Icon(Icons.edit),
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: _breedingDate,
                    firstDate: DateTime.now().subtract(const Duration(days: 365)),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (date != null) {
                    setState(() => _breedingDate = date);
                  }
                },
              ),
            ),

            const SizedBox(height: 16),

            // Статус
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Статус',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: _status,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(value: 'planned', child: Text('Запланирована')),
                        DropdownMenuItem(value: 'completed', child: Text('Завершена')),
                        DropdownMenuItem(value: 'failed', child: Text('Неудачная')),
                        DropdownMenuItem(value: 'cancelled', child: Text('Отменена')),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => _status = value);
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Заметки
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Заметки',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      initialValue: _notes,
                      decoration: const InputDecoration(
                        hintText: 'Дополнительная информация...',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                      onSaved: (value) => _notes = value ?? '',
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Кнопка сохранения
            ElevatedButton(
              onPressed: _isSubmitting ? null : _submitForm,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
                backgroundColor: Colors.purple[700],
              ),
              child: _isSubmitting
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Text(
                      'Сохранить',
                      style: TextStyle(fontSize: 16),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
