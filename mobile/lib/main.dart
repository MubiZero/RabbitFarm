import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'core/analytics/analytics.dart';
import 'core/cache/list_cache.dart';
import 'core/error/error_handling.dart';
import 'core/l10n/date_locale.dart';
import 'core/l10n/framework_locale_fallback.dart';
import 'core/notifications/fcm_service.dart';
import 'core/providers/app_version.dart';
import 'core/providers/locale_provider.dart';
import 'core/providers/theme_provider.dart';
import 'core/router/app_router.dart';
import 'core/router/deep_links.dart';
import 'core/widgets/force_update_screen.dart';
import 'core/widgets/offline_banner.dart';
import 'core/widgets/offline_queue_gate.dart';
import 'features/auth/presentation/widgets/farm_status_banner.dart';
import 'features/auth/presentation/widgets/impersonation_banner.dart';
import 'l10n/generated/app_localizations.dart';

/// Тайр-офф для `ProviderScope.retry`: топ-левел функция, а не замыкание,
/// нужна ради `const ProviderScope`.
Duration? _noRetry(int retryCount, Object error) => null;

void main() {
  // Асинхронная ошибка, упавшая мимо дерева виджетов, всплывает в ту зону, где
  // родилась, — поэтому и запуск, и вся инициализация живут внутри одной общей
  // зоны, иначе такая ошибка просто исчезает. По той же причине привязка
  // Flutter создаётся здесь же, а не снаружи.
  runZonedGuarded(_bootstrap, (error, stack) {
    logUncaughtError(error, stack, source: 'zone');
  });
}

/// Пустая строка по умолчанию — без DSN Sentry инициализируется в
/// выключенном режиме, ничего никуда не отправляет.
/// flutter build ... --dart-define=SENTRY_DSN=https://...@sentry.io/...
const _sentryDsn = String.fromEnvironment('SENTRY_DSN');

Future<void> _bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();

  // До `installErrorHandlers()`: наши обработчики ставятся поверх и
  // полностью владеют `FlutterError.onError`/`PlatformDispatcher.onError`
  // (см. `error_handling.dart`) — иначе оба перехвата спорили бы за
  // FlutterError.onError, и часть ошибок либо дублировалась, либо терялась.
  await SentryFlutter.init((options) {
    options.dsn = _sentryDsn;
    options.environment = kReleaseMode ? 'production' : 'development';
    // Только ошибки: performance-трейсинг на этом масштабе не нужен, а на
    // бесплатном тарифе Sentry именно он лимитирован.
    options.tracesSampleRate = 0;
  });
  installErrorHandlers();

  // Кэш последних виденных списков. Без него в сарае без связи после
  // перезапуска поголовье, клетки и задачи встречали пустым экраном. Хранилище
  // может не подняться (нет места, сломанный файл) — это не повод не запускать
  // приложение: тогда списки просто работают только по сети, как раньше.
  try {
    await initListCache();
  } catch (e) {
    debugPrint('Кэш списков недоступен, работаем только по сети: $e');
  }

  // Web пока без push — нужен отдельный VAPID-ключ и service worker.
  // До того как в проект добавлен google-services.json (Android) или
  // GoogleService-Info.plist (iOS), Firebase не инициализируется вовсе —
  // приложение не должно падать на старте только потому, что push ещё не
  // настроен на этой платформе.
  var firebaseReady = false;
  if (!kIsWeb) {
    try {
      await Firebase.initializeApp();
      FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
      listenForForegroundMessages();
      listenForMessageTaps();
      // Аналитика живёт на том же Firebase-приложении: не поднялось оно —
      // не пишутся и события (см. `Analytics`).
      Analytics.enable();
      firebaseReady = true;
    } catch (e) {
      debugPrint('Firebase: инициализация не удалась, push отключён: $e');
    }
  }

  // Даты и числа форматируются по-русски и там, где локаль не передана явно.
  await initializeDateFormatting('ru');
  Intl.defaultLocale = 'ru';

  runApp(
    const ProviderScope(
      // Riverpod 3.x по умолчанию сам молча ретраит упавший провайдер (до 10
      // раз с растущей паузой) — пока идёт ретрай, `AsyncValue` держит и
      // ошибку, и признак загрузки одновременно, и `.when()` в этом окне
      // отдаёт `loading`, а не `error`. У приложения уже есть свой ответ на
      // сбой сети — явная кнопка «Повторить» на каждом экране, — и тихий
      // повтор поверх нёс бы только задержку показа настоящей ошибки.
      retry: _noRetry,
      child: MyApp(),
    ),
  );

  // Ссылка-приглашение `rabbitfarm://join?phone=…`: и та, которой приложение
  // запустили, и приходящие потом. Подписка живёт всё время работы
  // приложения — отменять её негде и незачем.
  unawaited(initDeepLinks());

  // Приложение было запущено тапом по уведомлению из полностью закрытого
  // состояния — навигация ждёт первого кадра, роутер ещё не готов раньше.
  if (firebaseReady) {
    final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => handleMessageTap(initialMessage),
      );
    }
  }
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeState = ref.watch(themeProvider);
    final darkTheme = ref.watch(darkThemeProvider);
    final lightTheme = ref.watch(lightThemeProvider);
    final router = ref.watch(routerProvider);
    final upgradeRequired = ref.watch(upgradeRequiredProvider);
    // Пока `SharedPreferences` ещё не прочитан — русский, тот же выбор, что
    // и в самом провайдере до его первого разрешения.
    final locale = ref.watch(localeProvider).value ?? const Locale('ru');
    // Догоняет любой `DateFormat`/форматирование без явной локали до
    // выбранного языка — иначе такие места молча остались бы русскими,
    // сколько бы языков в приложении ни было.
    Intl.defaultLocale = dateSymbolsLocale(locale);

    return MaterialApp.router(
      onGenerateTitle: (context) => AppLocalizations.of(context).appName,
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeState.mode,
      routerConfig: router,
      locale: locale,
      // Все три плашки должны быть видны на любом экране, а не только там, где
      // начался просмотр, выяснилось состояние доступа или отвалилась сеть —
      // поэтому оборачивают весь роутер, а не один маршрут. Порядок — от
      // самого объемлющего к самому частному: вход под клиентом это режим
      // сеанса целиком, состояние фермы — факт внутри него, а отсутствие связи
      // проходит само и относится к устройству, а не к аккаунту.
      //
      // Устаревшая версия — снаружи всех трёх и замещает экран целиком, а не
      // накладывается баннером: с сервером, который её не понимает, любой
      // другой экран за плашкой всё равно ломается непредсказуемо.
      builder: (context, child) => upgradeRequired
          ? const ForceUpdateScreen()
          : ImpersonationBanner(
              child: FarmStatusBanner(
                child: OfflineQueueGate(
                  child: OfflineBanner(child: child ?? const SizedBox.shrink()),
                ),
              ),
            ),
      // Обёртки вместо Global*Delegate напрямую: `flutter_localizations` не
      // знает таджикский вовсе (см. `framework_locale_fallback.dart`) — без
      // них выбор таджикского ронял бы любой системный диалог (календарь,
      // выделение текста) с «No MaterialLocalizations found».
      localizationsDelegates: const [
        AppLocalizations.delegate,
        TgAwareMaterialLocalizationsDelegate(),
        TgAwareWidgetsLocalizationsDelegate(),
        TgAwareCupertinoLocalizationsDelegate(),
      ],
      // Список языков берётся из переводов, а не пишется руками: раньше здесь
      // значился английский, которого в приложении никогда не было.
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}
