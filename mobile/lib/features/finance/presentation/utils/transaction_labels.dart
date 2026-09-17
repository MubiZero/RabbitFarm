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
    typeTexts(context.l10n)[type]!;

String transactionCategoryLabel(
        BuildContext context, TransactionCategory category) =>
    categoryTexts(context.l10n)[category]!;

/// Те же подписи, но переводами-значением: книга доходов и расходов
/// собирается после `await`, когда обращаться к `BuildContext` уже небезопасно.
Map<TransactionType, String> typeTexts(AppLocalizations l10n) => {
      TransactionType.income: l10n.financeTypeIncome,
      TransactionType.expense: l10n.financeTypeExpense,
    };

Map<TransactionCategory, String> categoryTexts(AppLocalizations l10n) => {
      TransactionCategory.saleRabbit: l10n.txCategorySaleRabbit,
      TransactionCategory.saleMeat: l10n.txCategorySaleMeat,
      TransactionCategory.saleFur: l10n.txCategorySaleFur,
      TransactionCategory.breedingFee: l10n.txCategoryBreedingFee,
      TransactionCategory.feed: l10n.txCategoryFeed,
      TransactionCategory.veterinary: l10n.txCategoryVeterinary,
      TransactionCategory.equipment: l10n.txCategoryEquipment,
      TransactionCategory.utilities: l10n.txCategoryUtilities,
      TransactionCategory.other: l10n.txCategoryOther,
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
