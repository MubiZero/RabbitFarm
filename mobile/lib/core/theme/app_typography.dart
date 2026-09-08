import 'package:flutter/material.dart';

/// Design token: text styles.
/// Always use these — never inline fontSize/fontWeight.
abstract class AppTypography {
  static const String _font = 'Inter';

  static const displayLg = TextStyle(
    fontFamily: _font,
    fontSize: 32,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
    height: 1.2,
  );

  static const displayMd = TextStyle(
    fontFamily: _font,
    fontSize: 24,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.3,
    height: 1.25,
  );

  static const titleLg = TextStyle(
    fontFamily: _font,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.2,
    height: 1.3,
  );

  static const titleMd = TextStyle(
    fontFamily: _font,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.4,
  );

  static const bodyLg = TextStyle(
    fontFamily: _font,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  static const bodyMd = TextStyle(
    fontFamily: _font,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  static const labelLg = TextStyle(
    fontFamily: _font,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.4,
    letterSpacing: 0.1,
  );

  /// Машинный текст: JSON выгрузки, ключи, коды. Отдельный токен, потому что
  /// такой текст читают глазами по строкам, и пропорциональный шрифт ломает
  /// отступы, которыми он и структурирован. Семейство задано через фолбэки:
  /// «monospace» разрешается только на Android.
  static const mono = TextStyle(
    fontFamily: 'monospace',
    fontFamilyFallback: ['Menlo', 'Courier New', 'monospace'],
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.45,
  );

  static const labelSm = TextStyle(
    fontFamily: _font,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 1.3,
    letterSpacing: 0.2,
  );
}
