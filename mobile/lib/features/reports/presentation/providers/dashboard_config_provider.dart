import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/models/dashboard_config.dart';
import '../../data/services/dashboard_config_service.dart';

/// Provider для SharedPreferences
final sharedPreferencesProvider = FutureProvider<SharedPreferences>((ref) async {
  return await SharedPreferences.getInstance();
});

/// Provider для сервиса настроек дашборда
final dashboardConfigServiceProvider = FutureProvider<DashboardConfigService>((ref) async {
  final prefs = await ref.watch(sharedPreferencesProvider.future);
  return DashboardConfigService(prefs);
});

/// Provider для конфигурации дашборда
final dashboardConfigProvider =
    StateNotifierProvider<DashboardConfigNotifier, AsyncValue<DashboardConfig>>(
  (ref) => DashboardConfigNotifier(ref),
);

/// Notifier для управления конфигурацией дашборда
class DashboardConfigNotifier extends StateNotifier<AsyncValue<DashboardConfig>> {
  final Ref _ref;

  DashboardConfigNotifier(this._ref) : super(const AsyncValue.loading()) {
    _loadConfig();
  }

  Future<DashboardConfigService> get _service async =>
      await _ref.read(dashboardConfigServiceProvider.future);

  /// Загрузить конфигурацию
  Future<void> _loadConfig() async {
    state = const AsyncValue.loading();
    try {
      final service = await _service;
      final config = await service.loadConfig();
      state = AsyncValue.data(config);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  /// Обновить конфигурацию
  Future<void> updateConfig(DashboardConfig config) async {
    state = const AsyncValue.loading();
    try {
      final service = await _service;
      await service.saveConfig(config);
      state = AsyncValue.data(config);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  /// Обновить порядок виджетов
  Future<void> updateWidgetsOrder(List<WidgetConfig> widgets) async {
    await state.whenData((config) async {
      // Обновляем order для каждого виджета
      final updatedWidgets = widgets.asMap().entries.map((entry) {
        return entry.value.copyWith(order: entry.key);
      }).toList();

      final updatedConfig = config.copyWith(widgets: updatedWidgets);
      await updateConfig(updatedConfig);
    });
  }

  /// Обновить порядок быстрых действий
  Future<void> updateQuickActionsOrder(List<QuickActionConfig> quickActions) async {
    await state.whenData((config) async {
      // Обновляем order для каждого действия
      final updatedActions = quickActions.asMap().entries.map((entry) {
        return entry.value.copyWith(order: entry.key);
      }).toList();

      final updatedConfig = config.copyWith(quickActions: updatedActions);
      await updateConfig(updatedConfig);
    });
  }

  /// Переключить видимость виджета
  Future<void> toggleWidgetVisibility(WidgetType type) async {
    await state.whenData((config) async {
      final updatedWidgets = config.widgets.map((widget) {
        if (widget.type == type) {
          return widget.copyWith(isVisible: !widget.isVisible);
        }
        return widget;
      }).toList();

      final updatedConfig = config.copyWith(widgets: updatedWidgets);
      await updateConfig(updatedConfig);
    });
  }

  /// Переключить видимость быстрого действия
  Future<void> toggleQuickActionVisibility(QuickActionType type) async {
    await state.whenData((config) async {
      final updatedActions = config.quickActions.map((action) {
        if (action.type == type) {
          return action.copyWith(isVisible: !action.isVisible);
        }
        return action;
      }).toList();

      final updatedConfig = config.copyWith(quickActions: updatedActions);
      await updateConfig(updatedConfig);
    });
  }

  /// Сбросить к дефолтным настройкам
  Future<void> resetToDefault() async {
    state = const AsyncValue.loading();
    try {
      final service = await _service;
      await service.resetToDefault();
      final config = await service.loadConfig();
      state = AsyncValue.data(config);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  /// Перезагрузить конфигурацию
  Future<void> reload() async {
    await _loadConfig();
  }
}
