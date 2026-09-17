import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'countries.dart';

const _kSelectedCountry = 'selected_country';

/// Страна, которую человек назвал в знакомстве.
///
/// Живёт на устройстве, а не в аккаунте, потому что спрашивают её **до**
/// регистрации: от неё зависит, предлагать ли вход по СМС и на каком языке
/// говорить. При регистрации код страны уезжает на сервер, и дальше
/// авторитетом становится хозяйство — валюту и пояс проставляет сервер.
///
/// Пока не выбрана — Таджикистан, как у всех ферм, заведённых до появления
/// этого вопроса.
class SelectedCountryNotifier extends AsyncNotifier<Country> {
  @override
  Future<Country> build() async {
    final prefs = await SharedPreferences.getInstance();
    return countryByCode(prefs.getString(_kSelectedCountry));
  }

  Future<void> select(Country country) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kSelectedCountry, country.code);
    state = AsyncData(country);
  }
}

final selectedCountryProvider =
    AsyncNotifierProvider<SelectedCountryNotifier, Country>(
  SelectedCountryNotifier.new,
);

/// Доходит ли до выбранной страны код по СМС.
///
/// Экран входа спрашивает именно это, а не саму страну: предлагать телефон
/// там, куда сообщение не уходит, — значит оставить человека ждать код,
/// которого не будет.
final smsAvailableProvider = Provider<bool>((ref) {
  final country = ref.watch(selectedCountryProvider).value;
  return country?.sms ?? true;
});
