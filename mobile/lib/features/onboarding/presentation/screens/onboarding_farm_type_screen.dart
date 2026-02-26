import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/onboarding_provider.dart';
import '../widgets/onboarding_progress.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

class OnboardingFarmTypeScreen extends ConsumerStatefulWidget {
  const OnboardingFarmTypeScreen({super.key});

  @override
  ConsumerState<OnboardingFarmTypeScreen> createState() =>
      _OnboardingFarmTypeScreenState();
}

class _OnboardingFarmTypeScreenState
    extends ConsumerState<OnboardingFarmTypeScreen> {
  String? _selected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 24),
              const OnboardingProgress(current: 2, total: 2),
              const Spacer(flex: 2),
              Text(
                'Как вы управляете\nфермой?',
                style: AppTypography.displayMd.copyWith(
                  color: AppColors.darkTextPrimary,
                ),
              ),
              const SizedBox(height: 32),
              _TypeCard(
                icon: Icons.person,
                title: 'Один хозяин',
                subtitle: 'Я управляю фермой самостоятельно',
                selected: _selected == 'solo',
                onTap: () => setState(() => _selected = 'solo'),
              ),
              const SizedBox(height: 12),
              _TypeCard(
                icon: Icons.group,
                title: 'Команда',
                subtitle: 'У меня есть сотрудники с разными ролями',
                selected: _selected == 'team',
                onTap: () => setState(() => _selected = 'team'),
              ),
              const Spacer(flex: 3),
              ElevatedButton(
                onPressed: _selected != null ? _next : null,
                child: const Text('Далее'),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => context.go('/onboarding/ready'),
                child: Text(
                  'Пропустить',
                  style: AppTypography.labelLg.copyWith(
                    color: AppColors.darkTextSecondary,
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
    await ref.read(onboardingProvider.notifier).saveFarmType(_selected!);
    if (mounted) context.go('/onboarding/ready');
  }
}

class _TypeCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  const _TypeCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final accent = Theme.of(context).colorScheme.primary;
    final surface = Theme.of(context).colorScheme.surface;
    final border = selected ? accent : Theme.of(context).colorScheme.outline;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: selected ? accent.withValues(alpha: 0.08) : surface,
          border: Border.all(color: border, width: selected ? 2 : 1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: (selected ? accent : AppColors.darkTextSecondary)
                    .withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon,
                  color: selected ? accent : AppColors.darkTextSecondary),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: AppTypography.titleMd.copyWith(
                        color: selected
                            ? accent
                            : AppColors.darkTextPrimary,
                      )),
                  Text(subtitle,
                      style: AppTypography.bodyMd.copyWith(
                        color: AppColors.darkTextSecondary,
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
