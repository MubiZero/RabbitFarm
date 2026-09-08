import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mobile/core/api/api_client.dart';
import 'package:mobile/core/api/api_failure.dart';
import 'package:mobile/core/api/paginated.dart';
import 'package:mobile/core/models/user_ref.dart';
import 'package:mobile/features/platform_admin/data/models/platform_admin_models.dart';
import 'package:mobile/features/platform_admin/data/repositories/platform_admin_repository.dart';
import 'package:mobile/features/platform_admin/presentation/providers/platform_admin_provider.dart';
import 'package:mobile/features/platform_admin/presentation/screens/farm_detail_screen.dart';

import '../support/test_app.dart';

const _plan = Plan(
  id: 2,
  name: 'Базовый',
  maxRabbits: 30,
  maxStaff: 3,
  price: 50,
);

/// Ферма-фикстура той же формы, что отдаёт `GET /platform-admin/farms/:id`.
///
/// Даты собраны как местные `DateTime`, а не разобраны из строк: экран
/// печатает их в местном поясе, и на машине с другим часовым поясом разбор
/// UTC-строки сдвинул бы день.
PlatformFarmDetail _farm({
  String status = 'active',
  int? extraRabbits,
  int? extraStaff,
  DateTime? extrasUntil,
  DateTime? planExpiresAt,
  List<FarmPayment> payments = const [],
  List<FarmStaffMember>? staff,
  int storageBytes = 15728640,
  DateTime? deletedAt,
}) {
  return PlatformFarmDetail(
    id: 1,
    name: 'Ферма Иванова',
    owner: const UserRef(
      id: 5,
      fullName: 'Иван Иванов',
      email: 'ivan@example.com',
      phone: '+992900000000',
    ),
    planId: 2,
    plan: _plan,
    planExpiresAt: planExpiresAt ?? DateTime(2026, 10, 1),
    status: status,
    extraRabbits: extraRabbits,
    extraStaff: extraStaff,
    extrasUntil: extrasUntil,
    rabbitsCount: 26,
    staffCount: 2,
    createdAt: DateTime(2026, 8, 1),
    lastActiveAt: DateTime(2026, 9, 7, 18, 30),
    staff: staff ??
        [
          FarmStaffMember(
            id: 5,
            fullName: 'Иван Иванов',
            email: 'ivan@example.com',
            phone: '+992900000000',
            role: 'owner',
            lastLoginAt: DateTime(2026, 9, 7, 18, 30),
          ),
          const FarmStaffMember(
            id: 9,
            fullName: 'Пётр Петров',
            phone: '+992900000001',
            role: 'worker',
            isActive: false,
          ),
        ],
    payments: payments,
    storageBytes: storageBytes,
    deletedAt: deletedAt,
  );
}

/// Репозиторий с заранее известной фермой. Настоящий полез бы в сеть, а
/// провайдер карточки при этом остаётся настоящим.
class _FakeRepository extends PlatformAdminRepository {
  _FakeRepository({PlatformFarmDetail? farm, this.error, this.deleteError})
      : farm = farm ?? _farm(),
        super(ApiClient(storage: const FlutterSecureStorage()));

  PlatformFarmDetail farm;
  final Object? error;

  /// Чем сервер отвечает на удаление. Нужен, чтобы проверить отказ
  /// «название не совпадает» — тот приезжает как обычная ошибка запроса.
  final Object? deleteError;

  /// Что ушло в запросы — по этому видно, дошло ли решение админа до сервера.
  final statusCalls = <String>[];
  final extrasCalls = <({int? rabbits, int? staff, DateTime? until})>[];
  final deleteCalls = <String>[];
  int restoreCalls = 0;

