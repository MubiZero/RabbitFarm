import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../data/models/vaccination_model.dart';
import '../../../rabbits/data/models/rabbit_model.dart';
import '../../../rabbits/presentation/providers/rabbits_provider.dart';
import '../providers/vaccinations_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_date_field.dart';
import '../../../../core/widgets/app_form_section.dart';

/// Экран формы добавления/редактирования вакцинации
class VaccinationFormScreen extends ConsumerStatefulWidget {
  final Vaccination? vaccination;
  final RabbitModel? rabbit;

  const VaccinationFormScreen({
    super.key,
    this.vaccination,
    this.rabbit,
  });

  @override
  ConsumerState<VaccinationFormScreen> createState() =>
      _VaccinationFormScreenState();
}

class _VaccinationFormScreenState
    extends ConsumerState<VaccinationFormScreen> {
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

  final Map<VaccineType, List<String>> _commonVaccines = {
    VaccineType.vhd: ['Раббивак V', 'Песторин', 'ВГБК вакцина'],
    VaccineType.myxomatosis: [
      'Раббивак B',
      'Лапимун Микс',
      'Миксоматоз вакцина'
    ],
    VaccineType.pasteurellosis: ['Пастовак', 'Песторин Mormyx'],
    VaccineType.other: [],
  };

  @override
  void initState() {
    super.initState();
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
    final cs = Theme.of(context).colorScheme;
    final isEditing = widget.vaccination != null;
    final rabbitsState = ref.watch(rabbitsListProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
            isEditing ? 'Редактировать вакцинацию' : 'Добавить вакцинацию'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
          children: [
            if (!isEditing)
              Card(
                color: AppColors.accentOcean.withValues(alpha: 0.08),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, color: AppColors.accentOcean),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Зарегистрируйте вакцинацию для отслеживания графика прививок',
                          style: TextStyle(
                              fontSize: 13, color: AppColors.accentOcean),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            if (!isEditing) const SizedBox(height: 8),

            AppFormSection(
              title: 'Основное',
              children: [
                DropdownButtonFormField<int>(
                  value: _selectedRabbitId,
                  decoration: const InputDecoration(
                    labelText: 'Кролик *',
                    prefixIcon: Icon(Icons.pets),
                  ),
                  items: rabbitsState.rabbits.map((rabbit) {
                    return DropdownMenuItem(
                      value: rabbit.id,
                      child: Text('${rabbit.name} (${rabbit.tagId})'),
                    );
                  }).toList(),
                  onChanged: isEditing
                      ? null
                      : (value) => setState(() => _selectedRabbitId = value),
                  validator: (value) =>
                      value == null ? 'Выберите кролика' : null,
                ),
                DropdownButtonFormField<VaccineType>(
                  value: _selectedVaccineType,
                  decoration: const InputDecoration(
                    labelText: 'Тип вакцины *',
                    prefixIcon: Icon(Icons.category),
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
                Autocomplete<String>(
                  initialValue:
                      TextEditingValue(text: _vaccineNameController.text),
                  optionsBuilder: (textEditingValue) {
                    if (textEditingValue.text.isEmpty) {
                      return _commonVaccines[_selectedVaccineType] ?? [];
                    }
                    final suggestions =
                        _commonVaccines[_selectedVaccineType] ?? [];
                    return suggestions.where((option) => option
                        .toLowerCase()
                        .contains(textEditingValue.text.toLowerCase()));
                  },
                  onSelected: (selection) {
                    _vaccineNameController.text = selection;
                  },
                  fieldViewBuilder:
                      (context, controller, focusNode, onEditingComplete) {
                    _vaccineNameController.text = controller.text;
                    return TextFormField(
                      controller: controller,
                      focusNode: focusNode,
                      decoration: const InputDecoration(
                        labelText: 'Название вакцины *',
                        hintText: 'Например: Раббивак V',
                        prefixIcon: Icon(Icons.vaccines),
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
              ],
            ),

            AppFormSection(
              title: 'Даты',
              children: [
                AppDateField(
                  label: 'Дата вакцинации *',
                  value: _vaccinationDate,
                  onChanged: (date) {
                    setState(() {
                      _vaccinationDate = date;
                      if (_nextVaccinationDate != null &&
                          _nextVaccinationDate!.isBefore(date)) {
                        _nextVaccinationDate = null;
                      }
                    });
                  },
                  prefixIcon: Icons.calendar_today,
                  lastDate: DateTime.now(),
                ),
                // Optional next vaccination date
                InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () => _selectNextVaccinationDate(context),
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: 'Следующая вакцинация',
                      prefixIcon: const Icon(Icons.event),
                      suffixIcon: _nextVaccinationDate != null
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () =>
                                  setState(() => _nextVaccinationDate = null),
                            )
                          : null,
                    ),
                    child: Text(
                      _nextVaccinationDate != null
                          ? DateFormat('dd.MM.yyyy').format(_nextVaccinationDate!)
                          : 'Не указана',
                      style: TextStyle(
                        color: _nextVaccinationDate != null
                            ? cs.onSurface
                            : cs.onSurfaceVariant,
                      ),
                    ),
                  ),
                ),
                Wrap(
                  spacing: 8,
                  children: [
                    _QuickDateButton(
                      label: '+3 мес',
                      onPressed: () => setState(() {
                        _nextVaccinationDate =
                            _vaccinationDate.add(const Duration(days: 90));
                      }),
                    ),
                    _QuickDateButton(
                      label: '+6 мес',
                      onPressed: () => setState(() {
                        _nextVaccinationDate =
                            _vaccinationDate.add(const Duration(days: 180));
                      }),
                    ),
                    _QuickDateButton(
                      label: '+1 год',
                      onPressed: () => setState(() {
                        _nextVaccinationDate =
                            _vaccinationDate.add(const Duration(days: 365));
                      }),
                    ),
                  ],
                ),
              ],
            ),

            AppFormSection(
              title: 'Дополнительно',
              children: [
                TextFormField(
                  controller: _batchNumberController,
                  decoration: const InputDecoration(
                    labelText: 'Номер партии',
                    hintText: 'Например: 12345-67',
                    prefixIcon: Icon(Icons.tag),
                  ),
                ),
                TextFormField(
                  controller: _veterinarianController,
                  decoration: const InputDecoration(
                    labelText: 'Ветеринар',
                    hintText: 'ФИО ветеринара',
                    prefixIcon: Icon(Icons.person_outline),
                  ),
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
              onPressed: _isSubmitting ? null : _submit,
              child: _isSubmitting
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(isEditing
                      ? 'Сохранить изменения'
                      : 'Добавить вакцинацию'),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _selectNextVaccinationDate(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      initialDate: _nextVaccinationDate ??
          _vaccinationDate.add(const Duration(days: 180)),
      firstDate: _vaccinationDate,
      lastDate: DateTime.now().add(const Duration(days: 730)),
    );
    if (date != null) setState(() => _nextVaccinationDate = date);
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

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
        ref.read(vaccinationsProvider.notifier).loadVaccinations();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.vaccination != null
                ? 'Вакцинация обновлена'
                : 'Вакцинация добавлена'),
          ),
        );
        context.pop();
      } else if (mounted) {
        final error = ref.read(vaccinationsProvider).error;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error ?? 'Ошибка сохранения'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }
}

/// Кнопка быстрого выбора срока следующей вакцинации
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
