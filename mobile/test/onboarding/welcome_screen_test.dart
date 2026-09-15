import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:mobile/core/providers/locale_provider.dart';
import 'package:mobile/features/onboarding/presentation/screens/welcome_screen.dart';
import 'package:mobile/l10n/generated/app_localizations.dart';

class _RuLocale extends LocaleNotifier {
  @override
  Future<Locale> build() async => const Locale('ru');
}

/// Знакомство уводит на регистрацию или на вход — обе точки нужны настоящими,
/// иначе переход упирается в «страница не найдена» и тест не отличит успех от
/// поломки маршрута.
Widget _app() {
  final router = GoRouter(
    initialLocation: '/welcome',
    routes: [
      GoRoute(path: '/welcome', builder: (_, __) => const WelcomeScreen()),
      GoRoute(
        path: '/register',
        builder: (_, __) => const Scaffold(body: Text('экран регистрации')),
      ),
      GoRoute(
        path: '/login',
        builder: (_, __) => const Scaffold(body: Text('экран входа')),
      ),
    ],
  );

  return ProviderScope(
    retry: (retryCount, error) => null,
    overrides: [localeProvider.overrideWith(_RuLocale.new)],
    child: MaterialApp.router(
      locale: const Locale('ru'),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: router,
    ),
  );
}

Future<void> _tap(WidgetTester tester, String label) async {
  await tester.tap(find.text(label));
  await tester.pumpAndSettle();
}

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('знакомство доводит до регистрации и запоминает ответы', (
    tester,
  ) async {
    await tester.pumpWidget(_app());
    await tester.pumpAndSettle();

    expect(find.text('RabbitFarm'), findsOneWidget);

    await _tap(tester, 'Начать');
    expect(find.text('Сколько у вас кроликов?'), findsOneWidget);

    // Ответ на вопрос с одним выбором сразу ведёт дальше: подтверждать его
    // отдельной кнопкой человеку не нужно.
    await _tap(tester, 'От 100 до 500');
    expect(find.text('Что записывать в первую очередь?'), findsOneWidget);

    await _tap(tester, 'Случки и окролы');
    await _tap(tester, 'Дальше');
    expect(find.text('Кто будет работать в приложении?'), findsOneWidget);

    await _tap(tester, 'Я и помощники');
    expect(find.text('С чего начнём'), findsOneWidget);

    // Обещание на итоге — те же шаги, что потом ждут на «Сегодня».
    expect(find.text('Записать первую случку'), findsOneWidget);
    expect(find.text('Пригласить помощника'), findsOneWidget);

    await _tap(tester, 'Создать ферму');
    expect(find.text('экран регистрации'), findsOneWidget);

    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getBool('onboarding_seen'), isTrue);
    expect(
      jsonDecode(prefs.getString('onboarding_answers')!),
      containsPair('herd_size', 'upTo500'),
    );
    expect(
      jsonDecode(prefs.getString('onboarding_answers')!),
      containsPair('crew', 'withHelpers'),
    );
  });

  testWidgets('«У меня уже есть ферма» ведёт на вход, минуя вопросы', (
    tester,
  ) async {
    await tester.pumpWidget(_app());
    await tester.pumpAndSettle();

    await _tap(tester, 'У меня уже есть ферма');

    expect(find.text('экран входа'), findsOneWidget);
    // Знакомство засчитано: человек с фермой не должен встречать эти вопросы
    // при каждом запуске.
    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getBool('onboarding_seen'), isTrue);
  });

  testWidgets('«Пропустить» уводит к итогу, а не выбрасывает из знакомства', (
    tester,
  ) async {
    await tester.pumpWidget(_app());
    await tester.pumpAndSettle();

    await _tap(tester, 'Начать');
    await _tap(tester, 'Пропустить');

    expect(find.text('С чего начнём'), findsOneWidget);
    // Ответов нет — предлагаем то, с чего ферма начинается в любом случае.
    expect(find.text('Завести клетки'), findsOneWidget);
    expect(find.text('Отметить первое кормление'), findsOneWidget);
  });

  testWidgets('назад возвращает к предыдущему вопросу с прежним ответом', (
    tester,
  ) async {
    await tester.pumpWidget(_app());
    await tester.pumpAndSettle();

    await _tap(tester, 'Начать');
    await _tap(tester, 'До 20');
    expect(find.text('Что записывать в первую очередь?'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();

    expect(find.text('Сколько у вас кроликов?'), findsOneWidget);
    // Выбранный ответ не потерян: возврат — это уточнение, а не сброс.
    expect(find.byIcon(Icons.check_circle), findsOneWidget);
  });
}
