import 'package:flutter_test/flutter_test.dart';

import 'package:mobile/core/providers/locale_provider.dart';

/// Узбекский фермер читал узбекскую страницу витрины, нажимал «Открыть
/// приложение» — и попадал в английский интерфейс: язык приложение угадывало
/// по настройкам телефона, а на дешёвом Android там английский. Витрина
/// теперь называет язык прямо в адресе.
void main() {
  test('язык страницы, с которой пришли', () {
    expect(languageFromUrl(Uri.parse('https://app.rabbitfarm.click/?lang=uz')),
        'uz');
    expect(languageFromUrl(Uri.parse('https://app.rabbitfarm.click/?lang=TG')),
        'tg');
  });

  test('без параметра решает не адрес', () {
    expect(languageFromUrl(Uri.parse('https://app.rabbitfarm.click/')), isNull);
  });

  test('чужой язык не берём', () {
    // Иначе `?lang=fr` показал бы пустые подписи вместо интерфейса.
    expect(languageFromUrl(Uri.parse('https://app.rabbitfarm.click/?lang=fr')),
        isNull);
    expect(languageFromUrl(Uri.parse('https://app.rabbitfarm.click/?lang=')),
        isNull);
  });
}
