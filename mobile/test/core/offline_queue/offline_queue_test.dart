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
  }) async => {
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
  }) async => const [];

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

/// Пропускает несколько оборотов очереди микрозадач — колбэк `ref.listen`
/// внутри контроллера и восстановление с диска не awaitable снаружи
/// напрямую, а без паузы тест проверял бы состояние до того, как они
/// успели отработать.
Future<void> _settle() async {
  for (var i = 0; i < 5; i++) {
    await Future<void>.delayed(Duration.zero);
  }
}

ProviderContainer _container({
  required Stream<bool> online,
  String? scope,
  TasksRepository? tasks,
  FeedingRecordsRepository? feeding,
  NotesRepository? notes,
}) {
  final container = ProviderContainer(
    overrides: [
      isOnlineProvider.overrideWith((ref) => online),
      cacheScopeProvider.overrideWithValue(scope),
      if (tasks != null) tasksRepositoryProvider.overrideWithValue(tasks),
      if (feeding != null)
        feedingRecordsRepositoryProvider.overrideWithValue(feeding),
      if (notes != null) notesRepositoryProvider.overrideWithValue(notes),
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
