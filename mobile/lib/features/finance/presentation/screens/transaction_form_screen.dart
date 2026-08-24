import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/access/farm_access.dart';
import '../../../../core/l10n/l10n_context.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/utils/format_utils.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../rabbits/data/models/rabbit_model.dart';
import '../../../rabbits/presentation/widgets/rabbit_picker.dart';
import '../../data/models/transaction_model.dart';
import '../providers/transactions_provider.dart';
import '../utils/transaction_labels.dart';
import '../../../../core/l10n/error_text.dart';

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
  bool _touched = false;

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
            ),
          )).future,
        );
      } else {
        await ref.read(
          createTransactionProvider(TransactionCreate(
            type: _type,
            category: _category,
            amount: amount,
            transactionDate: _date,
            rabbitId: _rabbitId,
            description: description,
          )).future,
        );
      }
      await ref.read(transactionsProvider.notifier).refresh();
      return null;
    } catch (e) {
      return e;
    }
  }

  Future<void> _delete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l10n.financeDeleteTitle),
        content: Text(context.l10n.financeDeleteBody),
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
    final done = context.l10n.financeDeleted;
    final failed = context.l10n.financeDeleteFailed;
    final l10n = context.l10n;

    try {
      await ref.read(deleteTransactionProvider(_record!.id).future);
      ref.read(transactionsProvider.notifier).removeTransaction(_record!.id);
      messenger.showSnackBar(SnackBar(content: Text(done)));
      if (navigator.canPop()) navigator.pop();
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(
          content:
              Text('$failed: ${errorText(l10n, e)}'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final canDelete = ref.watch(canProvider(FarmCapability.deleteRecords));

    return AppFormScaffold(
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
                suffixText: '₽',
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
          ],
        ),
      ],
    );
  }
}
