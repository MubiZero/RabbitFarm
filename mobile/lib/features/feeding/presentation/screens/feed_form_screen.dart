import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/access/farm_access.dart';
import '../../../../core/l10n/l10n_context.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/utils/format_utils.dart';
import '../../../../core/widgets/widgets.dart';
import '../../data/models/feed_model.dart';
import '../providers/feeds_provider.dart';

/// Карточка корма на складе.
class FeedFormScreen extends ConsumerStatefulWidget {
  final Feed? feed;

  const FeedFormScreen({super.key, this.feed});

  @override
  ConsumerState<FeedFormScreen> createState() => _FeedFormScreenState();
}

class _FeedFormScreenState extends ConsumerState<FeedFormScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _name;
  late final TextEditingController _currentStock;
  late final TextEditingController _minStock;
  late final TextEditingController _costPerUnit;

  late FeedType _type;
  late FeedUnit _unit;
  bool _touched = false;

  Feed? get _feed => widget.feed;
  bool get _isEditing => _feed != null;

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: _feed?.name ?? '');
    _currentStock =
        TextEditingController(text: _feed?.currentStock.toString() ?? '0');
    _minStock = TextEditingController(text: _feed?.minStock.toString() ?? '0');
    _costPerUnit =
        TextEditingController(text: _feed?.costPerUnit?.toString() ?? '');

    _type = _feed?.type ?? FeedType.pellets;
    _unit = _feed?.unit ?? FeedUnit.kg;

    for (final c in [_name, _currentStock, _minStock, _costPerUnit]) {
      c.addListener(() => _touched = true);
    }
  }

  @override
  void dispose() {
    for (final c in [_name, _currentStock, _minStock, _costPerUnit]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<Object?> _save() async {
    final repository = ref.read(feedsRepositoryProvider);
    final notifier = ref.read(feedsProvider.notifier);

    final currentStock = parseDecimal(_currentStock.text) ?? 0;
    final minStock = parseDecimal(_minStock.text) ?? 0;
    final costPerUnit = parseDecimal(_costPerUnit.text);

    try {
      if (_isEditing) {
        final updated = await repository.updateFeed(
          _feed!.id,
          FeedUpdate(
            name: _name.text.trim(),
            type: _type.name,
            unit: _unit.name,
            currentStock: currentStock,
            minStock: minStock,
            costPerUnit: costPerUnit,
          ),
        );
        notifier.updateFeed(updated);
      } else {
        final created = await repository.createFeed(
          FeedCreate(
            name: _name.text.trim(),
            type: _type.name,
            unit: _unit.name,
            currentStock: currentStock,
            minStock: minStock,
            costPerUnit: costPerUnit,
          ),
        );
        notifier.addFeed(created);
      }
      return null;
    } catch (e) {
      return e;
    }
  }

  Future<void> _delete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l10n.feedsDeleteTitle),
        content: Text(context.l10n.feedsDeleteBody(_feed!.name)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(context.l10n.commonCancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: Text(context.l10n.commonDelete),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    final done = context.l10n.feedsDeleted;
    final failed = context.l10n.feedsDeleteFailed;

    final error = await ref.read(feedsProvider.notifier).deleteFeed(_feed!.id);
    if (error == null) {
      messenger.showSnackBar(SnackBar(content: Text(done)));
      if (navigator.canPop()) navigator.pop();
    } else {
      messenger.showSnackBar(
        SnackBar(
          content: Text('$failed: $error'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  String? _validateAmount(String? value, {required bool required}) {
    final l10n = context.l10n;
    if (value == null || value.trim().isEmpty) {
      return required ? l10n.feedFormRequired : null;
    }
    final number = parseDecimal(value);
    if (number == null) return l10n.commonNumberInvalid;
    if (number < 0) return l10n.feedFormNegative;
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final canDelete = ref.watch(canProvider(FarmCapability.deleteRecords));

    return AppFormScaffold(
      title: _isEditing ? l10n.feedFormEditTitle : l10n.feedFormNewTitle,
      formKey: _formKey,
      submitLabel: _isEditing ? l10n.commonSave : l10n.commonAdd,
      successMessage:
          _isEditing ? l10n.feedFormUpdated : l10n.feedFormCreated,
      onSubmit: _save,
      isDirty: () => _touched,
      actions: [
        if (_isEditing && canDelete)
          IconButton(
            tooltip: l10n.commonDelete,
            icon: const Icon(Icons.delete_outline),
            color: AppColors.error,
            onPressed: _delete,
          ),
      ],
      children: [
        AppFormSection(
          title: l10n.commonSectionMain,
          children: [
            TextFormField(
              controller: _name,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                labelText: l10n.feedFormName,
                prefixIcon: const Icon(Icons.label_outline),
              ),
              validator: (v) => (v == null || v.trim().isEmpty)
                  ? l10n.feedFormNameEmpty
                  : null,
            ),
            DropdownButtonFormField<FeedType>(
              initialValue: _type,
              decoration: InputDecoration(
                labelText: l10n.feedFormType,
                prefixIcon: const Icon(Icons.category_outlined),
              ),
              items: [
                for (final type in FeedType.values)
                  DropdownMenuItem(
                    value: type,
                    child: Text(type.displayName),
                  ),
              ],
              onChanged: (v) => setState(() {
                if (v != null) _type = v;
                _touched = true;
              }),
            ),
            DropdownButtonFormField<FeedUnit>(
              initialValue: _unit,
              decoration: InputDecoration(
                labelText: l10n.feedFormUnit,
                prefixIcon: const Icon(Icons.straighten),
              ),
              items: [
                for (final unit in FeedUnit.values)
                  DropdownMenuItem(
                    value: unit,
                    child: Text(unit.displayName),
                  ),
              ],
              onChanged: (v) => setState(() {
                if (v != null) _unit = v;
                _touched = true;
              }),
            ),
          ],
        ),
        AppFormSection(
          title: l10n.feedFormSectionStock,
          children: [
            TextFormField(
              controller: _currentStock,
              // Дробный ввод: мешок редко весит целое число килограммов.
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: l10n.feedFormCurrentStock,
                prefixIcon: const Icon(Icons.inventory_2_outlined),
                suffixText: _unit.displayName,
              ),
              validator: (v) => _validateAmount(v, required: true),
            ),
            TextFormField(
              controller: _minStock,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: l10n.feedFormMinStock,
                prefixIcon: const Icon(Icons.warning_amber_outlined),
                suffixText: _unit.displayName,
                helperText: l10n.feedFormMinStockHelp,
                helperMaxLines: 2,
              ),
              validator: (v) => _validateAmount(v, required: true),
            ),
            TextFormField(
              controller: _costPerUnit,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: l10n.feedFormCost,
                prefixIcon: const Icon(Icons.payments_outlined),
                suffixText: '$kCurrencySymbol/${_unit.displayName}',
              ),
              validator: (v) => _validateAmount(v, required: false),
            ),
          ],
        ),
      ],
    );
  }
}
