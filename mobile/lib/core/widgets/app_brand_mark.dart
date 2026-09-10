import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/theme.dart';

/// Фирменный знак приложения — сплэш и вход, куда пользователь попадает
/// без AppBar. Раньше там стояла `Icons.pets` — та же самая иконка, что
/// используется как обычный функциональный значок в списках кроликов,
/// так что «логотип» приложения ничем не отличался от значка одной записи.
/// Здесь — отдельная нарисованная метка, не связанная с Material-иконками
/// из остального интерфейса.
class AppBrandMark extends StatelessWidget {
  const AppBrandMark({super.key, this.size = 72});

  final double size;

  @override
  Widget build(BuildContext context) {
    final cs = context.colors;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: cs.primaryContainer,
        borderRadius: BorderRadius.circular(size * AppRadius.lg / 72),
      ),
      padding: EdgeInsets.all(size * 0.22),
      child: CustomPaint(painter: _RabbitMarkPainter(color: cs.primary)),
    );
  }
}

class _RabbitMarkPainter extends CustomPainter {
  const _RabbitMarkPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    final w = size.width;
    final h = size.height;

    // Одно цельное пятно силуэта — заострённые уши переходят прямо в
    // голову, без отдельных деталей (носа, зрачков и т.п.). Плоский,
    // графичный знак, читаемый даже в 24×24 — как у иконок-монограмм,
    // а не мультяшный персонаж.
    Path ear(double baseWidth, double tipWidth, double height) {
      final path = Path()
        ..moveTo(-baseWidth / 2, height / 2)
        ..quadraticBezierTo(
          -baseWidth * 0.56,
          -height * 0.12,
          -tipWidth / 2,
          -height / 2,
        )
        ..quadraticBezierTo(0, -height * 0.58, tipWidth / 2, -height / 2)
        ..quadraticBezierTo(
          baseWidth * 0.56,
          -height * 0.12,
          baseWidth / 2,
          height / 2,
        )
        ..close();
      return path;
    }

    void drawEar(double tiltDegrees, double dx) {
      canvas.save();
      canvas.translate(w / 2 + dx, h * 0.4);
      canvas.rotate(tiltDegrees * math.pi / 180);
      canvas.drawPath(ear(w * 0.20, w * 0.075, h * 0.62), paint);
      canvas.restore();
    }

    drawEar(-15, -w * 0.15);
    drawEar(15, w * 0.15);
    canvas.drawCircle(Offset(w / 2, h * 0.62), w * 0.30, paint);
  }

  @override
  bool shouldRepaint(covariant _RabbitMarkPainter oldDelegate) =>
      oldDelegate.color != color;
}
