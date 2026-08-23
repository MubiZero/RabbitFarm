import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:mobile/core/access/farm_access.dart';
import 'package:mobile/core/api/api_client.dart';
import 'package:mobile/core/api/api_failure.dart';
import 'package:mobile/features/home/presentation/screens/today_screen.dart';
import 'package:mobile/features/reports/data/models/report_model.dart';
import 'package:mobile/features/reports/presentation/providers/reports_provider.dart';
import 'package:mobile/features/tasks/data/models/task_model.dart';
import 'package:mobile/features/tasks/data/repositories/tasks_repository.dart';
import 'package:mobile/features/tasks/presentation/providers/tasks_provider.dart';

import '../support/test_app.dart';

/// Ферма без единой тревоги: всё срочное в тестах добавляется явно, чтобы было
/// видно, что именно проверяется.
const _calmDashboard = DashboardReport(
  rabbits: RabbitStats(total: 48, male: 12, female: 36),
  cages: CageStats(total: 30, occupied: 22, available: 8),
  health: HealthStats(upcomingVaccinations: 0, overdueVaccinations: 0),
  finance:
      FinanceStats(income30days: 184500, expenses30days: 96200, profit30days: 88300),
  tasks: TaskStats(pending: 7, overdue: 2, urgent: 1),
  inventory: InventoryStats(lowStockFeeds: 0),
  breeding: BreedingStats(recentBirths: 5),
);

Task _task({
  required int id,
  required String title,
  required DateTime dueDate,
}) =>
    Task(
      id: id,
      title: title,
      type: TaskType.feeding,
      status: TaskStatus.pending,
      priority: TaskPriority.high,
      dueDate: dueDate,
    );

DateTime _daysAgo(int days) {
  final now = DateTime.now();
  return DateTime(now.year, now.month, now.day, 9).subtract(Duration(days: days));
}

/// Репозиторий без сети: подменяется целиком, чтобы под тестом оставалась
/// настоящая логика провайдера — и порядок строк, и откат отметки.
class _FakeTasksRepository extends TasksRepository {
  _FakeTasksRepository(this.tasks, {this.completeError})
      : super(ApiClient(storage: const FlutterSecureStorage()));

  final List<Task> tasks;
  final Object? completeError;
  final List<int> completed = [];

  /// Порядок строк на экране задаёт сервер, поэтому запрос тоже под проверкой.
  Map<String, dynamic> lastQuery = const {};

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
    lastQuery = {
      'limit': limit,
      'sortBy': sortBy,
      'sortOrder': sortOrder,
      'status': status,
    };
    return {
      'tasks': tasks.take(limit).toList(),
      'pagination': {'page': 1, 'pages': 1, 'total': tasks.length},
    };
  }

  /// Ответ приходит с задержкой, как от настоящего сервера: без неё отказ
  /// возвращался бы в том же микрозадании, и мгновенную отметку — то самое,
  /// что проверяется, — увидеть было бы нечем.
  @override
  Future<Task> completeTask(int id) async {
    await Future<void>.delayed(const Duration(milliseconds: 50));
    if (completeError != null) throw completeError!;
    completed.add(id);
    return tasks
        .firstWhere((task) => task.id == id)
        .copyWith(status: TaskStatus.completed);
  }
}

/// Репозиторий, который не отдаёт список вовсе.
class _BrokenTasksRepository extends _FakeTasksRepository {
  _BrokenTasksRepository() : super(const []);

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
    throw const ApiFailure(ApiFailureKind.offline);
  }
}

/// Скелетоны пульсируют бесконечно, поэтому `pumpAndSettle` здесь не сходится:
/// ждём ответы провайдеров и доигрываем анимацию вручную. Окно растягиваем —
/// экран длиннее стандартных 800x600, а `ListView` строит только видимое.
Future<void> _settle(WidgetTester tester) async {
  await tester.binding.setSurfaceSize(const Size(420, 2400));
  addTearDown(() => tester.binding.setSurfaceSize(null));
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 400));
}

