import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/api_providers.dart';
import '../../data/models/task_model.dart';
import '../../data/repositories/tasks_repository.dart';

/// Tasks repository provider
final tasksRepositoryProvider = Provider<TasksRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return TasksRepository(apiClient);
});

/// Tasks list provider (legacy - kept for backward compatibility)
final tasksProvider = FutureProvider.autoDispose.family<
    Map<String, dynamic>,
    TasksQueryParams>((ref, params) async {
  final repository = ref.watch(tasksRepositoryProvider);
  return repository.getTasks(
    page: params.page,
    limit: params.limit,
    sortBy: params.sortBy,
    sortOrder: params.sortOrder,
    type: params.type,
    status: params.status,
    priority: params.priority,
    rabbitId: params.rabbitId,
    cageId: params.cageId,
    assignedTo: params.assignedTo,
    createdBy: params.createdBy,
    fromDate: params.fromDate,
    toDate: params.toDate,
    overdueOnly: params.overdueOnly,
    todayOnly: params.todayOnly,
  );
});

/// Tasks list state for infinite scroll
class TasksListState {
  final List<Task> tasks;
  final bool isLoading;
  final String? error;
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
    String? error,
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
        error: e.toString().replaceAll('Exception: ', ''),
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
        error: e.toString().replaceAll('Exception: ', ''),
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
    // Invalidate tasks list to refresh
    _ref.invalidate(tasksProvider);
    _ref.invalidate(taskStatisticsProvider);
    return result;
  }

  /// Update task
  Future<Task> updateTask(int id, TaskUpdate task) async {
    final result = await _repository.updateTask(id, task);
    // Invalidate related providers
    _ref.invalidate(tasksProvider);
    _ref.invalidate(taskProvider(id));
    _ref.invalidate(taskStatisticsProvider);
    return result;
  }

  /// Delete task
  Future<void> deleteTask(int id) async {
    await _repository.deleteTask(id);
    // Invalidate related providers
    _ref.invalidate(tasksProvider);
    _ref.invalidate(taskStatisticsProvider);
  }

  /// Complete task
  Future<Task> completeTask(int id) async {
    final result = await _repository.completeTask(id);
    // Invalidate related providers
    _ref.invalidate(tasksProvider);
    _ref.invalidate(taskProvider(id));
    _ref.invalidate(taskStatisticsProvider);
    return result;
  }
}

/// Tasks query parameters
class TasksQueryParams {
  final int page;
  final int limit;
  final String? sortBy;
  final String? sortOrder;
  final TaskType? type;
  final TaskStatus? status;
  final TaskPriority? priority;
  final int? rabbitId;
  final int? cageId;
  final int? assignedTo;
  final int? createdBy;
  final String? fromDate;
  final String? toDate;
  final bool? overdueOnly;
  final bool? todayOnly;

  TasksQueryParams({
    this.page = 1,
    this.limit = 10,
    this.sortBy,
    this.sortOrder,
    this.type,
    this.status,
    this.priority,
    this.rabbitId,
    this.cageId,
    this.assignedTo,
    this.createdBy,
    this.fromDate,
    this.toDate,
    this.overdueOnly,
    this.todayOnly,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TasksQueryParams &&
          runtimeType == other.runtimeType &&
          page == other.page &&
          limit == other.limit &&
          sortBy == other.sortBy &&
          sortOrder == other.sortOrder &&
          type == other.type &&
          status == other.status &&
          priority == other.priority &&
          rabbitId == other.rabbitId &&
          cageId == other.cageId &&
          assignedTo == other.assignedTo &&
          createdBy == other.createdBy &&
          fromDate == other.fromDate &&
          toDate == other.toDate &&
          overdueOnly == other.overdueOnly &&
          todayOnly == other.todayOnly;

  @override
  int get hashCode =>
      page.hashCode ^
      limit.hashCode ^
      sortBy.hashCode ^
      sortOrder.hashCode ^
      type.hashCode ^
      status.hashCode ^
      priority.hashCode ^
      rabbitId.hashCode ^
      cageId.hashCode ^
      assignedTo.hashCode ^
      createdBy.hashCode ^
      fromDate.hashCode ^
      toDate.hashCode ^
      overdueOnly.hashCode ^
      todayOnly.hashCode;
}
