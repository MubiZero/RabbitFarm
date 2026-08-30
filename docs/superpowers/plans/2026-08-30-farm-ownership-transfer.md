# Передача хозяйства фермы — план реализации

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Дать владельцу фермы передать хозяйство активному работнику той же фермы — мгновенно, без подтверждения со стороны получателя.

**Architecture:** Новая ручка `POST /staff/:id/transfer-ownership` в существующем стеке `staffService` → `staffController` → `staff.routes.js`, одной транзакцией переключающая `Farm.owner_id` и роли обоих участников. На клиенте — новый пункт меню на карточке работника в `StaffScreen`, диалог-подтверждение и обновление локального профиля текущего пользователя через уже существующий `authProvider.refreshProfile()`.

**Tech Stack:** Node.js / Express / Sequelize (backend), Flutter / Riverpod (mobile).

**Спека:** `docs/superpowers/specs/2026-08-30-farm-ownership-transfer-design.md`

---

## Task 1: Backend — падающие интеграционные тесты

**Files:**
- Create: `backend/tests/integration/staff-ownership-transfer.test.js`

- [ ] **Step 1: Написать тестовый файл**

```js
const request = require('supertest');
const app = require('./helpers/testApp');
const { syncTestDb, closeTestDb } = require('./helpers/testDb');
const { User, Farm } = require('../../src/models');

/**
 * Передача хозяйства: владелец мгновенно уступает ферму активному
 * работнику, без подтверждения с его стороны — получатель уже участник
 * этой же фермы, а не посторонний по коду.
 */
describe('Передача хозяйства фермы', () => {
  let ownerToken;
  let farmId;
  let managerId;
  let workerId;
  let inactiveWorkerId;
  let strangerId;

  beforeAll(async () => {
    await syncTestDb();

    const owner = await request(app)
      .post('/api/v1/auth/register')
      .send({ email: 'transfer_owner@example.com', password: 'Password123!', full_name: 'Владелец' });
    ownerToken = owner.body.data.access_token;
    farmId = owner.body.data.user.farm_id;

    await request(app)
      .post('/api/v1/auth/register')
      .send({ email: 'transfer_manager@example.com', password: 'Password123!', full_name: 'Управляющий' });
    await User.update(
      { farm_id: farmId, role: 'manager' },
      { where: { email: 'transfer_manager@example.com' } }
    );
    managerId = (await User.findOne({ where: { email: 'transfer_manager@example.com' } })).id;

    await request(app)
      .post('/api/v1/auth/register')
      .send({ email: 'transfer_worker@example.com', password: 'Password123!', full_name: 'Работник' });
    await User.update(
      { farm_id: farmId, role: 'worker' },
      { where: { email: 'transfer_worker@example.com' } }
    );
    workerId = (await User.findOne({ where: { email: 'transfer_worker@example.com' } })).id;

    await request(app)
      .post('/api/v1/auth/register')
      .send({ email: 'transfer_inactive@example.com', password: 'Password123!', full_name: 'Уволенный' });
    await User.update(
      { farm_id: farmId, role: 'worker', is_active: false },
      { where: { email: 'transfer_inactive@example.com' } }
    );
    inactiveWorkerId = (await User.findOne({ where: { email: 'transfer_inactive@example.com' } })).id;

    const stranger = await request(app)
      .post('/api/v1/auth/register')
      .send({ email: 'transfer_stranger@example.com', password: 'Password123!', full_name: 'Сосед' });
    strangerId = stranger.body.data.user.id;
  });

  afterAll(async () => {
    await closeTestDb();
  });

  it('работника чужой фермы получателем не назначить', async () => {
    const res = await request(app)
      .post(`/api/v1/staff/${strangerId}/transfer-ownership`)
      .set('Authorization', `Bearer ${ownerToken}`);

    expect(res.status).toBe(404);
  });

  it('неактивному работнику ферму не передать', async () => {
    const res = await request(app)
      .post(`/api/v1/staff/${inactiveWorkerId}/transfer-ownership`)
      .set('Authorization', `Bearer ${ownerToken}`);

    expect(res.status).toBe(404);
  });

  it('не-владелец передать хозяйство не может', async () => {
    const managerLogin = await request(app)
      .post('/api/v1/auth/login')
      .send({ email: 'transfer_manager@example.com', password: 'Password123!' });

    const res = await request(app)
      .post(`/api/v1/staff/${workerId}/transfer-ownership`)
      .set('Authorization', `Bearer ${managerLogin.body.data.access_token}`);

    expect(res.status).toBe(403);
  });

  it('владелец передаёт хозяйство работнику', async () => {
    const res = await request(app)
      .post(`/api/v1/staff/${workerId}/transfer-ownership`)
      .set('Authorization', `Bearer ${ownerToken}`);

    expect(res.status).toBe(200);
    expect(res.body.data.id).toBe(workerId);
    expect(res.body.data.role).toBe('owner');

    const farm = await Farm.findByPk(farmId);
    expect(farm.owner_id).toBe(workerId);

    const previousOwner = await User.findOne({ where: { email: 'transfer_owner@example.com' } });
    expect(previousOwner.role).toBe('manager');
  });

  it('бывший владелец теряет владельческий доступ без повторного логина', async () => {
    // Тот же access-токен, что и в начале файла — роль в нём не менялась,
    // но middleware читает её из базы заново на каждый запрос.
    const res = await request(app)
      .post('/api/v1/staff/invitations')
      .set('Authorization', `Bearer ${ownerToken}`)
      .send({ email: 'after_transfer@example.com', role: 'worker' });

    expect(res.status).toBe(403);
  });

  it('новый владелец получает владельческий доступ тем же токеном', async () => {
    const newOwnerLogin = await request(app)
      .post('/api/v1/auth/login')
      .send({ email: 'transfer_worker@example.com', password: 'Password123!' });

    const res = await request(app)
      .post('/api/v1/staff/invitations')
      .set('Authorization', `Bearer ${newOwnerLogin.body.data.access_token}`)
      .send({ email: 'after_transfer2@example.com', role: 'worker' });

    expect(res.status).toBe(201);
  });
});
```

