import 'package:flutter/material.dart';

import '../l10n/l10n_context.dart';
import 'app_filter_bar.dart';

/// Период, за который считается статистика.
///
/// Подписи берутся из переводов, а не из значения перечисления: окончания
/// числительных зависят от языка, и «3 месяца» нельзя было записать
/// константой.
enum StatsPeriod {
  month(30),
  quarter(90),
  year(365),
  all(null);

  const StatsPeriod(this.days);

  final int? days;

  String label(BuildContext context) => switch (this) {
        StatsPeriod.month => context.l10n.periodDays(30),
        StatsPeriod.quarter => context.l10n.periodMonths(3),
        StatsPeriod.year => context.l10n.periodYear,
        StatsPeriod.all => context.l10n.periodAll,
      };

  /// Начало периода; `null` — без ограничения снизу.
  ///
  /// Округлено до начала дня осознанно: значение попадает в ключ провайдера,
  /// и время с точностью до миллисекунды давало бы новый ключ на каждой
  /// перестройке — экран уходил бы в бесконечную загрузку и дёргал API.
  DateTime? get fromDate {
    if (days == null) return null;
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day)
        .subtract(Duration(days: days!));
  }
}

/// Выбор периода для экранов статистики.
class StatsPeriodBar extends StatelessWidget {
  final StatsPeriod selected;
  final ValueChanged<StatsPeriod> onChanged;

  const StatsPeriodBar({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return AppFilterBar(
      chips: [
        for (final period in StatsPeriod.values)
          AppFilterChipData(
            label: period.label(context),
            isSelected: period == selected,
            onTap: () => onChanged(period),
          ),
      ],
    );
  }
}
