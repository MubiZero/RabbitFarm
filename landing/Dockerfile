# syntax=docker/dockerfile:1

# Лендинг rabbitfarm.click. Сборка это `node build.js`: четыре статические
# страницы из одного шаблона и словарей, без npm install и без бандлера.
FROM node:20-alpine AS build

WORKDIR /landing
COPY . .
RUN node build.js

# --- раздача -------------------------------------------------------------
FROM nginx:1.27-alpine AS runtime

COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=build /landing/dist /usr/share/nginx/html
# Адреса приложения и сборки для Android приходят из окружения при старте:
# ссылка на магазин появляется в день публикации, а не в день пересборки.
COPY docker-entrypoint.sh /docker-entrypoint.d/40-config.sh
RUN chmod +x /docker-entrypoint.d/40-config.sh

EXPOSE 80

HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
  CMD wget -qO- http://127.0.0.1/healthz >/dev/null 2>&1 || exit 1
