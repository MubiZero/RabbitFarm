import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// Последний удачный ответ списка, сохранённый на диск.
///
/// Приложение работает только по сети, и до этого любой список жил ровно
/// столько, сколько открыто приложение: в сарае без связи после перезапуска
/// поголовье, клетки и задачи показывали пустой экран с кнопкой «Повторить» —
/// хотя эти же данные человек видел час назад.
///
/// Здесь на диске лежит только последняя первая страница каждого списка. Это
/// кэш чтения, а не офлайн-режим: записи в офлайне по-прежнему нет, а
/// показанный из кэша список честно помечается полосой «данные устарели»
/// (`StaleDataBanner`), как только обновление не удалось.
///
/// Каждый список кэшируется независимо, по своему ящику и своему ключу: между
/// ними нет ни общей отметки времени, ни синхронизации — клетки, приехавшие
/// вчера, не делают вчерашним список задач.
class ListCacheBoxes {
  const ListCacheBoxes._();

  static const rabbits = 'cached_rabbits';
  static const cages = 'cached_cages';
  static const tasks = 'cached_tasks';

  /// Всё, что чистится при смене пользователя. Список задан явно, а не
  /// собирается из созданных [ListCache]: они создаются лениво, и к моменту
  /// выхода часть ящиков могла ни разу не понадобиться — а чистить их всё
  /// равно нужно.
  static const all = [rabbits, cages, tasks];
}

/// Подготовить хранилище. Вызывается один раз на старте приложения.
Future<void> initListCache() => Hive.initFlutter();

/// Забыть кэш всех списков.
///
/// Вызывается вместе со сбросом состояния сессии: на общем планшете фермы
/// следующий вошедший не должен увидеть чужое поголовье — ни из памяти, ни
/// тем более с диска, где оно пережило бы и перезапуск.
Future<void> clearListCaches() async {
  for (final name in ListCacheBoxes.all) {
    try {
      await Hive.deleteBoxFromDisk(name);
    } catch (e) {
      debugPrint('ListCache: не удалось очистить $name: $e');
    }
  }
}

/// Кэш одного списка.
///
/// [scope] — чей это список. Ключ владельца обязателен: кэш переживает
/// перезапуск, и без разделения по пользователю следующий вошедший на том же
/// устройстве открыл бы чужие данные ещё до первого запроса. `null` означает
/// «владелец неизвестен» — тогда кэш просто не работает, ни на чтение, ни на
/// запись.
class ListCache<T> {
  const ListCache({
    required this.boxName,
    required this.fromJson,
    required this.toJson,
  });

  final String boxName;
  final T Function(Map<String, dynamic> json) fromJson;
  final Map<String, dynamic> Function(T item) toJson;

  /// Сколько записей имеет смысл держать. Кэшируется первая страница списка —
  /// это то, что человек увидит при открытии экрана; хранить всё поголовье
  /// целиком незачем, а на большой ферме ещё и дорого.
  static const _maxItems = 100;

  Future<List<T>> read(String? scope) async {
    if (scope == null) return const [];

    try {
      final box = await _box();
      final raw = box.get(scope);
      if (raw == null) return const [];

      final decoded = jsonDecode(raw) as List<dynamic>;
      return [
        for (final item in decoded) fromJson(item as Map<String, dynamic>),
      ];
    } catch (e) {
      // Обычно это значит, что модель поменялась после обновления приложения:
      // разобрать прошлый ответ уже нечем. Испорченную запись выбрасываем —
      // иначе она будет падать при каждом открытии экрана.
      debugPrint('ListCache: кэш $boxName не прочитан, сбрасываю: $e');
      await _forget(scope);
      return const [];
    }
  }

  Future<void> write(String? scope, List<T> items) async {
    if (scope == null) return;

    try {
      final box = await _box();
      final head = items.length > _maxItems ? items.sublist(0, _maxItems) : items;
      await box.put(scope, jsonEncode([for (final item in head) toJson(item)]));
    } catch (e) {
      // Кэш — удобство, а не обязательство: не сохранился, значит в следующий
      // раз экран просто сходит на сервер, как раньше.
      debugPrint('ListCache: кэш $boxName не сохранён: $e');
    }
  }

  Future<void> _forget(String scope) async {
    try {
      final box = await _box();
      await box.delete(scope);
    } catch (_) {
      // Ящик не открылся — стирать нечего.
    }
  }

  Future<Box<String>> _box() async {
    if (Hive.isBoxOpen(boxName)) return Hive.box<String>(boxName);
    return Hive.openBox<String>(boxName);
  }
}
