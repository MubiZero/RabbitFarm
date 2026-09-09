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
| Journal | Feeding, treatments, vaccinations, closed tasks and free-form notes in one timeline |
| Staff | Invite by code, assign roles, hand the whole farm to someone else |
| Notifications | Push (Android): daily digest of overdue vaccinations/tasks/feed stock, instant push on task assignment and new notes |
| Billing | Plans with rabbit/staff limits, paid subscriptions via Эсхата Мерчант, renewal reminders, read-only lockout on non-payment |
| Platform admin | A separate, flag-gated view across every farm on the install — plans, usage, suspend/read-only, one-off limit grants, broadcast announcements, read-only impersonation for support, an audit log, and a service-wide summary. See [Accounts](#accounts) and [docs/plans/PLATFORM-ADMIN.md](docs/plans/PLATFORM-ADMIN.md) |

One installation is multi-tenant: it can host many independent farms, each
fully isolated from the others at the database level (every farm-owned table
carries a `farm_id`, enforced by hooks, not just application code — see
[docs/ARCHITECTURE.md](docs/ARCHITECTURE.md#-многоарендность-изоляция-ферм)).
Registration creates a new farm with its own owner every time; people join an
existing farm only by invitation — see [Accounts](#accounts).

## Stack

**Backend** — Node 20, Express, Sequelize, MySQL 8, JWT auth, Joi validation,
Swagger reference, Jest.

**Client** — Flutter 3.47, Riverpod, go_router, freezed + json_serializable,
Dio. One codebase for Android, iOS and web — the web build doubles as the
platform admin's desktop view, no separate app.

**Runtime** — Docker Compose: `db`, `minio` (S3-compatible file storage),
`api`, and `web` (nginx serving the Flutter web build).

## Quick start

You need Docker and Docker Compose. For client work you also need the Flutter
SDK — **exactly the version CI uses** (`FLUTTER_VERSION` in
[.github/workflows/mobile-release.yml](.github/workflows/mobile-release.yml),
`3.47.0` at the time of writing, required by the pinned `freezed`/
`build_runner`: anything older ships a Dart SDK below the `>=3.13.0` they
need, and `flutter pub get` refuses outright). If you installed Flutter via
git, check out that exact tag:
`git -C <flutter-dir> checkout 3.47.0 && flutter --version`.

```bash
git clone https://github.com/MubiZero/RabbitFarm.git
cd RabbitFarm
cp backend/.env.example .env
```

Fill in the secrets in `.env` — at minimum `DB_PASSWORD`, `DB_ROOT_PASSWORD`,
`JWT_SECRET`, `JWT_REFRESH_SECRET`, `MINIO_ROOT_USER` and
`MINIO_ROOT_PASSWORD`. Generate each with `openssl rand -base64 32`. Compose
refuses to start without them on purpose: no installation should run with
default credentials.

Push notifications need three more (`FIREBASE_PROJECT_ID`,
`FIREBASE_CLIENT_EMAIL`, `FIREBASE_PRIVATE_KEY`) from a Firebase project's
service account — optional, the API runs fine without them and simply sends
no push.

```bash
docker compose up -d
```

| Service | Address |
|---|---|
| API | http://localhost:4567 |
| API reference (Swagger) | http://localhost:4567/api-docs |
| Health check | http://localhost:4567/health |
| MySQL | localhost:3307 |
| MinIO console (file storage) | http://localhost:9001 |

Adminer (DB browser) sits behind its own profile — it's not part of a plain
`docker compose up -d` on purpose, so a login form for the database isn't
sitting open on every deployment by default:

```bash
docker compose --profile debug up -d adminer
```

| Service | Address |
|---|---|
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

Every registration creates a brand-new farm and makes that account its
`owner` — there is no "first user wins" gate. `ALLOW_REGISTRATION=false` (the
default) simply closes public sign-up, e.g. once a deployment's farms are
provisioned some other way; set it to `true` to let people register their own
farms.

Everyone else joins an *existing* farm by invitation rather than by
registering. The owner issues a code on the Работники screen and passes it
on; the person enters it at `/join` and lands inside that farm, seeing the
same livestock, feed and tasks as everyone else there.

| Role | Can |
|---|---|
| `owner` | everything: invite people, change roles, reset passwords, transfer ownership |
| `manager` | create/edit livestock, cages, feed, breeding and finances; view financial reports |
| `worker` | record daily work (feeding, vaccinations, medical records, notes, tasks); no finances, no create/edit on rabbits, cages, breeds, breeding or feed stock |

Deleting a record is owner-only almost everywhere; a few day-to-day types
(feeding records, notes, tasks) can also be deleted by a manager. The owner
can hand the farm to another active member (`staff/:id/transfer-ownership`):
the recipient becomes `owner`, the previous owner drops to `manager`.

There is no mail server, so invitation codes travel however the owner already
talks to people, and a forgotten password is reset by the owner rather than
by email. Codes and temporary passwords are shown once — only their hashes
are stored.

`is_platform_admin` is a separate flag, unrelated to farm roles and set by
hand in the database — it opens a "Платформа" section covering every farm on
the install, not just the admin's own. See
[docs/plans/PLATFORM-ADMIN.md](docs/plans/PLATFORM-ADMIN.md) for what it can
do.

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
npm test                 # 1539 tests, 7 fail unless MinIO is reachable from the host (see docs/HANDOFF.md)
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
flutter test             # 326 tests
dart run build_runner build --delete-conflicting-outputs   # after model changes
```

Models use freezed and json_serializable, so anything touching a file in
`data/models` needs a build_runner run.

Building the app for phones — signing, CI, App Store — is in
[docs/MOBILE.md](docs/MOBILE.md).

## API

The running API serves an interactive reference at `/api-docs`.
[docs/API_TESTING.md](docs/API_TESTING.md) has ready-made curl requests.

Everything requires `Authorization: Bearer <access token>` except `/health`,
the `/auth` endpoints you by definition don't have one for yet (`register`,
`login`, `refresh`, `logout`, `accept-invitation`, `forgot-password`,
`reset-password`), the bank's `/payments/webhook`, and `/files/*` (object
keys are unguessable timestamp+random names, not enumerable — the same
protection static file serving would have had). Errors come back in one
shape:

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
