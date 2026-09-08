import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mobile/core/widgets/plan_limit_dialog.dart';

import '../support/test_app.dart';

/// `showPlanLimitReachedDialog` — экран отказа по лимиту тарифа, общий для
/// формы кролика (`RABBIT_LIMIT_REACHED`) и приглашения сотрудника
/// (`STAFF_LIMIT_REACHED`). Здесь проверяется сам виджет; сценарий
/// приглашения сотрудника целиком проверен в `staff_screen_test.dart`.
Future<void> _open(WidgetTester tester) async {
  await tester.pumpWidget(testAppScreen(
    Builder(
      builder: (context) => Scaffold(
        body: Center(
          child: ElevatedButton(
            onPressed: () => showPlanLimitReachedDialog(
              context,
              title: 'Лимит кроликов по тарифу',
              body: 'Ферма достигла лимита кроликов, разрешённого тарифом.',
            ),
            child: const Text('Открыть'),
          ),
        ),
      ),
    ),
  ));

  await tester.tap(find.text('Открыть'));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('показывает заголовок и объяснение вместо текста ошибки',
      (tester) async {
    await _open(tester);

    expect(find.text('Лимит кроликов по тарифу'), findsOneWidget);
    expect(
      find.text('Ферма достигла лимита кроликов, разрешённого тарифом.'),
      findsOneWidget,
    );
  });

  testWidgets('закрывается кнопкой «Закрыть»', (tester) async {
    await _open(tester);

    await tester.tap(find.text('Закрыть'));
    await tester.pumpAndSettle();

    expect(find.text('Лимит кроликов по тарифу'), findsNothing);
  });
}