- [ ] **Step 2: Прогнать и убедиться, что тесты падают**

Run: `cd backend && npx jest tests/integration/staff-ownership-transfer.test.js --runInBand --coverageThreshold={}`
Expected: FAIL — ручки `/staff/:id/transfer-ownership` ещё нет, запросы возвращают 404 от Express (не от `ApiResponse.notFound`), тесты на `403`/`200`/`201` тоже падают.

- [ ] **Step 3: Commit**

```bash
git add backend/tests/integration/staff-ownership-transfer.test.js
git commit -m "test: падающие тесты на передачу хозяйства фермы"
```

---

## Task 2: Backend — `staffService.transferOwnership`

**Files:**
- Modify: `backend/src/services/staffService.js:3` (импорт), после `updateMember` (после строки 182, перед закрывающей `}` класса)

- [ ] **Step 1: Добавить `Farm` в импорт моделей**

В `backend/src/services/staffService.js:3` заменить:

```js
const { User, Invitation, RefreshToken } = require('../models');
```

на:

```js
const { User, Farm, Invitation, RefreshToken } = require('../models');
```

- [ ] **Step 2: Добавить метод `transferOwnership`**

Вставить в `backend/src/services/staffService.js` перед закрывающей `}` класса (после метода `updateMember`, который сейчас заканчивается на строке 182):

```js

  /**
   * Передать хозяйство фермы активному работнику.
   *
   * Мгновенно, без подтверждения со стороны получателя: он уже
   * авторизованный участник этой же фермы, а не посторонний по коду, как в
   * приглашении. Прежний владелец становится управляющим — остаётся в
   * ферме с почти полным доступом, но без права передавать хозяйство
   * дальше или менять состав.
   */
  async transferOwnership(farmId, currentOwner, newOwnerId) {
    const newOwner = await User.findOne({
      where: { id: newOwnerId, farm_id: farmId, role: { [Op.ne]: 'owner' }, is_active: true }
    });
    if (!newOwner) {
      throw new Error('MEMBER_NOT_FOUND');
    }

    const transaction = await User.sequelize.transaction();
    try {
      await Farm.update({ owner_id: newOwner.id }, { where: { id: farmId }, transaction });
      await newOwner.update({ role: 'owner' }, { transaction });
      await currentOwner.update({ role: 'manager' }, { transaction });
      await transaction.commit();
    } catch (error) {
      await transaction.rollback();
      throw error;
    }

    logger.info('Ownership transferred', {
      farmId,
      fromUserId: currentOwner.id,
      toUserId: newOwner.id
    });
    return newOwner;
  }
```

