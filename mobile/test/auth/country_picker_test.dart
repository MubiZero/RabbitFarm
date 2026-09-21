import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:mobile/core/providers/api_providers.dart';
import 'package:mobile/features/auth/presentation/screens/login_screen.dart';

import '../support/fake_storage.dart';
import '../support/test_app.dart';

/// Страну спрашивают в знакомстве, но знакомство пропускают, а ответ —
/// промахиваются. Узбекский фермер, миновавший этот вопрос, попадал на вход
/// с таджикским номером: его `+998` не проходил проверку, СМС до Узбекистана
/// всё равно не доходит, а поменять страну было негде — второй раз знакомство
/// не показывают.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Future<void> pumpLogin(WidgetTester tester, {String? country}) async {
    SharedPreferences.setMockInitialValues(
      country == null ? {} : {'selected_country': country},
    );
    await tester.pumpWidget(testAppWithRouter(
      const LoginScreen(),
      overrides: [storageProvider.overrideWithValue(FakeStorage())],
    ));
    await tester.pumpAndSettle();
  }

  testWidgets('страну видно и её можно поменять прямо со входа',
      (tester) async {
    await pumpLogin(tester);

    expect(find.text('Страна: Таджикистан'), findsOneWidget);
    // Таджикистан — единственная страна, куда доходит код по СМС: шлюз
    // таджикский.
    expect(find.widgetWithText(SegmentedButton<bool>, 'Телефон'),
        findsOneWidget);

    await tester.tap(find.text('Страна: Таджикистан'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Узбекистан').last);
    await tester.pumpAndSettle();

    expect(find.text('Страна: Узбекистан'), findsOneWidget);
    expect(find.byType(SegmentedButton<bool>), findsNothing,
        reason: 'предлагать телефон там, куда СМС не доходит, — значит '
            'оставить человека ждать код, которого не будет');
    expect(find.text('В вашей стране код по СМС не приходит — входите по почте'),
        findsOneWidget);
  });

  testWidgets('выбранная страна переживает перезапуск', (tester) async {
    await pumpLogin(tester, country: 'UZ');

    expect(find.text('Страна: Узбекистан'), findsOneWidget);
    expect(find.widgetWithText(TextFormField, 'Почта'), findsOneWidget);
  });
}
