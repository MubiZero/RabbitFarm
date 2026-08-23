/// Design token: единая шкала отступов, шаг 4.
///
/// Экраны и так тяготели к 4/8/12/16/24/32 — токены закрепляют эту шкалу и
/// убирают случайные 6, 10, 20 и 28, из-за которых соседние блоки выглядели
/// сдвинутыми друг относительно друга.
abstract class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double xxl = 32;

  /// Боковые поля контента экрана.
  static const double screenH = 16;

  /// Запас снизу под плавающую кнопку и панель навигации, чтобы последний
  /// элемент списка не прятался под ними.
  static const double fabSafeBottom = 96;
}
