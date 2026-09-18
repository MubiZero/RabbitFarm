#!/bin/sh
# Адреса, которые нельзя зашить в образ: куда ведёт кнопка «Открыть
# приложение» и откуда качают сборку для Android. Лежит в
# /docker-entrypoint.d/ — nginx выполняет всё оттуда при старте сам,
# поэтому свой ENTRYPOINT не нужен.
#
# Тот же приём, что у страницы приглашения (mobile/nginx-app-links.sh):
# адрес магазина появляется в день публикации, а не в день пересборки.
# Пустое значение оставляет кнопку скрытой: ссылка в никуда хуже, чем её
# отсутствие.
set -eu

ROOT=/usr/share/nginx/html

APP_URL="${APP_URL:-https://rabbitfarm.click}"
ANDROID_APK_URL="${ANDROID_APK_URL:-}"

cat > "$ROOT/config.json" <<JSON
{
  "appUrl": "${APP_URL}",
  "androidApkUrl": "${ANDROID_APK_URL}"
}
JSON

echo "Лендинг: приложение ${APP_URL}, сборка Android ${ANDROID_APK_URL:-не задана}"
