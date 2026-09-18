#!/bin/sh
# Файлы, которые нельзя зашить в образ: адреса кнопок, адреса магазинов и
# проверка ссылок доменом. Лежит в /docker-entrypoint.d/ — nginx выполняет
# всё оттуда при старте контейнера сам, поэтому свой ENTRYPOINT не нужен.
#
# Здесь же, а не на сервисе `web`, потому что ссылка-приглашение и проверка
# ссылок живут на главном домене (`rabbitfarm.click/i`), а его отдаёт
# лендинг.
#
# Пустое значение всегда означает «файла нет». Выдуманный `assetlinks.json`
# проверку не пройдёт, но будет выглядеть настроенным, и разбираться с этим
# придётся уже по жалобам «ссылка открывает браузер вместо приложения». То
# же и с кнопками: ссылка в никуда хуже её отсутствия.
set -eu

ROOT=/usr/share/nginx/html
WELL_KNOWN="$ROOT/.well-known"
mkdir -p "$WELL_KNOWN"

APP_URL="${APP_URL:-https://app.rabbitfarm.click}"
ANDROID_APK_URL="${ANDROID_APK_URL:-}"
IOS_BUNDLE_ID="${IOS_BUNDLE_ID:-dev.mubi.rabbitfarm}"
ANDROID_PACKAGE="${ANDROID_PACKAGE:-dev.mubi.rabbitfarm}"

# Куда ведут кнопки лендинга.
cat > "$ROOT/config.json" <<JSON
{
  "appUrl": "${APP_URL}",
  "androidApkUrl": "${ANDROID_APK_URL}"
}
JSON
echo "entrypoint: приложение ${APP_URL}, сборка Android ${ANDROID_APK_URL:-не задана}"

# Проверка ссылок доменом. Team ID у Apple и отпечаток ключа подписи у
# Google появляются позже самой сборки (отпечаток Play App Signing виден
# только после первой загрузки в консоль), поэтому приходят окружением.
if [ -n "${APPLE_TEAM_ID:-}" ]; then
  cat > "$WELL_KNOWN/apple-app-site-association" <<JSON
{
  "applinks": {
    "details": [
      {
        "appIDs": ["${APPLE_TEAM_ID}.${IOS_BUNDLE_ID}"],
        "components": [
          { "/": "/i", "comment": "Приглашение работника" },
          { "/": "/i/*", "comment": "Приглашение работника" }
        ]
      }
    ]
  }
}
JSON
  echo "entrypoint: apple-app-site-association записан для ${APPLE_TEAM_ID}.${IOS_BUNDLE_ID}"
else
  rm -f "$WELL_KNOWN/apple-app-site-association"
  echo "entrypoint: APPLE_TEAM_ID не задан, ссылки на iOS открываются браузером"
fi

if [ -n "${ANDROID_CERT_SHA256:-}" ]; then
  cat > "$WELL_KNOWN/assetlinks.json" <<JSON
[
  {
    "relation": ["delegate_permission/common.handle_all_urls"],
    "target": {
      "namespace": "android_app",
      "package_name": "${ANDROID_PACKAGE}",
      "sha256_cert_fingerprints": ["${ANDROID_CERT_SHA256}"]
    }
  }
]
JSON
  echo "entrypoint: assetlinks.json записан для ${ANDROID_PACKAGE}"
else
  rm -f "$WELL_KNOWN/assetlinks.json"
  echo "entrypoint: ANDROID_CERT_SHA256 не задан, ссылки на Android открываются браузером"
fi

# Адреса магазинов для страницы приглашения: кнопка появляется только у
# заданного адреса. Веб-версия на странице всегда доступна, поэтому пустой
# файл это рабочее состояние, а не поломка.
{
  printf '{"webUrl":"%s"' "$APP_URL"
  SEP=','
  if [ -n "${APP_STORE_URL:-}" ]; then
    printf '%s"appStoreUrl":"%s"' "$SEP" "$APP_STORE_URL"
    SEP=','
  fi
  if [ -n "${PLAY_STORE_URL:-}" ]; then
    printf '%s"playStoreUrl":"%s"' "$SEP" "$PLAY_STORE_URL"
  fi
  printf '}\n'
} > "$ROOT/i/config.json"
