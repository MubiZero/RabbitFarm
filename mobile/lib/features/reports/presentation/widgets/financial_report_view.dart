import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/l10n_context.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/utils/format_utils.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../finance/data/models/transaction_model.dart';
import '../../../finance/presentation/utils/transaction_labels.dart';
import '../../data/models/report_model.dart';
import '../providers/reports_provider.dart';
import 'report_sections.dart';

/// Финансовый отчёт: доход, расход, итог и структура по категориям.
///
/// Раздел видят только те, кому доступны финансы: сервер закрывает финансы
/// работнику, и кнопка, ведущая к отказу, читалась бы как поломка. Права
/// проверяются на экране отчётов, где собираются разделы.
class FinancialReportView extends ConsumerWidget {
  final FinancialReportParams params;

  const FinancialReportView({super.key, required this.params});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reportAsync = ref.watch(financialReportProvider(params));

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(financialReportProvider(params));
        await ref.read(financialReportProvider(params).future);
      },
      child: AppAsyncView<FinancialReport>(
        value: reportAsync,
        onRetry: () => ref.invalidate(financialReportProvider(params)),
        skeleton: (_) => const ReportSkeleton(),
        builder: (report) => _content(context, report),
      ),
    );
  }

  Widget _content(BuildContext context, FinancialReport report) {
    final summary = report.summary;

    if (report.byCategory.isEmpty &&
        summary.totalIncome == 0 &&
        summary.totalExpenses == 0) {
      return AppEmptyState(
        icon: Icons.query_stats,
        title: context.l10n.financeStatsEmptyTitle,
        subtitle: context.l10n.financeStatsEmptyBody,
        actionLabel: context.l10n.financeAdd,
        onAction: () => context.push('/transactions/form'),
      );
    }

    final income = report.byCategory.where((item) => item.type == 'income');
    final expenses = report.byCategory.where((item) => item.type == 'expense');

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenH,
        AppSpacing.sm,
        AppSpacing.screenH,
        AppSpacing.xxl,
      ),
      children: [
        ReportMoneySummary(
          income: summary.totalIncome,
          expenses: summary.totalExpenses,
          netProfit: summary.netProfit,
        ),
        if (income.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.xl),
          ReportBreakdown(
            title: context.l10n.financeIncomeByCategory,
            color: AppColors.success,
            items: [for (final item in income) _item(context, item)],
          ),
        ],
        if (expenses.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.xl),
          ReportBreakdown(
            title: context.l10n.financeExpensesByCategory,
            color: AppColors.error,
            items: [for (final item in expenses) _item(context, item)],
          ),
        ],
      ],
    );
  }

  ReportBreakdownItem _item(BuildContext context, CategoryData data) {
    final category = _categoryByCode[data.category];

    return ReportBreakdownItem(
      label: category == null
          ? data.category
          : transactionCategoryLabel(context, category),
      value: formatMoney(data.total),
      amount: data.total,
      icon: category?.icon,
    );
  }
}

/// Коды категорий из ответа сервера.
///
/// Разбор кода в перечисление живёт в сгенерированном коде модели операций и
/// наружу не выведен, а отчёт приходит уже сгруппированным — с голыми
/// строками. Незнакомый код показываем как есть: подставить «Прочее» значило
/// бы слить новую категорию с настоящим «Прочим» и занизить её долю.
const _categoryByCode = <String, TransactionCategory>{
  'sale_rabbit': TransactionCategory.saleRabbit,
  'sale_meat': TransactionCategory.saleMeat,
  'sale_fur': TransactionCategory.saleFur,
  'breeding_fee': TransactionCategory.breedingFee,
  'feed': TransactionCategory.feed,
  'veterinary': TransactionCategory.veterinary,
  'equipment': TransactionCategory.equipment,
  'utilities': TransactionCategory.utilities,
  'other': TransactionCategory.other,
};
