import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:mobile/features/staff/data/models/staff_models.dart';
import 'package:mobile/features/staff/presentation/providers/staff_provider.dart';
import 'package:mobile/features/staff/presentation/screens/staff_screen.dart';

const _owner = FarmMember(
  id: 1,
  email: 'owner@example.com',
  fullName: 'Пётр Владелец',
  role: FarmRole.owner,
);

const _worker = FarmMember(
  id: 2,
  email: 'worker@example.com',
  fullName: 'Иван Работник',
  role: FarmRole.worker,
  ownerId: 1,
);

final _blockedManager = FarmMember(
  id: 3,
  email: 'manager@example.com',
  fullName: 'Анна Управляющая',
  role: FarmRole.manager,
  isActive: false,
  ownerId: 1,
);

Future<void> _settle(WidgetTester tester) async {
  await tester.binding.setSurfaceSize(const Size(420, 2000));
  addTearDown(() => tester.binding.setSurfaceSize(null));
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 400));
}

Widget _wrap(List<Override> overrides) => ProviderScope(
      overrides: overrides,
      child: MaterialApp(
        theme: ThemeData(useMaterial3: true),
        home: const StaffScreen(),
      ),
    );

void main() {
  setUpAll(() => initializeDateFormatting('ru_RU', null));

  testWidgets('показывает владельца и сотрудников по отдельности',
      (tester) async {
    await tester.pumpWidget(_wrap([
      farmMembersProvider.overrideWith((ref) async => [_owner, _worker]),
      farmInvitationsProvider.overrideWith((ref) async => <FarmInvitation>[]),
    ]));
    await _settle(tester);

    expect(find.text('ВЛАДЕЛЕЦ'), findsOneWidget);
    expect(find.text('Пётр Владелец'), findsOneWidget);
    expect(find.text('СОТРУДНИКИ'), findsOneWidget);
    expect(find.text('Иван Работник'), findsOneWidget);
    expect(find.text('Работник'), findsOneWidget);
  });

  testWidgets('когда сотрудников нет, объясняет что делать', (tester) async {
    await tester.pumpWidget(_wrap([
      farmMembersProvider.overrideWith((ref) async => [_owner]),
      farmInvitationsProvider.overrideWith((ref) async => <FarmInvitation>[]),
    ]));
    await _settle(tester);

    expect(find.textContaining('На ферме пока только вы'), findsOneWidget);
    expect(find.text('Пригласить'), findsOneWidget);
  });

  testWidgets('закрытый доступ видно прямо в списке', (tester) async {
    await tester.pumpWidget(_wrap([
      farmMembersProvider.overrideWith((ref) async => [_owner, _blockedManager]),
      farmInvitationsProvider.overrideWith((ref) async => <FarmInvitation>[]),
    ]));
    await _settle(tester);

    expect(find.text('Управляющий · доступ закрыт'), findsOneWidget);
  });

  testWidgets('показывает неиспользованные приглашения', (tester) async {
    await tester.pumpWidget(_wrap([
      farmMembersProvider.overrideWith((ref) async => [_owner]),
      farmInvitationsProvider.overrideWith((ref) async => [
            FarmInvitation(
              id: 10,
              email: 'invited@example.com',
              role: FarmRole.worker,
              expiresAt: DateTime(2026, 9, 1),
            ),
          ]),
    ]));
    await _settle(tester);

    expect(find.text('ЖДУТ ОТВЕТА'), findsOneWidget);
    expect(find.text('invited@example.com'), findsOneWidget);
    expect(find.text('Отозвать'), findsOneWidget);
  });

  testWidgets('на ошибке предлагает повторить', (tester) async {
    await tester.pumpWidget(_wrap([
      farmMembersProvider.overrideWith((ref) async => throw Exception('нет сети')),
      farmInvitationsProvider.overrideWith((ref) async => <FarmInvitation>[]),
    ]));
    await _settle(tester);

    expect(find.text('Ошибка загрузки'), findsOneWidget);
    expect(find.text('Повторить'), findsOneWidget);
  });
}
