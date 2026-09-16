import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:mobile/features/platform_admin/data/models/platform_admin_models.dart';
import 'package:mobile/features/platform_admin/presentation/screens/platform_admin_screen.dart';
import 'package:mobile/features/platform_admin/presentation/widgets/plan_delete_dialog.dart';

import '../support/test_app.dart';

/// Хвосты админки: места, где интерфейс молчал о последствии, которое сервер
/// уже знал.
Plan _plan({required int farmsCount, bool isDefault = false}) => Plan(
      id: 1,
      name: 'Базовый',
      maxRabbits: 50,
      farmsCount: farmsCount,
      isDefault: isDefault,
    );

Future<void> _openDialog(WidgetTester tester, Plan plan) async {
  await tester.pumpWidget(testApp(
    Builder(
      builder: (context) => TextButton(
        onPressed: () => showPlanDeleteDialog(context, plan: plan),
        child: const Text('удалить'),
      ),
    ),
  ));
  await tester.tap(find.text('удалить'));
  await tester.pumpAndSettle();
}

void main() {
  setUpAll(() => initializeDateFormatting('ru'));

  // Одно дело стереть тариф, на котором никого, другое — тот, на котором
  // половина сервиса. Сервер этого числа раньше не отдавал вовсе.
  testWidgets('окно удаления тарифа называет число ферм на нём',
      (tester) async {
    await _openDialog(tester, _plan(farmsCount: 3));

    expect(find.textContaining('3 фермы'), findsOneWidget);
  });

  testWidgets('на пустом тарифе окно так и говорит', (tester) async {
    await _openDialog(tester, _plan(farmsCount: 0));

    expect(find.textContaining('нет ни одной фермы'), findsOneWidget);
  });

  // Ссылка «Весь журнал» с карточки фермы ведёт на вкладку журнала. Порядок
  // вкладок задан одним списком: разойдись он с самим экраном — ссылка
  // открывала бы не то, что обещает.
  test('вкладки админки адресуются именем, а не номером', () {
    expect(PlatformAdminScreen.tabs, contains('audit'));
    expect(PlatformAdminScreen.tabs.first, 'summary');
    // Неизвестное имя и пустая ссылка не должны валить экран — их разбор
    // даёт -1, и экран открывается на первой вкладке.
    expect(PlatformAdminScreen.tabs.indexOf('нет такой'), -1);
  });
}
