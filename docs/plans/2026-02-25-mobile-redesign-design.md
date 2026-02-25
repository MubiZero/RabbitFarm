# RabbitFarm Mobile — Total Redesign Design Document

**Date:** 2026-02-25
**Author:** Principal Product Designer (Claude)
**Status:** Approved

---

## Overview

Full redesign of the RabbitFarm Flutter mobile app from a fragmented, inconsistent UI to a unified Design System Dark experience. Target: individual farmers and commercial farm teams. All screens in scope.

---

## 1. Design System Tokens

### Color Palette

#### Dark Mode (default)
| Token | Value | Usage |
|---|---|---|
| `background` | `#0A0D14` | Scaffold background |
| `surface` | `#131720` | Cards, sheets |
| `surfaceVariant` | `#1C2130` | Inputs, nested elements |
| `border` | `#2A3142` | Dividers, input borders |
| `textPrimary` | `#F0F4FF` | Main text |
| `textSecondary` | `#8B95B0` | Secondary text |
| `textHint` | `#4A5168` | Placeholder, disabled |

#### Light Mode (system-adaptive)
| Token | Value |
|---|---|
| `background` | `#F4F6FB` |
| `surface` | `#FFFFFF` |
| `surfaceVariant` | `#EEF0F6` |
| `border` | `#E0E4EE` |
| `textPrimary` | `#0F172A` |
| `textSecondary` | `#64748B` |
| `textHint` | `#94A3B8` |

#### Accent Colors (user selects one)
| Name | Value | Token |
|---|---|---|
| Emerald (default) | `#10B981` | `accent` |
| Ocean | `#3B82F6` | |
| Sunset | `#F59E0B` | |
| Rose | `#EC4899` | |
| Violet | `#8B5CF6` | |

#### Semantic Colors (unchanged)
| Token | Value |
|---|---|
| `error` | `#EF4444` |
| `success` | `#10B981` |
| `warning` | `#F59E0B` |
| `info` | `#3B82F6` |

### Typography

Font: Inter (or system font fallback). Scale:
| Style | Size | Weight | Usage |
|---|---|---|---|
| `displayLg` | 32 | Bold | Screen titles |
| `displayMd` | 24 | SemiBold | Section headings |
| `titleLg` | 20 | SemiBold | Card titles |
| `titleMd` | 16 | SemiBold | List item titles |
| `bodyLg` | 16 | Regular | Body text |
| `bodyMd` | 14 | Regular | Secondary body |
| `labelLg` | 14 | Medium | Buttons, tags |
| `labelSm` | 12 | Medium | Captions, badges |

### Border Radius Tokens
| Token | Value | Usage |
|---|---|---|
| `radius.sm` | 8px | Chips, badges |
| `radius.md` | 12px | Inputs, buttons |
| `radius.lg` | 16px | Cards |
| `radius.xl` | 24px | Bottom sheets, modals |
| `radius.full` | 999px | Pills, avatars |

### Elevation (Dark Mode: surfaces, not shadows)
Dark mode uses progressively lighter surface colors for elevation instead of box shadows (Material3 tonal elevation principle).

---

## 2. Onboarding Flow

### Trigger
- First app launch (no auth token)
- Onboarding completed flag stored in SharedPreferences

### Flow
```
Splash (1.5s) → Onboarding Screens → Auth (Register/Login) → Main App → Product Tour
```

### Splash Screen
- Dark background, animated logo (🐇 + "RabbitFarm")
- Auto-redirect: if token valid → Main App; if no token → Onboarding

### Onboarding Screens (3 steps)

**Step 1 — Welcome**
- Full-screen dark background
- Animated illustration (Lottie or static SVG of rabbit farm)
- Title: "Управляйте фермой умно"
- Subtitle: "Кролики, кормление, здоровье — всё в одном месте"
- CTA: "Начать" (primary button)
- Link: "Уже есть аккаунт?" → goes to Login

**Step 2 — Farm Name**
- Progress indicator: step 1/3
- Title: "Как называется ваша ферма?"
- Large text field, placeholder "Например: Ферма 'Берёзки'"
- "Далее" / "Пропустить"

