import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Защищённое хранилище в памяти.
///
/// Настоящее ходит в платформенный канал, которого в виджет-тестах нет, а
/// `AuthNotifier` лезет за токенами прямо при создании. Раньше такая же
/// заглушка была выписана в каждом тестовом файле про авторизацию — теперь
/// одна на всех.
class FakeStorage extends FlutterSecureStorage {
  /// [initial] — что уже «лежит на устройстве» к началу теста: токены,
  /// профиль, отложенная сессия админа.
  FakeStorage([Map<String, String>? initial])
      : values = {...?initial},
        super();

  final Map<String, String> values;

  @override
  Future<String?> read({
    required String key,
    IOSOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    MacOsOptions? mOptions,
    WindowsOptions? wOptions,
  }) async =>
      values[key];

  @override
  Future<void> write({
    required String key,
    required String? value,
    IOSOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    MacOsOptions? mOptions,
    WindowsOptions? wOptions,
  }) async {
    if (value == null) {
      values.remove(key);
    } else {
      values[key] = value;
    }
  }

  @override
  Future<void> delete({
    required String key,
    IOSOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    MacOsOptions? mOptions,
    WindowsOptions? wOptions,
  }) async {
    values.remove(key);
  }
}
