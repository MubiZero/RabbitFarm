const { Sequelize } = require('sequelize');
const config = require('../config/database');

const env = process.env.NODE_ENV || 'development';
const dbConfig = config[env];

// Create Sequelize instance
const sequelize = new Sequelize(
  dbConfig.database,
  dbConfig.username,
  dbConfig.password,
  dbConfig
);

// Import models
const Farm = require('./Farm')(sequelize);
const User = require('./User')(sequelize);
const RefreshToken = require('./RefreshToken')(sequelize);
const Breed = require('./Breed')(sequelize);
const Invitation = require('./Invitation')(sequelize);
const Cage = require('./Cage')(sequelize);
const Rabbit = require('./Rabbit')(sequelize);
const RabbitWeight = require('./RabbitWeight')(sequelize);
const Breeding = require('./Breeding')(sequelize);
const Birth = require('./Birth')(sequelize);
const Vaccination = require('./Vaccination')(sequelize);
const MedicalRecord = require('./MedicalRecord')(sequelize);
const Feed = require('./Feed')(sequelize);
const FeedingRecord = require('./FeedingRecord')(sequelize);
const Transaction = require('./Transaction')(sequelize);
const Task = require('./Task')(sequelize);
const Photo = require('./Photo')(sequelize);
const Note = require('./Note')(sequelize);
const TokenBlacklist = require('./TokenBlacklist')(sequelize);
const PasswordResetToken = require('./PasswordResetToken')(sequelize);

// Define associations

// Ферма и её люди. Хозяйство ссылается на владельца, владелец — на
// хозяйство: при регистрации они появляются по очереди, в одной транзакции.
Farm.belongsTo(User, { as: 'owner', foreignKey: 'owner_id' });
Farm.hasMany(User, { as: 'staff', foreignKey: 'farm_id', onDelete: 'CASCADE' });
User.belongsTo(Farm, { as: 'farm', foreignKey: 'farm_id' });

// Всё имущество и вся история принадлежат ферме напрямую. Удаление
// хозяйства уносит его данные — учётной записи вне фермы не существует.
Farm.hasMany(Breed, { foreignKey: 'farm_id', onDelete: 'CASCADE' });
Farm.hasMany(Cage, { foreignKey: 'farm_id', onDelete: 'CASCADE' });
Farm.hasMany(Feed, { foreignKey: 'farm_id', onDelete: 'CASCADE' });
Farm.hasMany(Rabbit, { foreignKey: 'farm_id', onDelete: 'CASCADE' });
Farm.hasMany(RabbitWeight, { foreignKey: 'farm_id', onDelete: 'CASCADE' });
Farm.hasMany(Breeding, { foreignKey: 'farm_id', onDelete: 'CASCADE' });
Farm.hasMany(Birth, { foreignKey: 'farm_id', onDelete: 'CASCADE' });
Farm.hasMany(Vaccination, { foreignKey: 'farm_id', onDelete: 'CASCADE' });
Farm.hasMany(MedicalRecord, { foreignKey: 'farm_id', onDelete: 'CASCADE' });
Farm.hasMany(FeedingRecord, { foreignKey: 'farm_id', onDelete: 'CASCADE' });
Farm.hasMany(Transaction, { foreignKey: 'farm_id', onDelete: 'CASCADE' });
Farm.hasMany(Task, { foreignKey: 'farm_id', onDelete: 'CASCADE' });
Farm.hasMany(Photo, { foreignKey: 'farm_id', onDelete: 'CASCADE' });
Farm.hasMany(Note, { foreignKey: 'farm_id', onDelete: 'CASCADE' });
Farm.hasMany(Invitation, { foreignKey: 'farm_id', onDelete: 'CASCADE' });

