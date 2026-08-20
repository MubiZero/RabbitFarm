# syntax=docker/dockerfile:1

# --- сборка веб-версии ---------------------------------------------------
FROM ghcr.io/cirruslabs/flutter:3.41.6 AS build
WORKDIR /app

# Адрес API вшивается в бандл на этапе сборки: у Flutter web нет
# рантайм-окружения, читать переменные во время работы неоткуда.
ARG API_URL
RUN test -n "$API_URL" || (echo "Не задан build-arg API_URL" >&2; exit 1)

# Зависимости отдельным слоем — правка кода не тянет повторный pub get.
COPY pubspec.yaml pubspec.lock ./
RUN flutter pub get

COPY . .
RUN flutter build web --release --dart-define=API_URL="$API_URL"

# --- раздача -------------------------------------------------------------
FROM nginx:1.27-alpine AS runtime

COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=build /app/build/web /usr/share/nginx/html

EXPOSE 80

HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
  CMD wget -qO- http://127.0.0.1/healthz >/dev/null 2>&1 || exit 1
