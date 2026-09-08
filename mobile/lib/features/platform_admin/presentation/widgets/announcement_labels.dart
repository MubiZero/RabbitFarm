import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n_context.dart';
import 'farm_filter_labels.dart';

/// Подписи адресатов и каналов объявления.
///
/// Одни и те же слова нужны форме, подтверждению перед отправкой и истории:
/// «кому» в подтверждении обязано читаться теми же словами, что и в строке
/// списка, иначе не понять, то ли самое отправлено.

/// Кому можно адресовать объявление — от самого широкого к самому узкому.
const List<String> kAnnouncementTargets = ['all', 'farm', 'filter'];

/// Каналы, которыми объявление уходит.
///
/// SMS здесь нет и не появится: платёжный шлюз (Payom) принимает только
/// заранее одобренные шаблоны, а объявление — свободный текст, который через
/// него технически не отправить. Сервер такой канал тоже отклоняет.
const List<String> kAnnouncementChannels = ['push', 'email'];

String announcementTargetLabel(BuildContext context, String target) {
  final l10n = context.l10n;
  return switch (target) {
    'all' => l10n.platformAnnouncementTargetAll,
    'farm' => l10n.platformAnnouncementTargetFarm,
    'filter' => l10n.platformAnnouncementTargetFilter,
    _ => target,
  };
}

String announcementTargetHint(BuildContext context, String target) {
  final l10n = context.l10n;
  return switch (target) {
    'all' => l10n.platformAnnouncementTargetAllHint,
    'farm' => l10n.platformAnnouncementTargetFarmHint,
    'filter' => l10n.platformAnnouncementTargetFilterHint,
    _ => '',
  };
}

IconData announcementTargetIcon(String target) => switch (target) {
      'all' => Icons.public,
      'farm' => Icons.holiday_village_outlined,
      'filter' => Icons.filter_alt_outlined,
      _ => Icons.help_outline,
    };

String announcementChannelLabel(BuildContext context, String channel) {
  final l10n = context.l10n;
  return switch (channel) {
    'push' => l10n.platformAnnouncementChannelPush,
    'email' => l10n.platformAnnouncementChannelEmail,
    // Сервер мог обзавестись новым каналом раньше приложения — показать код
    // честнее, чем промолчать о канале, которым что-то ушло.
    _ => channel,
  };
}

/// Чем канал обернётся для фермы. В истории эта строка не нужна — там важен
/// итог доставки, — а в форме без неё push и почта выглядят как выбор из двух
/// технических слов.
String announcementChannelHint(BuildContext context, String channel) {
  final l10n = context.l10n;
  return switch (channel) {
    'push' => l10n.platformAnnouncementChannelPushHint,
    'email' => l10n.platformAnnouncementChannelEmailHint,
    _ => '',
  };
}

IconData announcementChannelIcon(String channel) => switch (channel) {
      'push' => Icons.notifications_outlined,
      'email' => Icons.mail_outline,
      _ => Icons.send_outlined,
    };

/// Кому ушло (или уйдёт) объявление — одной строкой.
///
/// [farmName] может быть неизвестно: в истории сервер отдаёт только id фермы,
/// и название есть лишь там, где ферму только что выбрали. Тогда строка честно
/// говорит «одной ферме», а не подставляет номер, который в интерфейсе больше
/// нигде не встречается.
String announcementAudience(
  BuildContext context, {
  required String targetType,
  String? farmName,
  String? targetFilter,
}) {
  final l10n = context.l10n;
  return switch (targetType) {
    'farm' => farmName == null
        ? l10n.platformAnnouncementTargetFarm
        : l10n.platformAnnouncementAudienceFarm(farmName),
    'filter' => l10n.platformAnnouncementAudienceFilter(
        farmFilterLabelOf(context, targetFilter),
      ),
    'all' => l10n.platformAnnouncementTargetAll,
    _ => targetType,
  };
}
