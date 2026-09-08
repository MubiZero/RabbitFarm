import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../../../core/providers/session.dart';
import '../../../../core/providers/api_providers.dart';
import '../../data/models/task_model.dart';
import '../../data/repositories/tasks_repository.dart';

/// Tasks repository provider
final tasksRepositoryProvider = Provider<TasksRepository>((ref) {
  ref.watch(sessionRevisionProvider);
  final apiClient = ref.watch(apiClientProvider);
  return TasksRepository(apiClient);
});

/// Tasks list state for infinite scroll
class TasksListState {
  final List<Task> tasks;
  final bool isLoading;
  final Object? error;
  final int currentPage;
  final int totalPages;
  final int total;
  final bool hasMore;
  final TaskType? typeFilter;
  final TaskStatus? statusFilter;
  final TaskPriority? priorityFilter;
  final bool overdueOnly;
  final bool todayOnly;

  TasksListState({
    this.tasks = const [],
    this.isLoading = false,
    this.error,
    this.currentPage = 1,
    this.totalPages = 1,
    this.total = 0,
    this.hasMore = false,
    this.typeFilter,
    this.statusFilter,
    this.priorityFilter,
    this.overdueOnly = false,
    this.todayOnly = false,
  });

  TasksListState copyWith({
    List<Task>? tasks,
    bool? isLoading,
    Object? error,
    int? currentPage,
    int? totalPages,
    int? total,
    bool? hasMore,
    TaskType? typeFilter,
    bool clearTypeFilter = false,
    TaskStatus? statusFilter,
    bool clearStatusFilter = false,
    TaskPriority? priorityFilter,
    bool clearPriorityFilter = false,
    bool? overdueOnly,
    bool? todayOnly,
  }) {
    return TasksListState(
      tasks: tasks ?? this.tasks,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      total: total ?? this.total,
      hasMore: hasMore ?? this.hasMore,
      typeFilter: clearTypeFilter ? null : (typeFilter ?? this.typeFilter),
      statusFilter: clearStatusFilter ? null : (statusFilter ?? this.statusFilter),
      priorityFilter: clearPriorityFilter ? null : (priorityFilter ?? this.priorityFilter),
      overdueOnly: overdueOnly ?? this.overdueOnly,
      todayOnly: todayOnly ?? this.todayOnly,
    );
  }
}

/// Tasks list notifier with infinite scroll support
class TasksListNotifier extends StateNotifier<TasksListState> {
  final TasksRepository _repository;

  TasksListNotifier(this._repository) : super(TasksListState()) {
    loadTasks();
  }

  /// Load tasks (first page or refresh)
  Future<void> loadTasks() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final result = await _repository.getTasks(
        page: 1,
        limit: 20,
        sortBy: 'due_date',
        sortOrder: 'ASC',
        type: state.typeFilter,
        status: state.statusFilter,
        priority: state.priorityFilter,
        overdueOnly: state.overdueOnly ? true : null,
        todayOnly: state.todayOnly ? true : null,
      );

      final tasks = result['tasks'] as List<Task>;
      final pagination = result['pagination'] as Map<String, dynamic>;
      final page = pagination['page'] as int;
      final totalPages = pagination['pages'] as int;
      final total = pagination['total'] as int? ?? 0;

      state = state.copyWith(
        tasks: tasks,
        isLoading: false,
        currentPage: page,
        totalPages: totalPages,
        total: total,
        hasMore: page < totalPages,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e,
      );
    }
  }

  /// Load more tasks (next page)
  Future<void> loadMore() async {
    if (state.isLoading || !state.hasMore) return;

    state = state.copyWith(isLoading: true);

    try {
      final result = await _repository.getTasks(
        page: state.currentPage + 1,
        limit: 20,
        sortBy: 'due_date',
        sortOrder: 'ASC',
        type: state.typeFilter,
        status: state.statusFilter,
        priority: state.priorityFilter,
        overdueOnly: state.overdueOnly ? true : null,
        todayOnly: state.todayOnly ? true : null,
      );

      final tasks = result['tasks'] as List<Task>;
      final pagination = result['pagination'] as Map<String, dynamic>;
      final page = pagination['page'] as int;
      final totalPages = pagination['pages'] as int;
      final total = pagination['total'] as int? ?? 0;

      state = state.copyWith(
        tasks: [...state.tasks, ...tasks],
        isLoading: false,
        currentPage: page,
        totalPages: totalPages,
        total: total,
        hasMore: page < totalPages,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e,
      );
    }
  }

  /// Refresh (reload from first page)
  Future<void> refresh() async {
    await loadTasks();
  }

  /// Update filters and reload
  void setFilters({
    TaskType? type,
    bool clearType = false,
    TaskStatus? status,
    bool clearStatus = false,
    TaskPriority? priority,
    bool clearPriority = false,
    bool? overdueOnly,
    bool? todayOnly,
  }) {
    state = state.copyWith(
      typeFilter: type,
      clearTypeFilter: clearType,
      statusFilter: status,
      clearStatusFilter: clearStatus,
      priorityFilter: priority,
      clearPriorityFilter: clearPriority,
      overdueOnly: overdueOnly,
      todayOnly: todayOnly,
    );
    loadTasks();
  }

  /// Clear all filters and reload
  void clearFilters() {
    state = state.copyWith(
      clearTypeFilter: true,
      clearStatusFilter: true,
      clearPriorityFilter: true,
      overdueOnly: false,
      todayOnly: false,
    );
    loadTasks();
  }

  /// Clear error
  void clearError() {
    state = state.copyWith(error: null);
  }
}

