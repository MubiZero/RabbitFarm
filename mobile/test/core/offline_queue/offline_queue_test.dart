import 'dart:async';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';

import 'package:mobile/core/api/api_client.dart';
import 'package:mobile/core/api/api_failure.dart';
import 'package:mobile/core/cache/cache_scope.dart';
import 'package:mobile/core/offline_queue/offline_queue.dart';
import 'package:mobile/core/providers/connectivity.dart';
import 'package:mobile/features/feeding/data/models/feeding_record_model.dart';
import 'package:mobile/features/feeding/data/repositories/feeding_records_repository.dart';
import 'package:mobile/features/notes/data/models/note_model.dart';
import 'package:mobile/features/notes/data/repositories/notes_repository.dart';
import 'package:mobile/features/tasks/data/models/task_model.dart';
import 'package:mobile/features/tasks/data/repositories/tasks_repository.dart';
import 'package:mobile/features/tasks/presentation/providers/tasks_provider.dart';
import 'package:mobile/features/feeding/presentation/providers/feeding_records_provider.dart';
import 'package:mobile/features/notes/presentation/providers/notes_provider.dart';
import 'package:mobile/shared/models/api_response.dart';
import 'package:mobile/features/breeding/data/repositories/breeding_repository.dart';
import 'package:mobile/features/breeding/presentation/providers/breeding_provider.dart';
import 'package:mobile/features/rabbits/data/models/birth_model.dart';
import 'package:mobile/features/rabbits/data/models/breeding_model.dart';
import 'package:mobile/features/rabbits/data/models/rabbit_model.dart';
import 'package:mobile/features/rabbits/data/repositories/births_repository.dart';
import 'package:mobile/features/rabbits/data/repositories/rabbits_repository.dart';
import 'package:mobile/features/health/data/models/medical_record_model.dart';
import 'package:mobile/features/health/data/models/vaccination_model.dart';
import 'package:mobile/features/health/data/repositories/medical_records_repository.dart';
import 'package:mobile/features/health/presentation/providers/medical_records_provider.dart';
import 'package:mobile/features/health/data/repositories/vaccinations_repository.dart';
import 'package:mobile/features/rabbits/presentation/providers/rabbits_provider.dart';

/// Репозиторий задач без сети: только то, что нужно очереди — список для
/// `tasksListProvider.notifier.refresh()` и сама отметка выполнения.
class _FakeTasksRepository extends TasksRepository {
  _FakeTasksRepository({this.completeError, this.rejectIds = const {}})
      : super(ApiClient(storage: const FlutterSecureStorage()));

  final Object? completeError;

  /// Id задач, которые сервер отклоняет окончательно (не «нет сети») —
  /// имитация «эту задачу уже закрыл другой работник».
  final Set<int> rejectIds;
  final List<int> completed = [];

  @override
  Future<Map<String, dynamic>> getTasks({
    int page = 1,
    int limit = 10,
    String? sortBy,
    String? sortOrder,
    TaskType? type,
    TaskStatus? status,
    TaskPriority? priority,
    int? rabbitId,
    int? cageId,
    int? assignedTo,
    int? createdBy,
    String? fromDate,
    String? toDate,
    bool? overdueOnly,
    bool? todayOnly,
  }) async =>
      {
        'tasks': <Task>[],
        'pagination': {'page': 1, 'pages': 1, 'total': 0},
      };

  @override
  Future<Task> completeTask(int id) async {
    if (completeError != null) throw completeError!;
    if (rejectIds.contains(id)) {
      throw const ApiFailure(
        ApiFailureKind.invalid,
        serverText: 'Задачу уже закрыл другой работник',
      );
    }
    completed.add(id);
    return Task(
      id: id,
      title: 'Задача $id',
      type: TaskType.feeding,
      status: TaskStatus.completed,
      priority: TaskPriority.medium,
      dueDate: DateTime.now(),
    );
  }
}

/// Репозиторий кормлений без сети: список для `feedingRecordsProvider` и
/// сама пачковая запись.
class _FakeFeedingRepository extends FeedingRecordsRepository {
  _FakeFeedingRepository()
      : super(ApiClient(storage: const FlutterSecureStorage()));

  var createCalls = 0;

  @override
  Future<List<FeedingRecord>> getFeedingRecords({
    int? page,
    int? limit,
    String? sortBy,
    String? sortOrder,
    int? rabbitId,
    int? feedId,
    int? cageId,
    DateTime? fromDate,
    DateTime? toDate,
  }) async =>
      const [];

