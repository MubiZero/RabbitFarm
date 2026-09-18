/*
 * Поведение лендинга. Ванильный JavaScript без сборки: страницу открывают с
 * телефона на мобильном интернете, и фреймворк ради трёх обработчиков стоил
 * бы дороже, чем всё остальное на странице.
 *
 * Всё здесь необязательно для чтения страницы: без JavaScript видны все
 * секции, работают ссылки, а разделы «Что записать» показывают первый экран.
 */
(function () {
  'use strict';

  var reduceMotion = window.matchMedia('(prefers-reduced-motion: reduce)');

  /* --- След касания ----------------------------------------------------
   * Домен у страницы .click, и нажатие обязано быть заметным: волна из
   * точки касания подтверждает, что палец попал по кнопке.
   */
  function attachRipple(el) {
    el.addEventListener('pointerdown', function (event) {
      if (reduceMotion.matches) return;

      var rect = el.getBoundingClientRect();
      var size = Math.max(rect.width, rect.height);
      var ripple = document.createElement('span');

      ripple.className = 'ripple';
      ripple.style.width = ripple.style.height = size + 'px';
      ripple.style.left = event.clientX - rect.left - size / 2 + 'px';
      ripple.style.top = event.clientY - rect.top - size / 2 + 'px';

      el.appendChild(ripple);
      ripple.addEventListener('animationend', function () {
        ripple.remove();
      });
    });
  }

  document.querySelectorAll('.btn, .job').forEach(attachRipple);

  /* --- «Что записать»: выбор дела --------------------------------------
   * Кнопка меняет и снимок экрана, и подпись под ним. Без выбора страница
   * показывает первое дело, поэтому блок осмыслен и без JavaScript.
   */
  var jobs = Array.prototype.slice.call(document.querySelectorAll('.job'));
  var jobShot = document.querySelector('[data-job-shot]');
  var jobCaption = document.querySelector('[data-job-caption]');

  function selectJob(button) {
    jobs.forEach(function (job) {
      job.setAttribute('aria-selected', String(job === button));
      job.tabIndex = job === button ? 0 : -1;
    });

    if (jobShot) {
      jobShot.src = button.dataset.shot;
      jobShot.alt = button.dataset.shotAlt;
    }
    if (jobCaption) {
      jobCaption.textContent = button.dataset.caption;
    }
  }

  jobs.forEach(function (button, index) {
    button.addEventListener('click', function () {
      selectJob(button);
    });

    // Стрелками ходят по вкладкам: так же, как в самом приложении.
    button.addEventListener('keydown', function (event) {
      var step = event.key === 'ArrowDown' || event.key === 'ArrowRight' ? 1
        : event.key === 'ArrowUp' || event.key === 'ArrowLeft' ? -1
          : 0;
      if (!step) return;

      event.preventDefault();
      var next = jobs[(index + step + jobs.length) % jobs.length];
      selectJob(next);
      next.focus();
    });
  });

  /* --- Появление секций ------------------------------------------------ */
  var revealables = document.querySelectorAll('.reveal');

  if ('IntersectionObserver' in window && !reduceMotion.matches) {
    var revealObserver = new IntersectionObserver(function (entries) {
      entries.forEach(function (entry) {
        if (!entry.isIntersecting) return;
        entry.target.classList.add('is-visible');
        revealObserver.unobserve(entry.target);
      });
    }, { rootMargin: '0px 0px -10% 0px', threshold: 0.1 });

    revealables.forEach(function (el) {
      revealObserver.observe(el);
    });
  } else {
    revealables.forEach(function (el) {
      el.classList.add('is-visible');
    });
  }

  /* --- Граница шапки при прокрутке -------------------------------------
   * Наблюдателем, а не обработчиком scroll: обработчик срабатывает на
   * каждый кадр прокрутки и заметно греет слабый телефон.
   */
  var topbar = document.querySelector('.topbar');
  var sentinel = document.querySelector('[data-scroll-sentinel]');

  if (topbar && sentinel && 'IntersectionObserver' in window) {
    new IntersectionObserver(function (entries) {
      topbar.dataset.scrolled = String(!entries[0].isIntersecting);
    }).observe(sentinel);
  }

  /* --- Адреса приложения и магазинов -----------------------------------
   * Те же правила, что на странице приглашения (mobile/web/i): кнопка
   * появляется, только когда адрес задан. Кнопка «Скачать», ведущая в
   * пустоту, хуже честной строчки о том, что сборки пока нет.
   */
  // Адрес абсолютный: языковые страницы лежат в /tg/, /uz/, /en/, и
  // относительный путь искал бы config.json внутри каждой из них.
  fetch('/config.json', { cache: 'no-store' })
    .then(function (response) {
      return response.ok ? response.json() : {};
    })
    .catch(function () {
      return {};
    })
    .then(function (config) {
      if (config.appUrl) {
        // Язык страницы едет вместе со ссылкой: приложение открывается на
        // том же языке, а не угадывает его по настройкам телефона.
        var lang = document.documentElement.lang || 'ru';
        var separator = config.appUrl.indexOf('?') === -1 ? '?' : '&';
        var target = config.appUrl + separator + 'lang=' + encodeURIComponent(lang);
        document.querySelectorAll('[data-app-link]').forEach(function (link) {
          link.href = target;
        });
      }

      if (config.androidApkUrl) {
        document.querySelectorAll('[data-android-link]').forEach(function (link) {
          link.href = config.androidApkUrl;
          link.hidden = false;
        });
        document.querySelectorAll('[data-stores-note]').forEach(function (note) {
          note.hidden = false;
        });
      }
    });
})();
