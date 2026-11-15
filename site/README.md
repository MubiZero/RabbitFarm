# Сайт rabbitfarm.click

Статический генератор на Go (стандартная библиотека, без зависимостей и без npm).
Из одного шаблона и четырёх словарей получается четыре страницы:
`/`, `/tg/`, `/uz/`, `/en/`. Продукт-контекст: [../PRODUCT.md](../PRODUCT.md).

```bash
cd site
go run .            # собрать в dist/
go run . -serve     # собрать и отдавать на http://localhost:5961
```

Макеты, из которых выбран первый экран (вариант D): `../.impeccable/mocks/decision/`.

## Что где

```
main.go             сборка, карта сайта, robots, _headers, .well-known
templates/          шаблон страницы (html/template)
content/*.json      все тексты, по файлу на язык; новый язык = файл + код в locales
static/             стили, скрипты, шрифт Onest, снимки экранов, /i и /privacy.html
```

Страница без встроенных стилей и скриптов: строгий CSP (`_headers`). Лёгкая
версия (`lite`) включается при слабой связи или экономии трафика
(`static/theme-boot.js`): без перспективы, боковых экранов и появлений.

## Выкладка (Cloudflare Pages)

С 15.11.2026 домен `rabbitfarm.click` отдаёт проект Pages `rabbitfarm-site`.

Автоматически: `.github/workflows/site.yml`. Коммит в `main`, меняющий `site/`, выкладывает
боевой сайт; pull request выкладывает предпросмотр на `<ветка>.rabbitfarm-site.pages.dev`.
Секреты репозитория: `CLOUDFLARE_API_TOKEN` (токен только с правом Pages Write на
аккаунт) и `CLOUDFLARE_ACCOUNT_ID`.

Вручную: `npx --yes wrangler@4.150.0 pages deploy dist --project-name rabbitfarm-site --branch main`
с переменными `CLOUDFLARE_API_TOKEN` и `CLOUDFLARE_ACCOUNT_ID`.

Откат: вернуть в DNS зоны запись `A rabbitfarm.click -> 207.180.237.97` (proxied); старый сервис
`landing` в Coolify собран и ждёт.

Что делал nginx лендинга и что теперь делает Pages:

| Было (nginx) | Стало |
|---|---|
| заголовки, CSP, кэш | `dist/_headers` (генерируется) |
| `/.well-known/apple-app-site-association` из окружения | файл в `dist/.well-known/` (Team ID не секрет, зашит в `main.go`) |
| `assetlinks.json` из `ANDROID_CERT_SHA256` | собирается только при заданной переменной окружения сборки |
| `/config.json` из `APP_URL`, `ANDROID_APK_URL` | `dist/config.json`, те же переменные при сборке |
| `/i` отдаёт `i/index.html` | Pages отдаёт `/i/`, а `/i` редиректом 308 |
| `/privacy.html` | Pages отдаёт `/privacy` и редиректит с `.html` (308); приложение ссылается на `.html` |
| любой путь без файла: 404 | нужен `404.html`, иначе Pages отдаёт главную с кодом 200 |

## Не сделано и требует внимания

- Снимки экранов в `static/assets/screens` взяты из прежнего лендинга: тёмная
  тема, старая версия приложения. Свежие (светлая тема по умолчанию) снять с
  запущенного приложения.
- `static/privacy.html` унаследована от прежнего лендинга и говорит «пароль хранится
  только в виде хеша», хотя паролей в продукте нет (вход по коду). Юридический текст
  правит владелец.
- Нет автоопределения языка и окна заявки (в приложении вход по коду, форма не нужна).
- Прежний `../landing` не удалён: откат и сервис в Coolify остаются, пока владелец не решит.