  @override
  Future<int> createFeedingRecordsBulk({
    required int feedId,
    required double quantityPerRecipient,
    required DateTime fedAt,
    List<int> rabbitIds = const [],
    List<int> cageIds = const [],
    String? notes,
  }) async {
    createCalls++;
    return rabbitIds.length + cageIds.length;
  }
}

/// Репозиторий заметок без сети.
class _FakeNotesRepository extends NotesRepository {
  _FakeNotesRepository()
      : super(ApiClient(storage: const FlutterSecureStorage()));

  final List<String> created = [];

  @override
  Future<NoteModel> createNote(NoteCreate note) async {
    created.add(note.content);
    return NoteModel(id: created.length, content: note.content);
  }
}

/// Репозиторий окролов без сети. Окрол — то, ради чего человек достаёт
/// телефон у клетки, где связи нет, поэтому очередь обязана его нести.
class _FakeBirthsRepository extends BirthsRepository {
  _FakeBirthsRepository()
      : super(apiClient: ApiClient(storage: const FlutterSecureStorage()));

  final List<Map<String, dynamic>> created = [];

  @override
  Future<List<BirthModel>> getBirths() async => const [];

  @override
  Future<BirthModel> createBirth(Map<String, dynamic> birthData) async {
    created.add(birthData);
    return BirthModel(
      id: created.length,
      motherId: birthData['mother_id'] as int,
      birthDate: birthData['birth_date'] as String,
      kitsBornAlive: birthData['kits_born_alive'] as int,
      kitsBornDead: birthData['kits_born_dead'] as int,
    );
  }
}

/// Репозиторий случек без сети.
class _FakeBreedingRepository extends BreedingRepository {
  _FakeBreedingRepository()
      : super(apiClient: ApiClient(storage: const FlutterSecureStorage()));

  final List<Map<String, dynamic>> created = [];

  @override
  Future<PaginatedResponse<BreedingModel>> getBreedings({
    int page = 1,
    int limit = 20,
    String? status,
    int? maleId,
    int? femaleId,
    String? fromDate,
    String? toDate,
  }) async =>
      PaginatedResponse<BreedingModel>(
        items: const [],
        total: 0,
        page: page,
        limit: limit,
        totalPages: 0,
      );

  @override
  Future<BreedingModel> createBreeding(Map<String, dynamic> data) async {
    created.add(data);
    return BreedingModel(
      id: created.length,
      maleId: data['male_id'] as int,
      femaleId: data['female_id'] as int,
      breedingDate: data['breeding_date'] as String,
      status: data['status'] as String,
    );
  }
}

/// Кролики без сети: очередь трогает только отметку падежа.
class _FakeRabbitsRepository extends RabbitsRepository {
  _FakeRabbitsRepository()
      : super(apiClient: ApiClient(storage: const FlutterSecureStorage()));

  final List<(int, Map<String, dynamic>)> updates = [];

  @override
  Future<PaginatedResponse<RabbitModel>> getRabbits({
    int page = 1,
    int limit = 10,
    String? search,
    String? sex,
    String? status,
    String? purpose,
    int? breedId,
  }) async =>
      PaginatedResponse<RabbitModel>(
        items: const [],
        total: 0,
        page: page,
        limit: limit,
        totalPages: 0,
      );

  @override
  Future<RabbitModel> updateRabbit(int id, Map<String, dynamic> data) async {
    updates.add((id, data));
    return RabbitModel(
      id: id,
      breedId: 1,
      sex: 'female',
      birthDate: DateTime(2026, 1, 1),
      status: data['status'] as String? ?? 'active',
      purpose: 'breeding',
      createdAt: DateTime(2026, 1, 1),
      updatedAt: DateTime(2026, 1, 1),
    );
  }
}

/// Пропускает несколько оборотов очереди микрозадач — колбэк `ref.listen`
/// внутри контроллера и восстановление с диска не awaitable снаружи
/// напрямую, а без паузы тест проверял бы состояние до того, как они
/// успели отработать.
Future<void> _settle() async {
  for (var i = 0; i < 5; i++) {
    await Future<void>.delayed(Duration.zero);
  }
}

/// Лечение и прививка: очередь шлёт их готовым телом запроса, поэтому от
/// репозитория нужен только приём Map и возможность отказать.
class _FakeMedicalRepository extends MedicalRecordsRepository {
  _FakeMedicalRepository({this.error})
      : super(ApiClient(storage: const FlutterSecureStorage()));

