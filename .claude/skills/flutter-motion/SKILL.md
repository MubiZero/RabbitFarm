---
name: flutter-motion
description: Анимации и движение в мобильном приложении RabbitFarm (Flutter). Использовать при добавлении или правке любой анимации, перехода между экранами, микровзаимодействия, состояния загрузки, появления и исчезновения элементов, а также при жалобах на дёрганый интерфейс, подвисания и мигание спиннеров. Опирается на токены AppDuration проекта, Material 3 и требование уважать отключённые анимации.
---

# Движение в RabbitFarm

Движение здесь — не украшение, а объяснение: оно показывает, откуда взялся элемент
и куда он делся. Анимация, которая ничего не объясняет, подлежит удалению.

## 1. Длительности и кривые берём из дизайн-системы

В `mobile/lib/core/theme/app_duration.dart` уже есть токены. Голые
`Duration(milliseconds: 300)` в коде экранов — ошибка, даже если число совпадает
с токеном: через полгода токен изменят, а хардкод останется.

| Токен | Значение | Для чего |
|---|---|---|
| `AppDuration.instant` | 120 мс | отклик на касание: подсветка, нажатие, переключатель |
| `AppDuration.fast` | 200 мс | появление и скрытие элементов внутри экрана |
| `AppDuration.normal` | 300 мс | разворачивание блоков, смена состояния экрана |
| `AppDuration.slow` | 900 мс | пульсация скелетонов |
| `AppDuration.spinnerDelay` | 250 мс | задержка перед показом индикатора загрузки |
| `AppDuration.curve` | `Curves.easeOutCubic` | кривая по умолчанию |

Нужной длительности нет — **добавь новый токен в `AppDuration` с комментарием
«для чего»**, а не число по месту. Импорт один: `import '../../core/theme/theme.dart';`

Если понадобится более точная раскладка по Material 3, в Flutter SDK есть
готовые `Durations.short1…extralong4` и `Easing.standard`,
`Easing.emphasizedDecelerate`, `Easing.emphasizedAccelerate`. Ими наполняют
`AppDuration`, а не экраны.

## 2. Отключённые анимации — обязательны, а не «приятное дополнение»

В системных настройках iOS и Android есть «уменьшить движение». Приложение обязано
его слушать: для части людей анимация вызывает тошноту и головокружение.

```dart
if (context.reduceMotion) {
  return child; // статичный вариант, без движения
}
```

`context.reduceMotion` — расширение из `core/theme/theme.dart`. Правильный ответ —
**показать конечное состояние сразу**, а не ускорить анимацию. Образец —
`core/widgets/skeleton.dart`.

## 3. Что уже есть — не переписывать заново

- `DelayedSpinner` (`core/widgets/delayed_spinner.dart`) — индикатор с паузой
  250 мс, чтобы быстрый ответ не мигал спиннером. Любой новый экран с загрузкой
  берёт его, а не голый `CircularProgressIndicator`.
- `Skeleton` (`core/widgets/skeleton.dart`) — заглушка с пульсацией и с уважением
  к `reduceMotion`. Каркас должен повторять геометрию будущего контента, иначе
  при загрузке экран дёрнется.

## 4. Неявная анимация или явная

```
Меняется одно-два свойства (размер, цвет, прозрачность, сдвиг)
  └── неявная: AnimatedContainer, AnimatedOpacity, AnimatedAlign, TweenAnimationBuilder

Последовательность, повтор, пауза, реакция на жест, точный контроль
  └── явная: AnimationController + CurvedAnimation + AnimatedBuilder
```

Начинай с неявной. `AnimationController` ради обычного появления — лишние
`initState`, `dispose` и риск утечки.

```dart
AnimatedContainer(
  duration: AppDuration.normal,
  curve: AppDuration.curve,
  height: expanded ? 220 : 96,
  child: child,
)
```

У явной анимации контроллер **обязан** освобождаться, иначе тикер продолжает
работать после ухода с экрана:

```dart
class _State extends State<X> with SingleTickerProviderStateMixin {
  late final _controller = AnimationController(vsync: this, duration: AppDuration.fast);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
```

Несколько контроллеров — `TickerProviderStateMixin` (без `Single`).

## 5. Что анимировать дёшево, а что дорого

Плавно (работает на видеокарте):
`Transform.translate`, `Transform.scale`, `Transform.rotate`, `Opacity`,
`FadeTransition`, `SlideTransition`, `ScaleTransition`.

Дорого (заставляет пересчитывать разметку каждый кадр):
`width`, `height`, `padding`, `margin`, `Positioned.top/left`, `decoration`.

Правило: сдвинуть или увеличить — через `Transform`, а не через изменение размеров.
Тяжёлый неподвижный сосед рядом с анимацией оборачивается в `RepaintBoundary`.
В `TweenAnimationBuilder` и `AnimatedBuilder` неизменную часть передавай
параметром `child` — иначе она перестраивается каждый кадр.

## 6. Переходы между экранами — через go_router

Навигация в `core/router/app_router.dart`. Свой переход задаётся
`CustomTransitionPage`, а не `Navigator.push` в обход роутера:

```dart
GoRoute(
  path: '/rabbits/:id',
  name: 'rabbit-detail',
  pageBuilder: (context, state) => CustomTransitionPage(
    key: state.pageKey,
    child: RabbitDetailScreen(rabbitId: int.parse(state.pathParameters['id']!)),
    transitionDuration: AppDuration.fast,
    transitionsBuilder: (context, animation, _, child) =>
        FadeTransition(opacity: animation, child: child),
  ),
)
```

Сейчас все маршруты объявлены через `builder` и получают переход платформы
по умолчанию. Менять маршрут на `pageBuilder` стоит только ради конкретного
осмысленного перехода, а не «чтобы было красивее».

Переход по умолчанию (родной для платформы) лучше кастомного: пользователь уже
знает, как ведёт себя его система. Свой переход оправдан, когда он показывает
связь экранов, — например, карточка кролика разворачивается в его страницу.

## 7. Общий элемент между экранами — Hero

Уже работает на фото кролика: список и карточка используют одну метку
`rabbit_photo_${rabbit.id}` (`rabbits_list_screen.dart` и
`rabbit_detail_screen.dart`), поэтому фото не мигает, а перелетает.

```dart
Hero(tag: 'rabbit_photo_${rabbit.id}', child: RabbitAvatar(photoUrl: rabbit.photoUrl))
```

Метка обязана быть уникальной в пределах экрана — обычно это идентификатор
сущности. Две одинаковые метки на одном экране роняют кадр с исключением.
В списках следи, чтобы метка не повторилась у элемента и у его превью.

## 8. Каскад в списках

Элементы списка появляются с нарастающей задержкой через `Interval`:

```dart
final slot = CurvedAnimation(
  parent: _controller,
  curve: Interval(index * 0.05, 1.0, curve: AppDuration.curve),
);
```

Каскад уместен максимум на 5–7 видимых элементах и только при первом показе.
На прокрутке длинного списка он превращает интерфейс в мигающую ленту.

## 9. Перед тем как сказать «готово»

- Длительности взяты из `AppDuration`, голых чисел в экране не осталось.
- `context.reduceMotion` обработан — проверено включением «уменьшить движение»
  в настройках устройства или симулятора.
- Все `AnimationController` освобождены в `dispose`.
- Анимация проверена на живом приложении (hot reload через MCP-сервер `dart`),
  а не только в голове: `flutter run`, затем посмотреть глазами.
- Анимация объясняет переход. Если её убрать и ничего не потеряется — убрать.
