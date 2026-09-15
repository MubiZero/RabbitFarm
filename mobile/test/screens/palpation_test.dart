import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:mobile/core/access/farm_access.dart';
import 'package:mobile/core/api/api_client.dart';
import 'package:mobile/features/breeding/data/repositories/breeding_repository.dart';
import 'package:mobile/features/breeding/presentation/providers/breeding_provider.dart';
import 'package:mobile/features/breeding/presentation/screens/breeding_cycle_screen.dart';
import 'package:mobile/features/rabbits/data/models/breeding_model.dart';
import 'package:mobile/features/rabbits/data/models/rabbit_model.dart';
import 'package:mobile/shared/models/api_response.dart';

import '../support/test_app.dart';

/// Сервер давно ждёт результат прощупывания — по нему он переводит самку в
/// «беременна» и по нему же лента цикла решает, что делать дальше, — но
/// отправить его было неоткуда. Проверяется, что уходит на сервер и что
/// показывает лента после ответа.
class _FakeBreedingRepository extends BreedingRepository {
  _FakeBreedingRepository(this._items)
      : super(
          apiClient: ApiClient(
            storage: const FlutterSecureStorage(),
            baseUrl: 'http://localhost',
          ),
        );

  List<BreedingModel> _items;
  final List<Map<String, dynamic>> updates = [];

  @override
  Future<PaginatedResponse<BreedingModel>> getBreedings({
    int page = 1,
    int limit = 20,
    String? status,
    int? maleId,
    int? femaleId,
    String? fromDate,
    String? toDate,
  }) async =>
      PaginatedResponse<BreedingModel>(
        items: _items,
        total: _items.length,
        page: 1,
        limit: limit,
        totalPages: 1,
      );

  @override
  Future<BreedingModel> updateBreeding(
    int id,
    Map<String, dynamic> data,
  ) async {
    updates.add(data);
    final updated = _items.firstWhere((b) => b.id == id).copyWith(
          palpationDate: data['palpation_date'] as String?,
          isPregnant: data['is_pregnant'] as bool?,
        );
    _items = [
      for (final breeding in _items) breeding.id == id ? updated : breeding,
    ];
    return updated;
  }
}

String _iso(DateTime date) => '${date.year.toString().padLeft(4, '0')}-'
    '${date.month.toString().padLeft(2, '0')}-'
    '${date.day.toString().padLeft(2, '0')}';

RabbitModel _rabbit(int id, String name, String sex) => RabbitModel(
      id: id,
      tagId: 'A-$id',
      name: name,
      breedId: 1,
      sex: sex,
      birthDate: DateTime(2024, 1, 1),
      status: 'active',
      purpose: 'breeding',
      createdAt: DateTime(2024, 1, 1),
      updatedAt: DateTime(2024, 1, 1),
    );

/// Случка на 14-й день — ровно тот день, на который сервер заводит задачу
/// «Прощупать».
BreedingModel _breeding({
  String status = 'planned',
  String? palpationDate,
  bool? isPregnant,
}) {
  final today = DateTime.now();
  final bred = DateTime(today.year, today.month, today.day - 13);

  return BreedingModel(
    id: 1,
    maleId: 11,
    femaleId: 21,
    breedingDate: _iso(bred),
    status: status,
    palpationDate: palpationDate,
    isPregnant: isPregnant,
    expectedBirthDate: _iso(DateTime(bred.year, bred.month, bred.day + 31)),
    male: _rabbit(11, 'Буран', 'male'),
    female: _rabbit(21, 'Зорька', 'female'),
  );
}

Future<_FakeBreedingRepository> _pump(
  WidgetTester tester, {
  BreedingModel? breeding,
  FarmRoleAccess role = FarmRoleAccess.owner,
}) async {
  await tester.binding.setSurfaceSize(const Size(420, 2000));
  addTearDown(() => tester.binding.setSurfaceSize(null));

  final repository = _FakeBreedingRepository([breeding ?? _breeding()]);
  await tester.pumpWidget(
    testAppScreen(
      const BreedingCycleScreen(),
      overrides: [
        farmRoleProvider.overrideWithValue(role),
        breedingRepositoryProvider.overrideWithValue(repository),
      ],
    ),
  );
  await tester.pumpAndSettle();
  return repository;
}

void main() {
  setUpAll(() => initializeDateFormatting('ru_RU', null));

  testWidgets('«сукрольная» уходит на сервер с сегодняшней датой', (
    tester,
  ) async {
    final repository = await _pump(tester);

    await tester.tap(find.text('Прощупала'));
    await tester.pumpAndSettle();

    // Выбор — между последствиями, а не между словами.
    expect(find.text('Что показало прощупывание?'), findsOneWidget);
    expect(find.text('Самка станет беременной, впереди окрол'), findsOneWidget);

    await tester.tap(find.text('Сукрольная'));
    await tester.pumpAndSettle();

    expect(repository.updates.single, {
      'palpation_date': _iso(DateTime.now()),
      'is_pregnant': true,
    });
  });

  testWidgets('«пустая» уходит на сервер, и лента закрывает цикл', (
    tester,
  ) async {
    final repository = await _pump(tester);

    await tester.tap(find.text('Прощупала'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Пустая'));
    await tester.pumpAndSettle();

    expect(repository.updates.single, {
      'palpation_date': _iso(DateTime.now()),
      'is_pregnant': false,
    });

    // Ответ сервера подставляется в ленту сразу: самка пустая, щупать больше
    // нечего.
    expect(find.text('Самка пустая'), findsOneWidget);
    expect(find.text('Прощупала'), findsNothing);
  });

  testWidgets('записанный результат второй раз не спрашивают', (tester) async {
    await _pump(
      tester,
      breeding: _breeding(palpationDate: '2026-09-01', isPregnant: true),
    );

    expect(find.text('Прощупала'), findsNothing);
    expect(find.text('Окрол ожидается'), findsOneWidget);
  });

  testWidgets('по записанному окролу щупать уже нечего', (tester) async {
    await _pump(tester, breeding: _breeding(status: 'completed'));

    expect(find.text('Прощупала'), findsNothing);
  });

  testWidgets('работнику кнопку не показывают — сервер её не пропустит', (
    tester,
  ) async {
    await _pump(tester, role: FarmRoleAccess.worker);

    expect(find.text('Прощупала'), findsNothing);
    expect(find.text('Проверить сукрольность'), findsOneWidget);
  });
}
