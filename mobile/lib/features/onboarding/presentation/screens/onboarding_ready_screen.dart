import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/onboarding_provider.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/l10n/l10n_context.dart';

class OnboardingReadyScreen extends ConsumerWidget {
  const OnboardingReadyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final onboarding = ref.watch(onboardingProvider).value;
    // Без названия фраза не должна изображать название: «"ваша ферма"
    // готова к работе!» читалось так, будто ферму действительно так зовут.
    final farmName =
        onboarding?.farmName.trim().isNotEmpty == true ? onboarding!.farmName.trim() : null;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(flex: 2),
              Center(
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: cs.primaryContainer,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check_circle_outline,
                    size: 56,
                    color: cs.primary,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Text(
                farmName == null
                    ? context.l10n.onboardReadyPlain
                    : context.l10n.onboardReadyNamed(farmName),
                style: AppTypography.displayMd.copyWith(
                  color: cs.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                context.l10n.onboardReadyBody,
                style: AppTypography.bodyLg.copyWith(
                  color: cs.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              const Spacer(flex: 3),
              ElevatedButton(
                onPressed: () async {
                  await ref.read(onboardingProvider.notifier).completeOnboarding();
                  if (context.mounted) context.go('/register');
                },
                child: Text(context.l10n.onboardRegister),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () async {
                  await ref.read(onboardingProvider.notifier).completeOnboarding();
                  if (context.mounted) context.go('/login');
                },
                child: Text(
                  context.l10n.onboardHaveAccount,
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
}
