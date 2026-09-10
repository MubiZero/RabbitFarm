import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mobile/core/api/api_failure.dart';
import 'package:mobile/core/providers/api_providers.dart';
import 'package:mobile/features/auth/data/models/user_model.dart';
import 'package:mobile/features/auth/data/repositories/auth_repository.dart';
import 'package:mobile/features/auth/presentation/providers/auth_provider.dart';
import 'package:mobile/features/auth/presentation/screens/password_screen.dart';

import '../support/test_app.dart';

/// Хранилище в памяти — как в register_screen_test.dart.
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
      key == 'access_token' ? 'fake-token' : null;
}

UserModel _user({required bool hasPassword}) => UserModel(
      id: 1,
      email: 'ivan@farm.test',
      fullName: 'Иван',
      role: 'owner',
      isActive: true,
      hasPassword: hasPassword,
      createdAt: DateTime(2026, 1, 1),
      updatedAt: DateTime(2026, 1, 1),
    );

class _FakeAuthRepository extends AuthRepository {
  _FakeAuthRepository({
    required super.apiClient,
    required super.storage,
    required this.seedUser,
    this.setPasswordError,
    this.changePasswordError,
  });

  final UserModel seedUser;
  final Object? setPasswordError;
  final Object? changePasswordError;

  @override
  Future<bool> isLoggedIn() async => true;

  @override
  Future<UserModel> getProfile() async => seedUser;

  @override
  Future<void> setPassword(String newPassword) async {
    if (setPasswordError != null) throw setPasswordError!;
  }

  @override
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    if (changePasswordError != null) throw changePasswordError!;
  }

  @override
  Future<void> logout() async {}
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Future<void> pumpPassword(
    WidgetTester tester, {
    required bool hasPassword,
    Object? setPasswordError,
    Object? changePasswordError,
  }) async {
    await tester.pumpWidget(testAppScreen(
      const PasswordScreen(),
      overrides: [
        storageProvider.overrideWithValue(_FakeStorage()),
        authRepositoryProvider.overrideWith((ref) => _FakeAuthRepository(
              apiClient: ref.watch(apiClientProvider),
              storage: ref.watch(storageProvider),
              seedUser: _user(hasPassword: hasPassword),
              setPasswordError: setPasswordError,
              changePasswordError: changePasswordError,
            )),
      ],
    ));
    await tester.pumpAndSettle();
  }

  testWidgets('без пароля — форма «Задать пароль» без текущего пароля',
      (tester) async {
    await pumpPassword(tester, hasPassword: false);

    expect(find.text('Задать пароль'), findsOneWidget);
    expect(find.text('Текущий пароль'), findsNothing);
  });

  testWidgets('с паролем — форма «Изменить пароль» с текущим паролем',
      (tester) async {
    await pumpPassword(tester, hasPassword: true);

    expect(find.text('Изменить пароль'), findsOneWidget);
    expect(find.text('Текущий пароль'), findsOneWidget);
  });

  testWidgets('короткий новый пароль не проходит валидацию', (tester) async {
    await pumpPassword(tester, hasPassword: false);

    await tester.enterText(find.byType(TextFormField).first, 'short');
    await tester.enterText(find.byType(TextFormField).last, 'short');
    await tester.tap(find.text('Сохранить'));
    await tester.pump();

    expect(find.text('Пароль должен быть не короче 8 символов'), findsOneWidget);
  });

  testWidgets('несовпадающее повторение не проходит валидацию', (tester) async {
    await pumpPassword(tester, hasPassword: false);

    await tester.enterText(find.byType(TextFormField).first, 'password123');
    await tester.enterText(find.byType(TextFormField).last, 'different123');
    await tester.tap(find.text('Сохранить'));
    await tester.pump();

    expect(find.text('Пароли не совпадают'), findsOneWidget);
  });

  testWidgets('ошибка сервера при установке пароля показывает сообщение',
      (tester) async {
    await pumpPassword(
      tester,
      hasPassword: false,
      setPasswordError: const ApiFailure(
        ApiFailureKind.invalid,
        serverText: 'Пароль уже задан — смените его через «Изменить пароль»',
      ),
    );

    await tester.enterText(find.byType(TextFormField).first, 'password123');
    await tester.enterText(find.byType(TextFormField).last, 'password123');
    await tester.tap(find.text('Сохранить'));
    await tester.pumpAndSettle();

    expect(
      find.text('Пароль уже задан — смените его через «Изменить пароль»'),
      findsOneWidget,
    );
  });

  testWidgets('успешная смена пароля разлогинивает', (tester) async {
    await pumpPassword(tester, hasPassword: true);

    await tester.enterText(find.byType(TextFormField).at(0), 'oldpassword');
    await tester.enterText(find.byType(TextFormField).at(1), 'newpassword123');
    await tester.enterText(find.byType(TextFormField).at(2), 'newpassword123');
    await tester.tap(find.text('Сохранить'));
    await tester.pumpAndSettle();

    final context = tester.element(find.byType(PasswordScreen));
    final container = ProviderScope.containerOf(context);
    expect(container.read(authProvider).isAuthenticated, isFalse);
  });
}
