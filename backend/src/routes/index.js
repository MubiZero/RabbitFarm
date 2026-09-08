const express = require('express');
const router = express.Router();

/**
 * Список смонтированных модулей — единственный источник правды.
 *
 * Раньше маршруты монтировались по одному, а рядом лежал рукописный справочник
 * endpoints: он успел разойтись с реальностью (обещал /health, /feeding,
 * /finance и /farm, которых нет, и дважды объявлял tasks). Теперь и монтирование,
 * и справочник строятся из одного массива, поэтому разойтись им негде.
 */
const modules = [
  ['/auth', require('./auth.routes')],
  ['/staff', require('./staff.routes')],
  ['/rabbits', require('./rabbit.routes')],
  ['/breeds', require('./breed.routes')],
  ['/births', require('./birth.routes')],
  ['/cages', require('./cage.routes')],
  ['/vaccinations', require('./vaccination.routes')],
  ['/medical-records', require('./medical-record.routes')],
  ['/feeds', require('./feed.routes')],
  ['/feeding-records', require('./feeding-record.routes')],
  ['/transactions', require('./transaction.routes')],
  ['/tasks', require('./task.routes')],
  ['/reports', require('./report.routes')],
  ['/breeding', require('./breeding.routes')],
  ['/notes', require('./note.routes')],
  ['/device-tokens', require('./device-token.routes')],
  ['/payments', require('./payment.routes')],
  ['/photos', require('./photo.routes')],
  ['/platform-admin', require('./platform-admin.routes')]
];

// API Info
router.get('/', (req, res) => {
  res.json({
    message: 'RabbitFarm API',
    version: process.env.API_VERSION || 'v1',
    documentation: '/api-docs',
    endpoints: modules.map(([path]) => path)
  });
});

for (const [path, routes] of modules) {
  router.use(path, routes);
}

module.exports = router;
