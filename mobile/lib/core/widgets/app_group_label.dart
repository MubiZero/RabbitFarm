import 'package:flutter/material.dart';

import '../theme/theme.dart';

/// Мелкая надпись-разделитель над группой полей или показателей.
///
/// Тише заголовка блока и потому не спорит с ним за внимание: на экранах
/// аналитики такие подписи идут одна за другой, и крупный шрифт превратил бы
/// их в лестницу из заголовков.
///
/// Раньше эта надпись была описана заново на трёх экранах аналитики и на
/// экране работников.
class AppGroupLabel extends StatelessWidget {
  final String text;

  const AppGroupLabel(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: AppTypography.labelSm.copyWith(
        color: context.colors.onSurfaceVariant,
        letterSpacing: 1.2,
      ),
    );
  }
}
