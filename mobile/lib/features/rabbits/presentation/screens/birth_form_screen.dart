import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../data/models/birth_model.dart';
import '../../data/models/breeding_model.dart';
import '../providers/births_provider.dart';
import '../providers/rabbits_provider.dart';

/// Экран формы регистрации окрола
///
/// Позволяет зарегистрировать окрол и автоматически создать карточки крольчат
class BirthFormScreen extends ConsumerStatefulWidget {
  final BirthModel? birth;
  final BreedingModel? breeding; // Можно передать случку для автозаполнения

  const BirthFormScreen({
    super.key,
    this.birth,
    this.breeding,
  });

  @override
  ConsumerState<BirthFormScreen> createState() => _BirthFormScreenState();
}

class _BirthFormScreenState extends ConsumerState<BirthFormScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _kitsBornAliveController;
  late TextEditingController _kitsBornDeadController;
  late TextEditingController _complicationsController;
  late TextEditingController _notesController;

  int? _selectedMotherId;
  DateTime? _birthDate;
  bool _isSubmitting = false;
  bool _createKits = true; // Автосоздание крольчат по умолчанию включено

  @override
  void initState() {
    super.initState();
    _kitsBornAliveController = TextEditingController(
      text: widget.birth?.kitsBornAlive.toString() ?? '',
    );
    _kitsBornDeadController = TextEditingController(
      text: widget.birth?.kitsBornDead.toString() ?? '',
    );
    _complicationsController = TextEditingController(
      text: widget.birth?.complications ?? '',
    );
    _notesController = TextEditingController(
      text: widget.birth?.notes ?? '',
    );

    _selectedMotherId = widget.birth?.motherId ?? widget.breeding?.femaleId;
    _birthDate = widget.birth?.birthDate != null
        ? DateTime.parse(widget.birth!.birthDate)
        : DateTime.now();
  }

  @override
  void dispose() {
    _kitsBornAliveController.dispose();
    _kitsBornDeadController.dispose();
    _complicationsController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.birth != null;
    final rabbitsState = ref.watch(rabbitsListProvider);
    final females = rabbitsState.rabbits.where((r) => r.sex == 'female').toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Редактировать окрол' : 'Зарегистрировать окрол'),
        centerTitle: true,
        backgroundColor: Colors.green[700],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Информационная карточка
              Card(
                color: Colors.blue[50],
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.blue[700]),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Зарегистрируйте окрол и автоматически создайте карточки для крольчат',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.blue[900],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Выбор самки
              DropdownButtonFormField<int>(
                value: _selectedMotherId,
                decoration: InputDecoration(
                  labelText: 'Самка (мать) *',
                  prefixIcon: const Icon(Icons.female, color: Colors.pink),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                items: females.map((rabbit) {
                  return DropdownMenuItem(
                    value: rabbit.id,
                    child: Text('${rabbit.name} (${rabbit.tagId})'),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedMotherId = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Выберите самку';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Дата окрола
              InkWell(
                onTap: () => _selectDate(context),
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: 'Дата окрола *',
                    prefixIcon: const Icon(Icons.calendar_today),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    _birthDate != null
                        ? _formatDate(_birthDate!)
                        : 'Выберите дату',
                    style: TextStyle(
                      fontSize: 16,
                      color: _birthDate != null ? Colors.black : Colors.grey[600],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Заголовок статистики
              Text(
                'Статистика помёта',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),

              const SizedBox(height: 16),

              // Родилось живыми
              TextFormField(
                controller: _kitsBornAliveController,
                decoration: InputDecoration(
                  labelText: 'Родилось живыми *',
                  hintText: 'Количество',
                  prefixIcon: Icon(Icons.child_care, color: Colors.green[700]),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Введите количество';
                  }
                  final num = int.tryParse(value);
                  if (num == null || num < 0) {
                    return 'Введите корректное число';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Родилось мертвыми
              TextFormField(
                controller: _kitsBornDeadController,
                decoration: InputDecoration(
                  labelText: 'Родилось мертвыми',
                  hintText: 'Количество (опционально)',
                  prefixIcon: Icon(Icons.close, color: Colors.red[700]),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    final num = int.tryParse(value);
                    if (num == null || num < 0) {
                      return 'Введите корректное число';
                    }
                  }
                  return null;
                },
              ),

              const SizedBox(height: 24),

              // Осложнения
              TextFormField(
                controller: _complicationsController,
                decoration: InputDecoration(
                  labelText: 'Осложнения',
                  hintText: 'Опишите, если были осложнения',
                  prefixIcon: const Icon(Icons.warning_amber),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                maxLines: 2,
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
                ),
                maxLines: 3,
              ),

              const SizedBox(height: 24),

              // Чекбокс автосоздания крольчат
              if (!isEditing)
                Card(
                  color: Colors.green[50],
                  child: CheckboxListTile(
                    title: const Text(
                      'Автоматически создать карточки крольчат',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      'Будет создано ${_kitsBornAliveController.text.isNotEmpty ? _kitsBornAliveController.text : "0"} карточек',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    value: _createKits,
                    onChanged: (value) {
                      setState(() {
                        _createKits = value ?? false;
                      });
                    },
                    secondary: Icon(
                      Icons.auto_awesome,
                      color: Colors.green[700],
                    ),
                  ),
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
                        backgroundColor: Colors.green[700],
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
                          : Text(isEditing ? 'Сохранить' : 'Зарегистрировать'),
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

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _birthDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        _birthDate = picked;
      });
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate() || _birthDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Пожалуйста, заполните все обязательные поля'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    final birthData = {
      'mother_id': _selectedMotherId,
      if (widget.breeding != null) 'breeding_id': widget.breeding!.id,
      'birth_date': _birthDate!.toIso8601String().split('T')[0],
      'kits_born_alive': int.parse(_kitsBornAliveController.text),
      'kits_born_dead': _kitsBornDeadController.text.isNotEmpty
          ? int.parse(_kitsBornDeadController.text)
          : 0,
      if (_complicationsController.text.isNotEmpty)
        'complications': _complicationsController.text,
      if (_notesController.text.isNotEmpty) 'notes': _notesController.text,
    };

    final isEditing = widget.birth != null;
    BirthModel? birth;

    if (isEditing) {
      final success = await ref
          .read(birthsProvider.notifier)
          .updateBirth(widget.birth!.id, birthData);

      if (mounted) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Окрол обновлен'),
              backgroundColor: Colors.green,
            ),
          );
          context.pop();
        } else {
          setState(() {
            _isSubmitting = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                ref.read(birthsProvider).error ?? 'Ошибка обновления окрола',
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } else {
      birth = await ref.read(birthsProvider.notifier).createBirth(birthData);

      if (mounted) {
        if (birth != null) {
          // Если нужно создать крольчат
          if (_createKits && int.parse(_kitsBornAliveController.text) > 0) {
            await _createKitsDialog(context, birth);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Окрол зарегистрирован'),
                backgroundColor: Colors.green,
              ),
            );
            context.pop();
          }
        } else {
          setState(() {
            _isSubmitting = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                ref.read(birthsProvider).error ?? 'Ошибка регистрации окрола',
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  Future<void> _createKitsDialog(BuildContext context, BirthModel birth) async {
    final mother = ref.read(rabbitsListProvider).rabbits.firstWhere(
          (r) => r.id == birth.motherId,
        );

    final namePrefixController = TextEditingController(
      text: '${mother.name}-',
    );

    final shouldCreate = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Создать карточки крольчат?'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Будет создано ${birth.kitsBornAlive} карточек кроликов',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: namePrefixController,
              decoration: const InputDecoration(
                labelText: 'Префикс имени',
                hintText: 'Например: Белка-',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Крольчата будут названы: ${namePrefixController.text}1, ${namePrefixController.text}2, ...',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Отмена'),
          ),
          ElevatedButton.icon(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green[700],
            ),
            icon: const Icon(Icons.auto_awesome),
            label: const Text('Создать'),
          ),
        ],
      ),
    );

    if (shouldCreate == true && mounted) {
      final kits = await ref.read(birthsProvider.notifier).createKitsFromBirth(
            birthId: birth.id,
            motherId: birth.motherId,
            fatherId: widget.breeding?.maleId,
            breedId: mother.breed!.id,
            birthDate: birth.birthDate,
            count: birth.kitsBornAlive,
            namePrefix: namePrefixController.text,
          );

      if (mounted) {
        if (kits != null) {
          // Обновляем список кроликов
          await ref.read(rabbitsListProvider.notifier).refresh();

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Окрол зарегистрирован! Создано ${kits.length} крольчат',
              ),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 4),
            ),
          );
          context.pop();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                ref.read(birthsProvider).error ?? 'Ошибка создания крольчат',
              ),
              backgroundColor: Colors.orange,
            ),
          );
        }
      }
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Окрол зарегистрирован'),
          backgroundColor: Colors.green,
        ),
      );
      context.pop();
    }

    setState(() {
      _isSubmitting = false;
    });
  }

  String _formatDate(DateTime date) {
    final months = [
      'января',
      'февраля',
      'марта',
      'апреля',
      'мая',
      'июня',
      'июля',
      'августа',
      'сентября',
      'октября',
      'ноября',
      'декабря'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
}
