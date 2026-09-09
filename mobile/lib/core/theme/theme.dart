/// Единая точка входа в дизайн-систему.
///
/// Экрану достаточно одного импорта, чтобы получить токены цвета, отступов,
/// скруглений, типографики и сокращения [BuildContext].
library;

import 'package:flutter/material.dart';

export 'app_breakpoints.dart';
export 'app_colors.dart';
export 'app_duration.dart';
export 'app_radius.dart';
export 'app_spacing.dart';
export 'app_theme.dart';
export 'app_typography.dart';

/// Сокращения для самых частых обращений к теме.
///
/// `Theme.of(context).colorScheme.onSurfaceVariant` повторялся в экранах сотни
/// раз, и из-за длины его регулярно заменяли на `Colors.grey` — цвет, который
/// не следует за темой и в тёмном режиме выглядит грязным пятном.
extension AppThemeContext on BuildContext {
  /// Цвета текущей темы.
  ColorScheme get colors => Theme.of(this).colorScheme;

  /// Текстовые стили текущей темы.
  TextTheme get text => Theme.of(this).textTheme;

  /// Акцент, выбранный пользователем. Им красится всё нажимаемое.
  Color get accent => Theme.of(this).colorScheme.primary;

  bool get isDark => Theme.of(this).brightness == Brightness.dark;

  /// Пользователь попросил систему уменьшить анимацию: движение нужно
  /// выключать, а не ускорять.
  bool get reduceMotion => MediaQuery.of(this).disableAnimations;
}
