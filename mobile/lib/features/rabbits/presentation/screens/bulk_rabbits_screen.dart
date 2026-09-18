import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/l10n/l10n_context.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/app_date_field.dart';
import '../../../../core/widgets/app_form_scaffold.dart';
import '../../../../core/widgets/app_form_section.dart';
import '../../../cages/presentation/providers/cages_provider.dart';
import '../providers/breeds_provider.dart';
import '../providers/rabbits_provider.dart';
import '../utils/rabbit_labels.dart';
import '../../../../core/forms/form_draft.dart';

/// Завести сразу несколько кроликов одним образцом.
///
/// Так переносят на приложение стадо, которое уже есть: у фермы триста
/// голов, порода одна-две, пол известен, возраст примерный. Заводить их по
/// одному — триста заполненных форм, и именно на этом перенос
/// останавливался, не начавшись.
class BulkRabbitsScreen extends ConsumerStatefulWidget {
  const BulkRabbitsScreen({super.key});

  @override
  ConsumerState<BulkRabbitsScreen> createState() => _BulkRabbitsScreenState();
}

class _BulkRabbitsScreenState extends ConsumerState<BulkRabbitsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _count = TextEditingController(text: '10');
  final _tagPrefix = TextEditingController();

  int? _breedId;
  int? _cageId;
  String _sex = 'unknown';
  DateTime _birthDate = DateTime.now().subtract(const Duration(days: 90));
  bool _touched = false;

  @override
  void dispose() {
    _count.dispose();
    _tagPrefix.dispose();
    super.dispose();
  }

  Future<Object?> _save() async {
    final prefix = _tagPrefix.text.trim();

    try {
      final created =
          await ref.read(rabbitsRepositoryProvider).createRabbitsBulk({
        'count': int.parse(_count.text.trim()),
        'breed_id': _breedId,
        'sex': _sex,
        'birth_date': _birthDate.toIso8601String().split('T').first,
        if (_cageId != null) 'cage_id': _cageId,
        // Пустой образец означает «бирок нет»: тогда сервер запишет
        // отсутствие клейма, а не пустую строку.
        if (prefix.isNotEmpty) 'tag_prefix': prefix,
      });

      await ref.read(rabbitsListProvider.notifier).refresh();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.bulkHerdDone(created))),
        );
      }
      return null;
    } catch (e) {
      return e;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final breeds = ref.watch(breedsProvider);
    final cages = ref.watch(cagesProvider);

    return AppFormScaffold(
      // Недописанное переживает смерть приложения (core/forms/form_draft.dart).
      draft: FormDraft(
        key: 'bulk-rabbits',
        fields: {
          'tagPrefix': _tagPrefix,
        },
      ),
      title: l10n.bulkHerdTitle,
      formKey: _formKey,
      submitLabel: l10n.commonAdd,
      // Сколько именно завелось, говорит сам экран после ответа сервера:
      // общее «готово» тут ничего не подтверждает.
      successMessage: l10n.bulkHerdTitle,
      onSubmit: _save,
      isDirty: () => _touched,
      children: [
        AppFormSection(
          title: l10n.commonSectionMain,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.md),
              child: Text(
                l10n.bulkHerdSubtitle,
                style: AppTypography.labelSm
                    .copyWith(color: context.colors.onSurfaceVariant),
              ),
            ),
            TextFormField(
              controller: _count,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                labelText: l10n.bulkHerdCount,
                prefixIcon: const Icon(Icons.numbers),
              ),
              onChanged: (_) => _touched = true,
              validator: (value) {
                final count = int.tryParse((value ?? '').trim());
                if (count == null || count < 1 || count > 100) {
                  return l10n.bulkHerdCountInvalid;
                }
                return null;
              },
            ),
            DropdownButtonFormField<int>(
              isExpanded: true,
              initialValue: _breedId,
              decoration: InputDecoration(
                labelText: l10n.rabbitBreed,
                prefixIcon: const Icon(Icons.pets_outlined),
              ),
              items: [
                for (final breed in breeds.breeds)
                  DropdownMenuItem(value: breed.id, child: Text(breed.name)),
              ],
              onChanged: (value) => setState(() {
                _breedId = value;
                _touched = true;
              }),
              validator: (value) =>
                  value == null ? l10n.rabbitFormBreedRequired : null,
            ),
            DropdownButtonFormField<String>(
              isExpanded: true,
              initialValue: _sex,
              decoration: InputDecoration(
                labelText: l10n.rabbitSex,
                prefixIcon: const Icon(Icons.wc_outlined),
              ),
              items: [
                for (final sex in ['unknown', 'female', 'male'])
                  DropdownMenuItem(
                    value: sex,
                    child: Text(sexLabel(context, sex)),
                  ),
              ],
              onChanged: (value) => setState(() {
                if (value != null) _sex = value;
                _touched = true;
              }),
            ),
            AppDateField(
              label: l10n.rabbitBirthDate,
              value: _birthDate,
              onChanged: (date) => setState(() {
                _birthDate = date;
                _touched = true;
              }),
              prefixIcon: Icons.cake_outlined,
              lastDate: DateTime.now(),
            ),
          ],
        ),
        AppFormSection(
          title: l10n.commonSectionDetails,
          children: [
            TextFormField(
              controller: _tagPrefix,
              decoration: InputDecoration(
                labelText: l10n.bulkHerdTagPrefix,
                hintText: l10n.bulkHerdTagPrefixHint,
                helperText: l10n.bulkHerdTagPrefixEmpty,
                helperMaxLines: 2,
                prefixIcon: const Icon(Icons.sell_outlined),
              ),
              onChanged: (_) => _touched = true,
            ),
            DropdownButtonFormField<int?>(
              isExpanded: true,
              initialValue: _cageId,
              decoration: InputDecoration(
                labelText: l10n.rabbitCage,
                prefixIcon: const Icon(Icons.grid_view_outlined),
              ),
              items: [
                DropdownMenuItem(value: null, child: Text(l10n.rabbitFormCageNone)),
                for (final cage in cages.cages)
                  DropdownMenuItem(
                    value: cage.id,
                    child: Text(cage.number),
                  ),
              ],
              onChanged: (value) => setState(() {
                _cageId = value;
                _touched = true;
              }),
            ),
          ],
        ),
      ],
    );
  }
}
