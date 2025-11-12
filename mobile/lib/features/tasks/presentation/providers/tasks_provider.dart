import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/api/api_client.dart';
import '../../data/models/task_model.dart';
import '../../data/repositories/tasks_repository.dart';

/// Tasks repository provider
final tasksRepositoryProvider = Provider<TasksRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return TasksRepository(apiClient);
});

/// Tasks list provider
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
