import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/l10n/l10n_context.dart';
import '../../../../core/widgets/widgets.dart';
import '../../data/models/cage_model.dart';
import '../providers/cages_provider.dart';
import '../utils/cage_labels.dart';

/// Клетка: номер, тип, вместимость и состояние.
class CageFormScreen extends ConsumerStatefulWidget {
  final CageModel? cage;

  const CageFormScreen({super.key, this.cage});

  @override
  ConsumerState<CageFormScreen> createState() => _CageFormScreenState();
}

class _CageFormScreenState extends ConsumerState<CageFormScreen> {
  static const _types = ['single', 'group', 'maternity'];
  static const _conditions = ['good', 'needs_repair', 'broken'];

  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _number;
  late final TextEditingController _size;
  late final TextEditingController _capacity;
  late final TextEditingController _location;
  late final TextEditingController _notes;

  late String _type;
  late String _condition;
  bool _touched = false;

  /// Тип клетки — только подпись, вся логика занятости считается по числу
  /// мест. Из-за этого «Групповая» спокойно сохранялась с одним местом:
  /// подпись противоречила числу рядом с ней.
  void _typeChanged(String type) {
    final wasGroup = _type == 'group';
    _type = type;

    final places = int.tryParse(_capacity.text.trim()) ?? 0;
    if (type == 'group' && places < 2) {
      _capacity.text = '4';
    } else if (wasGroup && type != 'group' && places > 1) {
      _capacity.text = '1';
    }
  }

  CageModel? get _cage => widget.cage;
  bool get _isEditing => _cage != null;

  @override
  void initState() {
    super.initState();
    _number = TextEditingController(text: _cage?.number ?? '');
    _size = TextEditingController(text: _cage?.size ?? '');
    _capacity = TextEditingController(text: _cage?.capacity.toString() ?? '1');
    _location = TextEditingController(text: _cage?.location ?? '');
    _notes = TextEditingController(text: _cage?.notes ?? '');

    _type = _cage?.type ?? 'single';
    _condition = _cage?.condition ?? 'good';

    for (final c in _controllers) {
      c.addListener(() => _touched = true);
    }
  }

  List<TextEditingController> get _controllers =>
      [_number, _size, _capacity, _location, _notes];

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  Future<Object?> _save() async {
    final notifier = ref.read(cagesProvider.notifier);

    final data = <String, dynamic>{
      'number': _number.text.trim(),
      'type': _type,
      'capacity': int.parse(_capacity.text.trim()),
      'condition': _condition,
      if (_size.text.trim().isNotEmpty) 'size': _size.text.trim(),
      if (_location.text.trim().isNotEmpty) 'location': _location.text.trim(),
      if (_notes.text.trim().isNotEmpty) 'notes': _notes.text.trim(),
    };

    final ok = _isEditing
        ? await notifier.updateCage(_cage!.id, data)
        : await notifier.createCage(data);

    if (ok) return null;
    return ref.read(cagesProvider).error;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return AppFormScaffold(
      title: _isEditing ? l10n.cageFormEditTitle : l10n.cageFormNewTitle,
      formKey: _formKey,
      submitLabel: _isEditing ? l10n.commonSave : l10n.commonAdd,
      successMessage:
          _isEditing ? l10n.cageFormUpdated : l10n.cageFormCreated,
      onSubmit: _save,
      isDirty: () => _touched,
      children: [
        AppFormSection(
          title: l10n.commonSectionMain,
          children: [
            TextFormField(
              controller: _number,
              textCapitalization: TextCapitalization.characters,
              decoration: InputDecoration(
                labelText: l10n.cageFormNumber,
                prefixIcon: const Icon(Icons.tag),
              ),
              validator: (v) => (v == null || v.trim().isEmpty)
                  ? l10n.cageFormNumberEmpty
                  : null,
            ),
            DropdownButtonFormField<String>(
              initialValue: _type,
              decoration: InputDecoration(
                labelText: l10n.cageFormType,
                prefixIcon: Icon(cageTypeIcon(_type)),
              ),
              items: [
                for (final type in _types)
                  DropdownMenuItem(
                    value: type,
                    child: Text(cageTypeLabel(context, type)),
                  ),
              ],
              onChanged: (v) => setState(() {
                if (v != null) _typeChanged(v);
                _touched = true;
              }),
            ),
            TextFormField(
              controller: _capacity,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                labelText: l10n.cageFormCapacity,
                prefixIcon: const Icon(Icons.groups_outlined),
              ),
              validator: (v) {
                final value = int.tryParse(v?.trim() ?? '');
                if (value == null || value <= 0) {
                  return l10n.cageFormCapacityInvalid;
                }
                if (_type == 'group' && value < 2) {
                  return l10n.cageFormCapacityGroup;
                }
                return null;
              },
            ),
            DropdownButtonFormField<String>(
              initialValue: _condition,
              decoration: InputDecoration(
                labelText: l10n.cagesFilterCondition,
                prefixIcon: const Icon(Icons.handyman_outlined),
              ),
              items: [
                for (final condition in _conditions)
                  DropdownMenuItem(
                    value: condition,
                    child: Text(cageConditionLabel(context, condition)),
                  ),
              ],
              onChanged: (v) => setState(() {
                if (v != null) _condition = v;
                _touched = true;
              }),
            ),
          ],
        ),
        AppFormSection(
          title: l10n.commonSectionDetails,
          children: [
            TextFormField(
              controller: _size,
              decoration: InputDecoration(
                labelText: l10n.cageFormSize,
                hintText: l10n.cageFormSizeHint,
                prefixIcon: const Icon(Icons.straighten),
              ),
            ),
            TextFormField(
              controller: _location,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                labelText: l10n.cageFormLocation,
                hintText: l10n.cageFormLocationHint,
                prefixIcon: const Icon(Icons.place_outlined),
              ),
            ),
            TextFormField(
              controller: _notes,
              textCapitalization: TextCapitalization.sentences,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: l10n.cageFormNotes,
                prefixIcon: const Icon(Icons.sticky_note_2_outlined),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
