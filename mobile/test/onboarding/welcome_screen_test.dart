import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:mobile/core/providers/locale_provider.dart';
import 'package:mobile/features/subscription/data/models/plan_option.dart';
import 'package:mobile/features/subscription/presentation/providers/plans_provider.dart';
import 'package:mobile/features/onboarding/presentation/screens/welcome_screen.dart';
import 'package:mobile/l10n/generated/app_localizations.dart';

class _RuLocale extends LocaleNotifier {
  @override
  Future<Locale> build() async => const Locale('ru');
}

/// Знакомство уводит на регистрацию или на вход — обе точки нужны настоящими,
/// иначе переход упирается в «страница не найдена» и тест не отличит успех от
/// поломки маршрута.
Widget _app({List<PlanOption> plans = const []}) {
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
    overrides: [
      localeProvider.overrideWith(_RuLocale.new),
      // Тарифы в тесте подменяем: без списка шаг с ценой пропускается, и
      // знакомство ведёт прямо на регистрацию — как при недоступной сети.
      plansProvider.overrideWith((ref) async => plans),
    ],
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

    // Первым делом — страна: от неё зависят валюта, часовой пояс и то,
    // предлагать ли вход по СМС, поэтому спрашивают её раньше всего.
    expect(find.text('Где ваше хозяйство?'), findsOneWidget);
    await _tap(tester, 'Таджикистан');

    // Второй вопрос — светлая или тёмная. Экран этого приложения читают во
    // дворе на солнце, и ответ применяется сразу: остаток знакомства человек
    // видит уже в выбранном виде.
    expect(find.text('Как показывать экран?'), findsOneWidget);
    await _tap(tester, 'Светлая');

    expect(find.text('Сколько у вас кроликов?'), findsOneWidget);

    // Ответ на вопрос с одним выбором сразу ведёт дальше: подтверждать его
    // отдельной кнопкой человеку не нужно.
    await _tap(tester, 'От 100 до 500');
    expect(find.text('Что записывать в первую очередь?'), findsOneWidget);

    await _tap(tester, 'Случки и окролы');
    await _tap(tester, 'Дальше');
    expect(find.text('Кто будет работать в приложении?'), findsOneWidget);

    await _tap(tester, 'Небольшая команда');
    expect(find.text('С чего начнём'), findsOneWidget);

    // Обещание на итоге — те же шаги, что потом ждут на «Сегодня».
    expect(find.text('Записать первую случку'), findsOneWidget);
    expect(find.text('Пригласить помощника'), findsOneWidget);

    await _tap(tester, 'Создать ферму');
    expect(find.text('экран регистрации'), findsOneWidget);

    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getBool('onboarding_seen'), isTrue);
    // Страну регистрация отправит на сервер — из неё выводятся валюта
    // хозяйства и часовой пояс.
    expect(prefs.getString('selected_country'), 'TJ');
    expect(prefs.getString('theme_mode'), 'light',
        reason: 'ответ про вид экрана должен пережить закрытие приложения');
    expect(
      jsonDecode(prefs.getString('onboarding_answers')!),
      containsPair('herd_size', 'upTo500'),
    );
    expect(
      jsonDecode(prefs.getString('onboarding_answers')!),
      containsPair('crew', 'team'),
    );
  });

  testWidgets('«Войти» ведёт на вход, минуя вопросы', (tester) async {
    await tester.pumpWidget(_app());
    await tester.pumpAndSettle();

    // Кнопка называется «Войти»: человек с аккаунтом ищет глазами это слово,
    // а не рассказ про ферму.
    await _tap(tester, 'Войти');

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
    await _tap(tester, 'Таджикистан');
    await _tap(tester, 'Светлая');
    await _tap(tester, 'До 20');
    expect(find.text('Что записывать в первую очередь?'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();

    expect(find.text('Сколько у вас кроликов?'), findsOneWidget);
    // Выбранный ответ не потерян: возврат — это уточнение, а не сброс.
    expect(find.byIcon(Icons.check_circle), findsOneWidget);
  });

  testWidgets('страна подсказывает валюту и способ входа до регистрации', (
    tester,
  ) async {
    await tester.pumpWidget(_app());
    await tester.pumpAndSettle();

    await _tap(tester, 'Начать');

    // Последствия выбора видно сразу, а не после регистрации — и словами, а
    // не записью «с · Телефон», понятной только нам.
    expect(find.text('Код для входа придёт в SMS'), findsOneWidget);
    expect(find.text('Код для входа придёт на почту'), findsWidgets);

    await _tap(tester, 'Узбекистан');
    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getString('selected_country'), 'UZ');
  });

  testWidgets('в конце знакомства показан подобранный тариф', (tester) async {
    await tester.pumpWidget(_app(plans: const [
      PlanOption(id: 1, name: 'Бесплатный', maxRabbits: 20, maxStaff: 1, price: 0),
      PlanOption(id: 2, name: 'Малый', maxRabbits: 120, maxStaff: 2, price: 45),
    ]));
    await tester.pumpAndSettle();

    await _tap(tester, 'Начать');
    await _tap(tester, 'Таджикистан');
    await _tap(tester, 'Светлая');
    await _tap(tester, 'От 20 до 100');
    await _tap(tester, 'Случки и окролы');
    await _tap(tester, 'Дальше');
    await _tap(tester, 'Только я');
    expect(find.text('С чего начнём'), findsOneWidget);

    await _tap(tester, 'Создать ферму');

    // Про деньги владелец хозяйства спрашивает первым, а узнавал последним —
    // уже заведя ферму и записав триста кроликов.
    expect(find.text('Под ваше хозяйство подходит'), findsOneWidget);
    expect(find.text('Малый'), findsOneWidget);
    expect(find.text('До 120 кроликов'), findsOneWidget);
    expect(find.text('До 2 человек в приложении'), findsOneWidget,
        reason: 'не «до 2 работников»: число и слово должны согласоваться');
    expect(find.text('Бесплатный'), findsOneWidget,
        reason: 'другие тарифы видно тоже — выбор не должен выглядеть навязанным');

    // Подобранный тариф — подсказка, а не приговор: другой выбирается
    // нажатием, и выбор запоминается рядом с остальными ответами.
    await tester.ensureVisible(find.text('Бесплатный'));
    await tester.pumpAndSettle();
    await _tap(tester, 'Бесплатный');
    expect(find.text('Вам хватит бесплатного'), findsOneWidget);

    await _tap(tester, 'Завести ферму');
    expect(find.text('экран регистрации'), findsOneWidget);

    final prefs = await SharedPreferences.getInstance();
    expect(
      jsonDecode(prefs.getString('onboarding_answers')!),
      containsPair('wanted_plan', 'Бесплатный'),
    );
  });

  testWidgets('без тарифов знакомство ведёт прямо на регистрацию',
      (tester) async {
    await tester.pumpWidget(_app());
    await tester.pumpAndSettle();

    await _tap(tester, 'Начать');
    await _tap(tester, 'Пропустить');
    await _tap(tester, 'Создать ферму');

    // Список цен не должен становиться стеной между человеком и фермой.
    expect(find.text('экран регистрации'), findsOneWidget);
  });
}
