import 'package:flutter/widgets.dart';

import '../../../../core/l10n/l10n_context.dart';

/// Назначение породы. Значения совпадают с теми, что понимает сервер.
const breedPurposes = ['meat', 'fur', 'decorative', 'combined'];

/// Подпись назначения породы.
///
/// Один и тот же список был выписан руками в списке пород и в форме породы;
/// достаточно поправить одно место и забыть про второе, чтобы фильтр и форма
/// начали называть одно и то же по-разному.
String breedPurposeLabel(BuildContext context, String? purpose) =>
    switch (purpose) {
      'meat' => context.l10n.breedPurposeMeat,
      'fur' => context.l10n.breedPurposeFur,
      'decorative' => context.l10n.breedPurposeDecorative,
      'combined' => context.l10n.breedPurposeCombined,
      _ => purpose ?? '',
    };
