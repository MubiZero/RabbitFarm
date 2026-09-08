import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/rabbits/data/models/breed_model.dart';
import 'package:mobile/features/rabbits/data/models/rabbit_model.dart';
import 'package:mobile/features/rabbits/data/models/rabbit_statistics.dart';
import 'package:mobile/features/platform_admin/data/models/platform_admin_models.dart';
import 'package:mobile/features/reports/data/models/report_model.dart';

void main() {
  group('Model parsing with IntConverter', () {
    test('BreedModel parses string ids', () {
      final json = {
        'id': '5',
        'name': 'Калифорнийская',
        'average_weight': 4.5,
        'average_litter_size': '8',
      };

      final model = BreedModel.fromJson(json);
      expect(model.id, 5);
      expect(model.averageLitterSize, 8);
    });

    test('RabbitModel parses string int fields', () {
      final json = {
        'id': '1',
        'tag_id': 'R-001',
        'name': 'Бусинка',
        'breed_id': '2',
        'sex': 'male',
        'birth_date': DateTime(2024, 1, 10).toIso8601String(),
        'status': 'alive',
        'purpose': 'meat',
        'created_at': DateTime(2024, 2, 1).toIso8601String(),
        'updated_at': DateTime(2024, 2, 1).toIso8601String(),
        'cage_id': '10',
        'father_id': '3',
        'mother_id': null,
        'current_weight': 2.2,
      };

      final model = RabbitModel.fromJson(json);
      expect(model.id, 1);
      expect(model.breedId, 2);
      expect(model.cageId, 10);
      expect(model.fatherId, 3);
      expect(model.motherId, isNull);
    });

    test('RabbitStatistics parses string counts', () {
      final json = {
        'total': '12',
        'alive_count': '10',
        'male_count': '6',
        'female_count': '4',
        'pregnant_count': '1',
        'sick_count': '0',
        'for_sale_count': '2',
        'dead_count': '0',
        'by_breed': [
          {
            'breed_id': '2',
            'breed_name': 'Калифорнийская',
            'count': '7',
          }
        ],
      };

      final stats = RabbitStatistics.fromJson(json);
      expect(stats.total, 12);
      expect(stats.aliveCount, 10);
      expect(stats.byBreed.first.breedId, 2);
      expect(stats.byBreed.first.count, 7);
    });

    test('Plan разбирает лимиты-строки и цену из DECIMAL', () {
      final plan = Plan.fromJson({
        'id': '3',
        'name': 'Базовый',
        'max_rabbits': '200',
        'max_staff': '5',
        'price': '150.00',
        'is_active': true,
      });

      expect(plan.id, 3);
      expect(plan.maxRabbits, 200);
      expect(plan.maxStaff, 5);
      expect(plan.price, 150);
      expect(plan.isUnlimited, isFalse);
    });

    test('Пустой лимит тарифа — это «без ограничения», а не ноль', () {
      final plan = Plan.fromJson({
        'id': 4,
        'name': 'Без границ',
        'max_rabbits': null,
        'max_staff': null,
        'price': null,
      });

      expect(plan.maxRabbits, isNull);
      expect(plan.maxStaff, isNull);
      expect(plan.isUnlimited, isTrue);
      // Поля нет в ответе — тариф считается рабочим, а не выключенным.
      expect(plan.isActive, isTrue);
    });

    test('DashboardReport.planUsage разбирает потребление против тарифа', () {
      final usage = PlanUsage.fromJson({
        'rabbits': {'used': '26', 'limit': '30'},
        'staff': {'used': '2', 'limit': null},
      });

      expect(usage.rabbits.used, 26);
      expect(usage.rabbits.limit, 30);
      // `limit: null` — без ограничения, а не ноль участников.
      expect(usage.staff.used, 2);
      expect(usage.staff.limit, isNull);
    });

    test('DashboardReport без plan_usage у фермы без тарифа', () {
      final json = {
        'rabbits': {'total': 5, 'male': 2, 'female': 3},
        'cages': {'total': 3, 'occupied': 2, 'available': 1},
        'health': {'upcomingVaccinations': 0, 'overdueVaccinations': 0},
        'tasks': {'pending': 0, 'overdue': 0, 'urgent': 0},
        'inventory': {'lowStockFeeds': 0},
        'breeding': {'recentBirths': 0},
      };

      final report = DashboardReport.fromJson(json);

      expect(report.planUsage, isNull);
    });

    test('PlatformFarm разбирает потребление, владельца и тариф', () {
      final farm = PlatformFarm.fromJson({
        'id': '7',
        'name': 'Зелёная поляна',
        'created_at': DateTime(2026, 9, 1).toIso8601String(),
        'rabbits_count': '48',
        'staff_count': '2',
        'owner': {'id': '10', 'full_name': 'Пётр Иванов', 'phone': '+992...'},
        'plan': {'id': '1', 'name': 'Базовый', 'max_rabbits': 200, 'max_staff': 5},
        'last_active': '2026-08-15T00:00:00.000Z',
      });

      expect(farm.id, 7);
      expect(farm.rabbitsCount, 48);
      expect(farm.staffCount, 2);
      expect(farm.owner?.fullName, 'Пётр Иванов');
      expect(farm.owner?.phone, '+992...');
      expect(farm.rabbitsUsage, closeTo(0.24, 0.001));
      expect(farm.isAtLimit, isFalse);
      expect(farm.lastActiveAt, isNotNull);
    });

    test('Ферма без тарифа и без счётчиков не выдумывает пределы', () {
      final farm = PlatformFarm.fromJson({
        'id': 8,
        'name': 'Новая',
        'created_at': DateTime(2026, 9, 1).toIso8601String(),
      });

      expect(farm.rabbitsCount, 0);
      expect(farm.staffCount, 0);
      expect(farm.rabbitsUsage, isNull);
      expect(farm.staffUsage, isNull);
      expect(farm.isAtLimit, isFalse);
      expect(farm.isNearLimit, isFalse);
      // Ни разу не заходили — это `null`, а не выдуманная дата.
      expect(farm.lastActiveAt, isNull);
    });

    test('Ферма на пределе видна и как «упёрлась», и не как «подходит»', () {
      PlatformFarm at(int rabbits) => PlatformFarm.fromJson({
            'id': 9,
            'name': 'Полная',
            'created_at': DateTime(2026, 9, 1).toIso8601String(),
            'rabbits_count': rabbits,
            'staff_count': 1,
            'plan': {'id': 1, 'name': 'Базовый', 'max_rabbits': 10},
          });

      expect(at(10).isAtLimit, isTrue);
      expect(at(10).isNearLimit, isFalse);
      expect(at(11).isAtLimit, isTrue);
      expect(at(8).isNearLimit, isTrue);
      expect(at(7).isNearLimit, isFalse);
    });
  });

  group('Карточка одной фермы', () {
    // Ровно та форма, которую отдаёт `GET /platform-admin/farms/:id`:
    // DECIMAL приходит строкой, часть полей — пустыми.
    Map<String, dynamic> farmJson({
      Object? extraRabbits,
      Object? extraStaff,
      Object? extrasUntil,
      String status = 'active',
      Object? deletedAt,
    }) =>
        {
          'id': 1,
          'name': 'Ферма Иванова',
          'owner': {
            'id': 5,
            'full_name': 'Иван Иванов',
            'email': 'ivan@example.com',
            'phone': '+992900000000',
          },
          'plan_id': 2,
          'plan': {
            'id': 2,
            'name': 'Базовый',
            'max_rabbits': 30,
            'max_staff': 3,
            'price': 50.0,
            'is_active': true,
            'is_default': false,
          },
          'plan_expires_at': '2026-10-01T00:00:00.000Z',
          'status': status,
          'extra_rabbits': extraRabbits,
          'extra_staff': extraStaff,
          'extras_until': extrasUntil,
          'created_at': '2026-08-01T10:00:00.000Z',
          'rabbits_count': 26,
          'staff_count': 2,
          'last_active': '2026-09-07T18:30:00.000Z',
          'staff': [
            {
              'id': 5,
              'full_name': 'Иван Иванов',
              'email': 'ivan@example.com',
              'phone': '+992900000000',
              'role': 'owner',
              'is_active': true,
              'last_login_at': '2026-09-07T18:30:00.000Z',
            },
            {
              'id': 9,
              'full_name': 'Пётр Петров',
              'email': null,
              'phone': '+992900000001',
              'role': 'worker',
              'is_active': true,
              'last_login_at': null,
            },
          ],
          'payments': [
            {
              'id': 3,
              'amount': '50.00',
              'currency': '972',
              'status': 'completed',
              'description': 'Тариф Базовый',
              'created_at': '2026-08-01T10:05:00.000Z',
            },
          ],
          'storage_bytes': 15728640,
          'deleted_at': deletedAt,
        };

    test('разбирает состав, платежи и место', () {
      final farm = PlatformFarmDetail.fromJson(farmJson());

      expect(farm.id, 1);
      expect(farm.planId, 2);
      expect(farm.plan?.maxRabbits, 30);
      expect(farm.planExpiresAt, isNotNull);
      expect(farm.isActive, isTrue);
      expect(farm.staff, hasLength(2));
      expect(farm.staff.first.role, 'owner');
      // Ни разу не заходил — это `null`, а не выдуманная дата.
      expect(farm.staff.last.lastLoginAt, isNull);
      expect(farm.staff.last.email, isNull);
      // Сумма остаётся строкой ровно такой, какой пришла из DECIMAL.
      expect(farm.payments.single.amount, '50.00');
      expect(farm.storageBytes, 15728640);
    });

    test('без поблажки предел равен пределу тарифа', () {
      final farm = PlatformFarmDetail.fromJson(farmJson());

      expect(farm.hasActiveExtras, isFalse);
      expect(farm.hasExpiredExtras, isFalse);
      expect(farm.effectiveRabbitsLimit, 30);
      expect(farm.effectiveStaffLimit, 3);
      expect(farm.isAtLimit, isFalse);
    });

    test('действующая поблажка складывается с тарифом, но не меняет его', () {
      final farm = PlatformFarmDetail.fromJson(farmJson(
        extraRabbits: 50,
        extrasUntil: DateTime.now()
            .add(const Duration(days: 30))
            .toUtc()
            .toIso8601String(),
      ));

      expect(farm.hasActiveExtras, isTrue);
      expect(farm.effectiveRabbitsLimit, 80);
      // Сам тариф остался прежним — поблажка живёт рядом, а не внутри него.
      expect(farm.plan?.maxRabbits, 30);
      // Добавки по людям не выдавали — там по-прежнему предел тарифа.
      expect(farm.effectiveStaffLimit, 3);
    });

    test('поблажка без срока считается бессрочной', () {
      final farm =
          PlatformFarmDetail.fromJson(farmJson(extraStaff: 2, extrasUntil: null));

      expect(farm.hasActiveExtras, isTrue);
      expect(farm.effectiveStaffLimit, 5);
    });

    test('истёкшая поблажка не считается и названа истёкшей', () {
      final farm = PlatformFarmDetail.fromJson(farmJson(
        extraRabbits: 50,
        extrasUntil: DateTime.now()
            .subtract(const Duration(days: 1))
            .toUtc()
            .toIso8601String(),
      ));

      expect(farm.hasActiveExtras, isFalse);
      expect(farm.hasExpiredExtras, isTrue);
      expect(farm.effectiveRabbitsLimit, 30);
    });

    test('ферма без тарифа не выдумывает пределов даже с поблажкой', () {
      final farm = PlatformFarmDetail.fromJson({
        'id': 4,
        'name': 'Новая',
        'created_at': '2026-08-01T10:00:00.000Z',
        'extra_rabbits': 10,
      });

      expect(farm.effectiveRabbitsLimit, isNull);
      expect(farm.rabbitsUsage, isNull);
      expect(farm.isAtLimit, isFalse);
      // Состав и платежи не приехали — пусто, а не падение разбора.
      expect(farm.staff, isEmpty);
      expect(farm.payments, isEmpty);
      expect(farm.storageBytes, 0);
      // Состояние по умолчанию — обычная работа.
      expect(farm.isActive, isTrue);
    });

    test('пометка на удаление разбирается и отличается от живой фермы', () {
      expect(PlatformFarmDetail.fromJson(farmJson()).isDeleted, isFalse);

      final deleted = PlatformFarmDetail.fromJson(
        farmJson(deletedAt: '2026-09-08T12:00:00.000Z'),
      );
      expect(deleted.isDeleted, isTrue);
      expect(deleted.deletedAt, isNotNull);
    });

    test('состояния доступа различимы', () {
      expect(
        PlatformFarmDetail.fromJson(farmJson(status: 'read_only')).isReadOnly,
        isTrue,
      );
      expect(
        PlatformFarmDetail.fromJson(farmJson(status: 'suspended')).isSuspended,
        isTrue,
      );
    });
  });
}