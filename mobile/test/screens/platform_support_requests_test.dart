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
  String? answer,
  SupportRequestFarm? farm = const SupportRequestFarm(
    id: 7,
    name: 'Зелёная поляна',
  ),
  UserRef? author = const UserRef(
    id: 3,
    fullName: 'Иван',
    email: 'ivan@ferma.tj',
    phone: '+992 900 11 22 33',
  ),
}) {
  return SupportRequest(
    id: id,
    text: text,
    status: status,
    answer: answer,
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
  final answers = <String?>[];

  @override
  Future<SupportRequestsPage> getSupportRequests({
    int page = 1,
    int limit = 20,
  }) async {
    listCalls += 1;
    return (
      items: requests,
      page: PageInfo(
        page: 1,
        limit: limit,
        total: requests.length,
        totalPages: 1,
      ),
    );
  }

  @override
  Future<SupportRequest> resolveSupportRequest(int id, {String? answer}) async {
    if (resolveFailure != null) throw resolveFailure!;
    resolved.add(id);
    answers.add(answer);
    final source = requests.firstWhere((r) => r.id == id);
    return SupportRequest(
      id: source.id,
      text: source.text,
      status: 'resolved',
      answer: answer,
      resolvedAt: DateTime(2026, 9, 10, 9),
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
        platformAdminRepositoryProvider.overrideWithValue(repository)
      ],
    );

void main() {
  group('Обращения в поддержку (админ)', () {
    testWidgets('строка показывает ферму, автора, текст и статус', (
      tester,
    ) async {
      await tester.pumpWidget(_tab(_FakeRepository(requests: [_request()])));
      await _settle(tester);

      expect(find.text('Зелёная поляна'), findsOneWidget);
      expect(find.text('Иван'), findsOneWidget);
      expect(find.text('Не получается добавить кролика'), findsOneWidget);
      expect(find.text('новое'), findsOneWidget);
      expect(find.text('1 ОБРАЩЕНИЕ'), findsOneWidget);
    });

    testWidgets('пустой список объясняет, откуда берутся обращения', (
      tester,
    ) async {
      await tester.pumpWidget(_tab(_FakeRepository()));
      await _settle(tester);

      expect(find.text('Обращений пока нет'), findsOneWidget);
    });

    testWidgets('почта и телефон автора видны и нажимаемы', (tester) async {
      await tester.pumpWidget(_tab(_FakeRepository(requests: [_request()])));
      await _settle(tester);

      expect(find.text('ivan@ferma.tj'), findsOneWidget);
      expect(find.text('+992 900 11 22 33'), findsOneWidget);

      // Связаться с человеком — это нажатие, а не переписывание номера с
      // экрана: обе строки обязаны быть кнопками нужного размера.
      for (final value in ['ivan@ferma.tj', '+992 900 11 22 33']) {
        // Ближайший предок, а не карточка целиком: сама `AppCard` тоже
        // `InkWell`, и её высота ничего не сказала бы про строку контакта.
        final row = find
            .ancestor(of: find.text(value), matching: find.byType(InkWell))
            .first;
        expect(row, findsOneWidget);
        expect(tester.getSize(row).height, greaterThanOrEqualTo(56));
      }
    });

    testWidgets('закрытие с ответом уходит на сервер вместе с текстом', (
      tester,
    ) async {
      final repository = _FakeRepository(requests: [_request()]);
      await tester.pumpWidget(_tab(repository));
      await _settle(tester);

      expect(find.text('Отметить разобранным'), findsOneWidget);

      await tester.tap(find.text('Отметить разобранным'));
      await _settle(tester);

      await tester.enterText(
        find.byType(TextField),
        'Обновите приложение — в версии 2.3 это исправлено',
      );
      await tester.pump();

      await tester.tap(find.text('Отправить ответ'));
      await _settle(tester);

      expect(repository.resolved, [1]);
      expect(repository.answers, [
        'Обновите приложение — в версии 2.3 это исправлено',
      ]);
      expect(find.text('разобрано'), findsOneWidget);
      expect(find.text('Отметить разобранным'), findsNothing);
      // Ответ остался на карточке: второй админ не напишет то же самое заново.
      expect(
        find.text('Обновите приложение — в версии 2.3 это исправлено'),
        findsOneWidget,
      );
      // Обновилась запись на месте, список не перечитывался.
      expect(repository.listCalls, 1);
    });

    testWidgets('пустое поле закрывает обращение без ответа', (tester) async {
      final repository = _FakeRepository(requests: [_request()]);
      await tester.pumpWidget(_tab(repository));
      await _settle(tester);

      await tester.tap(find.text('Отметить разобранным'));
      await _settle(tester);

      await tester.tap(find.text('Закрыть без ответа'));
      await _settle(tester);

      expect(repository.answers, [null]);
      expect(find.text('разобрано'), findsOneWidget);
    });

    testWidgets('передумал в окне ответа — обращение осталось новым', (
      tester,
    ) async {
      final repository = _FakeRepository(requests: [_request()]);
      await tester.pumpWidget(_tab(repository));
      await _settle(tester);

      await tester.tap(find.text('Отметить разобранным'));
      await _settle(tester);

      await tester.tap(find.text('Отмена'));
      await _settle(tester);

      expect(repository.resolved, isEmpty);
      expect(find.text('новое'), findsOneWidget);
    });

    testWidgets('отказ сервера не меняет статус и не роняет экран', (
      tester,
    ) async {
      final repository = _FakeRepository(
        requests: [_request()],
        resolveFailure: Exception('Сервер недоступен'),
      );
      await tester.pumpWidget(_tab(repository));
      await _settle(tester);

      await tester.tap(find.text('Отметить разобранным'));
      await _settle(tester);

      await tester.tap(find.text('Закрыть без ответа'));
      await _settle(tester);

      expect(find.text('новое'), findsOneWidget);
      expect(find.text('Сервер недоступен'), findsOneWidget);
    });
  });
}
