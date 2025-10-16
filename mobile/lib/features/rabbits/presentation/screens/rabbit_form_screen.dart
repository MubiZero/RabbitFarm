import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../data/models/rabbit_model.dart';
import '../providers/breeds_provider.dart';
import '../providers/rabbits_provider.dart';

class RabbitFormScreen extends ConsumerStatefulWidget {
  final int? rabbitId; // ID for edit mode
  final RabbitModel? rabbit; // Pre-loaded rabbit data (optional)

  const RabbitFormScreen({
    super.key,
    this.rabbitId,
    this.rabbit,
  });

  @override
  ConsumerState<RabbitFormScreen> createState() => _RabbitFormScreenState();
}

class _RabbitFormScreenState extends ConsumerState<RabbitFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _tagIdController = TextEditingController();
  final _colorController = TextEditingController();
  final _weightController = TextEditingController();
  final _notesController = TextEditingController();

  int? _selectedBreedId;
  String _selectedSex = 'male';
  String _selectedStatus = 'healthy';
  String _selectedPurpose = 'breeding';
  DateTime _birthDate = DateTime.now().subtract(const Duration(days: 60));
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.rabbit != null) {
      _loadRabbitDataFromModel(widget.rabbit!);
    } else if (widget.rabbitId != null) {
      // Load rabbit data from provider
      Future.microtask(() => _loadRabbitFromProvider());
    } else {
      // Generate tag ID for new rabbit
      _tagIdController.text = 'R-${DateTime.now().millisecondsSinceEpoch}';
    }
  }

  Future<void> _loadRabbitFromProvider() async {
    try {
      final rabbit = await ref.read(rabbitsRepositoryProvider).getRabbitById(widget.rabbitId!);
      if (mounted) {
        _loadRabbitDataFromModel(rabbit);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ошибка загрузки: ${e.toString().replaceAll('Exception: ', '')}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _loadRabbitDataFromModel(RabbitModel rabbit) {
    _nameController.text = rabbit.name;
    _tagIdController.text = rabbit.tagId;
    _colorController.text = rabbit.color ?? '';
    _weightController.text = rabbit.currentWeight?.toString() ?? '';
    _notesController.text = rabbit.notes ?? '';
    _selectedBreedId = rabbit.breedId;
    _selectedSex = rabbit.sex;
    _selectedStatus = rabbit.status;
    _selectedPurpose = rabbit.purpose;
    _birthDate = rabbit.birthDate;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _tagIdController.dispose();
    _colorController.dispose();
    _weightController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _selectBirthDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _birthDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      locale: const Locale('ru'),
    );
    if (picked != null) {
      setState(() {
        _birthDate = picked;
      });
    }
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedBreedId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Выберите породу'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final data = {
        'name': _nameController.text.trim(),
        'tag_id': _tagIdController.text.trim(),
        'breed_id': _selectedBreedId,
        'sex': _selectedSex,
        'birth_date': _birthDate.toIso8601String(),
        'status': _selectedStatus,
        'purpose': _selectedPurpose,
        if (_colorController.text.isNotEmpty) 'color': _colorController.text.trim(),
        if (_weightController.text.isNotEmpty)
          'current_weight': double.parse(_weightController.text),
        if (_notesController.text.isNotEmpty) 'notes': _notesController.text.trim(),
      };

      final isEditMode = widget.rabbitId != null || widget.rabbit != null;

      if (isEditMode) {
        // Update
        final id = widget.rabbitId ?? widget.rabbit!.id;
        await ref.read(rabbitsRepositoryProvider).updateRabbit(id, data);
      } else {
        // Create
        await ref.read(rabbitsRepositoryProvider).createRabbit(data);
      }

      // Refresh list
      ref.read(rabbitsListProvider.notifier).refresh();

      // Invalidate detail cache if editing
      if (isEditMode && widget.rabbitId != null) {
        ref.invalidate(rabbitDetailProvider(widget.rabbitId!));
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isEditMode
                  ? 'Данные обновлены'
                  : 'Кролик добавлен',
            ),
            backgroundColor: Colors.green,
          ),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceAll('Exception: ', '')),
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

  @override
  Widget build(BuildContext context) {
    final breedsAsync = ref.watch(breedsProvider);
    final isEditMode = widget.rabbitId != null || widget.rabbit != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditMode ? 'Редактировать' : 'Добавить кролика'),
        actions: [
          if (!_isLoading)
            TextButton(
              onPressed: _handleSubmit,
              child: const Text(
                'Сохранить',
                style: TextStyle(color: Colors.white),
              ),
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Name
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Кличка',
                hintText: 'Введите кличку',
                prefixIcon: Icon(Icons.pets),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Введите кличку';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Tag ID
            TextFormField(
              controller: _tagIdController,
              decoration: const InputDecoration(
                labelText: 'Номер бирки',
                hintText: 'R-XXX',
                prefixIcon: Icon(Icons.tag),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Введите номер бирки';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Breed
            breedsAsync.when(
              data: (breeds) => DropdownButtonFormField<int>(
                value: _selectedBreedId,
                decoration: const InputDecoration(
                  labelText: 'Порода',
                  prefixIcon: Icon(Icons.category),
                ),
                items: breeds.map((breed) {
                  return DropdownMenuItem(
                    value: breed.id,
                    child: Text(breed.name),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedBreedId = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Выберите породу';
                  }
                  return null;
                },
              ),
              loading: () => const LinearProgressIndicator(),
              error: (error, stack) => Text('Ошибка: $error'),
            ),
            const SizedBox(height: 16),

            // Sex
            DropdownButtonFormField<String>(
              value: _selectedSex,
              decoration: const InputDecoration(
                labelText: 'Пол',
                prefixIcon: Icon(Icons.wc),
              ),
              items: const [
                DropdownMenuItem(value: 'male', child: Text('Самец')),
                DropdownMenuItem(value: 'female', child: Text('Самка')),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedSex = value!;
                });
              },
            ),
            const SizedBox(height: 16),

            // Birth Date
            InkWell(
              onTap: _selectBirthDate,
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Дата рождения',
                  prefixIcon: Icon(Icons.cake),
                ),
                child: Text(
                  DateFormat('dd.MM.yyyy').format(_birthDate),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Status
            DropdownButtonFormField<String>(
              value: _selectedStatus,
              decoration: const InputDecoration(
                labelText: 'Статус',
                prefixIcon: Icon(Icons.info),
              ),
              items: const [
                DropdownMenuItem(value: 'healthy', child: Text('Здоров')),
                DropdownMenuItem(value: 'sick', child: Text('Болен')),
                DropdownMenuItem(value: 'quarantine', child: Text('Карантин')),
                DropdownMenuItem(value: 'pregnant', child: Text('Беременна')),
                DropdownMenuItem(value: 'sold', child: Text('Продан')),
                DropdownMenuItem(value: 'dead', child: Text('Умер')),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedStatus = value!;
                });
              },
            ),
            const SizedBox(height: 16),

            // Purpose
            DropdownButtonFormField<String>(
              value: _selectedPurpose,
              decoration: const InputDecoration(
                labelText: 'Назначение',
                prefixIcon: Icon(Icons.flag),
              ),
              items: const [
                DropdownMenuItem(value: 'breeding', child: Text('Разведение')),
                DropdownMenuItem(value: 'meat', child: Text('Мясо')),
                DropdownMenuItem(value: 'sale', child: Text('Продажа')),
                DropdownMenuItem(value: 'show', child: Text('Выставка')),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedPurpose = value!;
                });
              },
            ),
            const SizedBox(height: 16),

            // Color
            TextFormField(
              controller: _colorController,
              decoration: const InputDecoration(
                labelText: 'Окрас (опционально)',
                hintText: 'Серый, белый, черный...',
                prefixIcon: Icon(Icons.palette),
              ),
            ),
            const SizedBox(height: 16),

            // Weight
            TextFormField(
              controller: _weightController,
              decoration: const InputDecoration(
                labelText: 'Вес (кг, опционально)',
                hintText: '0.0',
                prefixIcon: Icon(Icons.monitor_weight),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value != null && value.isNotEmpty) {
                  if (double.tryParse(value) == null) {
                    return 'Введите корректное число';
                  }
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Notes
            TextFormField(
              controller: _notesController,
              decoration: const InputDecoration(
                labelText: 'Заметки (опционально)',
                hintText: 'Дополнительная информация',
                prefixIcon: Icon(Icons.notes),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 24),

            // Submit button
            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else
              ElevatedButton(
                onPressed: _handleSubmit,
                child: Text(
                  isEditMode ? 'Сохранить изменения' : 'Добавить кролика',
                ),
              ),
          ],
        ),
      ),
    );
  }
}
