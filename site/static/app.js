/*
 * Поведение сайта. Ванильный JavaScript без сборки: страницу открывают с
 * телефона на мобильном интернете, и фреймворк ради нескольких обработчиков
 * стоил бы дороже всего остального.
 *
 * Всё здесь необязательно для чтения: без скрипта видны все секции,
 * работают ссылки, «Что записать» показывает первое дело. Перспектива
 * экранов выпрямляется прокруткой средствами CSS (композитор), не здесь.
 */
(function () {
  'use strict';

  var root = document.documentElement;
  var reduce = window.matchMedia('(prefers-reduced-motion: reduce)');
  var lite = root.classList.contains('lite');

  /* --- Первый экран: слежение за указателем -----------------------------
   * Включается только пока первый экран виден и только у мыши. Наклон
   * ставится прямо на внутренние обёртки экранов (.ph-in), без переменных
   * на весь блок: так браузер пересчитывает три элемента, а не поддерево.
   */
  var hero = document.querySelector('[data-hero]');
  var stage = document.querySelector('[data-stage]');
  var fine = window.matchMedia('(hover: hover) and (pointer: fine)');

  if (hero && 'IntersectionObserver' in window) {
    new IntersectionObserver(function (entries) {
      hero.classList.toggle('is-live', entries[0].isIntersecting);
    }).observe(hero);
  }

  if (hero && stage && fine.matches && !reduce.matches && !lite) {
    // Двигается сам телефон целиком, а не картинка внутри рамки: плоский
    // сдвиг свойством translate (оно не конфликтует с transform наклона).
    // Вложенные 3D-повороты внутри наклонённого экрана в Safari пересекаются
    // с плоскостью рамки и рвут картинку на диагональные куски.
    var tilts = [
      { el: stage.querySelector('.ph-center'), x: 8, y: 5 },
      { el: stage.querySelector('.ph-left'), x: 18, y: 9 },
      { el: stage.querySelector('.ph-right'), x: 18, y: 9 }
    ].filter(function (t) { return t.el; });
    var tx = 0, ty = 0, cx = 0, cy = 0, raf = 0;

    var step = function () {
      cx += (tx - cx) * 0.08;
      cy += (ty - cy) * 0.08;
      tilts.forEach(function (t) {
        t.el.style.translate = (cx * t.x).toFixed(2) + 'px ' + (cy * t.y).toFixed(2) + 'px';
      });
      raf = Math.abs(tx - cx) > 0.002 || Math.abs(ty - cy) > 0.002 ? requestAnimationFrame(step) : 0;
    };
    var kick = function () { if (!raf) raf = requestAnimationFrame(step); };

    hero.addEventListener('pointermove', function (event) {
      var rect = hero.getBoundingClientRect();
      tx = ((event.clientX - rect.left) / rect.width - 0.5) * 2;
      ty = ((event.clientY - rect.top) / rect.height - 0.5) * 2;
      kick();
    }, { passive: true });
    hero.addEventListener('pointerleave', function () { tx = 0; ty = 0; kick(); });
  }

  /* --- «Что записать»: выбор дела ----------------------------------------
   * Снимок и подпись плавно сменяются. Новая картинка сначала
   * декодируется, потом меняется: иначе на медленной сети экран мигнул бы
   * пустым.
   */
  var jobs = Array.prototype.slice.call(document.querySelectorAll('.job'));
  var panel = document.querySelector('[data-click]');
  var shot = document.querySelector('[data-job-shot]');
  var caption = document.querySelector('[data-job-caption]');
  var swapTimer = 0;

  function selectJob(button) {
    jobs.forEach(function (job) {
      job.setAttribute('aria-selected', String(job === button));
      job.tabIndex = job === button ? 0 : -1;
    });
    if (!shot || !panel) return;

    var next = new Image();
    next.src = button.dataset.shot;
    var ready = next.decode ? next.decode() : Promise.resolve();
    ready.catch(function () { /* покажем как есть */ }).then(function () {
      window.clearTimeout(swapTimer);
      panel.classList.add('is-swapping');
      swapTimer = window.setTimeout(function () {
        shot.src = button.dataset.shot;
        shot.alt = button.dataset.shotAlt;
        if (caption) caption.textContent = button.dataset.caption;
        panel.classList.remove('is-swapping');
      }, reduce.matches ? 0 : 150);
    });
  }

  var touched = false;
  jobs.forEach(function (button, index) {
    button.addEventListener('pointerdown', function () { touched = true; });
    button.addEventListener('click', function () { selectJob(button); });
    button.addEventListener('keydown', function (event) {
      var step = event.key === 'ArrowRight' || event.key === 'ArrowDown' ? 1
        : event.key === 'ArrowLeft' || event.key === 'ArrowUp' ? -1 : 0;
      if (!step) return;
      event.preventDefault();
      var next = jobs[(index + step + jobs.length) % jobs.length];
      selectJob(next);
      next.focus();
    });
  });

  /* --- Вкладки сами показывают себя один раз -------------------------------
   * Когда блок виден на 60%, дела переключаются по кругу один раз, чтобы
   * было видно, что их можно нажимать. Любое касание, фокус или уход блока
   * из виду останавливают показ насовсем. При «меньше движения» и в лёгкой
   * версии показа нет.
   */
  var clickGrid = document.querySelector('[data-click]');
  if (clickGrid && jobs.length > 1 && 'IntersectionObserver' in window && !reduce.matches && !lite) {
    var auto = 0, idx = 0, started = false;
    var stop = function () { window.clearInterval(auto); started = true; };
    jobs.forEach(function (b) { b.addEventListener('focus', function () { touched = true; }); });
    new IntersectionObserver(function (entries) {
      if (started) return;
      if (!entries[0].isIntersecting) { if (auto) stop(); return; }
      started = true;
      auto = window.setInterval(function () {
        if (touched || document.hidden || idx >= jobs.length - 1) { window.clearInterval(auto); return; }
        idx += 1;
        selectJob(jobs[idx]);
      }, 3200);
    }, { threshold: 0.6 }).observe(clickGrid);
  }

  /* --- Живой виджет «пропала связь» ---------------------------------- */
  var demo = document.querySelector('[data-demo]');
  if (demo) {
    var toggle = demo.querySelector('[data-demo-toggle]');
    var states = demo.querySelectorAll('[data-demo-s]');
    var timer = 0;
    var show = function (state) {
      demo.dataset.state = state;
      states.forEach(function (s) { s.hidden = s.dataset.demoS !== state; });
    };
    toggle.hidden = false;
    toggle.addEventListener('click', function () {
      window.clearTimeout(timer);
      if (demo.dataset.state === 'offline') {
        show('sent');
        toggle.textContent = toggle.dataset.off;
        timer = window.setTimeout(function () { show('online'); }, 4000);
      } else {
        show('offline');
        toggle.textContent = toggle.dataset.on;
      }
    });
  }

  /* --- Граница шапки при прокрутке ----------------------------------- */
  var topbar = document.querySelector('.topbar');
  var sentinel = document.querySelector('[data-scroll-sentinel]');
  if (topbar && sentinel && 'IntersectionObserver' in window) {
    new IntersectionObserver(function (entries) {
      topbar.dataset.scrolled = String(!entries[0].isIntersecting);
    }).observe(sentinel);
  }

  /* --- Светлая или тёмная -------------------------------------------- */
  var themeToggle = document.querySelector('[data-theme-toggle]');
  if (themeToggle) {
    themeToggle.addEventListener('click', function () {
      var next = (root.dataset.theme || 'light') === 'dark' ? 'light' : 'dark';
      root.dataset.theme = next;
      try { localStorage.setItem('theme', next); } catch (e) { /* до перезагрузки */ }
    });
  }

  /* --- Выпадающий список языка --------------------------------------- */
  var pops = Array.prototype.slice.call(document.querySelectorAll('.pop'));
  document.addEventListener('click', function (event) {
    pops.forEach(function (pop) { if (!pop.contains(event.target)) pop.open = false; });
  });
  document.addEventListener('keydown', function (event) {
    if (event.key === 'Escape') pops.forEach(function (pop) { pop.open = false; });
  });

  /* --- Где я сейчас --------------------------------------------------- */
  var spy = Array.prototype.slice.call(document.querySelectorAll('[data-spy]'));
  if (spy.length && 'IntersectionObserver' in window) {
    var so = new IntersectionObserver(function (entries) {
      entries.forEach(function (entry) {
        if (!entry.isIntersecting) return;
        // Первый экран, закрывающий блок и подвал не относятся ни к одному
        // пункту меню: подсветка снимается, а не остаётся на прошлом.
        var id = entry.target.id || '';
        spy.forEach(function (link) {
          link.classList.toggle('is-current', link.dataset.spy === id);
        });
      });
    }, { rootMargin: '-45% 0px -50% 0px' });
    spy.forEach(function (link) {
      var section = document.getElementById(link.dataset.spy);
      if (section) so.observe(section);
    });
    document.querySelectorAll('[data-hero], .closing, .footer').forEach(function (el) { so.observe(el); });
  }

  /* --- Кнопка внизу на телефоне -------------------------------------------
   * После первого экрана единственное действие страницы уезжало вверх. Пока
   * не видны ни первая кнопка, ни закрывающий блок, она держится внизу.
   */
  var dock = document.querySelector('[data-dock]');
  if (dock && hero && 'IntersectionObserver' in window) {
    var link = dock.querySelector('a');
    var seen = { hero: true, closing: false };
    var sync = function () {
      var on = !seen.hero && !seen.closing;
      dock.classList.toggle('is-on', on);
      link.tabIndex = on ? 0 : -1;
    };
    var closing = document.querySelector('.closing');
    var dio = new IntersectionObserver(function (entries) {
      entries.forEach(function (e) {
        if (e.target === hero) seen.hero = e.isIntersecting && e.boundingClientRect.bottom > 220;
        else seen.closing = e.isIntersecting;
      });
      sync();
    }, { threshold: [0, 0.01] });
    dio.observe(hero);
    if (closing) dio.observe(closing);
  }

  /* --- Адреса приложения и сборки ------------------------------------ */
  fetch('/config.json', { cache: 'no-store' })
    .then(function (r) { return r.ok ? r.json() : {}; })
    .catch(function () { return {}; })
    .then(function (config) {
      if (config.appUrl) {
        var lang = root.lang || 'ru';
        var sep = config.appUrl.indexOf('?') === -1 ? '?' : '&';
        var target = config.appUrl + sep + 'lang=' + encodeURIComponent(lang);
        document.querySelectorAll('[data-app-link]').forEach(function (a) { a.href = target; });
      }
      if (config.androidApkUrl) {
        document.querySelectorAll('[data-android-link]').forEach(function (a) {
          a.href = config.androidApkUrl;
          a.hidden = false;
        });
        document.querySelectorAll('[data-stores-note]').forEach(function (n) { n.hidden = false; });
      }
    });
})();
