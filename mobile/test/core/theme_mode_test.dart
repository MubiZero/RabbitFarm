import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:mobile/core/providers/theme_provider.dart';
import 'package:mobile/core/widgets/theme_picker.dart';

import '../support/test_app.dart';

/// Светлая тема в приложении была с самого начала, но доставалась она только
/// тому, кто сам нашёл её в настройках, — а по умолчанию всем показывали
/// тёмную. Люди работают во дворе и в сарае, чаще всего под открытым солнцем,
/// где тёмный экран не читается вовсе; полевой проход так и закончился
/// выводом «светлой темы нет».
Future<ThemeState> _settled(ProviderContainer container) async {
  for (var i = 0; i < 50; i += 1) {
    await Future<void>.delayed(const Duration(milliseconds: 5));
    final state = container.read(themeProvider);
    if (state.mode != ThemeMode.light || i > 10) return state;
  }
  return container.read(themeProvider);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  ProviderContainer build() {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    return container;
  }

  test('новому человеку экран достаётся светлым', () async {
    SharedPreferences.setMockInitialValues({});
    final container = build();

    expect(container.read(themeProvider).mode, ThemeMode.light);
    expect((await _settled(container)).mode, ThemeMode.light,
        reason: 'после чтения настроек выбор не должен перескакивать');
  });

  test('выбранное тёмное переживает перезапуск', () async {
    SharedPreferences.setMockInitialValues({'theme_mode': 'dark'});
    final container = build();

    expect((await _settled(container)).mode, ThemeMode.dark);
  });

  test('выбор сохраняется на устройстве', () async {
    SharedPreferences.setMockInitialValues({});
    final container = build();
    await _settled(container);

    await container.read(themeProvider.notifier).setMode(ThemeMode.dark);
    expect(
      (await SharedPreferences.getInstance()).getString('theme_mode'),
      'dark',
    );

    await container.read(themeProvider.notifier).setMode(ThemeMode.system);
    expect(
      (await SharedPreferences.getInstance()).getString('theme_mode'),
      'system',
    );
  });

  testWidgets('выбор темы называет варианты словами', (tester) async {
    SharedPreferences.setMockInitialValues({});
    late WidgetRef ref;

    await tester.pumpWidget(testApp(
      Consumer(builder: (context, widgetRef, _) {
        ref = widgetRef;
        return TextButton(
          onPressed: () => showThemePicker(context, ref),
          child: const Text('открыть'),
        );
      }),
    ));

    await tester.tap(find.text('открыть'));
    await tester.pumpAndSettle();

    // Раньше здесь стояли три безымянных значка — солнце, шестерёнка, луна, —
    // и подписи жили только во всплывающих подсказках, которых на телефоне не
    // бывает. Проверяющий продукт человек светлой темы просто не нашёл.
    expect(find.text('Светлая'), findsOneWidget);
    expect(find.text('Тёмная'), findsOneWidget);
    expect(find.text('Как в телефоне'), findsOneWidget);

    await tester.tap(find.text('Тёмная'));
    await tester.pumpAndSettle();

    expect(ref.read(themeProvider).mode, ThemeMode.dark);
  });
}