- [ ] **Step 3: Commit**

```bash
git add backend/src/services/staffService.js
git commit -m "feat: staffService.transferOwnership"
```

---

## Task 3: Backend — контроллер и роут

**Files:**
- Modify: `backend/src/controllers/staffController.js` (добавить метод после `resetMemberPassword`, строка 52)
- Modify: `backend/src/routes/staff.routes.js:59` (добавить роут)

- [ ] **Step 1: Добавить метод в контроллер**

Вставить в `backend/src/controllers/staffController.js` сразу после закрывающей `}` метода `resetMemberPassword` (строка 52), перед `/** POST /staff/invitations — выписать приглашение */`:

```js

  /** POST /staff/:id/transfer-ownership — передать хозяйство фермы */
  async transferOwnership(req, res, next) {
    try {
      const newOwner = await staffService.transferOwnership(
        req.farmId,
        req.user,
        req.params.id
      );
      return ApiResponse.success(res, newOwner, 'Хозяйство передано');
    } catch (error) {
      if (error.message === 'MEMBER_NOT_FOUND') {
        return ApiResponse.notFound(res, 'Работник не найден');
      }
      next(error);
    }
  }
```

- [ ] **Step 2: Добавить роут**

В `backend/src/routes/staff.routes.js` заменить строку 59:

```js
router.post('/:id/reset-password', authorize(['owner']), staffController.resetMemberPassword);
```

на:

```js
router.post('/:id/reset-password', authorize(['owner']), staffController.resetMemberPassword);

/**
 * @swagger
 * /staff/{id}/transfer-ownership:
 *   post:
 *     summary: Передать хозяйство фермы активному работнику
 *     tags: [Staff]
 */
router.post('/:id/transfer-ownership', authorize(['owner']), staffController.transferOwnership);
```

- [ ] **Step 3: Прогнать тесты из Task 1 и убедиться, что они проходят**

Run: `cd backend && npx jest tests/integration/staff-ownership-transfer.test.js --runInBand --coverageThreshold={}`
Expected: PASS — все 6 тестов зелёные.

- [ ] **Step 4: Прогнать весь backend-набор — убедиться, что ничего не сломалось**

Run: `cd backend && npx jest tests/integration --runInBand --coverageThreshold={} && npx jest tests/unit --coverageThreshold={}`
Expected: PASS — все интеграционные (392) и unit (731) тесты зелёные.

- [ ] **Step 5: Commit**

```bash
git add backend/src/controllers/staffController.js backend/src/routes/staff.routes.js
git commit -m "feat: ручка передачи хозяйства фермы"
```

---

## Task 4: Flutter — метод в `StaffRepository`

**Files:**
- Modify: `mobile/lib/features/staff/data/repositories/staff_repository.dart` (добавить метод после `resetMemberPassword`, строка 87)

- [ ] **Step 1: Добавить метод**

Вставить в `mobile/lib/features/staff/data/repositories/staff_repository.dart` после метода `resetMemberPassword` (после строки 87, перед `/// Присоединиться к ферме по коду.`):

```dart

  /// Передать хозяйство фермы работнику. Мгновенно, без подтверждения с
  /// его стороны — он уже участник этой же фермы.
  Future<FarmMember> transferOwnership(int id) async {
    try {
      final response = await _apiClient.post('/staff/$id/transfer-ownership');
      return FarmMember.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw ApiFailure.from(e);
    }
  }
```

- [ ] **Step 2: Commit**

```bash
git add mobile/lib/features/staff/data/repositories/staff_repository.dart
git commit -m "feat(mobile): StaffRepository.transferOwnership"
```

