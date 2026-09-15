import 'package:flutter/material.dart';

import '../l10n/l10n_context.dart';

/// Удаление с окном на отмену.
///
/// Второй страх, который владельцы называют сами: «помощник сотрёт». Первый
/// ответ на него — журнал (видно, кто что удалил), второй — этот: несколько
/// секунд, за которые удаление можно вернуть, не обращаясь ни к кому.
///
/// Запрос на сервер уходит не сразу, а когда окно закрылось: пока оно
/// открыто, отменять нечего — удаления ещё не было. Отсюда и главное
/// свойство: если приложение закрыли или связь пропала внутри этих секунд,
/// запись останется на месте. Ошибиться в эту сторону безопаснее.
///
/// Возвращает `true`, если удаление всё-таки состоялось.
Future<bool> deleteWithUndo(
  BuildContext context, {
  required String message,
  required Future<void> Function() commit,

  /// Вызывается, если человек передумал, — списку пора вернуть строку на
  /// место.
  VoidCallback? onUndo,
  Duration window = const Duration(seconds: 6),
}) async {
  final messenger = ScaffoldMessenger.of(context);
  final l10n = context.l10n;

  final controller = messenger.showSnackBar(
    SnackBar(
      content: Text(message),
      duration: window,
      // Подсказка с кнопкой по умолчанию висит, пока её не тронут: Flutter
      // считает, что раз есть действие — человек должен его увидеть. Здесь это
      // наоборот ломает замысел: без закрытия по времени удаление не уезжает
      // на сервер никогда, и окно отмены становится бесконечным.
      persist: false,
      action: SnackBarAction(
        label: l10n.commonUndo,
        // Работы здесь нет намеренно: нажатие само закрывает подсказку, а
        // причину закрытия читает код ниже.
        onPressed: () {},
      ),
    ),
  );

  final reason = await controller.closed;
  if (reason == SnackBarClosedReason.action) {
    onUndo?.call();
    return false;
  }

  await commit();
  return true;
}
