import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/rabbits/data/models/breed_model.dart';
import 'package:mobile/features/rabbits/data/models/rabbit_model.dart';
import 'package:mobile/features/rabbits/data/models/rabbit_statistics.dart';
import 'package:mobile/features/platform_admin/data/models/platform_admin_models.dart';

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
}