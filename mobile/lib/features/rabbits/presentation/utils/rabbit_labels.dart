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
/// Статус павшего кролика.
///
/// Слово ровно одно и совпадает с тем, что принимает сервер
/// (`ENUM('healthy','active','sick','quarantine','pregnant','sold','dead')`).
/// Рядом жило второе, `deceased`: форма падежа отправляла его и получала
/// отказ, а карточка по нему прятала кнопку — и не прятала никогда.
const rabbitStatusDead = 'dead';

/// Статус проданного кролика. Ставится не правкой карточки, а записью
/// продажи: вместе с ним заводится приход и день продажи.
const rabbitStatusSold = 'sold';

/// Кролик выбыл из поголовья — продан или пал. Обратной дороги из этих
/// статусов форма не предлагает: у каждого свой экран, где спрашивают то,
/// без чего запись остаётся полуправдой (цену и день продажи, дату и причину
/// падежа).
const rabbitStatusesTerminal = [rabbitStatusSold, rabbitStatusDead];

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
      rabbitStatusDead => context.l10n.statusDead,
      _ => status ?? '',
    };

/// Назначения кролика, которые понимает сервер.
///
/// Ровно четыре — столько в колонке:
/// `ENUM('breeding','meat','sale','show')`. Рядом в этом списке жили ещё
/// «мех» и «питомец»: форма их предлагала, а сервер отвечал 422, и человек,
/// выбравший «Мех», не мог сохранить кролика вовсе. Список один на форму,
/// фильтр стада и оптовую простановку — разойдясь, они снова начали бы
/// предлагать несуществующее.
const rabbitPurposes = ['breeding', 'meat', 'sale', 'show'];
