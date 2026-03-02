import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppDateField extends StatelessWidget {
  final String label;
  final DateTime value;
  final ValueChanged<DateTime> onChanged;
  final IconData prefixIcon;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final bool showTime;

  const AppDateField({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.prefixIcon = Icons.calendar_today,
    this.firstDate,
    this.lastDate,
    this.showTime = false,
  });

  Future<void> _pick(BuildContext context) async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: value,
      firstDate: firstDate ?? DateTime(2020),
      lastDate: lastDate ?? now.add(const Duration(days: 365 * 3)),
      locale: const Locale('ru'),
    );
    if (date == null || !context.mounted) return;

    if (!showTime) {
      onChanged(date);
      return;
    }

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(value),
    );
    if (time == null) return;
    onChanged(DateTime(date.year, date.month, date.day, time.hour, time.minute));
  }

  String _formatted() {
    if (showTime) return DateFormat('dd.MM.yyyy HH:mm').format(value);
    return DateFormat('dd.MM.yyyy').format(value);
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
        ),
        child: Text(_formatted()),
      ),
    );
  }
}
