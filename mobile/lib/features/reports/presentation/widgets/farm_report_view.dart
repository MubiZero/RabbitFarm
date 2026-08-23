import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/access/farm_access.dart';
import '../../../../core/l10n/l10n_context.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/utils/format_utils.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../feeding/presentation/utils/feed_labels.dart';
import '../../data/models/report_model.dart';
import '../providers/reports_provider.dart';
import 'report_sections.dart';

/// Отчёт по ферме: сколько кроликов, что происходило за период и во что это
/// обошлось.
///
/// Данные для него сервер отдавал с самого начала, а показывать их было
/// негде: единственным потребителем отчётов оставался экран «Сегодня» со
/// сводкой за сегодня.
class FarmReportView extends ConsumerWidget {
  final ReportDateParams params;

  const FarmReportView({super.key, required this.params});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reportAsync = ref.watch(farmReportProvider(params));

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(farmReportProvider(params));
        await ref.read(farmReportProvider(params).future);
      },
      child: AppAsyncView<FarmReport>(
        value: reportAsync,
        onRetry: () => ref.invalidate(farmReportProvider(params)),
        skeleton: (_) => const ReportSkeleton(),
        builder: (report) => _content(context, ref, report),
      ),
    );
  }

  Widget _content(BuildContext context, WidgetRef ref, FarmReport report) {
    // Финансы работнику закрыты на сервере, поэтому и в отчёте по ферме их
    // не показываем: строка «нет доступа» посреди сводки читается как поломка.
    final canFinance = ref.watch(canProvider(FarmCapability.manageFinance));
    final breedNames = ref.watch(reportBreedNamesProvider);

    final money = report.financial.summary;
    final hasMoney = money.totalIncome != 0 || money.totalExpenses != 0;
    final activity = [
      report.breeding.breedings,
      report.breeding.births,
      report.health.vaccinations,
      report.health.medicalRecords,
      report.feeding.totalFeedingRecords,
    ];
    final hasActivity = activity.any((count) => count > 0);

    if (report.population.totalRabbits == 0 &&
        !hasActivity &&
        !(canFinance && hasMoney)) {
      return AppEmptyState(
        icon: Icons.insights_outlined,
        title: context.l10n.reportsFarmEmptyTitle,
        subtitle: context.l10n.reportsFarmEmptyBody,
        actionLabel: context.l10n.quickAddRabbit,
        onAction: () => context.push('/rabbits/new'),
      );
    }

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenH,
        AppSpacing.sm,
        AppSpacing.screenH,
        AppSpacing.xxl,
      ),
      children: [
        ReportPeriodCaption(from: report.period.from, to: report.period.to),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: [
            Expanded(
              child: StatTile(
                icon: Icons.pets_outlined,
                // Поголовье — это «сколько сейчас», а не «сколько за период»:
                // сервер считает его на момент запроса.
                label: context.l10n.reportsPopulationNow,
                value: '${report.population.totalRabbits}',
                accent: AppColors.domainLivestock,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: StatTile(
                icon: Icons.child_friendly_outlined,
                label: context.l10n.reportsBirths,
                value: '${report.breeding.births}',
                accent: AppColors.domainBreeding,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xl),
        AppGroupLabel(context.l10n.reportsActivity),
        const SizedBox(height: AppSpacing.md),
        if (hasActivity)
          ReportFigureTable(
            figures: [
              ReportFigure(
                icon: Icons.favorite_outline,
                label: context.l10n.reportsBreedings,
                value: '${report.breeding.breedings}',
              ),
              ReportFigure(
                icon: Icons.vaccines_outlined,
                label: context.l10n.reportsVaccinations,
                value: '${report.health.vaccinations}',
              ),
              ReportFigure(
                icon: Icons.medical_services_outlined,
                label: context.l10n.reportsMedicalRecords,
                value: '${report.health.medicalRecords}',
              ),
              ReportFigure(
                icon: Icons.restaurant_outlined,
                label: context.l10n.reportsFeedings,
                value: '${report.feeding.totalFeedingRecords}',
              ),

              // Расход показан по каждой единице отдельно: сложить
              // килограммы со штуками нельзя, а прятать расход целиком
              // ради одного удобного числа значит выбросить то, что
              // сервер уже посчитал.
              for (final row in report.feeding.consumptionByUnit)
                ReportFigure(
                  icon: Icons.inventory_2_outlined,
                  label: context.l10n.reportsFeedUsed,
                  value: formatQuantity(row.total, unitLabel(row.unit)),
                ),
            ],
          )
        else
          AlertCard(
            icon: Icons.event_busy_outlined,
            color: context.colors.onSurfaceVariant,
            title: context.l10n.reportsNoActivityTitle,
            description: context.l10n.reportsNoActivityBody,
          ),
        if (report.population.byBreed.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.xl),
          ReportBreakdown(
            title: context.l10n.reportsByBreed,
            color: AppColors.domainLivestock,
            items: [
              for (final breed in report.population.byBreed)
                ReportBreakdownItem(
                  label: breedNames[breed.breedId] ??
                      context.l10n.reportsBreedUnknown(breed.breedId),
                  value: '${breed.count}',
                  amount: breed.count.toDouble(),
                ),
            ],
          ),
        ],
        if (canFinance) ...[
          const SizedBox(height: AppSpacing.xl),
          AppGroupLabel(context.l10n.reportsMoney),
          const SizedBox(height: AppSpacing.md),
          ReportMoneySummary(
            income: money.totalIncome,
            expenses: money.totalExpenses,
            // Сервер в этом отчёте итог не считает, а вычесть расход из
            // дохода — та же арифметика, что и в финансовом отчёте.
            netProfit: money.totalIncome - money.totalExpenses,
          ),
        ],
      ],
    );
  }
}
