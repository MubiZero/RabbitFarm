import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/onboarding_provider.dart';
import '../../../../features/auth/presentation/providers/auth_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _ctrl.forward();
    _navigate();
  }

  Future<void> _navigate() async {
    await Future.delayed(const Duration(milliseconds: 1500));
    if (!mounted) return;

    // Ждём окончания инициализации аутентификации (максимум 5 секунд)
    int waitedMs = 0;
    while (ref.read(authProvider).isLoading && waitedMs < 5000) {
      await Future.delayed(const Duration(milliseconds: 50));
      waitedMs += 50;
      if (!mounted) return;
    }

    final authState = ref.read(authProvider);
    final onboarding = await ref.read(onboardingProvider.future);

    if (!mounted) return;

    if (authState.isAuthenticated) {
      context.go('/today');
    } else if (!onboarding.isDone) {
      context.go('/onboarding');
    } else {
      context.go('/login');
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: Center(
        child: FadeTransition(
          opacity: _fade,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.accentEmerald.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.pets,
                  size: 40,
                  color: AppColors.accentEmerald,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'RabbitFarm',
                style: AppTypography.displayMd.copyWith(
                  color: AppColors.darkTextPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Управление фермой',
                style: AppTypography.bodyMd.copyWith(
                  color: AppColors.darkTextSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