  final Object? error;
  final sent = <Map<String, dynamic>>[];

  @override
  Future<MedicalRecord> createMedicalRecordFromJson(
      Map<String, dynamic> data) async {
    if (error != null) throw error!;
    sent.add(data);
    return MedicalRecord(
      id: 1,
      rabbitId: data['rabbit_id'] as int,
      symptoms: data['symptoms'] as String? ?? '',
      startedAt: DateTime.parse(data['started_at'] as String),
      outcome: MedicalOutcome.ongoing,
    );
  }
}

class _FakeVaccinationsRepository extends VaccinationsRepository {
  _FakeVaccinationsRepository({this.error})
      : super(apiClient: ApiClient(storage: const FlutterSecureStorage()));

  final Object? error;
  final sent = <Map<String, dynamic>>[];

  @override
  Future<Vaccination> createVaccinationFromJson(
      Map<String, dynamic> data) async {
    if (error != null) throw error!;
    sent.add(data);
    return Vaccination(
      id: 1,
      rabbitId: data['rabbit_id'] as int,
      vaccineName: data['vaccine_name'] as String,
      vaccineType: VaccineType.other,
      vaccinationDate: DateTime.parse(data['vaccination_date'] as String),
    );
  }
}

ProviderContainer _container({
  required Stream<bool> online,
  String? scope,
  TasksRepository? tasks,
  FeedingRecordsRepository? feeding,
  NotesRepository? notes,
  BirthsRepository? births,
  BreedingRepository? breeding,
  RabbitsRepository? rabbits,
  MedicalRecordsRepository? medical,
  VaccinationsRepository? vaccinations,
}) {
  final container = ProviderContainer(
    overrides: [
      isOnlineProvider.overrideWith((ref) => online),
      cacheScopeProvider.overrideWithValue(scope),
      if (tasks != null) tasksRepositoryProvider.overrideWithValue(tasks),
      if (feeding != null)
        feedingRecordsRepositoryProvider.overrideWithValue(feeding),
      if (notes != null) notesRepositoryProvider.overrideWithValue(notes),
      if (births != null) birthsRepositoryProvider.overrideWithValue(births),
      if (breeding != null)
        breedingRepositoryProvider.overrideWithValue(breeding),
      if (rabbits != null) rabbitsRepositoryProvider.overrideWithValue(rabbits),
      if (medical != null)
        medicalRecordsRepositoryProvider.overrideWithValue(medical),
      if (vaccinations != null)
        vaccinationsRepositoryProvider.overrideWithValue(vaccinations),
    ],
  );
  addTearDown(container.dispose);
  // `.future` на голом ProviderContainer без единого слушателя у этой
  // версии riverpod зависает — а вот постоянный `listen` (как у виджета,
  // который вотчит провайдер) резолвит стрим сразу же.
  container.listen(isOnlineProvider, (_, __) {});
  return container;
}

