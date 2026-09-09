import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mobile/core/api/api_client.dart';
import 'package:mobile/core/api/paginated.dart';
import 'package:mobile/core/models/user_ref.dart';
import 'package:mobile/core/theme/theme.dart';
import 'package:mobile/features/platform_admin/data/models/platform_admin_models.dart';
import 'package:mobile/features/platform_admin/data/repositories/platform_admin_repository.dart';
import 'package:mobile/features/platform_admin/presentation/providers/platform_admin_provider.dart';
import 'package:mobile/features/platform_admin/presentation/screens/platform_farms_tab.dart';
import 'package:mobile/features/platform_admin/presentation/screens/platform_plans_tab.dart';
import 'package:mobile/features/platform_admin/presentation/screens/platform_summary_tab.dart';
import 'package:mobile/features/platform_admin/presentation/widgets/platform_farm_card.dart';
import 'package:mobile/features/platform_admin/presentation/widgets/platform_farms_table.dart';

import '../support/test_app.dart';

const _basic = Plan(
  id: 1,
  name: 'Базовый',
  maxRabbits: 200,
  maxStaff: 5,
  price: 150,
);

const _retired = Plan(
  id: 2,
  name: 'Старый',
  maxRabbits: 50,
  isActive: false,
);

const _owner = UserRef(
  id: 10,
  fullName: 'Пётр Иванов',
  email: 'petr@example.com',
);

PlatformFarm _farm({
  Plan? plan,
  int rabbits = 0,
  int staff = 1,
  UserRef? owner = _owner,
}) {
  return PlatformFarm(
    id: 1,
    name: 'Зелёная поляна',
    owner: owner,
    plan: plan,
    rabbitsCount: rabbits,
    staffCount: staff,
    createdAt: DateTime(2026, 9, 1),
  );
}

/// Репозиторий с заранее известным ответом. Настоящий полез бы в сеть, но
/// нужен как основа: провайдеры и notifier списка ферм остаются настоящими.
class _FakeRepository extends PlatformAdminRepository {
  _FakeRepository({
    this.farms = const [],
    this.plans = const [],
    this.error,
  }) : super(ApiClient(storage: const FlutterSecureStorage()));

  final List<PlatformFarm> farms;
  final List<Plan> plans;
  final Object? error;

  /// Что ушло в `assignPlan` — по этому видно, дошёл ли выбор до сервера.
  final assigned = <({int farmId, int? planId})>[];

  /// Каждый вызов `getFarms` — по нему видно, что поиск и фильтр реально
  /// дошли до репозитория, а не осели где-то в виджете.
  final queries = <({int page, int limit, String? search, String? filter})>[];

  @override
  Future<FarmsPage> getFarms({
    int page = 1,
    int limit = 20,
    String? search,
    String? filter,
    String? sort,
  }) async {
    queries.add((page: page, limit: limit, search: search, filter: filter));
    if (error != null) throw error!;
    return (
      items: farms,
      page: PageInfo(
        page: 1,
        limit: limit,
        total: farms.length,
        totalPages: 1,
      ),
    );
  }

  @override
  Future<List<Plan>> getPlans() async => plans;

  @override
  Future<PlatformFarm> assignPlan(int farmId, int? planId) async {
    assigned.add((farmId: farmId, planId: planId));
    return farms
        .firstWhere((farm) => farm.id == farmId)
        .copyWith(plan: plans.where((plan) => plan.id == planId).firstOrNull);
  }
}

Future<void> _settle(WidgetTester tester) async {
  await tester.binding.setSurfaceSize(const Size(420, 2000));
  addTearDown(() => tester.binding.setSurfaceSize(null));
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 400));
}

/// То же самое, но на ширине рабочего стола — там список ферм переключается
/// на табличный вид ([AppBreakpoints.wideScreen]).
///
/// `tester.binding.setSurfaceSize` (как в [_settle]) здесь не годится: он не
/// доезжает до `MediaQuery.sizeOf`, которым и решает `context.isWideScreen`
/// (проверено — с ним ширина в тесте остаётся дефолтной 800 независимо от
/// переданного размера). Нужен `tester.view`, который на неё реально влияет;
/// заодно фиксируется `devicePixelRatio: 1`, чтобы переданная ширина не
/// делилась на дефолтные тестовые 3.
Future<void> _settleWide(WidgetTester tester, {double width = 1280}) async {
  tester.view.physicalSize = Size(width, 900);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 400));
}

