import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mobile/core/access/farm_access.dart';
import 'package:mobile/features/home/presentation/screens/farm_screen.dart';

import '../support/test_app.dart';

/// Экран не скроллится в тесте: высокая «поверхность» строит сразу весь
/// список, иначе find.text не нашёл бы то, что осталось ниже сгиба.
Future<void> _pumpFor(
  WidgetTester tester,
  FarmRoleAccess role, {
  bool isPlatformAdmin = false,
}) async {
  await tester.binding.setSurfaceSize(const Size(420, 2400));
  addTearDown(() => tester.binding.setSurfaceSize(null));

  await tester.pumpWidget(testAppScreen(
    const FarmScreen(),
    overrides: [
      farmRoleProvider.overrideWithValue(role),
      isPlatformAdminProvider.overrideWithValue(isPlatformAdmin),
    ],
  ));
  await tester.pump();
}

void main() {
  testWidgets('владелец видит деньги, отчёты и людей', (tester) async {
    await _pumpFor(tester, FarmRoleAccess.owner);

    expect(find.text('Хозяйство'), findsOneWidget);
    expect(find.text('Деньги'), findsOneWidget);
    expect(find.text('Доходы и расходы'), findsOneWidget);
    expect(find.text('Отчёты'), findsOneWidget);
    expect(find.text('Люди'), findsOneWidget);
    expect(find.text('Сотрудники'), findsOneWidget);
    expect(find.text('Владелец фермы'), findsOneWidget);
  });

  testWidgets('работник не видит денег, людей и отчётов', (tester) async {
    await _pumpFor(tester, FarmRoleAccess.worker);

    expect(find.text('Деньги'), findsNothing);
    expect(find.text('Доходы и расходы'), findsNothing);
    expect(find.text('Люди'), findsNothing);
    expect(find.text('Сотрудники'), findsNothing);
    expect(find.text('Отчёты'), findsNothing);
    expect(find.text('Корма'), findsNothing);
    expect(find.text('Здоровье'), findsNothing);
  });

  testWidgets('работнику остаются настройки, «О приложении» и выход',
      (tester) async {
    await _pumpFor(tester, FarmRoleAccess.worker);

    // Заголовок экрана и подпись вкладки внизу — одно и то же слово.
    expect(find.text('Профиль'), findsWidgets);
    expect(find.text('Приложение'), findsOneWidget);
    expect(find.text('Настройки'), findsOneWidget);
    expect(find.text('О приложении'), findsOneWidget);
    expect(find.text('Выйти'), findsOneWidget);
    expect(find.text('Работник'), findsOneWidget);
  });

  testWidgets('управляющий распоряжается хозяйством, но не сотрудниками',
      (tester) async {
    await _pumpFor(tester, FarmRoleAccess.manager);

    expect(find.text('Деньги'), findsOneWidget);
    expect(find.text('Отчёты'), findsOneWidget);
    expect(find.text('Корма'), findsOneWidget);
    expect(find.text('Здоровье'), findsOneWidget);
    expect(find.text('Люди'), findsNothing);
  });

  testWidgets('платформенная админка не видна владельцу фермы',
      (tester) async {
    await _pumpFor(tester, FarmRoleAccess.owner);

    expect(find.text('Платформа'), findsNothing);
    expect(find.text('Фермы и тарифы'), findsNothing);
  });

  testWidgets('платформенная админка видна суперадмину отдельным разделом',
      (tester) async {
    await _pumpFor(tester, FarmRoleAccess.owner, isPlatformAdmin: true);

    expect(find.text('Платформа'), findsOneWidget);
    expect(find.text('Фермы и тарифы'), findsOneWidget);
  });

  testWidgets('поголовье и разведение из вкладки убраны', (tester) async {
    await _pumpFor(tester, FarmRoleAccess.owner);

    for (final gone in const [
      'Клетки',
      'Породы',
      'Случки',
      'Роды',
      'Подбор пар',
      'Кролики',
    ]) {
      expect(find.text(gone), findsNothing, reason: 'осталось: $gone');
    }
  });
}
