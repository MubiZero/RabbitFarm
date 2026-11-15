/*
 * Поведение сайта. Ванильный JavaScript без сборки: страницу открывают с
 * телефона на мобильном интернете, и фреймворк ради нескольких обработчиков
 * стоил бы дороже всего остального.
 *
 * Всё здесь необязательно для чтения: без скрипта видны все секции,
 * работают ссылки, «Что записать» показывает первое дело.
 */
(function () {
  'use strict';

  var root = document.documentElement;
  var reduce = window.matchMedia('(prefers-reduced-motion: reduce)');
  var lite = root.classList.contains('lite');

  /* --- Перспектива экранов выпрямляется при прокрутке ---------------- */
  var hero = document.querySelector('[data-hero]');
  if (hero && !reduce.matches && !lite) {
    var ticking = false;
    var update = function () {
      var p = Math.min(1, Math.max(0, window.scrollY / (hero.offsetHeight * 0.55)));
      hero.style.setProperty('--p', p.toFixed(3));
      ticking = false;
    };
    window.addEventListener('scroll', function () {
      if (!ticking) { ticking = true; requestAnimationFrame(update); }
    }, { passive: true });
    update();
  }

  /* --- «Что записать»: выбор дела ----------------------------------- */
  var jobs = Array.prototype.slice.call(document.querySelectorAll('.job'));
  var shot = document.querySelector('[data-job-shot]');
  var caption = document.querySelector('[data-job-caption]');

  function selectJob(button) {
    jobs.forEach(function (job) {
      job.setAttribute('aria-selected', String(job === button));
      job.tabIndex = job === button ? 0 : -1;
    });
    if (shot) { shot.src = button.dataset.shot; shot.alt = button.dataset.shotAlt; }
    if (caption) caption.textContent = button.dataset.caption;
  }

  jobs.forEach(function (button, index) {
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

  /* --- Живой виджет «пропала связь» ---------------------------------- */
  var demo = document.querySelector('[data-demo]');
  if (demo) {
    var toggle = demo.querySelector('[data-demo-toggle]');
    var states = demo.querySelectorAll('[data-demo-s]');
    var timer = null;
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

  /* --- Появление блоков --------------------------------------------- */
  var revealables = document.querySelectorAll('.reveal');
  if ('IntersectionObserver' in window && !reduce.matches && !lite) {
    var io = new IntersectionObserver(function (entries) {
      entries.forEach(function (entry) {
        if (!entry.isIntersecting) return;
        entry.target.classList.add('is-visible');
        io.unobserve(entry.target);
      });
    }, { rootMargin: '0px 0px -8% 0px', threshold: 0.1 });
    revealables.forEach(function (el) { io.observe(el); });
  } else {
    revealables.forEach(function (el) { el.classList.add('is-visible'); });
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
      var current = root.dataset.theme || 'light';
      var next = current === 'dark' ? 'light' : 'dark';
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
        spy.forEach(function (link) {
          link.classList.toggle('is-current', link.dataset.spy === entry.target.id);
        });
      });
    }, { rootMargin: '-45% 0px -50% 0px' });
    spy.forEach(function (link) {
      var section = document.getElementById(link.dataset.spy);
      if (section) so.observe(section);
    });
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
