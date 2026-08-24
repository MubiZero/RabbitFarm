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
///
/// Кормят не по одному: за утренний обход работник обходит ряд или всю ферму,
/// и раньше на каждую клетку заводилась отдельная форма — сорок форм дважды в
/// день. Поэтому получателей здесь можно выбрать сколько угодно, а количество
/// задаётся НА ОДНОГО из них: работник отмеряет ковш на клетку, а не делит
/// мешок на сорок частей. Сколько уйдёт со склада всего, форма считает сама и
/// показывает под полем — иначе цифра корма читалась бы двояко.
///
/// Одиночный случай от этого не усложняется: один выбранный получатель — тот
/// же самый экран и та же кнопка.
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

  /// Получатели новой записи. У правки получатель ровно один — менять его на
  /// пачку нельзя: правится одна конкретная строка журнала.
  final List<RabbitModel> _rabbits = [];
  final Set<int> _cageIds = {};

  RabbitModel? _editedRabbit;
  int? _editedRabbitId;
  int? _editedCageId;

  int? _feedId;
  late DateTime _fedAt;
  bool _touched = false;

  FeedingRecord? get _record => widget.record;
  bool get _isEditing => _record != null;

  int get _recipientCount =>
      _mode == _FeedingMode.rabbit ? _rabbits.length : _cageIds.length;

  @override
  void initState() {
    super.initState();
    final record = _record;
    _fedAt = record?.fedAt ?? DateTime.now();

    if (record != null) {
      _feedId = record.feedId;
      _editedRabbitId = record.rabbitId;
      _editedRabbit = record.rabbit;
      _editedCageId = record.cageId;
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

  Future<Object?> _save() async {
    final repository = ref.read(feedingRecordsRepositoryProvider);
    final notifier = ref.read(feedingRecordsProvider.notifier);

    final quantity = parseDecimal(_quantity.text) ?? 0;
    final notes = _notes.text.trim().isEmpty ? null : _notes.text.trim();

    try {
      if (_isEditing) {
        await repository.updateFeedingRecord(
          _record!.id,
          FeedingRecordUpdate(
            rabbitId: _mode == _FeedingMode.rabbit ? _editedRabbitId : null,
            cageId: _mode == _FeedingMode.cage ? _editedCageId : null,
            feedId: _feedId!,
            quantity: quantity,
            fedAt: _fedAt,
            notes: notes,
          ),
        );
      } else {
        // Один путь и для одного получателя, и для сорока: сервер принимает
        // пачку из одного так же, как из сорока, и форме не нужно выбирать
        // между двумя видами запроса.
        await repository.createFeedingRecordsBulk(
          feedId: _feedId!,
          quantityPerRecipient: quantity,
          fedAt: _fedAt,
          rabbitIds: _mode == _FeedingMode.rabbit
              ? [for (final rabbit in _rabbits) rabbit.id]
              : const [],
          cageIds:
              _mode == _FeedingMode.cage ? _cageIds.toList() : const <int>[],
          notes: notes,
        );
      }
      // Склад изменился вместе с записью, поэтому обновляем и его.
      await notifier.refresh();
      ref.invalidate(feedsProvider);
      ref.invalidate(feedOptionsProvider);
      return null;
    } catch (e) {
      return e;
    }
  }

  void _addRabbit(RabbitModel? rabbit) {
    if (rabbit == null) return;
    setState(() {
      if (!_rabbits.any((r) => r.id == rabbit.id)) _rabbits.add(rabbit);
      _touched = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final feedsAsync = ref.watch(feedOptionsProvider);
    final cagesAsync = ref.watch(cageOptionsProvider);

    final feed =
        feedsAsync.valueOrNull?.where((f) => f.id == _feedId).firstOrNull;
    final isBulk = !_isEditing && _recipientCount > 1;

    return AppFormScaffold(
      title: _isEditing ? l10n.feedingFormEditTitle : l10n.feedingFormNewTitle,
      formKey: _formKey,
      submitLabel: _isEditing ? l10n.commonSave : l10n.commonAdd,
      successMessage: _isEditing
          ? l10n.feedingFormUpdated
          : l10n.feedingBulkCreated(_recipientCount),
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
                  label: Text(_isEditing
                      ? l10n.feedingFormModeRabbit
                      : l10n.feedingBulkModeRabbits),
                ),
                ButtonSegment(
                  value: _FeedingMode.cage,
                  icon: const Icon(Icons.grid_view_outlined),
                  label: Text(_isEditing
                      ? l10n.feedingFormModeCage
                      : l10n.feedingBulkModeCages),
                ),
              ],
              selected: {_mode},
              onSelectionChanged: (selection) => setState(() {
                _mode = selection.first;
                _touched = true;
              }),
            ),
            _recipientField(context, cagesAsync),
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
                // Подпись прямо говорит, что означает число: при нескольких
                // получателях «сколько» без уточнения читается и как норма на
                // клетку, и как общий расход.
                labelText: isBulk
                    ? l10n.feedingBulkQuantityEach
                    : l10n.feedingFormQuantity,
                prefixIcon: const Icon(Icons.scale_outlined),
                suffixText: feed?.unit.displayName,
                helperText: _quantityHelper(context, feed, isBulk),
                helperMaxLines: 2,
              ),
              // Подсказка про общий расход считается здесь же, при сборке
              // экрана, а набор текста сам по себе его не пересобирает: без
              // этой строки «Всего спишется 1,5 кг» не появлялось никогда —
              // ровно то число, ради которого подсказка и нужна.
              onChanged: (_) => setState(() => _touched = true),
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

  /// Кому записываем кормление.
  ///
  /// У правки получатель ровно один и поля прежние: правится конкретная
  /// строка журнала, превращать её в пачку нечего.
  Widget _recipientField(
    BuildContext context,
    AsyncValue<List<CageModel>> cagesAsync,
  ) {
    final l10n = context.l10n;

    if (_mode == _FeedingMode.rabbit) {
      if (_isEditing) {
        return RabbitPickerField(
          label: l10n.fieldRecipient,
          selected: _editedRabbit,
          required: true,
          onChanged: (rabbit) => setState(() {
            _editedRabbit = rabbit;
            _editedRabbitId = rabbit?.id;
            _touched = true;
          }),
        );
      }

      return _RabbitsField(
        rabbits: _rabbits,
        onAdd: _addRabbit,
        onRemove: (rabbit) => setState(() {
          _rabbits.removeWhere((r) => r.id == rabbit.id);
          _touched = true;
        }),
      );
    }

    if (_isEditing) {
      return _CageField(
        cagesAsync: cagesAsync,
        selected: _editedCageId,
        onChanged: (id) => setState(() {
          _editedCageId = id;
          _touched = true;
        }),
      );
    }

    return _CagesField(
      cagesAsync: cagesAsync,
      selected: _cageIds,
      onChanged: (ids) => setState(() {
        _cageIds
          ..clear()
          ..addAll(ids);
        _touched = true;
      }),
    );
  }

  /// Что спишется со склада. Пока получатель один, ответ прежний; как только
  /// их несколько — под полем стоит общий расход, чтобы «0,5» не выглядело
  /// как полкило на всю ферму.
  String _quantityHelper(BuildContext context, Feed? feed, bool isBulk) {
    final l10n = context.l10n;
    if (!isBulk) return l10n.feedingFormStockNote;

    final perRecipient = parseDecimal(_quantity.text);
    if (perRecipient == null || perRecipient <= 0) {
      return l10n.feedingBulkQuantityEachHint;
    }

    return l10n.feedingBulkQuantityEachNote(
      formatQuantity(perRecipient * _recipientCount, feed?.unit.displayName),
    );
  }
}

/// Несколько кроликов: поле «добавить» плюс список выбранных.
class _RabbitsField extends StatelessWidget {
  final List<RabbitModel> rabbits;
  final ValueChanged<RabbitModel?> onAdd;
  final ValueChanged<RabbitModel> onRemove;

  const _RabbitsField({
    required this.rabbits,
    required this.onAdd,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return FormField<bool>(
      initialValue: rabbits.isNotEmpty,
      validator: (_) =>
          rabbits.isEmpty ? l10n.feedingBulkRabbitsRequired : null,
      builder: (field) {
        // Ошибка живёт до следующей проверки формы, поэтому гасим её сами,
        // как только кролик выбран: иначе красная подпись висит под уже
        // заполненным полем.
        final error = rabbits.isEmpty ? field.errorText : null;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RabbitPickerField(
              label: l10n.feedingBulkAddRabbit,
              selected: null,
              icon: Icons.add,
              onChanged: onAdd,
            ),
            if (rabbits.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.sm),
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: [
                  for (final rabbit in rabbits)
                    InputChip(
                      label: Text('${rabbit.name} · ${rabbit.tagId}'),
                      onDeleted: () => onRemove(rabbit),
                      deleteButtonTooltipMessage: l10n.feedingBulkRemove,
                    ),
                ],
              ),
            ],
            if (error != null) ...[
              const SizedBox(height: AppSpacing.xs),
              Text(
                error,
                style: AppTypography.labelSm
                    .copyWith(color: context.colors.error),
              ),
            ],
          ],
        );
      },
    );
  }
}

