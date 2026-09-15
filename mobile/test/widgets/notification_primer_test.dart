import 'package:flutter_test/flutter_test.dart';

import 'package:mobile/core/notifications/notification_permission.dart';
import 'package:mobile/core/notifications/notification_primer.dart';

import '../support/test_app.dart';

/// Разрешение на уведомления спрашивают один раз за установку, и отказ в
/// системном диалоге из приложения уже не отменить. Поэтому проверяется не
/// внешний вид объяснения, а то, когда оно появляется и когда молчит: на
/// пушах висит напоминание поставить маточник, и лишний отказ стоит окрола.
class _FakePermission extends NotificationPermission {
  _FakePermission({required this.shouldShow});

  final bool shouldShow;
  int asked = 0;

  @override
  Future<bool> shouldShowPrimer() async {
    asked++;
    return shouldShow;
  }
}

Future<void> _pump(WidgetTester tester, _FakePermission permission,
    {required bool enabled}) async {
  await tester.pumpWidget(
    testApp(
      NotificationPrimerGate(enabled: enabled),
      overrides: [notificationPermissionProvider.overrideWithValue(permission)],
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('на пустой ферме про уведомления не спрашивают', (tester) async {
    final permission = _FakePermission(shouldShow: true);
    await _pump(tester, permission, enabled: false);

    // Напоминать не о чем: ни кроликов, ни случек. Спросить сейчас — сжечь
    // единственную попытку на пустом месте.
    expect(permission.asked, 0);
    expect(find.text('Напомним поставить маточник'), findsNothing);
  });

  testWidgets(
      'когда на ферме есть кролики — объясняем выгоду до системного вопроса', (
    tester,
  ) async {
    final permission = _FakePermission(shouldShow: true);
    await _pump(tester, permission, enabled: true);

    expect(find.text('Напомним поставить маточник'), findsOneWidget);
    expect(find.text('Включить напоминания'), findsOneWidget);
    expect(find.text('Не сейчас'), findsOneWidget);
  });

  testWidgets('уже отвеченный вопрос не задаётся заново', (tester) async {
    final permission = _FakePermission(shouldShow: false);
    await _pump(tester, permission, enabled: true);

    expect(permission.asked, 1);
    expect(find.byType(NotificationPrimerSheet), findsNothing);
  });

  testWidgets('перестроение экрана не показывает объяснение второй раз', (
    tester,
  ) async {
    final permission = _FakePermission(shouldShow: false);
    await _pump(tester, permission, enabled: true);

    // Лента «Сегодня» перестраивается на каждом обновлении, и без защёлки
    // проверка уходила бы заново на каждый кадр.
    await tester.pumpWidget(
      testApp(
        const NotificationPrimerGate(enabled: true),
        overrides: [
          notificationPermissionProvider.overrideWithValue(permission)
        ],
      ),
    );
    await tester.pumpAndSettle();

    expect(permission.asked, 1);
  });
}
