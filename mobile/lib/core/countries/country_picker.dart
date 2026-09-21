import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../l10n/l10n_context.dart';
import '../theme/theme.dart';
import 'countries.dart';
import 'country_labels.dart';
import 'country_provider.dart';

/// Строка «Страна: …» на экранах входа и регистрации.
///
/// Страну спрашивают в знакомстве, но знакомство можно пропустить, а ответ —
/// промахнуться. До этой строки выхода не было: узбекскому фермеру
/// предлагали вход по таджикскому номеру, его `+998` не проходил проверку, и
/// поменять страну было негде — знакомство второй раз не показывают.
class CountryPickerButton extends ConsumerWidget {
  const CountryPickerButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final country = ref.watch(selectedCountryProvider).value;
    if (country == null) return const SizedBox.shrink();

    return Align(
      alignment: Alignment.centerLeft,
      child: TextButton.icon(
        icon: const Icon(Icons.public, size: 18),
        label: Text(context.l10n.countryLine(countryName(context, country.code))),
        onPressed: () => showCountryPicker(context, ref),
      ),
    );
  }
}

/// Список стран нижним листом. Под каждой — чем считают деньги и как входят:
/// последствия выбора видно до того, как он сделан.
Future<void> showCountryPicker(BuildContext context, WidgetRef ref) {
  final current = ref.read(selectedCountryProvider).value;

  return showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    builder: (sheetContext) => SafeArea(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screenH,
                0,
                AppSpacing.screenH,
                AppSpacing.md,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    sheetContext.l10n.onbCountryTitle,
                    style: AppTypography.titleMd
                        .copyWith(color: sheetContext.colors.onSurface),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    sheetContext.l10n.onbCountrySubtitle,
                    style: AppTypography.labelSm
                        .copyWith(color: sheetContext.colors.onSurfaceVariant),
                  ),
                ],
              ),
            ),
            for (final country in kCountries)
              ListTile(
                title: Text(countryName(sheetContext, country.code)),
                subtitle: Text(countryHint(sheetContext, country)),
                trailing: country.code == current?.code
                    ? Icon(Icons.check, color: sheetContext.accent)
                    : null,
                onTap: () {
                  ref.read(selectedCountryProvider.notifier).select(country);
                  Navigator.of(sheetContext).pop();
                },
              ),
          ],
        ),
      ),
    ),
  );
}
