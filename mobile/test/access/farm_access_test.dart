import 'package:flutter_test/flutter_test.dart';

import 'package:mobile/core/access/farm_access.dart';

/// Права в интерфейсе должны повторять права на сервере. Если они разойдутся,
/// пользователь увидит кнопку, которая приводит к отказу, — и решит, что
/// сломалось приложение.
void main() {
  group('Права роли', () {
    test('работник только ведёт ежедневные записи', () {
      const worker = FarmRoleAccess.worker;

      expect(worker.can(FarmCapability.recordDailyWork), isTrue);
      expect(worker.can(FarmCapability.manageLivestock), isFalse);
      expect(worker.can(FarmCapability.manageStock), isFalse);
      expect(worker.can(FarmCapability.manageFinance), isFalse);
      expect(worker.can(FarmCapability.manageStaff), isFalse);
      expect(worker.can(FarmCapability.deleteRecords), isFalse);
    });

    test('управляющий ведёт хозяйство, но не трогает сотрудников и удаление',
        () {
      const manager = FarmRoleAccess.manager;

      expect(manager.can(FarmCapability.recordDailyWork), isTrue);
      expect(manager.can(FarmCapability.manageLivestock), isTrue);
      expect(manager.can(FarmCapability.manageStock), isTrue);
      expect(manager.can(FarmCapability.manageFinance), isTrue);
      expect(manager.can(FarmCapability.manageStaff), isFalse);
      expect(manager.can(FarmCapability.deleteRecords), isFalse);
    });

    test('владельцу доступно всё', () {
      for (final capability in FarmCapability.values) {
        expect(FarmRoleAccess.owner.can(capability), isTrue);
      }
    });

    test('неизвестная роль трактуется как самая узкая', () {
      expect(FarmRoleAccess.parse('superadmin'), FarmRoleAccess.worker);
      expect(FarmRoleAccess.parse(null), FarmRoleAccess.worker);
      expect(FarmRoleAccess.parse(''), FarmRoleAccess.worker);
    });

    test('известные роли разбираются точно', () {
      expect(FarmRoleAccess.parse('owner'), FarmRoleAccess.owner);
      expect(FarmRoleAccess.parse('manager'), FarmRoleAccess.manager);
      expect(FarmRoleAccess.parse('worker'), FarmRoleAccess.worker);
    });
  });
}
