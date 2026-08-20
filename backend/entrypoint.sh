#!/bin/sh
set -eu

# Адрес базы берётся из окружения, а не зашит: один и тот же образ
# работает и локально, и в Coolify, и в тестовом контуре.
DB_HOST="${DB_HOST:-db}"
DB_PORT="${DB_PORT:-3306}"

echo "Ожидание базы ${DB_HOST}:${DB_PORT}..."
i=0
until node -e "
  const net = require('net');
  const s = net.connect(Number(process.argv[2]), process.argv[1]);
  s.on('connect', () => { s.end(); process.exit(0); });
  s.on('error', () => process.exit(1));
  s.setTimeout(2000, () => { s.destroy(); process.exit(1); });
" "$DB_HOST" "$DB_PORT" 2>/dev/null; do
  i=$((i + 1))
  if [ "$i" -ge 60 ]; then
    echo "База не ответила за 60 попыток — выходим, пусть оркестратор перезапустит." >&2
    exit 1
  fi
  sleep 2
done
echo "База отвечает."

# MySQL открывает порт раньше, чем готов принимать запросы, поэтому
# миграции повторяем — вместо того чтобы гадать со `sleep`.
i=0
until npm run migrate; do
  i=$((i + 1))
  if [ "$i" -ge 10 ]; then
    echo "Миграции не прошли за 10 попыток." >&2
    exit 1
  fi
  echo "Миграции не прошли, попытка $i из 10..."
  sleep 3
done

if [ "${RUN_SEEDS:-false}" = "true" ]; then
  echo "Заполняем справочники (RUN_SEEDS=true)..."
  npm run seed
fi

echo "Запуск приложения..."
# exec — чтобы node получил PID процесса и сигналы от tini напрямую.
exec node src/server.js
