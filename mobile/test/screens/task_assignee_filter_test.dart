import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mobile/core/access/farm_access.dart';
import 'package:mobile/core/api/api_client.dart';
import 'package:mobile/core/api/paginated.dart';
import 'package:mobile/core/cache/cache_scope.dart';
import 'package:mobile/features/staff/data/models/staff_models.dart';
import 'package:mobile/features/staff/presentation/providers/staff_provider.dart';
import 'package:mobile/features/tasks/data/models/task_model.dart';
import 'package:mobile/features/tasks/data/repositories/tasks_repository.dart';
import 'package:mobile/features/tasks/presentation/providers/tasks_provider.dart';
import 'package:mobile/features/tasks/presentation/screens/tasks_list_screen.dart';

import '../support/test_app.dart';

/// Сервер принимал `assigned_to` в списке задач с самого начала, а приложение
/// его не слало: работник не мог отобрать «только мои», а владелец —
/// посмотреть, что на конкретном человеке. На ферме из пяти работников это
/// означало один общий список на всех.
class _FakeTasksRepository extends TasksRepository {
  _FakeTasksRepository()
      : super(ApiClient(storage: const FlutterSecureStorage()));

  final List<int?> requestedAssignees = [];

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
  }) async {
    requestedAssignees.add(assignedTo);
    return {
      'tasks': <Task>[],
      'pagination': PageInfo(page: page, limit: limit, total: 0, totalPages: 1),
    };
  }
}

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

Future<_FakeTasksRepository> _pump(
  WidgetTester tester, {
  FarmRoleAccess role = FarmRoleAccess.owner,
}) async {
  await tester.binding.setSurfaceSize(const Size(420, 1600));
  addTearDown(() => tester.binding.setSurfaceSize(null));

  final repository = _FakeTasksRepository();
  await tester.pumpWidget(
    testAppScreen(
      const TasksListScreen(),
      overrides: [
        tasksRepositoryProvider.overrideWithValue(repository),
        farmMembersProvider.overrideWith((ref) async => [_owner, _worker]),
        farmRoleProvider.overrideWithValue(role),
        currentUserIdProvider.overrideWithValue(
          role == FarmRoleAccess.owner ? _owner.id : _worker.id,
        ),
        cacheScopeProvider.overrideWithValue(null),
      ],
    ),
  );
  await tester.pumpAndSettle();
  return repository;
}

Future<void> _openFilters(WidgetTester tester) async {
  await tester.tap(find.byIcon(Icons.filter_list));
  await tester.pumpAndSettle();
}

Future<void> _pick(WidgetTester tester, String label) async {
  await tester.tap(find.byType(DropdownButtonFormField<int?>));
  await tester.pumpAndSettle();
  await tester.tap(find.text(label).last);
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('владелец отбирает задачи конкретного работника', (tester) async {
    final repository = await _pump(tester);

    await _openFilters(tester);
    await _pick(tester, 'Иван Работник');
    await tester.tap(find.widgetWithText(FilledButton, 'Применить'));
    await tester.pumpAndSettle();

    // Первый запрос — при открытии экрана, второй — уже с фильтром.
    expect(repository.requestedAssignees.last, _worker.id);
    // Фильтр виден и снимается: чужой фильтр, о котором забыли, читается
    // как «на ферме больше нет задач».
    expect(find.text('Иван Работник'), findsOneWidget);
  });

  testWidgets('работник отбирает свои — и чужих в списке не видит',
      (tester) async {
    final repository = await _pump(tester, role: FarmRoleAccess.worker);

    await _openFilters(tester);
    await tester.tap(find.byType(DropdownButtonFormField<int?>));
    await tester.pumpAndSettle();

    // Состав фермы работнику не показывают — ему и выбирать не из кого,
    // кроме себя.
    expect(find.text('Пётр Владелец'), findsNothing);

    await tester.tap(find.text('Только мои').last);
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Применить'));
    await tester.pumpAndSettle();

    expect(repository.requestedAssignees.last, _worker.id);
    expect(find.text('Мои задачи'), findsOneWidget);
  });
}
