import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mobile/features/auth/presentation/widgets/pin_pad.dart';
import 'package:mobile/l10n/generated/app_localizations.dart';

/// Замок приложения рисуется НАД навигатором (`PinGate` в main.dart), чтобы
/// содержимое фермы не мелькало под ним при возврате из фона. Цена такого
/// расположения: там нет слоя, в котором живут всплывающие подсказки, и
/// любая из них превращается в красную плашку Flutter вместо кнопки.
///
/// Тест ставит клавиатуру кода ровно в такие условия — без `Navigator` и
/// `Overlay` — и требует, чтобы она нарисовалась целиком.
void main() {
  testWidgets('клавиатура кода рисуется над навигатором, без слоя подсказок', (
    tester,
  ) async {
    var entered = '';

    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('ru'),
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        // Тот же приём, что у `PinGate`: содержимое подставляется в builder,
        // то есть выше навигатора и его слоя подсказок.
        builder: (context, _) => PinPad(
          value: entered,
          onChanged: (value) => entered = value,
        ),
        home: const SizedBox.shrink(),
      ),
    );
    await tester.pump();

    expect(tester.takeException(), isNull);
    expect(find.byIcon(Icons.backspace_outlined), findsOneWidget);

    // Подпись для голосового доступа при этом никуда не делась.
    expect(
      find.bySemanticsLabel('Стереть цифру'),
      findsOneWidget,
      reason: 'кнопка «стереть» должна оставаться названной для озвучки',
    );
  });
}
