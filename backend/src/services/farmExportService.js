const {
  Farm, User, Rabbit, RabbitWeight, Breeding, Birth, Vaccination,
  MedicalRecord, Cage, Breed, Feed, FeedingRecord, Transaction, Task,
  Photo, Note, Payment
} = require('../models');

/**
 * Экспорт всех данных одной фермы одним JSON (см.
 * docs/plans/PLATFORM-ADMIN.md, 2.4): и для просьбы «отдайте мои данные»,
 * и как копия перед удалением.
 *
 * Внутренняя техника аутентификации и платформы (токены, приглашения,
 * устройства для пушей, журнал админа) сюда не входит намеренно: это не
 * данные хозяйства, а служебное устройство сервиса.
 */
class FarmExportService {
  /** Полный слепок данных фермы — синхронно, без очереди (масштаб — десятки ферм). */
  async exportFarm(farmId) {
    const farm = await Farm.findByPk(farmId, {
      include: [{ model: User, as: 'owner', attributes: ['id', 'full_name', 'email', 'phone'] }]
    });
    if (!farm) {
      throw new Error('FARM_NOT_FOUND');
    }

    const scoped = (Model, extra = {}) => Model.findAll({ where: { farm_id: farmId }, ...extra });

    // Все выборки уходят вместе: цепочка из шестнадцати запросов растянула бы
    // экспорт на сумму задержек вместо самой долгой из них.
    const [
      staff, rabbits, rabbitWeights, breedings, births, vaccinations,
      medicalRecords, cages, breeds, feeds, feedingRecords, transactions,
      tasks, photos, notes, payments
    ] = await Promise.all([
      // Хеш пароля и поколение токенов — не данные фермы, а её ключи от
      // дома: в выгрузке, которая уходит наружу, им места нет.
      scoped(User, { attributes: { exclude: ['password_hash', 'token_version'] } }),
      scoped(Rabbit),
      scoped(RabbitWeight),
      scoped(Breeding),
      scoped(Birth),
      scoped(Vaccination),
      scoped(MedicalRecord),
      scoped(Cage),
      scoped(Breed),
      scoped(Feed),
      scoped(FeedingRecord),
      scoped(Transaction),
      scoped(Task),
      scoped(Photo),
      scoped(Note),
      // Без raw_response — сырой ответ банка тяжёлый и содержит его
      // внутренние поля, к данным фермы не относящиеся.
      scoped(Payment, { attributes: { exclude: ['raw_response'] } })
    ]);

    return {
      generated_at: new Date().toISOString(),
      farm: farm.toJSON(),
      staff,
      rabbits,
      rabbit_weights: rabbitWeights,
      breedings,
      births,
      vaccinations,
      medical_records: medicalRecords,
      cages,
      breeds,
      feeds,
      feeding_records: feedingRecords,
      transactions,
      tasks,
      photos,
      notes,
      payments
    };
  }
}

module.exports = new FarmExportService();
