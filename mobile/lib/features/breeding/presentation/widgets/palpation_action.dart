import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/l10n/error_text.dart';
import '../../../../core/l10n/l10n_context.dart';
import '../../../../core/theme/theme.dart';
import '../../../rabbits/data/models/breeding_model.dart';
import '../providers/breeding_provider.dart';

/// Спросить результат прощупывания и отправить его на сервер.
///
/// Сервер по `is_pregnant` сам переводит самку в «беременна» или возвращает её
/// в работу, а лента цикла по этим же полям решает, что делать дальше. До сих
/// пор их нельзя было заполнить ниоткуда: задача «Прощупать» приходила, фермер
/// щупал, а записать результат было негде.
///
/// Возвращает `true`, если результат ушёл на сервер, — вызвавшему экрану
/// остаётся обновить свои данные.
Future<bool> recordPalpation(
  BuildContext context,
  WidgetRef ref,
  BreedingModel breeding,
) async {
  final pregnant = await showModalBottomSheet<bool>(
    context: context,
    showDragHandle: true,
    builder: (_) => const _PalpationSheet(),
  );
  if (pregnant == null || !context.mounted) return false;

  final messenger = ScaffoldMessenger.of(context);
  final l10n = context.l10n;
  final notifier = ref.read(breedingListProvider.notifier);

  final ok = await notifier.updateBreeding(breeding.id, {
    'palpation_date': DateTime.now().toIso8601String().split('T').first,
    'is_pregnant': pregnant,
  });

  messenger.showSnackBar(
    ok
        ? SnackBar(
            content: Text(
              pregnant
                  ? l10n.cyclePalpationSavedPregnant
                  : l10n.cyclePalpationSavedEmpty,
            ),
          )
        : SnackBar(
            content: Text(
              l10n.commonActionFailed(
                errorText(l10n, ref.read(breedingListProvider).error),
              ),
            ),
            backgroundColor: AppColors.error,
          ),
  );

  return ok;
}

/// Сукрольная или пустая.
///
/// Два варианта во всю ширину и с подписью про последствие: фермер выбирает не
/// между словами, а между «впереди окрол» и «самку можно крыть заново».
class _PalpationSheet extends StatelessWidget {
  const _PalpationSheet();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.xl,
          AppSpacing.sm,
          AppSpacing.xl,
          AppSpacing.xl,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l10n.cyclePalpationTitle, style: context.text.headlineSmall),
            const SizedBox(height: AppSpacing.lg),
            _Choice(
              icon: Icons.check_circle_outline,
              color: AppColors.success,
              label: l10n.cyclePalpationPregnant,
              hint: l10n.cyclePalpationPregnantHint,
              onTap: () => Navigator.of(context).pop(true),
            ),
            const SizedBox(height: AppSpacing.md),
            _Choice(
              icon: Icons.remove_circle_outline,
              color: AppColors.warning,
              label: l10n.cyclePalpationEmpty,
              hint: l10n.cyclePalpationEmptyHint,
              onTap: () => Navigator.of(context).pop(false),
            ),
          ],
        ),
      ),
    );
  }
}

class _Choice extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final String hint;
  final VoidCallback onTap;

  const _Choice({
    required this.icon,
    required this.color,
    required this.label,
    required this.hint,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        minimumSize: const Size.fromHeight(AppSizes.touchTargetLarge),
        padding: const EdgeInsets.all(AppSpacing.lg),
        alignment: Alignment.centerLeft,
        foregroundColor: color,
        side: BorderSide(color: color),
      ),
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: AppTypography.titleMd.copyWith(color: color),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  hint,
                  style: AppTypography.labelSm.copyWith(
                    color: context.colors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
