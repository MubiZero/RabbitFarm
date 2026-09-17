import 'package:flutter/widgets.dart';

import '../l10n/l10n_context.dart';

/// Возраст кролика словами: «5 мес», «2 года», «1 г 3 мес».
///
/// Раньше здесь лежала своя таблица русских окончаний — три ветвления на
/// «год/года/лет» и столько же на месяцы. На таджикском и узбекском экране
/// возраст всё равно оставался русским, а в приложении для этого давно есть
/// ICU-плюрал: правила окончаний в нём свои у каждого языка, и писать их
/// руками не нужно.
String formatAge(BuildContext context, DateTime birthDate) {
  final months = (DateTime.now().difference(birthDate).inDays / 30).floor();
  final years = months ~/ 12;

  if (years > 0) {
    final remainingMonths = months % 12;
    return remainingMonths > 0
        ? context.l10n.ageYearsMonths(years, remainingMonths)
        : context.l10n.ageYears(years);
  }
  return context.l10n.periodMonths(months);
}
