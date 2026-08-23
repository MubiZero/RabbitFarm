import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/l10n_context.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../../data/models/report_model.dart';
import '../providers/reports_provider.dart';
import 'report_sections.dart';

/// Отчёт по здоровью: чем и сколько прививали и чем закончились лечения.
class HealthReportView extends ConsumerWidget {
  final ReportDateParams params;

  const HealthReportView({super.key, required this.params});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reportAsync = ref.watch(healthReportProvider(params));

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(healthReportProvider(params));
        await ref.read(healthReportProvider(params).future);
      },
      child: AppAsyncView<HealthReport>(
        value: reportAsync,
        onRetry: () => ref.invalidate(healthReportProvider(params)),
        skeleton: (_) => const ReportSkeleton(),
        builder: (report) => _content(context, report),
      ),
    );
  }

  Widget _content(BuildContext context, HealthReport report) {
    final vaccinations = report.vaccinations.byType;
    final records = report.medicalRecords.byOutcome;

    if (vaccinations.isEmpty && records.isEmpty) {
      return AppEmptyState(
        icon: Icons.vaccines_outlined,
        title: context.l10n.reportsHealthEmptyTitle,
        subtitle: context.l10n.reportsHealthEmptyBody,
        actionLabel: context.l10n.vaccinationsEmptyAction,
        onAction: () => context.push('/vaccinations/form'),
      );
    }

    final vaccinationsTotal =
        vaccinations.fold<int>(0, (sum, item) => sum + item.count);
    final recordsTotal = records.fold<int>(0, (sum, item) => sum + item.count);

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenH,
        AppSpacing.sm,
        AppSpacing.screenH,
        AppSpacing.xxl,
      ),
      children: [
        Row(
          children: [
            Expanded(
              child: StatTile(
                icon: Icons.vaccines_outlined,
                label: context.l10n.reportsVaccinations,
                value: '$vaccinationsTotal',
                accent: AppColors.domainHealth,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: StatTile(
                icon: Icons.medical_services_outlined,
                label: context.l10n.reportsMedicalRecords,
                value: '$recordsTotal',
                accent: AppColors.warning,
              ),
            ),
          ],
        ),
        if (vaccinations.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.xl),
          ReportBreakdown(
            title: context.l10n.reportsVaccinesByName,
            color: AppColors.domainHealth,
            items: [
              for (final item in vaccinations)
                ReportBreakdownItem(
                  label: item.vaccineName,
                  value: '${item.count}',
                  amount: item.count.toDouble(),
                ),
            ],
          ),
        ],
        if (records.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.xl),
          ReportBreakdown(
            title: context.l10n.reportsRecordsByOutcome,
            color: AppColors.warning,
            items: [
              for (final item in records)
                ReportBreakdownItem(
                  label: _outcomeLabel(context, item.outcome),
                  value: '${item.count}',
                  amount: item.count.toDouble(),
                ),
            ],
          ),
        ],
      ],
    );
  }
}

/// Подпись группы медзаписей.
///
/// Сервер группирует лечения по исходу и присылает код («recovered»), а
/// незнакомый код показываем как есть: свести его к «прочему» — значит
/// молча слить новую группу с настоящей.
String _outcomeLabel(BuildContext context, String? code) => switch (code) {
      'ongoing' => context.l10n.medOutcomeOngoing,
      'recovered' => context.l10n.medOutcomeRecovered,
      'died' => context.l10n.medOutcomeDied,
      'euthanized' => context.l10n.medOutcomeEuthanized,
      null || '' => context.l10n.reportsOutcomeUnknown,
      _ => code,
    };
