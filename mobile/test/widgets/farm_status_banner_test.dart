import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mobile/core/api/api_client.dart';
import 'package:mobile/core/models/farm_ref.dart';
import 'package:mobile/features/auth/data/models/user_model.dart';
import 'package:mobile/features/auth/data/repositories/auth_repository.dart';
import 'package:mobile/features/auth/presentation/providers/auth_provider.dart';
import 'package:mobile/features/auth/presentation/widgets/farm_status_banner.dart';

import '../support/test_app.dart';

UserModel _user({String? farmStatus}) => UserModel(
      id: 1,
      email: 'ivan@farm.test',
      fullName: 'Иван',
      role: 'owner',
      isActive: true,
      createdAt: DateTime(2026, 1, 1),
      updatedAt: DateTime(2026, 1, 1),
      farm: farmStatus == null ? null : FarmRef(id: 7, status: farmStatus),
    );

/// Профиль готов сразу, без сети — баннер реагирует на состояние
/// `authProvider`, а не на то, как оно туда попало.
class _FakeAuthRepository extends AuthRepository {
  _FakeAuthRepository(this.user)
      : super(apiClient: ApiClient(storage: const FlutterSecureStorage()), storage: const FlutterSecureStorage());

  final UserModel user;

  @override
  Future<bool> isLoggedIn() async => true;

  @override
  Future<bool> isImpersonating() async => false;

  @override
  Future<UserModel> getProfile() async => user;
}

Widget _wrap(UserModel user, {required Widget child}) => testApp(
      FarmStatusBanner(child: child),
      overrides: [
        authRepositoryProvider.overrideWithValue(_FakeAuthRepository(user)),
      ],
    );

void main() {
  group('FarmStatusBanner', () {
    testWidgets('ничего не показывает на активной ферме', (tester) async {
      await tester.pumpWidget(_wrap(
        _user(farmStatus: 'active'),
        child: const Text('контент'),
      ));
      await tester.pumpAndSettle();

      expect(find.text('контент'), findsOneWidget);
      expect(find.textContaining('только для чтения'), findsNothing);
    });

    testWidgets('read_only показывает баннер и кнопку «Тариф»', (tester) async {
      await tester.pumpWidget(_wrap(
        _user(farmStatus: 'read_only'),
        child: const Text('контент'),
      ));
      await tester.pumpAndSettle();

      expect(find.text('контент'), findsOneWidget);
      expect(
        find.text('Доступ только для чтения — продлите тариф, чтобы снова вносить записи'),
        findsOneWidget,
      );
      expect(find.widgetWithText(TextButton, 'Тариф'), findsOneWidget);
      expect(find.widgetWithText(TextButton, 'Поддержка'), findsNothing);
    });

    testWidgets('suspended показывает баннер без кнопки «Тариф»', (tester) async {
      await tester.pumpWidget(_wrap(
        _user(farmStatus: 'suspended'),
        child: const Text('контент'),
      ));
      await tester.pumpAndSettle();

      expect(find.text('Доступ закрыт — обратитесь в поддержку'), findsOneWidget);
      expect(find.widgetWithText(TextButton, 'Тариф'), findsNothing);
      expect(find.widgetWithText(TextButton, 'Поддержка'), findsOneWidget);
    });

    testWidgets('без фермы вовсе ничего не показывает', (tester) async {
      await tester.pumpWidget(_wrap(
        _user(),
        child: const Text('контент'),
      ));
      await tester.pumpAndSettle();

      expect(find.text('контент'), findsOneWidget);
    });
  });
}
