import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mobile/core/api/api_client.dart';
import 'package:mobile/features/support/data/repositories/support_repository.dart';
import 'package:mobile/features/support/presentation/providers/support_provider.dart';
import 'package:mobile/features/support/presentation/screens/support_request_screen.dart';

import '../support/test_app.dart';

class _FakeSupportRepository extends SupportRepository {
  // `create` переопределён ниже и настоящего `ApiClient` не трогает — фейку
  // достаточно любого экземпляра, лишь бы завести родительский конструктор.
  _FakeSupportRepository({this.onCreate, this.error})
      : super(ApiClient(storage: const FlutterSecureStorage()));

  final void Function(String text)? onCreate;
  final Object? error;

  @override
  Future<void> create(String text) async {
    if (error != null) throw error!;
    onCreate?.call(text);
  }
}

void main() {
  group('SupportRequestScreen', () {
    testWidgets('кнопка выключена, пока текст короче 10 символов', (tester) async {
      await tester.pumpWidget(testAppScreen(
        const SupportRequestScreen(),
        overrides: [
          supportRepositoryProvider.overrideWithValue(_FakeSupportRepository()),
        ],
      ));

      await tester.enterText(find.byType(TextField), 'коротко');
      await tester.pump();

      final button = tester.widget<FilledButton>(find.byType(FilledButton));
      expect(button.onPressed, isNull);
    });

    testWidgets('отправляет текст и закрывает экран', (tester) async {
      String? sent;
      await tester.pumpWidget(testAppScreen(
        const SupportRequestScreen(),
        overrides: [
          supportRepositoryProvider.overrideWithValue(
            _FakeSupportRepository(onCreate: (text) => sent = text),
          ),
        ],
      ));

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
      await tester.pumpWidget(testAppScreen(
        const SupportRequestScreen(),
        overrides: [
          supportRepositoryProvider.overrideWithValue(
            _FakeSupportRepository(error: Exception('нет связи')),
          ),
        ],
      ));

      await tester.enterText(
        find.byType(TextField),
        'Не получается добавить кролика — приложение зависает',
      );
      await tester.pump();

      await tester.tap(find.byType(FilledButton));
      await tester.pumpAndSettle();

      expect(find.byType(SupportRequestScreen), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
    });
  });
}
