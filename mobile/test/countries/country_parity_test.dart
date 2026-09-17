import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/countries/countries.dart';

/// Список стран живёт в двух местах: приложение носит его с собой, потому что
/// страну спрашивают на первом экране — до всякой сети, — а сервер решает по
/// нему, какую валюту и пояс проставить хозяйству.
///
/// Два списка обязаны совпадать. Расходятся такие пары тихо: страну добавляют
/// в приложение, регистрация уходит с кодом, которого сервер не знает, и
/// хозяйство молча заводится таджикским.
void main() {
  final source = File('../backend/src/config/countries.js');

  Map<String, Map<String, String>> serverCountries() {
    final text = source.readAsStringSync();

    // Достаём только тело COUNTRIES: разбирать JS целиком незачем, нужен
    // список кодов и то, что от них зависит.
    final entries = RegExp(
      r"(\w{2}):\s*\{\s*code:\s*'(\w{2})',\s*currency:\s*'(\w{3})',"
      r"\s*timezone:\s*'([^']+)',\s*phonePrefix:\s*'([^']+)',"
      r"\s*language:\s*'(\w+)',\s*sms:\s*(true|false),"
      r"\s*payments:\s*(true|false)",
      multiLine: true,
    ).allMatches(text);

    return {
      for (final m in entries)
        m.group(2)!: {
          'currency': m.group(3)!,
          'phonePrefix': m.group(5)!,
          'language': m.group(6)!,
          'sms': m.group(7)!,
          'payments': m.group(8)!,
        }
    };
  }

  test('справочник стран сервера существует и разбирается', () {
    expect(source.existsSync(), isTrue,
        reason: 'не найден backend/src/config/countries.js');
    expect(serverCountries(), isNotEmpty,
        reason: 'не удалось разобрать COUNTRIES — изменился формат файла');
  });

  test('коды стран совпадают с серверными', () {
    final server = serverCountries().keys.toSet();
    final app = kCountries.map((c) => c.code).toSet();

    expect(app.difference(server), isEmpty,
        reason: 'в приложении есть страны, которых сервер не знает — '
            'регистрация заведёт такое хозяйство таджикским');
    expect(server.difference(app), isEmpty,
        reason: 'сервер знает страны, которых нет в приложении — выбрать их '
            'человеку негде');
  });

  test('валюта, префикс телефона и доступность СМС совпадают', () {
    final server = serverCountries();

    for (final country in kCountries) {
      final theirs = server[country.code]!;

      expect(country.currencyCode, theirs['currency'],
          reason: 'валюта ${country.code} разошлась');
      expect(country.phonePrefix, theirs['phonePrefix'],
          reason: 'префикс телефона ${country.code} разошёлся');
      expect(country.defaultLanguage, theirs['language'],
          reason: 'язык по умолчанию ${country.code} разошёлся');

      // Самое важное: если приложение считает, что СМС дойдёт, а сервер — что
      // нет, человек увидит вход по телефону и будет ждать код, которого не
      // будет.
      expect(country.sms.toString(), theirs['sms'],
          reason: 'доступность СМС ${country.code} разошлась');
      expect(country.payments.toString(), theirs['payments'],
          reason: 'доступность оплаты ${country.code} разошлась');
    }
  });
}
