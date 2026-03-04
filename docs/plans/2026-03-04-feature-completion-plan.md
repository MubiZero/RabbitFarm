# Feature Completion Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Fix all broken/incomplete functionality across the app — missing refreshes, incomplete edit flows, missing birth detail, tasks pagination, and detail actions for health/finance/feeding modules.

**Architecture:** Fix critical cross-cutting bugs first (Phase 1), then complete each module in priority order. Each task is independent and committable. No new screens unless necessary — prefer bottom sheets for detail/edit.

**Tech Stack:** Flutter, Riverpod (StateNotifier + autoDispose FutureProviders), GoRouter, Dio

---

## Phase 1: Critical Cross-Cutting Fixes

### Task 1: Fix missing refresh in TransactionFormScreen

**Files:**
- Modify: `mobile/lib/features/finance/presentation/screens/transaction_form_screen.dart`

After `createTransactionProvider` future resolves (line ~273), before `context.pop()`, add:
```dart
ref.read(transactionsProvider.notifier).refresh();
```
Same after `updateTransactionProvider` (line ~303) and after `deleteTransactionProvider` (line ~350).

**Verify:** Create a transaction → list updates without manual pull-to-refresh.

**Commit:** `fix: refresh transactions list after create/update/delete`

---

### Task 2: Fix missing refresh in FeedingRecordFormScreen

**Files:**
- Modify: `mobile/lib/features/feeding/presentation/screens/feeding_record_form_screen.dart`

After `createFeedingRecordProvider` (line ~318), add:
```dart
ref.read(feedingRecordsProvider.notifier).refresh();
```
Same after `updateFeedingRecordProvider` (line ~337) and any delete call.

**Commit:** `fix: refresh feeding records list after mutations`

---

### Task 3: Fix missing refresh in FeedFormScreen

**Files:**
- Modify: `mobile/lib/features/feeding/presentation/screens/feed_form_screen.dart`

After `createFeedProvider` (line ~242), add:
```dart
ref.read(feedsProvider.notifier).refresh();
```
Same after `updateFeedProvider` (line ~262) and `deleteFeedProvider` (line ~314).

**Commit:** `fix: refresh feeds list after mutations`

---

### Task 4: Fix firstWhere crash in BirthsListScreen

**Files:**
- Modify: `mobile/lib/features/rabbits/presentation/screens/births_list_screen.dart`

Line ~54 change from:
```dart
final mother = rabbitsState.rabbits.firstWhere(
  (r) => r.id == birth.motherId,
  orElse: () => throw Exception('Mother not found'),
);
```
To:
```dart
final mother = rabbitsState.rabbits.where(
  (r) => r.id == birth.motherId,
).firstOrNull;
```

Then in `_BirthCard` make `motherName` nullable and show `'Мать не найдена'` if null:
```dart
// In itemBuilder, skip rendering or show placeholder if mother == null
if (mother == null) return const SizedBox.shrink();
```

**Commit:** `fix: handle missing mother rabbit in births list`

---

### Task 5: Fix breeding edit flow

**Files:**
- Modify: `mobile/lib/core/router/app_router.dart`
- Modify: `mobile/lib/features/breeding/presentation/screens/breeding_detail_screen.dart`
- Modify: `mobile/lib/features/breeding/presentation/screens/breeding_form_screen.dart`
- Modify: `mobile/lib/features/breeding/data/repositories/breeding_repository.dart`

**Step 1:** Add update method to BreedingRepository if missing:
```dart
Future<BreedingModel> updateBreeding(int id, Map<String, dynamic> data) async {
  final response = await _apiClient.dio.put('/breeding/$id', data: data);
  // parse and return BreedingModel
}
```

**Step 2:** Update `BreedingFormScreen` to support edit mode:
```dart
final BreedingModel? breeding; // add field alongside initialData
```
In `initState`, if `breeding != null`, populate fields from it.
In `_submitForm`, if `breeding != null`, call `repository.updateBreeding(breeding!.id, data)` + `ref.invalidate(breedingDetailProvider(breeding!.id))`, else call `createBreeding`.

**Step 3:** Add route in `app_router.dart` after `/breeding/:id`:
```dart
GoRoute(
  path: '/breeding/:id/edit',
  name: 'breeding-edit',
  builder: (context, state) {
    final id = int.parse(state.pathParameters['id']!);
    final breeding = state.extra as BreedingModel?;
    return BreedingFormScreen(breeding: breeding);
  },
),
```

