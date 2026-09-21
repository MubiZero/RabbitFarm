import 'package:flutter/material.dart';

import '../theme/theme.dart';

/// Фирменный знак приложения — сплэш, вход и знакомство, куда человек
/// попадает без AppBar.
///
/// Тот же контурный кролик, что на иконке приложения и на витрине: знак
/// узнают по повторению, а три разных рисунка в трёх местах — это три разных
/// приложения в глазах того, кто их видит. Подложка — акцент, выбранный
/// человеком, линии — тёмные: белые на акценте дают 2,9 при норме 4,5, и
/// по этой же причине тёмная надпись стоит на всех кнопках приложения.
class AppBrandMark extends StatelessWidget {
  const AppBrandMark({super.key, this.size = 72});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: context.accent,
        borderRadius: BorderRadius.circular(size * AppRadius.lg / 72),
      ),
      padding: EdgeInsets.all(size * 0.12),
      child: Image.asset(
        'assets/brand/rabbit-mark.png',
        // Цвет знака не зависит от акцента: он один и тот же на иконке
        // приложения, на витрине и здесь.
        color: AppColors.onAccent,
        filterQuality: FilterQuality.medium,
        excludeFromSemantics: true,
      ),
    );
  }
}
