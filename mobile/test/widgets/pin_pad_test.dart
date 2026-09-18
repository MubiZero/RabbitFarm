import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mobile/features/auth/presentation/widgets/pin_pad.dart';

import '../support/contrast.dart';
import '../support/test_app.dart';

/// Точки набранного кода — единственный ответ экрана на нажатие цифры: сам
/// код не показывают. Полевой проход застрял именно здесь: человеку казалось,
/// что часть нажатий теряется, и он набирал лишнее. Нажатия доходили —
/// не было видно пустых ячеек, поэтому изменений человек не замечал.
///
/// Норма для нетекстового — 3:1.
const _minNonTextContrast = 3.0;

Iterable<BoxDecoration> _dots(WidgetTester tester) => tester
    .widgetList<AnimatedContainer>(find.descendant(
      of: find.byType(PinPad),
      matching: find.byType(AnimatedContainer),
    ))
    .map((container) => container.decoration! as BoxDecoration);

void main() {
  for (final brightness in Brightness.values) {
    testWidgets('незаполненная ячейка кода видна: ${brightness.name}',
        (tester) async {
      await tester.pumpWidget(testApp(
        PinPad(value: '12', onChanged: (_) {}),
        brightness: brightness,
      ));
      await tester.pumpAndSettle();

      final background = Theme.of(tester.element(find.byType(PinPad)))
          .scaffoldBackgroundColor;
      final dots = _dots(tester).toList();
      expect(dots, hasLength(4));

      for (var index = 0; index < dots.length; index += 1) {
        final ratio =
            contrastRatio(dots[index].border!.top.color, background);
        expect(
          ratio,
          greaterThanOrEqualTo(_minNonTextContrast),
          reason: 'ячейка ${index + 1} даёт ${ratio.toStringAsFixed(2)} '
              'при норме $_minNonTextContrast',
        );
      }
    });
  }

  testWidgets('набранное отличается от ненабранного не только цветом фона',
      (tester) async {
    await tester.pumpWidget(testApp(PinPad(value: '12', onChanged: (_) {})));
    await tester.pumpAndSettle();

    final background =
        Theme.of(tester.element(find.byType(PinPad))).scaffoldBackgroundColor;
    final dots = _dots(tester).toList();
    final filled = dots[0].color!;
    // Пустая ячейка залита полупрозрачным, поэтому сравниваем с тем, что
    // получилось на фоне экрана, а не с самим цветом.
    final empty = colorOver(dots[3].color!, background, dots[3].color!.a);

    expect(contrastRatio(filled, empty),
        greaterThanOrEqualTo(_minNonTextContrast),
        reason: 'иначе непонятно, сколько цифр уже набрано');
  });

  testWidgets('каждое нажатие доходит, даже быстрое', (tester) async {
    var value = '';
    await tester.pumpWidget(testApp(
      StatefulBuilder(
        builder: (context, setState) => PinPad(
          value: value,
          onChanged: (next) => setState(() => value = next),
        ),
      ),
    ));

    for (final digit in '4071'.split('')) {
      await tester.tap(find.widgetWithText(TextButton, digit));
      await tester.pump();
    }

    expect(value, '4071');
  });

  testWidgets('стереть убирает последнюю цифру, а на пустом молчит',
      (tester) async {
    var value = '12';
    await tester.pumpWidget(testApp(
      StatefulBuilder(
        builder: (context, setState) => PinPad(
          value: value,
          onChanged: (next) => setState(() => value = next),
        ),
      ),
    ));

    await tester.tap(find.byIcon(Icons.backspace_outlined));
    await tester.pump();
    expect(value, '1');

    await tester.tap(find.byIcon(Icons.backspace_outlined));
    await tester.pump();
    expect(value, '');

    expect(
      tester.widget<IconButton>(find.byType(IconButton)).onPressed,
      isNull,
      reason: 'стирать нечего — клавиша должна быть видимо неактивной',
    );
  });
}
