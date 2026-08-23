import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mobile/core/access/farm_access.dart';
import 'package:mobile/core/api/api_client.dart';
import 'package:mobile/features/cages/data/models/cage_model.dart';
import 'package:mobile/features/cages/data/repositories/cages_repository.dart';
import 'package:mobile/features/rabbits/data/models/rabbit_model.dart';
import 'package:mobile/features/rabbits/data/repositories/rabbits_repository.dart';
import 'package:mobile/features/rabbits/presentation/providers/rabbits_provider.dart';
import 'package:mobile/features/rabbits/presentation/screens/herd_screen.dart';
import 'package:mobile/shared/models/api_response.dart';

import '../support/test_app.dart';

CageModel _cage({
  required int id,
  required String number,
  String? location,
  int capacity = 4,
  int occupied = 0,
  String condition = 'good',
}) =>
    CageModel(
      id: id,
      number: number,
      type: 'single',
      capacity: capacity,
      location: location,
      condition: condition,
      currentOccupancy: occupied,
    );

RabbitModel _rabbit({
  required int id,
  required String name,
  required String purpose,
  String sex = 'female',
}) =>
    RabbitModel(
      id: id,
      tagId: 'A-$id',
      name: name,
      breedId: 1,
      sex: sex,
      birthDate: DateTime(2025, 3, 1),
      status: 'healthy',
      purpose: purpose,
      createdAt: DateTime(2025, 3, 1),
      updatedAt: DateTime(2025, 3, 1),
    );

/// Репозитории без сети: подменяются целиком, чтобы под тестом осталась
/// настоящая логика провайдеров — и раскладка клеток по рядам, и то, какой
/// отбор уходит на сервер за кроликами.
class _FakeCagesRepository extends CagesRepository {
  _FakeCagesRepository(this.cages)
      : super(apiClient: ApiClient(storage: const FlutterSecureStorage()));

  final List<CageModel> cages;

  @override
  Future<List<CageModel>> getCages({
    int page = 1,
    int limit = 50,
    String? type,
    String? condition,
    String? location,
    String? search,
    bool? onlyAvailable,
  }) async =>
      page == 1 ? cages : const [];
}

class _FakeRabbitsRepository extends RabbitsRepository {
  _FakeRabbitsRepository(this.rabbits)
      : super(apiClient: ApiClient(storage: const FlutterSecureStorage()));

  final List<RabbitModel> rabbits;

  /// Запросы запоминаются: отбор по назначению обязан уходить на сервер, а не
  /// отсеиваться среди приехавшей страницы.
  final List<String?> requestedPurposes = [];

  @override
  Future<PaginatedResponse<RabbitModel>> getRabbits({
    int page = 1,
    int limit = 10,
    String? search,
    String? sex,
    String? status,
    String? purpose,
    int? breedId,
  }) async {
    requestedPurposes.add(purpose);
    final items = purpose == null
        ? rabbits
        : rabbits.where((r) => r.purpose == purpose).toList();
    return PaginatedResponse<RabbitModel>(
      items: items,
      total: items.length,
      page: 1,
      limit: limit,
      totalPages: 1,
    );
  }
}

/// Скелетоны пульсируют бесконечно, поэтому `pumpAndSettle` не сходится: ждём
/// ответы провайдеров и доигрываем анимацию вручную. Окно растягиваем — карта
/// рядов длиннее стандартных 800x600.
Future<void> _settle(WidgetTester tester) async {
  await tester.binding.setSurfaceSize(const Size(420, 2000));
  addTearDown(() => tester.binding.setSurfaceSize(null));
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 400));
}

Widget _wrap({
  List<CageModel> cages = const [],
  List<RabbitModel> rabbits = const [],
  FarmRoleAccess role = FarmRoleAccess.owner,
  RabbitsRepository? rabbitsRepository,
}) =>
    testAppScreen(
      const HerdScreen(),
      overrides: [
        cagesRepositoryProvider.overrideWithValue(_FakeCagesRepository(cages)),
        rabbitsRepositoryProvider.overrideWithValue(
            rabbitsRepository ?? _FakeRabbitsRepository(rabbits)),
        farmRoleProvider.overrideWithValue(role),
      ],
    );

Future<void> _openRabbits(WidgetTester tester) async {
  await tester.tap(find.text('Кролики'));
  await _settle(tester);
}

