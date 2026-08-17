/// Возраст кролика в человекочитаемом виде: «5 мес», «2 года», «1 г 3 мес».
String formatAge(DateTime birthDate) {
  final months = (DateTime.now().difference(birthDate).inDays / 30).floor();
  final years = (months / 12).floor();

  if (years > 0) {
    final remainingMonths = months % 12;
    if (remainingMonths > 0) {
      return '$years г $remainingMonths мес';
    }
    return '$years ${_pluralYears(years)}';
  }
  return '$months ${_pluralMonths(months)}';
}

String _pluralYears(int years) {
  if (years % 10 == 1 && years % 100 != 11) return 'год';
  if ([2, 3, 4].contains(years % 10) && ![12, 13, 14].contains(years % 100)) {
    return 'года';
  }
  return 'лет';
}

String _pluralMonths(int months) {
  if (months % 10 == 1 && months % 100 != 11) return 'месяц';
  if ([2, 3, 4].contains(months % 10) && ![12, 13, 14].contains(months % 100)) {
    return 'месяца';
  }
  return 'месяцев';
}
