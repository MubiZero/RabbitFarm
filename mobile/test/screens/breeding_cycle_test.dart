import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:mobile/core/access/farm_access.dart';
import 'package:mobile/core/api/api_client.dart';
import 'package:mobile/core/api/api_failure.dart';
import 'package:mobile/features/breeding/data/repositories/breeding_repository.dart';
import 'package:mobile/features/breeding/presentation/providers/breeding_provider.dart';
import 'package:mobile/features/breeding/presentation/screens/breeding_cycle_screen.dart';
import 'package:mobile/features/rabbits/data/models/breeding_model.dart';
import 'package:mobile/features/rabbits/data/models/rabbit_model.dart';
import 'package:mobile/shared/models/api_response.dart';

import '../support/test_app.dart';

/// Лента цикла отвечает на вопрос «что делать сегодня», поэтому проверяется
/// не вёрстка, а то, что фермер увидит первым: чья это самка, какое дело
/// ближайшее и не просрочено ли оно.
class _FakeBreedingRepository extends BreedingRepository {
  final List<BreedingModel> items;
  final Object? failure;

  _FakeBreedingRepository({this.items = const [], this.failure})
      : super(
          apiClient: ApiClient(
            storage: const FlutterSecureStorage(),
            baseUrl: 'http://localhost',
          ),
        );

  @override
  Future<PaginatedResponse<BreedingModel>> getBreedings({
    int page = 1,
    int limit = 20,
    String? status,
    int? maleId,
    int? femaleId,
    String? fromDate,
    String? toDate,
  }) async {
    if (failure != null) throw failure!;
    return PaginatedResponse<BreedingModel>(
      items: items,
      total: items.length,
      page: 1,
      limit: limit,
      totalPages: 1,
    );
  }
}

RabbitModel rabbit(int id, String name, String sex) => RabbitModel(
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

String _iso(DateTime date) =>
    '${date.year.toString().padLeft(4, '0')}-'
    '${date.month.toString().padLeft(2, '0')}-'
    '${date.day.toString().padLeft(2, '0')}';

/// Даты в ленте живут относительно «сегодня», поэтому фикстуры строятся
/// сдвигом от текущего дня, а не жёсткими датами.
BreedingModel breeding({
  required int id,
  required int bredDaysAgo,
  String status = 'planned',
  bool? isPregnant,
  String femaleName = 'Зорька',
  String maleName = 'Буран',
  int? bornDaysAgo,
  int? weanedDaysAgo,
}) {
  final today = DateTime.now();
  // Сдвиг делается конструктором, а не Duration: на переводе часов сутки не
  // равны 24 часам, и тест начал бы падать раз в полгода.
  final bred = DateTime(today.year, today.month, today.day - bredDaysAgo);
  final expected = DateTime(bred.year, bred.month, bred.day + 31);
  String? daysAgo(int? days) => days == null
      ? null
      : _iso(DateTime(today.year, today.month, today.day - days));

  return BreedingModel(
    id: id,
    maleId: 10 + id,
    femaleId: 20 + id,
    breedingDate: _iso(bred),
    status: status,
    isPregnant: isPregnant,
    expectedBirthDate: _iso(expected),
    actualBirthDate: daysAgo(bornDaysAgo),
    weaningDate: daysAgo(weanedDaysAgo),
    male: rabbit(10 + id, maleName, 'male'),
    female: rabbit(20 + id, femaleName, 'female'),
  );
}

Widget _wrap({
  List<BreedingModel> items = const [],
  Object? failure,
  FarmRoleAccess role = FarmRoleAccess.owner,
}) =>
    testAppScreen(
      const BreedingCycleScreen(),
      overrides: [
        farmRoleProvider.overrideWithValue(role),
        breedingRepositoryProvider.overrideWithValue(
          _FakeBreedingRepository(items: items, failure: failure),
        ),
      ],
    );

Future<void> _settle(WidgetTester tester) async {
  await tester.binding.setSurfaceSize(const Size(420, 2000));
  addTearDown(() => tester.binding.setSurfaceSize(null));
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 400));
}

