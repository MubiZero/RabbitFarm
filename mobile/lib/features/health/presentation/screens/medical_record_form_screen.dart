import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/l10n/l10n_context.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/utils/format_utils.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../rabbits/data/models/rabbit_model.dart';
import '../../../rabbits/presentation/widgets/rabbit_picker.dart';
import '../../data/models/medical_record_model.dart';
import '../providers/medical_records_provider.dart';
import '../utils/medical_labels.dart';

/// Карта лечения: что случилось, чем лечили, чем закончилось.
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

  final _symptoms = TextEditingController();
  final _diagnosis = TextEditingController();
  final _treatment = TextEditingController();
  final _medication = TextEditingController();
  final _dosage = TextEditingController();
  final _cost = TextEditingController();
  final _veterinarian = TextEditingController();
  final _notes = TextEditingController();

  RabbitModel? _rabbit;
  int? _rabbitId;
  DateTime _startedAt = DateTime.now();
  DateTime? _endedAt;
  MedicalOutcome _outcome = MedicalOutcome.ongoing;
  bool _touched = false;

  MedicalRecord? get _record => widget.medicalRecord;
  bool get _isEditing => _record != null;

  @override
  void initState() {
    super.initState();
    final record = _record;
    if (record != null) {
      _rabbitId = record.rabbitId;
      _rabbit = record.rabbit;
      _symptoms.text = record.symptoms;
      _diagnosis.text = record.diagnosis ?? '';
      _treatment.text = record.treatment ?? '';
      _medication.text = record.medication ?? '';
      _dosage.text = record.dosage ?? '';
      _cost.text = record.cost?.toString() ?? '';
      _veterinarian.text = record.veterinarian ?? '';
      _notes.text = record.notes ?? '';
      _startedAt = record.startedAt;
      _endedAt = record.endedAt;
      _outcome = record.outcome;
    }

    for (final c in _controllers) {
      c.addListener(() => _touched = true);
    }
  }

  List<TextEditingController> get _controllers => [
        _symptoms,
        _diagnosis,
        _treatment,
        _medication,
        _dosage,
        _cost,
        _veterinarian,
        _notes,
      ];

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  String? _optional(TextEditingController c) =>
      c.text.trim().isEmpty ? null : c.text.trim();

  Future<Object?> _save() async {
    final noRabbit = context.l10n.rabbitPickerRequired;
    if (_rabbitId == null) return noRabbit;

    final notifier = ref.read(medicalRecordsProvider.notifier);
    final outcome = medicalOutcomeValue(_outcome);
    final cost = parseDecimal(_cost.text);

    try {
      if (_isEditing) {
        await notifier.updateMedicalRecord(
          _record!.id,
          MedicalRecordUpdate(
            rabbitId: _rabbitId,
            symptoms: _symptoms.text.trim(),
            diagnosis: _optional(_diagnosis),
            treatment: _optional(_treatment),
            medication: _optional(_medication),
            dosage: _optional(_dosage),
            startedAt: _startedAt,
            endedAt: _endedAt,
            outcome: outcome,
            cost: cost,
            veterinarian: _optional(_veterinarian),
            notes: _optional(_notes),
          ),
        );
      } else {
        await notifier.addMedicalRecord(
          MedicalRecordCreate(
            rabbitId: _rabbitId!,
            symptoms: _symptoms.text.trim(),
            diagnosis: _optional(_diagnosis),
            treatment: _optional(_treatment),
            medication: _optional(_medication),
            dosage: _optional(_dosage),
            startedAt: _startedAt,
            endedAt: _endedAt,
            outcome: outcome,
            cost: cost,
            veterinarian: _optional(_veterinarian),
            notes: _optional(_notes),
          ),
        );
      }
      return null;
    } catch (e) {
      return e;
    }
  }

  Future<void> _pickEndDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _endedAt ?? DateTime.now(),
      firstDate: _startedAt,
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _endedAt = picked;
        _touched = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return AppFormScaffold(
      title: _isEditing ? l10n.medFormEditTitle : l10n.medFormNewTitle,
      formKey: _formKey,
      submitLabel: _isEditing ? l10n.commonSave : l10n.commonAdd,
      successMessage: _isEditing ? l10n.medFormUpdated : l10n.medFormCreated,
      onSubmit: _save,
      isDirty: () => _touched,
      children: [
        AppFormSection(
          title: l10n.medFormSectionCase,
          children: [
            RabbitPickerField(
              label: l10n.medFormRabbit,
              selected: _rabbit,
              required: true,
              onChanged: (rabbit) => setState(() {
                _rabbit = rabbit;
                _rabbitId = rabbit?.id;
                _touched = true;
              }),
            ),
            TextFormField(
              controller: _symptoms,
              textCapitalization: TextCapitalization.sentences,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: l10n.medSymptoms,
                prefixIcon: const Icon(Icons.sick_outlined),
              ),
              validator: (v) => (v == null || v.trim().isEmpty)
                  ? l10n.medFormSymptomsEmpty
                  : null,
            ),
            TextFormField(
              controller: _diagnosis,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                labelText: l10n.medDiagnosis,
                prefixIcon: const Icon(Icons.medical_information_outlined),
              ),
            ),
          ],
        ),
        AppFormSection(
          title: l10n.medFormSectionTreatment,
          children: [
            TextFormField(
              controller: _treatment,
              textCapitalization: TextCapitalization.sentences,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: l10n.medTreatment,
                prefixIcon: const Icon(Icons.healing_outlined),
              ),
            ),
            TextFormField(
              controller: _medication,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                labelText: l10n.medMedication,
                prefixIcon: const Icon(Icons.medication_outlined),
              ),
            ),
            TextFormField(
              controller: _dosage,
              decoration: InputDecoration(
                labelText: l10n.medFormDosage,
                prefixIcon: const Icon(Icons.straighten),
              ),
            ),
            TextFormField(
              controller: _veterinarian,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(
                labelText: l10n.medVet,
                prefixIcon: const Icon(Icons.person_outline),
              ),
            ),
          ],
        ),
        AppFormSection(
          title: l10n.medFormSectionDates,
          children: [
            AppDateField(
              label: l10n.medStarted,
              value: _startedAt,
              onChanged: (date) => setState(() {
                _startedAt = date;
                _touched = true;
                if (_endedAt != null && _endedAt!.isBefore(date)) {
                  _endedAt = null;
                }
              }),
              prefixIcon: Icons.event_available_outlined,
              lastDate: DateTime.now(),
            ),
            InkWell(
              borderRadius: AppRadius.mdAll,
              onTap: _pickEndDate,
              child: InputDecorator(
                isEmpty: _endedAt == null,
                decoration: InputDecoration(
                  labelText: l10n.medFormEndedDate,
                  prefixIcon: const Icon(Icons.event_outlined),
                  suffixIcon: _endedAt != null
                      ? IconButton(
                          tooltip: l10n.rabbitPickerClear,
                          icon: const Icon(Icons.clear),
                          onPressed: () => setState(() {
                            _endedAt = null;
                            _touched = true;
                          }),
                        )
                      : const Icon(Icons.arrow_drop_down),
                ),
                child: _endedAt == null
                    ? null
                    : Text(
                        DateFormat('d MMMM y', 'ru').format(_endedAt!),
                        style: AppTypography.bodyLg
                            .copyWith(color: context.colors.onSurface),
                      ),
              ),
            ),
            DropdownButtonFormField<MedicalOutcome>(
              initialValue: _outcome,
              decoration: InputDecoration(
                labelText: l10n.medFormOutcome,
                prefixIcon: Icon(medicalOutcomeIcon(_outcome)),
              ),
              items: [
                for (final outcome in MedicalOutcome.values)
                  DropdownMenuItem(
                    value: outcome,
                    child: Text(medicalOutcomeLabel(context, outcome)),
                  ),
              ],
              onChanged: (v) => setState(() {
                if (v != null) _outcome = v;
                _touched = true;
              }),
            ),
            TextFormField(
              controller: _cost,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: l10n.medFormCostLabel,
                prefixIcon: const Icon(Icons.payments_outlined),
                // Сумма не просто хранится в карте: сервер заводит на неё
                // расход. Пользователь должен знать об этом до сохранения.
                helperText: l10n.medFormCostHelp,
                helperMaxLines: 2,
              ),
              validator: (v) {
                if (v == null || v.trim().isEmpty) return null;
                return parseDecimal(v) == null
                    ? l10n.commonNumberInvalid
                    : null;
              },
            ),
            TextFormField(
              controller: _notes,
              textCapitalization: TextCapitalization.sentences,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: l10n.medNotes,
                prefixIcon: const Icon(Icons.sticky_note_2_outlined),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
