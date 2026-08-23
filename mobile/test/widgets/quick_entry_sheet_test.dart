import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:mobile/core/access/farm_access.dart';
import 'package:mobile/features/home/presentation/providers/quick_entry_usage_provider.dart';
import 'package:mobile/features/home/presentation/widgets/quick_entry_sheet.dart';

import '../support/test_app.dart';

/// Лист открывается с другого экрана — как в приложении, где его вызывает
/// круглая кнопка поверх вкладки.
Future<void> _openSheet(
  WidgetTester tester, {
  FarmRoleAccess role = FarmRoleAccess.owner,
}) async {
  await tester.pumpWidget(testAppScreen(
    Builder(
      builder: (context) => Scaffold(
        body: Center(
          child: ElevatedButton(
            onPressed: () => showQuickEntrySheet(context, role),
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
  group('часто выбираемое', () {
    test('пока выборов мало, «Часто» не собирается', () {
      expect(frequentRoutes(const {}), isEmpty);
      expect(frequentRoutes(const {'/tasks/form': 4}), isEmpty);
    });

    test('однажды нажатый пункт наверх не поднимается', () {
      final routes = frequentRoutes(const {
        '/feeding-records/form': 5,
        '/rabbits/new': 1,
      });

      expect(routes, ['/feeding-records/form']);
    });

    test('наверх идут три самых частых, от частого к редкому', () {
      final routes = frequentRoutes(const {
        '/tasks/form': 3,
        '/feeding-records/form': 9,
        '/vaccinations/form': 5,
        '/cages/form': 2,
      });

      expect(routes, [
        '/feeding-records/form',
        '/vaccinations/form',
        '/tasks/form',
      ]);
    });
  });

  testWidgets('новому человеку рубрика «Часто» не показывается',
      (tester) async {
    SharedPreferences.setMockInitialValues({});
    await _openSheet(tester);

    expect(find.text('Часто'), findsNothing);
    expect(find.text('Каждый день'), findsOneWidget);
  });

  testWidgets('привычные записи поднимаются наверх отдельной рубрикой',
      (tester) async {
    SharedPreferences.setMockInitialValues({
      'quick_entry_usage': ['/feeding-records/form 4', '/tasks/form 3'],
    });
    await _openSheet(tester);

    expect(find.text('Часто'), findsOneWidget);
    // Пункт остаётся и в своей рубрике: список, который переставляется под
    // человеком, приходится перечитывать заново каждый раз.
    expect(find.text('Записать кормление'), findsNWidgets(2));
    expect(find.text('Создать задачу'), findsNWidgets(2));
    expect(find.text('Добавить кролика'), findsOneWidget);
  });

  testWidgets('испорченный счётчик не ломает лист', (tester) async {
    SharedPreferences.setMockInitialValues({
      'quick_entry_usage': ['мусор', '/tasks/form'],
    });
    await _openSheet(tester);

    expect(tester.takeException(), isNull);
    expect(find.text('Часто'), findsNothing);
    expect(find.text('Создать задачу'), findsOneWidget);
  });

  testWidgets('работнику видно только то, что ему можно записывать',
      (tester) async {
    SharedPreferences.setMockInitialValues({});
    await _openSheet(tester, role: FarmRoleAccess.worker);

    expect(find.text('Записать кормление'), findsOneWidget);
    expect(find.text('Стадо'), findsNothing);
    expect(find.text('Приход или расход'), findsNothing);
  });

  testWidgets('на маленьком экране список прокручивается, а не обрезается',
      (tester) async {
    await tester.binding.setSurfaceSize(const Size(360, 560));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    SharedPreferences.setMockInitialValues({});

    await _openSheet(tester);

    expect(tester.takeException(), isNull);

    final sheet = tester.getRect(find.byType(BottomSheet));
    final last = find.text('Приход или расход');

    // Последний пункт в лист не помещается — и это нормально, пока до него
    // можно долистать. Обрезанным он был бы, если бы лист не прокручивался.
    expect(tester.getRect(last).top, greaterThan(sheet.bottom));

    await tester.scrollUntilVisible(
      last,
      120,
      scrollable: find.byType(Scrollable).last,
    );
    await tester.pumpAndSettle();

    expect(tester.getRect(last).bottom, lessThanOrEqualTo(sheet.bottom));
  });
}
