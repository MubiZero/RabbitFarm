import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mobile/core/access/farm_access.dart';
import 'package:mobile/core/api/api_client.dart';
import 'package:mobile/features/rabbits/data/models/birth_model.dart';
import 'package:mobile/features/rabbits/data/repositories/births_repository.dart';
import 'package:mobile/features/rabbits/presentation/screens/births_list_screen.dart';

import '../support/test_app.dart';

/// Падёж молодняка до отсадки отмечать было негде: экран падежа работает с
/// карточкой взрослого кролика, а у крольчонка карточки нет — он живёт числом
/// внутри записи об окроле. Проверяется, что потери теперь и записываются, и
/// видны в списке.
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
    _birth = _birth.copyWith(kitsDied: data['kits_died'] as int);
    return _birth;
  }
}

BirthModel _birth({int bornAlive = 8, int died = 0}) => BirthModel(
  id: 1,
  motherId: 5,
  birthDate: '2026-09-01',
  kitsBornAlive: bornAlive,
  kitsBornDead: 0,
  kitsDied: died,
);

Future<_FakeBirthsRepository> _pump(
  WidgetTester tester, {
  int died = 0,
}) async {
  await tester.binding.setSurfaceSize(const Size(420, 1200));
  addTearDown(() => tester.binding.setSurfaceSize(null));

  final repository = _FakeBirthsRepository(_birth(died: died));
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
  testWidgets('потери в выводке отмечаются количеством и уходят на сервер', (
    tester,
  ) async {
    final repository = await _pump(tester);

    await tester.tap(find.text('Отметить падёж'));
    await tester.pumpAndSettle();

    // Цифры кнопками: отмечают это у клетки, одной рукой и в перчатке.
    expect(find.text('Сколько крольчат пало?'), findsOneWidget);
    expect(find.text('Осталось живых: 8'), findsOneWidget);

    await tester.tap(find.widgetWithText(OutlinedButton, '2'));
    await tester.pumpAndSettle();

    expect(repository.updates.single, {'kits_died': 2});
  });

  testWidgets('уже записанные потери прибавляются, а не затирают прежние', (
    tester,
  ) async {
    final repository = await _pump(tester, died: 2);

    // Живых осталось шесть из восьми — и предложить больше шести нельзя.
    await tester.tap(find.text('Отметить падёж'));
    await tester.pumpAndSettle();
    expect(find.text('Осталось живых: 6'), findsOneWidget);
    expect(find.widgetWithText(OutlinedButton, '7'), findsNothing);

    await tester.tap(find.widgetWithText(OutlinedButton, '1'));
    await tester.pumpAndSettle();

    expect(repository.updates.single, {'kits_died': 3});
  });

  testWidgets('потери видны в карточке окрола', (tester) async {
    await _pump(tester, died: 2);

    expect(find.text('Пало'), findsOneWidget);
    expect(find.text('2'), findsWidgets);
  });
}
