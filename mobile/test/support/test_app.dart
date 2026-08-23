import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:mobile/core/theme/app_theme.dart';
import 'package:mobile/l10n/generated/app_localizations.dart';

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
    overrides: overrides,
    child: MaterialApp(
      theme: AppTheme.build(
        brightness: brightness,
        accent: const Color(0xFF10B981),
      ),
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
    overrides: overrides,
    child: MaterialApp(
      theme: AppTheme.build(
        brightness: brightness,
        accent: const Color(0xFF10B981),
      ),
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