void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  group(
    'OfflineQueueController — базовая механика (scope=null, диск не трогается)',
    () {
      test('успешная отправка снимает элемент с очереди', () async {
        final tasks = _FakeTasksRepository();
        final container = _container(online: Stream.value(true), tasks: tasks);
        await _settle();

        final controller = container.read(offlineQueueProvider.notifier);
        await controller.enqueue(OfflineActionType.taskComplete, {
          'task_id': 1,
        });
        expect(container.read(offlineQueueProvider), hasLength(1));

        await controller.flush();

        expect(container.read(offlineQueueProvider), isEmpty);
        expect(tasks.completed, [1]);
      });

      test('нет сети — элемент остаётся первым, порядок не ломается', () async {
        final tasks = _FakeTasksRepository(
          completeError: const ApiFailure(ApiFailureKind.offline),
        );
        final container = _container(online: Stream.value(true), tasks: tasks);
        await _settle();

        final controller = container.read(offlineQueueProvider.notifier);
        await controller.enqueue(OfflineActionType.taskComplete, {
          'task_id': 1,
        });
        await controller.enqueue(OfflineActionType.taskComplete, {
          'task_id': 2,
        });

        await controller.flush();

        // Первый элемент не прошёл из-за «сети нет» — второй ждёт своей
        // очереди, а не проскакивает вперёд.
        final remaining = container.read(offlineQueueProvider);
        expect(remaining, hasLength(2));
        expect(remaining.first.payload['task_id'], 1);
        expect(tasks.completed, isEmpty);
      });

      test(
        'дроп по-настоящему отказанного элемента не блокирует следующий',
        () async {
          final tasks = _FakeTasksRepository(rejectIds: {1});
          final container = _container(
            online: Stream.value(true),
            tasks: tasks,
          );
          await _settle();

          final controller = container.read(offlineQueueProvider.notifier);
          await controller.enqueue(OfflineActionType.taskComplete, {
            'task_id': 1,
          });
          await controller.enqueue(OfflineActionType.taskComplete, {
            'task_id': 2,
          });

          await controller.flush();

          // Первую отклонил сервер окончательно (не «нет сети») — она выброшена,
          // но очередь не зависла на ней: вторая всё равно дошла.
          expect(container.read(offlineQueueProvider), isEmpty);
          expect(tasks.completed, [2]);
        },
      );

      test('кормление и заметка тоже уходят через очередь', () async {
        final feeding = _FakeFeedingRepository();
        final notes = _FakeNotesRepository();
        final container = _container(
          online: Stream.value(true),
          feeding: feeding,
          notes: notes,
        );
        await _settle();

        final controller = container.read(offlineQueueProvider.notifier);
        await controller.enqueue(OfflineActionType.feedingRecord, {
          'feed_id': 1,
          'quantity': 0.5,
          'fed_at': DateTime(2026, 1, 1).toIso8601String(),
          'rabbit_ids': [10, 11],
          'cage_ids': <int>[],
        });
        await controller.enqueue(
          OfflineActionType.note,
          NoteCreate(content: 'Заметка с обхода').toJson(),
        );

        await controller.flush();

        expect(container.read(offlineQueueProvider), isEmpty);
        expect(feeding.createCalls, 1);
        expect(notes.created, ['Заметка с обхода']);
      });

      test('окрол и случка тоже уходят через очередь', () async {
        final births = _FakeBirthsRepository();
        final breeding = _FakeBreedingRepository();
        final container = _container(
          online: Stream.value(true),
          births: births,
          breeding: breeding,
        );
        await _settle();

        final controller = container.read(offlineQueueProvider.notifier);
        await controller.enqueue(OfflineActionType.birth, {
          'mother_id': 7,
          'birth_date': '2026-09-14',
          'kits_born_alive': 8,
          'kits_born_dead': 1,
        });
        await controller.enqueue(OfflineActionType.breeding, {
          'male_id': 3,
          'female_id': 7,
          'breeding_date': '2026-09-14',
          'status': 'completed',
        });

        await controller.flush();

        expect(container.read(offlineQueueProvider), isEmpty);
        expect(births.created.single['kits_born_alive'], 8);
        expect(breeding.created.single['female_id'], 7);
      });

      test('падёж тоже уходит через очередь', () async {
        final rabbits = _FakeRabbitsRepository();
        final container = _container(
          online: Stream.value(true),
          rabbits: rabbits,
        );
        await _settle();

        final controller = container.read(offlineQueueProvider.notifier);
        await controller.enqueue(OfflineActionType.rabbitDeath, {
          'rabbit_id': 42,
          'status': 'deceased',
          'death_date': '2026-09-14',
          'death_reason': 'Не ела два дня',
        });

        await controller.flush();

        expect(container.read(offlineQueueProvider), isEmpty);
        // `rabbit_id` — адрес записи, а не её поле: в теле запроса его быть
        // не должно.
        final (id, data) = rabbits.updates.single;
        expect(id, 42);
        expect(data, {
          'status': 'deceased',
          'death_date': '2026-09-14',
          'death_reason': 'Не ела два дня',
        });
      });

      test('лечение и прививка тоже уходят через очередь', () async {
        // Их фермер назвал первыми: укол ставят, стоя рядом с кроликом в
        // сарае, где связи нет. До сих пор такая запись пропадала молча —
        // форма говорила «сохранено», а записи не было.
        final medical = _FakeMedicalRepository();
        final vaccinations = _FakeVaccinationsRepository();
        final container = _container(
          online: Stream.value(true),
          medical: medical,
          vaccinations: vaccinations,
        );
        await _settle();

        final controller = container.read(offlineQueueProvider.notifier);
        await controller.enqueue(OfflineActionType.medicalRecord, {
          'rabbit_id': 7,
          'symptoms': 'Не ест второй день',
          'started_at': '2026-09-16',
        });
        await controller.enqueue(OfflineActionType.vaccination, {
          'rabbit_id': 7,
          'vaccine_name': 'ВГБК',
          'vaccine_type': 'other',
          'vaccination_date': '2026-09-16',
        });

        await controller.flush();

        expect(container.read(offlineQueueProvider), isEmpty);
        expect(medical.sent.single['symptoms'], 'Не ест второй день');
        expect(vaccinations.sent.single['vaccine_name'], 'ВГБК');
      });

      test('отвергнутая сервером запись не пропадает молча', () async {
        // Повторами такой отказ не лечится, но и выбрасывать запись нельзя:
        // человек доверил очереди работу вместо того, чтобы держать её в
        // голове, и должен узнать, что записывать придётся заново.
        final medical = _FakeMedicalRepository(
          error: const ApiFailure(ApiFailureKind.invalid),
        );
        final container = _container(
          online: Stream.value(true),
          medical: medical,
        );
        await _settle();

        final controller = container.read(offlineQueueProvider.notifier);
        await controller.enqueue(OfflineActionType.medicalRecord, {
          'rabbit_id': 7,
          'symptoms': 'Хромает',
          'started_at': '2026-09-16',
        });

        await controller.flush();

        // Из очереди ушла — повторять бессмысленно.
        expect(container.read(offlineQueueProvider), isEmpty);
        // Но человеку про неё скажут.
        final rejected = container.read(offlineRejectedProvider);
        expect(rejected, hasLength(1));
        expect(rejected.single.type, OfflineActionType.medicalRecord);
        expect(rejected.single.payload['symptoms'], 'Хромает');
      });

      test(
        'восстановленная связь запускает отправку сама, без ручного flush',
        () async {
          final online = StreamController<bool>();
          addTearDown(online.close);
          final tasks = _FakeTasksRepository();
          final container = _container(online: online.stream, tasks: tasks);

          online.add(false);
          await _settle();

          final controller = container.read(offlineQueueProvider.notifier);
          await controller.enqueue(OfflineActionType.taskComplete, {
            'task_id': 7,
          });
          expect(tasks.completed, isEmpty);

          online.add(true);
          await _settle();

          expect(tasks.completed, [7]);
          expect(container.read(offlineQueueProvider), isEmpty);
        },
      );
    },
  );

  group(
    'OfflineQueueController — переживает пересоздание (диск, реальный scope)',
    () {
      late Directory tempDir;

      setUpAll(() {
        tempDir = Directory.systemTemp.createTempSync('offline_queue_test');
        Hive.init(tempDir.path);
      });

      tearDownAll(() async {
        await Hive.close();
        if (tempDir.existsSync()) tempDir.deleteSync(recursive: true);
      });

      test(
        'элемент, поставленный в очередь при первом контроллере, виден второму',
        () async {
          const scope = 'u-test-1';

          final containerA = _container(
            online: Stream.value(false),
            scope: scope,
            tasks: _FakeTasksRepository(),
          );
          await _settle();
          await containerA.read(offlineQueueProvider.notifier).enqueue(
            OfflineActionType.taskComplete,
            {'task_id': 42},
          );
          expect(containerA.read(offlineQueueProvider), hasLength(1));
          containerA.dispose();

          // Новый контроллер — как после перезапуска приложения или повторного
          // входа тем же пользователем. Он не должен начинать с пустой очереди.
          final tasksB = _FakeTasksRepository();
          final containerB = _container(
            online: Stream.value(false),
            scope: scope,
            tasks: tasksB,
          );
          // Читаем контроллер, чтобы он начал восстановление с диска.
          containerB.read(offlineQueueProvider.notifier);
          await _settle();

          final restored = containerB.read(offlineQueueProvider);
          expect(restored, hasLength(1));
          expect(restored.single.payload['task_id'], 42);
          addTearDown(containerB.dispose);
        },
      );

      test('разные пользователи не видят чужую очередь', () async {
        final containerA = _container(
          online: Stream.value(false),
          scope: 'u-a',
          tasks: _FakeTasksRepository(),
        );
        await _settle();
        await containerA.read(offlineQueueProvider.notifier).enqueue(
          OfflineActionType.taskComplete,
          {'task_id': 1},
        );
        containerA.dispose();

        final containerB = _container(
          online: Stream.value(false),
          scope: 'u-b',
          tasks: _FakeTasksRepository(),
        );
        containerB.read(offlineQueueProvider.notifier);
        await _settle();

        expect(containerB.read(offlineQueueProvider), isEmpty);
        addTearDown(containerB.dispose);
      });
    },
  );
}
