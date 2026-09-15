import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:mobile/core/access/farm_access.dart';
import 'package:mobile/core/api/api_client.dart';
import 'package:mobile/core/api/api_failure.dart';
import 'package:mobile/features/staff/data/models/staff_models.dart';
import 'package:mobile/features/staff/data/repositories/staff_repository.dart';
import 'package:mobile/features/staff/presentation/providers/staff_provider.dart';
import 'package:mobile/features/staff/presentation/screens/staff_screen.dart';

import '../support/test_app.dart';

/// Приглашение всегда упирается в лимит тарифа — без обращения к сети.
class _LimitedStaffRepository extends StaffRepository {
  _LimitedStaffRepository()
      : super(ApiClient(storage: const FlutterSecureStorage()));

  @override
  Future<CreatedInvitation> createInvitation({
    String? email,
    String? phone,
    String? fullName,
    required FarmRole role,
  }) async {
    throw const ApiFailure(ApiFailureKind.invalid, code: 'STAFF_LIMIT_REACHED');
  }
}

const _inviteLink = 'https://rabbitfarm.mubi.dev/i';

/// Приглашение по телефону, которое сервер создал, но отправить не смог:
/// SMS-шлюз принимает только заранее одобренные шаблоны.
class _InvitingStaffRepository extends StaffRepository {
  _InvitingStaffRepository()
      : super(ApiClient(storage: const FlutterSecureStorage()));

  int resentId = 0;

  CreatedInvitation _invitation() => CreatedInvitation(
        id: 10,
        phone: '+992901234567',
        fullName: 'Новый Работник',
        role: FarmRole.worker,
        expiresAt: DateTime.now().add(const Duration(days: 7)),
        inviteLink: _inviteLink,
      );

  @override
  Future<CreatedInvitation> createInvitation({
    String? email,
    String? phone,
    String? fullName,
    required FarmRole role,
  }) async =>
      _invitation();

  @override
  Future<CreatedInvitation> resendInvitation(int id) async {
    resentId = id;
    return _invitation();
  }
}

FarmInvitation _invitation({
  required int id,
  required String email,
  required Duration expiresIn,
}) =>
    FarmInvitation(
      id: id,
      email: email,
      role: FarmRole.worker,
      // Срок задаётся от «сейчас», а не календарной датой: приглашение с
      // датой из прошлого превращает тест в бомбу замедленного действия —
      // он зеленеет до этого дня и краснеет после.
      expiresAt: DateTime.now().add(expiresIn),
    );

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
);

final _blockedManager = FarmMember(
  id: 3,
  email: 'manager@example.com',
  fullName: 'Анна Управляющая',
  role: FarmRole.manager,
  isActive: false,
);

Future<void> _settle(WidgetTester tester) async {
  await tester.binding.setSurfaceSize(const Size(420, 2000));
  addTearDown(() => tester.binding.setSurfaceSize(null));
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 400));
}