// Обратная сторона: по записи всегда видно её хозяйство.
Breed.belongsTo(Farm, { as: 'farm', foreignKey: 'farm_id' });
Cage.belongsTo(Farm, { as: 'farm', foreignKey: 'farm_id' });
Feed.belongsTo(Farm, { as: 'farm', foreignKey: 'farm_id' });
Rabbit.belongsTo(Farm, { as: 'farm', foreignKey: 'farm_id' });
RabbitWeight.belongsTo(Farm, { as: 'farm', foreignKey: 'farm_id' });
Breeding.belongsTo(Farm, { as: 'farm', foreignKey: 'farm_id' });
Birth.belongsTo(Farm, { as: 'farm', foreignKey: 'farm_id' });
Vaccination.belongsTo(Farm, { as: 'farm', foreignKey: 'farm_id' });
MedicalRecord.belongsTo(Farm, { as: 'farm', foreignKey: 'farm_id' });
FeedingRecord.belongsTo(Farm, { as: 'farm', foreignKey: 'farm_id' });
Transaction.belongsTo(Farm, { as: 'farm', foreignKey: 'farm_id' });
Task.belongsTo(Farm, { as: 'farm', foreignKey: 'farm_id' });
Photo.belongsTo(Farm, { as: 'farm', foreignKey: 'farm_id' });
Note.belongsTo(Farm, { as: 'farm', foreignKey: 'farm_id' });

// User associations
User.hasMany(RefreshToken, { foreignKey: 'user_id', onDelete: 'CASCADE' });
// Приглашение выписывает человек, а принадлежит оно ферме.
Invitation.belongsTo(Farm, { as: 'farm', foreignKey: 'farm_id' });
Invitation.belongsTo(User, { as: 'author', foreignKey: 'created_by' });

RefreshToken.belongsTo(User, { foreignKey: 'user_id' });

User.hasMany(PasswordResetToken, { foreignKey: 'user_id', onDelete: 'CASCADE' });
PasswordResetToken.belongsTo(User, { foreignKey: 'user_id' });

User.hasMany(Task, { as: 'assignedTo', foreignKey: 'assigned_to', onDelete: 'SET NULL' });
User.hasMany(Task, { as: 'creator', foreignKey: 'created_by', onDelete: 'SET NULL' });
User.hasMany(Transaction, { foreignKey: 'created_by', onDelete: 'SET NULL' });
User.hasMany(FeedingRecord, { foreignKey: 'fed_by', onDelete: 'SET NULL' });
User.hasMany(Photo, { foreignKey: 'uploaded_by', onDelete: 'SET NULL' });
User.hasMany(Note, { foreignKey: 'created_by', onDelete: 'SET NULL' });

// Breed associations
Breed.hasMany(Rabbit, { foreignKey: 'breed_id', onDelete: 'RESTRICT' });

// Cage associations
Cage.hasMany(Rabbit, { as: 'rabbits', foreignKey: 'cage_id', onDelete: 'SET NULL' });
Cage.hasMany(FeedingRecord, { foreignKey: 'cage_id', onDelete: 'SET NULL' });
Cage.hasMany(Task, { foreignKey: 'cage_id', onDelete: 'CASCADE' });
Cage.hasMany(Note, { foreignKey: 'cage_id', onDelete: 'CASCADE' });

// Rabbit associations
Rabbit.belongsTo(Breed, { as: 'breed', foreignKey: 'breed_id' });
Rabbit.belongsTo(Cage, { foreignKey: 'cage_id' });

// Self-referential associations for parents
Rabbit.belongsTo(Rabbit, { as: 'father', foreignKey: 'father_id' });
Rabbit.belongsTo(Rabbit, { as: 'mother', foreignKey: 'mother_id' });
Rabbit.hasMany(Rabbit, { as: 'offspring_as_father', foreignKey: 'father_id' });
Rabbit.hasMany(Rabbit, { as: 'offspring_as_mother', foreignKey: 'mother_id' });

// Rabbit related associations
Rabbit.hasMany(RabbitWeight, { foreignKey: 'rabbit_id', onDelete: 'CASCADE' });
Rabbit.hasMany(Vaccination, { foreignKey: 'rabbit_id', onDelete: 'CASCADE' });
Rabbit.hasMany(MedicalRecord, { foreignKey: 'rabbit_id', onDelete: 'CASCADE' });
Rabbit.hasMany(FeedingRecord, { foreignKey: 'rabbit_id', onDelete: 'CASCADE' });
Rabbit.hasMany(Transaction, { foreignKey: 'rabbit_id', onDelete: 'SET NULL' });
Rabbit.hasMany(Task, { as: 'tasks', foreignKey: 'rabbit_id', onDelete: 'CASCADE' });
Rabbit.hasMany(Photo, { foreignKey: 'rabbit_id', onDelete: 'CASCADE' });
Rabbit.hasMany(Note, { foreignKey: 'rabbit_id', onDelete: 'CASCADE' });

