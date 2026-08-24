import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/feeding/data/models/feed_model.dart';
import 'package:mobile/features/feeding/data/models/feeding_record_model.dart';
import 'package:mobile/features/rabbits/data/models/rabbit_model.dart';
import 'package:mobile/features/tasks/data/models/task_model.dart';

/// Связанные записи в ответах сервера.
///
/// Формы взяты из бэкенда: `feedingRecordController` кладёт корм, кролика и
/// клетку целиком и добавляет автора `fedBy` тремя полями, а `taskService`
/// отдаёт кролика и клетку урезанными — `['id','name','tag_id']` и
/// `['id','number','location']`. Если модель снова начнёт их выбрасывать,
/// экраны опять покажут «Корм не указан» — эти тесты про то, что имена
/// доезжают.
void main() {
  group('FeedingRecord', () {
    test('забирает корм, кролика, клетку и автора из ответа списка', () {
      final record = FeedingRecord.fromJson(_feedingListItem());

      expect(record.feed?.name, 'Комбикорм для кроликов ПК-90');
      expect(record.feed?.unit.displayName, 'кг');
      expect(record.rabbit?.name, 'Бусинка');
      expect(record.cage?.number, 'C1');
      expect(record.author?.fullName, 'Пётр Иванов');
      // Число автора остаётся на месте: по нему запись фильтруется.
      expect(record.fedBy, 7);
    });

    test('переживает ответ без связанных записей', () {
      final json = _feedingListItem()
        ..remove('feed')
        ..remove('rabbit')
        ..remove('cage')
        ..remove('fedBy');

      final record = FeedingRecord.fromJson(json);

      expect(record.feed, isNull);
      expect(record.rabbit, isNull);
      expect(record.cage, isNull);
      expect(record.author, isNull);
      expect(record.feedId, 3);
    });
  });

  group('Task', () {
    test('забирает урезанных кролика и клетку и постановщика', () {
      final task = Task.fromJson(_taskListItem());

      expect(task.rabbit?.name, 'Бусинка');
      expect(task.rabbit?.tagId, 'R-001');
      expect(task.cage?.number, 'C1');
      expect(task.cage?.location, 'Сарай');
      expect(task.author?.fullName, 'Пётр Иванов');
    });

    test('урезанный кролик не роняет разбор', () {
      // В задачах кролик приходит тремя полями: породы, пола и даты рождения,
      // которых требует полная карточка, в ответе нет вовсе.
      final rabbit = Task.fromJson(_taskListItem()).rabbit;

      expect(rabbit, isA<RabbitRef>());
      expect(rabbit?.id, 4);
    });

    test('кролик без имени и клейма не роняет разбор', () {
      // Имя и клеймо в базе необязательны: кролик, заведённый одной кнопкой,
      // приезжает с обоими null — и раньше это уронило бы весь список.
      final json = _taskListItem();
      json['rabbit'] = {'id': 4, 'name': null, 'tag_id': null};

      final task = Task.fromJson(json);

      expect(task.rabbit?.name, isNull);
      expect(task.rabbit?.label, '#4');
    });

    test('кролик без имени подписывается клеймом', () {
      final json = _taskListItem();
      json['rabbit'] = {'id': 4, 'name': null, 'tag_id': 'R-001'};

      expect(Task.fromJson(json).rabbit?.label, 'R-001');
    });

    test('ответ без постановщика разбирается', () {
      // «Ближайшие дела» и «отметить выполненной» отдают задачу без `creator`.
      final json = _taskListItem()..remove('creator');

      expect(Task.fromJson(json).author, isNull);
    });
  });

  group('RabbitModel', () {
    test('родословная разбирается той же ссылкой на кролика', () {
      final json = _rabbitItem();

      final rabbit = RabbitModel.fromJson(json);

      expect(rabbit.father?.label, 'Граф');
      expect(rabbit.mother?.label, 'R-013');
      expect(rabbit.cage?.number, 'C1');
    });
  });
}

