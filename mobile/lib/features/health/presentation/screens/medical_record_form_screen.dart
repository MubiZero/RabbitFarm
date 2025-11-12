import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../data/models/medical_record_model.dart';
import '../../../rabbits/presentation/providers/rabbits_provider.dart';
import '../providers/medical_records_provider.dart';

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
          padding: const EdgeInsets.all(16),
          children: [
            // Rabbit selection
            rabbitsState.isLoading
                ? const Center(child: CircularProgressIndicator())
                : rabbitsState.error != null
                    ? Text('Ошибка загрузки кроликов: ${rabbitsState.error}')
                    : DropdownButtonFormField<int>(
                        value: _selectedRabbitId,
                        decoration: const InputDecoration(
                          labelText: 'Кролик *',
                          border: OutlineInputBorder(),
                        ),
                        items: rabbitsState.rabbits.map((rabbit) {
                          return DropdownMenuItem(
                            value: rabbit.id,
                            child: Text('${rabbit.name} (${rabbit.tagId ?? ''})'),
                          );
                        }).toList(),
                        onChanged: (value) {
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

            // Symptoms
            TextFormField(
              controller: _symptomsController,
              decoration: const InputDecoration(
                labelText: 'Симптомы *',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Введите симптомы';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Diagnosis
            TextFormField(
              controller: _diagnosisController,
              decoration: const InputDecoration(
                labelText: 'Диагноз',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Treatment
            TextFormField(
              controller: _treatmentController,
              decoration: const InputDecoration(
                labelText: 'Лечение',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),

            // Medication
            TextFormField(
              controller: _medicationController,
              decoration: const InputDecoration(
                labelText: 'Препараты',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Dosage
            TextFormField(
              controller: _dosageController,
              decoration: const InputDecoration(
                labelText: 'Дозировка',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Started date
            ListTile(
              title: const Text('Дата начала *'),
              subtitle: Text(DateFormat('dd.MM.yyyy').format(_startedAt)),
              trailing: const Icon(Icons.calendar_today),
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: _startedAt,
                  firstDate: DateTime(2020),
                  lastDate: DateTime.now(),
                );
                if (date != null) {
                  setState(() {
                    _startedAt = date;
                  });
                }
              },
            ),

            // Ended date
            ListTile(
              title: const Text('Дата окончания'),
              subtitle: Text(_endedAt != null
                  ? DateFormat('dd.MM.yyyy').format(_endedAt!)
                  : 'Не указана'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_endedAt != null)
                    IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        setState(() {
                          _endedAt = null;
                        });
                      },
                    ),
                  const Icon(Icons.calendar_today),
                ],
              ),
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: _endedAt ?? DateTime.now(),
                  firstDate: _startedAt,
                  lastDate: DateTime.now(),
                );
                if (date != null) {
                  setState(() {
                    _endedAt = date;
                  });
                }
              },
            ),
            const SizedBox(height: 16),

            // Outcome
            DropdownButtonFormField<String>(
              value: _outcome,
              decoration: const InputDecoration(
                labelText: 'Исход',
                border: OutlineInputBorder(),
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
                if (value != null) {
                  setState(() {
                    _outcome = value;
                  });
                }
              },
            ),
            const SizedBox(height: 16),

            // Cost
            TextFormField(
              controller: _costController,
              decoration: const InputDecoration(
                labelText: 'Стоимость (руб.)',
                border: OutlineInputBorder(),
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
            const SizedBox(height: 16),

            // Veterinarian
            TextFormField(
              controller: _veterinarianController,
              decoration: const InputDecoration(
                labelText: 'Ветеринар',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Notes
            TextFormField(
              controller: _notesController,
              decoration: const InputDecoration(
                labelText: 'Примечания',
                border: OutlineInputBorder(),
              ),
              maxLines: 4,
            ),
            const SizedBox(height: 24),

            // Submit button
            ElevatedButton(
              onPressed: _isLoading ? null : _submitForm,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
              ),
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : Text(widget.medicalRecord == null
                      ? 'Создать'
                      : 'Сохранить'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      if (widget.medicalRecord == null) {
        // Create new record
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
        // Update existing record
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
            backgroundColor: Colors.green,
          ),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ошибка: ${e.toString()}'),
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
}
