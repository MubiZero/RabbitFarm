import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/l10n/l10n_context.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/utils/format_utils.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../cages/data/models/cage_model.dart';
import '../../../cages/presentation/providers/cages_provider.dart';
import '../../../cages/presentation/utils/cage_labels.dart';
import '../../../rabbits/data/models/rabbit_model.dart';
import '../../../rabbits/presentation/widgets/rabbit_picker.dart';
import '../../data/models/feed_model.dart';
import '../../data/models/feeding_record_model.dart';
import '../providers/feeding_records_provider.dart';
import '../providers/feeds_provider.dart';

enum _FeedingMode { rabbit, cage }

/// Запись о кормлении.
class FeedingRecordFormScreen extends ConsumerStatefulWidget {
  final FeedingRecord? record;

  const FeedingRecordFormScreen({super.key, this.record});

  @override
  ConsumerState<FeedingRecordFormScreen> createState() =>
      _FeedingRecordFormScreenState();
}

class _FeedingRecordFormScreenState
    extends ConsumerState<FeedingRecordFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _quantity = TextEditingController();
  final _notes = TextEditingController();

  _FeedingMode _mode = _FeedingMode.rabbit;
  RabbitModel? _rabbit;
  int? _rabbitId;
  int? _cageId;
  int? _feedId;
  late DateTime _fedAt;
  bool _touched = false;

  FeedingRecord? get _record => widget.record;
  bool get _isEditing => _record != null;

  @override
  void initState() {
    super.initState();
    final record = _record;
    _fedAt = record?.fedAt ?? DateTime.now();

    if (record != null) {
      _feedId = record.feedId;
      _rabbitId = record.rabbitId;
      _rabbit = record.rabbit;
      _cageId = record.cageId;
      _mode = record.cageId != null ? _FeedingMode.cage : _FeedingMode.rabbit;
      _quantity.text = record.quantity.toString();
      _notes.text = record.notes ?? '';
    }

    for (final c in [_quantity, _notes]) {
      c.addListener(() => _touched = true);
    }
  }

  @override
  void dispose() {
    _quantity.dispose();
    _notes.dispose();
    super.dispose();
  }

  Future<String?> _save() async {
    final failed = context.l10n.feedingFormFailed;
    final repository = ref.read(feedingRecordsRepositoryProvider);
    final notifier = ref.read(feedingRecordsProvider.notifier);

    final rabbitId = _mode == _FeedingMode.rabbit ? _rabbitId : null;
    final cageId = _mode == _FeedingMode.cage ? _cageId : null;
    final quantity = parseDecimal(_quantity.text) ?? 0;

    try {
      if (_isEditing) {
        await repository.updateFeedingRecord(
          _record!.id,
          FeedingRecordUpdate(
            rabbitId: rabbitId,
            cageId: cageId,
            feedId: _feedId!,
            quantity: quantity,
            fedAt: _fedAt,
            notes: _notes.text.trim().isEmpty ? null : _notes.text.trim(),
          ),
        );
      } else {
        await repository.createFeedingRecord(
          FeedingRecordCreate(
            rabbitId: rabbitId,
            cageId: cageId,
            feedId: _feedId!,
            quantity: quantity,
            fedAt: _fedAt,
            notes: _notes.text.trim().isEmpty ? null : _notes.text.trim(),
          ),
        );
      }
      // Склад изменился вместе с записью, поэтому обновляем и его.
      await notifier.refresh();
      ref.invalidate(feedsProvider);
      ref.invalidate(feedOptionsProvider);
      return null;
    } catch (e) {
      final message = e.toString().replaceAll('Exception: ', '').trim();
      return message.isEmpty ? failed : message;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final feedsAsync = ref.watch(feedOptionsProvider);
    final cagesAsync = ref.watch(cageOptionsProvider);

    return AppFormScaffold(
      title:
          _isEditing ? l10n.feedingFormEditTitle : l10n.feedingFormNewTitle,
      formKey: _formKey,
      submitLabel: _isEditing ? l10n.commonSave : l10n.commonAdd,
      successMessage:
          _isEditing ? l10n.feedingFormUpdated : l10n.feedingFormCreated,
      onSubmit: _save,
      isDirty: () => _touched,
      children: [
        AppFormSection(
          title: l10n.feedingFormSectionWhom,
          children: [
            SegmentedButton<_FeedingMode>(
              segments: [
                ButtonSegment(
                  value: _FeedingMode.rabbit,
                  icon: const Icon(Icons.pets_outlined),
                  label: Text(l10n.feedingFormModeRabbit),
                ),
                ButtonSegment(
                  value: _FeedingMode.cage,
                  icon: const Icon(Icons.grid_view_outlined),
                  label: Text(l10n.feedingFormModeCage),
                ),
              ],
              selected: {_mode},
              onSelectionChanged: (selection) => setState(() {
                _mode = selection.first;
                _touched = true;
              }),
            ),
            if (_mode == _FeedingMode.rabbit)
              RabbitPickerField(
                label: l10n.vaccFormRabbit,
                selected: _rabbit,
                required: true,
                onChanged: (rabbit) => setState(() {
                  _rabbit = rabbit;
                  _rabbitId = rabbit?.id;
                  _touched = true;
                }),
              )
            else
              _CageField(
                cagesAsync: cagesAsync,
                selected: _cageId,
                onChanged: (id) => setState(() {
                  _cageId = id;
                  _touched = true;
                }),
              ),
          ],
        ),
        AppFormSection(
          title: l10n.feedingFormSectionWhat,
          children: [
            _FeedField(
              feedsAsync: feedsAsync,
              selected: _feedId,
              onChanged: (id) => setState(() {
                _feedId = id;
                _touched = true;
              }),
            ),
            TextFormField(
              controller: _quantity,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: l10n.feedingFormQuantity,
                prefixIcon: const Icon(Icons.scale_outlined),
                suffixText: feedsAsync.valueOrNull
                    ?.where((f) => f.id == _feedId)
                    .firstOrNull
                    ?.unit
                    .displayName,
                helperText: l10n.feedingFormStockNote,
                helperMaxLines: 2,
              ),
              validator: (v) {
                final value = parseDecimal(v);
                if (value == null) return l10n.feedingFormQuantityRequired;
                if (value <= 0) return l10n.feedsQuantityPositive;
                return null;
              },
            ),
            AppDateField(
              label: l10n.feedingFormWhen,
              value: _fedAt,
              onChanged: (date) => setState(() {
                _fedAt = date;
                _touched = true;
              }),
              prefixIcon: Icons.schedule,
              lastDate: DateTime.now(),
              showTime: true,
            ),
            TextFormField(
              controller: _notes,
              textCapitalization: TextCapitalization.sentences,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: l10n.feedingFormNotes,
                prefixIcon: const Icon(Icons.sticky_note_2_outlined),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// Выбор клетки. Список берётся целиком, а не первой страницей: раньше в
/// выпадающем поле были только те клетки, что успели загрузиться.
class _CageField extends StatelessWidget {
  final AsyncValue<List<CageModel>> cagesAsync;
  final int? selected;
  final ValueChanged<int?> onChanged;

  const _CageField({
    required this.cagesAsync,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final cages = cagesAsync.valueOrNull ?? const <CageModel>[];

    return DropdownButtonFormField<int>(
      initialValue: selected,
      decoration: InputDecoration(
        labelText: context.l10n.feedingFormCage,
        prefixIcon: const Icon(Icons.grid_view_outlined),
        suffixIcon: cagesAsync.isLoading
            ? const Padding(
                padding: EdgeInsets.all(AppSpacing.md),
                child: SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              )
            : null,
      ),
      items: [
        for (final cage in cages)
          DropdownMenuItem(
            value: cage.id,
            child: Text(
              '${context.l10n.cageTitleNumbered(cage.number)} · '
              '${cageTypeLabel(context, cage.type)}',
            ),
          ),
      ],
      onChanged: onChanged,
      validator: (v) => v == null ? context.l10n.feedingFormCageRequired : null,
    );
  }
}

class _FeedField extends StatelessWidget {
  final AsyncValue<List<Feed>> feedsAsync;
  final int? selected;
  final ValueChanged<int?> onChanged;

  const _FeedField({
    required this.feedsAsync,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final feeds = feedsAsync.valueOrNull ?? const <Feed>[];

    return DropdownButtonFormField<int>(
      initialValue: selected,
      isExpanded: true,
      decoration: InputDecoration(
        labelText: context.l10n.feedingFormFeed,
        prefixIcon: const Icon(Icons.inventory_2_outlined),
        suffixIcon: feedsAsync.isLoading
            ? const Padding(
                padding: EdgeInsets.all(AppSpacing.md),
                child: SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              )
            : null,
      ),
      items: [
        for (final feed in feeds)
          DropdownMenuItem(
            value: feed.id,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    feed.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                // Остаток виден прямо в списке: иначе легко записать расход
                // корма, которого на складе уже нет.
                Text(
                  context.l10n.feedingFormStockLeft(
                      formatQuantity(feed.currentStock, feed.unit.displayName)),
                  style: AppTypography.labelSm.copyWith(
                    color: feed.currentStock <= feed.minStock
                        ? AppColors.warning
                        : context.colors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
      ],
      onChanged: onChanged,
      validator: (v) => v == null ? context.l10n.feedingFormFeedRequired : null,
    );
  }
}
