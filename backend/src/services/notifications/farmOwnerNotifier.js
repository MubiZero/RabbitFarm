const { User } = require('../../models');
const notificationService = require('../notificationService');
const { sendAnnouncementEmail } = require('./emailTransport');
const { notificationText } = require('../../i18n/notifications');
const logger = require('../../utils/logger');

/**
 * Достучаться до владельцев фермы сразу двумя каналами — пуш и письмо.
 *
 * Ровно то, что нужно фоновым задачам, которые говорят с клиентом, а не с
 * работниками фермы: срок тарифа, приглашение вернуться. Дайджест по работе
 * фермы этим не пользуется — там адресат другой (`sendToRoles` на owner и
 * manager) и канал один.
 *
 * Два канала, а не один, потому что именно у этих сообщений адресат может
 * месяцами не открывать приложение: пуш до него просто не дойдёт.
 *
 * Пуш и письмо отвечают за отказ по-разному. Сбой пуша пробрасывается —
 * вызывающая задача сама решит, считать ли ферму обработанной (например, не
 * запоминать отправку, чтобы попробовать завтра). Сбой письма только пишется
 * в лог: одна ферма без почтового ящика или отвалившийся SMTP не должны
 * отменять уже доставленный пуш.
 */
async function notifyFarmOwners(farmId, { key, params = {}, data = {} }) {
  const owners = await User.findAll({
    where: { farm_id: farmId, role: 'owner', is_active: true },
    attributes: ['id', 'email', 'language']
  });
  if (owners.length === 0) return { owners: 0 };

  await notificationService.sendToUsers(farmId, owners.map((owner) => owner.id), {
    i18n: { key, params },
    data
  });

  // Письмо собирается заново на каждого: у совладельцев фермы языки могут
  // различаться, а тема и текст письма — такой же интерфейс, как и пуш.
  for (const owner of owners) {
    if (!owner.email) continue;
    const { title, body } = notificationText(key, owner.language, params);
    try {
      await sendAnnouncementEmail({ to: owner.email, subject: title, text: body });
    } catch (error) {
      logger.error('Farm owner email failed', { farmId, type: data.type, error: error.message });
    }
  }

  return { owners: owners.length };
}

module.exports = { notifyFarmOwners };
