import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mobile/core/api/api_client.dart';
import 'package:mobile/core/api/paginated.dart';
import 'package:mobile/core/models/user_ref.dart';
import 'package:mobile/features/platform_admin/data/models/platform_admin_models.dart';
import 'package:mobile/features/platform_admin/data/repositories/platform_admin_repository.dart';
import 'package:mobile/features/platform_admin/presentation/providers/platform_admin_provider.dart';
import 'package:mobile/features/platform_admin/presentation/screens/platform_audit_tab.dart';
import 'package:mobile/features/platform_admin/presentation/screens/platform_farms_tab.dart';
import 'package:mobile/features/platform_admin/presentation/widgets/plan_delete_dialog.dart';
import 'package:mobile/features/platform_admin/presentation/widgets/platform_farm_card.dart';

import '../support/test_app.dart';

const _basic = Plan(id: 1, name: 'Базовый', maxRabbits: 200, maxStaff: 5);
const _wide = Plan(id: 2, name: 'Расширенный', maxRabbits: 1000, maxStaff: 20);

const _owner = UserRef(id: 10, fullName: 'Пётр Иванов');

PlatformFarm _farm({
  String name = 'Зелёная поляна',
  String status = 'active',
  DateTime? deletedAt,
  Plan? plan,
  int rabbits = 0,
  int? extraRabbits,
  DateTime? extrasUntil,
}) {
  return PlatformFarm(
    id: 1,
    name: name,
    owner: _owner,
    plan: plan,
    status: status,
    deletedAt: deletedAt,
    extraRabbits: extraRabbits,
    extrasUntil: extrasUntil,
    rabbitsCount: rabbits,
    staffCount: 1,
    createdAt: DateTime(2026, 9, 1),
  );
}

AdminAuditEntry _entry({
  int id = 1,
  required String action,
  int? farmId = 7,
  Map<String, dynamic>? before,
  Map<String, dynamic>? after,
  String? ip,

  /// Имена сервер отдаёт вместе с записью. По умолчанию их здесь нет —
  /// так проверяется запасной вариант: ферму могли снести, и запись о том,
  /// кто это сделал, обязана её пережить.
  UserRef? admin,
  SupportRequestFarm? farm,
}) {
  return AdminAuditEntry(
    id: id,
    adminId: 3,
    action: action,
    farmId: farmId,
    before: before,
    after: after,
    ip: ip,
    admin: admin,
    farm: farm,
    createdAt: DateTime(2026, 9, 12, 14, 30),
  );
}

/// Репозиторий с заранее известным ответом: провайдеры и notifier остаются
/// настоящими, в сеть не ходит только он сам.
class _FakeRepository extends PlatformAdminRepository {
  _FakeRepository({
    this.farms = const [],
    this.plans = const [],
    this.audit = const [],
  }) : super(ApiClient(storage: const FlutterSecureStorage()));

  final List<PlatformFarm> farms;
  final List<Plan> plans;
  final List<AdminAuditEntry> audit;

  /// Каждый запрос списка ферм — по нему видно, что срез дошёл до сервера.
  final farmQueries = <String?>[];

  @override
  Future<FarmsPage> getFarms({
    int page = 1,
    int limit = 20,
    String? search,
    String? filter,
    String? sort,
  }) async {
    farmQueries.add(filter);
    // Удалённые фермы сервер отдаёт только в своём срезе — подделка повторяет
    // именно это: иначе тест «фильтр находит удалённую» проходил бы и без
    // самого фильтра.
    final items = [
      for (final farm in farms)
        if (farm.isDeleted == (filter == 'deleted')) farm,
    ];
    return (
      items: items,
      page: PageInfo(page: 1, limit: limit, total: items.length, totalPages: 1),
    );
  }

  @override
  Future<List<Plan>> getPlans() async => plans;

  @override
  Future<AuditPage> getAuditLog(
      {int page = 1, int limit = 20, int? farmId}) async {
    return (
      items: audit,
      page: PageInfo(page: 1, limit: limit, total: audit.length, totalPages: 1),
    );
  }
}

Future<void> _settle(WidgetTester tester,
    {Size size = const Size(420, 2000)}) async {
  await tester.binding.setSurfaceSize(size);
  addTearDown(() => tester.binding.setSurfaceSize(null));
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 400));
}

Widget _auditTab(_FakeRepository repository) => testApp(
      const PlatformAuditTab(),
      overrides: [
        platformAdminRepositoryProvider.overrideWithValue(repository),
      ],
    );

Widget _farmsTab(_FakeRepository repository) => testApp(
      const PlatformFarmsTab(),
      overrides: [
        platformAdminRepositoryProvider.overrideWithValue(repository),
      ],
    );