  /// Строка списка ферм — с нарочно устаревшим поголовьем: по нему видно,
  /// подтянулась ли она после правки в карточке.
  @override
  Future<FarmsPage> getFarms({
    int page = 1,
    int limit = 20,
    String? search,
    String? filter,
    String? sort,
  }) async {
    return (
      items: [
        PlatformFarm(
          id: 1,
          name: 'Ферма Иванова',
          plan: _plan,
          rabbitsCount: 1,
          staffCount: 1,
          createdAt: DateTime(2026, 8, 1),
        ),
      ],
      page: PageInfo(page: 1, limit: limit, total: 1, totalPages: 1),
    );
  }

  @override
  Future<PlatformFarmDetail> getFarmDetail(int farmId) async {
    if (error != null) throw error!;
    return farm;
  }

  @override
  Future<PlatformFarmDetail> updateFarmStatus(int farmId, String status) async {
    statusCalls.add(status);
    farm = farm.copyWith(status: status);
    return farm;
  }

  @override
  Future<PlatformFarmDetail> updateFarmExtras(
    int farmId, {
    int? extraRabbits,
    int? extraStaff,
    DateTime? extrasUntil,
  }) async {
    extrasCalls
        .add((rabbits: extraRabbits, staff: extraStaff, until: extrasUntil));
    farm = farm.copyWith(
      extraRabbits: extraRabbits,
      extraStaff: extraStaff,
      extrasUntil: extrasUntil,
    );
    return farm;
  }

  @override
  Future<PlatformFarmDetail> deleteFarm(int farmId, String confirmName) async {
    deleteCalls.add(confirmName);
    if (deleteError != null) throw deleteError!;
    farm = farm.copyWith(deletedAt: DateTime(2026, 9, 9));
    return farm;
  }

  @override
  Future<PlatformFarmDetail> restoreFarm(int farmId) async {
    restoreCalls++;
    farm = farm.copyWith(deletedAt: null);
    return farm;
  }
}

/// Экран длинный — на телефонной высоте нижние блоки не построены вовсе.
/// Разделу удаления нужна высота побольше, остальным хватает прежней.
Future<void> _settle(WidgetTester tester, {double height = 3000}) async {
  await tester.binding.setSurfaceSize(Size(420, height));
  addTearDown(() => tester.binding.setSurfaceSize(null));
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 400));
}

Widget _screen(_FakeRepository repository) => testAppScreen(
      const FarmDetailScreen(farmId: 1),
      overrides: [
        platformAdminRepositoryProvider.overrideWithValue(repository),
      ],
    );

/// Карточка, открытая поверх другого экрана — так на неё и заходят из списка
/// ферм. Нужна там, где проверяется уход с карточки: на корневом маршруте
/// закрывать нечего, и проверка была бы пустой.
Widget _pushedScreen(_FakeRepository repository) => testAppScreen(
      Scaffold(
        body: Builder(
          builder: (context) => TextButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const FarmDetailScreen(farmId: 1),
              ),
            ),
            child: const Text('открыть карточку'),
          ),
        ),
      ),
      overrides: [
        platformAdminRepositoryProvider.overrideWithValue(repository),
      ],
    );

