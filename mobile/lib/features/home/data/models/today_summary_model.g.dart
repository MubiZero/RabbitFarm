// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'today_summary_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TodaySummaryImpl _$$TodaySummaryImplFromJson(Map<String, dynamic> json) =>
    _$TodaySummaryImpl(
      tasks: TasksSummary.fromJson(json['tasks'] as Map<String, dynamic>),
      feeding: FeedingSummary.fromJson(json['feeding'] as Map<String, dynamic>),
      alerts: (json['alerts'] as List<dynamic>)
          .map((e) => Alert.fromJson(e as Map<String, dynamic>))
          .toList(),
      todayTasks: (json['todayTasks'] as List<dynamic>)
          .map((e) => Task.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$TodaySummaryImplToJson(_$TodaySummaryImpl instance) =>
    <String, dynamic>{
      'tasks': instance.tasks,
      'feeding': instance.feeding,
      'alerts': instance.alerts,
      'todayTasks': instance.todayTasks,
    };

_$TasksSummaryImpl _$$TasksSummaryImplFromJson(Map<String, dynamic> json) =>
    _$TasksSummaryImpl(
      totalToday: const IntConverter().fromJson(json['total_today']),
      completedToday: const IntConverter().fromJson(json['completed_today']),
      pendingToday: const IntConverter().fromJson(json['pending_today']),
    );

Map<String, dynamic> _$$TasksSummaryImplToJson(_$TasksSummaryImpl instance) =>
    <String, dynamic>{
      'total_today': const IntConverter().toJson(instance.totalToday),
      'completed_today': const IntConverter().toJson(instance.completedToday),
      'pending_today': const IntConverter().toJson(instance.pendingToday),
    };

_$FeedingSummaryImpl _$$FeedingSummaryImplFromJson(Map<String, dynamic> json) =>
    _$FeedingSummaryImpl(
      countToday: const IntConverter().fromJson(json['count_today']),
    );

Map<String, dynamic> _$$FeedingSummaryImplToJson(
  _$FeedingSummaryImpl instance,
) => <String, dynamic>{
  'count_today': const IntConverter().toJson(instance.countToday),
};

_$AlertImpl _$$AlertImplFromJson(Map<String, dynamic> json) => _$AlertImpl(
  type: $enumDecode(_$AlertTypeEnumMap, json['type']),
  title: json['title'] as String,
  message: json['message'] as String,
  priority: $enumDecode(_$AlertPriorityEnumMap, json['priority']),
  route: json['route'] as String?,
);

Map<String, dynamic> _$$AlertImplToJson(_$AlertImpl instance) =>
    <String, dynamic>{
      'type': _$AlertTypeEnumMap[instance.type]!,
      'title': instance.title,
      'message': instance.message,
      'priority': _$AlertPriorityEnumMap[instance.priority]!,
      'route': instance.route,
    };

const _$AlertTypeEnumMap = {
  AlertType.vaccination: 'vaccination',
  AlertType.birth: 'birth',
  AlertType.feed: 'feed',
  AlertType.health: 'health',
  AlertType.task: 'task',
};

const _$AlertPriorityEnumMap = {
  AlertPriority.low: 'low',
  AlertPriority.medium: 'medium',
  AlertPriority.high: 'high',
  AlertPriority.urgent: 'urgent',
};
