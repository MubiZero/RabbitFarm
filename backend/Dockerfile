# syntax=docker/dockerfile:1

# --- зависимости ---------------------------------------------------------
# Отдельный слой: пересобирается только при изменении package*.json,
# поэтому правка кода не тянет за собой переустановку пакетов.
FROM node:20-alpine AS deps
WORKDIR /app
COPY package.json package-lock.json ./
# ci, а не install: ставит ровно то, что зафиксировано в lock-файле.
RUN npm ci --omit=dev && npm cache clean --force

# --- рантайм -------------------------------------------------------------
FROM node:20-alpine AS runtime

# tini как PID 1: без него SIGTERM не доходит до node и контейнер
# останавливается по таймауту вместо аккуратного завершения.
RUN apk add --no-cache tini

WORKDIR /app
ENV NODE_ENV=production \
    PORT=4567

COPY --from=deps /app/node_modules ./node_modules
COPY --chown=node:node . .

# Каталоги загрузок и логов должны быть записываемыми не-root пользователем.
RUN mkdir -p uploads/rabbits uploads/receipts logs \
    && chown -R node:node uploads logs

# Процесс работает от непривилегированного пользователя: выход из контейнера
# через уязвимость в приложении не даёт root на хосте.
USER node

EXPOSE 4567

# Для docker-compose Coolify берёт состояние сервиса именно отсюда.
HEALTHCHECK --interval=30s --timeout=5s --start-period=40s --retries=3 \
  CMD wget -qO- "http://127.0.0.1:${PORT}/health" >/dev/null 2>&1 || exit 1

ENTRYPOINT ["/sbin/tini", "--", "./entrypoint.sh"]
