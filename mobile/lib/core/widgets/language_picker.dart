import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/locale_provider.dart';
import '../theme/theme.dart';

/// Название языка на нём самом — эндоним, а не перевод. Тот, кому нужен
/// другой язык, не обязан уметь читать текущий, чтобы его найти.
String localeEndonym(Locale locale) => switch (locale.languageCode) {
      'ru' => 'Русский',
      'tg' => 'Тоҷикӣ',
      'uz' => 'Oʻzbekcha',
      'en' => 'English',
      _ => locale.languageCode,
    };

/// Иконка-переключатель языка для AppBar экранов входа и регистрации —
/// единственное место, где язык выбирают до того, как форма вообще открылась.
class LanguagePickerButton extends ConsumerWidget {
  const LanguagePickerButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider).value ?? const Locale('ru');
    return IconButton(
      icon: const Icon(Icons.language),
      tooltip: localeEndonym(locale),
      onPressed: () => showLanguagePicker(context, ref),
    );
  }
}

/// Открывает список языков нижним листом. Общая точка входа и для AppBar
/// экранов входа/регистрации, и для строки в Настройках — выбор языка не
/// должен быть заперт в онбординге: доступен и не найден один раз.
Future<void> showLanguagePicker(BuildContext context, WidgetRef ref) {
  final current = ref.read(localeProvider).value ?? const Locale('ru');

  return showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    builder: (sheetContext) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final locale in supportedAppLocales)
            ListTile(
              title: Text(localeEndonym(locale)),
              trailing: locale.languageCode == current.languageCode
                  ? Icon(Icons.check, color: sheetContext.accent)
                  : null,
              onTap: () {
                ref.read(localeProvider.notifier).setLocale(locale);
                Navigator.of(sheetContext).pop();
              },
            ),
        ],
      ),
    ),
  );
}
