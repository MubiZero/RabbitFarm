/*
 * Поведение страницы приглашения. Отдельным файлом по той же
 * причине, что и стили: встроенный скрипт не пройдёт политику
 * содержимого.
 */
  // Строки прямо здесь: это отдельная статическая страница вне приложения,
  // тянуть ради четырёх фраз каталог ARB и Flutter-бандл незачем.
  var STRINGS = {
    ru: {
      title: 'Вас зовут в хозяйство',
      lead: 'Установите приложение и войдите по тому номеру или адресу, на который пришло приглашение — код придёт туда же.',
      web: 'Открыть в браузере',
      soon: 'Приложение скоро появится в App Store и Google Play.'
    },
    tg: {
      title: 'Шуморо ба хоҷагӣ даъват кардаанд',
      lead: 'Барномаро насб кунед ва бо ҳамон рақам ё почтае, ки даъват омад, ворид шавед — рамз ба ҳамон ҷо меояд.',
      web: 'Дар браузер кушоед',
      soon: 'Барнома ба зудӣ дар App Store ва Google Play пайдо мешавад.'
    },
    uz: {
      title: 'Sizni xoʻjalikka taklif qilishmoqda',
      lead: 'Ilovani oʻrnating va taklif kelgan raqam yoki pochta orqali kiring — kod ham shu yerga keladi.',
      web: 'Brauzerda ochish',
      soon: 'Ilova tez orada App Store va Google Play’da paydo boʻladi.'
    },
    en: {
      title: 'You have been invited to a farm',
      lead: 'Install the app and sign in with the phone number or email the invitation arrived at — the code will arrive there too.',
      web: 'Open in browser',
      soon: 'The app is coming to the App Store and Google Play.'
    }
  };

  var lang = (navigator.language || 'ru').slice(0, 2).toLowerCase();
  var t = STRINGS[lang] || STRINGS.ru;
  document.documentElement.lang = STRINGS[lang] ? lang : 'ru';
  document.getElementById('title').textContent = t.title;
  document.getElementById('lead').textContent = t.lead;
  document.getElementById('web').textContent = t.web;
  document.getElementById('soon').textContent = t.soon;

  // Кнопка магазина показывается только та, что человеку пригодится, и
  // только если адрес задан: пустая кнопка «App Store» на Android — ровно
  // то обещание без последствий, от которого мы уходим.
  fetch('config.json', { cache: 'no-store' })
    .then(function (r) { return r.ok ? r.json() : {}; })
    .catch(function () { return {}; })
    .then(function (cfg) {
      if (cfg.webUrl) {
        document.getElementById('web').href = cfg.webUrl;
      }

      var ua = navigator.userAgent || '';
      var isIos = /iPhone|iPad|iPod/i.test(ua);
      var isAndroid = /Android/i.test(ua);
      var shown = false;

      if (cfg.appStoreUrl && (isIos || !isAndroid)) {
        var ios = document.getElementById('ios');
        ios.href = cfg.appStoreUrl;
        ios.hidden = false;
        shown = true;
      }
      if (cfg.playStoreUrl && (isAndroid || !isIos)) {
        var android = document.getElementById('android');
        android.href = cfg.playStoreUrl;
        android.hidden = false;
        shown = true;
      }
      if (shown) {
        document.getElementById('web').classList.remove('primary');
      } else {
        document.getElementById('soon').hidden = false;
        document.getElementById('web').classList.add('primary');
      }
    });
