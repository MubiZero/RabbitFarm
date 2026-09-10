import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';

import 'package:mobile/core/providers/locale_provider.dart';
import 'package:mobile/core/theme/app_theme.dart';
import 'package:mobile/l10n/generated/app_localizations.dart';

/// `LocaleNotifier.build()` подхватывает язык устройства из
/// `SharedPreferences` асинхронно — в тестовом окружении локаль по умолчанию
/// `en`, и без этой подмены язык интерфейса переключался бы на английский,
/// как только провайдер дочитает настройки, ломая любой поиск текста
/// по-русски. Тест, которому язык важен сам по себе, переопределяет
/// `localeProvider` заново в своих `overrides` — этот вариант в списке идёт
/// раньше и просто перезаписывается.
class _FixedRuLocaleNotifier extends LocaleNotifier {
  @override
  Future<Locale> build() async => const Locale('ru');
}

final _fixedRuLocaleOverride =
    localeProvider.overrideWith(_FixedRuLocaleNotifier.new);

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
  Locale locale = const Locale('ru'),
}) {
  return ProviderScope(
    // Без этого сбойный провайдер в тесте молча ретраится по расписанию
    // Riverpod (до 10 раз, растущая пауза) вместо немедленной ошибки — тесты
    // на «показывает ошибку и кнопку „Повторить“» иначе зависали бы на
    // фиктивной загрузке дольше, чем длится сам тест. См. `lib/main.dart`,
    // где то же самое сделано для настоящего приложения.
    retry: (retryCount, error) => null,
    overrides: [_fixedRuLocaleOverride, ...overrides],
    child: MaterialApp(
      theme: _theme(brightness),
      // Без явной локали Flutter резолвит её сам против `supportedLocales`
      // и системного языка тестового окружения (по умолчанию `en_US`) — с
      // тех пор как в списке появился английский, тесты на русский текст
      // посыпались бы просто от смены окружения, а не от своей логики.
      locale: locale,
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
  Locale locale = const Locale('ru'),
}) {
  return ProviderScope(
    // Без этого сбойный провайдер в тесте молча ретраится по расписанию
    // Riverpod (до 10 раз, растущая пауза) вместо немедленной ошибки — тесты
    // на «показывает ошибку и кнопку „Повторить“» иначе зависали бы на
    // фиктивной загрузке дольше, чем длится сам тест. См. `lib/main.dart`,
    // где то же самое сделано для настоящего приложения.
    retry: (retryCount, error) => null,
    overrides: [_fixedRuLocaleOverride, ...overrides],
    child: MaterialApp(
      theme: _theme(brightness),
      locale: locale,
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
