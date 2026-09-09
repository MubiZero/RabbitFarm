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
    await tester.pumpWidget(testAppScreen(
      const RegisterScreen(),
      overrides: [storageProvider.overrideWithValue(_FakeStorage())],
    ));
    await tester.pumpAndSettle();
  }

  Finder farmNameField() => find.ancestor(
        of: find.text('Название фермы'),
        matching: find.byType(TextFormField),
      );

  testWidgets('подставляет название фермы из онбординга', (tester) async {
    SharedPreferences.setMockInitialValues({'farm_name': '  Ферма Заря  '});

    await pumpRegister(tester);

    // Название показали на экране «... готова к работе!» — на регистрации оно
    // должно быть уже в поле, иначе бэкенд заведёт ферму под другим именем.
    expect(
      tester.widget<TextFormField>(farmNameField()).controller!.text,
      'Ферма Заря',
    );
  });

  testWidgets('оставляет поле пустым, если онбординг не проходили',
      (tester) async {
    SharedPreferences.setMockInitialValues({});

    await pumpRegister(tester);

    expect(tester.widget<TextFormField>(farmNameField()).controller!.text, '');
  });
}
