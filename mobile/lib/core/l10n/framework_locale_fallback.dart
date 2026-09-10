import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

/// Таджикский, в отличие от русского, узбекского и английского, не входит ни
/// в один из готовых пакетов Flutter (`flutter_localizations` не знает `tg`
/// вовсе — ни для системных диалогов Material, ни для базовых `Widgets`, ни
/// для Cupertino). Без обхода выбор таджикского в приложении оставлял бы
/// системные подписи вроде «ОК»/«Отмена» в календаре без перевода вовсе —
/// `Localizations` пропускает делегата, если тот сам говорит, что не
/// поддерживает локаль, и тогда `MaterialLocalizations.of(context)` не
/// находит вообще ничего и падает.
///
/// Раз родных данных для `tg` нет и взять их неоткуда, ближайший осмысленный
/// вариант — русские подписи: в Таджикистане это тот язык, на котором и так
/// принято показывать даты и системные диалоги там, где родного перевода
/// нет, а не английский, который не в ходу.
const _tgFrameworkFallback = Locale('ru');

Locale _effective(Locale locale) =>
    locale.languageCode == 'tg' ? _tgFrameworkFallback : locale;

class TgAwareMaterialLocalizationsDelegate
    extends LocalizationsDelegate<MaterialLocalizations> {
  const TgAwareMaterialLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      locale.languageCode == 'tg' ||
      GlobalMaterialLocalizations.delegate.isSupported(locale);

  @override
  Future<MaterialLocalizations> load(Locale locale) =>
      GlobalMaterialLocalizations.delegate.load(_effective(locale));

  @override
  bool shouldReload(TgAwareMaterialLocalizationsDelegate old) => false;
}

class TgAwareWidgetsLocalizationsDelegate
    extends LocalizationsDelegate<WidgetsLocalizations> {
  const TgAwareWidgetsLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      locale.languageCode == 'tg' ||
      GlobalWidgetsLocalizations.delegate.isSupported(locale);

  @override
  Future<WidgetsLocalizations> load(Locale locale) =>
      GlobalWidgetsLocalizations.delegate.load(_effective(locale));

  @override
  bool shouldReload(TgAwareWidgetsLocalizationsDelegate old) => false;
}

class TgAwareCupertinoLocalizationsDelegate
    extends LocalizationsDelegate<CupertinoLocalizations> {
  const TgAwareCupertinoLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      locale.languageCode == 'tg' ||
      GlobalCupertinoLocalizations.delegate.isSupported(locale);

  @override
  Future<CupertinoLocalizations> load(Locale locale) =>
      GlobalCupertinoLocalizations.delegate.load(_effective(locale));

  @override
  bool shouldReload(TgAwareCupertinoLocalizationsDelegate old) => false;
}
