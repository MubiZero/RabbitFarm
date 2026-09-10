import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mobile/core/api/api_failure.dart';
import 'package:mobile/core/providers/api_providers.dart';
import 'package:mobile/features/auth/data/repositories/auth_repository.dart';
import 'package:mobile/features/auth/presentation/providers/auth_provider.dart';
import 'package:mobile/features/auth/presentation/screens/login_screen.dart';

import '../support/test_app.dart';

/// Хранилище в памяти — как в register_screen_test.dart: настоящее ходит в
/// платформенный канал, которого в тестах нет.
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

class _FakeAuthRepository extends AuthRepository {
  _FakeAuthRepository({
    required super.apiClient,
    required super.storage,
    this.requestOtpError,
  });

  final Object? requestOtpError;

  // Настоящее хранилище остаётся ниже (isLoggedIn — реальный метод базового
  // класса, читает через инъецированное хранилище, а не платформенный канал).
  @override
  Future<void> requestOtp({required String phone}) async {
    if (requestOtpError != null) throw requestOtpError!;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Future<void> pumpLogin(WidgetTester tester, {Object? requestOtpError}) async {
    await tester.pumpWidget(testAppScreen(
      const LoginScreen(),
      overrides: [
        storageProvider.overrideWithValue(_FakeStorage()),
        authRepositoryProvider.overrideWith((ref) => _FakeAuthRepository(
              apiClient: ref.watch(apiClientProvider),
              storage: ref.watch(storageProvider),
              requestOtpError: requestOtpError,
            )),
      ],
    ));
    await tester.pumpAndSettle();
  }

  testWidgets('пустой телефон не даёт отправить запрос', (tester) async {
    await pumpLogin(tester);

    await tester.tap(find.text('Получить код'));
    await tester.pump();

    expect(find.text('Введите номер телефона'), findsOneWidget);
  });

  testWidgets('некорректный телефон подсвечивает ошибку', (tester) async {
    await pumpLogin(tester);

    await tester.enterText(find.byType(TextFormField), '123');
    await tester.tap(find.text('Получить код'));
    await tester.pump();

    expect(
      find.text('Телефон должен быть таджикским номером: +992XXXXXXXXX'),
      findsOneWidget,
    );
  });

  testWidgets('валидный телефон переводит на экран ввода кода', (tester) async {
    await pumpLogin(tester);

    await tester.enterText(find.byType(TextFormField), '901234567');
    await tester.tap(find.text('Получить код'));
    // Не pumpAndSettle: курсор Pinput на экране кода мигает бесконечной
    // анимацией, и pumpAndSettle никогда не увидит «нет запланированных
    // кадров» — как и мигающий курсор текстового поля в других тестах.
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text('Введите код'), findsOneWidget);
    expect(find.textContaining('+992901234567'), findsOneWidget);
  });

  testWidgets('ошибка сервера при запросе кода остаётся на экране телефона', (tester) async {
    await pumpLogin(
      tester,
      requestOtpError: const ApiFailure(
        ApiFailureKind.invalid,
        serverText: 'Слишком много запросов кода — попробуйте позже',
      ),
    );

    await tester.enterText(find.byType(TextFormField), '901234567');
    await tester.tap(find.text('Получить код'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(
      find.text('Слишком много запросов кода — попробуйте позже'),
      findsOneWidget,
    );
    expect(find.text('Введите код'), findsNothing);
  });
}
