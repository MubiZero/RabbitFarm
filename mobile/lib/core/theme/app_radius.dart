import 'package:flutter/widgets.dart';

/// Design token: скругления.
///
/// Одна шкала на всё приложение. Роль важнее числа: поля ввода и кнопки — [md],
/// карточки — [lg], шторки — [xl], значки-«таблетки» — [pill].
abstract class AppRadius {
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double pill = 999;

  static const smAll = BorderRadius.all(Radius.circular(sm));
  static const mdAll = BorderRadius.all(Radius.circular(md));
  static const lgAll = BorderRadius.all(Radius.circular(lg));
  static const xlAll = BorderRadius.all(Radius.circular(xl));
  static const pillAll = BorderRadius.all(Radius.circular(pill));

  /// Верхние углы модальной шторки.
  static const sheetTop = BorderRadius.vertical(top: Radius.circular(xl));
}
