import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/access/farm_access.dart';
import '../../../../core/l10n/l10n_context.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../providers/reports_provider.dart';
import '../widgets/farm_report_view.dart';
import '../widgets/financial_report_view.dart';
import '../widgets/health_report_view.dart';
import '../widgets/report_sections.dart';

/// Какой отчёт открыт.
enum _ReportKind { farm, health, finance }

/// Отчёты по ферме, здоровью и деньгам.
///
/// Сервер считает эти три отчёта с самого начала, модели и провайдеры под них
/// в приложении тоже были — а на экране стояла заглушка «записей нет». Работа
/// была оплачена с обеих сторон и не видна никому.
///
/// Раздел переключается сегментами, а не ещё одним рядом чипов: чипы на этом
/// экране уже заняты периодом, и два одинаковых ряда подряд не дали бы понять,
/// который из них меняет отчёт, а который отрезок времени. Сегменты в
/// приложении для этого уже используются — так устроен выбор вида на «Стаде».
class ReportsScreen extends ConsumerStatefulWidget {
  const ReportsScreen({super.key});

  @override
  ConsumerState<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends ConsumerState<ReportsScreen> {
  _ReportKind _kind = _ReportKind.farm;
  StatsPeriod _period = StatsPeriod.month;

  /// Дата уходит в запрос строкой «2026-08-21» — так её ждут остальные
  /// разделы API.
  String? get _fromDate =>
      _period.fromDate?.toIso8601String().split('T').first;

  @override
  Widget build(BuildContext context) {
    // Финансы сервер работнику не отдаёт. Раздел, который заведомо приведёт к
    // отказу, читается как поломка, поэтому его просто нет.
    final canFinance = ref.watch(canProvider(FarmCapability.manageFinance));
    // Роль может смениться, пока экран открыт: тогда открытый финансовый
    // отчёт нужно закрыть, а не оставлять его без кнопки возврата.
    final kind = _kind == _ReportKind.finance && !canFinance
        ? _ReportKind.farm
        : _kind;

    final params = ReportDateParams(fromDate: _fromDate);

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.reportsTitle)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.screenH,
              AppSpacing.md,
              AppSpacing.screenH,
              0,
            ),
            child: SizedBox(
              width: double.infinity,
              child: SegmentedButton<_ReportKind>(
                segments: [
                  ButtonSegment(
                    value: _ReportKind.farm,
                    label: Text(context.l10n.reportsTabFarm),
                  ),
                  ButtonSegment(
                    value: _ReportKind.health,
                    label: Text(context.l10n.reportsTabHealth),
                  ),
                  if (canFinance)
                    ButtonSegment(
                      value: _ReportKind.finance,
                      label: Text(context.l10n.reportsTabFinance),
                    ),
                ],
                selected: {kind},
                showSelectedIcon: false,
                onSelectionChanged: (selection) =>
                    setState(() => _kind = selection.first),
              ),
            ),
          ),
          // Период общий для всех трёх отчётов: переключая раздел, человек
          // сравнивает один и тот же отрезок времени, а не выбирает его заново.
          ReportPeriodBar(
            selected: _period,
            onChanged: (period) => setState(() => _period = period),
          ),
          Expanded(
            child: switch (kind) {
              _ReportKind.farm => FarmReportView(params: params),
              _ReportKind.health => HealthReportView(params: params),
              _ReportKind.finance => FinancialReportView(
                  params: FinancialReportParams(fromDate: _fromDate),
                ),
            },
          ),
        ],
      ),
    );
  }
}
