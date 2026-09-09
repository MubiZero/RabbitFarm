import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mobile/core/error/error_handling.dart';
import 'package:mobile/core/widgets/widgets.dart';

import '../support/test_app.dart';

/// Проверки про то, что ошибка не пропадает молча и не показывается фермеру
/// служебным экраном Flutter.

void main() {
  group('AppCrashView', () {
    testWidgets('внутри приложения берёт текст из переводов', (tester) async {
      await tester.pumpWidget(testApp(const AppCrashView()));
      await tester.pumpAndSettle();

      expect(find.text('Что-то пошло не так'), findsOneWidget);
    });

    testWidgets('без Localizations и Directionality всё равно собирается',
        (tester) async {
      // Настоящий случай: упал сам каркас приложения, и заглушка оказывается
      // выше делегатов переводов. Вторая ошибка тут означала бы бесконечный
      // цикл вместо экрана.
      await tester.pumpWidget(const AppCrashView());
      await tester.pump();

      expect(tester.takeException(), isNull);
      expect(find.text('Что-то пошло не так'), findsOneWidget);
    });
  });

  group('installErrorHandlers', () {
    late void Function(FlutterErrorDetails)? originalFlutterOnError;
    late ErrorCallback? originalPlatformOnError;
    late ErrorWidgetBuilder originalErrorWidgetBuilder;

    setUp(() {
      originalFlutterOnError = FlutterError.onError;
      originalPlatformOnError = PlatformDispatcher.instance.onError;
      originalErrorWidgetBuilder = ErrorWidget.builder;
    });

    tearDown(() {
      FlutterError.onError = originalFlutterOnError;
      PlatformDispatcher.instance.onError = originalPlatformOnError;
      ErrorWidget.builder = originalErrorWidgetBuilder;
    });

    test('ошибка мимо Flutter перехватывается и не роняет процесс', () {
      installErrorHandlers();

      final handled = PlatformDispatcher.instance.onError!(
        Exception('фоновый запрос упал'),
        StackTrace.empty,
      );

      expect(handled, isTrue);
    });

    test('красный экран Flutter в отладке остаётся нетронутым', () {
      // В отладке подробности сборки нужнее аккуратной заглушки, подмена
      // включается только в релизе.
      installErrorHandlers();

      expect(ErrorWidget.builder, same(originalErrorWidgetBuilder));
    });
  });
}