// Breeding associations
Rabbit.hasMany(Breeding, { as: 'breedings_as_male', foreignKey: 'male_id', onDelete: 'RESTRICT' });
Rabbit.hasMany(Breeding, { as: 'breedings_as_female', foreignKey: 'female_id', onDelete: 'RESTRICT' });
Breeding.belongsTo(Rabbit, { as: 'male', foreignKey: 'male_id' });
Breeding.belongsTo(Rabbit, { as: 'female', foreignKey: 'female_id' });

// Birth associations
Breeding.hasMany(Birth, { foreignKey: 'breeding_id', onDelete: 'CASCADE' });
Birth.belongsTo(Breeding, { as: 'breeding', foreignKey: 'breeding_id' });
Birth.belongsTo(Rabbit, { as: 'mother', foreignKey: 'mother_id' });
Rabbit.hasMany(Birth, { as: 'births', foreignKey: 'mother_id', onDelete: 'RESTRICT' });

// Other associations
RabbitWeight.belongsTo(Rabbit, { foreignKey: 'rabbit_id' });
Vaccination.belongsTo(Rabbit, { as: 'rabbit', foreignKey: 'rabbit_id' });
MedicalRecord.belongsTo(Rabbit, { as: 'rabbit', foreignKey: 'rabbit_id' });

Feed.hasMany(FeedingRecord, { foreignKey: 'feed_id', onDelete: 'RESTRICT' });
FeedingRecord.belongsTo(Rabbit, { as: 'rabbit', foreignKey: 'rabbit_id' });
FeedingRecord.belongsTo(Feed, { as: 'feed', foreignKey: 'feed_id' });
FeedingRecord.belongsTo(Cage, { as: 'cage', foreignKey: 'cage_id' });
FeedingRecord.belongsTo(User, { as: 'fedBy', foreignKey: 'fed_by' });

Transaction.belongsTo(Rabbit, { as: 'rabbit', foreignKey: 'rabbit_id' });
// Автоматический расход живёт ровно столько, сколько запись, из которой он
// создан: иначе в ведомости остаётся сирота со ссылкой на удалённое лечение.
MedicalRecord.hasOne(Transaction, { as: 'expense', foreignKey: 'medical_record_id', onDelete: 'CASCADE' });
Transaction.belongsTo(MedicalRecord, { as: 'medicalRecord', foreignKey: 'medical_record_id' });
Vaccination.hasOne(Transaction, { as: 'expense', foreignKey: 'vaccination_id', onDelete: 'CASCADE' });
Transaction.belongsTo(Vaccination, { as: 'vaccination', foreignKey: 'vaccination_id' });
Transaction.belongsTo(User, { as: 'creator', foreignKey: 'created_by' });

Task.belongsTo(Rabbit, { as: 'rabbit', foreignKey: 'rabbit_id' });
Task.belongsTo(Cage, { as: 'cage', foreignKey: 'cage_id' });
Task.belongsTo(User, { as: 'assignedTo', foreignKey: 'assigned_to' });
Task.belongsTo(User, { as: 'creator', foreignKey: 'created_by' });

Photo.belongsTo(Rabbit, { foreignKey: 'rabbit_id' });
Photo.belongsTo(User, { foreignKey: 'uploaded_by' });

Note.belongsTo(Rabbit, { as: 'rabbit', foreignKey: 'rabbit_id' });
Note.belongsTo(Cage, { as: 'cage', foreignKey: 'cage_id' });
Note.belongsTo(User, { as: 'author', foreignKey: 'created_by' });

// Запрос к таблице фермы без условия по farm_id дальше не проходит.
// Подключаем после того, как все модели определены и связаны.
require('../utils/tenancy').attach({
  Breed, Cage, Feed, Rabbit, RabbitWeight, Breeding, Birth,
  Vaccination, MedicalRecord, FeedingRecord, Transaction, Task, Photo, Note,
  Invitation
});

// Export models and sequelize instance
module.exports = {
  Farm,
  Invitation,
  sequelize,
  Sequelize,
  User,
  RefreshToken,
  TokenBlacklist,
  PasswordResetToken,
  Breed,
  Cage,
  Rabbit,
  RabbitWeight,
  Breeding,
  Birth,
  Vaccination,
  MedicalRecord,
  Feed,
  FeedingRecord,
  Transaction,
  Task,
  Photo,
  Note
};
