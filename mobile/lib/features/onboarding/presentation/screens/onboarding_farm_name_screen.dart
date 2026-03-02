import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/onboarding_provider.dart';
import '../widgets/onboarding_progress.dart';
import '../../../../core/theme/app_typography.dart';

class OnboardingFarmNameScreen extends ConsumerStatefulWidget {
  const OnboardingFarmNameScreen({super.key});

  @override
  ConsumerState<OnboardingFarmNameScreen> createState() =>
      _OnboardingFarmNameScreenState();
}

class _OnboardingFarmNameScreenState
    extends ConsumerState<OnboardingFarmNameScreen> {
  final _ctrl = TextEditingController();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 24),
              const OnboardingProgress(current: 1, total: 2),
              const Spacer(flex: 2),
              Text(
                'Как называется\nваша ферма?',
                style: AppTypography.displayMd.copyWith(
                  color: cs.onSurface,
                ),
              ),
              const SizedBox(height: 32),
              TextField(
                controller: _ctrl,
                autofocus: true,
                style: AppTypography.bodyLg.copyWith(
                  color: cs.onSurface,
                ),
                decoration: const InputDecoration(
                  hintText: 'Например: Ферма "Берёзки"',
                ),
                onSubmitted: (_) => _next(),
              ),
              const Spacer(flex: 3),
              ElevatedButton(
                onPressed: _next,
                child: const Text('Далее'),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => context.go('/onboarding/farm-type'),
                child: Text(
                  'Пропустить',
                  style: AppTypography.labelLg.copyWith(
                    color: cs.onSurfaceVariant,
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _next() async {
    if (_ctrl.text.isNotEmpty) {
      await ref.read(onboardingProvider.notifier).saveFarmName(_ctrl.text.trim());
    }
    if (mounted) context.go('/onboarding/farm-type');
  }
}
