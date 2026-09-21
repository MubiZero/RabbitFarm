import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mobile/core/widgets/app_section_title.dart';

import '../support/test_app.dart';

/// «Задачи на сегодня» и «Все задачи» стоят в одной строке, и по верхнему
/// краю кнопка вставала выше заголовка: заголовок крупнее, и его строка
/// выше. Пара выглядела съехавшей на всех экранах сразу — заголовок блока
/// в приложении один на всех.
void main() {
  testWidgets('без подзаголовка заголовок и действие на одной линии',
      (tester) async {
    await tester.pumpWidget(testApp(
      AppSectionTitle(
        'Задачи на сегодня',
        actionLabel: 'Все задачи',
        onAction: () {},
      ),
    ));

    final title = tester.getRect(find.text('Задачи на сегодня'));
    final action = tester.getRect(find.text('Все задачи'));

    expect((title.center.dy - action.center.dy).abs(), lessThan(2),
        reason: 'центры заголовка и действия должны совпадать');
  });

  testWidgets('с подзаголовком действие держится верхней строки',
      (tester) async {
    await tester.pumpWidget(testApp(
      AppSectionTitle(
        'Корма',
        subtitle: 'Остаток на складе и ближайшие закупки',
        actionLabel: 'Весь склад',
        onAction: () {},
      ),
    ));

    final title = tester.getRect(find.text('Корма'));
    final action = tester.getRect(find.text('Весь склад'));

    expect(action.center.dy, lessThan(title.bottom + 12),
        reason: 'действие относится к заголовку, а не к подзаголовку');
  });
}
