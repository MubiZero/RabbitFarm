import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:mobile/core/api/api_failure.dart';
import 'package:mobile/core/models/farm_ref.dart';
import 'package:mobile/features/auth/data/models/user_model.dart';
import 'package:mobile/features/auth/presentation/providers/auth_provider.dart';
import 'package:mobile/features/settings/presentation/screens/delete_account_screen.dart';

import '../support/test_app.dart';

/// Удаление своей учётной записи — обязательный путь по правилам обоих
/// магазинов приложений. Проверяется не «кнопка есть», а то, что человек
/// читает про свой случай: владельцу уходит хозяйство целиком, работнику —
/// только его вход, и данные хозяйства остаются на месте.
class _AuthStub extends AuthNotifier {
  _AuthStub(super.repository, super.ref, {required String role, String? farmName}) {
    state = state.copyWith(
      isAuthenticated: true,
      isLoading: false,
      user: UserModel(
        id: 1,
        email: 'someone@example.com',
        fullName: 'Человек',
        role: role,
        isActive: true,
        farm: farmName == null
            ? null
            : FarmRef(id: 1, name: farmName, status: 'active'),
        createdAt: DateTime(2026, 1, 1),
        updatedAt: DateTime(2026, 1, 1),
      ),
    );
  }

  String? requestedConfirmName;
  int calls = 0;
  Object? failWith;

  @override
  Future<void> deleteAccount({String? confirmName}) async {
    calls++;
    requestedConfirmName = confirmName;
    if (failWith != null) throw failWith!;
  }
}

Future<_AuthStub> _open(
  WidgetTester tester, {
  required String role,
  String? farmName,
  Object? failWith,
}) async {
  late _AuthStub stub;

  await tester.binding.setSurfaceSize(const Size(420, 1400));
  addTearDown(() => tester.binding.setSurfaceSize(null));

  await tester.pumpWidget(testAppScreen(
    const DeleteAccountScreen(),
    overrides: [
      authProvider.overrideWith((ref) {
        stub = _AuthStub(
          ref.watch(authRepositoryProvider),
          ref,
          role: role,
          farmName: farmName,
        );
        stub.failWith = failWith;
        return stub;
      }),
    ],
  ));
  await tester.pumpAndSettle();
  return stub;
}

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  testWidgets('владельцу сказано, что уходит хозяйство целиком',
      (tester) async {
    await _open(tester, role: 'owner', farmName: 'Зелёная поляна');

    expect(find.text('Это удалит хозяйство целиком'), findsOneWidget);
    // Тридцать дней — то, ради чего экран и читают целиком.
    expect(find.textContaining('Тридцать дней'), findsOneWidget);
    expect(
      find.text('Наберите название хозяйства «Зелёная поляна», чтобы подтвердить'),
      findsOneWidget,
    );
  });

  testWidgets('пока название не набрано, кнопка не нажимается', (tester) async {
    final stub = await _open(tester, role: 'owner', farmName: 'Зелёная поляна');

    await tester.tap(find.text('Удалить хозяйство'));
    await tester.pumpAndSettle();

    // Ни диалога, ни запроса: пустое поле — это ещё не решение.
    expect(find.text('Удалить хозяйство?'), findsNothing);
    expect(stub.calls, 0);
  });

  testWidgets('набранное название уходит на сервер как есть', (tester) async {
    final stub = await _open(tester, role: 'owner', farmName: 'Зелёная поляна');

    await tester.enterText(find.byType(TextField), 'Зелёная поляна');
    await tester.pumpAndSettle();
    await tester.tap(find.text('Удалить хозяйство'));
    await tester.pumpAndSettle();

    // Последний вопрос — словами, а не «вы уверены?».
    expect(find.text('Удалить хозяйство?'), findsOneWidget);
    await tester.tap(find.text('Удалить'));
    // Не `pumpAndSettle`: после удачного удаления экран остаётся занятым,
    // пока роутер уводит на вход, — крутилка не даёт кадрам успокоиться.
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(stub.calls, 1);
    // Совпадение проверяет сервер: экран не решает за него.
    expect(stub.requestedConfirmName, 'Зелёная поляна');
  });

  testWidgets('работнику сказано, что данные хозяйства остаются',
      (tester) async {
    await _open(tester, role: 'worker');

    expect(find.text('Это удалит вашу учётную запись'), findsOneWidget);
    expect(find.textContaining('остаются хозяйству'), findsOneWidget);
    // Названия набирать нечего: его учётка не уносит с собой чужие данные.
    expect(find.byType(TextField), findsNothing);
  });

  testWidgets('работник удаляет себя без подтверждения названием',
      (tester) async {
    final stub = await _open(tester, role: 'worker');

    await tester.tap(find.text('Удалить учётную запись'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Удалить'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(stub.calls, 1);
    expect(stub.requestedConfirmName, isNull);
  });

  testWidgets('отказ сервера виден человеку, а экран остаётся', (tester) async {
    await _open(
      tester,
      role: 'owner',
      farmName: 'Зелёная поляна',
      failWith: const ApiFailure(
        ApiFailureKind.invalid,
        code: 'CONFIRM_NAME_MISMATCH',
        serverText: 'Название хозяйства набрано неточно',
      ),
    );

    await tester.enterText(find.byType(TextField), 'зелёная поляна');
    await tester.pumpAndSettle();
    await tester.tap(find.text('Удалить хозяйство'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Удалить'));
    await tester.pumpAndSettle();

    expect(find.text('Название хозяйства набрано неточно'), findsOneWidget);
    expect(find.text('Удалить хозяйство'), findsOneWidget);
  });
}
