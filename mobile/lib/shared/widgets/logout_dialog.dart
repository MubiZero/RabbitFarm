import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/l10n/l10n_context.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';

Future<void> showLogoutDialog(BuildContext context, WidgetRef ref) {
  return showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(ctx.l10n.logoutDialogTitle),
      // Раньше здесь стояло «Вы действительно хотите выйти?» — вопрос без
      // ответа на настоящее опасение: не пропадут ли записи. Теперь диалог
      // говорит то, ради чего его читают.
      content: Text(ctx.l10n.logoutDialogBody),
      actions: [
        TextButton(
          onPressed: () => ctx.pop(),
          child: Text(ctx.l10n.commonCancel),
        ),
        ElevatedButton(
          onPressed: () async {
            ctx.pop();
            await ref.read(authProvider.notifier).logout();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(ctx).colorScheme.error,
          ),
          child: Text(ctx.l10n.logoutDialogConfirm),
        ),
      ],
    ),
  );
}
