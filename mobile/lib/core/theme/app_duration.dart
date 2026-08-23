import 'package:flutter/widgets.dart';

/// Design token: длительности и кривые анимаций.
///
/// Движение здесь служит обратной связью, а не украшением: подтверждает нажатие
/// и показывает, что данные меняются. Всё, что длиннее [slow], для рабочего
/// приложения — задержка, а не эффект.
abstract class AppDuration {
  /// Отклик на касание: подсветка, нажатие, переключение.
  static const instant = Duration(milliseconds: 120);

  /// Появление и скрытие элементов внутри экрана.
  static const fast = Duration(milliseconds: 200);

  /// Разворачивание блоков, переходы между состояниями экрана.
  static const normal = Duration(milliseconds: 300);

  /// Пульсация скелетонов.
  static const slow = Duration(milliseconds: 900);

  /// Задержка перед показом индикатора загрузки: быстрый ответ не должен
  /// мигать спиннером.
  static const spinnerDelay = Duration(milliseconds: 250);

  static const curve = Curves.easeOutCubic;
}
