import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppDateField extends StatelessWidget {
  final String label;

  /// Пусто — дата не выбрана. Такое поле показывает [placeholder] вместо
  /// числа: у необязательной даты «не указана» — это ответ, а подставленное
  /// сегодняшнее число было бы выдумкой.
  final DateTime? value;
  final ValueChanged<DateTime> onChanged;
  final IconData prefixIcon;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final bool showTime;

  /// Что писать вместо числа, пока даты нет.
  final String? placeholder;

  /// Убрать дату. Задан — рядом появляется крестик: иначе однажды
  /// проставленную необязательную дату нельзя было бы снять.
  final VoidCallback? onCleared;

  const AppDateField({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.prefixIcon = Icons.calendar_today,
    this.firstDate,
    this.lastDate,
    this.showTime = false,
    this.placeholder,
    this.onCleared,
  });

  Future<void> _pick(BuildContext context) async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: value ?? DateTime.now(),
      firstDate: firstDate ?? DateTime(2020),
      lastDate: lastDate ?? now.add(const Duration(days: 365 * 3)),
      locale: Localizations.localeOf(context),
    );
    if (date == null || !context.mounted) return;

    if (!showTime) {
      onChanged(date);
      return;
    }

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(value ?? DateTime.now()),
    );
    if (time == null || !context.mounted) return;
    onChanged(
        DateTime(date.year, date.month, date.day, time.hour, time.minute));
  }

  String _formatted() {
    final date = value;
    if (date == null) return placeholder ?? '—';
    if (showTime) return DateFormat('dd.MM.yyyy HH:mm').format(date);
    return DateFormat('dd.MM.yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _pick(context),
      borderRadius: BorderRadius.circular(12),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(prefixIcon),
          suffixIcon: value != null && onCleared != null
              ? IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: onCleared,
                )
              : null,
        ),
        child: Text(
          _formatted(),
          style: value == null
              ? TextStyle(color: Theme.of(context).hintColor)
              : null,
        ),
      ),
    );
  }
}
