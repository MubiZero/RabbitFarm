import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Есть ли у устройства сеть — по данным операционной системы.
///
/// Раньше приложение узнавало об отсутствии связи только по ошибке очередного
/// запроса: человек жал «Сохранить», ждал таймаут и получал «не удалось» — по
/// одной попытке за раз. Здесь состояние известно заранее и на весь экран.
///
/// Важная оговорка: это наличие сети у устройства, а не доступность сервера.
/// Wi-Fi без интернета система считает связью, и запрос всё равно упадёт —
/// поэтому отдельная обработка ошибок запросов никуда не девается. Обратное
/// неверно: сети нет — значит запрос точно не пройдёт, и об этом честно можно
/// сказать сразу.
final isOnlineProvider = StreamProvider<bool>((ref) async* {
  final connectivity = Connectivity();

  yield _isOnline(await connectivity.checkConnectivity());
  yield* connectivity.onConnectivityChanged.map(_isOnline);
});

/// Плагин отдаёт список интерфейсов и кладёт в него `none` единственным
/// элементом ровно тогда, когда связи нет вовсе.
bool _isOnline(List<ConnectivityResult> results) =>
    results.any((result) => result != ConnectivityResult.none);
