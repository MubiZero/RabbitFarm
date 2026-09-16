#!/bin/sh
# Файлы, которые нельзя зашить в образ: проверка ссылок доменом и адреса
# магазинов. Лежит в /docker-entrypoint.d/ — nginx выполняет всё оттуда при
# старте контейнера сам, поэтому свой ENTRYPOINT не нужен.
#
# Проверка (Universal Links на iOS, App Links на Android) работает только
# тогда, когда домен подтверждает конкретное приложение: Team ID для Apple и
# отпечаток ключа подписи для Google. Отпечаток при этом — тот, которым
# подписывает сам Google (Play App Signing), и узнать его можно только после
# первой загрузки сборки в консоль. Поэтому значения приходят окружением и
# меняются без пересборки образа.
#
# Нет значения — нет и файла: пустой или выдуманный `assetlinks.json`
# проверку не пройдёт, но выглядеть будет настроенным, и разбираться с этим
# придётся уже по жалобам «ссылка открывает браузер вместо приложения».
set -eu

ROOT=/usr/share/nginx/html
WELL_KNOWN="$ROOT/.well-known"
mkdir -p "$WELL_KNOWN"

IOS_BUNDLE_ID="${IOS_BUNDLE_ID:-dev.mubi.rabbitfarm}"
ANDROID_PACKAGE="${ANDROID_PACKAGE:-dev.mubi.rabbitfarm}"

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
  echo "entrypoint: APPLE_TEAM_ID не задан — ссылки на iOS открываются браузером"
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
  echo "entrypoint: ANDROID_CERT_SHA256 не задан — ссылки на Android открываются браузером"
fi

# Адреса магазинов для страницы приглашения. Кнопка появляется только у
# заданного адреса.
{
  printf '{'
  SEP=''
  if [ -n "${APP_STORE_URL:-}" ]; then
    printf '%s"appStoreUrl":"%s"' "$SEP" "$APP_STORE_URL"
    SEP=','
  fi
  if [ -n "${PLAY_STORE_URL:-}" ]; then
    printf '%s"playStoreUrl":"%s"' "$SEP" "$PLAY_STORE_URL"
  fi
  printf '}\n'
} > "$ROOT/i/config.json"
