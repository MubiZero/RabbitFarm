import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../api/api_failure.dart';
import '../cache/cache_scope.dart';
import '../cache/list_cache.dart';
import '../error/error_handling.dart';
import '../providers/connectivity.dart';
import '../providers/session.dart';
import '../../features/feeding/presentation/providers/feeding_records_provider.dart';
import '../../features/feeding/presentation/providers/feeds_provider.dart';
import '../../features/home/presentation/providers/journal_provider.dart';
import '../../features/notes/data/models/note_model.dart';
import '../../features/notes/presentation/providers/notes_provider.dart';
import '../../features/tasks/presentation/providers/tasks_provider.dart';

/// Действие из `FarmCapability.recordDailyWork`, отложенное до появления сети.
///
/// Кормление, отметка задачи и заметка — операции добавления: одна ферма,
/// низкий риск конфликта. Поэтому и разрешение при повторной отправке
/// простое — запись уходит как есть, без слияния с тем, что могло случиться
/// на сервере за это время (CRDT было бы оверинжинирингом для этого
/// масштаба).
enum OfflineActionType { feedingRecord, taskComplete, note }

/// Одно отложенное действие на диске.
class OfflineQueueItem {
  const OfflineQueueItem({
    required this.id,
    required this.type,
    required this.payload,
    required this.queuedAt,
  });

  /// Локальный идентификатор элемента очереди. Не имеет отношения к id
  /// сущности на сервере — тот появляется только после успешной отправки, а
  /// на бэкенде это автоинкремент, который клиент заранее знать не может.
  final String id;
  final OfflineActionType type;
  final Map<String, dynamic> payload;
  final DateTime queuedAt;

  factory OfflineQueueItem.fromJson(Map<String, dynamic> json) =>
      OfflineQueueItem(
        id: json['id'] as String,
        type: OfflineActionType.values.byName(json['type'] as String),
        payload: Map<String, dynamic>.from(json['payload'] as Map),
        queuedAt: DateTime.parse(json['queued_at'] as String),
      );

  Map<String, dynamic> toJson() => {
    'id': id,
    'type': type.name,
    'payload': payload,
    'queued_at': queuedAt.toIso8601String(),
  };
}

/// Хранилище очереди на диске.
///
/// Сознательно не в [ListCacheBoxes.all]: тот список чистится при выходе
/// (`resetSessionData`), а очередь — это не кэш чтения, а несохранённая
/// работа человека. Она обязана пережить и выход из аккаунта, если человек
/// вышел раньше, чем появилась связь. Изоляция между пользователями на общем
/// устройстве всё равно есть — тем же способом, что и у кэша: ключ внутри
/// бокса это [cacheScopeProvider], и чужой scope просто не читается.
const _queueCache = ListCache<OfflineQueueItem>(
  boxName: 'offline_action_queue',
  fromJson: OfflineQueueItem.fromJson,
  toJson: _itemToJson,
);

Map<String, dynamic> _itemToJson(OfflineQueueItem item) => item.toJson();

/// Очередь действий, накопленных без связи, и их отправка.
final offlineQueueProvider =
    StateNotifierProvider<OfflineQueueController, List<OfflineQueueItem>>((
      ref,
    ) {
      // Сменился пользователь — пересоздаём контроллер с новым scope, иначе он
      // продолжил бы читать/писать очередь предыдущего аккаунта.
      ref.watch(sessionRevisionProvider);
      return OfflineQueueController(ref, ref.read(cacheScopeProvider));
    });

/// Итог одной попытки отправить элемент очереди.
enum _SendResult {
  /// Дошло до сервера.
  done,

  /// Сервер отказал не из-за сети — повторами это не исправить.
  dropped,

  /// Сети всё ещё нет — элемент остаётся первым в очереди.
  retryLater,
}

class OfflineQueueController extends StateNotifier<List<OfflineQueueItem>> {
  OfflineQueueController(this._ref, this._scope) : super(const []) {
    // Живёт всё время, пока приложение открыто (см. `OfflineQueueGate`),
    // поэтому подписка на связь тоже держится всё это время, а не только
    // пока какой-то экран смотрит на очередь.
    _ref.listen<AsyncValue<bool>>(isOnlineProvider, (previous, next) {
      if (next.value == true) unawaited(flush());
    });
    _restore();
  }

  final Ref _ref;
  final String? _scope;

  /// Отправка уже идёт — второй вызов `flush()` (например, из слушателя
  /// связи сразу после ручного вызова тем же кадром) не должен начинать
  /// параллельный проход по той же очереди, а просто дождаться этого же.
  Future<void>? _inFlight;

  /// Хватает микросекундного счётчика: элементы очереди появляются по
  /// одному нажатию за раз, а не пачками в одну и ту же микросекунду.
  static var _sequence = 0;

