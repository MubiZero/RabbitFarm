import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/l10n/l10n_context.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/utils/format_utils.dart';
import '../../../../core/widgets/widgets.dart';

/// Общие кирпичи трёх отчётов.
///
/// Ферма, здоровье и деньги показывают разные числа, но одинаково: строка
/// «показатель — значение», разбивка полосами, каркас загрузки. Собери каждую
/// отчёт сам по себе — и соседние разъедутся по виду ровно так же,
/// как когда-то разъехались экраны аналитики.

/// Выбор периода отчёта.
///
/// «Всё время» из [StatsPeriod] здесь намеренно нет: сервер, не получив
/// `from_date`, считает отчёт по ферме за последние 30 дней. Подпись обещала бы
/// историю фермы целиком, а цифры пришли бы за месяц — это хуже, чем не
/// предлагать такой выбор вовсе.
class ReportPeriodBar extends StatelessWidget {
  static const periods = [
    StatsPeriod.month,
    StatsPeriod.quarter,
    StatsPeriod.year,
  ];

  final StatsPeriod selected;
  final ValueChanged<StatsPeriod> onChanged;

  const ReportPeriodBar({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return AppFilterBar(
      chips: [
        for (final period in periods)
          AppFilterChipData(
            label: period.label(context),
            isSelected: period == selected,
            onTap: () => onChanged(period),
          ),
      ],
    );
  }
}

/// Границы периода, за который сервер посчитал отчёт.
///
/// Показываем именно серверные даты, а не выбранный чип: сервер вправе
/// подставить свои границы, и человек должен видеть, за что на самом деле
/// посчитаны числа под этой подписью.
class ReportPeriodCaption extends StatelessWidget {
  final String from;
  final String to;

  const ReportPeriodCaption({super.key, required this.from, required this.to});

  @override
  Widget build(BuildContext context) {
    return Text(
      context.l10n.reportsPeriodRange(_format(from), _format(to)),
      style: AppTypography.labelSm.copyWith(color: context.colors.onSurfaceVariant),
    );
  }

  /// Даты приходят строкой «2026-08-21». Неразобранную строку показываем как
  /// есть: подставить сегодняшнее число вместо непонятного значения — значит
  /// соврать о периоде.
  String _format(String raw) {
    final date = DateTime.tryParse(raw);
    if (date == null) return raw;
    return DateFormat('d MMMM yyyy', 'ru_RU').format(date);
  }
}

/// Одна строка столбца «показатель — число».
class ReportFigure {
  final IconData icon;
  final String label;
  final String value;

  const ReportFigure({
    required this.icon,
    required this.label,
    required this.value,
  });
}

/// Столбец показателей с числами по правому краю.
///
/// Цифры моноширинные: в столбце из шести значений разной длины
/// пропорциональные знаки съезжают друг относительно друга, и колонку
/// перестаёт быть видно как колонку.
class ReportFigureTable extends StatelessWidget {
  final List<ReportFigure> figures;

  const ReportFigureTable({super.key, required this.figures});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.sm,
      ),
      child: Column(
        children: [
          for (final figure in figures)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
              child: Row(
                children: [
                  Icon(figure.icon, size: 18, color: context.colors.onSurfaceVariant),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Text(
                      figure.label,
                      style: AppTypography.bodyMd
                          .copyWith(color: context.colors.onSurface),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    figure.value,
                    style: AppTypography.labelLg.copyWith(
                      color: context.colors.onSurface,
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

/// Одна доля разбивки: подпись, готовое к показу значение и число, по
/// которому доли сравниваются между собой.
class ReportBreakdownItem {
  final String label;
  final String value;
  final double amount;
  final IconData? icon;

  const ReportBreakdownItem({
    required this.label,
    required this.value,
    required this.amount,
    this.icon,
  });
}

/// Разбивка полосами: подпись группы и строки [MetricBar] от большего к
/// меньшему. Новых графических библиотек ради этого не нужно — полоса
/// сравнения в проекте уже есть.
class ReportBreakdown extends StatelessWidget {
  final String title;
  final List<ReportBreakdownItem> items;
  final Color color;

  const ReportBreakdown({
    super.key,
    required this.title,
    required this.items,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final sorted = [...items]..sort((a, b) => b.amount.compareTo(a.amount));
    final max = sorted.first.amount;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppGroupLabel(title),
        const SizedBox(height: AppSpacing.md),
        AppCard(
          child: Column(
            children: [
              for (final item in sorted)
                MetricBar(
                  icon: item.icon,
                  label: item.label,
                  value: item.value,
                  fraction: max <= 0 ? 0 : item.amount / max,
                  color: color,
                ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Каркас первой загрузки отчёта.
///
/// Повторяет геометрию готового отчёта — две плитки, столбец показателей и
/// разбивка, — чтобы при подстановке чисел ничего не прыгало.
class ReportSkeleton extends StatelessWidget {
  const ReportSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenH,
        AppSpacing.sm,
        AppSpacing.screenH,
        AppSpacing.xxl,
      ),
      children: const [
        SkeletonBox(width: 200, height: 12),
        SizedBox(height: AppSpacing.lg),
        SkeletonStatRow(),
        SizedBox(height: AppSpacing.xl),
        SkeletonBox(width: 160, height: 12),
        SizedBox(height: AppSpacing.md),
        SkeletonBox(height: 200, borderRadius: AppRadius.lgAll),
        SizedBox(height: AppSpacing.xl),
        SkeletonBox(width: 160, height: 12),
        SizedBox(height: AppSpacing.md),
        SkeletonBox(height: 180, borderRadius: AppRadius.lgAll),
      ],
    );
  }
}

/// Деньги за период: доход, расход и итог.
///
/// Общий блок для вкладок «Ферма» и «Деньги» — в отчёте по ферме те же
/// суммы стоят рядом с поголовьем, и показывать их двумя разными способами
/// значило бы заставлять сверять одинаковые числа глазами.
class ReportMoneySummary extends StatelessWidget {
  final double income;
  final double expenses;
  final double netProfit;

  const ReportMoneySummary({
    super.key,
    required this.income,
    required this.expenses,
    required this.netProfit,
  });

  @override
  Widget build(BuildContext context) {
    final isProfit = netProfit >= 0;

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: StatTile(
                icon: Icons.arrow_upward,
                label: context.l10n.financeIncome,
                value: formatMoney(income),
                accent: AppColors.success,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: StatTile(
                icon: Icons.arrow_downward,
                label: context.l10n.financeExpenses,
                value: formatMoney(expenses),
                accent: AppColors.error,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        AppCard(
          variant: isProfit ? AppCardVariant.highlighted : AppCardVariant.error,
          child: Row(
            children: [
              Icon(
                isProfit ? Icons.trending_up : Icons.trending_down,
                color: isProfit ? AppColors.success : AppColors.error,
                size: 28,
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isProfit
                          ? context.l10n.financeProfit
                          : context.l10n.financeLoss,
                      style: AppTypography.labelSm
                          .copyWith(color: context.colors.onSurfaceVariant),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      formatMoney(netProfit.abs()),
                      style: AppTypography.displayMd.copyWith(
                        color: isProfit ? AppColors.success : AppColors.error,
                        fontFeatures: const [FontFeature.tabularFigures()],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
