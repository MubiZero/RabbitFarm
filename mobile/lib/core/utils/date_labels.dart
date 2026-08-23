import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import '../l10n/l10n_context.dart';

/// Срок человеческим языком.
///
/// «15.03.2026 00:00» заставляет читателя самому считать, далеко ли это и не
/// прошло ли уже. Для списка дел важен ответ, а не сама дата: «Сегодня в
/// 14:00», «Просрочена на 3 дня».
String humanDueDate(BuildContext context, DateTime due, {DateTime? now}) {
  final l10n = context.l10n;
  final today = _dayOf(now ?? DateTime.now());
  final day = _dayOf(due);
  final diff = day.difference(today).inDays;

  // Срок прошёл: важно не «когда было», а насколько запущено.
  if (diff < 0) return l10n.overdueByDays(-diff);

  if (diff == 0) {
    return _hasTime(due)
        ? l10n.dueToday(DateFormat.Hm('ru').format(due))
        : l10n.dueTodayPlain;
  }
  if (diff == 1) {
    return _hasTime(due)
        ? l10n.dueTomorrow(DateFormat.Hm('ru').format(due))
        : l10n.dueTomorrowPlain;
  }
  return l10n.dueOn(DateFormat('d MMMM', 'ru').format(due));
}

/// Срок уже прошёл — с точностью до дня. Задача, записанная на сегодняшнюю
/// полночь, в восемь утра ещё не просрочена.
bool isOverdue(DateTime due, {DateTime? now}) =>
    _dayOf(due).isBefore(_dayOf(now ?? DateTime.now()));

DateTime _dayOf(DateTime d) => DateTime(d.year, d.month, d.day);

bool _hasTime(DateTime d) => d.hour != 0 || d.minute != 0;
