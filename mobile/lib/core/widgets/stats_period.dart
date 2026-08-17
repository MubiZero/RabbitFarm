import 'package:flutter/material.dart';
import 'app_filter_bar.dart';

/// Период, за который считается статистика.
enum StatsPeriod {
  month('30 дней', 30),
  quarter('3 месяца', 90),
  year('Год', 365),
  all('Всё время', null);

  const StatsPeriod(this.label, this.days);

  final String label;
  final int? days;

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
            label: period.label,
            isSelected: period == selected,
            onTap: () => onChanged(period),
          ),
      ],
    );
  }
}
