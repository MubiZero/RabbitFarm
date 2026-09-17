import 'package:flutter/widgets.dart';

import '../utils/format_utils.dart';
import 'countries.dart';

/// Валюта хозяйства — на весь экран сразу.
///
/// Суммы показываются в двух десятках мест, и протаскивать валюту в каждое
/// через параметры значило бы, что где-то её забудут: часть экранов считала
/// бы в сомони, часть — в сумах, и доверие к числам кончилось бы быстрее,
/// чем нашлась причина.
///
/// Обратите внимание: это валюта **хозяйства**, а не сервиса. Тарифы,
/// которые ферма платит нам, считаются в сомони всегда — там валюта другая
/// и берётся не отсюда.
class FarmCurrencyScope extends InheritedWidget {
  /// Знак валюты хозяйства. Пока профиль не загружен — таджикский, как было
  /// до появления выбора страны.
  final String symbol;

  const FarmCurrencyScope({
    super.key,
    required this.symbol,
    required super.child,
  });

  static String of(BuildContext context) {
    final scope =
        context.dependOnInheritedWidgetOfExactType<FarmCurrencyScope>();
    return scope?.symbol ?? kCurrencySymbol;
  }

  @override
  bool updateShouldNotify(FarmCurrencyScope oldWidget) =>
      oldWidget.symbol != symbol;
}

/// Короткий доступ к деньгам хозяйства: `context.money(1250)` → «1 250 с».
///
/// Тот же приём, что и `context.l10n`: длинная форма обходится стороной, и
/// рядом с ней заводят самодельную.
extension FarmMoneyContext on BuildContext {
  /// Знак валюты хозяйства — для суффиксов и подписей полей ввода.
  String get currencySymbol => FarmCurrencyScope.of(this);

  /// Сумма в валюте хозяйства с разделителями разрядов.
  String money(num amount) => formatMoney(amount, currencySymbol);
}

/// Знак валюты по ISO-коду хозяйства — для мест, где виджета рядом нет.
String symbolForCurrency(String? currencyCode) =>
    currencySymbolByCode(currencyCode);
