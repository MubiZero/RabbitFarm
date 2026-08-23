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

  /// Приглашать сотрудников и менять их роли.
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

  /// Удалять записи.
  deleteRecords,
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

/// Доступна ли пользователю конкретная возможность.
final canProvider = Provider.family<bool, FarmCapability>(
  (ref, capability) => ref.watch(farmRoleProvider).can(capability),
);
