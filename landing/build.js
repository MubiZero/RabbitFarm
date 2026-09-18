#!/usr/bin/env node
/*
 * Сборка лендинга: из одного шаблона и четырёх словарей получается четыре
 * статических страницы, по одной на язык.
 *
 * Почему не переключение языка в браузере: страницу ищут в поиске, и
 * поисковику нужен отдельный адрес на каждый язык (`/`, `/tg/`, `/uz/`,
 * `/en/`) с перекрёстными hreflang. Заодно человек получает готовый текст
 * сразу, без мигания русского перед узбекским.
 *
 * Зависимостей нет намеренно: `node landing/build.js` работает на чистой
 * машине, без npm install.
 */
'use strict';

const fs = require('fs');
const path = require('path');

const SRC = path.join(__dirname, 'src');
const OUT = path.join(__dirname, 'dist');
const SITE = 'https://rabbitfarm.click';
// Куда ведут кнопки «Открыть приложение», пока страница не получила
// config.json. Значение из config.json перекрывает этот адрес на лету, без
// пересборки: так адрес магазина или нового стенда меняется одной
// переменной окружения.
const APP_URL = 'https://app.rabbitfarm.click';

// Приложение открывается на языке страницы, с которой человек пришёл.
// Иначе узбекская страница уводила в интерфейс на английском: приложение
// угадывало язык по настройкам телефона, а на дешёвом Android там английский.
const appUrl = (locale) => `${APP_URL}?lang=${locale}`;
const REPO = 'https://github.com/MubiZero/RabbitFarm';

// Русский лежит в корне: это основной язык аудитории.
const LOCALES = ['ru', 'tg', 'uz', 'en'];
const DEFAULT_LOCALE = 'ru';

const read = (file) => fs.readFileSync(path.join(SRC, file), 'utf8');
const dict = (locale) => JSON.parse(read(path.join('i18n', `${locale}.json`)));

const icon = (name, className) => read(path.join('assets', 'icons', `${name}.svg`))
  .replace('<svg', `<svg class="${className}" aria-hidden="true" focusable="false"`)
  .trim();

