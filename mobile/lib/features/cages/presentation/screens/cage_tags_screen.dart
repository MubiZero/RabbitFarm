import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../../core/l10n/error_text.dart';
import '../../../../core/printing/print_html.dart';
import '../../../../core/l10n/l10n_context.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../../data/models/cage_model.dart';
import '../providers/cages_provider.dart';
import '../utils/cage_tag.dart';

/// Метки на клетки: посмотреть и распечатать.
///
/// Печатают их дома, на обычном принтере, целым листом — потому что вешать
/// их идут один раз на все сорок клеток, а не по одной. Поэтому экран
/// показывает лист целиком и печатает его одной кнопкой.
class CageTagsScreen extends ConsumerWidget {
  const CageTagsScreen({super.key, this.cageId});

  /// Метка одной клетки — когда пришли с её экрана. Пусто — весь крольчатник.
  final int? cageId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cages = ref.watch(cageOptionsProvider);

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.cageTagsTitle)),
      body: AppAsyncView<List<CageModel>>(
        value: cages,
        onRetry: () => ref.invalidate(cageOptionsProvider),
        skeleton: (_) => const SkeletonList(count: 4, itemHeight: 120),
        builder: (all) {
          final selected = cageId == null
              ? all
              : [
                  for (final cage in all)
                    if (cage.id == cageId) cage,
                ];

          if (selected.isEmpty) {
            return AppEmptyState(
              icon: Icons.qr_code_2_outlined,
              title: context.l10n.cageTagsEmptyTitle,
              subtitle: context.l10n.cageTagsEmptyBody,
            );
          }

          return _Preview(cages: selected);
        },
      ),
    );
  }
}

class _Preview extends StatelessWidget {
  const _Preview({required this.cages});

  final List<CageModel> cages;

  Future<void> _print(BuildContext context) async {
    final l10n = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    final html = cageTagsHtml(cages, hint: l10n.cageTagsPrintHint);

    try {
      await printHtmlSheet(html: html, documentName: l10n.cageTagsTitle);
    } catch (e) {
      messenger.showSnackBar(SnackBar(content: Text(errorText(l10n, e))));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(AppSpacing.screenH),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 180,
              mainAxisSpacing: AppSpacing.md,
              crossAxisSpacing: AppSpacing.md,
              childAspectRatio: 0.85,
            ),
            itemCount: cages.length,
            itemBuilder: (context, i) => _Tag(cage: cages[i]),
          ),
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.screenH),
            child: SizedBox(
              width: double.infinity,
              height: AppSizes.touchTargetLarge,
              child: FilledButton.icon(
                onPressed: () => _print(context),
                icon: const Icon(Icons.print_outlined),
                label: Text(context.l10n.cageTagsPrint),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag({required this.cage});

  final CageModel cage;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: QrImageView(
              data: cageTagPayload(cage.id),
              // Метку печатают на белой бумаге, поэтому и на экране она
              // белая: в тёмной теме инвертированный код не читается
              // сканером, и человек решил бы, что метка испорчена.
              backgroundColor: Colors.white,
              padding: const EdgeInsets.all(AppSpacing.sm),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            cage.number,
            style: context.text.titleMedium,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
