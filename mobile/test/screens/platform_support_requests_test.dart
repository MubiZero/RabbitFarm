import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mobile/core/api/api_client.dart';
import 'package:mobile/core/api/paginated.dart';
import 'package:mobile/core/models/user_ref.dart';
import 'package:mobile/features/platform_admin/data/models/platform_admin_models.dart';
import 'package:mobile/features/platform_admin/data/repositories/platform_admin_repository.dart';
import 'package:mobile/features/platform_admin/presentation/providers/platform_admin_provider.dart';
import 'package:mobile/features/platform_admin/presentation/screens/platform_support_requests_tab.dart';

import '../support/test_app.dart';

SupportRequest _request({
  int id = 1,
  String text = 'Не получается добавить кролика',
  String status = 'new',
  SupportRequestFarm? farm = const SupportRequestFarm(id: 7, name: 'Зелёная поляна'),
  UserRef? author = const UserRef(id: 3, fullName: 'Иван'),
}) {
  return SupportRequest(
    id: id,
    text: text,
    status: status,
    farm: farm,
    author: author,
    createdAt: DateTime(2026, 9, 9, 12, 30),
  );
}

/// Репозиторий с заранее известным ответом — тот же приём, что у истории
/// объявлений (`platform_announcements_test.dart`).
class _FakeRepository extends PlatformAdminRepository {
  _FakeRepository({this.requests = const [], this.resolveFailure})
      : super(ApiClient(storage: const FlutterSecureStorage()));

  final List<SupportRequest> requests;
  final Object? resolveFailure;

  int listCalls = 0;
  final resolved = <int>[];

  @override
  Future<SupportRequestsPage> getSupportRequests({int page = 1, int limit = 20}) async {
    listCalls += 1;
    return (
      items: requests,
      page: PageInfo(page: 1, limit: limit, total: requests.length, totalPages: 1),
    );
  }

  @override
  Future<SupportRequest> resolveSupportRequest(int id) async {
    if (resolveFailure != null) throw resolveFailure!;
    resolved.add(id);
    final source = requests.firstWhere((r) => r.id == id);
    return SupportRequest(
      id: source.id,
      text: source.text,
      status: 'resolved',
      farm: source.farm,
      author: source.author,
      createdAt: source.createdAt,
    );
  }
}

Future<void> _settle(WidgetTester tester) async {
  await tester.binding.setSurfaceSize(const Size(420, 1200));
  addTearDown(() => tester.binding.setSurfaceSize(null));
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 400));
}

Widget _tab(_FakeRepository repository) => testApp(
      const PlatformSupportRequestsTab(),
      overrides: [
        platformAdminRepositoryProvider.overrideWithValue(repository),
      ],
    );

void main() {
  group('Обращения в поддержку (админ)', () {
    testWidgets('строка показывает ферму, автора, текст и статус', (tester) async {
      await tester.pumpWidget(_tab(_FakeRepository(requests: [_request()])));
      await _settle(tester);

      expect(find.text('Зелёная поляна'), findsOneWidget);
      expect(find.text('Иван'), findsOneWidget);
      expect(find.text('Не получается добавить кролика'), findsOneWidget);
      expect(find.text('новое'), findsOneWidget);
      expect(find.text('1 ОБРАЩЕНИЕ'), findsOneWidget);
    });

    testWidgets('пустой список объясняет, откуда берутся обращения', (tester) async {
      await tester.pumpWidget(_tab(_FakeRepository()));
      await _settle(tester);

      expect(find.text('Обращений пока нет'), findsOneWidget);
    });

    testWidgets('разобранное обращение теряет кнопку и получает статус', (tester) async {
      final repository = _FakeRepository(requests: [_request()]);
      await tester.pumpWidget(_tab(repository));
      await _settle(tester);

      expect(find.text('Отметить разобранным'), findsOneWidget);

      await tester.tap(find.text('Отметить разобранным'));
      await _settle(tester);

      expect(repository.resolved, [1]);
      expect(find.text('разобрано'), findsOneWidget);
      expect(find.text('Отметить разобранным'), findsNothing);
      // Обновилась запись на месте, список не перечитывался.
      expect(repository.listCalls, 1);
    });

    testWidgets('отказ сервера не меняет статус и не роняет экран', (tester) async {
      final repository = _FakeRepository(
        requests: [_request()],
        resolveFailure: Exception('Сервер недоступен'),
      );
      await tester.pumpWidget(_tab(repository));
      await _settle(tester);

      await tester.tap(find.text('Отметить разобранным'));
      await _settle(tester);

      expect(find.text('новое'), findsOneWidget);
      expect(find.text('Сервер недоступен'), findsOneWidget);
    });
  });
}