const escape = (value) => String(value)
  .replace(/&/g, '&amp;')
  .replace(/</g, '&lt;')
  .replace(/>/g, '&gt;')
  .replace(/"/g, '&quot;');

const localePath = (locale) => (locale === DEFAULT_LOCALE ? '/' : `/${locale}/`);

// Иконка модуля подбирается по порядку: словарь хранит только слова.
const MODULE_ICONS = ['rabbit', 'heart-straight', 'grid-four', 'plant', 'first-aid-kit', 'coins', 'users'];
// Снимков в карточках модулей нет намеренно: они были только у двух
// модулей из семи и только на русской странице, и ряд выглядел так, будто
// две функции настоящие, а пять обещаны. Ровный текстовый ряд честнее.
// Крупные ячейки выделены фоном, а не картинкой.
const JOB_SHOTS = ['feeding', 'birth'];

/**
 * Снимок экрана на языке страницы. Приложение говорит на всех четырёх
 * языках, и показывать узбекскому хозяйству русские экраны значит на первом
 * же снимке опровергать обещание из текста рядом.
 *
 * Русские файлы лежат без префикса, остальные с ним (`uz-home.webp`). Нет
 * снимка на нужном языке — нет и картинки: чужой язык в рамке телефона
 * хуже, чем её отсутствие.
 */
const SCREENS = path.join(SRC, 'assets', 'screens');
const screenFile = (locale, name) => {
  const file = locale === DEFAULT_LOCALE ? `${name}.webp` : `${locale}-${name}.webp`;
  return fs.existsSync(path.join(SCREENS, file)) ? `assets/screens/${file}` : null;
};

function renderPage(locale) {
  const t = dict(locale);
  const base = locale === DEFAULT_LOCALE ? '' : '../';
  const asset = (file) => `${base}${file}`;

  const alternates = LOCALES
    .map((other) => `  <link rel="alternate" hreflang="${dict(other).lang}" href="${SITE}${localePath(other)}">`)
    .concat([`  <link rel="alternate" hreflang="x-default" href="${SITE}/">`])
    .join('\n');

  const jobShots = JOB_SHOTS.map((name) => screenFile(locale, name));
  const heroShot = screenFile(locale, 'home');

  const jobs = t.click.items
    .map((item, index) => `
          <button type="button" class="job" role="tab" id="job-${index}"
            aria-selected="${index === 0}" tabindex="${index === 0 ? 0 : -1}"
            aria-controls="job-panel"
            data-shot="${asset(jobShots[index])}"
            data-shot-alt="${escape(item.alt)}"
            data-caption="${escape(item.caption)}">
            ${icon('cursor-click', 'job-mark')}
            <span>${escape(item.label)}</span>
          </button>`)
    .join('');

  const modules = t.modules.items
    .map((item, index) => `
        <article class="module reveal">
          ${icon(MODULE_ICONS[index], 'module-icon')}
          <h3>${escape(item.name)}</h3>
          <p>${escape(item.text)}</p>
        </article>`)
    .join('');

  const fieldItems = t.field.items
    .map((item) => `
        <div class="field-item reveal">
          <h3>${escape(item.name)}</h3>
          <p>${escape(item.text)}</p>
        </div>`)
    .join('');

  const pricePoints = t.price.points
    .map((point) => `
            <li>${icon('check', 'price-check')}<span>${escape(point)}</span></li>`)
    .join('');

  const langs = LOCALES
    .map((other) => {
      const name = { ru: 'Русский', tg: 'Тоҷикӣ', uz: 'Oʻzbekcha', en: 'English' }[other];
      const current = other === locale;
      return `          <a class="lang" href="${localePath(other)}" lang="${other}"${current ? ' aria-current="true"' : ''}>${name}</a>`;
    })
    .join('\n');

  return `<!DOCTYPE html>
<html lang="${t.lang}">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>${escape(t.meta.title)}</title>
<meta name="description" content="${escape(t.meta.description)}">
<link rel="canonical" href="${SITE}${localePath(locale)}">
${alternates}
<meta property="og:type" content="website">
<meta property="og:title" content="${escape(t.meta.title)}">
<meta property="og:description" content="${escape(t.meta.description)}">
<meta property="og:url" content="${SITE}${localePath(locale)}">
<meta property="og:image" content="${SITE}/assets/og.png">
<meta property="og:image:alt" content="${escape(t.meta.og_alt)}">
<meta property="og:locale" content="${t.locale.replace('-', '_')}">
<meta name="twitter:card" content="summary_large_image">
<link rel="icon" href="${asset('assets/favicon.png')}" type="image/png">
<link rel="stylesheet" href="${asset('assets/fonts/fonts.css')}">
<link rel="stylesheet" href="${asset('styles.css')}">
</head>
<body>
<header class="topbar">
  <div class="wrap topbar-inner">
    <a class="brand" href="${localePath(locale)}">
      <img class="brand-mark" src="${asset('assets/mark.svg')}" alt="" width="26" height="26">
      <span>rabbitfarm<span class="brand-dot">.click</span></span>
    </a>
    <nav class="topbar-nav">
      <a href="#modules">${escape(t.nav.modules)}</a>
      <a href="#field">${escape(t.nav.field)}</a>
      <a href="#price">${escape(t.nav.price)}</a>
      <a class="btn btn-primary" href="${appUrl(locale)}" data-app-link>${escape(t.nav.open)}</a>
    </nav>
  </div>
</header>
<span data-scroll-sentinel aria-hidden="true"></span>

<main>
  <section class="hero">
    <div class="wrap hero-grid">
      <div>
        <h1>${escape(t.hero.title_top)} <span class="hero-accent">${escape(t.hero.title_accent)}</span></h1>
        <p class="hero-lead">${escape(t.hero.lead)}</p>
        <div class="hero-actions">
          <a class="btn btn-primary" href="${appUrl(locale)}" data-app-link>
            ${icon('arrow-right', 'btn-icon')}
            <span>${escape(t.hero.cta_primary)}</span>
          </a>
          <a class="btn" href="${REPO}/releases/latest" data-android-link hidden>
            ${icon('download-simple', 'btn-icon')}
            <span>${escape(t.hero.cta_secondary)}</span>
          </a>
        </div>
        <p class="hero-note">${escape(t.hero.cta_note_web)}</p>
      </div>
      <div class="phone">
        <img src="${asset(heroShot)}" alt="${escape(t.hero.shot_alt)}" width="640" height="1386" fetchpriority="high">
      </div>
    </div>
  </section>

  <section class="section section-sunken" id="click">
    <div class="wrap">
      <h2 class="section-title">${escape(t.click.title)}</h2>
      <p class="section-lead">${escape(t.click.lead)}</p>

      <div class="click-grid">
        <div>
          <div class="click-jobs" role="tablist" aria-label="${escape(t.click.title)}">${jobs}
          </div>
          <p class="click-hint">${escape(t.click.hint)}</p>
        </div>

        <div class="click-panel" id="job-panel" role="tabpanel" aria-labelledby="job-0">
          <div class="phone">
            <img data-job-shot src="${asset(jobShots[0])}"
              alt="${escape(t.click.items[0].alt)}" width="640" height="1386" loading="lazy">
          </div>
          <p class="click-caption" data-job-caption>${escape(t.click.items[0].caption)}</p>
        </div>
      </div>
    </div>
  </section>

  <section class="section" id="modules">
    <div class="wrap">
      <h2 class="section-title">${escape(t.modules.title)}</h2>
      <div class="modules">${modules}
      </div>
    </div>
  </section>

  <section class="section section-sunken" id="field">
    <div class="wrap">
      <h2 class="section-title">${escape(t.field.title)}</h2>
      <div class="field-list">${fieldItems}
      </div>
    </div>
  </section>

  <section class="section" id="price">
    <div class="wrap split">
      <div>
        <h2 class="section-title">${escape(t.price.title)}</h2>
        <p class="section-lead">${escape(t.price.lead)}</p>
        <ul class="price-points">${pricePoints}
        </ul>
      </div>
      <div>
        <h2 class="section-title">${escape(t.data.title)}</h2>
        <p class="section-lead">${escape(t.data.text)}</p>
        <a class="link-inline" href="${REPO}">
          <span>${escape(t.data.link)}</span>
          ${icon('arrow-right', 'btn-icon')}
        </a>
      </div>
    </div>
  </section>

  <section class="closing">
    <div class="wrap">
      <h2 class="section-title">${escape(t.cta.title)}</h2>
      <p class="section-lead">${escape(t.cta.lead)}</p>
      <div class="closing-actions">
        <a class="btn btn-primary" href="${appUrl(locale)}" data-app-link>
          ${icon('arrow-right', 'btn-icon')}
          <span>${escape(t.cta.primary)}</span>
        </a>
        <a class="btn" href="${REPO}/releases/latest" data-android-link hidden>
          ${icon('download-simple', 'btn-icon')}
          <span>${escape(t.cta.secondary)}</span>
        </a>
      </div>
      <p class="closing-note" data-stores-note hidden>${escape(t.cta.stores_soon)}</p>
    </div>
  </section>
</main>

<footer class="footer">
  <div class="wrap footer-inner">
    <div>
      <p>RabbitFarm</p>
      <p>${escape(t.footer.rights)}</p>
    </div>
    <nav class="footer-links">
      <a href="${SITE}/privacy.html">${escape(t.footer.privacy)}</a>
      <a href="${REPO}">${escape(t.footer.github)}</a>
    </nav>
    <div>
      <p>${escape(t.footer.lang_label)}</p>
      <div class="langs">
${langs}
      </div>
    </div>
  </div>
</footer>

<script src="${asset('app.js')}" defer></script>
</body>
</html>
`;
}

function copyDir(from, to) {
  fs.mkdirSync(to, { recursive: true });
  for (const entry of fs.readdirSync(from, { withFileTypes: true })) {
    const source = path.join(from, entry.name);
    const target = path.join(to, entry.name);
    if (entry.isDirectory()) copyDir(source, target);
    else fs.copyFileSync(source, target);
  }
}

function build() {
  fs.rmSync(OUT, { recursive: true, force: true });
  fs.mkdirSync(OUT, { recursive: true });

  for (const locale of LOCALES) {
    const dir = locale === DEFAULT_LOCALE ? OUT : path.join(OUT, locale);
    fs.mkdirSync(dir, { recursive: true });
    fs.writeFileSync(path.join(dir, 'index.html'), renderPage(locale), 'utf8');
  }

  copyDir(path.join(SRC, 'assets'), path.join(OUT, 'assets'));
  for (const file of ['styles.css', 'app.js', 'config.json', 'og.html', 'privacy.html']) {
    fs.copyFileSync(path.join(SRC, file), path.join(OUT, file));
  }
  // Страница приглашения: её адрес уходит в SMS, и отдаёт его главный домен.
  copyDir(path.join(SRC, 'i'), path.join(OUT, 'i'));

  const sitemap = [
    '<?xml version="1.0" encoding="UTF-8"?>',
    '<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9" xmlns:xhtml="http://www.w3.org/1999/xhtml">',
    ...LOCALES.map((locale) => [
      '  <url>',
      `    <loc>${SITE}${localePath(locale)}</loc>`,
      ...LOCALES.map((other) => `    <xhtml:link rel="alternate" hreflang="${other}" href="${SITE}${localePath(other)}"/>`),
      '  </url>'
    ].join('\n')),
    '</urlset>',
    ''
  ].join('\n');
  fs.writeFileSync(path.join(OUT, 'sitemap.xml'), sitemap, 'utf8');

  fs.writeFileSync(
    path.join(OUT, 'robots.txt'),
    `User-agent: *\nAllow: /\n\nSitemap: ${SITE}/sitemap.xml\n`,
    'utf8'
  );

  console.log(`Собрано ${LOCALES.length} страницы в ${path.relative(process.cwd(), OUT)}`);
}

build();
