import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/export/share_file.dart';
import '../../../../core/l10n/date_locale.dart';
import '../../../../core/l10n/error_text.dart';
import '../../../../core/l10n/l10n_context.dart';
import '../../../../core/printing/print_html.dart';
import '../../../../core/theme/theme.dart';
import '../../../rabbits/data/models/rabbit_model.dart';
import '../../data/repositories/vaccinations_repository.dart';
import '../providers/medical_records_provider.dart';
import '../utils/health_sheet.dart';
import '../../../rabbits/presentation/utils/rabbit_labels.dart';
import '../utils/medical_labels.dart';

/// Куда уходит собранная карта. В приложении — в системный диалог печати или
/// «поделиться», в тесте — в подмену: платформенный диалог без устройства не
/// открыть, а проверять надо то, что в нём окажется.
typedef SheetPrinter = Future<void> Function(
    {required String html, required String documentName});
typedef SheetSharer = Future<void> Function(
    {required String csv, required String fileName, required String subject});

/// «Карта здоровья» — то, что несут ветеринару или открывают в Excel.
///
/// Ветеринар не работает в чужом приложении: он смотрит бумагу и спрашивает
/// «чем кололи и когда». До сих пор ответ лежал в приложении и не доставался
/// оттуда никак.
class HealthSheetButton extends ConsumerStatefulWidget {
  const HealthSheetButton({
    super.key,
    required this.rabbit,
    this.printer = printHtmlSheet,
    this.sharer = shareCsvFile,
  });

  final RabbitModel rabbit;
  final SheetPrinter printer;
  final SheetSharer sharer;

  @override
  ConsumerState<HealthSheetButton> createState() => _HealthSheetButtonState();
}

class _HealthSheetButtonState extends ConsumerState<HealthSheetButton> {
  bool _busy = false;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: context.l10n.healthSheetAction,
      onPressed: _busy ? null : _pickWay,
      constraints: const BoxConstraints(
        minWidth: AppSizes.iconButton,
        minHeight: AppSizes.iconButton,
      ),
      icon: _busy
          // Сбор карты — это два запроса к серверу. Без ответа на нажатие
          // кажется, что кнопка не сработала, и по ней жмут ещё раз.
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : const Icon(Icons.description_outlined),
    );
  }

  /// Бумага и таблица — разные нужды: первую несут ветеринару, вторую
  /// открывают у себя в Excel. Спрашиваем, а не решаем за человека.
  Future<void> _pickWay() async {
    final chosen = await showModalBottomSheet<bool>(
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
                sheetContext.l10n.healthSheetAction,
                style: AppTypography.titleMd.copyWith(
                  color: sheetContext.colors.onSurface,
                ),
              ),
            ),
            ListTile(
              // По строке попадают в перчатках — она выше обычной.
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

    if (chosen != null) await _build(print: chosen);
  }

  Future<void> _build({required bool print}) async {
    // Тексты и локаль снимаются до запроса: пока идёт загрузка, экран могут
    // закрыть, и `context` до конца работы не доживёт.
    final l10n = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    final dateLocale = dateSymbolsLocale(Localizations.localeOf(context));

    setState(() => _busy = true);
    try {
      // Оба списка — целиком по этому кролику, отдельными запросами: на
      // экране лежит только первая страница общего списка, и карта,
      // собранная из неё, молча потеряла бы половину истории.
      final vaccinations = await ref
          .read(vaccinationsRepositoryProvider)
          .getRabbitVaccinations(widget.rabbit.id);
      final treatments = await ref
          .read(medicalRecordsRepositoryProvider)
          .getRabbitMedicalRecords(widget.rabbit.id);

      if (vaccinations.isEmpty && treatments.isEmpty) {
        // Пустой лист обманывает: человек решит, что прививок не делали,
        // хотя на деле их просто не записывали в приложение.
        messenger.showSnackBar(
          SnackBar(content: Text(l10n.healthSheetEmpty)),
        );
        return;
      }

      final rabbit = HealthSheetRabbit(
        name: widget.rabbit.label,
        tagId: widget.rabbit.tagId,
        breed: widget.rabbit.breed?.name,
        sex: sexText(l10n, widget.rabbit.sex),
        birthDate: widget.rabbit.birthDate,
        weight: widget.rabbit.currentWeight,
      );
      final fileName = 'health-${widget.rabbit.id}';

      if (print) {
        await widget.printer(
          html: buildHealthSheetHtml(
            rabbit: rabbit,
            vaccinations: vaccinations,
            treatments: treatments,
            l10n: l10n,
            dateLocale: dateLocale,
            outcomeLabel: (outcome) => medicalOutcomeText(l10n, outcome),
          ),
          documentName: fileName,
        );
      } else {
        await widget.sharer(
          csv: buildHealthSheetCsv(
            rabbit: rabbit,
            vaccinations: vaccinations,
            treatments: treatments,
            l10n: l10n,
            outcomeLabel: (outcome) => medicalOutcomeText(l10n, outcome),
          ),
          fileName: fileName,
          subject: l10n.exportShareSubject(
            l10n.healthSheetTitle(widget.rabbit.label),
          ),
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
