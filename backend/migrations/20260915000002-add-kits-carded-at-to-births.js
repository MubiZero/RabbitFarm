'use strict';

/**
 * Признак «по этому окролу уже заведены карточки крольчат».
 *
 * Крольчонок живёт в приложении двумя способами сразу: числами в записи об
 * окроле (`kits_born_alive` и остальные) и, если нажали «Завести карточки», —
 * строками в `rabbits`. Ни одна из половин не знала о другой, и из этого
 * росли сразу три беды: кнопку можно было нажать дважды и получить из шести
 * крольчат двенадцать карточек; падёж, отмеченный в выводке, не доходил до
 * карточек и наоборот; поголовье фермы и потребление тарифа зависели от того,
 * нажимали кнопку или нет.
 *
 * Отметка времени, а не флаг: «когда завели» отвечает на вопрос владельца
 * «почему у меня в клетке двадцать кроликов», а флаг — нет.
 *
 * Тем окролам, по которым карточки уже заводили, метка проставляется задним
 * числом — по наличию потомков этой матери с этой же датой рождения. Время
 * берётся от последней правки окрола: точного мы не знаем, а без метки защита
 * от повторного нажатия не сработала бы именно там, где уже задвоено.
 */
module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.addColumn('births', 'kits_carded_at', {
      type: Sequelize.DATE,
      allowNull: true,
      comment: 'When individual rabbit cards were created for this litter'
    });

    await queryInterface.sequelize.query(`
      UPDATE births b
      SET b.kits_carded_at = b.updated_at
      WHERE b.kits_carded_at IS NULL
        AND EXISTS (
          SELECT 1 FROM rabbits r
          WHERE r.farm_id = b.farm_id
            AND r.mother_id = b.mother_id
            AND r.birth_date = b.birth_date
        )
    `);
  },

  async down(queryInterface) {
    await queryInterface.removeColumn('births', 'kits_carded_at');
  }
};
