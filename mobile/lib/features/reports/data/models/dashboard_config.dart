import 'package:freezed_annotation/freezed_annotation.dart';

part 'dashboard_config.freezed.dart';
part 'dashboard_config.g.dart';

/// Конфигурация дашборда
@freezed
class DashboardConfig with _$DashboardConfig {
  const factory DashboardConfig({
    @Default([]) List<WidgetConfig> widgets,
    @Default([]) List<QuickActionConfig> quickActions,
  }) = _DashboardConfig;

  factory DashboardConfig.fromJson(Map<String, dynamic> json) =>
      _$DashboardConfigFromJson(json);

  /// Дефолтная конфигурация
  factory DashboardConfig.defaultConfig() {
    return DashboardConfig(
      widgets: [
        const WidgetConfig(type: WidgetType.overview, isVisible: true, order: 0),
        const WidgetConfig(type: WidgetType.finance, isVisible: true, order: 1),
        const WidgetConfig(type: WidgetType.health, isVisible: true, order: 2),
        const WidgetConfig(type: WidgetType.operations, isVisible: true, order: 3),
        const WidgetConfig(type: WidgetType.resources, isVisible: true, order: 4),
      ],
      quickActions: [
        const QuickActionConfig(type: QuickActionType.addRabbit, isVisible: true, order: 0),
        const QuickActionConfig(type: QuickActionType.addVaccination, isVisible: true, order: 1),
        const QuickActionConfig(type: QuickActionType.addFeeding, isVisible: true, order: 2),
        const QuickActionConfig(type: QuickActionType.addTask, isVisible: true, order: 3),
        const QuickActionConfig(type: QuickActionType.addBirth, isVisible: true, order: 4),
        const QuickActionConfig(type: QuickActionType.addTransaction, isVisible: true, order: 5),
        const QuickActionConfig(type: QuickActionType.addCage, isVisible: false, order: 6),
        const QuickActionConfig(type: QuickActionType.addBreed, isVisible: false, order: 7),
        const QuickActionConfig(type: QuickActionType.addMedicalRecord, isVisible: false, order: 8),
      ],
    );
  }
}

/// Конфигурация виджета
@freezed
class WidgetConfig with _$WidgetConfig {
  const factory WidgetConfig({
    required WidgetType type,
    required bool isVisible,
    required int order,
  }) = _WidgetConfig;

  factory WidgetConfig.fromJson(Map<String, dynamic> json) =>
      _$WidgetConfigFromJson(json);
}

/// Типы виджетов дашборда
enum WidgetType {
  @JsonValue('overview')
  overview,
  @JsonValue('finance')
  finance,
  @JsonValue('health')
  health,
  @JsonValue('operations')
  operations,
  @JsonValue('resources')
  resources,
}

/// Конфигурация быстрого действия
@freezed
class QuickActionConfig with _$QuickActionConfig {
  const factory QuickActionConfig({
    required QuickActionType type,
    required bool isVisible,
    required int order,
  }) = _QuickActionConfig;

  factory QuickActionConfig.fromJson(Map<String, dynamic> json) =>
      _$QuickActionConfigFromJson(json);
}

/// Типы быстрых действий
enum QuickActionType {
  @JsonValue('addRabbit')
  addRabbit,
  @JsonValue('addVaccination')
  addVaccination,
  @JsonValue('addFeeding')
  addFeeding,
  @JsonValue('addTask')
  addTask,
  @JsonValue('addBirth')
  addBirth,
  @JsonValue('addTransaction')
  addTransaction,
  @JsonValue('addCage')
  addCage,
  @JsonValue('addBreed')
  addBreed,
  @JsonValue('addMedicalRecord')
  addMedicalRecord,
}

/// Расширение для получения информации о типах виджетов
extension WidgetTypeExtension on WidgetType {
  String get title {
    switch (this) {
      case WidgetType.overview:
        return 'Обзор фермы';
      case WidgetType.finance:
        return 'Финансы';
      case WidgetType.health:
        return 'Здоровье';
      case WidgetType.operations:
        return 'Операции';
      case WidgetType.resources:
        return 'Ресурсы';
    }
  }

  String get description {
    switch (this) {
      case WidgetType.overview:
        return 'Кролики, клетки, рождения';
      case WidgetType.finance:
        return 'Доходы, расходы, прибыль';
      case WidgetType.health:
        return 'Вакцинации и здоровье';
      case WidgetType.operations:
        return 'Задачи и операции';
      case WidgetType.resources:
        return 'Инвентарь и корма';
    }
  }
}

/// Расширение для получения информации о быстрых действиях
extension QuickActionTypeExtension on QuickActionType {
  String get title {
    switch (this) {
      case QuickActionType.addRabbit:
        return 'Добавить кролика';
      case QuickActionType.addVaccination:
        return 'Записать вакцинацию';
      case QuickActionType.addFeeding:
        return 'Записать кормление';
      case QuickActionType.addTask:
        return 'Создать задачу';
      case QuickActionType.addBirth:
        return 'Записать рождение';
      case QuickActionType.addTransaction:
        return 'Добавить транзакцию';
      case QuickActionType.addCage:
        return 'Добавить клетку';
      case QuickActionType.addBreed:
        return 'Добавить породу';
      case QuickActionType.addMedicalRecord:
        return 'Добавить запись о здоровье';
    }
  }

  String get route {
    switch (this) {
      case QuickActionType.addRabbit:
        return '/rabbits/new';
      case QuickActionType.addVaccination:
        return '/vaccinations/form';
      case QuickActionType.addFeeding:
        return '/feeding-records/form';
      case QuickActionType.addTask:
        return '/tasks/form';
      case QuickActionType.addBirth:
        return '/births/new';
      case QuickActionType.addTransaction:
        return '/transactions/form';
      case QuickActionType.addCage:
        return '/cages/form';
      case QuickActionType.addBreed:
        return '/breeds/form';
      case QuickActionType.addMedicalRecord:
        return '/medical-records/form';
    }
  }
}
