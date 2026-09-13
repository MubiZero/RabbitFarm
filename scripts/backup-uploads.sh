#!/bin/sh
# Зеркало бакета с фотографиями. Запускается ВНУТРИ контейнера MinIO — там
# есть `mc` и переменные `MINIO_ROOT_USER`/`MINIO_ROOT_PASSWORD`:
#
#   docker exec <контейнер-minio> sh -c "$(cat scripts/backup-uploads.sh)"
#
# В Coolify это Scheduled Task на ресурсе MinIO с тем же телом. Проверено
# 2026-09-13: 36 объектов ушли в зеркало и вернулись обратно в отдельный
# бакет, md5 файла совпал с оригиналом.
#
# Зачем вообще: фото — единственные данные, которых нет в дампе базы. В базе
# лежит только путь к файлу, сам файл живёт в томе MinIO. Потеря тома
# означает карточки кроликов без единого снимка.
set -e

BUCKET="${MINIO_BUCKET:-rabbitfarm-uploads}"
DIR="${BACKUP_DIR:-/backups}/uploads"

# Каталог должен лежать на постоянном томе — том же соображении, что и у
# дампов базы (см. backup-db.sh).
mkdir -p "$DIR"

mc alias set backup-local "http://127.0.0.1:9000" \
  "$MINIO_ROOT_USER" "$MINIO_ROOT_PASSWORD" > /dev/null

# --remove удаляет в зеркале то, чего больше нет в бакете: зеркало повторяет
# хранилище, а не копит навсегда всё, что когда-либо было. Защита от
# случайного удаления — это отдельные ежедневные дампы базы и выгрузка
# наружу, а не бесконечно растущее зеркало на том же сервере.
mc mirror --overwrite --remove --quiet "backup-local/$BUCKET" "$DIR"

echo "mirror: $DIR ($(mc ls --recursive "$DIR" | wc -l) файлов)"