void main() {
  group('Журнал действий', () {
    testWidgets('смена тарифа читается названиями, а не номерами',
        (tester) async {
      final repository = _FakeRepository(
        plans: const [_basic, _wide],
        audit: [
          _entry(
            action: 'plan.assign',
            before: {'plan_id': 1},
            after: {'plan_id': 2},
            ip: '10.0.0.5',
          ),
        ],
      );
      await tester.pumpWidget(_auditTab(repository));
      await _settle(tester);

      expect(find.text('Смена тарифа фермы'), findsOneWidget);
      expect(find.text('Тариф: Базовый → Расширенный'), findsOneWidget);
      // Имён в этой записи нет — тогда номер, но не пустое место.
      expect(find.text('Админ #3 · Ферма #7'), findsOneWidget);
      expect(find.text('IP 10.0.0.5'), findsOneWidget);
      expect(find.text('12.09.2026 14:30'), findsOneWidget);
    });

    testWidgets('называет админа и ферму по именам, когда сервер их привёз', (
      tester,
    ) async {
      // «Админ №3 · Ферма №7» — это данные, которые есть, и не доехали до
      // читателя: имена лежали в базе рядом, одним join.
      final repository = _FakeRepository(
        plans: const [_basic],
        audit: [
          _entry(
            action: 'farm.status',
            after: {'status': 'read_only'},
            admin: const UserRef(id: 3, fullName: 'Пётр Смирнов'),
            farm: const SupportRequestFarm(id: 7, name: 'Заря'),
          ),
        ],
      );
      await tester.pumpWidget(_auditTab(repository));
      await _settle(tester);

      expect(find.text('Пётр Смирнов · Заря'), findsOneWidget);
    });

    testWidgets('снятие тарифа названо словами, а не пустым местом',
        (tester) async {
      final repository = _FakeRepository(
        plans: const [_basic],
        audit: [
          _entry(
            action: 'plan.assign',
            before: {'plan_id': 1},
            after: {'plan_id': null},
          ),
        ],
      );
      await tester.pumpWidget(_auditTab(repository));
      await _settle(tester);

      expect(find.text('Тариф: Базовый → Без тарифа'), findsOneWidget);
    });

    testWidgets('вход под клиентом показывает объяснение админа',
        (tester) async {
      // Ради этой строки объяснение и спрашивают — до журнала её было не
      // прочитать нигде.
      final repository = _FakeRepository(
        audit: [
          _entry(
            action: 'farm.impersonate',
            after: {'reason': 'Клиент не видит окролы', 'owner_id': 10},
          ),
        ],
      );
      await tester.pumpWidget(_auditTab(repository));
      await _settle(tester);

      expect(find.text('Вход под клиентом'), findsOneWidget);
      expect(find.text('Зачем: Клиент не видит окролы'), findsOneWidget);
    });

    testWidgets('смена доступа фермы названа теми же словами, что в карточке',
        (tester) async {
      final repository = _FakeRepository(
        audit: [
          _entry(
            action: 'farm.status',
            before: {'status': 'active'},
            after: {'status': 'suspended'},
          ),
        ],
      );
      await tester.pumpWidget(_auditTab(repository));
      await _settle(tester);

      expect(
        find.text('Доступ: Работает как обычно → Доступ закрыт'),
        findsOneWidget,
      );
    });

    testWidgets('правка тарифа показывает только то, что изменилось',
        (tester) async {
      final repository = _FakeRepository(
        audit: [
          _entry(
            action: 'plan.update',
            farmId: null,
            before: {
              'name': 'Базовый',
              'max_rabbits': 200,
              'max_staff': 5,
              'price': '150.00',
              'is_active': true,
              'is_default': false,
            },
            after: {
              'name': 'Базовый',
              'max_rabbits': 300,
              'max_staff': 5,
              'price': '150',
              'is_active': true,
              'is_default': true,
            },
          ),
        ],
      );
      await tester.pumpWidget(_auditTab(repository));
      await _settle(tester);

      expect(find.text('Кроликов по тарифу: 200 → 300'), findsOneWidget);
      expect(find.text('Стал тарифом по умолчанию'), findsOneWidget);
      // Цена записана по-разному ("150.00" и "150"), но это одно и то же —
      // правкой это показывать нельзя.
      expect(find.textContaining('Цена'), findsNothing);
      // Действие не про ферму — и об этом сказано, а не оставлено пустым.
      expect(find.text('Админ #3 · Весь сервис'), findsOneWidget);
    });

    testWidgets('незнакомое действие показано кодом, а не пропущено',
        (tester) async {
      final repository = _FakeRepository(
        audit: [_entry(action: 'farm.teleport')],
      );
      await tester.pumpWidget(_auditTab(repository));
      await _settle(tester);

      expect(find.text('Действие «farm.teleport»'), findsOneWidget);
    });

    testWidgets('пустой журнал объясняет, что в нём появится', (tester) async {
      await tester.pumpWidget(_auditTab(_FakeRepository()));
      await _settle(tester);

      expect(find.text('Журнал пуст'), findsOneWidget);
    });
  });

  group('Удаление тарифа', () {
    Widget host(Plan plan) => testApp(
          Builder(
            builder: (context) => TextButton(
              onPressed: () => showPlanDeleteDialog(context, plan: plan),
              child: const Text('удалить'),
            ),
          ),
        );

    testWidgets('про тариф по умолчанию предупреждает отдельно',
        (tester) async {
      await tester.pumpWidget(
          host(const Plan(id: 1, name: 'Базовый', isDefault: true)));
      await _settle(tester);

      await tester.tap(find.text('удалить'));
      await _settle(tester);

      expect(find.textContaining('тариф по умолчанию'), findsOneWidget);
      expect(find.textContaining('Отменить нельзя'), findsOneWidget);
    });

    testWidgets('обычный тариф лишним предупреждением не пугает',
        (tester) async {
      await tester.pumpWidget(host(const Plan(id: 2, name: 'Расширенный')));
      await _settle(tester);

      await tester.tap(find.text('удалить'));
      await _settle(tester);

      expect(find.textContaining('тариф по умолчанию'), findsNothing);
      expect(find.textContaining('Отменить нельзя'), findsOneWidget);
    });
  });

  group('Фермы — состояние в списке', () {
    testWidgets('удалённая ферма находится срезом «Удалённые»', (tester) async {
      final repository = _FakeRepository(
        farms: [_farm(deletedAt: DateTime(2026, 9, 10))],
      );
      await tester.pumpWidget(_farmsTab(repository));
      // Чипы лежат в горизонтальном списке: «Удалённые» — последний, и на
      // телефонной ширине он не построен вовсе.
      await _settle(tester, size: const Size(1400, 2000));

      // Из обычного списка сервер удалённые убирает — до фильтра их не видно.
      expect(find.byType(PlatformFarmCard), findsNothing);

      await tester.tap(find.widgetWithText(FilterChip, 'Удалённые'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));

      expect(repository.farmQueries.last, 'deleted');
      expect(
        find.descendant(
          of: find.byType(PlatformFarmCard),
          matching: find.text('Удалена 10.09.2026'),
        ),
        findsOneWidget,
      );
      // Тариф удалённой ферме не меняют — кнопка, которая ничего не решает,
      // была бы тупиком.
      expect(find.text('Назначить тариф'), findsNothing);
    });

    testWidgets('приостановленную ферму видно в списке', (tester) async {
      final repository = _FakeRepository(
        farms: [_farm(status: 'suspended', plan: _basic, rabbits: 10)],
      );
      await tester.pumpWidget(_farmsTab(repository));
      await _settle(tester);

      expect(
        find.descendant(
          of: find.byType(PlatformFarmCard),
          matching: find.text('Доступ закрыт'),
        ),
        findsOneWidget,
      );
    });

    testWidgets('работающая ферма ярлыка о состоянии не получает',
        (tester) async {
      final repository = _FakeRepository(
        farms: [_farm(plan: _basic, rabbits: 10)],
      );
      await tester.pumpWidget(_farmsTab(repository));
      await _settle(tester);

      expect(
        find.descendant(
          of: find.byType(PlatformFarmCard),
          matching: find.text('Работает'),
        ),
        findsNothing,
      );
    });

    testWidgets('ферма с поблажкой не горит «упёрлась в предел»',
        (tester) async {
      // Предел по тарифу — 200, добавка админа +50: сервер такую ферму ещё
      // пропускает, и список не должен звать разбираться с тем, чего нет.
      final repository = _FakeRepository(
        farms: [
          _farm(
            plan: _basic,
            rabbits: 210,
            extraRabbits: 50,
            extrasUntil: DateTime(2030, 1, 1),
          ),
        ],
      );
      await tester.pumpWidget(_farmsTab(repository));
      await _settle(tester);

      expect(find.text('210 из 250'), findsOneWidget);
      expect(
        find.descendant(
          of: find.byType(PlatformFarmCard),
          matching: find.text('Упёрлась в предел тарифа'),
        ),
        findsNothing,
      );
    });
  });
}
