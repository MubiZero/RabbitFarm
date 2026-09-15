import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mobile/core/api/api_client.dart';
import 'package:mobile/features/notifications/data/models/notification_model.dart';
import 'package:mobile/features/notifications/data/repositories/notifications_repository.dart';
import 'package:mobile/features/notifications/presentation/providers/notifications_provider.dart';
import 'package:mobile/features/notifications/presentation/screens/notifications_screen.dart';

import '../support/test_app.dart';

/// Лента существует ровно потому, что пуш — канал ненадёжный по устройству:
/// человек мог отказать в разрешении, удалить приложение, потерять токен.
/// Раньше это значило, что о просроченных прививках и скором окроле он не
/// узнает вовсе.
class _FakeNotificationsRepository extends NotificationsRepository {
  _FakeNotificationsRepository({
    this.items = const [],
    this.unread = 0,
    this.markFails = false,
  }) : super(ApiClient(storage: const FlutterSecureStorage()));

  final List<AppNotification> items;
  final int unread;
  final bool markFails;
  int markCalls = 0;

  @override
  Future<List<AppNotification>> load({int page = 1, int limit = 30}) async =>
      items;

  @override
  Future<int> unreadCount() async => unread;

  @override
  Future<void> markAllRead() async {
    markCalls++;
    if (markFails) throw Exception('нет связи');
  }
}

AppNotification _notification({
  int id = 1,
  String title = 'Просроченные прививки',
  String body = 'Просрочено: 3',
  String? route = '/vaccinations',
  DateTime? readAt,
}) => AppNotification(
  id: id,
  title: title,
  body: body,
  createdAt: DateTime(2026, 9, 14, 8),
  route: route,
  type: 'vaccination_digest',
  readAt: readAt,
);

Widget _screen(_FakeNotificationsRepository repository) => testAppScreen(
  const NotificationsScreen(),
  overrides: [
    notificationsRepositoryProvider.overrideWithValue(repository),
  ],
);

void main() {
  testWidgets('показывает то, о чём сообщали, пока человек не смотрел', (
    tester,
  ) async {
    await tester.pumpWidget(
      _screen(
        _FakeNotificationsRepository(
          items: [
            _notification(),
            _notification(
              id: 2,
              title: 'Мало корма',
              body: 'Заканчивается: 1',
              route: '/feeds',
            ),
          ],
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Просроченные прививки'), findsOneWidget);
    expect(find.text('Просрочено: 3'), findsOneWidget);
    expect(find.text('Мало корма'), findsOneWidget);
  });

  testWidgets('открыл экран — значит прочитал, отдельной кнопки не нужно', (
    tester,
  ) async {
    final repository = _FakeNotificationsRepository(items: [_notification()]);

    await tester.pumpWidget(_screen(repository));
    await tester.pumpAndSettle();

    expect(repository.markCalls, 1);
  });

  testWidgets('сбой отметки не показывает ошибку — сообщения просто останутся', (
    tester,
  ) async {
    // Красная плашка из-за того, что не удалось погасить счётчик, была бы
    // хуже самой проблемы: человек всё равно увидит эти сообщения снова.
    final repository = _FakeNotificationsRepository(
      items: [_notification()],
      markFails: true,
    );

    await tester.pumpWidget(_screen(repository));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('Просроченные прививки'), findsOneWidget);
  });

  testWidgets('пустая лента объясняет, что здесь будет', (tester) async {
    await tester.pumpWidget(_screen(_FakeNotificationsRepository()));
    await tester.pumpAndSettle();

    expect(find.text('Пока тихо'), findsOneWidget);
  });

  testWidgets('колокольчик показывает число непрочитанных и прячется без них', (
    tester,
  ) async {
    await tester.pumpWidget(
      testApp(
        const NotificationsBell(),
        overrides: [
          notificationsRepositoryProvider.overrideWithValue(
            _FakeNotificationsRepository(unread: 3),
          ),
        ],
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('3'), findsOneWidget);

    await tester.pumpWidget(
      testApp(
        const NotificationsBell(),
        overrides: [
          notificationsRepositoryProvider.overrideWithValue(
            _FakeNotificationsRepository(),
          ),
        ],
      ),
    );
    await tester.pumpAndSettle();
    // Пустой значок обещал бы то, чего за ним нет.
    expect(find.text('0'), findsNothing);
  });
}
