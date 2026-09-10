import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _kActivationChecklistDismissed = 'activation_checklist_dismissed';

/// Скрыл ли человек чек-лист активации вручную («Скрыть»).
///
/// Отдельно от самих трёх шагов: те всегда считаются по настоящим данным
/// фермы (см. `ActivationChecklistCard`), а этот флаг — единственное, что
/// нужно хранить локально.
class ActivationChecklistNotifier extends AsyncNotifier<bool> {
  @override
  Future<bool> build() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_kActivationChecklistDismissed) ?? false;
  }

  Future<void> dismiss() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kActivationChecklistDismissed, true);
    state = const AsyncData(true);
  }
}

final activationChecklistDismissedProvider =
    AsyncNotifierProvider<ActivationChecklistNotifier, bool>(
  ActivationChecklistNotifier.new,
);
