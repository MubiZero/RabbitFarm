import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/countries/farm_currency.dart';
import '../../../../core/export/share_file.dart';
import '../../../../core/l10n/date_locale.dart';
import '../../../../core/l10n/error_text.dart';
import '../../../../core/l10n/l10n_context.dart';
import '../../../../core/printing/print_html.dart';
import '../../../../core/theme/theme.dart';
import '../../../health/presentation/widgets/health_sheet_button.dart'
    show SheetPrinter, SheetSharer;
import '../providers/transactions_provider.dart';
import '../utils/finance_sheet.dart';
import '../utils/transaction_labels.dart';

/// «Книга доходов и расходов» — бумага в банк и таблица для Excel.
///
/// За кредитом и за субсидией просят бумагу: сколько пришло, сколько ушло.
/// До сих пор деньги из приложения не доставались никак, и их переписывали
/// в тетрадь руками.
class FinanceSheetButton extends ConsumerStatefulWidget {
  const FinanceSheetButton({
    super.key,
    this.printer = printHtmlSheet,
    this.sharer = shareCsvFile,
  });

  final SheetPrinter printer;
  final SheetSharer sharer;

  @override
  ConsumerState<FinanceSheetButton> createState() => _FinanceSheetButtonState();
}

/// Сколько операций забирать на лист. Тысяча — это больше, чем записывает за
/// год хозяйство на три сотни голов; лист за месяц в неё умещается с запасом.
const _sheetLimit = 1000;

class _FinanceSheetButtonState extends ConsumerState<FinanceSheetButton> {
  bool _busy = false;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: context.l10n.financeSheetAction,
      onPressed: _busy ? null : _pickPeriod,
      constraints: const BoxConstraints(
        minWidth: AppSizes.iconButton,
        minHeight: AppSizes.iconButton,
      ),
      icon: _busy
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : const Icon(Icons.description_outlined),
    );
  }

  /// Срок спрашивают всегда: в банк носят месяц или год, а не «то, что
  /// открыто на экране». Угадывать за человека тут нечего.
  Future<void> _pickPeriod() async {
    final now = DateTime.now();
    final l10n = context.l10n;
    final periods = <(String, DateTime, DateTime)>[
      (
        l10n.kindlingPlanThisMonth,
        DateTime(now.year, now.month),
        DateTime(now.year, now.month + 1, 0),
      ),
      (
        l10n.financeSheetLastMonth,
        DateTime(now.year, now.month - 1),
        DateTime(now.year, now.month, 0),
      ),
      (
        l10n.financeSheetThisYear,
        DateTime(now.year),
        DateTime(now.year, 12, 31),
      ),
    ];

    final dayName = DateFormat(
      'd MMM y',
      dateSymbolsLocale(Localizations.localeOf(context)),
    );

    final chosen = await showModalBottomSheet<(DateTime, DateTime)>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screenH,
                0,
                AppSpacing.screenH,
                AppSpacing.sm,
              ),
              child: Text(
                sheetContext.l10n.financeSheetAction,
                style: AppTypography.titleMd.copyWith(
                  color: sheetContext.colors.onSurface,
                ),
              ),
            ),
            for (final (label, from, to) in periods)
              ListTile(
                // По строке попадают в перчатках — она выше обычной.
                minTileHeight: AppSizes.touchTargetLarge,
                leading: const Icon(Icons.event_note_outlined),
                title: Text(label),
                subtitle: Text('${dayName.format(from)} — ${dayName.format(to)}'),
                onTap: () => Navigator.of(sheetContext).pop((from, to)),
              ),
          ],
        ),
      ),
    );

    if (chosen != null) await _pickWay(chosen.$1, chosen.$2);
  }

  /// Бумага и таблица — разные нужды: первую несут в банк, вторую сводят
  /// у себя в Excel.
  Future<void> _pickWay(DateTime from, DateTime to) async {
    final chosen = await showModalBottomSheet<bool>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ListTile(
              minTileHeight: AppSizes.touchTargetLarge,
              leading: const Icon(Icons.print_outlined),
              title: Text(sheetContext.l10n.healthSheetPrint),
              onTap: () => Navigator.of(sheetContext).pop(true),
            ),
            ListTile(
              minTileHeight: AppSizes.touchTargetLarge,
              leading: const Icon(Icons.table_view_outlined),
              title: Text(sheetContext.l10n.healthSheetShare),
              onTap: () => Navigator.of(sheetContext).pop(false),
            ),
          ],
        ),
      ),
    );

    if (chosen != null) await _build(from, to, print: chosen);
  }

  Future<void> _build(DateTime from, DateTime to, {required bool print}) async {
    // Тексты, локаль и валюта снимаются до запроса: пока идёт загрузка,
    // вкладку могут переключить, и `context` до конца работы не доживёт.
    final l10n = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    final dateLocale = dateSymbolsLocale(Localizations.localeOf(context));
    final currency = context.currencySymbol;
    final categories = categoryTexts(l10n);
    final types = typeTexts(l10n);

    setState(() => _busy = true);
    try {
      // Операции берутся отдельным запросом за весь срок: на экране лежит
      // только первая страница списка, и книга, собранная из неё, показала
      // бы банку неверный итог.
      final transactions =
          await ref.read(transactionsRepositoryProvider).getTransactions(
                page: 1,
                limit: _sheetLimit,
                fromDate: from,
                toDate: to,
              );

      final fileName =
          'finance-${DateFormat('yyyy-MM-dd').format(from)}_${DateFormat('yyyy-MM-dd').format(to)}';

      if (print) {
        await widget.printer(
          html: buildFinanceSheetHtml(
            transactions: transactions,
            from: from,
            to: to,
            l10n: l10n,
            dateLocale: dateLocale,
            currency: currency,
            categoryLabel: (category) => categories[category]!,
          ),
          documentName: fileName,
        );
      } else {
        await widget.sharer(
          csv: buildFinanceSheetCsv(
            transactions: transactions,
            l10n: l10n,
            categoryLabel: (category) => categories[category]!,
            typeLabel: (type) => types[type]!,
          ),
          fileName: fileName,
          subject: l10n.exportShareSubject(l10n.financeSheetTitle),
        );
      }
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(
          content: Text(l10n.commonActionFailed(errorText(l10n, e))),
          backgroundColor: AppColors.error,
        ),
      );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }
}
