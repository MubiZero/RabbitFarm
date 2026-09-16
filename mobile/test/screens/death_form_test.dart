import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:mobile/core/api/api_client.dart';
import 'package:mobile/core/cache/cache_scope.dart';
import 'package:mobile/core/offline_queue/offline_queue.dart';
import 'package:mobile/core/widgets/app_slide_to_confirm.dart';
import 'package:mobile/core/providers/connectivity.dart';
import 'package:mobile/features/rabbits/data/models/rabbit_model.dart';
import 'package:mobile/features/rabbits/data/repositories/rabbits_repository.dart';
import 'package:mobile/features/rabbits/presentation/providers/rabbits_provider.dart';
import 'package:mobile/features/rabbits/presentation/screens/death_form_screen.dart';
import 'package:mobile/shared/models/api_response.dart';

import '../support/test_app.dart';

/// Падёж отмечают у клетки, где связи обычно нет, — поэтому проверяется не
/// вёрстка, а две вещи: что уходит на сервер и что происходит, когда сети нет.
class _FakeRabbitsRepository extends RabbitsRepository {
  _FakeRabbitsRepository()
      : super(apiClient: ApiClient(storage: const FlutterSecureStorage()));

  final List<(int, Map<String, dynamic>)> updates = [];

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

  @override
  Future<RabbitModel> updateRabbit(int id, Map<String, dynamic> data) async {
    updates.add((id, data));
    return _rabbit(status: data['status'] as String? ?? 'active');
  }
}

RabbitModel _rabbit({String status = 'active'}) => RabbitModel(
      id: 42,
      name: 'Мушка',
      tagId: 'A-0231',
      breedId: 1,
      sex: 'female',
      birthDate: DateTime(2026, 1, 1),
      status: status,
      purpose: 'breeding',
      createdAt: DateTime(2026, 1, 1),
      updatedAt: DateTime(2026, 1, 1),
    );

Widget _screen({
  required bool online,
  required _FakeRabbitsRepository repository,
}) =>
    testAppScreen(
      DeathFormScreen(rabbit: _rabbit()),
      overrides: [
        rabbitsRepositoryProvider.overrideWithValue(repository),
        isOnlineProvider.overrideWith((ref) => Stream.value(online)),
        cacheScopeProvider.overrideWithValue(null),
      ],
    );

/// Падёж подтверждают сдвигом, а не нажатием: у клетки, в перчатке,
/// случайное касание кнопки стоило бы необратимой записи.
Future<void> _slideToConfirm(WidgetTester tester) async {
  final knob = find.descendant(
    of: find.byType(AppSlideToConfirm),
    matching: find.byType(GestureDetector),
  );
  await tester.drag(knob.first, const Offset(1000, 0));
  await tester.pumpAndSettle();
}

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('отправляет статус, дату и причину — а не только статус', (
    tester,
  ) async {
    final repository = _FakeRabbitsRepository();
    await tester.pumpWidget(_screen(online: true, repository: repository));
    await tester.pump();

    await tester.enterText(
      find.byType(TextFormField).last,
      'Не ела два дня',
    );
    await _slideToConfirm(tester);

    final (id, data) = repository.updates.single;
    expect(id, 42);
    // Слово написано здесь буквой намеренно: это значение с той стороны
    // провода. Сервер принимает только `dead`, а приложение слало
    // `deceased` и получало отказ на каждую попытку — сверка с собственной
    // константой такую ошибку пропустила бы, потому что ошибка была в ней.
    expect(data['status'], 'dead');
    // Дата смерти раньше не отправлялась вовсе: в форме кролика её просто не
    // было, хотя сервер принимал.
    expect(data['death_date'], isNotNull);
    expect(data['death_reason'], 'Не ела два дня');
  });

  testWidgets('без связи запись уходит в очередь, а не теряется', (
    tester,
  ) async {
    final repository = _FakeRabbitsRepository();
    late ProviderContainer container;

    await tester.pumpWidget(
      ProviderScope(
        retry: (retryCount, error) => null,
        overrides: [
          rabbitsRepositoryProvider.overrideWithValue(repository),
          isOnlineProvider.overrideWith((ref) => Stream.value(false)),
          cacheScopeProvider.overrideWithValue(null),
        ],
        child: Builder(
          builder: (context) {
            container = ProviderScope.containerOf(context);
            return _screen(online: false, repository: repository);
          },
        ),
      ),
    );
    await tester.pump();

    await _slideToConfirm(tester);

    // На сервер не ходили, но и не потеряли: запись ждёт связи.
    expect(repository.updates, isEmpty);
    expect(container.read(offlineQueueProvider), hasLength(1));
    expect(
      container.read(offlineQueueProvider).single.type,
      OfflineActionType.rabbitDeath,
    );
  });
}