**Step 4:** Fix edit button in `breeding_detail_screen.dart` line ~23:
```dart
onPressed: () => context.push(
  '/breeding/${breedingId}/edit',
  extra: breeding, // BreedingModel from breedingAsync.value
),
```
Note: `breeding` is available inside `breedingAsync.when(data: (breeding) => ...)` — move AppBar actions inside or use a separate ConsumerWidget.

**Commit:** `feat: implement breeding edit flow`

---

## Phase 2: Окролы — Complete the flow

### Task 6: Add birth detail bottom sheet with actions

**Files:**
- Modify: `mobile/lib/features/rabbits/presentation/screens/births_list_screen.dart`

Replace the empty `onTap` in `_BirthCard` with a call to a bottom sheet:

```dart
onTap: () => _showBirthDetail(context, ref, birth, mother),
```

Add method `_showBirthDetail` in `_BirthsListScreenState`:

```dart
void _showBirthDetail(BuildContext context, WidgetRef ref, BirthModel birth, RabbitModel? mother) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) => _BirthDetailSheet(
      birth: birth,
      mother: mother,
      onEdit: () {
        Navigator.pop(context);
        context.push('/births/new', extra: birth); // birth_form handles edit mode
      },
      onDelete: () {
        Navigator.pop(context);
        _deleteBirth(birth);
      },
      onCreateKits: () {
        Navigator.pop(context);
        _createKitsForExistingBirth(context, ref, birth, mother);
      },
    ),
  );
}
```

**`_BirthDetailSheet`** widget shows:
- Мать: `mother?.name ?? 'Неизвестно'`
- Дата окрола
- Живых / Мёртвых / Отсажено
- Связанная случка (если `birth.breedingId != null`)
- Осложнения, заметки
- Three action buttons: Редактировать, Удалить, Создать крольчат
- "Создать крольчат" visible only if `birth.kitsBornAlive > 0`

**Commit:** `feat: add birth detail bottom sheet with actions`

---

### Task 7: Add "Создать крольчат" for existing birth

**Files:**
- Modify: `mobile/lib/features/rabbits/presentation/screens/births_list_screen.dart`

Add method `_createKitsForExistingBirth`:
```dart
Future<void> _createKitsForExistingBirth(
  BuildContext context,
  WidgetRef ref,
  BirthModel birth,
  RabbitModel? mother,
) async {
  if (mother == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Мать не найдена в списке')),
    );
    return;
  }
  // Reuse the same dialog logic from BirthFormScreen
  // Extract _createKitsDialog to a shared function or duplicate minimally here
  // Pass birth, mother, then call birthsProvider.notifier.createKitsFromBirth(...)
  // After success: ref.read(rabbitsListProvider.notifier).refresh()
}
```

The dialog pattern is identical to `_createKitsDialog` in `birth_form_screen.dart`. Extract it to a top-level function `showCreateKitsDialog(context, ref, birth, mother)` in a shared location or just in `births_list_screen.dart`.

**Commit:** `feat: add create kits button for existing births`

---

### Task 8: Wire birth form edit mode

**Files:**
- Modify: `mobile/lib/features/rabbits/presentation/screens/birth_form_screen.dart`
- Modify: `mobile/lib/core/router/app_router.dart`

`BirthFormScreen` already accepts `birth` parameter and has `isEditing` logic. The form calls `updateBirth` when editing. Just need to ensure the route `/births/new` handles `extra` as `BirthModel?`:

In `app_router.dart` on the `/births/new` route:
```dart
builder: (context, state) {
  final birth = state.extra as BirthModel?;
  final breeding = ...; // keep existing logic
  return BirthFormScreen(birth: birth, breeding: breeding);
},
```

