import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../tasks/data/models/task_model.dart';

part 'today_summary_model.freezed.dart';
part 'today_summary_model.g.dart';

/// Custom converter for int values
class IntConverter implements JsonConverter<int, dynamic> {
  const IntConverter();

  @override
  int fromJson(dynamic value) {
    if (value is int) return value;
    if (value is String) return int.parse(value);
    throw ArgumentError('Cannot convert $value to int');
  }

  @override
  int toJson(int value) => value;
}

/// Today Summary Model - summary of today's activities
@freezed
class TodaySummary with _$TodaySummary {
  const factory TodaySummary({
    required TasksSummary tasks,
    required FeedingSummary feeding,
    required List<Alert> alerts,
    required List<Task> todayTasks,
  }) = _TodaySummary;

  factory TodaySummary.fromJson(Map<String, dynamic> json) =>
      _$TodaySummaryFromJson(json);
}

/// Tasks summary for today
@freezed
class TasksSummary with _$TasksSummary {
  const factory TasksSummary({
    @JsonKey(name: 'total_today') @IntConverter() required int totalToday,
    @JsonKey(name: 'completed_today') @IntConverter() required int completedToday,
    @JsonKey(name: 'pending_today') @IntConverter() required int pendingToday,
  }) = _TasksSummary;

  factory TasksSummary.fromJson(Map<String, dynamic> json) =>
      _$TasksSummaryFromJson(json);
}

/// Feeding summary for today
@freezed
class FeedingSummary with _$FeedingSummary {
  const factory FeedingSummary({
    @JsonKey(name: 'count_today') @IntConverter() required int countToday,
  }) = _FeedingSummary;

  factory FeedingSummary.fromJson(Map<String, dynamic> json) =>
      _$FeedingSummaryFromJson(json);
}

/// Alert Model
@freezed
class Alert with _$Alert {
  const factory Alert({
    required AlertType type,
    required String title,
    required String message,
    required AlertPriority priority,
    String? route,
  }) = _Alert;

  factory Alert.fromJson(Map<String, dynamic> json) => _$AlertFromJson(json);
}

/// Alert Type
enum AlertType {
  @JsonValue('vaccination')
  vaccination,
  @JsonValue('birth')
  birth,
  @JsonValue('feed')
  feed,
  @JsonValue('health')
  health,
  @JsonValue('task')
  task,
}

/// Alert Priority
enum AlertPriority {
  @JsonValue('low')
  low,
  @JsonValue('medium')
  medium,
  @JsonValue('high')
  high,
  @JsonValue('urgent')
  urgent,
}