**Step 3 — Farm Type**
- Progress indicator: step 2/3
- Title: "Как вы управляете фермой?"
- Two large option cards:
  - 👤 "Один хозяин" — я управляю фермой самостоятельно
  - 👥 "Команда" — у меня есть сотрудники с разными ролями
- "Далее" button enabled on selection

**Step 4 — Ready**
- Progress indicator: step 3/3
- Checkmark animation
- Title: "Ферма [name] готова!"
- Subtitle: "Настроим всё остальное вместе"
- CTA: "Зарегистрироваться" / "Войти"

### Product Tour (after first login)
Triggered once on first successful login. CoachMark overlays guide user through:
1. Today screen greeting + summary widgets
2. Alert cards (requires attention section)
3. Quick actions row
4. Bottom navigation tabs
5. FAB (+ button)
6. Menu tab → Settings

CoachMarks: dark scrim, highlighted element, tooltip with title + 1-line description, "Далее" / "Пропустить всё" buttons.

---

## 3. Authentication Screens

### Login Screen
Layout (dark background `#0A0D14`):
1. Top spacer (15% height)
2. Logo: animated 🐇 icon + "RabbitFarm" text + subtitle
3. Social auth section:
   - "Войти через Google" (outlined button with Google icon)
   - "Войти через Apple" (outlined button with Apple icon) — iOS only
4. Divider "──── или ────"
5. Email input field
6. Password input field (with show/hide toggle)
7. "Забыли пароль?" link (right-aligned)
8. "Войти" primary button (accent color, full width)
9. "Нет аккаунта? Зарегистрироваться" text link

**Remove:** test credentials block (dev-only, use .env flag)

### Register Screen
Similar layout. Fields: Name, Email, Password, Confirm Password. Social auth at top. Same Google/Apple buttons.

---

## 4. Navigation Architecture

### Bottom Navigation Bar (4 tabs)
| Index | Icon | Label | Route |
|---|---|---|---|
| 0 | home_outlined / home | Главная | /today |
| 1 | pets_outlined / pets | Кролики | /rabbits |
| 2 | bar_chart_outlined / bar_chart | Аналитика | /dashboard |
| 3 | menu | Меню | /menu |

**Design:** Bottom nav bar with `surface` background, pill indicator under active tab (accent color), no box elevation — use top border `border` color token.

### FAB
Context-sensitive, shown on Today and Rabbits screens. Opens bottom sheet with quick actions.

### App Bar
Transparent or `surface` background. No colored gradient headers. Title left-aligned (Material3 standard), notification bell + avatar/initials right side.

### Menu Screen (replaces "Еще")
Structure:
```
Header: Profile card (avatar, name, farm name, role)
─────────────────────────────
Здоровье
  Вакцинации
  Медицинские карты
─────────────────────────────
Разведение
  Случки
  Роды
  Породы
  Клетки
─────────────────────────────
Управление
  Корма
  Кормления
  Задачи
  Финансы
  Отчёты
─────────────────────────────
Прочее
  Фото
  Заметки
─────────────────────────────
Настройки →
```
Each item: icon (24px, accent color), title, arrow. Clean list style, not a grid.

---

## 5. Key Screen Redesigns

### Today (Home) Screen

```
AppBar: "RabbitFarm" + 🔔 + 👤
─────────────────────────────
Добрый день, [Имя]!        ← personalized time-based greeting
Пятница, 25 февраля

[Summary Widget Row]        ← configurable widgets (2 shown)
┌────────────┐ ┌────────────┐
│  🐰 127    │ │  ⚡ 3 зад.  │
│  Кролики   │ │  Задачи    │
└────────────┘ └────────────┘

Требует внимания
━━━━━━━━━━━━━━━━━━━━━━━━━━━
⚠️  Просрочено вакцинаций: 2   →
🍽   Корм на исходе: 1 вид     →
[empty state: "Всё в порядке ✓"]

Быстрые действия
━━━━━━━━━━━━━━━━━━━━━━━━━━━
[🍽 Корм] [💉 Вакц] [✓ Задача] [➕ Ещё]
```

