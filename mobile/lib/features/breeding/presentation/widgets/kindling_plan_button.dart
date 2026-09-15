import 'package:flutter/material.dart';

import '../../../../core/printing/print_html.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/l10n/date_locale.dart';
import '../../../../core/l10n/error_text.dart';
import '../../../../core/l10n/l10n_context.dart';
import '../../../../core/theme/theme.dart';
import '../../../rabbits/data/models/breeding_model.dart';
import '../../domain/kindling_plan.dart';
import '../providers/breeding_provider.dart';
import '../utils/kindling_plan_sheet.dart';

/// Куда уходит собранный лист. В приложении — в системный диалог печати и
/// «поделиться», в тесте — в подмену: платформенный диалог не открыть без
/// устройства, а проверять надо именно то, что на бумаге.
typedef KindlingSheetPrinter = Future<void> Function(
    {required String html, required String documentName});

/// Кнопка «План окролов»: лист на месяц, который печатают и вешают в сарае.
///
/// Приложение в крольчатнике достают не всегда — руки в перчатках, телефон в
/// кармане. Бумага на гвозде отвечает на главный вопрос месяца: когда какой
/// самке ставить маточник.
class KindlingPlanButton extends ConsumerStatefulWidget {
  final KindlingSheetPrinter printer;

  const KindlingPlanButton({super.key, this.printer = printHtmlSheet});

  @override
  ConsumerState<KindlingPlanButton> createState() => _KindlingPlanButtonState();
}

class _KindlingPlanButtonState extends ConsumerState<KindlingPlanButton> {
  bool _busy = false;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: context.l10n.kindlingPlanAction,
      onPressed: _busy ? null : _pickMonth,
      constraints: const BoxConstraints(
        minWidth: AppSizes.iconButton,
        minHeight: AppSizes.iconButton,
      ),
      icon: _busy
          // Сбор плана — это запрос к серверу. Без ответа на нажатие кажется,
          // что кнопка не сработала, и по ней жмут ещё раз.
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : const Icon(Icons.print_outlined),
    );
  }

  /// Месяц спрашивают всегда: 28-го числа план на текущий месяц уже почти
  /// пустой, а нужен как раз следующий — угадывать за фермера тут нечего.
  Future<void> _pickMonth() async {
    final now = DateTime.now();
    final months = [
      (DateTime(now.year, now.month), context.l10n.kindlingPlanThisMonth),
      (DateTime(now.year, now.month + 1), context.l10n.kindlingPlanNextMonth),
    ];
    final monthName = DateFormat(
      'LLLL y',
      dateSymbolsLocale(Localizations.localeOf(context)),
    );

    final chosen = await showModalBottomSheet<DateTime>(
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
                sheetContext.l10n.kindlingPlanPickMonth,
                style: AppTypography.titleMd.copyWith(
                  color: sheetContext.colors.onSurface,
                ),
              ),
            ),
            for (final (month, label) in months)
              ListTile(
                // По кнопке попадают в перчатках — строка выше обычной.
                minTileHeight: AppSizes.touchTargetLarge,
                leading: const Icon(Icons.event_note_outlined),
                title: Text(label),
                subtitle: Text(monthName.format(month)),
                onTap: () => Navigator.of(sheetContext).pop(month),
              ),
          ],
        ),
      ),
    );

    if (chosen != null) await _print(chosen);
  }

  Future<void> _print(DateTime month) async {
    // Тексты и локаль снимаются до запроса: пока идёт загрузка, вкладку могут
    // переключить, и `context` до конца работы не доживёт.
    final l10n = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    final dateLocale = dateSymbolsLocale(Localizations.localeOf(context));
    final monthName = DateFormat('LLLL y', dateLocale).format(month);

    setState(() => _busy = true);
    try {
      // Лента держит только первую страницу списка, а плану нужен весь месяц,
      // поэтому случки берутся отдельным запросом. Незакрытых случек на ферме
      // столько, сколько сукрольных самок, — десятки, а не тысячи.
      final page = await ref.read(breedingRepositoryProvider).getBreedings(
            page: 1,
            limit: 200,
            status: BreedingStatus.planned.value,
          );

      final rows = kindlingPlanForMonth(page.items, month: month);
      if (rows.isEmpty) {
        // Пустой лист на гвозде — обман: человек решит, что окролов не будет,
        // хотя на деле не нашлось ни одной записи. Лучше сказать это словами.
        messenger.showSnackBar(
          SnackBar(content: Text(l10n.kindlingPlanEmpty(monthName))),
        );
        return;
      }

      await widget.printer(
        html: buildKindlingPlanHtml(
          rows: rows,
          month: month,
          l10n: l10n,
          dateLocale: dateLocale,
        ),
        documentName:
            'kindling-plan-${month.year}-${month.month.toString().padLeft(2, '0')}',
      );
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