/// Выбор нескольких клеток: поле открывает шторку со списком по рядам.
class _CagesField extends StatelessWidget {
  final AsyncValue<List<CageModel>> cagesAsync;
  final Set<int> selected;
  final ValueChanged<Set<int>> onChanged;

  const _CagesField({
    required this.cagesAsync,
    required this.selected,
    required this.onChanged,
  });

  String _text(BuildContext context, List<CageModel> cages) {
    if (selected.length == 1) {
      final cage = cages.where((c) => c.id == selected.first).firstOrNull;
      if (cage != null) return context.l10n.cageTitleNumbered(cage.number);
    }
    return context.l10n.feedingBulkCagesSelected(selected.length);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final cages = cagesAsync.valueOrNull ?? const <CageModel>[];

    return FormField<bool>(
      initialValue: selected.isNotEmpty,
      validator: (_) => selected.isEmpty ? l10n.feedingBulkCagesRequired : null,
      builder: (field) {
        final error = selected.isEmpty ? field.errorText : null;

        return InkWell(
          borderRadius: AppRadius.mdAll,
          onTap: () async {
            final picked = await showModalBottomSheet<Set<int>>(
              context: context,
              isScrollControlled: true,
              builder: (_) =>
                  _CagePickerSheet(cages: cages, selected: selected),
            );
            if (picked != null) onChanged(picked);
          },
          child: InputDecorator(
            isEmpty: selected.isEmpty,
            decoration: InputDecoration(
              labelText: l10n.feedingBulkCagesField,
              prefixIcon: const Icon(Icons.grid_view_outlined),
              errorText: error,
              suffixIcon: cagesAsync.isLoading
                  ? const Padding(
                      padding: EdgeInsets.all(AppSpacing.md),
                      child: SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    )
                  : const Icon(Icons.arrow_drop_down),
            ),
            child: selected.isEmpty
                ? null
                : Text(
                    _text(context, cages),
                    style: AppTypography.bodyLg
                        .copyWith(color: context.colors.onSurface),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
          ),
        );
      },
    );
  }
}

/// Шторка выбора клеток: вся ферма, ряд целиком или отдельные клетки.
///
/// Ряд — это расположение клетки (`location`): другого понятия ряда в данных
/// нет, а работник обходит именно сарай или ряд целиком.
class _CagePickerSheet extends StatefulWidget {
  final List<CageModel> cages;
  final Set<int> selected;