void main() {
  group('Карточка фермы', () {
    testWidgets('собирает все разделы из одной загрузки', (tester) async {
      final repository = _FakeRepository(
        farm: _farm(payments: [
          FarmPayment(
            id: 3,
            amount: '50.00',
            currency: '972',
            status: 'completed',
            description: 'Тариф Базовый',
            createdAt: DateTime(2026, 8, 1),
          ),
        ]),
      );
      await tester.pumpWidget(_screen(repository));
      await _settle(tester);

      // Владелец и связь.
      expect(find.text('Ферма Иванова'), findsOneWidget);
      expect(find.text('ivan@example.com'), findsWidgets);
      expect(find.text('+992900000000'), findsWidgets);

      // Доступ.
      expect(find.text('Работает как обычно'), findsOneWidget);

      // Тариф и срок.
      expect(find.text('Базовый'), findsOneWidget);
      expect(find.text('до 30 кроликов · до 3 человек'), findsOneWidget);
      expect(find.text('Действует до 01.10.2026'), findsOneWidget);

      // Потребление — против предела тарифа, поблажки нет.
      expect(find.text('26 из 30'), findsOneWidget);
      expect(find.text('2 из 3'), findsOneWidget);

      // Состав: роль читаемым словом, последний вход и закрытый доступ.
      expect(find.text('Пётр Петров'), findsOneWidget);
      expect(find.textContaining('Владелец фермы'), findsOneWidget);
      expect(find.textContaining('Работник'), findsOneWidget);
      expect(find.text('Заходил 07.09.2026 18:30'), findsOneWidget);
      expect(find.text('Ещё не заходил'), findsOneWidget);
      expect(find.text('Вход закрыт'), findsOneWidget);

      // Платежи. «50 с» на экране дважды: цена тарифа и сумма платежа за него.
      expect(find.text('50 с'), findsNWidgets(2));
      expect(find.textContaining('Тариф Базовый'), findsOneWidget);
      expect(find.text('Оплачен'), findsOneWidget);

      // Место и последняя активность.
      expect(find.text('15 МБ'), findsOneWidget);
      expect(find.text('07.09.2026 18:30'), findsOneWidget);
    });

    testWidgets('пустые платежи и отсутствие поблажки названы словами',
        (tester) async {
      await tester.pumpWidget(_screen(_FakeRepository()));
      await _settle(tester);

      expect(find.text('Платежей ещё не было'), findsOneWidget);
      expect(
        find.text('Поблажек нет — действуют пределы тарифа'),
        findsOneWidget,
      );
      expect(find.text('Выдать поблажку'), findsOneWidget);
    });

    testWidgets('на ошибке загрузки предлагает повторить', (tester) async {
      await tester.pumpWidget(
        _screen(_FakeRepository(error: Exception('нет сети'))),
      );
      await _settle(tester);

      expect(find.text('Повторить'), findsOneWidget);
      // Заголовок не остаётся пустым, пока фермы нет.
      expect(find.text('Ферма'), findsOneWidget);
    });
  });

  group('Доступ фермы', () {
    testWidgets('только чтение и закрытый доступ подписаны и объяснены',
        (tester) async {
      await tester.pumpWidget(
        _screen(_FakeRepository(farm: _farm(status: 'read_only'))),
      );
      await _settle(tester);

      expect(find.text('Только чтение'), findsOneWidget);
      expect(
        find.textContaining('Данные видны, записать ничего нельзя'),
        findsOneWidget,
      );

      await tester.pumpWidget(
        _screen(_FakeRepository(farm: _farm(status: 'suspended'))),
      );
      await _settle(tester);

      expect(find.text('Доступ закрыт'), findsOneWidget);
      expect(
        find.textContaining('не пускает никого'),
        findsOneWidget,
      );
    });

    testWidgets('выбор и подтверждение доходят до сервера', (tester) async {
      final repository = _FakeRepository();
      await tester.pumpWidget(_screen(repository));
      await _settle(tester);

      await tester.tap(find.text('Изменить доступ'));
      await _settle(tester);

      // Все три уровня видны сразу — вместе с тем, что каждый означает.
      expect(find.widgetWithText(ListTile, 'Работает как обычно'), findsOneWidget);
      expect(find.widgetWithText(ListTile, 'Только чтение'), findsOneWidget);
      expect(find.widgetWithText(ListTile, 'Доступ закрыт'), findsOneWidget);

      await tester.tap(find.widgetWithText(ListTile, 'Только чтение'));
      await _settle(tester);

      // Между выбором и запросом — подтверждение: ферма увидит это сразу.
      expect(find.text('Изменить доступ?'), findsOneWidget);
      expect(repository.statusCalls, isEmpty);

      await tester.tap(find.text('Применить'));
      await _settle(tester);

      expect(repository.statusCalls, ['read_only']);
      expect(find.text('Доступ обновлён'), findsOneWidget);
      // Карточка обновилась из ответа, без второй загрузки.
      expect(find.text('Только чтение'), findsWidgets);
    });

    testWidgets('отказ от подтверждения ничего не отправляет', (tester) async {
      final repository = _FakeRepository();
      await tester.pumpWidget(_screen(repository));
      await _settle(tester);

      await tester.tap(find.text('Изменить доступ'));
      await _settle(tester);
      await tester.tap(find.widgetWithText(ListTile, 'Доступ закрыт'));
      await _settle(tester);
      await tester.tap(find.text('Отмена'));
      await _settle(tester);

      expect(repository.statusCalls, isEmpty);
      expect(find.text('Работает как обычно'), findsOneWidget);
    });

    testWidgets('прежнее состояние выбрано повторно — запроса нет',
        (tester) async {
      final repository = _FakeRepository();
      await tester.pumpWidget(_screen(repository));
      await _settle(tester);

      await tester.tap(find.text('Изменить доступ'));
      await _settle(tester);
      await tester.tap(find.widgetWithText(ListTile, 'Работает как обычно'));
      await _settle(tester);

      expect(find.text('Изменить доступ?'), findsNothing);
      expect(repository.statusCalls, isEmpty);
    });
  });

  group('Поблажка сверх тарифа', () {
    testWidgets('выданная поблажка уходит на сервер и расширяет предел',
        (tester) async {
      final repository = _FakeRepository();
      await tester.pumpWidget(_screen(repository));
      await _settle(tester);

      await tester.tap(find.text('Выдать поблажку'));
      await _settle(tester);

      await tester.enterText(
        find.widgetWithText(TextField, 'Кроликов сверх тарифа'),
        '50',
      );
      await tester.tap(find.text('Сохранить'));
      await _settle(tester);

      expect(repository.extrasCalls,
          [(rabbits: 50, staff: null, until: null)]);
      expect(find.text('Поблажка обновлена'), findsOneWidget);
      // Предел на полосе — с добавкой, а сам тариф остался прежним.
      expect(find.text('26 из 80'), findsOneWidget);
      expect(find.text('+50 кроликов бессрочно'), findsOneWidget);
      expect(find.text('до 30 кроликов · до 3 человек'), findsOneWidget);
    });

    testWidgets('пустая форма не отправляется и объясняет, чего не хватает',
        (tester) async {
      final repository = _FakeRepository();
      await tester.pumpWidget(_screen(repository));
      await _settle(tester);

      await tester.tap(find.text('Выдать поблажку'));
      await _settle(tester);
      await tester.tap(find.text('Сохранить'));
      await _settle(tester);

      expect(
        find.text('Укажите кроликов или людей — или снимите поблажку'),
        findsOneWidget,
      );
      expect(repository.extrasCalls, isEmpty);
    });

    testWidgets('действующая поблажка показана со сроком и снимается',
        (tester) async {
      final repository = _FakeRepository(
        farm: _farm(extraRabbits: 50, extrasUntil: DateTime(2026, 10, 15)),
      );
      await tester.pumpWidget(_screen(repository));
      await _settle(tester);

      expect(find.text('+50 кроликов до 15.10.2026'), findsOneWidget);

      await tester.tap(find.text('Изменить'));
      await _settle(tester);
      await tester.tap(find.text('Снять поблажку'));
      await _settle(tester);

      expect(repository.extrasCalls,
          [(rabbits: null, staff: null, until: null)]);
      expect(find.text('Поблажка снята'), findsOneWidget);
      expect(
        find.text('Поблажек нет — действуют пределы тарифа'),
        findsOneWidget,
      );
    });

    testWidgets('истёкшая поблажка не считается и названа истёкшей',
        (tester) async {
      final expired = DateTime.now().subtract(const Duration(days: 2));
      await tester.pumpWidget(_screen(_FakeRepository(
        farm: _farm(extraRabbits: 50, extrasUntil: expired),
      )));
      await _settle(tester);

      expect(find.textContaining('Поблажка истекла'), findsOneWidget);
      // Предел снова тарифный, а не расширенный.
      expect(find.text('26 из 30'), findsOneWidget);
    });
  });

  group('Выгрузка данных', () {
    testWidgets('карточка предлагает выгрузку и объясняет, зачем она',
        (tester) async {
      await tester.pumpWidget(_screen(_FakeRepository()));
      await _settle(tester, height: 4600);

      expect(find.text('Экспортировать данные'), findsOneWidget);
      expect(find.textContaining('отдайте мои данные'), findsOneWidget);
    });
  });

  group('Удаление и восстановление фермы', () {
    /// Высота под весь экран: раздел удаления идёт последним.
    Future<void> openDangerZone(WidgetTester tester) => _settle(tester, height: 4600);

    /// Кнопка «Удалить» в диалоге — та, что оживает от набранного названия.
    TextButton confirmButton(WidgetTester tester) =>
        tester.widget<TextButton>(find.widgetWithText(TextButton, 'Удалить'));

    testWidgets('кнопка подтверждения оживает только на точном названии',
        (tester) async {
      final repository = _FakeRepository();
      await tester.pumpWidget(_screen(repository));
      await openDangerZone(tester);

      await tester.tap(find.text('Удалить ферму'));
      await openDangerZone(tester);

      // Пустое поле — кнопка мертва.
      expect(confirmButton(tester).onPressed, isNull);

      // Похожее, но не то же самое, тоже не подходит: в этом и смысл второго
      // подтверждения.
      await tester.enterText(find.byType(TextField), 'Ферма Иванов');
      await openDangerZone(tester);
      expect(confirmButton(tester).onPressed, isNull);

      await tester.enterText(find.byType(TextField), 'Ферма Иванова');
      await openDangerZone(tester);
      expect(confirmButton(tester).onPressed, isNotNull);
      // До нажатия ничего не отправлено.
      expect(repository.deleteCalls, isEmpty);
    });

    testWidgets('подтверждённое удаление уходит на сервер и закрывает карточку',
        (tester) async {
      final repository = _FakeRepository();
      await tester.pumpWidget(_pushedScreen(repository));
      await openDangerZone(tester);
      await tester.tap(find.text('открыть карточку'));
      await openDangerZone(tester);

      await tester.tap(find.text('Удалить ферму'));
      await openDangerZone(tester);

      await tester.enterText(find.byType(TextField), 'Ферма Иванова');
      await openDangerZone(tester);
      await tester.tap(find.widgetWithText(TextButton, 'Удалить'));
      // Три шага друг за другом — закрытие диалога, запрос, уход с карточки, —
      // и каждый со своей анимацией: одного кадра на всё не хватает.
      await openDangerZone(tester);
      await openDangerZone(tester);
      await openDangerZone(tester);

      expect(repository.deleteCalls, ['Ферма Иванова']);
      expect(find.text('Ферма удалена'), findsOneWidget);
      // Диалог закрылся сам — второй раз подтверждать нечего.
      expect(find.byType(AlertDialog), findsNothing);
      // И сама карточка закрылась: делать на карточке удалённой фермы нечего,
      // админ пришёл из списка — туда и возвращается.
      expect(find.byType(FarmDetailScreen), findsNothing);
    });

    testWidgets('несовпадение по версии сервера показано под полем ввода',
        (tester) async {
      // Так бывает, когда ферму переименовали, пока карточка была открыта:
      // клиент считает название верным, сервер — нет.
      final repository = _FakeRepository(
        deleteError: const ApiFailure(
          ApiFailureKind.invalid,
          code: 'CONFIRM_NAME_MISMATCH',
        ),
      );
      await tester.pumpWidget(_screen(repository));
      await openDangerZone(tester);

      await tester.tap(find.text('Удалить ферму'));
      await openDangerZone(tester);
      await tester.enterText(find.byType(TextField), 'Ферма Иванова');
      await openDangerZone(tester);
      await tester.tap(find.widgetWithText(TextButton, 'Удалить'));
      await openDangerZone(tester);

      expect(repository.deleteCalls, ['Ферма Иванова']);
      // Ошибка ввода живёт под полем, а не в снекбаре, и форма остаётся
      // открытой — иначе набирать название пришлось бы заново.
      expect(find.byType(AlertDialog), findsOneWidget);
      expect(
        find.text('Название не совпадает с названием фермы'),
        findsOneWidget,
      );
    });

    testWidgets('удалённая ферма предупреждает и восстанавливается без диалога',
        (tester) async {
      final repository = _FakeRepository(
        farm: _farm(deletedAt: DateTime(2026, 9, 8)),
      );
      await tester.pumpWidget(_screen(repository));
      await openDangerZone(tester);

      expect(
        find.textContaining('Ферма удалена 08.09.2026'),
        findsOneWidget,
      );
      // Удалять второй раз нечего.
      expect(find.text('Удалить ферму'), findsNothing);

      // Пока ферма на пути к удалению, её доступ и поблажки не правят.
      expect(
        tester
            .widget<TextButton>(find.widgetWithText(TextButton, 'Изменить доступ'))
            .onPressed,
        isNull,
      );
      expect(
        tester
            .widget<TextButton>(find.widgetWithText(TextButton, 'Выдать поблажку'))
            .onPressed,
        isNull,
      );

      await tester.tap(find.text('Восстановить'));
      await openDangerZone(tester);

      expect(repository.restoreCalls, 1);
      expect(find.text('Ферма восстановлена'), findsOneWidget);
      // Карточка обновилась из ответа: удаление снова доступно.
      expect(find.text('Удалить ферму'), findsOneWidget);
    });
  });

  group('Список ферм после правки в карточке', () {
    test('живой список подтягивает то, что вернула карточка', () async {
      final container = ProviderContainer(overrides: [
        platformAdminRepositoryProvider.overrideWithValue(_FakeRepository()),
      ]);
      addTearDown(container.dispose);

      // Подписка держит список живым — как открытая вкладка «Фермы», с
      // которой в карточку и заходят.
      container.listen(platformFarmsProvider, (_, __) {}, fireImmediately: true);
      while (container.read(platformFarmsProvider).farms.isEmpty) {
        await Future<void>.delayed(Duration.zero);
      }
      expect(container.read(platformFarmsProvider).farms.single.rabbitsCount, 1);

      container.listen(platformFarmDetailProvider(1), (_, __) {}, fireImmediately: true);
      while (container.read(platformFarmDetailProvider(1)).isLoading) {
        await Future<void>.delayed(Duration.zero);
      }
      final error = await container
          .read(platformFarmDetailProvider(1).notifier)
          .updateStatus('read_only');

      expect(error, isNull);
      // Строка списка обновилась целиком из ответа, без перезагрузки страницы.
      expect(container.read(platformFarmsProvider).farms.single.rabbitsCount, 26);
      expect(container.read(platformFarmsProvider).farms.single.staffCount, 2);
    });

    test('мёртвый список не поднимается ради правки', () async {
      final repository = _FakeRepository();
      final container = ProviderContainer(overrides: [
        platformAdminRepositoryProvider.overrideWithValue(repository),
      ]);
      addTearDown(container.dispose);

      container.listen(platformFarmDetailProvider(1), (_, __) {}, fireImmediately: true);
      while (container.read(platformFarmDetailProvider(1)).isLoading) {
        await Future<void>.delayed(Duration.zero);
      }
      final error = await container
          .read(platformFarmDetailProvider(1).notifier)
          .updateExtras(extraRabbits: 10);

      expect(error, isNull);
      // Список никто не смотрит — запрашивать его страницу незачем.
      expect(container.exists(platformFarmsProvider), isFalse);
    });
  });
}
