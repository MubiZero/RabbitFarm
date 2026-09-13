# syntax=docker/dockerfile:1

# --- сборка веб-версии ---------------------------------------------------
# SDK ставится из официального архива, а не берётся готовым образом
# `ghcr.io/cirruslabs/flutter`: тег 3.47.0 из того реестра пропал, и деплой
# встал на «not found» (2026-09-13). Оставаться на их последнем теге нельзя —
# он несёт Dart 3.12, а freezed ^4.0.1 требует >=3.13.0.
#
# 3.47.0 — та же версия, что стоит локально и в
# .github/workflows/mobile-release.yml; архивы на storage.googleapis.com
# лежат для всех выпущенных версий и не исчезают.
FROM debian:bookworm-slim AS build

ARG FLUTTER_VERSION=3.47.0
RUN apt-get update && apt-get install -y --no-install-recommends \
      ca-certificates curl git unzip xz-utils zip \
    && rm -rf /var/lib/apt/lists/*
RUN curl -fsSL "https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_${FLUTTER_VERSION}-stable.tar.xz" \
      | tar -xJ -C /opt
ENV PATH="/opt/flutter/bin:/opt/flutter/bin/cache/dart-sdk/bin:${PATH}"
# Flutter отказывается работать в чужом git-чекауте без этой отметки —
# распакованный архив принадлежит root, а сборка идёт от него же.
RUN git config --global --add safe.directory /opt/flutter \
    && flutter --version

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
