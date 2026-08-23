import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/l10n/l10n_context.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../rabbits/data/models/rabbit_model.dart';
import '../../../rabbits/presentation/widgets/rabbit_picker.dart';
import '../../data/models/vaccination_model.dart';
import '../providers/vaccinations_provider.dart';

/// Форма записи о прививке.
class VaccinationFormScreen extends ConsumerStatefulWidget {
  final Vaccination? vaccination;
  final RabbitModel? rabbit;

  const VaccinationFormScreen({super.key, this.vaccination, this.rabbit});

  @override
  ConsumerState<VaccinationFormScreen> createState() =>
      _VaccinationFormScreenState();
}

class _VaccinationFormScreenState
    extends ConsumerState<VaccinationFormScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _vaccineName;
  late final TextEditingController _batchNumber;
  late final TextEditingController _veterinarian;
  late final TextEditingController _notes;

  RabbitModel? _rabbit;
  int? _rabbitId;
  late VaccineType _type;
  late DateTime _date;
  DateTime? _nextDate;
  bool _touched = false;

  /// Названия, которые чаще всего встречаются на российских фермах. Это
  /// подсказки, а не список: своё название можно ввести целиком.
  static const _commonVaccines = <VaccineType, List<String>>{
    VaccineType.vhd: ['Раббивак V', 'Песторин', 'ВГБК вакцина'],
    VaccineType.myxomatosis: ['Раббивак B', 'Лапимун Микс'],
    VaccineType.pasteurellosis: ['Пастовак', 'Песторин Mormyx'],
    VaccineType.other: [],
  };

  Vaccination? get _record => widget.vaccination;
  bool get _isEditing => _record != null;

  @override
  void initState() {
    super.initState();
    _vaccineName = TextEditingController(text: _record?.vaccineName ?? '');
    _batchNumber = TextEditingController(text: _record?.batchNumber ?? '');
    _veterinarian = TextEditingController(text: _record?.veterinarian ?? '');
    _notes = TextEditingController(text: _record?.notes ?? '');

    _type = _record?.vaccineType ?? VaccineType.vhd;
    _date = _record?.vaccinationDate ?? DateTime.now();
    _nextDate = _record?.nextVaccinationDate;
    _rabbit = widget.rabbit;
    _rabbitId = _record?.rabbitId ?? widget.rabbit?.id;

    for (final c in [_vaccineName, _batchNumber, _veterinarian, _notes]) {
      c.addListener(() => _touched = true);
    }
  }

  @override
  void dispose() {
    _vaccineName.dispose();
    _batchNumber.dispose();
    _veterinarian.dispose();
    _notes.dispose();
    super.dispose();
  }

  String? _optional(TextEditingController c) =>
      c.text.trim().isEmpty ? null : c.text.trim();

  Future<String?> _save() async {
    // Тексты снимаются до ожидания: экран может закрыться, пока идёт запрос.
    final noRabbit = context.l10n.rabbitPickerRequired;
    final failed = context.l10n.vaccFormFailed;
    if (_rabbitId == null) return noRabbit;

    final notifier = ref.read(vaccinationsProvider.notifier);
    final request = VaccinationRequest(
      rabbitId: _rabbitId!,
      vaccineName: _vaccineName.text.trim(),
      vaccineType: _type,
      vaccinationDate: _date,
      nextVaccinationDate: _nextDate,
      batchNumber: _optional(_batchNumber),
      veterinarian: _optional(_veterinarian),
      notes: _optional(_notes),
    );

    final ok = _isEditing
        ? await notifier.updateVaccination(_record!.id, request)
        : await notifier.createVaccination(request);

    if (ok) return null;
    return ref.read(vaccinationsProvider).error ?? failed;
  }

  Future<void> _pickNextDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _nextDate ?? _date.add(const Duration(days: 180)),
      firstDate: _date,
      lastDate: DateTime.now().add(const Duration(days: 1095)),
    );
    if (picked != null) {
      setState(() {
        _nextDate = picked;
        _touched = true;
      });
    }
  }

  void _setNextIn(Duration offset) => setState(() {
        _nextDate = _date.add(offset);
        _touched = true;
      });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final format = DateFormat('d MMMM y', 'ru');

    return AppFormScaffold(
      title: _isEditing ? l10n.vaccFormEditTitle : l10n.vaccFormNewTitle,
      formKey: _formKey,
      submitLabel: _isEditing ? l10n.commonSave : l10n.commonAdd,
      successMessage:
          _isEditing ? l10n.vaccFormUpdated : l10n.vaccFormCreated,
      onSubmit: _save,
      isDirty: () => _touched,
      children: [
        AppFormSection(
          title: l10n.vaccFormSectionMain,
          children: [
            // Кролик выбирается через поиск на сервере: раньше в списке были
            // только те, кто успел подгрузиться на первую страницу.
            RabbitPickerField(
              label: l10n.vaccFormRabbit,
              selected: _rabbit,
              required: true,
              // При правке запись уже привязана к кролику — менять эту связь
              // нельзя, иначе прививка «переедет» к другому животному.
              enabled: !_isEditing,
              onChanged: (rabbit) => setState(() {
                _rabbit = rabbit;
                _rabbitId = rabbit?.id;
                _touched = true;
              }),
            ),
            DropdownButtonFormField<VaccineType>(
              initialValue: _type,
              decoration: InputDecoration(
                labelText: l10n.vaccFormType,
                prefixIcon: const Icon(Icons.category_outlined),
              ),
              items: [
                for (final type in VaccineType.values)
                  DropdownMenuItem(value: type, child: Text(type.fullName)),
              ],
              onChanged: (value) {
                if (value == null) return;
                setState(() {
                  _type = value;
                  _touched = true;
                  final suggestions = _commonVaccines[value] ?? const [];
                  if (_vaccineName.text.trim().isEmpty &&
                      suggestions.isNotEmpty) {
                    _vaccineName.text = suggestions.first;
                  }
                });
              },
            ),
            TextFormField(
              controller: _vaccineName,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                labelText: l10n.vaccFormName,
                hintText: l10n.vaccFormNameHint,
                prefixIcon: const Icon(Icons.vaccines_outlined),
              ),
              validator: (v) => (v == null || v.trim().isEmpty)
                  ? l10n.vaccFormNameEmpty
                  : null,
            ),
            if ((_commonVaccines[_type] ?? const []).isNotEmpty)
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: [
                  for (final name in _commonVaccines[_type]!)
                    ActionChip(
                      label: Text(name),
                      onPressed: () => setState(() {
                        _vaccineName.text = name;
                        _touched = true;
                      }),
                    ),
                ],
              ),
          ],
        ),
        AppFormSection(
          title: l10n.vaccFormSectionDates,
          children: [
            AppDateField(
              label: l10n.vaccFormDate,
              value: _date,
              onChanged: (date) => setState(() {
                _date = date;
                _touched = true;
                if (_nextDate != null && _nextDate!.isBefore(date)) {
                  _nextDate = null;
                }
              }),
              prefixIcon: Icons.event_available_outlined,
              lastDate: DateTime.now(),
            ),
            InkWell(
              borderRadius: AppRadius.mdAll,
              onTap: _pickNextDate,
              child: InputDecorator(
                isEmpty: _nextDate == null,
                decoration: InputDecoration(
                  labelText: l10n.vaccFormNextDate,
                  prefixIcon: const Icon(Icons.event_outlined),
                  suffixIcon: _nextDate != null
                      ? IconButton(
                          tooltip: l10n.rabbitPickerClear,
                          icon: const Icon(Icons.clear),
                          onPressed: () => setState(() {
                            _nextDate = null;
                            _touched = true;
                          }),
                        )
                      : const Icon(Icons.arrow_drop_down),
                ),
                child: _nextDate == null
                    ? null
                    : Text(
                        format.format(_nextDate!),
                        style: AppTypography.bodyLg
                            .copyWith(color: context.colors.onSurface),
                      ),
              ),
            ),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: [
                ActionChip(
                  label: Text(l10n.vaccFormPlus3m),
                  onPressed: () => _setNextIn(const Duration(days: 90)),
                ),
                ActionChip(
                  label: Text(l10n.vaccFormPlus6m),
                  onPressed: () => _setNextIn(const Duration(days: 180)),
                ),
                ActionChip(
                  label: Text(l10n.vaccFormPlus1y),
                  onPressed: () => _setNextIn(const Duration(days: 365)),
                ),
              ],
            ),
          ],
        ),
        AppFormSection(
          title: l10n.vaccFormSectionExtra,
          children: [
            TextFormField(
              controller: _batchNumber,
              decoration: InputDecoration(
                labelText: l10n.vaccFormBatch,
                hintText: l10n.vaccFormBatchHint,
                prefixIcon: const Icon(Icons.tag),
              ),
            ),
            TextFormField(
              controller: _veterinarian,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(
                labelText: l10n.vaccFormVet,
                hintText: l10n.vaccFormVetHint,
                prefixIcon: const Icon(Icons.person_outline),
              ),
            ),
            TextFormField(
              controller: _notes,
              textCapitalization: TextCapitalization.sentences,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: l10n.vaccFormNotes,
                prefixIcon: const Icon(Icons.sticky_note_2_outlined),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
