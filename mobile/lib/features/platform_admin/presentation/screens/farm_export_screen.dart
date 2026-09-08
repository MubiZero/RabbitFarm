import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/l10n/l10n_context.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../providers/platform_admin_provider.dart';

final _momentFormat = DateFormat('dd.MM.yyyy HH:mm');

/// Выгрузка всех записей фермы — ответ на просьбу «отдайте мои данные».
///
/// Снимок показывается текстом и копируется в буфер, а не сохраняется файлом:
/// приложение вообще не умеет отдавать файлы наружу (ни `share_plus`, ни
/// `path_provider` в нём нет), и тянуть такую зависимость ради одной кнопки в
/// админке — решение не этого экрана. Адресат здесь один человек с правами
/// платформенного админа, которому достаточно вставить текст куда нужно.
class FarmExportScreen extends ConsumerWidget {
  const FarmExportScreen({super.key, required this.farmId, this.farmName});

  final int farmId;

  /// Название фермы для заголовка. Приходит с карточки, откуда сюда и заходят:
  /// второй запрос ради одной строки заголовка не нужен.
  final String? farmName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final value = ref.watch(platformFarmExportProvider(farmId));
    final data = value.valueOrNull;

    return Scaffold(
      appBar: AppBar(
        title: Text(farmName ?? context.l10n.platformFarmTitleFallback),
        actions: [
          IconButton(
            tooltip: context.l10n.commonCopy,
            icon: const Icon(Icons.copy_all_outlined),
            // Пока снимка нет, копировать нечего — кнопка не притворяется
            // рабочей.
            onPressed: data == null ? null : () => _copy(context, data),
          ),
        ],
      ),
      body: AppAsyncView<Map<String, dynamic>>(
        value: value,
        onRetry: () => ref.invalidate(platformFarmExportProvider(farmId)),
        builder: (export) => ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.screenH,
            AppSpacing.lg,
            AppSpacing.screenH,
            AppSpacing.xxl,
          ),
          children: [
            _GeneratedAt(raw: export['generated_at']),
            const SizedBox(height: AppSpacing.md),
            // Выделяемый текст, а не картинка из данных: часть админ может
            // забрать и кусками, не копируя весь снимок.
            SelectableText(
              _pretty(export),
              style: AppTypography.mono.copyWith(color: context.colors.onSurface),
            ),
          ],
        ),
      ),
    );
  }

  static String _pretty(Map<String, dynamic> export) =>
      const JsonEncoder.withIndent('  ').convert(export);

  Future<void> _copy(BuildContext context, Map<String, dynamic> data) async {
    final messenger = ScaffoldMessenger.of(context);
    final copied = context.l10n.commonCopied;

    await Clipboard.setData(ClipboardData(text: _pretty(data)));
    await HapticFeedback.lightImpact();

    messenger.showSnackBar(SnackBar(content: Text(copied)));
  }
}

/// Когда снимок собран. Дата есть и внутри JSON, но искать её там глазами —
/// не то же, что прочитать строкой: снимок недельной давности уже врёт.
class _GeneratedAt extends StatelessWidget {
  const _GeneratedAt({required this.raw});

  final Object? raw;

  @override
  Widget build(BuildContext context) {
    final moment = raw is String ? DateTime.tryParse(raw as String) : null;

    return Text(
      moment == null
          ? context.l10n.platformFarmExportHint
          : context.l10n
              .platformFarmExportGeneratedAt(_momentFormat.format(moment.toLocal())),
      style:
          AppTypography.labelSm.copyWith(color: context.colors.onSurfaceVariant),
    );
  }
}