/// Строка ответа `GET /feeding-records`: связи приходят целиком, автор — нет.
Map<String, dynamic> _feedingListItem() => {
      'id': 17,
      'rabbit_id': 4,
      'feed_id': 3,
      'cage_id': 9,
      // DECIMAL сериализуется строкой.
      'quantity': '2.50',
      'fed_at': '2026-08-20T07:15:00.000Z',
      'fed_by': 7,
      'notes': null,
      'created_at': '2026-08-20T07:15:04.000Z',
      'feed': {
        'id': 3,
        'name': 'Комбикорм для кроликов ПК-90',
        'user_id': 1,
        'type': 'pellets',
        'brand': 'Пурина',
        'unit': 'kg',
        'current_stock': '48.50',
        'min_stock': '10.00',
        'cost_per_unit': '32.00',
        'notes': null,
        'created_at': '2026-05-01T10:00:00.000Z',
        'updated_at': '2026-08-20T07:15:04.000Z',
      },
      'rabbit': {
        'id': 4,
        'user_id': 1,
        'tag_id': 'R-001',
        'name': 'Бусинка',
        'breed_id': 2,
        'sex': 'female',
        'birth_date': '2025-11-03',
        'color': 'белый',
        'cage_id': 9,
        'father_id': null,
        'mother_id': null,
        'status': 'healthy',
        'purpose': 'breeding',
        'acquired_date': null,
        'sold_date': null,
        'death_date': null,
        'death_reason': null,
        'current_weight': 3.4,
        'temperament': null,
        'notes': null,
        'photo_url': null,
        'created_at': '2026-01-12T09:00:00.000Z',
        'updated_at': '2026-08-01T09:00:00.000Z',
      },
      'cage': {
        'id': 9,
        'number': 'C1',
        'user_id': 1,
        'type': 'single',
        'size': '60x80x45',
        'capacity': 1,
        'location': 'Сарай',
        'condition': 'good',
        'last_cleaned_at': null,
        'notes': null,
        'created_at': '2026-01-10T09:00:00.000Z',
        'updated_at': '2026-01-10T09:00:00.000Z',
      },
      'fedBy': {
        'id': 7,
        'full_name': 'Пётр Иванов',
        'email': 'petr@example.com',
      },
    };

/// Строка ответа `GET /tasks`: кролик и клетка урезаны выборкой полей.
Map<String, dynamic> _taskListItem() => {
      'id': 31,
      'title': 'Осмотр',
      'description': null,
      'type': 'checkup',
      'status': 'completed',
      'priority': 'high',
      'due_date': '2026-08-20T06:00:00.000Z',
      'completed_at': '2026-08-20T08:40:00.000Z',
      'rabbit_id': 4,
      'cage_id': 9,
      'assigned_to': 7,
      'created_by': 1,
      'is_recurring': false,
      'recurrence_rule': null,
      'reminder_before': null,
      'notes': null,
      'created_at': '2026-08-19T18:00:00.000Z',
      'updated_at': '2026-08-20T08:40:00.000Z',
      'rabbit': {'id': 4, 'name': 'Бусинка', 'tag_id': 'R-001'},
      'cage': {'id': 9, 'number': 'C1', 'location': 'Сарай'},
      'assignedTo': {
        'id': 7,
        'full_name': 'Пётр Иванов',
        'email': 'petr@example.com',
      },
      'creator': {
        'id': 1,
        'full_name': 'Пётр Иванов',
        'email': 'owner@example.com',
      },
    };

/// Строка ответа `GET /rabbits/:id`: родители приходят тремя полями.
Map<String, dynamic> _rabbitItem() => {
      'id': 4,
      'tag_id': 'R-001',
      'name': 'Бусинка',
      'breed_id': 2,
      'sex': 'female',
      'birth_date': '2025-11-03',
      'cage_id': 9,
      'father_id': 12,
      'mother_id': 13,
      'status': 'healthy',
      'purpose': 'breeding',
      'created_at': '2026-01-12T09:00:00.000Z',
      'updated_at': '2026-08-01T09:00:00.000Z',
      'Cage': {'id': 9, 'number': 'C1', 'type': 'single', 'location': 'Сарай'},
      'father': {'id': 12, 'name': 'Граф', 'tag_id': 'R-012'},
      'mother': {'id': 13, 'name': null, 'tag_id': 'R-013'},
    };