---

## Task 5: Flutter — строки локализации

**Files:**
- Modify: `mobile/lib/l10n/app_ru.arb` (добавить ключи после `staffCloseAccess`, строка 1073)

- [ ] **Step 1: Добавить ключи**

В `mobile/lib/l10n/app_ru.arb` после строки 1073 (`"staffCloseAccess": "Закрыть доступ",`) добавить:

```json
  "staffTransferOwnership": "Передать хозяйство",
  "staffTransferTitle": "Передать хозяйство?",
  "staffTransferBody": "Ферма перейдёт {name}, а вы станете управляющим. Отменить это будет нельзя.",
  "@staffTransferBody": {
    "placeholders": { "name": { "type": "String" } }
  },
  "staffTransferConfirm": "Передать",
  "staffTransferred": "Хозяйство передано {name}",
  "@staffTransferred": {
    "placeholders": { "name": { "type": "String" } }
  },
```

- [ ] **Step 2: Перегенерировать локализацию**

Run: `cd mobile && /Users/mubidev/development/flutter/bin/flutter gen-l10n`
Expected: без ошибок; проверить `grep -n "staffTransferOwnership" lib/l10n/generated/app_localizations_ru.dart` находит новый геттер.

- [ ] **Step 3: Commit**

```bash
git add mobile/lib/l10n/app_ru.arb mobile/lib/l10n/generated/
git commit -m "feat(mobile): строки для передачи хозяйства"
```

---

## Task 6: Flutter — пункт меню, диалог, обновление профиля

**Files:**
- Modify: `mobile/lib/features/staff/presentation/screens/staff_screen.dart`

- [ ] **Step 1: Добавить импорт `authProvider`**

В начало `mobile/lib/features/staff/presentation/screens/staff_screen.dart`, после существующих импортов (после строки 12, `import '../../../../core/l10n/error_text.dart';`), добавить:

```dart
import '../../../auth/presentation/providers/auth_provider.dart';
```

- [ ] **Step 2: Прокинуть колбэк в цикле по сотрудникам**

В методе `_buildContent` заменить блок построения `_MemberCard` для сотрудников (строки 86–102):

```dart
            for (final member in staff)
              _MemberCard(
                member: member,
                onChangeRole: (role) => _updateMember(
                  context,
                  ref,
                  member,
                  role: role,
                ),
                onToggleAccess: () => _updateMember(
                  context,
                  ref,
                  member,
                  isActive: !member.isActive,
                ),
                onResetPassword: () => _resetPassword(context, ref, member),
              ),
```

на:

```dart
            for (final member in staff)
              _MemberCard(
                member: member,
                onChangeRole: (role) => _updateMember(
                  context,
                  ref,
                  member,
                  role: role,
                ),
                onToggleAccess: () => _updateMember(
                  context,
                  ref,
                  member,
                  isActive: !member.isActive,
                ),
                onResetPassword: () => _resetPassword(context, ref, member),
                onTransferOwnership: () =>
                    _transferOwnership(context, ref, member),
              ),
```

- [ ] **Step 3: Добавить метод `_transferOwnership`**

Вставить в класс `StaffScreen`, после метода `_resetPassword` (после строки 211, перед `Future<void> _revokeInvitation(`):

```dart

  /// Передача хозяйства мгновенна и необратима действием одной кнопки —
  /// поэтому подтверждение здесь жёстче, чем у смены роли.
  Future<void> _transferOwnership(
    BuildContext context,
    WidgetRef ref,
    FarmMember member,
  ) async {
    final messenger = ScaffoldMessenger.of(context);
    final l10n = context.l10n;
    final transferred = context.l10n.staffTransferred(member.fullName);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(context.l10n.staffTransferTitle),
        content: Text(context.l10n.staffTransferBody(member.fullName)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(context.l10n.commonCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(context.l10n.staffTransferConfirm),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      await ref.read(staffRepositoryProvider).transferOwnership(member.id);
      // Наша собственная роль сменилась на «управляющий» — без этого
      // локальный профиль продолжал бы считать нас владельцем до
      // следующего перелогина.
      await ref.read(authProvider.notifier).refreshProfile();
      if (!context.mounted) return;
      ref.invalidate(farmMembersProvider);
      messenger.showSnackBar(SnackBar(content: Text(transferred)));
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(
          content: Text(errorText(l10n, e)),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }
```