Widget _wrap({
  DashboardReport dashboard = _calmDashboard,
  TasksRepository? repository,
  FarmRoleAccess role = FarmRoleAccess.owner,
}) =>
    testAppScreen(
      const TodayScreen(),
      overrides: <Override>[
        dashboardReportProvider.overrideWith((ref) async => dashboard),
        tasksRepositoryProvider
            .overrideWithValue(repository ?? _FakeTasksRepository(const [])),
        farmRoleProvider.overrideWithValue(role),
      ],
    );

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await initializeDateFormatting('ru', null);
    await initializeDateFormatting('ru_RU', null);
  });

  setUp(() {
    // Экран сам решает, показывать ли обучение; без подложки настроек
    // SharedPreferences падает, а подсказки перекрыли бы задачи.
    SharedPreferences.setMockInitialValues({'tour_done': true});
  });

  testWidgets('задачи видны строками — просроченные выше сегодняшних',
      (tester) async {
    final repository = _FakeTasksRepository([
      _task(id: 1, title: 'Почистить клетки', dueDate: _daysAgo(2)),
      _task(id: 2, title: 'Раздать корм', dueDate: _daysAgo(0)),
      _task(id: 3, title: 'Взвесить молодняк', dueDate: _daysAgo(-1)),
    ]);

    await tester.pumpWidget(_wrap(repository: repository));
    await _settle(tester);

    expect(find.text('Задачи на сегодня'), findsOneWidget);
    expect(find.text('Почистить клетки'), findsOneWidget);
    expect(find.text('Раздать корм'), findsOneWidget);
    expect(find.text('Просрочена на 2 дня'), findsOneWidget);
    expect(find.textContaining('Сегодня'), findsOneWidget);
    // Завтрашнее — не сегодняшнее: на «Сегодня» ему не место.
    expect(find.text('Взвесить молодняк'), findsNothing);

    // Просроченное — выше сегодняшнего.
    final overdue = tester.getTopLeft(find.text('Почистить клетки')).dy;
    final today = tester.getTopLeft(find.text('Раздать корм')).dy;
    expect(overdue, lessThan(today));

    // Раньше просроченные задачи запрашивались фильтром `overdue_only`,
    // который сервер молча не применяет. Порядок держится на сортировке.
    expect(repository.lastQuery['sortBy'], 'due_date');
    expect(repository.lastQuery['sortOrder'], 'ASC');
    expect(repository.lastQuery['status'], TaskStatus.pending);

    // Карточки-ссылки «Просроченные задачи» больше нет: задачу закрывают здесь.
    expect(find.text('Просроченные задачи'), findsNothing);
    expect(find.text('Все задачи'), findsOneWidget);
  });

  testWidgets('галочка встаёт сразу и с экрана никуда не уводит',
      (tester) async {
    final repository = _FakeTasksRepository([
      _task(id: 1, title: 'Почистить клетки', dueDate: _daysAgo(2)),
    ]);

    await tester.pumpWidget(_wrap(repository: repository));
    await _settle(tester);

    await tester.tap(find.byType(Checkbox));
    // Один кадр, без ожидания ответа сервера: отметка не должна его ждать.
    await tester.pump();

    expect(find.byIcon(Icons.check_circle), findsOneWidget);
    expect(find.byType(Checkbox), findsNothing);
    expect(find.text('Почистить клетки'), findsOneWidget);
    expect(find.text('Задачи на сегодня'), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 400));
    expect(repository.completed, [1]);
  });

  testWidgets('отказ сервера возвращает отметку и объясняет причину',
      (tester) async {
    final repository = _FakeTasksRepository(
      [_task(id: 1, title: 'Почистить клетки', dueDate: _daysAgo(2))],
      completeError: const ApiFailure(
        ApiFailureKind.invalid,
        serverText: 'Задачу уже закрыл другой работник',
      ),
    );

    await tester.pumpWidget(_wrap(repository: repository));
    await _settle(tester);

    await tester.tap(find.byType(Checkbox));
    await tester.pump();
    expect(find.byIcon(Icons.check_circle), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 400));

    expect(find.byType(Checkbox), findsOneWidget);
    expect(find.byIcon(Icons.check_circle), findsNothing);
    expect(find.text('Задачу уже закрыл другой работник'), findsOneWidget);
  });

  testWidgets('работник тоже видит задачи и может их закрыть', (tester) async {
    final repository = _FakeTasksRepository([
      _task(id: 1, title: 'Раздать корм', dueDate: _daysAgo(0)),
    ]);

    await tester.pumpWidget(
      _wrap(repository: repository, role: FarmRoleAccess.worker),
    );
    await _settle(tester);

    expect(find.text('Раздать корм'), findsOneWidget);

    await tester.tap(find.byType(Checkbox));
    await tester.pump(const Duration(milliseconds: 400));

    expect(repository.completed, [1]);
  });

  testWidgets('без задач и тревог говорит, что срочного нет', (tester) async {
    await tester.pumpWidget(_wrap());
    await _settle(tester);

    expect(find.text('Всё под контролем — срочного нет'), findsOneWidget);
    expect(find.text('На сегодня задач нет'), findsNothing);
  });

  testWidgets('пустой список задач не отменяет остальных тревог',
      (tester) async {
    await tester.pumpWidget(_wrap(
      dashboard: _calmDashboard.copyWith(
        health: const HealthStats(upcomingVaccinations: 0, overdueVaccinations: 3),
      ),
    ));
    await _settle(tester);

    expect(find.text('На сегодня задач нет'), findsOneWidget);
    expect(find.text('Вакцинация просрочена'), findsOneWidget);
    // «Всё под контролем» рядом с просроченной вакцинацией — неправда.
    expect(find.text('Всё под контролем — срочного нет'), findsNothing);
  });

  testWidgets('сбой загрузки задач не уносит остальной экран', (tester) async {
    await tester.pumpWidget(_wrap(repository: _BrokenTasksRepository()));
    await _settle(tester);

    expect(find.text('Нет связи — проверьте интернет'), findsOneWidget);
    expect(find.text('Ещё раз'), findsOneWidget);
    // Сводка по ферме грузится отдельно и остаётся на месте.
    expect(find.text('Ферма сейчас'), findsOneWidget);
    expect(find.text('48'), findsOneWidget);
  });

  testWidgets('«Ферма сейчас» — три плитки без денег за 30 дней',
      (tester) async {
    await tester.pumpWidget(_wrap());
    await _settle(tester);

    expect(find.text('Поголовье'), findsOneWidget);
    expect(find.text('Клеток свободно'), findsOneWidget);
    expect(find.text('Задачи в работе'), findsOneWidget);

    // Доход и расход за 30 дней — это отчёт, а не «сегодня».
    expect(find.text('За 30 дней'), findsNothing);
    expect(find.text('Доход'), findsNothing);
    expect(find.text('Расход'), findsNothing);
    expect(find.text('Родилось'), findsNothing);
  });
}
