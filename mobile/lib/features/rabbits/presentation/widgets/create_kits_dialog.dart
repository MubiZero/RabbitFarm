import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/l10n/l10n_context.dart';
import '../../../../core/theme/theme.dart';
import '../../data/models/birth_model.dart';
import '../providers/births_provider.dart';
import '../providers/rabbits_provider.dart';

/// Заводит карточки на крольчат из записи об окроле.
///
/// Один и тот же диалог был описан дважды — в списке окролов и в форме
/// окрола, — и копии успели разойтись в подписях и в подсказке про клички.
class CreateKitsDialog extends ConsumerStatefulWidget {
  final BirthModel birth;

  /// Начало клички по умолчанию: обычно это имя матери.
  final String defaultPrefix;

  /// Порода матери, чтобы крольчата не заводились без породы.
  final int? breedId;

  const CreateKitsDialog({
    super.key,
    required this.birth,
    required this.defaultPrefix,
    this.breedId,
  });

  @override
  ConsumerState<CreateKitsDialog> createState() => _CreateKitsDialogState();
}

class _CreateKitsDialogState extends ConsumerState<CreateKitsDialog> {
  late final TextEditingController _prefix;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _prefix = TextEditingController(text: widget.defaultPrefix);
  }

  @override
  void dispose() {
    _prefix.dispose();
    super.dispose();
  }

  Future<void> _create() async {
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    final created = context.l10n.birthsKitsCreated;
    final failed = context.l10n.birthsKitsFailed;

    setState(() => _busy = true);
    final kits = await ref.read(birthsProvider.notifier).createKitsFromBirth(
          birthId: widget.birth.id,
          motherId: widget.birth.motherId,
          fatherId: null,
          breedId: widget.breedId,
          birthDate: widget.birth.birthDate,
          count: widget.birth.kitsBornAlive,
          namePrefix: _prefix.text.trim(),
        );
    if (mounted) setState(() => _busy = false);

    if (kits == null) {
      messenger.showSnackBar(
        SnackBar(
          content: Text(ref.read(birthsProvider).error ?? failed),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    await ref.read(rabbitsListProvider.notifier).refresh();
    navigator.pop(true);
    messenger.showSnackBar(SnackBar(content: Text(created(kits.length))));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final prefix = _prefix.text.trim();

    return AlertDialog(
      title: Text(l10n.birthsKitsDialogTitle),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.birthsKitsDialogBody(widget.birth.kitsBornAlive),
            style: AppTypography.bodyLg
                .copyWith(color: context.colors.onSurface),
          ),
          const SizedBox(height: AppSpacing.lg),
          TextField(
            controller: _prefix,
            decoration: InputDecoration(
              labelText: l10n.birthsNamePrefix,
              hintText: l10n.birthsNamePrefixHint,
            ),
            // Пример обновляется по мере набора: иначе непонятно, что
            // получится из введённого начала клички.
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            l10n.birthsNamePreview('${prefix}1', '${prefix}2'),
            style: AppTypography.labelSm
                .copyWith(color: context.colors.onSurfaceVariant),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: _busy ? null : () => Navigator.pop(context, false),
          child: Text(l10n.commonCancel),
        ),
        TextButton(
          onPressed: _busy ? null : _create,
          child: Text(l10n.commonAdd),
        ),
      ],
    );
  }
}
