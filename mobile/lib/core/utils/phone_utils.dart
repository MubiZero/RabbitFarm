/// Телефон в таджикском виде — `+992XXXXXXXXX`.
///
/// Зеркало серверного правила (`backend/src/utils/phone.js`): номер — это
/// логин, и сервер принимает его строго в одном виде. Клиент приводит номер
/// сам, чтобы человек мог писать «90 123 45 67», «992901234567» или
/// «+992 90 123 45 67» и не получать отказ формы за пробел.
const _tjPhonePattern = r'^\+992\d{9}$';

/// Привести номер к `+992XXXXXXXXX`, если он узнаётся. Неразобранный номер
/// возвращается как есть — годность решает [isTjPhone], а не догадки.
String normalizeTjPhone(String value) {
  final digits = value.replaceAll(RegExp(r'[^\d]'), '');

  if (digits.length == 9) return '+992$digits';
  if (digits.length == 12 && digits.startsWith('992')) return '+$digits';

  return value.trim();
}

bool isTjPhone(String value) => RegExp(_tjPhonePattern).hasMatch(value);

/// Номер для показа человеку: `+992 90 123 45 67`. Ненормализованный номер
/// возвращается как есть — лучше показать введённое, чем разрезать чужой
/// формат по чужим правилам.
String formatTjPhone(String value) {
  if (!isTjPhone(value)) return value;
  final d = value.substring(4);
  return '+992 ${d.substring(0, 2)} ${d.substring(2, 5)} '
      '${d.substring(5, 7)} ${d.substring(7)}';
}
