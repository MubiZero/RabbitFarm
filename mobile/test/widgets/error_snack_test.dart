import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mobile/core/widgets/app_snack.dart';

/// Плашки Material висят не на экране, а над всем приложением: человек уходил
/// с формы в другой раздел, а красная надпись про несохранённую запись ехала
/// с ним и пугала уже там, где ничего не ломалось.
void main() {
  Widget app(GlobalKey<NavigatorState> navigator) => MaterialApp(
        navigatorKey: navigator,
        navigatorObservers: [ErrorSnackObserver()],
        home: Builder(
          builder: (context) => Scaffold(
            body: Column(
              children: [
                TextButton(
                  onPressed: () =>
                      ScaffoldMessenger.of(context).showError('Не сохранилось'),
                  child: const Text('ошибка'),
                ),
                TextButton(
                  onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Клетка добавлена')),
                  ),
                  child: const Text('успех'),
                ),
              ],
            ),
          ),
        ),
      );

  testWidgets('ошибка не уезжает на следующий экран', (tester) async {
    final navigator = GlobalKey<NavigatorState>();
    await tester.pumpWidget(app(navigator));

    await tester.tap(find.text('ошибка'));
    await tester.pumpAndSettle();
    expect(find.text('Не сохранилось'), findsOneWidget);

    navigator.currentState!.push(
      MaterialPageRoute<void>(builder: (_) => const Scaffold(body: Text('дальше'))),
    );
    await tester.pumpAndSettle();

    expect(find.text('Не сохранилось'), findsNothing,
        reason: 'ошибка была про то, что человек делал на прошлом экране');
  });

  testWidgets('подтверждение переживает возврат назад', (tester) async {
    final navigator = GlobalKey<NavigatorState>();
    await tester.pumpWidget(app(navigator));

    // Подтверждения показывают как раз перед возвратом со свежей формы:
    // увидеть «Клетка добавлена» человек должен уже на списке.
    await tester.tap(find.text('успех'));
    await tester.pump();

    navigator.currentState!.push(
      MaterialPageRoute<void>(builder: (_) => const Scaffold(body: Text('дальше'))),
    );
    await tester.pumpAndSettle();

    expect(find.text('Клетка добавлена'), findsOneWidget);
  });
}
