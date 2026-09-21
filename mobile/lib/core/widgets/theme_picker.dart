import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../l10n/l10n_context.dart';
import '../providers/theme_provider.dart';
import '../theme/theme.dart';

/// Название темы словами, а не значком.
///
/// Раньше выбор стоял тремя безымянными кнопками — солнце, шестерёнка, луна.
/// Проверяющий продукт человек светлой темы просто не нашёл: подписи были
/// только во всплывающих подсказках, которые на телефоне никто не видит, —
/// их показывают наведением мыши.
String themeModeName(BuildContext context, ThemeMode mode) => switch (mode) {
      ThemeMode.light => context.l10n.settingsThemeLight,
      ThemeMode.dark => context.l10n.settingsThemeDark,
      ThemeMode.system => context.l10n.settingsThemeSystem,
    };

IconData themeModeIcon(ThemeMode mode) => switch (mode) {
      ThemeMode.light => Icons.light_mode_outlined,
      ThemeMode.dark => Icons.dark_mode_outlined,
      ThemeMode.system => Icons.brightness_auto_outlined,
    };

/// Открывает выбор темы нижним листом — тем же способом, что и выбор языка
/// строкой ниже: два соседних решения не должны выбираться по-разному.
Future<void> showThemePicker(BuildContext context, WidgetRef ref) {
  final current = ref.read(themeProvider).mode;

  return showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    builder: (sheetContext) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final mode in ThemeMode.values)
            ListTile(
              leading: Icon(themeModeIcon(mode)),
              title: Text(themeModeName(sheetContext, mode)),
              trailing: mode == current
                  ? Icon(Icons.check, color: sheetContext.accent)
                  : null,
              onTap: () {
                ref.read(themeProvider.notifier).setMode(mode);
                Navigator.of(sheetContext).pop();
              },
            ),
        ],
      ),
    ),
  );
}
