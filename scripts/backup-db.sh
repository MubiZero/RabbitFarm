#!/bin/sh
# Дамп базы RabbitFarm. Запускается ВНУТРИ контейнера MySQL — там есть
# mysqldump и там же лежат `MYSQL_ROOT_PASSWORD`/`MYSQL_DATABASE`:
#
#   docker exec <контейнер-db> sh -c "$(cat scripts/backup-db.sh)"
#
# В Coolify это Scheduled Task на ресурсе базы с тем же телом. Проверено
# 2026-09-13: дамп снят, развёрнут в отдельную базу, 29 таблиц и все
# количества строк совпали с источником.
set -e

DIR="${BACKUP_DIR:-/backups}"
KEEP="${BACKUP_KEEP:-14}"

# Каталог должен лежать на постоянном томе, иначе копии умрут вместе с
# контейнером при ближайшем передеплое — и «бэкап» окажется бумажным.
# И это НЕ /var/lib/mysql: рабочий каталог базы не место для архивов.
mkdir -p "$DIR"

FILE="$DIR/${MYSQL_DATABASE}-$(date +%F-%H%M%S).sql.gz"

# --single-transaction — снимок без блокировки таблиц (InnoDB);
# процедуры, триггеры и события иначе в дамп не попадают вовсе.
#
# Сначала пишем во временный файл и только потом переименовываем: если
# процесс оборвётся на середине, в каталоге не появится обрезанный архив,
# который выглядит как годная копия.
mysqldump -u root -p"$MYSQL_ROOT_PASSWORD" \
  --single-transaction --routines --triggers --events --hex-blob \
  "$MYSQL_DATABASE" | gzip > "$FILE.tmp"
mv "$FILE.tmp" "$FILE"

# Ротация: держим последние $KEEP копий.
ls -1t "$DIR/${MYSQL_DATABASE}"-*.sql.gz 2>/dev/null | tail -n "+$((KEEP + 1))" | while read -r old; do
  rm -f "$old"
done

echo "dump: $FILE ($(ls -lh "$FILE" | awk '{print $5}'))"
