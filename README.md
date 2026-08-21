# 🐰 RabbitFarm

Self-hosted management system for a rabbit farm: livestock, breeding, health,
feed stock and finances in one place.

The stack is a REST API (Node + MySQL) and a Flutter client that runs on
Android, iOS and in the browser. Everything ships together as a Docker Compose
stack.

> **The interface is in Russian.** The app is written for a Russian-speaking
> farm and has no localisation layer yet: code, API and docs use English
> identifiers, but every user-facing string is Russian.

## What it does

| Module | What you can do |
|---|---|
| Livestock | Rabbit cards with photos, weight history, pedigree, status and purpose |
| Breeding | Matings, pregnancies, births, kits, inbreeding check before pairing |
| Housing | Cages, occupancy, moving rabbits between cages |
| Health | Vaccinations, treatments, medical records and their costs |
| Feeding | Feed stock with low-stock warnings, feeding records, consumption per feed |
| Finance | Income and expenses by category, profit, recent operations |
| Analytics | Separate screens for finance, feed stock and feeding consumption |
| Tasks | Farm to-dos with types, priorities and statuses |

One installation serves one farm. The first person to register becomes its
owner; after that registration is closed — see [Accounts](#accounts).

## Stack

**Backend** — Node 20, Express, Sequelize, MySQL 8, JWT auth, Joi validation,
Swagger reference, Jest.

**Client** — Flutter 3.41, Riverpod, go_router, freezed + json_serializable,
Dio. One codebase for Android, iOS and web.

**Runtime** — Docker Compose: `db`, `api`, and `web` (nginx serving the Flutter
web build).

## Quick start

You need Docker and Docker Compose. For client work you also need the Flutter
SDK.

```bash
git clone https://github.com/MubiZero/RabbitFarm.git
cd RabbitFarm
cp backend/.env.example .env
```

Fill in the secrets in `.env` — at minimum `DB_PASSWORD`, `DB_ROOT_PASSWORD`,
`JWT_SECRET` and `JWT_REFRESH_SECRET`. Generate each with
`openssl rand -base64 32`. Compose refuses to start without them on purpose:
no installation should run with default credentials.

```bash
docker compose up -d
```

| Service | Address |
|---|---|
| API | http://localhost:4567 |
| API reference (Swagger) | http://localhost:4567/api-docs |
| Health check | http://localhost:4567/health |
| MySQL | localhost:3307 |
| Adminer (DB browser) | http://localhost:8080 |

Migrations run automatically when the API container starts. To load demo
reference data as well, start with `RUN_SEEDS=true`.

### Running the client

```bash
cd mobile
flutter pub get
flutter run --dart-define=API_URL=http://localhost:4567/api/v1
```

The API address is compiled into the build, so pass the one your device can
actually reach:

| Target | API_URL |
|---|---|
| iOS simulator, desktop, web | `http://localhost:4567/api/v1` |
| Android emulator | `http://10.0.2.2:4567/api/v1` |
| Real device | `http://<your-computer-ip>:4567/api/v1` |

## Accounts

Registration bootstraps the farm once: the first account created becomes the
`owner`, every later attempt is refused with 403. That keeps a publicly
reachable installation from being claimed by a stranger.

To add another account set `ALLOW_REGISTRATION=true`, register the person —
they come in as a `worker` — then set it back to `false`.

Data is currently scoped per user, so an added account starts with an empty
farm instead of sharing the owner's. Shared staff access needs a farm key and
an invite flow, which is not built yet.

## Deployment

[docs/DEPLOY.md](docs/DEPLOY.md) covers deploying the whole stack to a server
with Coolify: its own database, domains and certificates, a persistent volume
for uploads, and the backup job you have to set up yourself.

## Development

```
backend/     Node API — src/{routes,controllers,services,models,middleware}
mobile/      Flutter client — lib/features/<module>/{data,presentation}
docs/        Deployment, architecture, manual API testing
```

Backend:

```bash
cd backend
npm install
npm run dev              # hot reload
npm test                 # 842 tests
npm run test:unit        # no database needed
npm run migrate          # apply migrations
npx sequelize-cli migration:generate --name your-change
```

Integration tests need a running MySQL and a `rabbitfarm_test` database; unit
tests do not.

Client:

```bash
cd mobile
flutter analyze
flutter test             # 29 tests
dart run build_runner build --delete-conflicting-outputs   # after model changes
```

Models use freezed and json_serializable, so anything touching a file in
`data/models` needs a build_runner run.

## API

The running API serves an interactive reference at `/api-docs`.
[docs/API_TESTING.md](docs/API_TESTING.md) has ready-made curl requests.

Everything except `/auth/register`, `/auth/login`, `/auth/refresh` and
`/health` requires `Authorization: Bearer <access token>`. Errors come back in
one shape:

```json
{
  "success": false,
  "error": { "code": "VALIDATION_ERROR", "message": "Проверка данных не пройдена" },
  "timestamp": "2026-08-21T06:04:20.144Z"
}
```

## Contributing

Issues and pull requests are welcome. Run `npm test` in `backend/` and
`flutter analyze && flutter test` in `mobile/` before opening a PR — there is
no CI yet, so those checks are on you.

## License

MIT — see [LICENSE](LICENSE).
