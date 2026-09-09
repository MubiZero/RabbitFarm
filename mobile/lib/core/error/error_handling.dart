import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../widgets/app_crash_view.dart';

/// Общий перехват необработанных ошибок приложения.
///
/// До этого приложение теряло ошибки молча: упавший `Future` вне дерева
/// виджетов не попадал никуда — ни в консоль, ни в отчёт, — и разбирать жалобу
/// «у меня просто ничего не произошло» было не по чему.
///
/// Отправки во внешний сервис здесь пока нет: crash-репортер — отдельное
/// решение. Задача этого слоя — чтобы ошибка существовала хотя бы в логе
/// устройства и место для такой отправки было ровно одно.
void installErrorHandlers() {
  // Ошибка внутри Flutter: сборка, отрисовка, жесты, колбэки фреймворка.
  FlutterError.onError = (details) {
    // Стандартный вывод остаётся: в отладке именно он даёт разбор с деревом
    // виджетов, который никакой лог не заменит.
    FlutterError.presentError(details);
    logUncaughtError(
      details.exception,
      details.stack ?? StackTrace.current,
      source: details.context?.toString() ?? 'Flutter',
    );
  };

  // Ошибка мимо Flutter: асинхронщина, обратные вызовы платформы, изолятов.
  PlatformDispatcher.instance.onError = (error, stack) {
    logUncaughtError(error, stack, source: 'platform');
    // true — ошибка обработана, процесс не убиваем: приложение продолжает
    // работать, а человек видит состояние ошибки на экране, а не вылет.
    return true;
  };

  // В отладке красный экран Flutter полезен — на нём видно, что именно упало.
  // Пользователю релиза он не говорит ничего, кроме «сломалось».
  if (kReleaseMode) {
    ErrorWidget.builder = (details) => const AppCrashView();
  }
}

/// Пишет необработанную ошибку в лог устройства.
///
/// [source] — откуда пришло: помогает отличить сбой сборки виджета от
/// упавшего фонового запроса, когда в отчёте видно только текст исключения.
void logUncaughtError(Object error, StackTrace stack, {String? source}) {
  developer.log(
    'Необработанная ошибка${source == null ? '' : ' ($source)'}',
    name: 'rabbitfarm',
    level: 1000, // SEVERE
    error: error,
    stackTrace: stack,
  );
}
