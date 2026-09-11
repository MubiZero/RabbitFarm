import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mobile/core/providers/api_providers.dart';
import 'package:mobile/features/auth/data/pin_repository.dart';
import 'package:mobile/features/auth/presentation/providers/pin_provider.dart';
import 'package:mobile/features/auth/presentation/screens/pin_setup_screen.dart';

import '../support/fake_storage.dart';
import '../support/test_app.dart';

/// Код быстрого входа живёт только на устройстве: сервер о нём не знает, а
/// значит и восстановить его нечем — в этом вся разница между ним и паролем.
/// Провайдер читает хранилище при создании — ждём, пока он это доделает.
Future<void> _untilReady(ProviderContainer container) async {
  for (var i = 0; i < 50; i += 1) {
    if (container.read(pinProvider).ready) return;
    await Future<void>.delayed(const Duration(milliseconds: 5));
  }
  throw StateError('PinNotifier так и не прочитал хранилище');
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('PinRepository', () {
    test('код не хранится в открытом виде', () async {
      final storage = FakeStorage();
      final repository = PinRepository(storage);

      await repository.setPin('1234');

      expect(storage.values.values, isNot(contains('1234')));
      expect(await repository.isSet(), isTrue);
    });

    test('верный код принимается, чужой — нет', () async {
      final repository = PinRepository(FakeStorage());
      await repository.setPin('1234');

      expect(await repository.verify('1234'), isTrue);
      expect(await repository.verify('4321'), isFalse);
    });

    test('одинаковые коды на двух устройствах дают разные отпечатки', () async {
      final first = FakeStorage();
      final second = FakeStorage();
      await PinRepository(first).setPin('1234');
      await PinRepository(second).setPin('1234');

      expect(first.values['pin_hash'], isNot(second.values['pin_hash']));
    });

    test('промахи считаются, верный код обнуляет счётчик', () async {
      final repository = PinRepository(FakeStorage());
      await repository.setPin('1234');

      await repository.verify('0000');
      await repository.verify('0000');
      expect(await repository.failedAttempts(), 2);

      await repository.verify('1234');
      expect(await repository.failedAttempts(), 0);
    });

    test('выход забывает код целиком', () async {
      final storage = FakeStorage();
      final repository = PinRepository(storage);
      await repository.setPin('1234');

      await repository.clear();

      expect(await repository.isSet(), isFalse);
      expect(storage.values, isEmpty);
    });
  });

  group('PinNotifier', () {
    ProviderContainer build(FakeStorage storage) {
      final container = ProviderContainer(overrides: [
        storageProvider.overrideWithValue(storage),
      ]);
      addTearDown(container.dispose);
      return container;
    }

    test('заведённый код закрывает приложение при запуске', () async {
      final storage = FakeStorage();
      await PinRepository(storage).setPin('1234');

      final container = build(storage);
      await _untilReady(container);

      final state = container.read(pinProvider);
      expect(state.ready, isTrue);
      expect(state.isSet, isTrue);
      expect(state.locked, isTrue);
    });

    test('верный код снимает замок', () async {
      final storage = FakeStorage();
      await PinRepository(storage).setPin('1234');
      final container = build(storage);
      await _untilReady(container);

      expect(await container.read(pinProvider.notifier).unlock('1234'), isTrue);
      expect(container.read(pinProvider).locked, isFalse);
    });

    test('короткий фон замок не защёлкивает', () async {
      final storage = FakeStorage();
      await PinRepository(storage).setPin('1234');
      final container = build(storage);
      await _untilReady(container);
      await container.read(pinProvider.notifier).unlock('1234');

      final notifier = container.read(pinProvider.notifier);
      notifier.handleLifecycle(AppLifecycleState.paused);
      notifier.handleLifecycle(AppLifecycleState.resumed);

      expect(container.read(pinProvider).locked, isFalse);
    });

    test('без заведённого кода приложение не закрывается', () async {
      final container = build(FakeStorage());
      await _untilReady(container);

      expect(container.read(pinProvider).locked, isFalse);
      expect(await container.read(pinProvider.notifier).shouldOfferSetup(),
          isTrue);
    });

    test('отказ от кода больше не предлагается сам', () async {
      final container = build(FakeStorage());
      await _untilReady(container);

      await container.read(pinProvider.notifier).decline();

      expect(await container.read(pinProvider.notifier).shouldOfferSetup(),
          isFalse);
    });
  });

  group('экран заведения кода', () {
    Future<ProviderContainer> pumpSetup(WidgetTester tester) async {
      // Основной сценарий: экран открылся сразу после входа по коду, и
      // после сохранения уводит на «Сегодня».
      await tester.pumpWidget(testAppWithRouter(
        const PinSetupScreen(),
        overrides: [storageProvider.overrideWithValue(FakeStorage())],
      ));
      await tester.pumpAndSettle();
      return ProviderScope.containerOf(
        tester.element(find.byType(PinSetupScreen)),
      );
    }

    Future<void> enter(WidgetTester tester, String pin) async {
      for (final digit in pin.split('')) {
        await tester.tap(find.widgetWithText(TextButton, digit));
        await tester.pump();
      }
      await tester.pumpAndSettle();
    }

    testWidgets('несовпавший повтор просит набрать заново', (tester) async {
      final container = await pumpSetup(tester);

      await enter(tester, '1234');
      await enter(tester, '9999');

      expect(find.text('Коды не совпали — попробуйте ещё раз'), findsOneWidget);
      expect(container.read(pinProvider).isSet, isFalse);
    });

    testWidgets('совпавший повтор сохраняет код', (tester) async {
      final container = await pumpSetup(tester);

      await enter(tester, '1234');
      await enter(tester, '1234');

      expect(container.read(pinProvider).isSet, isTrue);
      expect(container.read(pinProvider).locked, isFalse);
    });
  });
}
