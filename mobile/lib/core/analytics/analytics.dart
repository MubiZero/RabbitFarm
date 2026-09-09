import 'dart:async';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';

/// Продуктовая аналитика: несколько событий воронки, а не слой поверх SDK.
///
/// Тонкая обёртка нужна ровно за двумя вещами. Первая: Firebase
/// инициализируется не всегда — на web его нет вовсе, а на сборке без
/// `google-services.json` инициализация падает и приложение продолжает
/// работать без push (см. `main.dart`); вызов аналитики в таком состоянии
/// должен быть тихим no-op, а не исключением посреди сохранения кролика.
/// Вторая: имена событий должны лежать в одном месте, иначе через полгода
/// в отчётах окажутся `rabbit_added` и `rabbitAdded` одновременно.
class Analytics {
  Analytics._();

  static bool _enabled = false;

  /// Вызывается из `main` после успешного `Firebase.initializeApp`.
  static void enable() => _enabled = true;

  /// Регистрация фермы завершена — бэкенд принял данные и выдал сессию.
  static void signUpCompleted() => _log('sign_up_completed');

  /// В стадо добавлен кролик. Событие пишется на каждое добавление: «первый
  /// кролик фермы» надёжно считается уже в отчёте — по первому событию
  /// пользователя, — а на клиенте потребовал бы отдельного запроса счётчика.
  static void rabbitAdded() => _log('rabbit_added');

  /// Записано кормление. Пачка на несколько получателей — одно событие:
  /// это одно действие человека.
  static void feedingRecorded() => _log('feeding_recorded');

  /// Открыта вкладка нижнего меню. [tab] — постоянный идентификатор вкладки
  /// (`today`, `herd`, ...), не подпись: подписи переводятся, и отчёт
  /// рассыпался бы по языкам.
  static void tabViewed(String tab) => _log('tab_viewed', {'tab': tab});

  static void _log(String name, [Map<String, Object>? parameters]) {
    if (!_enabled) return;
    // Отправка не должна ни задерживать действие пользователя, ни ломать его
    // при сбое: аналитика — побочный эффект, а не часть операции.
    unawaited(
      FirebaseAnalytics.instance
          .logEvent(name: name, parameters: parameters)
          .catchError((Object e) {
        debugPrint('Analytics: событие $name не отправлено: $e');
      }),
    );
  }
}
