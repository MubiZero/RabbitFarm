import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:mobile/core/api/api_client.dart';
import 'package:mobile/features/rabbits/data/models/breed_model.dart';
import 'package:mobile/features/rabbits/data/models/rabbit_model.dart';
import 'package:mobile/shared/models/api_response.dart';
import 'package:mobile/features/rabbits/data/repositories/rabbits_repository.dart';
import 'package:mobile/features/rabbits/data/repositories/breeds_repository.dart';
import 'package:mobile/features/rabbits/presentation/providers/rabbits_provider.dart';
import 'package:mobile/features/rabbits/presentation/screens/bulk_rabbits_screen.dart';

import '../support/test_app.dart';

/// Перенос стада, которое уже есть.
///
/// Проверяется не вёрстка, а то, что уходит на сервер: заводить триста голов
/// по одной форме никто не станет, и именно на этом перенос останавливался.
class _FakeRabbitsRepository extends RabbitsRepository {
  _FakeRabbitsRepository()
      : super(apiClient: ApiClient(storage: const FlutterSecureStorage()));

  final List<Map<String, dynamic>> bulkCalls = [];

  @override
  Future<int> createRabbitsBulk(Map<String, dynamic> data) async {
    bulkCalls.add(data);
    return (data['count'] as num).toInt();
  }

  // Экран обновляет список поголовья после переноса: без этого он ушёл бы
  // в настоящий сетевой вызов и тест завис бы на ожидании.
  @override
  Future<PaginatedResponse<RabbitModel>> getRabbits({
    int page = 1,
    int limit = 10,
    String? search,
    String? sex,
    String? status,
    String? purpose,
    int? breedId,
  }) async =>
      PaginatedResponse<RabbitModel>(
        items: const [],
        total: 0,
        page: page,
        limit: limit,
        totalPages: 0,
      );
}

/// Породы подменяются на уровне репозитория: сам провайдер грузит их сам,
/// и подменять его целиком значило бы обойти ту логику, которую экран и
/// использует.
class _FakeBreedsRepository extends BreedsRepository {
  _FakeBreedsRepository()
      : super(apiClient: ApiClient(storage: const FlutterSecureStorage()));

  @override
  Future<List<BreedModel>> getBreeds() async => [
        BreedModel(
          id: 3,
          name: 'Калифорнийская',
          createdAt: DateTime(2026, 1, 1),
          updatedAt: DateTime(2026, 1, 1),
        ),
      ];
}

Widget _screen(_FakeRabbitsRepository repository) => testAppScreen(
      const BulkRabbitsScreen(),
      overrides: [
        rabbitsRepositoryProvider.overrideWithValue(repository),
        breedsRepositoryProvider.overrideWithValue(_FakeBreedsRepository()),
      ],
    );

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('отправляет количество, породу и образец клейма', (tester) async {
    final repository = _FakeRabbitsRepository();
    await tester.pumpWidget(_screen(repository));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextFormField).first, '25');

    // Порода обязательна: без неё перенос не уйдёт.
    await tester.tap(find.text('Порода'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Калифорнийская').last);
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextFormField).last, 'R-');

    await tester.tap(find.text('Добавить'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    final sent = repository.bulkCalls.single;
    expect(sent['count'], 25);
    expect(sent['breed_id'], 3);
    expect(sent['tag_prefix'], 'R-');
  });

  testWidgets('без образца клейма поле не уходит вовсе', (tester) async {
    // Пустой образец означает «бирок нет»: тогда сервер запишет отсутствие
    // клейма, а не пустую строку, которая ломается об уникальный индекс.
    final repository = _FakeRabbitsRepository();
    await tester.pumpWidget(_screen(repository));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Порода'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Калифорнийская').last);
    await tester.pumpAndSettle();

    await tester.tap(find.text('Добавить'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(repository.bulkCalls.single.containsKey('tag_prefix'), isFalse);
  });

  testWidgets('больше ста голов за раз не принимает', (tester) async {
    final repository = _FakeRabbitsRepository();
    await tester.pumpWidget(_screen(repository));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextFormField).first, '500');
    await tester.tap(find.text('Добавить'));
    await tester.pumpAndSettle();

    expect(find.text('От 1 до 100'), findsOneWidget);
    expect(repository.bulkCalls, isEmpty);
  });
}
