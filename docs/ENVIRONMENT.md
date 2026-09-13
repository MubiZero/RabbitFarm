# Окружение разработки: что не в git и что мешает

Короткая выжимка из `docs/HANDOFF.md`, который вёлся по ходу работы и удалён
за ненадобностью. Здесь только то, что не восстановить из кода: секреты, их
происхождение и ловушки среды, на которые уже потрачено время.

## Настроено локально, НЕ в git

`backend/.env` (гитигнорится) содержит реальные тестовые креды:
- `ESKHATA_*` — тестовый контур банка (id организации, merchID, hash key).
- `SMS_API_TOKEN` — реальный токен Payom, `SMS_TEMPLATE_IDS` — маппинг
  `user.verification_code` → готовый templateId.

Актуальные плейсхолдеры и комментарии — в `backend/.env.example`. Значения
самих секретов у владельца проекта, в репозитории их нет намеренно.

`mobile/ios/Runner/GoogleService-Info.plist` (гитигнорится, как и
`android/app/google-services.json`) — конфиг Firebase-проекта `rabbitfarmho`
для bundle ID `dev.mubi.rabbitfarm`. Скачивается заново на каждой машине, где
собирается iOS-таргет: Firebase Console → тот же проект → Project settings →
приложение `dev.mubi.rabbitfarm`. APNs-ключ (`.p8`) для push там же — Cloud
Messaging → APNs Authentication Key, заведён в Apple Developer Portal.

Живая проверка push с APNs не сделана: симулятор не получает настоящий
APNs-токен, нужен реальный iPhone.

## Ловушки среды

**Эсхата (`connecttest.eskhata.com`) банит по IP** с обычной сети разработки.
Живая проверка делалась через Tailscale exit node: `tailscale set
--exit-node=<name>`, после — `tailscale set --exit-node=`. Payom
(`gateway.payom.tj`) банил так же, но лечится вайтлистом IP в его кабинете,
без VPN. IP разработчика динамический — при 403 с `IP-block` вайтлист нужно
обновить.

**Kaspersky Endpoint Security на рабочем Windows-ноуте рвёт TLS** к почтовым
доменам (`ECONNRESET`/`errno=10053`) — не помогает ни VPN, ни вайтлист в
Stalwart, это перехват на уровне антивируса. Обход: гонять SMTP из WSL2
(`wsl -d FedoraLinux-42 -- …`). Заодно выяснилось, что порт 587 (STARTTLS) у
`mail.mubi.dev` не отвечает вовсе — рабочий порт 465 (implicit TLS), см.
`backend/src/config/mailer.js`.

**MinIO не публикует порт 9000 наружу** (намеренно, см. `docker-compose.yml`)
— поэтому интеграционные тесты `rabbit-gallery` и `farm-photo-feed`, которые
бьют в него с хоста, всегда красные при прогоне *с хоста*. Это ограничение
запуска, а не баг: чтобы прогнать и их, нужно временно опубликовать 9000 или
запускать тесты внутри контейнера `api`.

**Flutter не в PATH** на машине разработчика — команды в `mobile/` вызывать
полным путём (`/Users/mubidev/development/flutter/bin/flutter`). Тесты
бэкенда требуют поднятого compose-стенда:

```bash
docker compose up -d db
cd backend && DB_HOST=127.0.0.1 DB_PORT=3307 NODE_ENV=test npx jest --runInBand
```

Флаг `--forceExit` не добавлять: он обрывает незавершённые запросы, и тесты
начинают падать вразнобой.

## Отложено сознательно

Бэкап и мониторинг боевого стенда. Масштабирование — только как варианты на
обсуждение (MinIO уже сделан как «дешёвый сейчас» шаг).
