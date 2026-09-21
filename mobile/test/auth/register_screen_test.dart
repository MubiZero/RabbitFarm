import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:mobile/core/providers/api_providers.dart';
import 'package:mobile/features/auth/presentation/screens/register_screen.dart';

import '../support/test_app.dart';
import '../support/fake_storage.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Future<void> pumpRegister(WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(testAppScreen(
      const RegisterScreen(),
      overrides: [storageProvider.overrideWithValue(FakeStorage())],
    ));
    await tester.pumpAndSettle();
  }

  testWidgets(
      'не даёт зарегистрироваться, пока не принята политика конфиденциальности',
      (tester) async {
    await pumpRegister(tester);
    final submitButton = find.text('Завести ферму');
    await tester.ensureVisible(submitButton);
    await tester.tap(submitButton);
    await tester.pump();

    expect(
      find.text('Нужно принять политику конфиденциальности, чтобы продолжить'),
      findsOneWidget,
    );
  });

  testWidgets('согласие видно рядом с кнопкой, а не в шапке экрана',
      (tester) async {
    await pumpRegister(tester);

    final submitButton = find.text('Завести ферму');
    await tester.ensureVisible(submitButton);
    await tester.pump();

    // Галочка стояла над заголовком, за три экрана прокрутки от кнопки:
    // человек жал «Завести ферму», она молчала, и он решал, что программа
    // сломана. Причина обязана быть в поле зрения вместе с кнопкой.
    final consent = tester.getRect(find.byType(Checkbox));
    final button = tester.getRect(submitButton);

    expect(consent.bottom, lessThan(button.top),
        reason: 'согласие стоит перед кнопкой, а не после неё');
    expect(button.top - consent.bottom, lessThan(160),
        reason: 'между согласием и кнопкой не должно быть экрана прокрутки');
  });

  testWidgets('отмечает согласие по тапу на строку целиком', (tester) async {
    await pumpRegister(tester);
    final checkbox = find.byType(Checkbox);
    await tester.ensureVisible(checkbox);
    expect(tester.widget<Checkbox>(checkbox).value, isFalse);

    // В перчатке в квадратик 18 пикселей не попасть, поэтому нажимается вся
    // строка: целимся рядом с подписью, мимо самого квадратика.
    final box = tester.getRect(find.byType(Checkbox));
    await tester.tapAt(Offset(box.right + 8, box.center.dy));
    await tester.pump();

    expect(tester.widget<Checkbox>(checkbox).value, isTrue);
  });

  testWidgets('отмеченное согласие убирает объяснение', (tester) async {
    await pumpRegister(tester);
    final submitButton = find.text('Завести ферму');
    await tester.ensureVisible(submitButton);
    await tester.tap(submitButton);
    await tester.pump();

    const complaint = 'Нужно принять политику конфиденциальности, чтобы '
        'продолжить';
    expect(find.text(complaint), findsOneWidget);

    await tester.tap(find.byType(Checkbox));
    await tester.pump();

    expect(find.text(complaint), findsNothing,
        reason: 'ругань про уже сделанное — это ложная тревога');
  });
}
