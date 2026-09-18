import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _kLocale = 'app_locale'; // 'ru' | 'tg' | 'uz' | 'en'

/// Языки, которые реально переведены — источник истины для переключателя.
/// Список поддерживаемых `MaterialApp.supportedLocales` берётся из самих
/// `.arb`-файлов (`AppLocalizations.supportedLocales`), а не отсюда; этот
/// список — только для UI выбора языка, где порядок и текст важны.
const supportedAppLocales = [
  Locale('ru'),
  Locale('tg'),
  Locale('uz'),
  Locale('en'),
];

/// `AsyncNotifier`, а не синхронный `Notifier` с фоновым чтением
/// `SharedPreferences`: на синхронном варианте выбор языка сразу после
/// запуска реально терялся — чтение автоопределения по локали устройства
/// иногда завершалось ПОЗЖЕ ручного выбора и перезаписывало его обратно.
/// Здесь так не выйдет: пока `build()` не отдал значение, `setLocale` ждать
/// не заставляет (он не вызывается раньше, чем экран с переключателем вообще
/// появится), а `state.value` для UI читается уже после того, как гонка
/// разрешилась.
class LocaleNotifier extends AsyncNotifier<Locale> {
  @override
  Future<Locale> build() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_kLocale);
    if (saved != null) return Locale(saved);

    // Человек пришёл с витрины, и язык страницы приехал в адресе
    // (`?lang=uz`). Это ближе к правде, чем язык телефона: узбекский фермер
    // читал узбекскую страницу, нажимал «Открыть приложение» и попадал в
    // английский интерфейс, потому что на дешёвом Android в настройках стоит
    // английский. Выбор запоминается: второй раз он придёт уже без адреса.
    final fromLink = _languageFromLaunchUrl();
    if (fromLink != null) {
      await prefs.setString(_kLocale, fromLink);
      return Locale(fromLink);
    }

    // Первый запуск: пробуем угадать по языку устройства, а не молчаливо
    // держим русский всем подряд — это тот самый явный выбор, которого от
    // языкового переключателя ждут, просто с разумным стартовым значением.
    final deviceCode = PlatformDispatcher.instance.locale.languageCode;
    final matches =
        supportedAppLocales.any((l) => l.languageCode == deviceCode);
    return Locale(matches ? deviceCode : 'ru');
  }

  Future<void> setLocale(Locale locale) async {
    state = AsyncData(locale);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kLocale, locale.languageCode);
  }
}

/// Язык, названный в адресе страницы: `app.rabbitfarm.click/?lang=uz`.
///
/// Незнакомый или чужой язык игнорируем — иначе `?lang=fr` показал бы пустые
/// подписи вместо интерфейса.
String? languageFromUrl(Uri url) {
  final asked = url.queryParameters['lang']?.toLowerCase();
  if (asked == null) return null;
  return supportedAppLocales.any((l) => l.languageCode == asked) ? asked : null;
}

/// Адрес, которым открыли приложение. На телефоне адреса нет — `Uri.base`
/// там указывает на файл, и параметров в нём не бывает.
String? _languageFromLaunchUrl() => languageFromUrl(Uri.base);

final localeProvider = AsyncNotifierProvider<LocaleNotifier, Locale>(
  LocaleNotifier.new,
);
