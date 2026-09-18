import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Контраст двух цветов по WCAG: считаемая величина, а не дело вкуса.
///
/// Пороги, которыми пользуются тесты: 4.5 — обычный текст, 3.0 — крупный
/// текст и всё нетекстовое, что должно быть видно (контуры полей, точки
/// набранного кода, значки состояния).
double contrastRatio(Color a, Color b) {
  final la = _relativeLuminance(a);
  final lb = _relativeLuminance(b);
  final lighter = math.max(la, lb);
  final darker = math.min(la, lb);
  return (lighter + 0.05) / (darker + 0.05);
}

/// Цвет поверх подложки: полупрозрачное рисуется прозрачностью, и считать
/// контраст нужно с тем, что получилось, а не с самим цветом.
Color colorOver(Color foreground, Color background, double alpha) =>
    Color.fromARGB(
      255,
      ((foreground.r * alpha + background.r * (1 - alpha)) * 255).round(),
      ((foreground.g * alpha + background.g * (1 - alpha)) * 255).round(),
      ((foreground.b * alpha + background.b * (1 - alpha)) * 255).round(),
    );

double _relativeLuminance(Color color) {
  double channel(double value) {
    return value <= 0.03928
        ? value / 12.92
        : math.pow((value + 0.055) / 1.055, 2.4) as double;
  }

  return 0.2126 * channel(color.r) +
      0.7152 * channel(color.g) +
      0.0722 * channel(color.b);
}
