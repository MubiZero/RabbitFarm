const { AsyncLocalStorage } = require('async_hooks');

/**
 * Кто сейчас делает запрос — для кода, до которого `req` не доезжает.
 *
 * Журнал удалений пишется хуками моделей: они срабатывают внутри
 * `Model.destroy()`, куда никакой `req` не передашь, а переписывать ради
 * этого все сервисы значило бы протащить «кто удалил» сквозь десяток слоёв
 * и всё равно где-нибудь забыть — а забытое место в журнале выглядит как
 * «никто ничего не удалял», то есть хуже отсутствия журнала.
 *
 * Хранилище живёт ровно один запрос: `run()` оборачивает обработку, и всё,
 * что запущено внутри (включая асинхронные ветки), видит свой контекст и не
 * видит чужой.
 */
const storage = new AsyncLocalStorage();

/** Middleware: выполнить остаток запроса внутри контекста вошедшего. */
function withRequestContext(req, res, next) {
  if (!req.user) return next();
  storage.run({ userId: req.user.id, farmId: req.farmId }, next);
}

/** Текущий контекст или `null`, если код выполняется вне запроса (cron, тест). */
function currentContext() {
  return storage.getStore() || null;
}

module.exports = { withRequestContext, currentContext };
