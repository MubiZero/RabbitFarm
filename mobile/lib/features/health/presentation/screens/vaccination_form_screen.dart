import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../data/models/vaccination_model.dart';
import '../../../rabbits/data/models/rabbit_model.dart';
import '../../../rabbits/presentation/providers/rabbits_provider.dart';
import '../providers/vaccinations_provider.dart';

/// Экран формы добавления/редактирования вакцинации
class VaccinationFormScreen extends ConsumerStatefulWidget {
  final Vaccination? vaccination;
  final RabbitModel? rabbit; // Можно передать кролика для автозаполнения

  const VaccinationFormScreen({
    super.key,
    this.vaccination,
    this.rabbit,
  });

  @override
  ConsumerState<VaccinationFormScreen> createState() =>
      _VaccinationFormScreenState();
}

class _VaccinationFormScreenState extends ConsumerState<VaccinationFormScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _vaccineNameController;
  late TextEditingController _batchNumberController;
  late TextEditingController _veterinarianController;
  late TextEditingController _notesController;

  int? _selectedRabbitId;
  VaccineType _selectedVaccineType = VaccineType.vhd;
  DateTime _vaccinationDate = DateTime.now();
  DateTime? _nextVaccinationDate;
  bool _isSubmitting = false;

  // Популярные названия вакцин
  final Map<VaccineType, List<String>> _commonVaccines = {
    VaccineType.vhd: [
      'Раббивак V',
      'Песторин',
      'ВГБК вакцина',
    ],
    VaccineType.myxomatosis: [
      'Раббивак B',
      'Лапимун Микс',
      'Миксоматоз вакцина',
    ],
    VaccineType.pasteurellosis: [
      'Пастовак',
      'Песторин Mormyx',
    ],
    VaccineType.other: [],
  };

  @override
  void initState() {
    super.initState();

    // Инициализация контроллеров
    _vaccineNameController = TextEditingController(
      text: widget.vaccination?.vaccineName ?? '',
    );
    _batchNumberController = TextEditingController(
      text: widget.vaccination?.batchNumber ?? '',
    );
    _veterinarianController = TextEditingController(
      text: widget.vaccination?.veterinarian ?? '',
    );
    _notesController = TextEditingController(
      text: widget.vaccination?.notes ?? '',
    );

    // Инициализация значений
    if (widget.vaccination != null) {
      _selectedRabbitId = widget.vaccination!.rabbitId;
      _selectedVaccineType = widget.vaccination!.vaccineType;
      _vaccinationDate = widget.vaccination!.vaccinationDate;
      _nextVaccinationDate = widget.vaccination!.nextVaccinationDate;
    } else if (widget.rabbit != null) {
      _selectedRabbitId = widget.rabbit!.id;
    }
  }

  @override
  void dispose() {
    _vaccineNameController.dispose();
    _batchNumberController.dispose();
    _veterinarianController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.vaccination != null;
    final rabbitsState = ref.watch(rabbitsListProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Редактировать вакцинацию' : 'Добавить вакцинацию'),
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
              if (!isEditing)
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
                            'Зарегистрируйте вакцинацию для отслеживания графика прививок',
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

              // Выбор кролика
              DropdownButtonFormField<int>(
                value: _selectedRabbitId,
                decoration: InputDecoration(
                  labelText: 'Кролик *',
                  prefixIcon: const Icon(Icons.pets, color: Colors.orange),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                items: rabbitsState.rabbits.map((rabbit) {
                  return DropdownMenuItem(
                    value: rabbit.id,
                    child: Text('${rabbit.name} (${rabbit.tagId})'),
                  );
                }).toList(),
                onChanged: isEditing
                    ? null
                    : (value) {
                        setState(() {
                          _selectedRabbitId = value;
                        });
                      },
                validator: (value) {
                  if (value == null) {
                    return 'Выберите кролика';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Тип вакцины
              DropdownButtonFormField<VaccineType>(
                value: _selectedVaccineType,
                decoration: InputDecoration(
                  labelText: 'Тип вакцины *',
                  prefixIcon: const Icon(Icons.category, color: Colors.purple),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                items: VaccineType.values.map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(type.fullName),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedVaccineType = value;
                      // Если поле названия пустое, предложим первую из списка
                      if (_vaccineNameController.text.isEmpty) {
                        final suggestions = _commonVaccines[value];
                        if (suggestions != null && suggestions.isNotEmpty) {
                          _vaccineNameController.text = suggestions.first;
                        }
                      }
                    });
                  }
                },
              ),
              const SizedBox(height: 16),

              // Название вакцины с автозаполнением
              Autocomplete<String>(
                initialValue: TextEditingValue(text: _vaccineNameController.text),
                optionsBuilder: (textEditingValue) {
                  if (textEditingValue.text.isEmpty) {
                    return _commonVaccines[_selectedVaccineType] ?? [];
                  }
                  final suggestions = _commonVaccines[_selectedVaccineType] ?? [];
                  return suggestions.where((option) {
                    return option
                        .toLowerCase()
                        .contains(textEditingValue.text.toLowerCase());
                  });
                },
                onSelected: (selection) {
                  _vaccineNameController.text = selection;
                },
                fieldViewBuilder: (context, controller, focusNode, onEditingComplete) {
                  // Синхронизируем с нашим контроллером
                  _vaccineNameController.text = controller.text;
                  return TextFormField(
                    controller: controller,
                    focusNode: focusNode,
                    decoration: InputDecoration(
                      labelText: 'Название вакцины *',
                      hintText: 'Например: Раббивак V',
                      prefixIcon: const Icon(Icons.vaccines, color: Colors.green),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Введите название вакцины';
                      }
                      return null;
                    },
                    onEditingComplete: onEditingComplete,
                  );
                },
              ),
              const SizedBox(height: 16),

              // Дата вакцинации
              InkWell(
                onTap: () => _selectVaccinationDate(context),
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: 'Дата вакцинации *',
                    prefixIcon: const Icon(Icons.calendar_today, color: Colors.blue),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    DateFormat('dd.MM.yyyy').format(_vaccinationDate),
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Следующая вакцинация
              InkWell(
                onTap: () => _selectNextVaccinationDate(context),
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: 'Следующая вакцинация',
                    hintText: 'Не указана',
                    prefixIcon: const Icon(Icons.event, color: Colors.orange),
                    suffixIcon: _nextVaccinationDate != null
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              setState(() {
                                _nextVaccinationDate = null;
                              });
                            },
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    _nextVaccinationDate != null
                        ? DateFormat('dd.MM.yyyy').format(_nextVaccinationDate!)
                        : 'Не указана',
                    style: TextStyle(
                      fontSize: 16,
                      color: _nextVaccinationDate != null
                          ? Colors.black
                          : Colors.grey[600],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              // Кнопки быстрого выбора срока
              Wrap(
                spacing: 8,
                children: [
                  _QuickDateButton(
                    label: '+3 мес',
                    onPressed: () {
                      setState(() {
                        _nextVaccinationDate = _vaccinationDate.add(
                          const Duration(days: 90),
                        );
                      });
                    },
                  ),
                  _QuickDateButton(
                    label: '+6 мес',
                    onPressed: () {
                      setState(() {
                        _nextVaccinationDate = _vaccinationDate.add(
                          const Duration(days: 180),
                        );
                      });
                    },
                  ),
                  _QuickDateButton(
                    label: '+1 год',
                    onPressed: () {
                      setState(() {
                        _nextVaccinationDate = _vaccinationDate.add(
                          const Duration(days: 365),
                        );
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Дополнительная информация
              Text(
                'Дополнительная информация',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 16),

              // Номер партии
              TextFormField(
                controller: _batchNumberController,
                decoration: InputDecoration(
                  labelText: 'Номер партии',
                  hintText: 'Например: 12345-67',
                  prefixIcon: const Icon(Icons.tag, color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Ветеринар
              TextFormField(
                controller: _veterinarianController,
                decoration: InputDecoration(
                  labelText: 'Ветеринар',
                  hintText: 'ФИО ветеринара',
                  prefixIcon: const Icon(Icons.person, color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Заметки
              TextFormField(
                controller: _notesController,
                decoration: InputDecoration(
                  labelText: 'Заметки',
                  hintText: 'Дополнительная информация',
                  prefixIcon: const Icon(Icons.note, color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 32),

              // Кнопка сохранения
              ElevatedButton(
                onPressed: _isSubmitting ? null : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[700],
                  padding: const EdgeInsets.symmetric(vertical: 16),
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
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Text(
                        isEditing ? 'Сохранить изменения' : 'Добавить вакцинацию',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectVaccinationDate(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      initialDate: _vaccinationDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (date != null) {
      setState(() {
        _vaccinationDate = date;
        // Если следующая вакцинация раньше текущей, сбрасываем
        if (_nextVaccinationDate != null &&
            _nextVaccinationDate!.isBefore(date)) {
          _nextVaccinationDate = null;
        }
      });
    }
  }

  Future<void> _selectNextVaccinationDate(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      initialDate: _nextVaccinationDate ??
          _vaccinationDate.add(const Duration(days: 180)),
      firstDate: _vaccinationDate,
      lastDate: DateTime.now().add(const Duration(days: 730)), // +2 года
    );

    if (date != null) {
      setState(() {
        _nextVaccinationDate = date;
      });
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedRabbitId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Выберите кролика')),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final request = VaccinationRequest(
        rabbitId: _selectedRabbitId!,
        vaccineName: _vaccineNameController.text.trim(),
        vaccineType: _selectedVaccineType,
        vaccinationDate: _vaccinationDate,
        nextVaccinationDate: _nextVaccinationDate,
        batchNumber: _batchNumberController.text.trim().isNotEmpty
            ? _batchNumberController.text.trim()
            : null,
        veterinarian: _veterinarianController.text.trim().isNotEmpty
            ? _veterinarianController.text.trim()
            : null,
        notes: _notesController.text.trim().isNotEmpty
            ? _notesController.text.trim()
            : null,
      );

      final success = widget.vaccination != null
          ? await ref
              .read(vaccinationsProvider.notifier)
              .updateVaccination(widget.vaccination!.id, request)
          : await ref
              .read(vaccinationsProvider.notifier)
              .createVaccination(request);

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.vaccination != null
                  ? 'Вакцинация обновлена'
                  : 'Вакцинация добавлена',
            ),
            backgroundColor: Colors.green,
          ),
        );
        context.pop();
      } else if (mounted) {
        final error = ref.read(vaccinationsProvider).error;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error ?? 'Ошибка сохранения'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }
}

/// Виджет быстрой кнопки выбора даты
class _QuickDateButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const _QuickDateButton({
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        minimumSize: const Size(0, 32),
      ),
      child: Text(label, style: const TextStyle(fontSize: 12)),
    );
  }
}
