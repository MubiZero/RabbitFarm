import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/models/transaction_model.dart';

/// Человекочитаемые подписи и визуальные признаки типов и категорий транзакций.
/// Один источник для всех экранов финансов.
extension TransactionTypeLabels on TransactionType {
  String get label => switch (this) {
        TransactionType.income => 'Доход',
        TransactionType.expense => 'Расход',
      };

  Color get color => switch (this) {
        TransactionType.income => AppColors.success,
        TransactionType.expense => AppColors.error,
      };

  IconData get icon => switch (this) {
        TransactionType.income => Icons.arrow_upward,
        TransactionType.expense => Icons.arrow_downward,
      };
}

extension TransactionCategoryLabels on TransactionCategory {
  String get label => switch (this) {
        TransactionCategory.saleRabbit => 'Продажа кролика',
        TransactionCategory.saleMeat => 'Продажа мяса',
        TransactionCategory.saleFur => 'Продажа меха',
        TransactionCategory.breedingFee => 'Плата за случку',
        TransactionCategory.feed => 'Корм',
        TransactionCategory.veterinary => 'Ветеринария',
        TransactionCategory.equipment => 'Оборудование',
        TransactionCategory.utilities => 'Коммунальные услуги',
        TransactionCategory.other => 'Другое',
      };

  IconData get icon => switch (this) {
        TransactionCategory.saleRabbit => Icons.pets,
        TransactionCategory.saleMeat => Icons.restaurant,
        TransactionCategory.saleFur => Icons.layers,
        TransactionCategory.breedingFee => Icons.favorite,
        TransactionCategory.feed => Icons.grass,
        TransactionCategory.veterinary => Icons.medical_services,
        TransactionCategory.equipment => Icons.build,
        TransactionCategory.utilities => Icons.bolt,
        TransactionCategory.other => Icons.more_horiz,
      };
}
