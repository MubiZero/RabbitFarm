import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mobile/core/api/api_client.dart';
import 'package:mobile/core/api/paginated.dart';
import 'package:mobile/core/models/user_ref.dart';
import 'package:mobile/features/platform_admin/data/models/platform_admin_models.dart';
import 'package:mobile/features/platform_admin/data/repositories/platform_admin_repository.dart';
import 'package:mobile/features/platform_admin/presentation/providers/platform_admin_provider.dart';
import 'package:mobile/features/platform_admin/presentation/screens/platform_farms_tab.dart';
import 'package:mobile/features/platform_admin/presentation/screens/platform_plans_tab.dart';

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

  @override
  Future<FarmsPage> getFarms({int page = 1, int limit = 20}) async {
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

      expect(find.text('Без тарифа'), findsOneWidget);
      expect(find.text('12, без предела'), findsOneWidget);
      expect(find.text('Назначить тариф'), findsOneWidget);
    });

    testWidgets('упёршаяся в предел ферма предупреждает об этом',
        (tester) async {
      await tester.pumpWidget(_farmsTab(
        farms: [_farm(plan: _basic, rabbits: 200, staff: 2)],
      ));
      await _settle(tester);

      expect(find.text('Упёрлась в предел тарифа'), findsOneWidget);
    });

    testWidgets('подошедшая к пределу ферма предупреждает мягче',
        (tester) async {
      await tester.pumpWidget(_farmsTab(
        farms: [_farm(plan: _basic, rabbits: 180, staff: 2)],
      ));
      await _settle(tester);

      expect(find.text('Подходит к пределу тарифа'), findsOneWidget);
      expect(find.text('Упёрлась в предел тарифа'), findsNothing);
    });

    testWidgets('владелец без записи не оставляет строку пустой',
        (tester) async {
      await tester.pumpWidget(_farmsTab(farms: [_farm(owner: null)]));
      await _settle(tester);

      expect(find.text('Владелец не назначен'), findsOneWidget);
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
}
