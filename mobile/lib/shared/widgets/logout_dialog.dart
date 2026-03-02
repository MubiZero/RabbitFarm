import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';

Future<void> showLogoutDialog(BuildContext context, WidgetRef ref) {
  return showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Выйти из аккаунта?'),
      content: const Text('Вы действительно хотите выйти?'),
      actions: [
        TextButton(
          onPressed: () => ctx.pop(),
          child: const Text('Отмена'),
        ),
        ElevatedButton(
          onPressed: () async {
            ctx.pop();
            await ref.read(authProvider.notifier).logout();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(ctx).colorScheme.error,
          ),
          child: const Text('Выйти'),
        ),
      ],
    ),
  );
}
