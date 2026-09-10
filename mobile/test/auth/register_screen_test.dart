import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:mobile/core/providers/api_providers.dart';
import 'package:mobile/features/auth/presentation/screens/register_screen.dart';

import '../support/test_app.dart';

/// Хранилище в памяти — как в farm_status_reactive_test.dart: настоящее ходит
/// в платформенный канал, которого в тестах нет, а `AuthNotifier` лезет за
/// токенами прямо при создании.
class _FakeStorage extends FlutterSecureStorage {
  _FakeStorage() : super();

  @override
  Future<String?> read({
    required String key,
    IOSOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    MacOsOptions? mOptions,
    WindowsOptions? wOptions,
  }) async =>
      null;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Future<void> pumpRegister(WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(testAppScreen(
      const RegisterScreen(),
      overrides: [storageProvider.overrideWithValue(_FakeStorage())],
    ));
    await tester.pumpAndSettle();
  }

  testWidgets(
      'не даёт зарегистрироваться, пока не принята политика конфиденциальности',
      (tester) async {
    await pumpRegister(tester);
    final submitButton = find.text('Завести ферму');
    await tester.ensureVisible(submitButton);
    await tester.tap(submitButton);
    await tester.pump();

    expect(
      find.text('Нужно принять политику конфиденциальности, чтобы продолжить'),
      findsOneWidget,
    );
  });

  testWidgets('отмечает согласие по тапу на чекбокс', (tester) async {
    await pumpRegister(tester);
    final checkbox = find.byType(Checkbox);
    await tester.ensureVisible(checkbox);
    expect(tester.widget<Checkbox>(checkbox).value, isFalse);

    await tester.tap(checkbox);
    await tester.pump();

    expect(tester.widget<Checkbox>(checkbox).value, isTrue);
  });
}