- [ ] **Step 4: Добавить параметр и пункт меню в `_MemberCard`**

В классе `_MemberCard` (строки 448–459) добавить поле и параметр конструктора:

```dart
class _MemberCard extends StatelessWidget {
  final FarmMember member;
  final ValueChanged<FarmRole>? onChangeRole;
  final VoidCallback? onToggleAccess;
  final VoidCallback? onResetPassword;
  final VoidCallback? onTransferOwnership;

  const _MemberCard({
    required this.member,
    this.onChangeRole,
    this.onToggleAccess,
    this.onResetPassword,
    this.onTransferOwnership,
  });
```

Дальше в `build()` — в `PopupMenuButton<String>.onSelected` (строки 515–526) добавить кейс:

```dart
                onSelected: (value) {
                  switch (value) {
                    case 'worker':
                      onChangeRole?.call(FarmRole.worker);
                    case 'manager':
                      onChangeRole?.call(FarmRole.manager);
                    case 'access':
                      onToggleAccess?.call();
                    case 'password':
                      onResetPassword?.call();
                    case 'transfer-ownership':
                      onTransferOwnership?.call();
                  }
                },
```

И в `itemBuilder` (строки 527–546) добавить пункт последним, только для активных сотрудников:

```dart
                itemBuilder: (context) => [
                  if (member.role != FarmRole.manager)
                    PopupMenuItem(
                      value: 'manager',
                      child: Text(context.l10n.staffMakeManager),
                    ),
                  if (member.role != FarmRole.worker)
                    PopupMenuItem(
                      value: 'worker',
                      child: Text(context.l10n.staffMakeWorker),
                    ),
                  PopupMenuItem(
                    value: 'password',
                    child: Text(context.l10n.staffResetPassword),
                  ),
                  PopupMenuItem(
                    value: 'access',
                    child: Text(inactive ? context.l10n.staffOpenAccess : context.l10n.staffCloseAccess),
                  ),
                  if (!inactive)
                    PopupMenuItem(
                      value: 'transfer-ownership',
                      child: Text(context.l10n.staffTransferOwnership),
                    ),
                ],
```

- [ ] **Step 5: Статический анализ**

Run: `cd mobile && /Users/mubidev/development/flutter/bin/flutter analyze lib/features/staff lib/features/auth`
Expected: `No issues found!`

- [ ] **Step 6: Прогнать существующие виджет-тесты экрана**

Run: `cd mobile && /Users/mubidev/development/flutter/bin/flutter test test/screens/staff_screen_test.dart`
Expected: PASS — существующие 5 тестов не задеты (новый пункт меню и диалог не покрываются тестами, как и соседние пункты меню — `staffMakeManager`, `staffResetPassword` и т.д. тоже без виджет-тестов).

- [ ] **Step 7: Commit**

```bash
git add mobile/lib/features/staff/presentation/screens/staff_screen.dart
git commit -m "feat(mobile): передача хозяйства фермы из карточки работника"
```

---

## Task 7: Ручная проверка

- [ ] **Step 1: Полный прогон backend**

Run: `cd backend && npx jest tests/integration --runInBand --coverageThreshold={} && npx jest tests/unit --coverageThreshold={}`
Expected: PASS.

- [ ] **Step 2: Полный `flutter analyze`**

Run: `cd mobile && /Users/mubidev/development/flutter/bin/flutter analyze`
Expected: `No issues found!`

- [ ] **Step 3: Живой прогон в симуляторе**

Открыть приложение владельцем фермы с хотя бы одним активным работником → экран «Ферма» → «Работники» → меню на карточке работника → «Передать хозяйство» → подтвердить → убедиться, что появился снэкбар и раздел «Работники» пропал из меню «Ферма» (роль сменилась на управляющего) без перелогина.
