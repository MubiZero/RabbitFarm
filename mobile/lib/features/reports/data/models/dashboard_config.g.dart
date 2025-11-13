// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DashboardConfigImpl _$$DashboardConfigImplFromJson(
  Map<String, dynamic> json,
) => _$DashboardConfigImpl(
  widgets:
      (json['widgets'] as List<dynamic>?)
          ?.map((e) => WidgetConfig.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  quickActions:
      (json['quickActions'] as List<dynamic>?)
          ?.map((e) => QuickActionConfig.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$$DashboardConfigImplToJson(
  _$DashboardConfigImpl instance,
) => <String, dynamic>{
  'widgets': instance.widgets,
  'quickActions': instance.quickActions,
};

_$WidgetConfigImpl _$$WidgetConfigImplFromJson(Map<String, dynamic> json) =>
    _$WidgetConfigImpl(
      type: $enumDecode(_$WidgetTypeEnumMap, json['type']),
      isVisible: json['isVisible'] as bool,
      order: (json['order'] as num).toInt(),
    );

Map<String, dynamic> _$$WidgetConfigImplToJson(_$WidgetConfigImpl instance) =>
    <String, dynamic>{
      'type': _$WidgetTypeEnumMap[instance.type]!,
      'isVisible': instance.isVisible,
      'order': instance.order,
    };

const _$WidgetTypeEnumMap = {
  WidgetType.overview: 'overview',
  WidgetType.finance: 'finance',
  WidgetType.health: 'health',
  WidgetType.operations: 'operations',
  WidgetType.resources: 'resources',
};

_$QuickActionConfigImpl _$$QuickActionConfigImplFromJson(
  Map<String, dynamic> json,
) => _$QuickActionConfigImpl(
  type: $enumDecode(_$QuickActionTypeEnumMap, json['type']),
  isVisible: json['isVisible'] as bool,
  order: (json['order'] as num).toInt(),
);

Map<String, dynamic> _$$QuickActionConfigImplToJson(
  _$QuickActionConfigImpl instance,
) => <String, dynamic>{
  'type': _$QuickActionTypeEnumMap[instance.type]!,
  'isVisible': instance.isVisible,
  'order': instance.order,
};

const _$QuickActionTypeEnumMap = {
  QuickActionType.addRabbit: 'addRabbit',
  QuickActionType.addVaccination: 'addVaccination',
  QuickActionType.addFeeding: 'addFeeding',
  QuickActionType.addTask: 'addTask',
  QuickActionType.addBirth: 'addBirth',
  QuickActionType.addTransaction: 'addTransaction',
  QuickActionType.addCage: 'addCage',
  QuickActionType.addBreed: 'addBreed',
  QuickActionType.addMedicalRecord: 'addMedicalRecord',
};