/// Роль задаётся явно: без неё вошедшего нет, и экран считал бы открывшего
/// работником — а тогда пропали бы все кнопки изменения состава.
Widget _wrap(
  List<Override> overrides, {
  FarmRoleAccess role = FarmRoleAccess.owner,
}) =>
    testAppScreen(const StaffScreen(),
        overrides: [farmRoleProvider.overrideWithValue(role), ...overrides]);

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
      farmMembersProvider
          .overrideWith((ref) async => [_owner, _blockedManager]),
      farmInvitationsProvider.overrideWith((ref) async => <FarmInvitation>[]),
    ]));
    await _settle(tester);

    expect(find.text('Управляющий · доступ закрыт'), findsOneWidget);
  });

  testWidgets('показывает неиспользованные приглашения', (tester) async {
    await tester.pumpWidget(_wrap([
      farmMembersProvider.overrideWith((ref) async => [_owner]),
      farmInvitationsProvider.overrideWith((ref) async => [
            _invitation(
              id: 10,
              email: 'invited@example.com',
              expiresIn: const Duration(days: 7),
            ),
          ]),
    ]));
    await _settle(tester);

    expect(find.text('ЖДУТ ОТВЕТА'), findsOneWidget);
    expect(find.text('invited@example.com'), findsOneWidget);
    expect(find.text('Отозвать'), findsOneWidget);
  });

  // Просроченное приглашение выглядело как живое: та же группа «Ждут
  // ответа», дата в прошлом мелким шрифтом и единственное действие
  // «Отозвать». Владелец думал, что человека ждут, а войти тот уже не мог.
  testWidgets(
      'просроченное приглашение отделено от живого и зовёт позвать заново',
      (tester) async {
    await tester.pumpWidget(_wrap([
      farmMembersProvider.overrideWith((ref) async => [_owner]),
      farmInvitationsProvider.overrideWith((ref) async => [
            _invitation(
              id: 10,
              email: 'live@example.com',
              expiresIn: const Duration(days: 7),
            ),
            _invitation(
              id: 11,
              email: 'stale@example.com',
              expiresIn: const Duration(days: -3),
            ),
          ]),
    ]));
    await _settle(tester);

    expect(find.text('ЖДУТ ОТВЕТА'), findsOneWidget);
    expect(find.text('СРОК ВЫШЕЛ'), findsOneWidget);
    expect(find.textContaining('срок истёк'), findsOneWidget);
    // Позвать заново можно оба: живое приглашение тоже приходится
    // отправлять повторно, если ссылку никому не переслали.
    expect(find.text('Пригласить заново'), findsNWidgets(2));
  });

  testWidgets('просроченное приглашение можно отправить заново',
      (tester) async {
    final repository = _InvitingStaffRepository();
    await tester.pumpWidget(_wrap([
      farmMembersProvider.overrideWith((ref) async => [_owner]),
      farmInvitationsProvider.overrideWith((ref) async => [
            _invitation(
              id: 11,
              email: 'stale@example.com',
              expiresIn: const Duration(days: -3),
            ),
          ]),
      staffRepositoryProvider.overrideWithValue(repository),
    ]));
    await _settle(tester);

    await tester.tap(find.text('Пригласить заново'));
    await tester.pumpAndSettle();

    expect(repository.resentId, 11);
    // Тот же разговор, что и после первого приглашения: вот ссылка, вот что
    // с ней делать.
    expect(find.text('Работник приглашён'), findsOneWidget);
    expect(find.text(_inviteLink), findsOneWidget);
  });

  testWidgets('на ошибке предлагает повторить', (tester) async {
    await tester.pumpWidget(_wrap([
      farmMembersProvider
          .overrideWith((ref) async => throw Exception('нет сети')),
      farmInvitationsProvider.overrideWith((ref) async => <FarmInvitation>[]),
    ]));
    await _settle(tester);

    expect(find.text('Не удалось загрузить'), findsOneWidget);
    expect(find.text('Повторить'), findsOneWidget);
  });

  testWidgets(
      'лимит участников по тарифу — закрывает форму приглашения и объясняет, что делать',
      (tester) async {
    await tester.pumpWidget(_wrap([
      farmMembersProvider.overrideWith((ref) async => [_owner]),
      farmInvitationsProvider.overrideWith((ref) async => <FarmInvitation>[]),
      staffRepositoryProvider.overrideWithValue(_LimitedStaffRepository()),
    ]));
    await _settle(tester);

    await tester.tap(find.text('Пригласить'));
    await tester.pumpAndSettle();

    // Приглашение по телефону — способ по умолчанию: номер и имя работника.
    await tester.enterText(find.byType(TextField).at(0), '+992901234567');
    await tester.enterText(find.byType(TextField).at(1), 'Новый Работник');
    await tester.tap(find.text('Пригласить работника'));
    await tester.pumpAndSettle();

    // Форма приглашения закрыта — номер сам по себе тут ни при чём, а
    // повторный ввод другого контакта лимит не снимет.
    expect(find.byType(TextField), findsNothing);
    expect(find.text('Лимит участников по тарифу'), findsOneWidget);
    expect(
      find.textContaining('Состав фермы достиг лимита участников'),
      findsOneWidget,
    );
  });

  // Сервер отдаёт управляющему состав фермы, но менять его разрешает только
  // владельцу: экран должен показывать людей и прятать всё, что их меняет.
  testWidgets('управляющий видит состав фермы без кнопок изменения',
      (tester) async {
    await tester.pumpWidget(_wrap(
      [
        farmMembersProvider.overrideWith((ref) async => [_owner, _worker]),
        farmInvitationsProvider.overrideWith((ref) async => [
              _invitation(
                id: 10,
                email: 'invited@example.com',
                expiresIn: const Duration(days: 7),
              ),
            ]),
      ],
      role: FarmRoleAccess.manager,
    ));
    await _settle(tester);

    expect(find.text('Пётр Владелец'), findsOneWidget);
    expect(find.text('Иван Работник'), findsOneWidget);
    expect(find.text('invited@example.com'), findsOneWidget);

    expect(find.text('Пригласить'), findsNothing);
    expect(find.text('Отозвать'), findsNothing);
    expect(find.byType(PopupMenuButton<String>), findsNothing);
  });

  testWidgets('владельцу кнопки изменения состава остаются', (tester) async {
    await tester.pumpWidget(_wrap([
      farmMembersProvider.overrideWith((ref) async => [_owner, _worker]),
      farmInvitationsProvider.overrideWith((ref) async => <FarmInvitation>[]),
    ]));
    await _settle(tester);

    expect(find.text('Пригласить'), findsOneWidget);
    expect(find.byType(PopupMenuButton<String>), findsOneWidget);
  });

  testWidgets('приглашение по телефону без имени не отправляется',
      (tester) async {
    await tester.pumpWidget(_wrap([
      farmMembersProvider.overrideWith((ref) async => [_owner]),
      farmInvitationsProvider.overrideWith((ref) async => <FarmInvitation>[]),
    ]));
    await _settle(tester);

    await tester.tap(find.text('Пригласить'));
    await tester.pumpAndSettle();

    // Телефон — способ по умолчанию: поля номера и имени, почты нет.
    expect(find.text('Имя работника'), findsOneWidget);
    expect(find.text('Почта'), findsNothing);

    await tester.enterText(find.byType(TextField).first, '901234567');
    await tester.tap(find.text('Пригласить работника'));
    await tester.pumpAndSettle();

    // Диалог остался открыт и объясняет, чего не хватает: имя работник
    // назвать больше нигде не может — он входит кодом, а не через форму.
    expect(find.text('Пригласить на ферму'), findsOneWidget);
    expect(find.text('Укажите имя работника'), findsOneWidget);
  });

  // Раньше диалог обещал, что работнику придёт SMS и передавать ничего не
  // нужно. SMS не уходит вовсе: шлюз принимает только заранее одобренные
  // шаблоны. Владелец должен увидеть ссылку и получить способ её переслать.
  testWidgets(
      'после приглашения по телефону владелец видит ссылку и может её переслать',
      (tester) async {
    String? copied;
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.platform,
      (call) async {
        if (call.method == 'Clipboard.setData') {
          copied = (call.arguments as Map)['text'] as String?;
        }
        return null;
      },
    );
    addTearDown(() => tester.binding.defaultBinaryMessenger
        .setMockMethodCallHandler(SystemChannels.platform, null));

    await tester.pumpWidget(_wrap([
      farmMembersProvider.overrideWith((ref) async => [_owner]),
      farmInvitationsProvider.overrideWith((ref) async => <FarmInvitation>[]),
      staffRepositoryProvider.overrideWithValue(_InvitingStaffRepository()),
    ]));
    await _settle(tester);

    await tester.tap(find.text('Пригласить'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).at(0), '+992901234567');
    await tester.enterText(find.byType(TextField).at(1), 'Новый Работник');
    await tester.tap(find.text('Пригласить работника'));
    await tester.pumpAndSettle();

    // Никаких «ничего передавать не нужно»: текст прямо говорит, что SMS не
    // уходит, и показывает ссылку целиком.
    expect(find.textContaining('SMS не уходит'), findsOneWidget);
    expect(find.text(_inviteLink), findsOneWidget);

    await tester.tap(find.text('Скопировать приглашение'));
    await tester.pumpAndSettle();

    // В буфер уходит готовое сообщение со ссылкой — его остаётся вставить в
    // мессенджер, которым работник пользуется.
    expect(copied, isNotNull);
    expect(copied, contains(_inviteLink));
    // Диалог закрыт, подтверждение видно поверх экрана, а не под затемнением.
    expect(find.text('Работник приглашён'), findsNothing);
    expect(find.textContaining('Приглашение скопировано'), findsOneWidget);
  });
}
