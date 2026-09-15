import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/l10n/l10n_context.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/utils/format_utils.dart';
import '../../../../core/voice/voice_input.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../finance/data/models/transaction_model.dart';
import '../../../finance/presentation/providers/transactions_provider.dart';
import '../../data/models/rabbit_model.dart';
import '../providers/rabbits_provider.dart';
import '../widgets/rabbit_picker.dart';

/// Записать продажу кролика.
///
/// Связь «кролик — деньги» работала только в одну сторону: приход категории
/// «продажа» переводил кролика в проданные, а обратный путь — выбрать статус
/// «Продан» в общей форме — не оставлял ни строчки в книге. Ферма теряла
/// главный свой доход ровно тем способом, которым его удобнее всего
/// записать.
///
/// Поэтому продажа оформляется той стороной, где она уже работает: заводим
/// приход за кролика, и сервер сам переводит его в проданные и ставит день
/// продажи.
class SaleFormScreen extends ConsumerStatefulWidget {
  const SaleFormScreen({super.key, this.rabbit});

  /// Кролик, с карточки которого пришли. Пусто — если открыли из общего
  /// списка и выбирать его надо здесь.
  final RabbitModel? rabbit;

  @override
  ConsumerState<SaleFormScreen> createState() => _SaleFormScreenState();
}

class _SaleFormScreenState extends ConsumerState<SaleFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amount = TextEditingController();
  final _buyer = TextEditingController();

  RabbitModel? _rabbit;
  DateTime _date = DateTime.now();
  bool _touched = false;

  @override
  void initState() {
    super.initState();
    _rabbit = widget.rabbit;
  }

  @override
  void dispose() {
    _amount.dispose();
    _buyer.dispose();
    super.dispose();
  }

  Future<Object?> _save() async {
    final rabbit = _rabbit;
    if (rabbit == null) return context.l10n.rabbitPickerRequired;

    final buyer = _buyer.text.trim();

    try {
      await ref.read(transactionsRepositoryProvider).createTransaction(
            TransactionCreate(
              type: TransactionType.income,
              // Ровно эта категория переводит кролика в проданные на сервере
              // (`transactionService`): другая оставила бы деньги в книге, а
              // кролика — в поголовье.
              category: TransactionCategory.saleRabbit,
              amount: parseDecimal(_amount.text) ?? 0,
              transactionDate: _date,
              rabbitId: rabbit.id,
              description: buyer.isEmpty ? null : buyer,
            ),
          );

      // Кролик изменился на сервере — в списке и карточке он ещё живой.
      ref.invalidate(rabbitsListProvider);
      ref.invalidate(rabbitDetailProvider(rabbit.id));
      ref.read(transactionsProvider.notifier).refresh();
      return null;
    } catch (e) {
      return e;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return AppFormScaffold(
      title: l10n.saleFormTitle,
      formKey: _formKey,
      submitLabel: l10n.saleFormSubmit,
      successMessage: l10n.saleFormSaved,
      onSubmit: _save,
      isDirty: () => _touched,
      children: [
        AppFormSection(
          title: l10n.commonSectionMain,
          children: [
            RabbitPickerField(
              label: l10n.saleFormRabbit,
              selected: _rabbit,
              // С карточки кролика менять его незачем: человек пришёл
              // продать конкретного.
              enabled: widget.rabbit == null,
              required: true,
              onChanged: (rabbit) => setState(() {
                _rabbit = rabbit;
                _touched = true;
              }),
            ),
            const SizedBox(height: AppSpacing.lg),
            TextFormField(
              controller: _amount,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              onChanged: (_) => _touched = true,
              decoration: InputDecoration(
                labelText: l10n.saleFormAmount,
                prefixIcon: const Icon(Icons.payments_outlined),
                // Продажа без суммы — это просто списание кролика из
                // поголовья, а человек пришёл записать доход.
                helperText: l10n.saleFormAmountHelp,
                helperMaxLines: 2,
              ),
              validator: (v) {
                final amount = parseDecimal(v ?? '');
                if (amount == null || amount <= 0) {
                  return l10n.saleFormAmountEmpty;
                }
                return null;
              },
            ),
            AppDateField(
              label: l10n.saleFormDate,
              value: _date,
              lastDate: DateTime.now(),
              prefixIcon: Icons.event_outlined,
              onChanged: (date) => setState(() {
                _date = date;
                _touched = true;
              }),
            ),
          ],
        ),
        AppFormSection(
          title: l10n.commonSectionDetails,
          children: [
            TextFormField(
              controller: _buyer,
              maxLines: 2,
              textCapitalization: TextCapitalization.sentences,
              onChanged: (_) => _touched = true,
              decoration: InputDecoration(
                labelText: l10n.saleFormBuyer,
                hintText: l10n.saleFormBuyerHint,
                prefixIcon: const Icon(Icons.notes_outlined),
                suffixIcon: VoiceInputButton(
                  controller: _buyer,
                  onChanged: () => _touched = true,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