/// Tasks list provider with infinite scroll
final tasksListProvider =
    StateNotifierProvider<TasksListNotifier, TasksListState>((ref) {
  final repository = ref.watch(tasksRepositoryProvider);
  return TasksListNotifier(repository);
});

/// Single task provider
final taskProvider =
    FutureProvider.autoDispose.family<Task, int>((ref, id) async {
  final repository = ref.watch(tasksRepositoryProvider);
  return repository.getTaskById(id);
});

/// Task statistics provider
final taskStatisticsProvider =
    FutureProvider.autoDispose<TaskStatistics>((ref) async {
  final repository = ref.watch(tasksRepositoryProvider);
  return repository.getStatistics();
});

/// Upcoming tasks provider
final upcomingTasksProvider =
    FutureProvider.autoDispose.family<List<Task>, int>((ref, days) async {
  final repository = ref.watch(tasksRepositoryProvider);
  return repository.getUpcoming(days: days);
});

/// Task actions provider
final taskActionsProvider = Provider<TaskActions>((ref) {
  final repository = ref.watch(tasksRepositoryProvider);
  return TaskActions(repository, ref);
});

/// Task actions class
class TaskActions {
  final TasksRepository _repository;
  final Ref _ref;

  TaskActions(this._repository, this._ref);

  /// Create task
  Future<Task> createTask(TaskCreate task) async {
    final result = await _repository.createTask(task);
    // Обновляем именно тот список, который показан на экране: раньше
    // инвалидировался провайдер, который никто не читает, и созданная задача
    // не появлялась, пока приложение не перезапустят.
    await _ref.read(tasksListProvider.notifier).refresh();
    _ref.invalidate(taskStatisticsProvider);
    return result;
  }

  /// Update task
  Future<Task> updateTask(int id, TaskUpdate task) async {
    final result = await _repository.updateTask(id, task);
    await _ref.read(tasksListProvider.notifier).refresh();
    _ref.invalidate(taskProvider(id));
    _ref.invalidate(taskStatisticsProvider);
    return result;
  }

  /// Delete task
  Future<void> deleteTask(int id) async {
    await _repository.deleteTask(id);
    await _ref.read(tasksListProvider.notifier).refresh();
    _ref.invalidate(taskStatisticsProvider);
  }

  /// Complete task
  Future<Task> completeTask(int id) async {
    final result = await _repository.completeTask(id);
    await _ref.read(tasksListProvider.notifier).refresh();
    _ref.invalidate(taskProvider(id));
    _ref.invalidate(taskStatisticsProvider);
    return result;
  }
}


/// Задачи, которые горят сегодня: просроченные и сегодняшние, ранние сверху.
///
/// Живёт отдельно от постраничного [tasksListProvider]: тот принадлежит экрану
/// со своими фильтрами, и перезагружать его ради одной галочки на «Сегодня»
/// означало бы сбрасывать то, что человек там настроил.
class TodayTasksNotifier extends AsyncNotifier<List<Task>> {
  /// Столько строк помещается на «Сегодня», не оттесняя сводку по ферме за
  /// нижний край. Остальное — по ссылке «Все задачи».
  static const _limit = 5;

  /// Экран могли закрыть, пока шёл запрос: возвращать строку на место уже
  /// некуда, а попытка тронуть выброшенное состояние ломается сама.
  var _disposed = false;

  @override
  Future<List<Task>> build() async {
    _disposed = false;
    ref.onDispose(() => _disposed = true);

    // Фильтры по сроку не просим: `to_date` без `from_date` сервер отклоняет,
    // а `overdue_only`/`today_only` он сейчас не применяет вовсе. Сортировка
    // по сроку по возрастанию и так ставит просроченные и сегодняшние первыми,
    // остаётся отсечь будущее.
    final result = await ref.watch(tasksRepositoryProvider).getTasks(
          page: 1,
          limit: _limit,
          sortBy: 'due_date',
          sortOrder: 'ASC',
          status: TaskStatus.pending,
        );

    final endOfToday = _endOfToday();
    return [
      for (final task in result['tasks'] as List<Task>)
        if (!task.dueDate.isAfter(endOfToday)) task,
    ];
  }

  /// Закрыть задачу.
  ///
  /// Галочка встаёт до ответа сервера: в сарае с одной палкой связи полсекунды
  /// ожидания читаются как «не нажалось», и задачу отмечают второй раз. Отказ
  /// возвращает в прежний вид только эту строку — соседние отметки, сделанные
  /// пока шёл запрос, откатывать нельзя.
  Future<void> complete(int id) async {
    final before = state.value;
    if (before == null) return;

    final index = before.indexWhere((task) => task.id == id);
    if (index < 0) return;
    final original = before[index];

    state = AsyncData(_replace(
      before,
      original.copyWith(
        status: TaskStatus.completed,
        completedAt: DateTime.now(),
      ),
    ));

    try {
      await ref.read(tasksRepositoryProvider).completeTask(id);
    } catch (_) {
      if (!_disposed) {
        state = AsyncData(_replace(state.value ?? before, original));
      }
      rethrow;
    }
  }

  List<Task> _replace(List<Task> tasks, Task task) =>
      [for (final item in tasks) item.id == task.id ? task : item];

  static DateTime _endOfToday() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day, 23, 59, 59, 999);
  }
}

/// Задачи для экрана «Сегодня».
final todayTasksProvider =
    AsyncNotifierProvider.autoDispose<TodayTasksNotifier, List<Task>>(
        TodayTasksNotifier.new);