  Future<void> _restore() async {
    final items = await _queueCache.read(_scope);
    if (!mounted) return;
    if (items.isNotEmpty) state = items;
    // К моменту восстановления связь могла уже вернуться — не ждать
    // следующего события `connectivity_plus`, чтобы не откладывать
    // отправку до случайного переключения Wi-Fi/мобильных данных.
    unawaited(flush());
  }

  /// Поставить действие в очередь.
  Future<void> enqueue(OfflineActionType type, Map<String, dynamic> payload) {
    final item = OfflineQueueItem(
      id: '${DateTime.now().microsecondsSinceEpoch}_${_sequence++}',
      type: type,
      payload: payload,
      queuedAt: DateTime.now(),
    );
    state = [...state, item];
    return _persist();
  }

  Future<void> _persist() => _queueCache.write(_scope, state);

  /// Отправить всё, что накопилось, пока была связь.
  ///
  /// FIFO — более старая запись должна дойти до сервера первой: два
  /// кормления или задача и связанная с ней заметка за один обход теряют
  /// смысл порядка, если поменять их местами.
  ///
  /// Вызов, заставший уже идущую отправку, не запускает вторую параллельно
  /// по той же очереди — он ждёт ту же самую: без этого включение сети,
  /// пойманное и слушателем связи, и явным вызовом из `_restore()` в одном
  /// кадре, породило бы два одновременных прохода по одному и тому же
  /// списку.
  Future<void> flush() {
    final inFlight = _inFlight;
    if (inFlight != null) return inFlight;
    if (!mounted) return Future<void>.value();
    final online = _ref.read(isOnlineProvider).value ?? false;
    if (!online) return Future<void>.value();

    final future = _flushQueue();
    _inFlight = future;
    return future.whenComplete(() => _inFlight = null);
  }

  Future<void> _flushQueue() async {
    while (mounted && state.isNotEmpty) {
      final result = await _send(state.first);
      if (!mounted) return;
      if (result == _SendResult.retryLater) break;
      state = state.sublist(1);
      await _persist();
    }
  }

  Future<_SendResult> _send(OfflineQueueItem item) async {
    try {
      switch (item.type) {
        case OfflineActionType.feedingRecord:
          await _sendFeedingRecord(item.payload);
        case OfflineActionType.taskComplete:
          await _sendTaskComplete(item.payload);
        case OfflineActionType.note:
          await _sendNote(item.payload);
      }
      return _SendResult.done;
    } catch (e, stack) {
      if (_isConnectivityFailure(e)) return _SendResult.retryLater;
      // Настоящий отказ сервера — например клетку успели удалить, пока
      // запись ждала связи. Повторами не лечится, а раздувать очередь
      // нечем помочь: человек уже не смотрит на экран, где это вводил.
      // Единственный оставшийся способ не потерять сигнал молча — Sentry.
      logUncaughtError(e, stack, source: 'offline_queue.${item.type.name}');
      return _SendResult.dropped;
    }
  }

  bool _isConnectivityFailure(Object e) =>
      e is ApiFailure &&
      (e.kind == ApiFailureKind.offline || e.kind == ApiFailureKind.timeout);

  Future<void> _sendFeedingRecord(Map<String, dynamic> payload) async {
    await _ref
        .read(feedingRecordsRepositoryProvider)
        .createFeedingRecordsBulk(
          feedId: payload['feed_id'] as int,
          quantityPerRecipient: (payload['quantity'] as num).toDouble(),
          fedAt: DateTime.parse(payload['fed_at'] as String),
          rabbitIds: List<int>.from(payload['rabbit_ids'] as List? ?? const []),
          cageIds: List<int>.from(payload['cage_ids'] as List? ?? const []),
          notes: payload['notes'] as String?,
        );
    // Запись уже ушла на сервер — что бы ни случилось дальше, отправка не
    // провалилась. Но если контроллер за это время успели закрыть (например
    // разобрали `ProviderContainer`), трогать `_ref` для обновления читаемых
    // списков уже нельзя.
    if (!mounted) return;
    await _ref.read(feedingRecordsProvider.notifier).refresh();
    _ref.invalidate(feedsProvider);
    _ref.invalidate(feedOptionsProvider);
  }

  Future<void> _sendTaskComplete(Map<String, dynamic> payload) async {
    final id = payload['task_id'] as int;
    await _ref.read(tasksRepositoryProvider).completeTask(id);
    if (!mounted) return;
    await _ref.read(tasksListProvider.notifier).refresh();
    _ref.invalidate(taskProvider(id));
    _ref.invalidate(taskStatisticsProvider);
  }

  Future<void> _sendNote(Map<String, dynamic> payload) async {
    await _ref
        .read(notesRepositoryProvider)
        .createNote(NoteCreate.fromJson(payload));
    if (!mounted) return;
    _ref.invalidate(journalFeedProvider);
  }
}