void main() {
  testWidgets('клетки показаны рядами, безымянный ряд — последним',
      (tester) async {
    await tester.pumpWidget(_wrap(cages: [
      _cage(id: 1, number: '2', location: 'Сарай', occupied: 1),
      _cage(id: 2, number: '10', location: 'Сарай', occupied: 4),
      _cage(id: 3, number: '1', location: 'Навес'),
      _cage(id: 4, number: '7'),
    ]));
    await _settle(tester);

    expect(find.text('Навес'), findsOneWidget);
    expect(find.text('Сарай'), findsOneWidget);
    expect(find.text('Место не указано'), findsOneWidget);

    // Ряд без места стоит ниже названных: клетки, у которых адреса нет,
    // не должны разбавлять карту сверху.
    final navesTop = tester.getTopLeft(find.text('Навес')).dy;
    final saraiTop = tester.getTopLeft(find.text('Сарай')).dy;
    final homelessTop = tester.getTopLeft(find.text('Место не указано')).dy;
    expect(navesTop, lessThan(saraiTop));
    expect(saraiTop, lessThan(homelessTop));

    // Занятость считается по всему ряду, а не по одной клетке.
    expect(find.text('Занято 5 из 8'), findsOneWidget);
  });

  testWidgets('клетки в ряду идут по номеру, а не посимвольно', (tester) async {
    await tester.pumpWidget(_wrap(cages: [
      _cage(id: 1, number: '10', location: 'Сарай'),
      _cage(id: 2, number: '2', location: 'Сарай'),
    ]));
    await _settle(tester);

    expect(
      tester.getTopLeft(find.text('2')).dx,
      lessThan(tester.getTopLeft(find.text('10')).dx),
    );
  });

  testWidgets('поиск по клеткам ищет по номеру и по ряду', (tester) async {
    await tester.pumpWidget(_wrap(cages: [
      _cage(id: 1, number: '2', location: 'Сарай'),
      _cage(id: 2, number: '3', location: 'Навес'),
    ]));
    await _settle(tester);

    await tester.enterText(find.byType(TextField), 'навес');
    await _settle(tester);

    expect(find.text('Навес'), findsOneWidget);
    expect(find.text('Сарай'), findsNothing);
  });

  testWidgets('клеток нет — владельцу подсказывают завести первую',
      (tester) async {
    await tester.pumpWidget(_wrap());
    await _settle(tester);

    expect(find.text('Клеток пока нет'), findsOneWidget);
    expect(find.text('Добавить клетку'), findsOneWidget);
  });

  testWidgets('работнику кнопку «Добавить клетку» не показывают',
      (tester) async {
    await tester.pumpWidget(_wrap(role: FarmRoleAccess.worker));
    await _settle(tester);

    expect(find.text('Клеток пока нет'), findsOneWidget);
    // Кнопка, которая вернёт работнику отказ, не показывается вовсе: человек
    // решит, что приложение сломалось, а не что ему не положено.
    expect(find.text('Добавить клетку'), findsNothing);
  });

  testWidgets('кролики показывают назначение прямо в карточке', (tester) async {
    await tester.pumpWidget(_wrap(rabbits: [
      _rabbit(id: 1, name: 'Белка', purpose: 'breeding'),
      _rabbit(id: 2, name: 'Стрелка', purpose: 'meat'),
    ]));
    await _settle(tester);
    await _openRabbits(tester);

    expect(find.text('Белка'), findsOneWidget);
    expect(find.text('На развод'), findsWidgets);
    expect(find.text('На мясо'), findsWidgets);
  });

  testWidgets('отбор по назначению уходит на сервер, а не режет страницу',
      (tester) async {
    final repository = _FakeRabbitsRepository([
      _rabbit(id: 1, name: 'Белка', purpose: 'breeding'),
      _rabbit(id: 2, name: 'Стрелка', purpose: 'meat'),
    ]);

    await tester.pumpWidget(_wrap(rabbitsRepository: repository));
    await _settle(tester);
    await _openRabbits(tester);

    // Ярлык назначения и подпись в карточке — одно и то же слово, поэтому
    // жмём именно ярлык в строке фильтров.
    await tester.tap(find.widgetWithText(FilterChip, 'На мясо'));
    await _settle(tester);

    expect(repository.requestedPurposes.last, 'meat');
    expect(find.text('Белка'), findsNothing);
    expect(find.text('Стрелка'), findsOneWidget);
  });

  testWidgets('вкладка открывается на всём поголовье, даже если отбор остался',
      (tester) async {
    final repository = _FakeRabbitsRepository([
      _rabbit(id: 1, name: 'Белка', purpose: 'breeding'),
    ]);

    await tester.pumpWidget(testAppScreen(
      const HerdScreen(),
      overrides: [
        cagesRepositoryProvider.overrideWithValue(_FakeCagesRepository(const [])),
        rabbitsRepositoryProvider.overrideWithValue(repository),
        farmRoleProvider.overrideWithValue(FarmRoleAccess.owner),
        // Список кроликов общий с экраном «Кролики»: заходим на вкладку так,
        // будто там уже отобрали откорм.
        rabbitsListProvider.overrideWith((ref) {
          final notifier = RabbitsListNotifier(repository);
          notifier.applyFilter(const RabbitsFilter(purpose: 'meat'));
          return notifier;
        }),
      ],
    ));
    await _settle(tester);
    await _openRabbits(tester);

    // Отбор сброшен, и в списке снова всё поголовье — иначе ярлык «Все» стоял
    // бы над выборкой, которой он не соответствует.
    expect(repository.requestedPurposes.last, isNull);
    expect(find.text('Белка'), findsOneWidget);
  });
}