Also ensure after update, `birthsProvider.notifier.loadBirths()` is called (check it's already done in `updateBirth`).

**Commit:** `fix: wire birth form edit mode via router extra`

---

## Phase 3: Задачи — Fix Pagination

### Task 9: Replace manual pagination with infinite scroll

**Files:**
- Modify: `mobile/lib/features/tasks/presentation/screens/tasks_list_screen.dart`

Current: uses `_currentPage` state + prev/next buttons.
Target: `ScrollController` pattern from `breeding_list_screen.dart`.

**Step 1:** Add `ScrollController`:
```dart
final _scrollController = ScrollController();

@override
void initState() {
  super.initState();
  _scrollController.addListener(_onScroll);
}

@override
void dispose() {
  _scrollController.dispose();
  super.dispose();
}

void _onScroll() {
  if (_scrollController.position.pixels >=
      _scrollController.position.maxScrollExtent - 200) {
    ref.read(tasksProvider.notifier).loadMore();
  }
}
```

**Step 2:** Remove `_buildPagination` widget and prev/next buttons from the UI.

**Step 3:** Pass `controller: _scrollController` to `ListView.builder`.

**Step 4:** Verify `TasksNotifier` has `loadMore()` — if not, add it following the pattern in `TransactionsNotifier`.

**Commit:** `fix: replace manual pagination with infinite scroll in tasks list`

---

## Phase 4: Здоровье — Complete CRUD

### Task 10: Ensure vaccinations bottom sheet has Edit + Delete

**Files:**
- Read: `mobile/lib/features/health/presentation/screens/vaccinations_list_screen.dart` (check current bottom sheet)
- Modify if bottom sheet lacks edit/delete actions

The bottom sheet should have:
- Full vaccination details (rabbit, vaccine name, date, next date, vet, notes)
- Edit button → `context.push('/vaccinations/form', extra: vaccination)`
- Delete button → confirm dialog → delete → `ref.read(vaccinationsProvider.notifier).refresh()`

After edit form saves, ensure invalidation: add `ref.read(vaccinationsProvider.notifier).refresh()` in `vaccination_form_screen.dart` after save/delete (same pattern as Task 1-3).

**Commit:** `feat: complete vaccination CRUD — edit/delete from list`

---

### Task 11: Add edit/delete to medical records list

**Files:**
- Modify: `mobile/lib/features/health/presentation/screens/medical_records_list_screen.dart`
- Modify: `mobile/lib/features/health/presentation/screens/medical_record_form_screen.dart`

Add long-press or trailing icon on each list tile → bottom sheet with Edit + Delete.
Edit: push to `/medical-records/form` with record as extra.
Delete: confirm → delete via provider → `ref.read(medicalRecordsProvider.notifier).refresh()`.

Add refresh after save/delete in `medical_record_form_screen.dart`.

**Commit:** `feat: add edit/delete actions to medical records list`

---

## Phase 5: Финансы — Detail bottom sheet

### Task 12: Add transaction detail bottom sheet

**Files:**
- Modify: `mobile/lib/features/finance/presentation/screens/transactions_list_screen.dart`

Tap on transaction card → `showModalBottomSheet` with:
- Full transaction info: тип, категория, сумма, дата, кролик (если есть), заметки
- Edit button → `context.push('/transactions/form', extra: transaction)`
- Delete button → confirm → delete → `ref.read(transactionsProvider.notifier).refresh()`

(Invalidation fix from Task 1 already covers the refresh.)

**Commit:** `feat: add transaction detail bottom sheet with edit/delete`

---

## Phase 6: Корма — Detail + Filters

### Task 13: Add feed detail bottom sheet

**Files:**
- Modify: `mobile/lib/features/feeding/presentation/screens/feeds_list_screen.dart`

Tap on feed card → bottom sheet with:
- Full feed details: название, тип, количество на складе, минимальный остаток
- Edit button → push to feed form with feed as extra
- Delete button → confirm → delete → refresh

**Commit:** `feat: add feed detail bottom sheet`

---

### Task 14: Add feeding record detail bottom sheet

**Files:**
- Modify: `mobile/lib/features/feeding/presentation/screens/feeding_records_list_screen.dart`

Same pattern: tap → bottom sheet → Edit + Delete.

**Commit:** `feat: add feeding record detail bottom sheet`

---

### Task 15: Implement feed filter dialog

**Files:**
- Modify: `mobile/lib/features/feeding/presentation/screens/feeds_list_screen.dart`

Replace snackbar on filter button with `showDialog`:
```dart
showDialog(
  context: context,
  builder: (_) => AlertDialog(
    title: const Text('Фильтры'),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // FeedType dropdown: Все / Сено / Зерно / Концентрат / Зелень / Прочее
        DropdownButtonFormField<FeedType?>(...)
        // Low stock toggle
        SwitchListTile(title: Text('Только низкий остаток'), ...)
      ],
    ),
    actions: [Reset, Apply],
  ),
);
```

Apply calls `ref.read(feedsProvider.notifier).loadFeeds(type: selectedType, lowStock: lowStockOnly)`.

Check `FeedsNotifier.loadFeeds` signature for supported params.

**Commit:** `feat: implement feed filter dialog`

---

## Execution Order

Tasks 1-5 → commit individually (Phase 1, ~30 min)
Tasks 6-8 → births module complete (~45 min)
Task 9 → tasks pagination (~15 min)
Tasks 10-11 → health module (~30 min)
Task 12 → finance (~20 min)
Tasks 13-15 → feeding module (~30 min)