void main() {
  setUpAll(() => initializeDateFormatting('ru_RU', null));

  testWidgets('строка показывает пару, день цикла и ближайшее дело',
      (tester) async {
    await tester.pumpWidget(_wrap(items: [breeding(id: 1, bredDaysAgo: 3)]));
    await _settle(tester);

    expect(find.text('Зорька'), findsOneWidget);
    expect(find.text('Самец: Буран'), findsOneWidget);
    expect(find.text('4-й день'), findsOneWidget);
    expect(find.text('Проверить сукрольность'), findsOneWidget);
    expect(find.textContaining('через 11 дней'), findsOneWidget);
  });

  testWidgets('просроченное дело выше предстоящего', (tester) async {
    await tester.pumpWidget(_wrap(items: [
      breeding(id: 1, bredDaysAgo: 2, femaleName: 'Ждущая'),
      breeding(
        id: 2,
        bredDaysAgo: 40,
        isPregnant: true,
        femaleName: 'Горящая',
      ),
    ]));
    await _settle(tester);

    expect(find.textContaining('просрочено на 9 дней'), findsOneWidget);
    expect(
      tester.getTopLeft(find.text('Горящая')).dy,
      lessThan(tester.getTopLeft(find.text('Ждущая')).dy),
    );
  });

  testWidgets('окрол записан — впереди отсадка, срок приблизительный',
      (tester) async {
    await tester.pumpWidget(_wrap(items: [
      breeding(id: 1, bredDaysAgo: 40, status: 'completed'),
    ]));
    await _settle(tester);

    expect(find.text('Отсадка молодняка'), findsOneWidget);
    expect(find.textContaining('примерно'), findsOneWidget);
  });

  testWidgets('с настоящей датой окрола срок точный, без «примерно»',
      (tester) async {
    await tester.pumpWidget(_wrap(items: [
      breeding(id: 1, bredDaysAgo: 40, status: 'completed', bornDaysAgo: 5),
    ]));
    await _settle(tester);

    expect(find.text('Отсадка молодняка'), findsOneWidget);
    expect(find.textContaining('через 40 дней'), findsOneWidget);
    expect(find.textContaining('примерно'), findsNothing);
  });

  testWidgets('отсадка записана — молодняк отсажен, а не просрочен',
      (tester) async {
    await tester.pumpWidget(_wrap(items: [
      breeding(
        id: 1,
        bredDaysAgo: 120,
        status: 'completed',
        bornDaysAgo: 85,
        weanedDaysAgo: 30,
      ),
    ]));
    await _settle(tester);

    expect(find.text('Молодняк отсажен'), findsOneWidget);
    expect(find.textContaining('просрочено'), findsNothing);
  });

  testWidgets('управляющему доступны подбор пары и запись окрола',
      (tester) async {
    await tester.pumpWidget(_wrap(
      items: [breeding(id: 1, bredDaysAgo: 30, isPregnant: true)],
      role: FarmRoleAccess.manager,
    ));
    await _settle(tester);

    expect(find.text('Подобрать пару'), findsOneWidget);
    expect(find.text('Записать окрол'), findsOneWidget);
  });

  testWidgets('работнику не показывают кнопки, которые сервер не пропустит',
      (tester) async {
    await tester.pumpWidget(_wrap(
      items: [breeding(id: 1, bredDaysAgo: 30, isPregnant: true)],
      role: FarmRoleAccess.worker,
    ));
    await _settle(tester);

    expect(find.text('Подобрать пару'), findsNothing);
    expect(find.text('Записать окрол'), findsNothing);
    expect(find.text('Окрол ожидается'), findsOneWidget);
  });

  testWidgets('пустая лента подсказывает, с чего начать', (tester) async {
    await tester.pumpWidget(_wrap());
    await _settle(tester);

    expect(find.text('Случек пока нет'), findsOneWidget);
    expect(find.text('Записать случку'), findsOneWidget);
  });

  testWidgets('ошибка объясняется и даёт повторить', (tester) async {
    await tester.pumpWidget(
      _wrap(failure: const ApiFailure(ApiFailureKind.offline)),
    );
    await _settle(tester);

    expect(find.text('Нет связи — проверьте интернет'), findsOneWidget);
    expect(find.text('Повторить'), findsOneWidget);
  });
}