### Settings / Profile Screen

```
AppBar: ← Настройки

Профиль
┌────────────────────────────┐
│ 👤 [avatar]                │
│ Иван Иванов                │
│ Ферма "Берёзки" · Владелец │
└────────────────────────────┘
[Редактировать профиль]

Внешний вид
  Тема               [ Тёмная / Светлая / Авто ]
  Акцентный цвет     ● ● ● ● ●  (5 swatches)

Дашборд
  Настроить виджеты   →

Уведомления           →
Экспорт данных        →
О приложении          →
────────────────────────────
[Выйти из аккаунта]  (destructive, red text)
```

### Dashboard Widget Customization

Grid drag-and-drop (or up/down arrows for simplicity). Available widgets:
- Итого кролики
- Задачи (ожидают / срочные)
- Низкий запас корма
- Скоро вакцинации
- Финансы (доход/расход за месяц)
- Роды за 30 дней

User can add/remove/reorder. Max 4 widgets visible on Today screen.

---

## 6. Component Library

### AppCard
Dark surface (`#131720`), `radius.lg`, no shadow in dark mode.
Variants: default, highlighted (accent border), error (error border).

### AppButton
Primary: accent fill, white text, `radius.md`, 48px height.
Secondary: transparent, accent border + text.
Destructive: `error` fill or text.
Loading state: inline CircularProgressIndicator.

### AppInput
Surface variant background, border color token, `radius.md`, 52px height.
States: default, focused (accent border 2px), error (error border + helper text).

### StatusBadge
Compact chip: `labelSm` text, colored background at 15% opacity, matching text color.
Types: active (green), inactive (grey), sick (red), pregnant (pink), sold (amber).

### AlertCard
Left colored border (4px), icon + title + description row. Tap navigates to relevant screen.

### CoachMark
Dark scrim overlay, rounded highlight cutout, tooltip box with arrow, title + description + buttons.

---

## 7. Animation Principles

- **Transitions:** Hero animations for detail views; shared element transitions for rabbit cards.
- **Page transitions:** Slide from right for push, fade for tab changes.
- **Micro-interactions:** Button press scale (0.97), card tap ripple.
- **Loading states:** Shimmer skeleton screens (not spinners on full page).
- **FAB:** Expand animation (rotate icon, expand label).
- **Onboarding:** Fade + slide-up per screen. Lottie for welcome illustration.

---

## 8. Accessibility

- Minimum touch target: 48×48px
- Color contrast: WCAG AA minimum (4.5:1 for text)
- Semantic labels for all icons
- Support system font size scaling

---

## 9. Implementation Phases

### Phase 1 — Design System Foundation
- New `AppTheme` with dark/light tokens
- Color token system + accent color provider (Riverpod)
- Typography scale
- Core components: AppCard, AppButton, AppInput, StatusBadge, AlertCard

### Phase 2 — Auth & Onboarding
- Splash screen
- Onboarding flow (3 steps + ready screen)
- Redesigned Login + Register with Google/Apple sign-in
- Product tour (CoachMark system)

### Phase 3 — Navigation & Shell
- New 4-tab bottom navigation
- Redesigned Menu screen (structured list, profile header)
- App bar standardization (no gradient headers)
- FAB cleanup

### Phase 4 — Today & Dashboard
- Today screen redesign (personalized greeting, configurable widgets)
- Dashboard widget customization screen
- Alert cards redesign

### Phase 5 — Settings & Profile
- Profile screen implementation (currently TODO)
- Settings screen: theme switcher, accent color picker
- App settings: notifications, data export

### Phase 6 — Feature Screens Polish
- Apply design tokens to all feature screens (rabbits, feeding, health, etc.)
- Remove hardcoded colors
- Standardize list/detail/form patterns

---

## 10. Out of Scope (this iteration)

- Role-based access control UI (commercial team features)
- Push notifications implementation
- Google/Apple sign-in backend integration
- Data export functionality
- Offline mode UI
