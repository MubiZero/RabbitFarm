import 'package:flutter/services.dart';

/// Телефон в таджикском виде — `+992XXXXXXXXX`.
///
/// Зеркалит `backend/src/utils/phone.js`: сервер всё равно нормализует и
/// перепроверяет номер сам, эта копия нужна только для мгновенной обратной
/// связи в форме — без похода на сервер за каждой опечаткой.
final RegExp tjPhonePattern = RegExp(r'^\+992\d{9}$');

/// Привести номер к `+992XXXXXXXXX`, если он узнаётся: 9 цифр — местный
/// формат без кода страны, 12 цифр, начинающихся с `992`, — код страны без
/// плюса. Номер, который не разобрался, возвращается как есть.
String normalizeTjPhone(String value) {
  final digits = value.replaceAll(RegExp(r'[^\d]'), '');

  if (digits.length == 9) return '+992$digits';
  if (digits.length == 12 && digits.startsWith('992')) return '+$digits';

  return value.trim();
}

bool isTjPhone(String value) => tjPhonePattern.hasMatch(value);

/// Форматирует ввод как `+992 XX XXX XX XX` по мере набора — человеку легче
/// сверить номер по группам цифр, чем сплошной строкой из двенадцати.
class TjPhoneInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    var digits = newValue.text.replaceAll(RegExp(r'[^\d]'), '');
    if (digits.startsWith('992')) digits = digits.substring(3);
    digits = digits.length > 9 ? digits.substring(0, 9) : digits;

    final buffer = StringBuffer('+992');
    if (digits.isNotEmpty) buffer.write(' ${digits.substring(0, digits.length.clamp(0, 2))}');
    if (digits.length > 2) buffer.write(' ${digits.substring(2, digits.length.clamp(2, 5))}');
    if (digits.length > 5) buffer.write(' ${digits.substring(5, digits.length.clamp(5, 7))}');
    if (digits.length > 7) buffer.write(' ${digits.substring(7, digits.length.clamp(7, 9))}');

    final formatted = buffer.toString();
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
