import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/l10n/l10n_context.dart';
import '../../../../core/utils/format_utils.dart';
import '../../../../core/widgets/widgets.dart';
import '../../data/models/breed_model.dart';
import '../providers/breeds_provider.dart';
import '../utils/breed_labels.dart';

/// Карточка породы.
class BreedFormScreen extends ConsumerStatefulWidget {
  final BreedModel? breed;

  const BreedFormScreen({super.key, this.breed});

  @override
  ConsumerState<BreedFormScreen> createState() => _BreedFormScreenState();
}

class _BreedFormScreenState extends ConsumerState<BreedFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final _name = TextEditingController();
  final _description = TextEditingController();
  final _weight = TextEditingController();
  final _litterSize = TextEditingController();

  String? _purpose;
  bool _touched = false;

  BreedModel? get _breed => widget.breed;
  bool get _isEditing => _breed != null;

  @override
  void initState() {
    super.initState();
    final breed = _breed;
    _name.text = breed?.name ?? '';
    _description.text = breed?.description ?? '';
    _weight.text = breed?.averageWeight?.toString() ?? '';
    _litterSize.text = breed?.averageLitterSize?.toString() ?? '';
    _purpose = breed?.purpose;

    for (final c in [_name, _description, _weight, _litterSize]) {
      c.addListener(() => _touched = true);
    }
  }

  @override
  void dispose() {
    for (final c in [_name, _description, _weight, _litterSize]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<String?> _save() async {
    final failed = context.l10n.breedFormFailed;
    final notifier = ref.read(breedsProvider.notifier);

    final data = <String, dynamic>{
      'name': _name.text.trim(),
      if (_description.text.trim().isNotEmpty)
        'description': _description.text.trim(),
      if (_purpose != null) 'purpose': _purpose,
      if (parseDecimal(_weight.text) != null)
        'average_weight': parseDecimal(_weight.text),
      if (_litterSize.text.trim().isNotEmpty)
        'average_litter_size': int.parse(_litterSize.text.trim()),
    };

    final ok = _isEditing
        ? await notifier.updateBreed(_breed!.id, data)
        : await notifier.createBreed(data);

    if (ok) return null;
    return ref.read(breedsProvider).error ?? failed;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return AppFormScaffold(
      title: _isEditing ? l10n.breedFormEditTitle : l10n.breedFormNewTitle,
      formKey: _formKey,
      submitLabel: _isEditing ? l10n.commonSave : l10n.commonAdd,
      successMessage:
          _isEditing ? l10n.breedFormUpdated : l10n.breedFormCreated,
      onSubmit: _save,
      isDirty: () => _touched,
      children: [
        AppFormSection(
          title: l10n.feedFormSectionMain,
          children: [
            TextFormField(
              controller: _name,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                labelText: l10n.breedFormName,
                hintText: l10n.breedFormNameHint,
                prefixIcon: const Icon(Icons.label_outline),
              ),
              validator: (v) => (v == null || v.trim().isEmpty)
                  ? l10n.breedFormNameEmpty
                  : null,
            ),
            DropdownButtonFormField<String>(
              initialValue: _purpose,
              decoration: InputDecoration(
                labelText: l10n.breedFormPurpose,
                prefixIcon: const Icon(Icons.category_outlined),
              ),
              items: [
                for (final purpose in breedPurposes)
                  DropdownMenuItem(
                    value: purpose,
                    child: Text(breedPurposeLabel(context, purpose)),
                  ),
              ],
              onChanged: (v) => setState(() {
                _purpose = v;
                _touched = true;
              }),
            ),
            TextFormField(
              controller: _description,
              textCapitalization: TextCapitalization.sentences,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: l10n.breedFormDescription,
                hintText: l10n.breedFormDescriptionHint,
                prefixIcon: const Icon(Icons.notes),
              ),
            ),
          ],
        ),
        AppFormSection(
          title: l10n.breedFormSectionTraits,
          children: [
            TextFormField(
              controller: _weight,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: l10n.breedFormWeight,
                hintText: l10n.breedFormWeightHint,
                prefixIcon: const Icon(Icons.monitor_weight_outlined),
              ),
              validator: (v) {
                if (v == null || v.trim().isEmpty) return null;
                final value = parseDecimal(v);
                return (value == null || value <= 0)
                    ? l10n.commonNumberInvalid
                    : null;
              },
            ),
            TextFormField(
              controller: _litterSize,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                labelText: l10n.breedFormLitter,
                hintText: l10n.breedFormLitterHint,
                prefixIcon: const Icon(Icons.family_restroom),
                suffixText: l10n.breedFormLitterSuffix,
              ),
              validator: (v) {
                if (v == null || v.trim().isEmpty) return null;
                final value = int.tryParse(v.trim());
                return (value == null || value <= 0)
                    ? l10n.commonNumberInvalid
                    : null;
              },
            ),
          ],
        ),
      ],
    );
  }
}
