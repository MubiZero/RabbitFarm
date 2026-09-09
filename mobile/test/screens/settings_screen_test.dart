import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mobile/core/api/api_client.dart';
import 'package:mobile/features/auth/data/models/user_model.dart';
import 'package:mobile/features/auth/data/repositories/auth_repository.dart';
import 'package:mobile/features/auth/presentation/providers/auth_provider.dart';
import 'package:mobile/features/settings/presentation/screens/settings_screen.dart';

import '../support/test_app.dart';

UserModel _user({bool digestEnabled = true}) => UserModel(
      id: 1,
      email: 'ivan@farm.test',
      fullName: 'Иван',
      role: 'owner',
      isActive: true,
      digestEnabled: digestEnabled,
      createdAt: DateTime(2026, 1, 1),
      updatedAt: DateTime(2026, 1, 1),
    );

/// Профиль готов сразу, без сети — как в `farm_status_banner_test.dart`.
class _FakeAuthRepository extends AuthRepository {
  _FakeAuthRepository(this.user, {this.updateFailure})
      : super(apiClient: ApiClient(storage: const FlutterSecureStorage()), storage: const FlutterSecureStorage());

  UserModel user;
  final Object? updateFailure;

  /// Что ушло на сервер последним вызовом — по этому видно, какое именно
  /// поле отправилось.
  Map<String, dynamic>? lastUpdate;

  @override
  Future<bool> isLoggedIn() async => true;

  @override
  Future<bool> isImpersonating() async => false;

  @override
  Future<UserModel> getProfile() async => user;

  @override
  Future<UserModel> updateProfile(Map<String, dynamic> data) async {
    lastUpdate = data;
    if (updateFailure != null) throw updateFailure!;
    user = user.copyWith(digestEnabled: data['digest_enabled'] as bool);
    return user;
  }
}

Widget _wrap(_FakeAuthRepository repository) => testAppScreen(
      const SettingsScreen(),
      overrides: [
        authRepositoryProvider.overrideWithValue(repository),
      ],
    );

void main() {
  group('SettingsScreen — дайджест', () {
    testWidgets('переключатель отражает текущее значение и отправляет новое',
        (tester) async {
      final repository = _FakeAuthRepository(_user(digestEnabled: true));
      await tester.pumpWidget(_wrap(repository));
      await tester.pumpAndSettle();

      final switchFinder = find.byType(Switch);
      expect(tester.widget<Switch>(switchFinder).value, isTrue);

      await tester.tap(switchFinder);
      await tester.pumpAndSettle();

      expect(repository.lastUpdate, {'digest_enabled': false});
      expect(tester.widget<Switch>(switchFinder).value, isFalse);
    });

    testWidgets('отказ сервера возвращает переключатель назад', (tester) async {
      final repository = _FakeAuthRepository(
        _user(digestEnabled: true),
        updateFailure: Exception('Сервер недоступен'),
      );
      await tester.pumpWidget(_wrap(repository));
      await tester.pumpAndSettle();

      final switchFinder = find.byType(Switch);
      await tester.tap(switchFinder);
      await tester.pumpAndSettle();

      // Сначала переключатель включает выключение сразу (оптимистично), но
      // после отказа сервера возвращается к прежнему значению.
      expect(tester.widget<Switch>(switchFinder).value, isTrue);
      expect(find.text('Сервер недоступен'), findsOneWidget);
    });
  });
}
