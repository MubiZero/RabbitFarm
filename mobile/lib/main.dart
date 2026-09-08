import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

import 'core/notifications/fcm_service.dart';
import 'core/providers/theme_provider.dart';
import 'core/router/app_router.dart';
import 'l10n/generated/app_localizations.dart';

/// Тайр-офф для `ProviderScope.retry`: топ-левел функция, а не замыкание,
/// нужна ради `const ProviderScope`.
Duration? _noRetry(int retryCount, Object error) => null;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

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

  // Приложение было запущено тапом по уведомлению из полностью закрытого
  // состояния — навигация ждёт первого кадра, роутер ещё не готов раньше.
  if (firebaseReady) {
    final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => handleMessageTap(initialMessage));
    }
  }
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeState = ref.watch(themeProvider);
    final darkTheme  = ref.watch(darkThemeProvider);
    final lightTheme = ref.watch(lightThemeProvider);
    final router     = ref.watch(routerProvider);

    return MaterialApp.router(
      onGenerateTitle: (context) => AppLocalizations.of(context).appName,
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeState.mode,
      routerConfig: router,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      // Список языков берётся из переводов, а не пишется руками: раньше здесь
      // значился английский, которого в приложении никогда не было.
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}
