import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/dashboard_config.dart';

/// Сервис для работы с настройками дашборда
class DashboardConfigService {
  static const String _configKey = 'dashboard_config';

  final SharedPreferences _prefs;

  DashboardConfigService(this._prefs);

  /// Загрузить конфигурацию
  Future<DashboardConfig> loadConfig() async {
    try {
      final String? configJson = _prefs.getString(_configKey);

      if (configJson == null) {
        // Если конфигурации нет, создаем дефолтную
        return DashboardConfig.defaultConfig();
      }

      final Map<String, dynamic> json = jsonDecode(configJson);
      return DashboardConfig.fromJson(json);
    } catch (e) {
      // В случае ошибки возвращаем дефолтную конфигурацию
      return DashboardConfig.defaultConfig();
    }
  }

  /// Сохранить конфигурацию
  Future<void> saveConfig(DashboardConfig config) async {
    final String configJson = jsonEncode(config.toJson());
    await _prefs.setString(_configKey, configJson);
  }

  /// Сбросить к дефолтным настройкам
  Future<void> resetToDefault() async {
    await _prefs.remove(_configKey);
  }

  /// Обновить порядок виджетов
  Future<void> updateWidgetsOrder(List<WidgetConfig> widgets) async {
    final config = await loadConfig();
    final updatedConfig = config.copyWith(widgets: widgets);
    await saveConfig(updatedConfig);
  }

  /// Обновить порядок быстрых действий
  Future<void> updateQuickActionsOrder(List<QuickActionConfig> quickActions) async {
    final config = await loadConfig();
    final updatedConfig = config.copyWith(quickActions: quickActions);
    await saveConfig(updatedConfig);
  }

  /// Переключить видимость виджета
  Future<void> toggleWidgetVisibility(WidgetType type) async {
    final config = await loadConfig();
    final updatedWidgets = config.widgets.map((widget) {
      if (widget.type == type) {
        return widget.copyWith(isVisible: !widget.isVisible);
      }
      return widget;
    }).toList();

    final updatedConfig = config.copyWith(widgets: updatedWidgets);
    await saveConfig(updatedConfig);
  }

  /// Переключить видимость быстрого действия
  Future<void> toggleQuickActionVisibility(QuickActionType type) async {
    final config = await loadConfig();
    final updatedActions = config.quickActions.map((action) {
      if (action.type == type) {
        return action.copyWith(isVisible: !action.isVisible);
      }
      return action;
    }).toList();

    final updatedConfig = config.copyWith(quickActions: updatedActions);
    await saveConfig(updatedConfig);
  }
}
