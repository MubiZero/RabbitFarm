import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../../../core/providers/api_providers.dart';
import '../../data/pin_repository.dart';
import 'auth_provider.dart';

final pinRepositoryProvider = Provider<PinRepository>((ref) {
  return PinRepository(ref.watch(storageProvider));
});

/// Состояние замка приложения.
class PinState {
  const PinState({
    this.isSet = false,
    this.locked = false,
    this.failedAttempts = 0,
    this.ready = false,
  });

  /// Код заведён на этом устройстве.
  final bool isSet;

  /// Приложение закрыто и ждёт код.
  final bool locked;

  /// Промахов подряд — после [PinRepository.maxAttempts] сессия стирается.
  final int failedAttempts;

  /// Хранилище уже прочитано. До этого момента [locked] ещё ничего не значит,
  /// и показывать экраны нельзя: иначе между запуском и чтением диска
  /// мелькает «Сегодня» с чужими данными.
  final bool ready;

  PinState copyWith({
    bool? isSet,
    bool? locked,
    int? failedAttempts,
    bool? ready,
  }) {
    return PinState(
      isSet: isSet ?? this.isSet,
      locked: locked ?? this.locked,
      failedAttempts: failedAttempts ?? this.failedAttempts,
      ready: ready ?? this.ready,
    );
  }
}

/// Замок на приложении.
///
/// Код проверяется на самом устройстве (см. [PinRepository]) — сеть для этого
/// не нужна, и в сарае без связи телефон открывается так же быстро, как дома.
class PinNotifier extends StateNotifier<PinState> {
  PinNotifier(this._ref) : super(const PinState()) {
    _restore();
  }

  final Ref _ref;

  /// Сколько приложение может пробыть в фоне, не спрашивая код. Меньше —
  /// и человек вводит код после каждого взгляда на часы; больше — телефон,
  /// оставленный на столе, слишком долго остаётся открытым.
  static const lockAfterBackground = Duration(minutes: 5);

  DateTime? _backgroundedAt;

  PinRepository get _repository => _ref.read(pinRepositoryProvider);

  Future<void> _restore() async {
    final isSet = await _repository.isSet();
    final attempts = await _repository.failedAttempts();
    if (!mounted) return;
    state = PinState(
      isSet: isSet,
      // Запуск приложения — всегда повод спросить код, если он заведён.
      locked: isSet,
      failedAttempts: attempts,
      ready: true,
    );
  }

  Future<void> setPin(String pin) async {
    await _repository.setPin(pin);
    if (!mounted) return;
    state = state.copyWith(isSet: true, locked: false, failedAttempts: 0);
  }

  /// Отказ от кода на этом входе — предложение больше не показывается,
  /// включить можно в Настройках.
  Future<void> decline() => _repository.markDeclined();

  Future<bool> shouldOfferSetup() async {
    if (await _repository.isSet()) return false;
    return !await _repository.wasDeclined();
  }

  /// Проверить введённый код. Вернёт `false` при промахе; когда промахов
  /// накопилось [PinRepository.maxAttempts], сессия стирается — дальше вход
  /// только по коду из SMS или письма.
  Future<bool> unlock(String pin) async {
    final ok = await _repository.verify(pin);
    if (!mounted) return ok;

    if (ok) {
      state = state.copyWith(locked: false, failedAttempts: 0);
      return true;
    }

    final attempts = await _repository.failedAttempts();
    if (!mounted) return false;
    state = state.copyWith(failedAttempts: attempts);

    if (attempts >= PinRepository.maxAttempts) {
      await forgetAndSignOut();
    }
    return false;
  }

  /// «Забыли код» и исчерпанные попытки ведут в одно место: выход из
  /// аккаунта. Код восстанавливать нечем — он живёт только здесь.
  Future<void> forgetAndSignOut() async {
    await _repository.clear();
    await _ref.read(authProvider.notifier).logout();
    if (!mounted) return;
    state = const PinState(ready: true);
  }

  /// Выключить код в Настройках.
  Future<void> disable() async {
    await _repository.clear();
    if (!mounted) return;
    state = const PinState(ready: true);
  }

  /// Приложение ушло в фон или вернулось. Замок защёлкивается не сразу:
  /// человек кладёт телефон в карман между двумя записями о кормлении
  /// десятки раз за день.
  void handleLifecycle(AppLifecycleState lifecycle) {
    if (!state.isSet) return;

    if (lifecycle == AppLifecycleState.resumed) {
      final since = _backgroundedAt;
      _backgroundedAt = null;
      if (since != null &&
          DateTime.now().difference(since) >= lockAfterBackground) {
        state = state.copyWith(locked: true);
      }
      return;
    }

    if (lifecycle == AppLifecycleState.paused ||
        lifecycle == AppLifecycleState.hidden) {
      _backgroundedAt ??= DateTime.now();
    }
  }
}

final pinProvider = StateNotifierProvider<PinNotifier, PinState>((ref) {
  return PinNotifier(ref);
});
