import 'package:flutter/material.dart';

import '../theme/theme.dart';

/// Сообщение об ошибке, которое живёт вместе со своим экраном.
///
/// Плашки Material висят не на экране, а над всем приложением, и переход
/// дальше их не убирает: человек уходил с формы, открывал другой раздел — а
/// красная надпись про несохранённую запись ехала с ним и пугала уже там,
/// где ничего не ломалось. Ошибка относится к тому, что человек только что
/// делал; ушёл с этого места — она больше не про него.
///
/// Подтверждения («Клетка добавлена») так не убираются намеренно: их
/// показывают как раз перед возвратом назад, и увидеть их человек должен
/// уже на списке.
ScaffoldFeatureController<SnackBar, SnackBarClosedReason>? _current;

extension ErrorSnack on ScaffoldMessengerState {
  /// Показать отказ: запись не ушла, действие не выполнено.
  ///
  /// `action` — когда у отказа есть продолжение («уже зарегистрированы —
  /// войти»): такому сообщению дают пожить подольше, но и оно не переезжает
  /// на следующий экран.
  void showError(String message, {SnackBarAction? action, Duration? duration}) {
    final controller = showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.error,
        action: action,
        duration: duration ?? const Duration(seconds: 4),
      ),
    );
    _current = controller;
    controller.closed.then((_) {
      if (identical(_current, controller)) _current = null;
    });
  }
}

/// Убирает показанную ошибку, как только человек ушёл с экрана, на котором
/// она случилась. Подключается в `GoRouter(observers: …)`.
class ErrorSnackObserver extends NavigatorObserver {
  void _dismiss() {
    _current?.close();
    _current = null;
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) => _dismiss();

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) => _dismiss();

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) => _dismiss();

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) =>
      _dismiss();
}