  const _CagePickerSheet({required this.cages, required this.selected});

  @override
  State<_CagePickerSheet> createState() => _CagePickerSheetState();
}

class _CagePickerSheetState extends State<_CagePickerSheet> {
  late final Set<int> _selected = {...widget.selected};

  Map<String?, List<CageModel>> get _rows {
    final rows = <String?, List<CageModel>>{};
    for (final cage in widget.cages) {
      final row = (cage.location?.trim().isEmpty ?? true)
          ? null
          : cage.location!.trim();
      rows.putIfAbsent(row, () => []).add(cage);
    }
    return rows;
  }

  void _toggleRow(List<CageModel> row, bool select) => setState(() {
        for (final cage in row) {
          if (select) {
            _selected.add(cage.id);
          } else {
            _selected.remove(cage.id);
          }
        }
      });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final rows = _rows;

    return SafeArea(
      child: SizedBox(
        height: MediaQuery.sizeOf(context).height * 0.75,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screenH,
                AppSpacing.md,
                AppSpacing.screenH,
                0,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      l10n.feedingBulkCagesPickTitle,
                      style: AppTypography.titleLg
                          .copyWith(color: context.colors.onSurface),
                    ),
                  ),
                  Text(
                    l10n.feedingBulkCagesSelected(_selected.length),
                    style: AppTypography.labelSm
                        .copyWith(color: context.colors.onSurfaceVariant),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.screenH,
              ),
              child: Row(
                children: [
                  TextButton.icon(
                    onPressed: () => setState(() => _selected
                      ..clear()
                      ..addAll(widget.cages.map((c) => c.id))),
                    icon: const Icon(Icons.select_all),
                    label: Text(l10n.feedingBulkWholeFarm),
                  ),
                  TextButton(
                    onPressed: _selected.isEmpty
                        ? null
                        : () => setState(_selected.clear),
                    child: Text(l10n.feedingBulkClearSelection),
                  ),
                ],
              ),
            ),
            Expanded(
              child: widget.cages.isEmpty
                  ? AppEmptyState(
                      icon: Icons.grid_view_outlined,
                      title: l10n.feedingBulkNoCagesTitle,
                      subtitle: l10n.feedingBulkNoCagesBody,
                    )
                  : ListView(
                      padding: const EdgeInsets.only(bottom: AppSpacing.xl),
                      children: [
                        for (final entry in rows.entries)
                          ..._rowTiles(context, entry.key, entry.value),
                      ],
                    ),
            ),
            AppSubmitBar(
              label: l10n.feedingBulkDone,
              onPressed: () => Navigator.pop(context, _selected),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _rowTiles(
    BuildContext context,
    String? row,
    List<CageModel> cages,
  ) {
    final chosen = cages.where((c) => _selected.contains(c.id)).length;

    return [
      CheckboxListTile(
        // Промежуточное состояние показывает, что ряд выбран не целиком —
        // иначе галочка врала бы про половину ряда.
        value: chosen == cages.length
            ? true
            : chosen == 0
                ? false
                : null,
        tristate: true,
        controlAffinity: ListTileControlAffinity.leading,
        title: Text(
          row ?? context.l10n.feedingBulkRowUnnamed,
          style: AppTypography.titleMd
              .copyWith(color: context.colors.onSurface),
        ),
        subtitle: Text(context.l10n.feedingBulkCagesSelected(chosen)),
        onChanged: (_) => _toggleRow(cages, chosen != cages.length),
      ),
      for (final cage in cages)
        Padding(
          padding: const EdgeInsets.only(left: AppSpacing.lg),
          child: CheckboxListTile(
            value: _selected.contains(cage.id),
            controlAffinity: ListTileControlAffinity.leading,
            title: Text(context.l10n.cageTitleNumbered(cage.number)),
            subtitle: Text(cageTypeLabel(context, cage.type)),
            onChanged: (checked) => setState(() {
              if (checked == true) {
                _selected.add(cage.id);
              } else {
                _selected.remove(cage.id);
              }
            }),
          ),
        ),
    ];
  }
}

/// Выбор одной клетки при правке записи. Список берётся целиком, а не первой
/// страницей: раньше в выпадающем поле были только те клетки, что успели
/// загрузиться.
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
