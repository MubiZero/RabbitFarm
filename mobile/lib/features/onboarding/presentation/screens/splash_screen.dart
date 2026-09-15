import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../features/auth/presentation/providers/auth_provider.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/l10n/l10n_context.dart';
import '../../../../core/widgets/app_brand_mark.dart';
import '../providers/onboarding_provider.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _fade;

  /// Сколько заставка держится на экране минимум.
  ///
  /// Не пауза ради красоты, а защита от мигания: сессия из хранилища читается
  /// за десятки миллисекунд, и без нижней границы знак успевал бы мелькнуть
  /// и исчезнуть. Раньше здесь стоял таймер на полторы секунды, и его ждали
  /// все — даже когда всё было готово сразу.
  static const _minVisible = Duration(milliseconds: 400);

  /// Столько ждём инициализацию, прежде чем вести на вход: если сеть или
  /// хранилище зависли, лучше показать экран входа, чем держать человека
  /// перед логотипом.
  static const _authTimeout = Duration(seconds: 5);

  Timer? _minVisibleTimer;
  Timer? _timeoutTimer;
  ProviderSubscription<AuthState>? _authSubscription;

  bool _minTimePassed = false;
  bool _authSettled = false;
  bool _leaving = false;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: AppDuration.fast);
    _fade = CurvedAnimation(parent: _ctrl, curve: AppDuration.curve);
    _ctrl.forward();

    _minVisibleTimer = Timer(_minVisible, () {
      _minTimePassed = true;
      _leaveIfReady();
    });
    _timeoutTimer = Timer(_authTimeout, () {
      _authSettled = true;
      _leaveIfReady();
    });

    // Подписка вместо цикла с задержками: тот продолжал тикать и после ухода
    // с экрана — отменить `Future.delayed` нечем, в отличие от таймера и
    // подписки.
    _authSubscription = ref.listenManual<AuthState>(authProvider, (_, next) {
      if (next.isLoading) return;
      _authSettled = true;
      _leaveIfReady();
    }, fireImmediately: true);
  }

  Future<void> _leaveIfReady() async {
    if (_leaving || !_minTimePassed || !_authSettled || !mounted) return;
    _leaving = true;

    if (ref.read(authProvider).isAuthenticated) {
      context.go('/today');
      return;
    }

    // Знакомство показываем только тем, кто его ещё не видел: вышедшему и
    // вернувшемуся человеку те же три вопроса второй раз не нужны.
    final seen = await ref.read(onboardingSeenProvider.future);
    if (!mounted) return;
    context.go(seen ? '/login' : '/welcome');
  }

  @override
  void dispose() {
    _minVisibleTimer?.cancel();
    _timeoutTimer?.cancel();
    _authSubscription?.close();
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      body: Center(
        child: FadeTransition(
          opacity: _fade,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const AppBrandMark(size: 80),
              const SizedBox(height: 20),
              Text(
                'RabbitFarm',
                style: AppTypography.displayMd.copyWith(color: cs.onSurface),
              ),
              const SizedBox(height: 8),
              Text(
                context.l10n.splashTagline,
                style: AppTypography.bodyMd.copyWith(
                  color: cs.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
