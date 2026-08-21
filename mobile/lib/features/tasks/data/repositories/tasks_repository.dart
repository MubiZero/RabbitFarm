import '../../../../core/api/paginated.dart';
import '../../../../core/api/api_error.dart';
import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_endpoints.dart';
import '../models/task_model.dart';

/// Tasks repository
class TasksRepository {
  final ApiClient _apiClient;

  TasksRepository(this._apiClient);

  /// Get list of tasks with filters
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
    return guardRequest(() async {
      final queryParams = <String, dynamic>{
        'page': page,
        'limit': limit,
        if (sortBy != null) 'sort_by': sortBy,
        if (sortOrder != null) 'sort_order': sortOrder,
        if (type != null) 'type': _taskTypeToString(type),
        if (status != null) 'status': _taskStatusToString(status),
        if (priority != null) 'priority': _taskPriorityToString(priority),
        if (rabbitId != null) 'rabbit_id': rabbitId,
        if (cageId != null) 'cage_id': cageId,
        if (assignedTo != null) 'assigned_to': assignedTo,
        if (createdBy != null) 'created_by': createdBy,
        if (fromDate != null) 'from_date': fromDate,
        if (toDate != null) 'to_date': toDate,
        if (overdueOnly != null) 'overdue_only': overdueOnly,
        if (todayOnly != null) 'today_only': todayOnly,
      };

      final response = await _apiClient.get(
        ApiEndpoints.tasks,
        queryParameters: queryParams,
      );

      final data = response.data['data'];
      final tasks = itemsOf(
        data,
      ).map((json) => Task.fromJson(json as Map<String, dynamic>)).toList();

      return {
        'tasks': tasks,
        'pagination': data is Map ? data['pagination'] : null,
      };
    }, 'Не удалось загрузить задачи');
  }

  /// Get task by ID
  Future<Task> getTaskById(int id) async {
    return guardRequest(() async {
      final response = await _apiClient.get('${ApiEndpoints.tasks}/$id');
      return Task.fromJson(response.data['data']);
    }, 'Не удалось загрузить задачу');
  }

  /// Create task
  Future<Task> createTask(TaskCreate task) async {
    return guardRequest(() async {
      final response = await _apiClient.post(
        ApiEndpoints.tasks,
        data: task.toJson(),
      );
      return Task.fromJson(response.data['data']);
    }, 'Не удалось создать задачу');
  }

  /// Update task
  Future<Task> updateTask(int id, TaskUpdate task) async {
    return guardRequest(() async {
      final response = await _apiClient.put(
        '${ApiEndpoints.tasks}/$id',
        data: task.toJson(),
      );
      return Task.fromJson(response.data['data']);
    }, 'Не удалось обновить задачу');
  }

  /// Delete task
  Future<void> deleteTask(int id) async {
    return guardRequest(() async {
      await _apiClient.delete('${ApiEndpoints.tasks}/$id');
    }, 'Не удалось удалить задачу');
  }

  /// Get task statistics
  Future<TaskStatistics> getStatistics() async {
    return guardRequest(() async {
      final response = await _apiClient.get(ApiEndpoints.taskStatistics);
      return TaskStatistics.fromJson(response.data['data']);
    }, 'Не удалось загрузить статистику задач');
  }

  /// Get upcoming tasks
  Future<List<Task>> getUpcoming({int days = 7}) async {
    return guardRequest(() async {
      final response = await _apiClient.get(
        ApiEndpoints.tasksUpcoming,
        queryParameters: {'days': days},
      );
      return (response.data['data'] as List)
          .map((json) => Task.fromJson(json))
          .toList();
    }, 'Не удалось загрузить ближайшие задачи');
  }

  /// Complete task
  Future<Task> completeTask(int id) async {
    return guardRequest(() async {
      final response = await _apiClient.post(
        '${ApiEndpoints.tasks}/$id/complete',
      );
      return Task.fromJson(response.data['data']);
    }, 'Не удалось отметить задачу выполненной');
  }

  // Helper methods to convert enums to strings
  String _taskTypeToString(TaskType type) {
    switch (type) {
      case TaskType.feeding:
        return 'feeding';
      case TaskType.cleaning:
        return 'cleaning';
      case TaskType.vaccination:
        return 'vaccination';
      case TaskType.checkup:
        return 'checkup';
      case TaskType.breeding:
        return 'breeding';
      case TaskType.other:
        return 'other';
    }
  }

  String _taskStatusToString(TaskStatus status) {
    switch (status) {
      case TaskStatus.pending:
        return 'pending';
      case TaskStatus.inProgress:
        return 'in_progress';
      case TaskStatus.completed:
        return 'completed';
      case TaskStatus.cancelled:
        return 'cancelled';
    }
  }

  String _taskPriorityToString(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.low:
        return 'low';
      case TaskPriority.medium:
        return 'medium';
      case TaskPriority.high:
        return 'high';
      case TaskPriority.urgent:
        return 'urgent';
    }
  }
}
