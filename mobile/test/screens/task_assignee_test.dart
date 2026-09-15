import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mobile/core/access/farm_access.dart';
import 'package:mobile/core/api/api_client.dart';
import 'package:mobile/core/api/paginated.dart';
import 'package:mobile/core/cache/cache_scope.dart';
import 'package:mobile/core/models/user_ref.dart';
import 'package:mobile/features/staff/data/models/staff_models.dart';
import 'package:mobile/features/staff/presentation/providers/staff_provider.dart';
import 'package:mobile/features/tasks/data/models/task_model.dart';
import 'package:mobile/features/tasks/data/repositories/tasks_repository.dart';
import 'package:mobile/features/tasks/presentation/providers/tasks_provider.dart';
import 'package:mobile/features/tasks/presentation/screens/task_form_screen.dart';
import 'package:mobile/features/tasks/presentation/screens/tasks_list_screen.dart';

import '../support/test_app.dart';

/// Сервер поддерживает исполнителя целиком: принимает `assigned_to`, кладёт
/// человека в каждый ответ и шлёт ему личный пуш. Приложение разбирало только
/// число и не показывало его нигде — поручить дело работнику было нельзя, а
/// список задач на ферме с работниками не отвечал на вопрос «чьё это».
class _FakeTasksRepository extends TasksRepository {
  _FakeTasksRepository({this.tasks = const []})
      : super(ApiClient(storage: const FlutterSecureStorage()));

  final List<Task> tasks;
  final List<TaskCreate> created = [];
  final List<TaskUpdate> updated = [];

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
        'tasks': page == 1 ? tasks : <Task>[],
        'pagination': PageInfo(
          page: page,
          limit: limit,
          total: tasks.length,
          totalPages: 1,
        ),
      };

  @override
  Future<Task> createTask(TaskCreate task) async {
    created.add(task);
    return _task();
  }

  @override
  Future<Task> updateTask(int id, TaskUpdate task) async {
    updated.add(task);
    return _task();
  }
}

Task _task({int? assignedTo, UserRef? assignee}) => Task(
      id: 7,
      title: 'Почистить клетки',
      type: TaskType.cleaning,
      status: TaskStatus.pending,
      priority: TaskPriority.medium,
      dueDate: DateTime.now().add(const Duration(days: 1)),
      assignedTo: assignedTo,
      assignee: assignee,
    );

const _owner = FarmMember(
  id: 1,
  email: 'owner@example.com',
  fullName: 'Пётр Владелец',
  role: FarmRole.owner,
);

const _worker = FarmMember(
  id: 2,
  email: 'worker@example.com',
  fullName: 'Иван Работник',
  role: FarmRole.worker,
);

/// Уволенный: в составе фермы его уже нет, а задача на нём ещё висит.
const _gone = UserRef(id: 3, fullName: 'Сергей Ушедший');

Widget _form({
  Task? task,
  required _FakeTasksRepository repository,
  FarmRoleAccess role = FarmRoleAccess.owner,
  List<FarmMember> members = const [_owner, _worker],
}) =>
    testAppScreen(
      TaskFormScreen(task: task),
      overrides: [
        tasksRepositoryProvider.overrideWithValue(repository),
        farmMembersProvider.overrideWith((ref) async => members),
        farmRoleProvider.overrideWithValue(role),
        cacheScopeProvider.overrideWithValue(null),
      ],
    );

Future<void> _settle(WidgetTester tester) async {
  await tester.binding.setSurfaceSize(const Size(420, 1600));
  addTearDown(() => tester.binding.setSurfaceSize(null));
  await tester.pumpAndSettle();
}

Future<void> _pickAssignee(WidgetTester tester, String name) async {
  final dropdown = find.byType(DropdownButtonFormField<int?>);
  await tester.ensureVisible(dropdown);
  await tester.pumpAndSettle();
  await tester.tap(dropdown);
  await tester.pumpAndSettle();
  await tester.tap(find.text(name).last);
  await tester.pumpAndSettle();
}

Future<void> _submit(WidgetTester tester, String label) async {
  await tester.ensureVisible(find.widgetWithText(FilledButton, label));
  await tester.tap(find.widgetWithText(FilledButton, label));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('владелец поручает задачу работнику, и это уходит на сервер',
      (tester) async {
    final repository = _FakeTasksRepository();
    await tester.pumpWidget(_form(repository: repository));
    await _settle(tester);

    await tester.enterText(
      find.widgetWithText(TextFormField, 'Что нужно сделать'),
      'Почистить клетки',
    );
    await _pickAssignee(tester, 'Иван Работник');
    await _submit(tester, 'Создать');

    expect(repository.created.single.assignedTo, _worker.id);
  });

  // Работнику сервер состав фермы не отдаёт (`GET /staff` — manager и owner),
  // так что выпадающий список у него всё равно остался бы пустым. Задачу ему
  // поручают, а не он себе выбирает.
  testWidgets('работник поля исполнителя не видит', (tester) async {
    await tester.pumpWidget(_form(
      repository: _FakeTasksRepository(),
      role: FarmRoleAccess.worker,
    ));
    await _settle(tester);

    expect(find.text('Исполнитель'), findsNothing);
    expect(find.text('Иван Работник'), findsNothing);
  });

  testWidgets('поручение снимается выбором «никому не поручена»',
      (tester) async {
    final repository = _FakeTasksRepository();
    await tester.pumpWidget(_form(
      task: _task(
          assignedTo: _worker.id,
          assignee: const UserRef(id: 2, fullName: 'Иван Работник')),
      repository: repository,
    ));
    await _settle(tester);

    await _pickAssignee(tester, 'Никому не поручена');
    await _submit(tester, 'Сохранить');

    expect(repository.updated.single.assignedTo, isNull);
  });

  // Уволенного в составе фермы больше нет, и без отдельного пункта список не
  // нашёл бы своего значения. Молчаливая подстановка «не назначен» стёрла бы
  // поручение при первом же сохранении — человек правил бы срок, а терял
  // исполнителя.
  testWidgets('исполнитель, которого убрали с фермы, не теряется при правке',
      (tester) async {
    final repository = _FakeTasksRepository();
    await tester.pumpWidget(_form(
      task: _task(assignedTo: _gone.id, assignee: _gone),
      repository: repository,
    ));
    await _settle(tester);

    expect(find.text(_gone.fullName), findsWidgets);

    await _submit(tester, 'Сохранить');

    expect(repository.updated.single.assignedTo, _gone.id);
  });

  testWidgets('список задач называет исполнителя', (tester) async {
    final repository = _FakeTasksRepository(tasks: [
      _task(
        assignedTo: _worker.id,
        assignee: const UserRef(id: 2, fullName: 'Иван Работник'),
      ),
    ]);

    await tester.pumpWidget(testAppScreen(
      const TasksListScreen(),
      overrides: [
        tasksRepositoryProvider.overrideWithValue(repository),
        farmRoleProvider.overrideWithValue(FarmRoleAccess.owner),
        cacheScopeProvider.overrideWithValue(null),
      ],
    ));
    await _settle(tester);

    expect(find.text('Иван Работник'), findsOneWidget);
  });
}