Widget _farmsTab({
  List<PlatformFarm> farms = const [],
  Object? error,
  _FakeRepository? repository,
}) =>
    testApp(
      const PlatformFarmsTab(),
      overrides: [
        platformAdminRepositoryProvider.overrideWithValue(
          repository ?? _FakeRepository(farms: farms, error: error),
        ),
      ],
    );

Widget _plansTab(List<Plan> plans) => testApp(
      const PlatformPlansTab(),
      overrides: [
        platformPlansProvider.overrideWith((ref) async => plans),
      ],
    );

Widget _summaryTab({PlatformSummary? summary, Object? error}) => testApp(
      const PlatformSummaryTab(),
      overrides: [
        platformSummaryProvider.overrideWith((ref) async {
          if (error != null) throw error;
          return summary ?? const PlatformSummary();
        }),
      ],
    );

void main() {
  group('Фермы', () {
    testWidgets('потребление показано против предела тарифа', (tester) async {
      await tester.pumpWidget(_farmsTab(
        farms: [_farm(plan: _basic, rabbits: 48, staff: 2)],
      ));
      await _settle(tester);

      expect(find.text('Зелёная поляна'), findsOneWidget);
      expect(find.textContaining('Пётр Иванов'), findsOneWidget);
      expect(find.text('Базовый'), findsOneWidget);
      expect(find.text('48 из 200'), findsOneWidget);
      expect(find.text('2 из 5'), findsOneWidget);
      expect(find.text('1 ФЕРМА'), findsOneWidget);
    });

    testWidgets('ферма без тарифа помечена и показана без предела',
        (tester) async {
      await tester.pumpWidget(_farmsTab(farms: [_farm(rabbits: 12)]));
      await _settle(tester);

      // «Без тарифа» встречается дважды на экране: ярлыком на карточке и
      // подписью фильтрующего чипа над списком — про карточку тут и вопрос.
      expect(
        find.descendant(
          of: find.byType(PlatformFarmCard),
          matching: find.text('Без тарифа'),
        ),
        findsOneWidget,
      );
      expect(find.text('12, без предела'), findsOneWidget);
      expect(find.text('Назначить тариф'), findsOneWidget);
    });

    testWidgets('упёршаяся в предел ферма предупреждает об этом',
        (tester) async {
      await tester.pumpWidget(_farmsTab(
        farms: [_farm(plan: _basic, rabbits: 200, staff: 2)],
      ));
      await _settle(tester);

      expect(
        find.descendant(
          of: find.byType(PlatformFarmCard),
          matching: find.text('Упёрлась в предел тарифа'),
        ),
        findsOneWidget,
      );
    });

    testWidgets('подошедшая к пределу ферма предупреждает мягче',
        (tester) async {
      await tester.pumpWidget(_farmsTab(
        farms: [_farm(plan: _basic, rabbits: 180, staff: 2)],
      ));
      await _settle(tester);

      expect(find.text('Подходит к пределу тарифа'), findsOneWidget);
      expect(
        find.descendant(
          of: find.byType(PlatformFarmCard),
          matching: find.text('Упёрлась в предел тарифа'),
        ),
        findsNothing,
      );
    });

    testWidgets('владелец без записи не оставляет строку пустой',
        (tester) async {
      await tester.pumpWidget(_farmsTab(farms: [_farm(owner: null)]));
      await _settle(tester);

      expect(find.text('Владелец не назначен'), findsOneWidget);
    });

    testWidgets('тап по карточке открывает карточку фермы', (tester) async {
      // Проверяется вызов, а не переход: сам маршрут
      // (`/platform-admin/farms/:id`) живёт в роутере приложения, а карточка
      // в списке обязана его дёрнуть — раньше строка списка была тупиком.
      var opened = 0;
      await tester.pumpWidget(testApp(PlatformFarmCard(
        farm: _farm(plan: _basic, rabbits: 48, staff: 2),
        onChangePlan: () {},
        onOpen: () => opened++,
      )));
      await _settle(tester);

      await tester.tap(find.text('Зелёная поляна'));
      await _settle(tester);

      expect(opened, 1);
    });

    testWidgets('пустой список объясняет, что здесь появится', (tester) async {
      await tester.pumpWidget(_farmsTab());
      await _settle(tester);

      expect(find.text('Ферм пока нет'), findsOneWidget);
    });

    testWidgets('выбранный тариф доходит до сервера и меняет карточку',
        (tester) async {
      final repository = _FakeRepository(
        farms: [_farm(rabbits: 48, staff: 2)],
        plans: [_basic],
      );
      await tester.pumpWidget(_farmsTab(repository: repository));
      await _settle(tester);

      await tester.tap(find.text('Назначить тариф'));
      await _settle(tester);

      // В листе выбора есть и «без тарифа», и сам тариф со своими пределами.
      expect(find.text('Без тарифа — работает без ограничений'), findsOneWidget);
      await tester.tap(find.text('Базовый'));
      await _settle(tester);

      expect(repository.assigned, [(farmId: 1, planId: 1)]);
      expect(find.text('Тариф обновлён'), findsOneWidget);
      // Пределы нового тарифа сразу видны на карточке — без перезагрузки.
      expect(find.text('48 из 200'), findsOneWidget);
      expect(find.text('Сменить тариф'), findsOneWidget);
    });

    testWidgets('закрытый без выбора лист ничего не отправляет',
        (tester) async {
      final repository = _FakeRepository(
        farms: [_farm(rabbits: 1)],
        plans: [_basic],
      );
      await tester.pumpWidget(_farmsTab(repository: repository));
      await _settle(tester);

      await tester.tap(find.text('Назначить тариф'));
      await _settle(tester);
      expect(find.text('Без тарифа — работает без ограничений'), findsOneWidget);

      // Тап по затемнению вне листа — обычный способ его закрыть.
      await tester.tapAt(const Offset(210, 20));
      await _settle(tester);

      expect(find.text('Без тарифа — работает без ограничений'), findsNothing);
      expect(repository.assigned, isEmpty);
    });

    testWidgets('на ошибке без данных предлагает повторить', (tester) async {
      await tester.pumpWidget(_farmsTab(error: Exception('нет сети')));
      await _settle(tester);

      expect(find.text('Повторить'), findsOneWidget);
    });

    testWidgets('поиск уходит на сервер, а не фильтрует загруженную страницу',
        (tester) async {
      final repository = _FakeRepository(farms: [_farm(rabbits: 1)]);
      await tester.pumpWidget(_farmsTab(repository: repository));
      await _settle(tester);

      await tester.enterText(find.byType(TextField), 'Иванов');
      await tester.testTextInput.receiveAction(TextInputAction.search);
      await _settle(tester);

      expect(repository.queries.last.search, 'Иванов');
    });

    testWidgets('фильтр «Без тарифа» уходит на сервер и снимается повторным тапом',
        (tester) async {
      final repository = _FakeRepository(farms: [_farm(rabbits: 1)]);
      await tester.pumpWidget(_farmsTab(repository: repository));
      await _settle(tester);

      final chip = find.widgetWithText(FilterChip, 'Без тарифа');
      await tester.tap(chip);
      await _settle(tester);
      expect(repository.queries.last.filter, 'no_plan');

      await tester.tap(chip);
      await _settle(tester);
      expect(repository.queries.last.filter, isNull);
    });

    testWidgets('все срезы списка видны как чипы', (tester) async {
      await tester.pumpWidget(_farmsTab(farms: [_farm(rabbits: 1)]));
      // Чипы лежат в горизонтальном списке: на обычной ширине телефона
      // дальние чипы не построены вовсе, потому что закадрированы — здесь
      // ширина шире, чтобы все они реально попали во вьюпорт.
      await tester.binding.setSurfaceSize(const Size(1400, 2000));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));

      expect(find.widgetWithText(FilterChip, 'Упёрлась в предел тарифа'), findsOneWidget);
      // Подпись та же, что у состояния фермы в её карточке — одно состояние
      // не должно называться в списке иначе.
      expect(find.widgetWithText(FilterChip, 'Доступ закрыт'), findsOneWidget);
      expect(find.widgetWithText(FilterChip, 'Просрочен тариф'), findsOneWidget);
      expect(find.widgetWithText(FilterChip, 'Не заходили 30 дней'), findsOneWidget);
    });

    testWidgets('срезы «доступ закрыт» и «просрочен тариф» уходят на сервер',
        (tester) async {
      final repository = _FakeRepository(farms: [_farm(rabbits: 1)]);
      await tester.pumpWidget(_farmsTab(repository: repository));
      // Ширина остаётся большой на весь тест: `_settle` вернул бы телефонную,
      // и дальние чипы перестали бы строиться посреди проверки.
      await tester.binding.setSurfaceSize(const Size(1400, 2000));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      Future<void> pump() async {
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 400));
      }

      await pump();

      await tester.tap(find.widgetWithText(FilterChip, 'Доступ закрыт'));
      await pump();
      expect(repository.queries.last.filter, 'suspended');

      // Фильтр один: выбор другого чипа заменяет прежний, а не складывается
      // с ним.
      await tester.tap(find.widgetWithText(FilterChip, 'Просрочен тариф'));
      await pump();
      expect(repository.queries.last.filter, 'expired');

      await tester.tap(find.widgetWithText(FilterChip, 'Просрочен тариф'));
      await pump();
      expect(repository.queries.last.filter, isNull);
    });
  });

  group('Фермы — широкий экран', () {
    final ownerB = const UserRef(id: 11, fullName: 'Мария Петрова', email: 'maria@example.com');

    testWidgets('список ферм выглядит таблицей, а не карточками', (tester) async {
      await tester.pumpWidget(_farmsTab(farms: [
        _farm(plan: _basic, rabbits: 5),
        PlatformFarm(
          id: 2,
          name: 'Дальний хутор',
          owner: ownerB,
          rabbitsCount: 0,
          staffCount: 1,
          createdAt: DateTime(2026, 8, 1),
        ),
      ]));
      await _settleWide(tester);

      expect(find.byType(PlatformFarmsTable), findsOneWidget);
      expect(find.byType(PlatformFarmCard), findsNothing);
      // Заголовки колонок.
      expect(find.text('Ферма'), findsOneWidget);
      expect(find.text('Владелец'), findsOneWidget);
      expect(find.text('Тариф'), findsOneWidget);
      expect(find.text('Кролики'), findsOneWidget);
      expect(find.text('Люди'), findsOneWidget);
      // Обе фермы в строках.
      expect(find.text('Зелёная поляна'), findsOneWidget);
      expect(find.text('Дальний хутор'), findsOneWidget);
      expect(find.text('Мария Петрова'), findsOneWidget);
      // «Без тарифа» есть и в чипе фильтра над таблицей, и в строке фермы —
      // ищем именно в таблице.
      expect(
        find.descendant(
          of: find.byType(PlatformFarmsTable),
          matching: find.text('Без тарифа'),
        ),
        findsOneWidget,
      );
    });

    testWidgets('на узком экране остаются карточки, на ровно граничной ширине — уже таблица', (tester) async {
      await tester.pumpWidget(_farmsTab(farms: [_farm(plan: _basic)]));

      await _settleWide(tester, width: AppBreakpoints.wideScreen - 1);
      expect(find.byType(PlatformFarmCard), findsOneWidget);
      expect(find.byType(PlatformFarmsTable), findsNothing);

      await _settleWide(tester, width: AppBreakpoints.wideScreen);
      expect(find.byType(PlatformFarmsTable), findsOneWidget);
      expect(find.byType(PlatformFarmCard), findsNothing);
    });

    testWidgets('тап по строке открывает карточку фермы', (tester) async {
      // Проверяется вызов, а не переход — тот же приём, что и у карточки в
      // узкой раскладке (см. группу «Фермы» выше).
      var opened = 0;
      await tester.pumpWidget(testApp(PlatformFarmsTable(
        farms: [_farm(plan: _basic, rabbits: 48, staff: 2)],
        onChangePlan: (_) {},
        onOpen: (_) => opened++,
      )));
      await _settleWide(tester);

      await tester.tap(find.text('Зелёная поляна'));
      await _settleWide(tester);

      expect(opened, 1);
    });

    testWidgets('выбранный в таблице тариф доходит до сервера', (tester) async {
      final repository = _FakeRepository(
        farms: [_farm()],
        plans: [_basic],
      );
      await tester.pumpWidget(_farmsTab(repository: repository));
      await _settleWide(tester);

      Future<void> pump() async {
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 400));
      }

      await tester.tap(find.byIcon(Icons.sell_outlined));
      await pump();

      // В листе выбора есть и «без тарифа», и сам тариф со своими пределами
      // — та же проверка, что и у карточки в узкой раскладке.
      expect(find.text('Без тарифа — работает без ограничений'), findsOneWidget);
      await tester.tap(find.text('Базовый'));
      await pump();

      expect(repository.assigned, [(farmId: 1, planId: 1)]);
    });
  });

  group('Тарифы', () {
    testWidgets('карточка показывает пределы и цену', (tester) async {
      await tester.pumpWidget(_plansTab([_basic]));
      await _settle(tester);

      expect(find.text('Базовый'), findsOneWidget);
      expect(find.text('до 200 кроликов · до 5 человек'), findsOneWidget);
      expect(find.text('150 с'), findsOneWidget);
    });

    testWidgets('тариф без цены назван бесплатным, а не оставлен пустым',
        (tester) async {
      await tester.pumpWidget(_plansTab([
        const Plan(id: 3, name: 'Проба', maxRabbits: 10),
      ]));
      await _settle(tester);

      expect(find.text('Бесплатный'), findsOneWidget);
      expect(find.text('до 10 кроликов'), findsOneWidget);
    });

    testWidgets('тариф без пределов так и подписан', (tester) async {
      await tester.pumpWidget(_plansTab([const Plan(id: 4, name: 'Без границ')]));
      await _settle(tester);

      expect(find.text('Без ограничений'), findsOneWidget);
    });

    testWidgets('выключенный тариф помечен', (tester) async {
      await tester.pumpWidget(_plansTab([_retired]));
      await _settle(tester);

      expect(find.text('выключен'), findsOneWidget);
    });

    testWidgets('пустой список предлагает создать первый тариф',
        (tester) async {
      await tester.pumpWidget(_plansTab(const []));
      await _settle(tester);

      expect(find.text('Тарифов пока нет'), findsOneWidget);
      expect(find.text('Новый тариф'), findsOneWidget);
    });
  });

  group('Сводка', () {
    testWidgets('показывает фермы по тарифу', (tester) async {
      await tester.pumpWidget(_summaryTab(
        summary: const PlatformSummary(
          farms: PlatformFarmsSummary(
            total: 12,
            free: 7,
            paid: 3,
            noPlan: 2,
          ),
        ),
      ));
      await _settle(tester);

      expect(find.text('Всего ферм'), findsOneWidget);
      expect(find.text('12'), findsOneWidget);
      expect(find.text('7'), findsOneWidget);
      expect(find.text('3'), findsOneWidget);
      expect(find.text('2'), findsOneWidget);
    });

    testWidgets('показывает просроченные, приостановленные и упёршиеся в предел',
        (tester) async {
      await tester.pumpWidget(_summaryTab(
        summary: const PlatformSummary(
          farms: PlatformFarmsSummary(expired: 4, suspended: 1, atLimit: 5),
        ),
      ));
      await _settle(tester);

      // Смысл и цвет — те же, что у срезов списка ферм
      // (farm_filter_labels.dart), а подписи свои: под числом-счётчиком
      // нужно существительное, а не фраза про одну конкретную ферму.
      expect(find.text('Просрочка тарифа'), findsOneWidget);
      expect(find.text('Доступ закрыт'), findsOneWidget);
      expect(find.text('У предела тарифа'), findsOneWidget);
      expect(find.text('4'), findsOneWidget);
      expect(find.text('1'), findsOneWidget);
      expect(find.text('5'), findsOneWidget);
    });

    testWidgets('показывает регистрации, неактивность, поголовье и место',
        (tester) async {
      await tester.pumpWidget(_summaryTab(
        summary: const PlatformSummary(
          registrations30d: 9,
          inactive30d: 6,
          rabbitsTotal: 340,
          storageBytes: 15728640, // 15 МБ
        ),
      ));
      await _settle(tester);

      expect(find.text('Регистраций за 30 дней'), findsOneWidget);
      expect(find.text('9'), findsOneWidget);
      expect(find.text('Не заходили 30 дней'), findsOneWidget);
      expect(find.text('6'), findsOneWidget);
      expect(find.text('Поголовье всего'), findsOneWidget);
      expect(find.text('340'), findsOneWidget);
      expect(find.text('15 МБ'), findsOneWidget);
    });

    testWidgets('на ошибке без данных предлагает повторить', (tester) async {
      await tester.pumpWidget(_summaryTab(error: Exception('нет сети')));
      await _settle(tester);

      expect(find.text('Повторить'), findsOneWidget);
    });
  });
}
