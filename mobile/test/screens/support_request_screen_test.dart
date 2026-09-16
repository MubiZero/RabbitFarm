import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mobile/core/api/api_client.dart';
import 'package:mobile/core/api/paginated.dart';
import 'package:mobile/core/models/support_contact.dart';
import 'package:mobile/features/support/data/models/support_request.dart';
import 'package:mobile/features/support/data/repositories/support_repository.dart';
import 'package:mobile/features/support/presentation/providers/support_provider.dart';
import 'package:mobile/features/support/presentation/screens/support_request_form_screen.dart';
import 'package:mobile/features/support/presentation/screens/support_request_screen.dart';

import '../support/test_app.dart';

SupportRequest _request({
  int id = 1,
  String text = 'Не получается добавить кролика',
  String status = 'new',
  String? answer,
  DateTime? resolvedAt,
}) {
  return SupportRequest(
    id: id,
    text: text,
    status: status,
    answer: answer,
    resolvedAt: resolvedAt,
    createdAt: DateTime(2026, 9, 9, 12, 30),
  );
}

class _FakeSupportRepository extends SupportRepository {
  // Все методы переопределены ниже и настоящего `ApiClient` не трогают —
  // фейку достаточно любого экземпляра, лишь бы завести родительский
  // конструктор.
  _FakeSupportRepository({
    this.onCreate,
    this.error,
    this.requests = const [],
    this.contact = const SupportContact(),
  }) : super(ApiClient(storage: const FlutterSecureStorage()));

  final void Function(String text)? onCreate;
  final Object? error;
  final List<SupportRequest> requests;
  final SupportContact contact;

  @override
  Future<void> create(String text) async {
    if (error != null) throw error!;
    onCreate?.call(text);
  }

  @override
  Future<SupportRequestsPage> list({int page = 1, int limit = 20}) async {
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
  Future<SupportContact> getContact() async => contact;
}

Future<void> _settle(WidgetTester tester) async {
  await tester.binding.setSurfaceSize(const Size(420, 1200));
  addTearDown(() => tester.binding.setSurfaceSize(null));
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 400));
}

Widget _screen(_FakeSupportRepository repository) => testAppScreen(
      const SupportRequestScreen(),
      overrides: [supportRepositoryProvider.overrideWithValue(repository)],
    );

void main() {
  group('Поддержка: свои обращения', () {
    testWidgets('ферма видит ответ поддержки на своё обращение', (
      tester,
    ) async {
      await tester.pumpWidget(
        _screen(
          _FakeSupportRepository(
            requests: [
              _request(
                status: 'resolved',
                answer: 'Обновите приложение — в версии 2.3 это исправлено',
                resolvedAt: DateTime(2026, 9, 10, 9),
              ),
            ],
          ),
        ),
      );
      await _settle(tester);

      expect(find.text('Не получается добавить кролика'), findsOneWidget);
      expect(find.text('Поддержка ответила'), findsOneWidget);
      expect(find.text('Ответ поддержки'), findsOneWidget);
      expect(
        find.text('Обновите приложение — в версии 2.3 это исправлено'),
        findsOneWidget,
      );
    });

    testWidgets('обращение без ответа показано как ожидающее', (tester) async {
      await tester.pumpWidget(
        _screen(_FakeSupportRepository(requests: [_request()])),
      );
      await _settle(tester);

      expect(find.text('Ждём ответа'), findsOneWidget);
      expect(find.text('Ответ поддержки'), findsNothing);
    });

    testWidgets('закрытое без ответа обращение не молчит', (tester) async {
      await tester.pumpWidget(
        _screen(
          _FakeSupportRepository(requests: [_request(status: 'resolved')]),
        ),
      );
      await _settle(tester);

      expect(
        find.text('Обращение закрыто без письменного ответа.'),
        findsOneWidget,
      );
    });

    testWidgets('пустой список объясняет, зачем сюда писать', (tester) async {
      await tester.pumpWidget(_screen(_FakeSupportRepository()));
      await _settle(tester);

      expect(find.text('Обращений пока нет'), findsOneWidget);
      expect(find.text('Написать в поддержку'), findsOneWidget);
    });

    testWidgets('контакт поддержки показан, когда он задан', (tester) async {
      await tester.pumpWidget(
        _screen(
          _FakeSupportRepository(
            requests: [_request()],
            contact: const SupportContact(
              email: 'help@rabbitfarm.tj',
              phone: '+992 900 00 00 00',
            ),
          ),
        ),
      );
      await _settle(tester);

      expect(find.text('help@rabbitfarm.tj'), findsOneWidget);
      expect(find.text('+992 900 00 00 00'), findsOneWidget);
    });

    testWidgets('кнопка открывает форму нового обращения', (tester) async {
      await tester.pumpWidget(_screen(_FakeSupportRepository()));
      await _settle(tester);

      await tester.tap(find.text('Написать'));
      await tester.pumpAndSettle();

      expect(find.byType(SupportRequestFormScreen), findsOneWidget);
    });
  });

  group('Поддержка: новое обращение', () {
    testWidgets('кнопка выключена, пока текст короче 10 символов', (
      tester,
    ) async {
      await tester.pumpWidget(
        testAppScreen(
          const SupportRequestFormScreen(),
          overrides: [
            supportRepositoryProvider.overrideWithValue(
              _FakeSupportRepository(),
            ),
          ],
        ),
      );

      await tester.enterText(find.byType(TextField), 'коротко');
      await tester.pump();

      final button = tester.widget<FilledButton>(find.byType(FilledButton));
      expect(button.onPressed, isNull);
    });

    testWidgets('отправляет текст и закрывает экран', (tester) async {
      String? sent;
      await tester.pumpWidget(
        testAppScreen(
          const SupportRequestFormScreen(),
          overrides: [
            supportRepositoryProvider.overrideWithValue(
              _FakeSupportRepository(onCreate: (text) => sent = text),
            ),
          ],
        ),
      );

      await tester.enterText(
        find.byType(TextField),
        'Не получается добавить кролика — приложение зависает',
      );
      await tester.pump();

      await tester.tap(find.byType(FilledButton));
      await tester.pumpAndSettle();

      expect(sent, 'Не получается добавить кролика — приложение зависает');
      expect(find.text('Обращение отправлено'), findsOneWidget);
    });

    testWidgets('ошибка сервера остаётся на экране с текстом', (tester) async {
      await tester.pumpWidget(
        testAppScreen(
          const SupportRequestFormScreen(),
          overrides: [
            supportRepositoryProvider.overrideWithValue(
              _FakeSupportRepository(error: Exception('нет связи')),
            ),
          ],
        ),
      );

      await tester.enterText(
        find.byType(TextField),
        'Не получается добавить кролика — приложение зависает',
      );
      await tester.pump();

      await tester.tap(find.byType(FilledButton));
      await tester.pumpAndSettle();

      expect(find.byType(SupportRequestFormScreen), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
    });
  });
}
