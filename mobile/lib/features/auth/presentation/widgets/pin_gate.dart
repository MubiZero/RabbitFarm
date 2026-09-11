import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/auth_provider.dart';
import '../providers/pin_provider.dart';
import '../screens/pin_lock_screen.dart';

/// Замок приложения поверх всего интерфейса.
///
/// Слой, а не маршрут: закрывать нужно и тот экран, на котором человек ушёл
/// в фон, — иначе содержимое фермы мелькает под замком при возврате. По той
/// же причине он снаружи роутера (см. `main.dart`).
class PinGate extends ConsumerStatefulWidget {
  const PinGate({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<PinGate> createState() => _PinGateState();
}

class _PinGateState extends ConsumerState<PinGate>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    ref.read(pinProvider.notifier).handleLifecycle(state);
  }

  @override
  Widget build(BuildContext context) {
    final pin = ref.watch(pinProvider);
    final authenticated = ref.watch(authProvider).isAuthenticated;

    // Замок держит уже открытую сессию. Без неё показывать нечего: человек
    // и так на экране входа, а код без аккаунта ничего не разблокирует.
    final locked = pin.ready && pin.locked && authenticated;

    return Stack(
      children: [
        widget.child,
        if (locked) const PinLockScreen(),
      ],
    );
  }
}
