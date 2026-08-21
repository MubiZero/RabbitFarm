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
owner and invites everyone else — see [Accounts](#accounts).

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

Everyone else joins by invitation. The owner issues a code on the Работники
screen and passes it on; the person enters it at `/join` and lands inside the
owner's farm, seeing the same livestock, feed and tasks.

| Role | Can |
|---|---|
| `owner` | everything, including inviting people and changing roles |
| `manager` | run the farm: livestock, feed, finances |
| `worker` | read the farm and record daily work |

There is no mail server, so codes travel however the owner already talks to
people, and a forgotten password is reset by the owner rather than by email.
Codes and temporary passwords are shown once — only their hashes are stored.

`ALLOW_REGISTRATION=true` reopens plain registration if you ever need it; new
accounts then arrive as workers with their own empty farm, which is rarely
what you want. Invitations are the normal path.

## Deployment

[docs/DEPLOY.md](docs/DEPLOY.md) covers deploying the whole stack to a server
with Coolify: its own database, domains and certificates, a persistent volume
for uploads, and the backup job you have to set up yourself.

## Development

```
backend/     Node API — src/{routes,controllers,services,models,middleware}
mobile/      Flutter client — lib/features/<module>/{data,presentation}
docs/        Deployment, mobile builds, architecture, manual API testing
```

Backend:

```bash
cd backend
npm install
npm run dev              # hot reload
npm test                 # 860 tests
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
flutter test             # 34 tests
dart run build_runner build --delete-conflicting-outputs   # after model changes
```

Models use freezed and json_serializable, so anything touching a file in
`data/models` needs a build_runner run.

Building the app for phones — signing, CI, App Store — is in
[docs/MOBILE.md](docs/MOBILE.md).

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
`flutter analyze && flutter test` in `mobile/` before opening a PR: nothing
runs them automatically on a pull request yet, so those checks are on you.
(The mobile release workflow does run them, but only when a build is made.)

## License

MIT — see [LICENSE](LICENSE).
