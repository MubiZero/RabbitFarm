import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';

import 'package:mobile/core/theme/app_theme.dart';
import 'package:mobile/l10n/generated/app_localizations.dart';

/// Тема приложения без чернильной волны от нажатий.
///
/// Волна Material 3 рисуется шейдером (`shaders/ink_sparkle.frag`), а в
/// тестовом окружении он загружается из артефактов SDK и может оказаться
/// несовместимым с движком — тогда любой тап валит тест сообщением про
/// «runtime stages format version», не имеющим отношения к проверяемому
/// поведению. Тесты про поведение, а не про анимацию нажатия.
ThemeData _theme(Brightness brightness) => AppTheme.build(
      brightness: brightness,
      accent: const Color(0xFF10B981),
    ).copyWith(splashFactory: NoSplash.splashFactory);

/// Обёртка для виджет-тестов: та же тема и те же переводы, что в приложении.
///
/// Без делегата переводов любой экран падает на первом же обращении к строке,
/// поэтому собирать MaterialApp в тестах руками нельзя.
Widget testApp(
  Widget child, {
  List<Override> overrides = const [],
  Brightness brightness = Brightness.light,
}) {
  return ProviderScope(
    // Без этого сбойный провайдер в тесте молча ретраится по расписанию
    // Riverpod (до 10 раз, растущая пауза) вместо немедленной ошибки — тесты
    // на «показывает ошибку и кнопку „Повторить“» иначе зависали бы на
    // фиктивной загрузке дольше, чем длится сам тест. См. `lib/main.dart`,
    // где то же самое сделано для настоящего приложения.
    retry: (retryCount, error) => null,
    overrides: overrides,
    child: MaterialApp(
      theme: _theme(brightness),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(body: child),
    ),
  );
}

/// То же самое для экрана, который сам собирает свой Scaffold.
Widget testAppScreen(
  Widget home, {
  List<Override> overrides = const [],
  Brightness brightness = Brightness.light,
}) {
  return ProviderScope(
    // Без этого сбойный провайдер в тесте молча ретраится по расписанию
    // Riverpod (до 10 раз, растущая пауза) вместо немедленной ошибки — тесты
    // на «показывает ошибку и кнопку „Повторить“» иначе зависали бы на
    // фиктивной загрузке дольше, чем длится сам тест. См. `lib/main.dart`,
    // где то же самое сделано для настоящего приложения.
    retry: (retryCount, error) => null,
    overrides: overrides,
    child: MaterialApp(
      theme: _theme(brightness),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: home,
    ),
  );
}
