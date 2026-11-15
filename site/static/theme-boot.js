/*
 * До первой отрисовки: тема, признак JavaScript и лёгкая версия.
 *
 * Отдельный файл, а не пара строк в самой странице: инлайн-скрипт не
 * пропустит CSP (см. _headers). Подключён в <head> без defer намеренно:
 * он должен отработать раньше первого кадра, иначе тема и скрытые до
 * появления блоки применяются вспышкой.
 */
(function () {
  'use strict';
  var root = document.documentElement;
  root.classList.add('js');
  try {
    var saved = localStorage.getItem('theme');
    if (saved === 'light' || saved === 'dark') root.dataset.theme = saved;
  } catch (e) {
    /* Приватный режим: остаётся тема телефона. */
  }
  // Лёгкая версия: слабая связь или экономия трафика. Смысл страницы не
  // меняется, пропадают только перспектива, боковые экраны и плавные появления.
  var c = navigator.connection || navigator.mozConnection || navigator.webkitConnection;
  if (c && (c.saveData || /(^|-)2g$/.test(c.effectiveType || '') || (c.downlink && c.downlink < 0.7))) {
    root.classList.add('lite');
  }
})();
