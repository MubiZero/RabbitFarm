# syntax=docker/dockerfile:1

# --- сборка веб-версии ---------------------------------------------------
# 3.47.0, не более раннюю: freezed ^4.0.1 (см. коммит про апгрейд
# кодогенерации) требует Dart >=3.13.0, которого 3.41.6 ещё не несёт —
# `flutter pub get` на нём отказывает с тех пор, как этот образ ни разу не
# пересобирался. Версия та же, что и в .github/workflows/mobile-release.yml.
FROM ghcr.io/cirruslabs/flutter:3.47.0 AS build
WORKDIR /app

# Адрес API вшивается в бандл на этапе сборки: у Flutter web нет
# рантайм-окружения, читать переменные во время работы неоткуда.
ARG API_URL
RUN test -n "$API_URL" || (echo "Не задан build-arg API_URL" >&2; exit 1)
# Sentry DSN — опционально, как и на бэкенде: пустая строка выключает SDK,
# сборка не падает без него.
ARG SENTRY_DSN=""

# Зависимости отдельным слоем — правка кода не тянет повторный pub get.
COPY pubspec.yaml pubspec.lock ./
RUN flutter pub get

COPY . .
RUN flutter build web --release --dart-define=API_URL="$API_URL" --dart-define=SENTRY_DSN="$SENTRY_DSN"

# --- раздача -------------------------------------------------------------
FROM nginx:1.27-alpine AS runtime

COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=build /app/build/web /usr/share/nginx/html

EXPOSE 80

HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
  CMD wget -qO- http://127.0.0.1/healthz >/dev/null 2>&1 || exit 1
