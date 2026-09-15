# Навыки Claude Code в этом проекте

Каждая папка рядом — отдельный навык: файл `SKILL.md` с инструкцией и папка `references/`
с подробностями. Claude подхватывает их сам, когда задача подходит под описание навыка;
вызывать руками ничего не нужно.

## Что откуда взято

Навыки скопированы (vendored) из публичных репозиториев, все под лицензией MIT.
Обновление — повторным копированием из источника.

| Навык | Источник | Для чего |
|---|---|---|
| `flutter-tester` | [Harishwarrior/flutter-claude-skills](https://github.com/Harishwarrior/flutter-claude-skills) | Тесты Flutter: unit, widget, integration; Riverpod и Mockito, структура Given-When-Then |
| `owasp-mobile-security-checker` | там же | Аудит по OWASP Mobile Top 10 (2024): секреты в коде, небезопасное хранилище, слабая криптография, сеть |
| `verification-before-completion` | [obra/superpowers](https://github.com/obra/superpowers) | Запрет говорить «готово» без запуска проверок и показа их вывода |
| `systematic-debugging` | там же | Сначала корневая причина, потом правка; лечение симптомов считается провалом |
| `mobile-android-design` | [wshobson/agents](https://github.com/wshobson/agents), плагин `ui-design` | Material Design 3 — база для нашего Flutter-интерфейса |
| `mobile-ios-design` | там же | Apple HIG — ориентир для Cupertino-экранов и поведения на iOS |
| `accessibility-compliance` | там же | WCAG 2.2 и мобильная доступность: контраст, размеры целей, скринридеры |
| `design-system-patterns` | там же | Токены, темизация, архитектура компонентов |
| `interaction-design` | там же | Микровзаимодействия, анимации переходов, состояния загрузки и обратная связь |
| `visual-design-foundations` | там же | Типографика, цвет, отступы, иконки |
| `frontend-design` | [anthropics/skills](https://github.com/anthropics/skills), Apache-2.0 | Вкус и визуальное направление: не давать интерфейсу выглядеть шаблонным. Почти не привязан к вебу, на Flutter ложится целиком |
| `ui-ux-pro-max` | [nextlevelbuilder/ui-ux-pro-max-skill](https://github.com/nextlevelbuilder/ui-ux-pro-max-skill) | Локальная база дизайн-решений: 192 палитры (есть готовая под агротех), 74 пары шрифтов, 119 правил UX, 52 правила по Flutter. Поиск — `python scripts/search.py «запрос» --stack flutter`, работает офлайн |
| `flutter-motion` | написан для этого проекта | Анимации на наших токенах `AppDuration`, уважение к «уменьшить движение», переходы go_router, Hero, дешёвые и дорогие свойства |

Из плагина `ui-design` сознательно **не** взяты `react-native-design`, `web-component-design`
и `responsive-design`: они про React Native и CSS, а у нас Flutter — такие навыки только
сбивали бы Claude на чужой стек.

По той же причине не взята [коллекция Vercel](https://github.com/vercel-labs/agent-skills):
она вся про Next.js, React и деплой в Vercel, а у репозитория к тому же нет лицензии —
переносить его файлы к себе юридически некорректно.

Навык `flutter-motion` написан здесь, а не скопирован: единственный внятный набор про
анимации во Flutter ([claude-flutter-ui-skills](https://github.com/Naimehossein77/claude-flutter-ui-skills))
опубликован без лицензии. Свой вариант к тому же знает про токены `AppDuration`,
`context.reduceMotion` и наши `DelayedSpinner` и `Skeleton` — чужой бы предлагал
писать `Duration(milliseconds: 300)` по месту.

## Связанное: Dart MCP-сервер

В `.mcp.json` подключён `dart mcp-server` — официальный мост в инструментарий Dart/Flutter
(входит в Dart SDK 3.9+, у нас 3.13). Он даёт Claude hot reload после правки, вывод
анализатора, запуск тестов с разбором падений и осмотр живого приложения через DevTools.

Запись сделана под Windows (`cmd /c dart mcp-server`), потому что `dart` здесь — `.bat`.
На macOS или Linux нужно заменить на:

```json
"dart": { "command": "dart", "args": ["mcp-server"] }
```
