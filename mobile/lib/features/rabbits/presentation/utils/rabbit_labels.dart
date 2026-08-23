import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n_context.dart';
import '../../../../core/theme/theme.dart';

/// Подписи, значки и цвета пола кролика.
///
/// Эти три ветвления были расписаны прямо в строке карточки списка и
/// повторялись ещё в трёх местах, каждый раз чуть иначе: где-то неизвестный
/// пол назывался «Неизвестно», где-то не показывался вовсе.
String sexLabel(BuildContext context, String? sex) => switch (sex) {
      'male' => context.l10n.sexMale,
      'female' => context.l10n.sexFemale,
      _ => context.l10n.sexUnknown,
    };

IconData rabbitSexIcon(String? sex) => switch (sex) {
      'male' => Icons.male,
      'female' => Icons.female,
      _ => Icons.help_outline,
    };

Color sexColor(BuildContext context, String? sex) => switch (sex) {
      'male' => AppColors.info,
      'female' => AppColors.domainBreeding,
      _ => context.colors.onSurfaceVariant,
    };

/// Для чего держат кролика. Раньше этот список был выписан в карточке
/// кролика и назывался «Мясо», «Мех», «Продажа» — набором существительных,
/// который читался как перечень товаров, а не как назначение животного.
String rabbitPurposeLabel(BuildContext context, String? purpose) =>
    switch (purpose) {
      'breeding' => context.l10n.purposeBreeding,
      'meat' => context.l10n.purposeMeat,
      'fur' => context.l10n.purposeFur,
      'sale' => context.l10n.purposeSale,
      'pet' => context.l10n.purposePet,
      'show' => context.l10n.purposeShow,
      _ => purpose ?? '',
    };

/// Статусы кролика, которые понимает сервер.
const rabbitStatuses = [
  'healthy',
  'sick',
  'quarantine',
  'pregnant',
  'sold',
  'dead',
];

String rabbitStatusLabel(BuildContext context, String? status) =>
    switch (status) {
      'healthy' || 'active' => context.l10n.statusHealthy,
      'sick' => context.l10n.statusSick,
      'quarantine' => context.l10n.statusQuarantine,
      'pregnant' => context.l10n.statusPregnant,
      'sold' => context.l10n.statusSold,
      'dead' || 'deceased' => context.l10n.statusDead,
      _ => status ?? '',
    };

/// Назначения кролика, которые понимает сервер.
const rabbitPurposes = ['breeding', 'meat', 'fur', 'sale', 'show', 'pet'];
