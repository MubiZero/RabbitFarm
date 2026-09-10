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

    // Первый запуск: пробуем угадать по языку устройства, а не молчаливо
    // держим русский всем подряд — это тот самый явный выбор, которого от
    // языкового переключателя ждут, просто с разумным стартовым значением.
    final deviceCode = PlatformDispatcher.instance.locale.languageCode;
    final matches = supportedAppLocales.any((l) => l.languageCode == deviceCode);
    return Locale(matches ? deviceCode : 'ru');
  }

  Future<void> setLocale(Locale locale) async {
    state = AsyncData(locale);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kLocale, locale.languageCode);
  }
}

final localeProvider = AsyncNotifierProvider<LocaleNotifier, Locale>(
  LocaleNotifier.new,
);
