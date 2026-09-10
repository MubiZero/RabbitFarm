import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../offline_queue/offline_queue.dart';

/// Держит очередь офлайн-действий живой всё время работы приложения.
///
/// Riverpod-провайдеры ленивые: без постоянного наблюдателя контроллер
/// очереди создавался бы только тогда, когда какой-то экран его читает — и
/// связь, вернувшаяся, пока человек смотрит на список кроликов, никогда не
/// запустила бы отправку. Сам виджет ничего не рисует, кроме `child`: полосу
/// «нет связи» уже показывает `OfflineBanner` рядом.
class OfflineQueueGate extends ConsumerWidget {
  const OfflineQueueGate({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(offlineQueueProvider);
    return child;
  }
}
