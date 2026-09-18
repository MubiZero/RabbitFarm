import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/l10n/error_text.dart';
import '../../../../core/l10n/l10n_context.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

/// Удаление своей учётной записи.
///
/// Обязательный путь по правилам обоих магазинов приложений: завёл учётку в
/// приложении — удалить её должен оттуда же, без писем в поддержку.
///
/// Экран, а не диалог: сказать нужно много и точно. Что именно пропадёт,
/// зависит от того, чьё это хозяйство, и человек должен прочитать про свой
/// случай, а не про оба сразу.
class DeleteAccountScreen extends ConsumerStatefulWidget {
  const DeleteAccountScreen({super.key});

  @override
  ConsumerState<DeleteAccountScreen> createState() =>
      _DeleteAccountScreenState();
}

class _DeleteAccountScreenState extends ConsumerState<DeleteAccountScreen> {
  final _confirmController = TextEditingController();
  bool _busy = false;

  @override
  void dispose() {
    _confirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider).user;
    final isOwner = user?.role == 'owner';
    final farmName = user?.farm?.name;
    final colors = context.colors;

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.deleteAccountTitle)),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.screenH),
        children: [
          AlertCard(
            icon: Icons.warning_amber_outlined,
            color: AppColors.error,
            title: isOwner
                ? context.l10n.deleteAccountOwnerHeadline
                : context.l10n.deleteAccountStaffHeadline,
            description: isOwner
                ? context.l10n.deleteAccountOwnerBody
                : context.l10n.deleteAccountStaffBody,
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            isOwner
                ? context.l10n.deleteAccountOwnerWhatGoes
                : context.l10n.deleteAccountStaffWhatStays,
            style: AppTypography.bodyMd.copyWith(color: colors.onSurface),
          ),
          if (isOwner) ...[
            const SizedBox(height: AppSpacing.lg),
            Text(
              // Тридцать дней — окно на «удалил сгоряча»: до зачистки данные
              // ещё лежат, и поддержка может вернуть хозяйство.
              context.l10n.deleteAccountGracePeriod,
              style:
                  AppTypography.bodyMd.copyWith(color: colors.onSurfaceVariant),
            ),
            const SizedBox(height: AppSpacing.xl),
            Text(
              farmName == null
                  ? context.l10n.deleteAccountTypeNameUnknown
                  : context.l10n.deleteAccountTypeName(farmName),
              style: AppTypography.titleMd.copyWith(color: colors.onSurface),
            ),
            const SizedBox(height: AppSpacing.sm),
            TextField(
              controller: _confirmController,
              enabled: !_busy,
              autocorrect: false,
              decoration: InputDecoration(
                hintText: farmName ?? context.l10n.deleteAccountFarmNameHint,
                border: const OutlineInputBorder(),
              ),
              onChanged: (_) => setState(() {}),
            ),
          ],
          const SizedBox(height: AppSpacing.xl),
          FilledButton.icon(
            onPressed: _canSubmit(isOwner) ? () => _confirm(isOwner) : null,
            icon: _busy
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.delete_forever_outlined),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: AppColors.readableOn(
                AppColors.error,
                Theme.of(context).brightness,
              ),
              minimumSize: const Size.fromHeight(AppSizes.touchTargetLarge),
            ),
            label: Text(isOwner
                ? context.l10n.deleteAccountOwnerAction
                : context.l10n.deleteAccountStaffAction),
          ),
          const SizedBox(height: AppSpacing.md),
          TextButton(
            onPressed: _busy ? null : () => Navigator.of(context).maybePop(),
            child: Text(context.l10n.commonCancel),
          ),
        ],
      ),
    );
  }

  /// Владельцу кнопка открывается только после набранного названия: пустое
  /// поле — это ещё не решение.
  bool _canSubmit(bool isOwner) {
    if (_busy) return false;
    return !isOwner || _confirmController.text.trim().isNotEmpty;
  }

  /// Последний вопрос перед необратимым — вслух и словами, а не «вы уверены?».
  Future<void> _confirm(bool isOwner) async {
    final l10n = context.l10n;
    final agreed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(isOwner
            ? l10n.deleteAccountOwnerDialogTitle
            : l10n.deleteAccountStaffDialogTitle),
        content: Text(isOwner
            ? l10n.deleteAccountOwnerDialogBody
            : l10n.deleteAccountStaffDialogBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(l10n.commonCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: FilledButton.styleFrom(backgroundColor: AppColors.error),
            child: Text(l10n.deleteAccountConfirm),
          ),
        ],
      ),
    );

    if (agreed == true) await _delete(isOwner);
  }

  Future<void> _delete(bool isOwner) async {
    final l10n = context.l10n;
    final messenger = ScaffoldMessenger.of(context);

    setState(() => _busy = true);
    try {
      await ref.read(authProvider.notifier).deleteAccount(
            confirmName: isOwner ? _confirmController.text.trim() : null,
          );
      // Дальше экран убирает сам роутер: сессии больше нет, и он уводит на
      // вход. Сообщение показываем поверх — иначе человек не поймёт, чем
      // кончилось.
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.deleteAccountDone)),
      );
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(
          content: Text(errorText(l10n, e)),
          backgroundColor: AppColors.error,
        ),
      );
      if (mounted) setState(() => _busy = false);
    }
  }
}
