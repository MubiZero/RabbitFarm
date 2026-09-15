import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mobile/core/access/farm_access.dart';
import 'package:mobile/core/api/api_client.dart';
import 'package:mobile/features/rabbits/data/models/birth_model.dart';
import 'package:mobile/features/rabbits/data/repositories/births_repository.dart';
import 'package:mobile/features/rabbits/presentation/screens/births_list_screen.dart';

import '../support/test_app.dart';

/// Отсадку сервер принимает, список её показывает, лента цикла по ней
/// закрывает цикл, а задача «Отсадка» приходит на 45-й день — но отправить её
/// было неоткуда. Проверяется, что уходит на сервер и что кнопка не зовёт
/// отсаживать второй раз.
class _FakeBirthsRepository extends BirthsRepository {
  _FakeBirthsRepository(this._birth)
    : super(apiClient: ApiClient(storage: const FlutterSecureStorage()));

  BirthModel _birth;
  final List<Map<String, dynamic>> updates = [];

  @override
  Future<List<BirthModel>> getBirths() async => [_birth];

  @override
  Future<BirthModel> updateBirth(int id, Map<String, dynamic> data) async {
    updates.add(data);
    _birth = _birth.copyWith(
      kitsWeaned: data['kits_weaned'] as int?,
      weaningDate: data['weaning_date'] as String?,
    );
    return _birth;
  }
}

String _iso(DateTime date) =>
    '${date.year.toString().padLeft(4, '0')}-'
    '${date.month.toString().padLeft(2, '0')}-'
    '${date.day.toString().padLeft(2, '0')}';

BirthModel _birth({
  int bornAlive = 8,
  int died = 0,
  int? weaned,
  String? weaningDate,
}) => BirthModel(
  id: 1,
  motherId: 5,
  birthDate: '2026-08-01',
  kitsBornAlive: bornAlive,
  kitsBornDead: 0,
  kitsDied: died,
  kitsWeaned: weaned,
  weaningDate: weaningDate,
);

Future<_FakeBirthsRepository> _pump(
  WidgetTester tester, {
  BirthModel? birth,
}) async {
  await tester.binding.setSurfaceSize(const Size(420, 1400));
  addTearDown(() => tester.binding.setSurfaceSize(null));

  final repository = _FakeBirthsRepository(birth ?? _birth());
  await tester.pumpWidget(
    testAppScreen(
      const BirthsListScreen(),
      overrides: [
        birthsRepositoryProvider.overrideWithValue(repository),
        farmRoleProvider.overrideWithValue(FarmRoleAccess.owner),
      ],
    ),
  );
  await tester.pumpAndSettle();
  return repository;
}

void main() {
  testWidgets('отсадка всего выводка — одно нажатие', (tester) async {
    final repository = await _pump(tester, birth: _birth(died: 2));

    await tester.tap(find.text('Отсадили'));
    await tester.pumpAndSettle();

    // По умолчанию — сколько живо: из восьми рождённых двое пали.
    expect(find.text('Живых в выводке: 6'), findsOneWidget);

    await tester.tap(find.text('Всех: 6'));
    await tester.pumpAndSettle();

    expect(repository.updates.single, {
      'kits_weaned': 6,
      'weaning_date': _iso(DateTime.now()),
    });
  });

  testWidgets('часть выводка можно оставить под самкой', (tester) async {
    final repository = await _pump(tester);

    await tester.tap(find.text('Отсадили'));
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(OutlinedButton, '5'));
    await tester.pumpAndSettle();

    expect(repository.updates.single['kits_weaned'], 5);
  });

  testWidgets('записанную отсадку второй раз не предлагают', (tester) async {
    await _pump(tester, birth: _birth(weaned: 8, weaningDate: '2026-09-14'));

    expect(find.text('Отсадили'), findsNothing);
    expect(find.text('Отсажено'), findsOneWidget);
  });

  testWidgets('после отсадки кнопка уходит из карточки', (tester) async {
    await _pump(tester);

    await tester.tap(find.text('Отсадили'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Всех: 8'));
    await tester.pumpAndSettle();

    expect(find.text('Отсадили'), findsNothing);
    expect(find.text('Отсажено'), findsOneWidget);
  });
}
