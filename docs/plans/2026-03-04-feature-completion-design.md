# Feature Completion Design
Date: 2026-03-04

## Approach: C — Critical bugs first, then modules by priority

---

## Phase 1: Critical Cross-Cutting Fixes

### 1.1 Missing provider invalidations after mutations
**Affected files:**
- `transaction_form_screen.dart` → after save/delete: `ref.read(transactionsProvider.notifier).refresh()`
- `feeding_record_form_screen.dart` → after save/delete: `ref.read(feedingRecordsProvider.notifier).refresh()`
- `feed_form_screen.dart` → after save/delete: `ref.read(feedsProvider.notifier).refresh()`

**Pattern:** copy from `breeding_form_screen.dart` which already does this correctly.

### 1.2 `firstWhere` crash in births_list_screen
`firstWhere((r) => r.id == birth.motherId)` throws if mother not in first page.
Fix: add `orElse: () => null`, render "Мать не найдена" if null, skip broken card.

### 1.3 Breeding edit flow broken
Edit button in `breeding_detail_screen` shows snackbar. Fix:
- Add route `/breeding/:id/edit` in `app_router.dart`
- Pass breeding object as `extra` to `BreedingFormScreen`

---

## Phase 2: Окролы (Births) — Complete the flow

### 2.1 Birth detail — bottom sheet (not separate screen)
Tap on birth card → `showModalBottomSheet` with:
- Stats: живых / мёртвых / отсажено
- Мать + дата
- Связанная случка (если есть)
- Actions: Редактировать, Удалить, **Создать крольчат** (if kits not yet created)

### 2.2 "Создать крольчат" для существующего окрола
Button visible when `birth.kitsCreated == false` (or track via checking if any rabbit has this `mother_id` and `birth_date`).
Reuses existing `_createKitsDialog` logic, extracted to shared method.

### 2.3 Birth form: ensure pop after kits dialog
After `_createKitsDialog` completes (kits created OR cancelled) → always `context.pop()`.
Currently can get stuck if flow changes.

---

## Phase 3: Задачи — Fix pagination

Switch from manual prev/next buttons to infinite scroll with `ScrollController`, matching pattern in `breeding_list_screen.dart`.

---

## Phase 4: Здоровье — Complete CRUD

### Vaccinations
Bottom sheet already exists. Ensure it has: full details + Edit + Delete actions.

### Medical records
Add Edit action from list (inline bottom sheet with form fields).

---

## Phase 5: Финансы — Detail bottom sheet

Tap on transaction → bottom sheet with full info + Edit + Delete.
Invalidations already fixed in Phase 1.

---

## Phase 6: Корма — Detail + Filters

- Feed/feeding record tap → bottom sheet with Edit + Delete
- Implement actual filter dialog in feeds list (currently shows snackbar)

---

## Out of scope
- Google/Apple Sign-In
- Photos / Notes (placeholders stay)
- Notifications
- Farm type adaptation
