import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/l10n/l10n_context.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../rabbits/data/models/breeding_model.dart';
import '../../../rabbits/data/models/rabbit_model.dart';
import '../../../rabbits/presentation/widgets/rabbit_picker.dart';
import '../providers/breeding_provider.dart';

/// Запись о случке.
class BreedingFormScreen extends ConsumerStatefulWidget {
  final Map<String, dynamic>? initialData;
  final BreedingModel? breeding;

  const BreedingFormScreen({super.key, this.initialData, this.breeding});

  @override
  ConsumerState<BreedingFormScreen> createState() => _BreedingFormScreenState();
}

class _BreedingFormScreenState extends ConsumerState<BreedingFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _notes = TextEditingController();

  RabbitModel? _male;
  RabbitModel? _female;
  int? _maleId;
  int? _femaleId;
  late DateTime _breedingDate;
  late String _status;
  bool _touched = false;

  BreedingModel? get _record => widget.breeding;
  bool get _isEditing => _record != null;
  bool get _fromPlanner => widget.initialData?['analysis'] != null;

  @override
  void initState() {
    super.initState();
    final record = _record;
    if (record != null) {
      _maleId = record.maleId;
      _femaleId = record.femaleId;
      _male = record.male;
      _female = record.female;
      _breedingDate =
          DateTime.tryParse(record.breedingDate) ?? DateTime.now();
      _status = record.status;
      _notes.text = record.notes ?? '';
    } else {
      _maleId = widget.initialData?['male_id'] as int?;
      _femaleId = widget.initialData?['female_id'] as int?;
      _breedingDate = DateTime.now();
      _status = 'planned';
    }
    _notes.addListener(() => _touched = true);
  }

  @override
  void dispose() {
    _notes.dispose();
    super.dispose();
  }

  Future<String?> _save() async {
    final l10n = context.l10n;
    if (_maleId == null) return l10n.breedingFormMaleRequired;
    if (_femaleId == null) return l10n.breedingFormFemaleRequired;
    final failed = l10n.breedingFormFailed;

    final repository = ref.read(breedingRepositoryProvider);
    final data = <String, dynamic>{
      'male_id': _maleId,
      'female_id': _femaleId,
      'breeding_date': _breedingDate.toIso8601String().split('T').first,
      'status': _status,
      'notes': _notes.text.trim().isEmpty ? null : _notes.text.trim(),
    };

    try {
      if (_isEditing) {
        await repository.updateBreeding(_record!.id, data);
        ref.invalidate(breedingDetailProvider(_record!.id));
      } else {
        await repository.createBreeding(data);
      }
      ref.invalidate(breedingListProvider);
      await ref.read(breedingListProvider.notifier).refresh();
      return null;
    } catch (e) {
      final message = e.toString().replaceAll('Exception: ', '').trim();
      return message.isEmpty ? failed : message;
    }
  }

  String _statusLabel(String status) => switch (status) {
        'planned' => context.l10n.breedingStatusPlanned,
        'completed' => context.l10n.breedingStatusCompleted,
        'failed' => context.l10n.breedingStatusFailed,
        _ => context.l10n.breedingStatusCancelled,
      };

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return AppFormScaffold(
      title:
          _isEditing ? l10n.breedingFormEditTitle : l10n.breedingFormNewTitle,
      formKey: _formKey,
      submitLabel: _isEditing ? l10n.commonSave : l10n.commonAdd,
      successMessage:
          _isEditing ? l10n.breedingFormUpdated : l10n.breedingFormCreated,
      onSubmit: _save,
      isDirty: () => _touched,
      children: [
        if (_fromPlanner)
          AppCard(
            borderColor: AppColors.info,
            child: Row(
              children: [
                const Icon(Icons.info_outline, color: AppColors.info),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Text(
                    l10n.breedingFormPrefilled,
                    style: AppTypography.bodyMd
                        .copyWith(color: context.colors.onSurface),
                  ),
                ),
              ],
            ),
          ),
        AppFormSection(
          title: l10n.breedingParents,
          children: [
            // Раньше пару выбирали из подгруженной страницы списка кроликов:
            // на большой ферме половину животных выбрать было нельзя.
            RabbitPickerField(
              label: l10n.breedingFormMale,
              icon: Icons.male,
              sex: 'male',
              selected: _male,
              required: true,
              onChanged: (rabbit) => setState(() {
                _male = rabbit;
                _maleId = rabbit?.id;
                _touched = true;
              }),
            ),
            RabbitPickerField(
              label: l10n.breedingFormFemale,
              icon: Icons.female,
              sex: 'female',
              selected: _female,
              required: true,
              onChanged: (rabbit) => setState(() {
                _female = rabbit;
                _femaleId = rabbit?.id;
                _touched = true;
              }),
            ),
          ],
        ),
        AppFormSection(
          title: l10n.txFormSectionDetails,
          children: [
            AppDateField(
              label: l10n.breedingDate,
              value: _breedingDate,
              onChanged: (date) => setState(() {
                _breedingDate = date;
                _touched = true;
              }),
              prefixIcon: Icons.event_outlined,
              firstDate: DateTime.now().subtract(const Duration(days: 365)),
              lastDate: DateTime.now().add(const Duration(days: 365)),
            ),
            DropdownButtonFormField<String>(
              initialValue: _status,
              decoration: InputDecoration(
                labelText: l10n.breedingStatus,
                prefixIcon: const Icon(Icons.flag_outlined),
              ),
              items: [
                for (final status in const [
                  'planned',
                  'completed',
                  'failed',
                  'cancelled'
                ])
                  DropdownMenuItem(
                    value: status,
                    child: Text(_statusLabel(status)),
                  ),
              ],
              onChanged: (v) => setState(() {
                if (v != null) _status = v;
                _touched = true;
              }),
            ),
            TextFormField(
              controller: _notes,
              textCapitalization: TextCapitalization.sentences,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: l10n.breedingNotes,
                hintText: l10n.breedingFormNotesHint,
                prefixIcon: const Icon(Icons.notes),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
