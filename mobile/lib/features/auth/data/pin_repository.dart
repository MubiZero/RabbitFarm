import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Короткий код, которым закрывается приложение на этом телефоне.
///
/// Это не пароль от аккаунта: сервер о нём не знает и знать не должен. Вход в
/// аккаунт всегда идёт по коду из SMS или письма, а ПИН лишь разблокирует уже
/// выданную сессию на конкретном устройстве — поэтому четырёх цифр достаточно:
/// подобрать их можно только держа телефон в руках, а после пяти промахов
/// сессия стирается совсем.
///
/// Хранится не сам код, а его отпечаток со случайной солью: заглянувший в
/// хранилище не прочитает код, которым человек, возможно, пользуется и в
/// других местах.
class PinRepository {
  PinRepository(this._storage);

  final FlutterSecureStorage _storage;

  static const pinLength = 4;

  /// Столько промахов подряд считаем не опечаткой, а чужими руками.
  static const maxAttempts = 5;

  static const _hashKey = 'pin_hash';
  static const _saltKey = 'pin_salt';
  static const _attemptsKey = 'pin_failed_attempts';
  static const _declinedKey = 'pin_declined';

  Future<bool> isSet() async => await _storage.read(key: _hashKey) != null;

  /// Человек уже отказывался заводить код — больше не предлагаем на каждом
  /// входе. Включить можно в Настройках.
  Future<bool> wasDeclined() async =>
      await _storage.read(key: _declinedKey) == '1';

  Future<void> markDeclined() =>
      _storage.write(key: _declinedKey, value: '1');

  Future<void> setPin(String pin) async {
    final salt = _generateSalt();
    await _storage.write(key: _saltKey, value: salt);
    await _storage.write(key: _hashKey, value: _hash(pin, salt));
    await _storage.delete(key: _attemptsKey);
    await _storage.delete(key: _declinedKey);
  }

  /// Проверить код. Возвращает `true` при совпадении и сбрасывает счётчик
  /// промахов; при промахе счётчик растёт — его читает [failedAttempts].
  Future<bool> verify(String pin) async {
    final hash = await _storage.read(key: _hashKey);
    final salt = await _storage.read(key: _saltKey);
    if (hash == null || salt == null) return false;

    if (_hash(pin, salt) == hash) {
      await _storage.delete(key: _attemptsKey);
      return true;
    }

    final attempts = await failedAttempts();
    await _storage.write(key: _attemptsKey, value: '${attempts + 1}');
    return false;
  }

  Future<int> failedAttempts() async {
    final raw = await _storage.read(key: _attemptsKey);
    return int.tryParse(raw ?? '') ?? 0;
  }

  /// Забыть код — при выходе из аккаунта и при смене человека на общем
  /// планшете фермы.
  Future<void> clear() async {
    await _storage.delete(key: _hashKey);
    await _storage.delete(key: _saltKey);
    await _storage.delete(key: _attemptsKey);
    await _storage.delete(key: _declinedKey);
  }

  String _generateSalt() {
    final random = Random.secure();
    final bytes = List<int>.generate(16, (_) => random.nextInt(256));
    return base64Url.encode(bytes);
  }

  String _hash(String pin, String salt) =>
      sha256.convert(utf8.encode('$salt:$pin')).toString();
}
