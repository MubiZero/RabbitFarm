import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/rabbits/data/models/breed_model.dart';
import 'package:mobile/features/rabbits/data/models/rabbit_model.dart';
import 'package:mobile/features/rabbits/data/models/rabbit_statistics.dart';

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
  });
}