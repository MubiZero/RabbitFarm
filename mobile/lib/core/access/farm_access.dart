import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/auth/presentation/providers/auth_provider.dart';

/// Что человек может делать на ферме.
///
/// Права проверяет сервер — это единственное надёжное место. Здесь они
/// продублированы для другой цели: не показывать кнопку, которая заведомо
/// вернёт отказ. Работник, нажимающий «Удалить» и получающий «нет доступа»,
/// решает, что приложение сломалось, а не что ему не положено.
///
/// Порядок ролей: работник ведёт ежедневные записи, управляющий распоряжается
/// поголовьем, кормами и деньгами, владелец вдобавок удаляет записи и
/// заводит сотрудников.
enum FarmCapability {
  /// Кролики, клетки, породы, роды: заводить и править.
  manageLivestock,

  /// Корма: заводить, править, корректировать остаток.
  manageStock,

  /// Приходы и расходы: заводить и править.
  manageFinance,

  /// Смотреть состав фермы и журнал кадровых действий.
  ///
  /// Отделено от [manageStaff], потому что сервер разводит их так же:
  /// управляющему список работников и журнал удалений отдаются, а менять
  /// состав разрешено только владельцу.
  viewStaff,

  /// Приглашать сотрудников, менять их роли, закрывать доступ и передавать
  /// хозяйство. На сервере — только owner.
  manageStaff,

  /// Ежедневные записи: вакцинация, лечение, кормление, задачи.
  recordDailyWork,

  /// Сводки по ферме, здоровью и деньгам.
  ///
  /// Сервер отдаёт отчёты всем вошедшим, но работнику они не нужны и не
  /// касаются его работы. Отдельное право нужно потому, что отчёты не
  /// сводятся к деньгам: ферма и здоровье к `manageFinance` отношения не
  /// имеют, и вешать вход в отчёты на денежное право — врать про смысл.
  viewReports,

  /// Удалять записи: кроликов, клетки, породы, корма, случки, роды,
  /// вакцинации, медкарты, транзакции. На сервере — только owner.
  deleteRecords,

  /// Удалять записи ежедневной текучки: кормление, заметки, задачи.
  /// На сервере это разрешено manager и owner, в отличие от
  /// [deleteRecords] — это не то же самое право с более широким охватом.
  deleteDailyRecords,
}

/// Роль текущего пользователя. Неизвестное значение трактуется как самая
/// узкая роль: лучше спрятать доступную кнопку, чем показать недоступную.
enum FarmRoleAccess {
  owner,
  manager,
  worker;

  static FarmRoleAccess parse(String? raw) => switch (raw) {
        'owner' => FarmRoleAccess.owner,
        'manager' => FarmRoleAccess.manager,
        _ => FarmRoleAccess.worker,
      };

  bool can(FarmCapability capability) => switch (this) {
        FarmRoleAccess.owner => true,
        FarmRoleAccess.manager => capability != FarmCapability.manageStaff &&
            capability != FarmCapability.deleteRecords,
        FarmRoleAccess.worker => capability == FarmCapability.recordDailyWork,
      };
}

/// Роль вошедшего пользователя.
final farmRoleProvider = Provider<FarmRoleAccess>((ref) {
  final user = ref.watch(authProvider).user;
  return FarmRoleAccess.parse(user?.role);
});

/// Кто смотрит на экран.
///
/// Нужен там, где записи фермы делятся на свои и чужие: подпись «кто записал»
/// под проводкой имеет смысл только на чужой строке. Рядом с ролью, а не в
/// фиче: вопрос «это сделал я или кто-то другой» не принадлежит ни деньгам,
/// ни задачам в отдельности.
final currentUserIdProvider = Provider<int?>((ref) {
  return ref.watch(authProvider).user?.id;
});

/// Платформенный суперадмин — доступ поверх ролей фермы.
///
/// В [FarmRoleAccess] он намеренно не входит: это не «роль выше владельца», а
/// другое измерение. Суперадмин распоряжается сервисом — тарифами и фермами, —
/// но внутри своей фермы остаётся тем, кем записан; и наоборот, владелец
/// фермы суперадмином от этого не становится.
final isPlatformAdminProvider = Provider<bool>((ref) {
  return ref.watch(authProvider).user?.isPlatformAdmin ?? false;
});

/// Доступна ли пользователю конкретная возможность.
final canProvider = Provider.family<bool, FarmCapability>(
  (ref, capability) => ref.watch(farmRoleProvider).can(capability),
);
