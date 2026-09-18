import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/access/farm_access.dart';
import '../../../../core/l10n/l10n_context.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/utils/format_utils.dart';
import '../../../../core/utils/image_url_helper.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../rabbits/data/models/rabbit_model.dart';
import '../../../rabbits/presentation/widgets/rabbit_picker.dart';
import '../../data/models/transaction_model.dart';
import '../providers/transactions_provider.dart';
import '../utils/transaction_labels.dart';
import '../../../../core/l10n/error_text.dart';
import '../../../../core/countries/farm_currency.dart';
import '../../../rabbits/presentation/widgets/rabbit_multi_picker.dart';
import '../../../../core/forms/form_draft.dart';
import '../../../../core/providers/after_write.dart';

/// Приход или расход фермы.
class TransactionFormScreen extends ConsumerStatefulWidget {
  final Transaction? transaction;

  const TransactionFormScreen({super.key, this.transaction});

  @override
  ConsumerState<TransactionFormScreen> createState() =>
      _TransactionFormScreenState();
}

class _TransactionFormScreenState extends ConsumerState<TransactionFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amount = TextEditingController();
  final _description = TextEditingController();

  late TransactionType _type;
  late TransactionCategory _category;
  late DateTime _date;
  RabbitModel? _rabbit;
  String? _rabbitLabel;
  int? _rabbitId;

  /// Партия: продажа нескольких кроликов одной сделкой.
  ///
  /// Только для новой записи о продаже. Правка партии не предлагается: у
  /// операции уже есть связанные кролики, и менять их состав задним числом
  /// значило бы разъехаться с тем, что уже списано из стада.
  bool _batchSale = false;
  List<RabbitModel> _batch = const [];

  bool get _isSaleCategory =>
      _category == TransactionCategory.saleRabbit ||
      _category == TransactionCategory.saleMeat ||
      _category == TransactionCategory.saleFur;
  bool _touched = false;

  /// Снимок чека: приложенный сейчас и уже сохранённый раньше.
  ///
  /// Чек — единственное подтверждение траты, которое остаётся у фермы:
  /// поле для него было в базе с самого начала, но положить туда что-то
  /// человек не мог.
  final _imagePicker = ImagePicker();
  XFile? _receipt;
  Uint8List? _receiptBytes;
  String? _receiptUrl;
  bool _receiptRemoved = false;

  static const _incomeCategories = [
    TransactionCategory.saleRabbit,
    TransactionCategory.saleMeat,
    TransactionCategory.saleFur,
    TransactionCategory.breedingFee,
  ];

  static const _expenseCategories = [
    TransactionCategory.feed,
    TransactionCategory.veterinary,
    TransactionCategory.equipment,
    TransactionCategory.utilities,
    TransactionCategory.other,
  ];

  Transaction? get _record => widget.transaction;
  bool get _isEditing => _record != null;

  List<TransactionCategory> get _categories =>
      _type == TransactionType.income ? _incomeCategories : _expenseCategories;

  @override
  void initState() {
    super.initState();
    final record = _record;
    _type = record?.type ?? TransactionType.expense;
    _category = record?.category ?? _expenseCategories.first;
    _date = record?.transactionDate ?? DateTime.now();
    _rabbitId = record?.rabbitId;
    // Пикеру нужна полная модель, а в записи лежит краткая ссылка. Пока
    // человек не выбрал кролика заново, показываем подпись из неё — иначе
    // при правке операции поле выглядело бы пустым.
    _rabbitLabel = record?.rabbit?.label;
    _amount.text = record?.amount.toString() ?? '';
    _description.text = record?.description ?? '';
    _receiptUrl = record?.receiptUrl;

    for (final c in [_amount, _description]) {
      c.addListener(() => _touched = true);
    }
  }

  @override
  void dispose() {
    _amount.dispose();
    _description.dispose();
    super.dispose();
  }

  Future<Object?> _save() async {
    final amount = parseDecimal(_amount.text) ?? 0;
    final description =
        _description.text.trim().isEmpty ? null : _description.text.trim();

    try {
      if (_isEditing) {
        await ref.read(
          updateTransactionProvider((
            id: _record!.id,
            update: TransactionUpdate(
              type: _type,
              category: _category,
              amount: amount,
              transactionDate: _date,
              rabbitId: _rabbitId,
              description: description,
              // Пустая строка — это «чек сняли»: сервер по ней удаляет и
              // запись, и сам файл из хранилища.
              receiptUrl: _receiptRemoved ? '' : null,
            ),
            receiptPath: _receipt?.path,
            receiptBytes: _receiptBytes,
          )).future,
        );
      } else {
        await ref.read(
          createTransactionProvider((
            create: TransactionCreate(
              type: _type,
              category: _category,
              amount: amount,
              transactionDate: _date,
              // Партия уходит списком, одиночная продажа — как раньше.
              rabbitId: _batchSale ? null : _rabbitId,
              rabbitIds: _batchSale && _batch.isNotEmpty
                  ? _batch.map((r) => r.id).toList()
                  : null,
              description: description,
            ),
            receiptPath: _receipt?.path,
            receiptBytes: _receiptBytes,
          )).future,
        );
      }
      await ref.read(transactionsProvider.notifier).refresh();
      ref.refreshAfter(FarmRecord.transaction);
      return null;
    } catch (e) {
      return e;
    }
  }

  /// Удаление без вопроса «точно удалить?», но с окном на отмену: в перчатках
  /// диалог подтверждения ничего не защищает, а несколько секунд на отмену —
  /// защищают.
  Future<void> _delete() async {
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    final failed = context.l10n.financeDeleteFailed;
    final l10n = context.l10n;
    final notifier = ref.read(transactionsProvider.notifier);
    // Репозиторий забираем сразу: запрос уйдёт уже после того, как экран
    // закроется.
    final repository = ref.read(transactionsRepositoryProvider);
    final recordId = _record!.id;

    notifier.removeTransaction(recordId);

    Object? error;
    // Окно отмены открываем, пока форма ещё на экране: `deleteWithUndo`
    // забирает всё нужное из контекста сразу, до первого ожидания. Саму форму
    // закрываем, не дожидаясь окна, — подсказка живёт выше экрана и переживёт
    // его закрытие.
    final pending = deleteWithUndo(
      context,
      message: context.l10n.financeDeleted,
      commit: () async {
        try {
          await repository.deleteTransaction(recordId);
        } catch (e) {
          error = e;
        }
      },
      onUndo: notifier.refresh,
    );
    if (navigator.canPop()) navigator.pop();
    await pending;

    if (error != null) {
      messenger.showSnackBar(
        SnackBar(
          content: Text('$failed: ${errorText(l10n, error)}'),
          backgroundColor: AppColors.error,
        ),
      );
      await notifier.refresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final canDelete = ref.watch(canProvider(FarmCapability.deleteRecords));

    return AppFormScaffold(
      // Недописанное переживает смерть приложения (core/forms/form_draft.dart).
      draft: FormDraft(
        key: 'transaction-${_record?.id ?? 'new'}',
        fields: {
          'amount': _amount,
          'description': _description,
        },
      ),
      title: _isEditing ? l10n.txFormEditTitle : l10n.txFormNewTitle,
      formKey: _formKey,
      submitLabel: _isEditing ? l10n.commonSave : l10n.commonAdd,
      successMessage: _isEditing ? l10n.txFormUpdated : l10n.txFormCreated,
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
          title: l10n.txFormSectionKind,
          children: [
            SegmentedButton<TransactionType>(
              segments: [
                ButtonSegment(
                  value: TransactionType.income,
                  icon: const Icon(Icons.arrow_upward),
                  label: Text(l10n.financeTypeIncome),
                ),
                ButtonSegment(
                  value: TransactionType.expense,
                  icon: const Icon(Icons.arrow_downward),
                  label: Text(l10n.financeTypeExpense),
                ),
              ],
              selected: {_type},
              onSelectionChanged: (selection) => setState(() {
                _type = selection.first;
                _touched = true;
                // Категории дохода и расхода не пересекаются, поэтому при
                // смене типа выбранная категория заменяется на подходящую.
                if (!_categories.contains(_category)) {
                  _category = _categories.first;
                }
              }),
            ),
            DropdownButtonFormField<TransactionCategory>(
              initialValue: _category,
              isExpanded: true,
              decoration: InputDecoration(
                labelText: l10n.financeCategory,
                prefixIcon: const Icon(Icons.category_outlined),
              ),
              items: [
                for (final category in _categories)
                  DropdownMenuItem(
                    value: category,
                    child: Text(transactionCategoryLabel(context, category)),
                  ),
              ],
              onChanged: (v) => setState(() {
                if (v != null) _category = v;
                _touched = true;
              }),
            ),
          ],
        ),
        AppFormSection(
          title: l10n.commonSectionDetails,
          children: [
            TextFormField(
              controller: _amount,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: l10n.txFormAmount,
                prefixIcon: const Icon(Icons.payments_outlined),
                suffixText: context.currencySymbol,
              ),
              validator: (v) {
                final value = parseDecimal(v);
                if (value == null) return l10n.txFormAmountEmpty;
                if (value <= 0) return l10n.txFormAmountPositive;
                return null;
              },
            ),
            AppDateField(
              label: l10n.txFormDate,
              value: _date,
              onChanged: (date) => setState(() {
                _date = date;
                _touched = true;
              }),
              prefixIcon: Icons.event_outlined,
              lastDate: DateTime.now(),
            ),
            // Партия предлагается только там, где она бывает: продажа. Для
            // расхода на корм список кроликов не нужен вовсе.
            if (!_isEditing && _isSaleCategory)
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(l10n.transactionSaleBatch),
                value: _batchSale,
                onChanged: (value) => setState(() {
                  _batchSale = value;
                  // Выбор не переносим между режимами: один кролик и партия
                  // — разные сделки, и молча превращать одно в другое
                  // значит записать не то, что человек видел на экране.
                  _rabbit = null;
                  _rabbitId = null;
                  _rabbitLabel = null;
                  _batch = const [];
                  _touched = true;
                }),
              ),
            if (!_isEditing && _isSaleCategory && _batchSale)
              RabbitMultiPickerField(
                selected: _batch,
                onChanged: (rabbits) => setState(() {
                  _batch = rabbits;
                  _touched = true;
                }),
              )
            else
              // Поле было спрятано целиком, если список кроликов ещё не
              // загрузился: привязать операцию к животному было нельзя,
              // и причина этого нигде не объяснялась.
              RabbitPickerField(
                label: l10n.txFormRabbit,
                selected: _rabbit,
                selectedLabel: _rabbitId != null ? _rabbitLabel : null,
                onChanged: (rabbit) => setState(() {
                  _rabbit = rabbit;
                  _rabbitLabel = null;
                  _rabbitId = rabbit?.id;
                  _touched = true;
                }),
              ),
            TextFormField(
              controller: _description,
              textCapitalization: TextCapitalization.sentences,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: l10n.txFormDescription,
                prefixIcon: const Icon(Icons.notes),
              ),
            ),
            _receiptField(context),
          ],
        ),
      ],
    );
  }

  /// Чек: снимок у кассы, а не ссылка.
  ///
  /// Снятый чек показывается тут же — иначе человек не знает, приложил он
  /// его к этой трате или к соседней.
  Widget _receiptField(BuildContext context) {
    final l10n = context.l10n;
    final savedUrl =
        _receiptRemoved ? null : ImageUrlHelper.getFullImageUrl(_receiptUrl);
    final hasReceipt = _receipt != null || savedUrl != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.txFormReceipt,
          style: AppTypography.labelSm
              .copyWith(color: context.colors.onSurfaceVariant),
        ),
        const SizedBox(height: AppSpacing.sm),
        if (hasReceipt) ...[
          ClipRRect(
            borderRadius: AppRadius.mdAll,
            child: SizedBox(
              height: 160,
              width: double.infinity,
              child: _receiptBytes != null
                  ? Image.memory(_receiptBytes!, fit: BoxFit.cover)
                  : _receipt != null
                      ? Image.file(File(_receipt!.path), fit: BoxFit.cover)
                      : Image.network(
                          savedUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => ColoredBox(
                            color: context.colors.surfaceContainerHighest,
                            child: Center(
                              child: Text(
                                l10n.txFormReceiptFailed,
                                style: AppTypography.labelSm.copyWith(
                                  color: context.colors.onSurfaceVariant,
                                ),
                              ),
                            ),
                          ),
                        ),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
        ],
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            OutlinedButton.icon(
              onPressed: () => _pickReceipt(ImageSource.camera),
              icon: const Icon(Icons.photo_camera_outlined, size: 18),
              label: Text(hasReceipt
                  ? l10n.txFormReceiptReplace
                  : l10n.txFormReceiptShoot),
            ),
            OutlinedButton.icon(
              onPressed: () => _pickReceipt(ImageSource.gallery),
              icon: const Icon(Icons.photo_library_outlined, size: 18),
              label: Text(l10n.txFormReceiptFromGallery),
            ),
            if (hasReceipt)
              TextButton.icon(
                onPressed: _removeReceipt,
                icon: const Icon(Icons.close, size: 18),
                label: Text(l10n.txFormReceiptRemove),
                style: TextButton.styleFrom(foregroundColor: AppColors.error),
              ),
          ],
        ),
      ],
    );
  }

  Future<void> _pickReceipt(ImageSource source) async {
    try {
      final image = await _imagePicker.pickImage(
        source: source,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );
      if (image == null) return;

      final bytes = kIsWeb ? await image.readAsBytes() : null;
      setState(() {
        _receipt = image;
        _receiptBytes = bytes;
        _receiptRemoved = false;
        _touched = true;
      });
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.l10n.txFormReceiptFailed),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  void _removeReceipt() {
    setState(() {
      _receipt = null;
      _receiptBytes = null;
      _receiptRemoved = true;
      _touched = true;
    });
  }
}
