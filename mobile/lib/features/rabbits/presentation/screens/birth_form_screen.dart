import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/l10n/l10n_context.dart';
import '../../../../core/widgets/widgets.dart';
import '../../data/models/birth_model.dart';
import '../../data/models/breeding_model.dart';
import '../../data/models/rabbit_model.dart';
import '../providers/births_provider.dart';
import '../widgets/create_kits_dialog.dart';
import '../widgets/rabbit_picker.dart';

/// Запись об окроле.
class BirthFormScreen extends ConsumerStatefulWidget {
  final BirthModel? birth;
  final BreedingModel? breeding;

  const BirthFormScreen({super.key, this.birth, this.breeding});

  @override
  ConsumerState<BirthFormScreen> createState() => _BirthFormScreenState();
}

class _BirthFormScreenState extends ConsumerState<BirthFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final _alive = TextEditingController();
  final _dead = TextEditingController();
  final _complications = TextEditingController();
  final _notes = TextEditingController();

  RabbitModel? _mother;
  int? _motherId;
  late DateTime _birthDate;
  bool _createKits = true;
  bool _touched = false;

  BirthModel? get _record => widget.birth;
  bool get _isEditing => _record != null;

  @override
  void initState() {
    super.initState();
    final record = _record;
    _alive.text = record?.kitsBornAlive.toString() ?? '';
    _dead.text = record?.kitsBornDead.toString() ?? '';
    _complications.text = record?.complications ?? '';
    _notes.text = record?.notes ?? '';

    _mother = record?.mother ?? widget.breeding?.female;
    _motherId = record?.motherId ?? widget.breeding?.femaleId;
    _birthDate = record?.birthDate != null
        ? DateTime.tryParse(record!.birthDate) ?? DateTime.now()
        : DateTime.now();

    for (final c in [_alive, _dead, _complications, _notes]) {
      c.addListener(() => _touched = true);
    }
  }

  @override
  void dispose() {
    for (final c in [_alive, _dead, _complications, _notes]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<String?> _save() async {
    final noMother = context.l10n.rabbitPickerRequired;
    final failed = context.l10n.birthFormFailed;
    if (_motherId == null) return noMother;

    final notifier = ref.read(birthsProvider.notifier);
    final breedingId = widget.breeding?.id ?? _record?.breedingId;

    final data = <String, dynamic>{
      'mother_id': _motherId,
      if (breedingId != null) 'breeding_id': breedingId,
      'birth_date': _birthDate.toIso8601String().split('T').first,
      'kits_born_alive': int.parse(_alive.text.trim()),
      'kits_born_dead':
          _dead.text.trim().isEmpty ? 0 : int.parse(_dead.text.trim()),
      if (_complications.text.trim().isNotEmpty)
        'complications': _complications.text.trim(),
      if (_notes.text.trim().isNotEmpty) 'notes': _notes.text.trim(),
    };

    if (_isEditing) {
      final ok = await notifier.updateBirth(_record!.id, data);
      if (!ok) return ref.read(birthsProvider).error ?? failed;
      await notifier.loadBirths();
      return null;
    }

    final created = await notifier.createBirth(data);
    if (created == null) return ref.read(birthsProvider).error ?? failed;
    await notifier.loadBirths();

    // Карточки крольчат заводятся тем же общим диалогом, что и из списка
    // окролов: раньше здесь лежала его вторая копия.
    if (_createKits && created.kitsBornAlive > 0 && mounted) {
      await showDialog<bool>(
        context: context,
        builder: (_) => CreateKitsDialog(
          birth: created,
          defaultPrefix: _mother == null ? '' : '${_mother!.name}-',
          breedId: _mother?.breedId,
        ),
      );
    }
    return null;
  }

  String? _validateCount(String? value, {required bool required}) {
    final l10n = context.l10n;
    if (value == null || value.trim().isEmpty) {
      return required ? l10n.birthFormAliveEmpty : null;
    }
    return int.tryParse(value.trim()) == null ? l10n.commonNumberInvalid : null;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return AppFormScaffold(
      title: _isEditing ? l10n.birthFormEditTitle : l10n.birthFormNewTitle,
      formKey: _formKey,
      submitLabel: _isEditing ? l10n.commonSave : l10n.commonAdd,
      successMessage: _isEditing ? l10n.birthFormUpdated : l10n.birthFormCreated,
      onSubmit: _save,
      isDirty: () => _touched,
      children: [
        AppFormSection(
          title: l10n.commonSectionMain,
          children: [
            RabbitPickerField(
              label: l10n.birthFormMother,
              icon: Icons.female,
              sex: 'female',
              selected: _mother,
              required: true,
              // Мать окрола менять нельзя: запись уже привязана к животному,
              // и подмена превратила бы её в чужую историю.
              enabled: !_isEditing,
              onChanged: (rabbit) => setState(() {
                _mother = rabbit;
                _motherId = rabbit?.id;
                _touched = true;
              }),
            ),
            AppDateField(
              label: l10n.birthFormDate,
              value: _birthDate,
              onChanged: (date) => setState(() {
                _birthDate = date;
                _touched = true;
              }),
              prefixIcon: Icons.event_outlined,
              lastDate: DateTime.now(),
            ),
          ],
        ),
        AppFormSection(
          title: l10n.birthFormSectionLitter,
          children: [
            TextFormField(
              controller: _alive,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                labelText: l10n.birthFormAliveLabel,
                prefixIcon: const Icon(Icons.child_care_outlined),
              ),
              validator: (v) => _validateCount(v, required: true),
            ),
            TextFormField(
              controller: _dead,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                labelText: l10n.birthFormDeadLabel,
                prefixIcon: const Icon(Icons.remove_circle_outline),
              ),
              validator: (v) => _validateCount(v, required: false),
            ),
            if (!_isEditing)
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(l10n.birthFormAutoKits),
                value: _createKits,
                onChanged: (v) => setState(() {
                  _createKits = v;
                  _touched = true;
                }),
              ),
          ],
        ),
        AppFormSection(
          title: l10n.commonSectionDetails,
          children: [
            TextFormField(
              controller: _complications,
              textCapitalization: TextCapitalization.sentences,
              maxLines: 2,
              decoration: InputDecoration(
                labelText: l10n.birthFormComplications,
                hintText: l10n.birthFormComplicationsHint,
                prefixIcon: const Icon(Icons.warning_amber_outlined),
              ),
            ),
            TextFormField(
              controller: _notes,
              textCapitalization: TextCapitalization.sentences,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: l10n.birthFormNotes,
                prefixIcon: const Icon(Icons.sticky_note_2_outlined),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
