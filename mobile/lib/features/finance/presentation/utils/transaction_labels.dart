import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n_context.dart';
import '../../../../core/theme/theme.dart';
import '../../data/models/transaction_model.dart';

/// Подписи и визуальные признаки операций. Один источник для всех экранов
/// финансов.
///
/// Подписи берутся из переводов, поэтому это функции, а не свойства
/// перечисления: слово зависит от языка, а перечисление о языке не знает.
String transactionTypeLabel(BuildContext context, TransactionType type) =>
    switch (type) {
      TransactionType.income => context.l10n.financeTypeIncome,
      TransactionType.expense => context.l10n.financeTypeExpense,
    };

String transactionCategoryLabel(
        BuildContext context, TransactionCategory category) =>
    switch (category) {
      TransactionCategory.saleRabbit => context.l10n.txCategorySaleRabbit,
      TransactionCategory.saleMeat => context.l10n.txCategorySaleMeat,
      TransactionCategory.saleFur => context.l10n.txCategorySaleFur,
      TransactionCategory.breedingFee => context.l10n.txCategoryBreedingFee,
      TransactionCategory.feed => context.l10n.txCategoryFeed,
      TransactionCategory.veterinary => context.l10n.txCategoryVeterinary,
      TransactionCategory.equipment => context.l10n.txCategoryEquipment,
      TransactionCategory.utilities => context.l10n.txCategoryUtilities,
      TransactionCategory.other => context.l10n.txCategoryOther,
    };

extension TransactionTypeVisuals on TransactionType {
  Color get color => switch (this) {
        TransactionType.income => AppColors.success,
        TransactionType.expense => AppColors.error,
      };

  IconData get icon => switch (this) {
        TransactionType.income => Icons.arrow_upward,
        TransactionType.expense => Icons.arrow_downward,
      };
}

extension TransactionCategoryVisuals on TransactionCategory {
  IconData get icon => switch (this) {
        TransactionCategory.saleRabbit => Icons.pets_outlined,
        TransactionCategory.saleMeat => Icons.restaurant_outlined,
        TransactionCategory.saleFur => Icons.layers_outlined,
        TransactionCategory.breedingFee => Icons.favorite_outline,
        TransactionCategory.feed => Icons.grass_outlined,
        TransactionCategory.veterinary => Icons.medical_services_outlined,
        TransactionCategory.equipment => Icons.build_outlined,
        TransactionCategory.utilities => Icons.bolt_outlined,
        TransactionCategory.other => Icons.more_horiz,
      };
}
