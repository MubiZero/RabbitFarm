import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _kQuickEntryUsage = 'quick_entry_usage';

/// Сколько выборов нужно, чтобы говорить о привычке.
///
/// До этого порога «Часто» не показывается вовсе: поднять наверх пункт,
/// нажатый однажды, — это не помощь, а перестановка списка под человеком,
/// который ещё не успел ничего запомнить.
const _minTotalPicks = 5;

/// Сколько раз должен быть выбран сам пункт, чтобы попасть наверх.
const _minPicksPerAction = 2;

/// Больше трёх пунктов наверху — это уже второй список, а не подсказка.
const _maxFrequent = 3;

/// Пункты, которые человек выбирает чаще всего, от частого к редкому.
List<String> frequentRoutes(Map<String, int> picks) {
  final total = picks.values.fold(0, (sum, count) => sum + count);
  if (total < _minTotalPicks) return const [];

  final routes = picks.entries
      .where((entry) => entry.value >= _minPicksPerAction)
      .toList()
    ..sort((a, b) => b.value.compareTo(a.value));

  return [for (final entry in routes.take(_maxFrequent)) entry.key];
}

/// Что человек записывает чаще всего.
///
/// В словаре записей одиннадцать пунктов, а в ходу на каждой ферме два-три:
/// кто-то каждый день отмечает кормление, кто-то — задачи. Счётчик живёт на
/// устройстве: это привычка конкретного человека за конкретным телефоном, и
/// серверу о ней знать незачем.
class QuickEntryUsageNotifier extends AsyncNotifier<Map<String, int>> {
  @override
  Future<Map<String, int>> build() async {
    final prefs = await SharedPreferences.getInstance();
    return _decode(prefs.getStringList(_kQuickEntryUsage));
  }

  Future<void> record(String route) async {
    final picks = Map<String, int>.from(state.value ?? const {});
    picks[route] = (picks[route] ?? 0) + 1;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_kQuickEntryUsage, _encode(picks));
    state = AsyncData(picks);
  }

  /// Счётчик хранится строками «маршрут пробел число»: карту в настройках
  /// не сохранить, а заводить ради четырёх цифр базу данных незачем.
  /// Испорченная строка просто пропускается — потерянный счётчик не повод
  /// ронять лист записей.
  static Map<String, int> _decode(List<String>? raw) {
    final picks = <String, int>{};
    for (final line in raw ?? const <String>[]) {
      final separator = line.lastIndexOf(' ');
      if (separator <= 0) continue;
      final count = int.tryParse(line.substring(separator + 1));
      if (count == null || count <= 0) continue;
      picks[line.substring(0, separator)] = count;
    }
    return picks;
  }

  static List<String> _encode(Map<String, int> picks) =>
      [for (final entry in picks.entries) '${entry.key} ${entry.value}'];
}

final quickEntryUsageProvider =
    AsyncNotifierProvider<QuickEntryUsageNotifier, Map<String, int>>(
  QuickEntryUsageNotifier.new,
);
