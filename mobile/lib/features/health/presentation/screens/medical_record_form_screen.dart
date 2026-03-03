import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../data/models/medical_record_model.dart';
import '../../../rabbits/presentation/providers/rabbits_provider.dart';
import '../providers/medical_records_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_date_field.dart';
import '../../../../core/widgets/app_form_section.dart';

class MedicalRecordFormScreen extends ConsumerStatefulWidget {
  final MedicalRecord? medicalRecord;

  const MedicalRecordFormScreen({super.key, this.medicalRecord});

  @override
  ConsumerState<MedicalRecordFormScreen> createState() =>
      _MedicalRecordFormScreenState();
}

class _MedicalRecordFormScreenState
    extends ConsumerState<MedicalRecordFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _symptomsController = TextEditingController();
  final _diagnosisController = TextEditingController();
  final _treatmentController = TextEditingController();
  final _medicationController = TextEditingController();
  final _dosageController = TextEditingController();
  final _costController = TextEditingController();
  final _veterinarianController = TextEditingController();
  final _notesController = TextEditingController();

  int? _selectedRabbitId;
  DateTime _startedAt = DateTime.now();
  DateTime? _endedAt;
  String _outcome = 'ongoing';

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.medicalRecord != null) {
      _loadMedicalRecord();
    }
  }

  void _loadMedicalRecord() {
    final record = widget.medicalRecord!;
    _selectedRabbitId = record.rabbitId;
    _symptomsController.text = record.symptoms;
    _diagnosisController.text = record.diagnosis ?? '';
    _treatmentController.text = record.treatment ?? '';
    _medicationController.text = record.medication ?? '';
    _dosageController.text = record.dosage ?? '';
    _startedAt = record.startedAt;
    _endedAt = record.endedAt;
    _outcome = record.outcome.name;
    _costController.text = record.cost?.toString() ?? '';
    _veterinarianController.text = record.veterinarian ?? '';
    _notesController.text = record.notes ?? '';
  }

  @override
  void dispose() {
    _symptomsController.dispose();
    _diagnosisController.dispose();
    _treatmentController.dispose();
    _medicationController.dispose();
    _dosageController.dispose();
    _costController.dispose();
    _veterinarianController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final rabbitsState = ref.watch(rabbitsListProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.medicalRecord == null
            ? 'Новая медицинская карта'
            : 'Редактировать карту'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
          children: [
            AppFormSection(
              title: 'Основное',
              children: [
                if (rabbitsState.isLoading)
                  const Center(child: CircularProgressIndicator())
                else if (rabbitsState.error != null)
                  Text('Ошибка загрузки кроликов: ${rabbitsState.error}',
                      style: TextStyle(color: Theme.of(context).colorScheme.error))
                else
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
                    onChanged: (value) => setState(() => _selectedRabbitId = value),
                    validator: (value) =>
                        value == null ? 'Выберите кролика' : null,
                  ),
                TextFormField(
                  controller: _symptomsController,
                  decoration: const InputDecoration(
                    labelText: 'Симптомы *',
                    prefixIcon: Icon(Icons.sick_outlined),
                  ),
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Введите симптомы';
                    }
                    return null;
                  },
                ),
                AppDateField(
                  label: 'Дата начала *',
                  value: _startedAt,
                  onChanged: (date) => setState(() => _startedAt = date),
                  prefixIcon: Icons.calendar_today,
                  lastDate: DateTime.now(),
                ),
              ],
            ),
            AppFormSection(
              title: 'Диагностика и лечение',
              children: [
                TextFormField(
                  controller: _diagnosisController,
                  decoration: const InputDecoration(
                    labelText: 'Диагноз',
                    prefixIcon: Icon(Icons.medical_information_outlined),
                  ),
                ),
                TextFormField(
                  controller: _treatmentController,
                  decoration: const InputDecoration(
                    labelText: 'Лечение',
                    prefixIcon: Icon(Icons.healing_outlined),
                  ),
                  maxLines: 3,
                ),
                TextFormField(
                  controller: _medicationController,
                  decoration: const InputDecoration(
                    labelText: 'Препараты',
                    prefixIcon: Icon(Icons.medication_outlined),
                  ),
                ),
                TextFormField(
                  controller: _dosageController,
                  decoration: const InputDecoration(
                    labelText: 'Дозировка',
                    prefixIcon: Icon(Icons.straighten),
                  ),
                ),
              ],
            ),
            AppFormSection(
              title: 'Дополнительно',
              children: [
                _buildEndedDateField(context),
                DropdownButtonFormField<String>(
                  value: _outcome,
                  decoration: const InputDecoration(
                    labelText: 'Исход',
                    prefixIcon: Icon(Icons.flag_outlined),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 'ongoing',
                      child: Text('Лечение продолжается'),
                    ),
                    DropdownMenuItem(
                      value: 'recovered',
                      child: Text('Выздоровел'),
                    ),
                    DropdownMenuItem(
                      value: 'died',
                      child: Text('Умер'),
                    ),
                    DropdownMenuItem(
                      value: 'euthanized',
                      child: Text('Эвтаназия'),
                    ),
                  ],
                  onChanged: (value) {
                    if (value != null) setState(() => _outcome = value);
                  },
                ),
                TextFormField(
                  controller: _costController,
                  decoration: const InputDecoration(
                    labelText: 'Стоимость (руб.)',
                    prefixIcon: Icon(Icons.payments_outlined),
                  ),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  validator: (value) {
                    if (value != null && value.isNotEmpty) {
                      if (double.tryParse(value) == null) {
                        return 'Введите корректное число';
                      }
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _veterinarianController,
                  decoration: const InputDecoration(
                    labelText: 'Ветеринар',
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
                    labelText: 'Примечания',
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
              onPressed: _isLoading ? null : _submitForm,
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(widget.medicalRecord == null ? 'Создать' : 'Сохранить'),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEndedDateField(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final dateText = _endedAt != null
        ? DateFormat('dd.MM.yyyy').format(_endedAt!)
        : 'Не указана';

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: _endedAt ?? DateTime.now(),
          firstDate: _startedAt,
          lastDate: DateTime.now(),
        );
        if (date != null && mounted) {
          setState(() => _endedAt = date);
        }
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: 'Дата окончания',
          prefixIcon: const Icon(Icons.calendar_month_outlined),
          suffixIcon: _endedAt != null
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () => setState(() => _endedAt = null),
                )
              : null,
        ),
        child: Text(
          dateText,
          style: TextStyle(color: cs.onSurface),
        ),
      ),
    );
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      if (widget.medicalRecord == null) {
        final record = MedicalRecordCreate(
          rabbitId: _selectedRabbitId!,
          symptoms: _symptomsController.text,
          diagnosis: _diagnosisController.text.isNotEmpty
              ? _diagnosisController.text
              : null,
          treatment: _treatmentController.text.isNotEmpty
              ? _treatmentController.text
              : null,
          medication: _medicationController.text.isNotEmpty
              ? _medicationController.text
              : null,
          dosage: _dosageController.text.isNotEmpty
              ? _dosageController.text
              : null,
          startedAt: _startedAt,
          endedAt: _endedAt,
          outcome: _outcome,
          cost: _costController.text.isNotEmpty
              ? double.parse(_costController.text)
              : null,
          veterinarian: _veterinarianController.text.isNotEmpty
              ? _veterinarianController.text
              : null,
          notes:
              _notesController.text.isNotEmpty ? _notesController.text : null,
        );

        await ref.read(medicalRecordsProvider.notifier).addMedicalRecord(record);
      } else {
        final update = MedicalRecordUpdate(
          rabbitId: _selectedRabbitId,
          symptoms: _symptomsController.text,
          diagnosis: _diagnosisController.text.isNotEmpty
              ? _diagnosisController.text
              : null,
          treatment: _treatmentController.text.isNotEmpty
              ? _treatmentController.text
              : null,
          medication: _medicationController.text.isNotEmpty
              ? _medicationController.text
              : null,
          dosage: _dosageController.text.isNotEmpty
              ? _dosageController.text
              : null,
          startedAt: _startedAt,
          endedAt: _endedAt,
          outcome: _outcome,
          cost: _costController.text.isNotEmpty
              ? double.parse(_costController.text)
              : null,
          veterinarian: _veterinarianController.text.isNotEmpty
              ? _veterinarianController.text
              : null,
          notes:
              _notesController.text.isNotEmpty ? _notesController.text : null,
        );

        await ref
            .read(medicalRecordsProvider.notifier)
            .updateMedicalRecord(widget.medicalRecord!.id, update);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.medicalRecord == null
                ? 'Медицинская карта создана'
                : 'Медицинская карта обновлена'),
          ),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ошибка: ${e.toString()}'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}
