# Сборка мобильного приложения

Одна кодовая база даёт Android, iOS и web. Web собирается вместе с сервером
(см. [DEPLOY.md](DEPLOY.md)), здесь — про телефоны.

Адрес API вшивается в сборку: у Flutter нет рантайм-конфигурации, поэтому
`--dart-define=API_URL=...` обязателен, а смена домена требует пересборки.

## Android

### Через GitHub Actions

Сборку делает [`.github/workflows/mobile-release.yml`](../.github/workflows/mobile-release.yml):

- **вручную** — Actions → Mobile release → Run workflow, при желании подставив
  другой адрес API;
- **по тегу** `v1.2.3` — APK автоматически прикрепляются к релизу.

Перед сборкой прогоняются `flutter analyze` и тесты: релиз не должен уезжать
из красного кода.

Результат — APK, разделённые по архитектурам (`app-arm64-v8a-release.apk`
подходит практически всем современным устройствам), и `.aab` для Google Play.

### Подпись

Без ключа сборка подписывается **отладочным** ключом: на устройство встанет,
в Google Play — нет. Чтобы подписывать своим:

```bash
keytool -genkey -v -keystore upload-keystore.jks -keyalg RSA \
  -keysize 2048 -validity 10000 -alias upload
```

Локально положите файл в `mobile/android/` и создайте рядом `key.properties`:

```properties
storeFile=upload-keystore.jks
storePassword=...
keyAlias=upload
keyPassword=...
```

Оба файла в `.gitignore` — в репозиторий они не попадут.

Для CI добавьте секреты репозитория: `ANDROID_KEYSTORE_BASE64`
(`base64 -i upload-keystore.jks`), `ANDROID_STORE_PASSWORD`,
`ANDROID_KEY_ALIAS`, `ANDROID_KEY_PASSWORD`. Появятся секреты — workflow
подпишет сам, шаг подписи пропускается только когда их нет.

**Ключ нельзя терять.** Google Play принимает обновления только от той же
подписи: с новым ключом приложение придётся публиковать заново, под другим
идентификатором.

### Локально

```bash
cd mobile
flutter build apk --release --dart-define=API_URL=https://api.rabbitfarm.mubi.dev/api/v1
```

## iOS

В CI сборки нет намеренно: нужен macOS-раннер и сертификаты Apple, а платный
аккаунт разработчика и ключи — это ваше решение, а не то, что можно подставить
за вас. Собирается локально на маке:

```bash
cd mobile
flutter build ipa --release --dart-define=API_URL=https://api.rabbitfarm.mubi.dev/api/v1
```

Понадобится:

- Xcode и учётная запись Apple Developer (99 $ в год для App Store и TestFlight);
- в Xcode у таргета `Runner` — ваша Team в Signing & Capabilities;
- идентификатор приложения `dev.mubi.rabbitfarm` (уже прописан) зарегистрирован
  в Apple Developer.

Готовый `.ipa` окажется в `build/ios/ipa/` — оттуда его загружают в TestFlight
через Transporter или `xcrun altool`.

Если понадобится сборка iOS в CI, скажите — это отдельный workflow на
`macos-latest` с сертификатом и профилем в секретах.

## Иконка приложения

Кролик на зелёном — эмодзи из Noto Emoji на фоне акцентного цвета по
умолчанию (`AppColors.accentEmerald`). До этого везде стоял логотип Flutter
из шаблона: с ним Apple отклоняет сборку как незавершённую.

Файлы собраны скриптом и лежат в git; пересобрать после смены цвета или
рисунка:

```bash
cd mobile && python3 tool/make_app_icon.py
```

Скрипт раскладывает иконку по всем платформам сразу — iOS, macOS, Android
(обычная, adaptive и монохромная для тем Android 13), веб (favicon и
PWA-иконки, включая maskable) и Windows. Размеры для iOS и macOS он читает
из `Contents.json`, поэтому ничего не пропускает.

Три вещи, на которых легко ошибиться и которые скрипт делает сам:

- **В iOS-иконках нет альфа-канала** — файл с прозрачностью App Store не
  принимает.
- **На слоях, которые обрезает система, кролик мельче.** У adaptive-иконки
  Android гарантированно видна только центральная зона 66dp из 108dp, у
  maskable в вебе — круг в 80% ширины; рисунок «во весь холст» там лишится
  ушей.
- **Происхождение рисунка** — Noto Emoji под SIL Open Font License,
  см. [tool/ICON-NOTICE.md](../mobile/tool/ICON-NOTICE.md). Эмодзи Apple,
  на которое кролик похож в macOS и iOS, использовать в иконке нельзя.

## Идентификаторы

| Что | Значение |
|---|---|
| Android applicationId | `dev.mubi.rabbitfarm` |
| iOS bundle identifier | `dev.mubi.rabbitfarm` |
| Название на устройстве | Кроличья ферма |

Изначально в проекте стоял шаблонный `com.example.mobile` — с таким
идентификатором Google Play сборку не принимает.
