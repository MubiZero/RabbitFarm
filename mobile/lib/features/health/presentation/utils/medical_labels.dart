import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n_context.dart';
import '../../../../core/theme/theme.dart';
import '../../data/models/medical_record_model.dart';

/// Подписи и цвета исходов лечения.
///
/// «Лечение продолжается» в карточке не помещалось и обрезалось, а в фильтре
/// та же строка называлась просто «Лечение». Теперь подпись одна: «Лечится».
String medicalOutcomeLabel(BuildContext context, MedicalOutcome outcome) =>
    switch (outcome) {
      MedicalOutcome.ongoing => context.l10n.medOutcomeOngoing,
      MedicalOutcome.recovered => context.l10n.medOutcomeRecovered,
      MedicalOutcome.died => context.l10n.medOutcomeDied,
      MedicalOutcome.euthanized => context.l10n.medOutcomeEuthanized,
    };

Color medicalOutcomeColor(BuildContext context, MedicalOutcome outcome) =>
    switch (outcome) {
      MedicalOutcome.ongoing => AppColors.warning,
      MedicalOutcome.recovered => AppColors.success,
      MedicalOutcome.died => AppColors.error,
      // Усыпление — не ошибка и не успех, поэтому нейтральный цвет: тревожный
      // красный здесь читался бы как сбой в приложении.
      MedicalOutcome.euthanized => context.colors.onSurfaceVariant,
    };

IconData medicalOutcomeIcon(MedicalOutcome outcome) => switch (outcome) {
      MedicalOutcome.ongoing => Icons.healing_outlined,
      MedicalOutcome.recovered => Icons.check_circle_outline,
      MedicalOutcome.died => Icons.sentiment_very_dissatisfied_outlined,
      MedicalOutcome.euthanized => Icons.do_not_disturb_on_outlined,
    };

/// Код исхода для запроса к серверу.
String medicalOutcomeValue(MedicalOutcome outcome) => switch (outcome) {
      MedicalOutcome.ongoing => 'ongoing',
      MedicalOutcome.recovered => 'recovered',
      MedicalOutcome.died => 'died',
      MedicalOutcome.euthanized => 'euthanized',
    };
