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
const User = require('./User')(sequelize);
const RefreshToken = require('./RefreshToken')(sequelize);
const Breed = require('./Breed')(sequelize);
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

// Define associations
// User associations
User.hasMany(RefreshToken, { foreignKey: 'user_id', onDelete: 'CASCADE' });
RefreshToken.belongsTo(User, { foreignKey: 'user_id' });

User.hasMany(Task, { as: 'assignedTasks', foreignKey: 'assigned_to', onDelete: 'SET NULL' });
User.hasMany(Task, { as: 'createdTasks', foreignKey: 'created_by', onDelete: 'SET NULL' });
User.hasMany(Transaction, { foreignKey: 'created_by', onDelete: 'SET NULL' });
User.hasMany(FeedingRecord, { foreignKey: 'fed_by', onDelete: 'SET NULL' });
User.hasMany(Photo, { foreignKey: 'uploaded_by', onDelete: 'SET NULL' });
User.hasMany(Note, { foreignKey: 'created_by', onDelete: 'SET NULL' });

// Breed associations
Breed.hasMany(Rabbit, { foreignKey: 'breed_id', onDelete: 'RESTRICT' });

// Cage associations
Cage.hasMany(Rabbit, { foreignKey: 'cage_id', onDelete: 'SET NULL' });
Cage.hasMany(FeedingRecord, { foreignKey: 'cage_id', onDelete: 'SET NULL' });
Cage.hasMany(Task, { foreignKey: 'cage_id', onDelete: 'CASCADE' });
Cage.hasMany(Note, { foreignKey: 'cage_id', onDelete: 'CASCADE' });

// Rabbit associations
Rabbit.belongsTo(Breed, { foreignKey: 'breed_id' });
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
Rabbit.hasMany(Task, { foreignKey: 'rabbit_id', onDelete: 'CASCADE' });
Rabbit.hasMany(Photo, { foreignKey: 'rabbit_id', onDelete: 'CASCADE' });
Rabbit.hasMany(Note, { foreignKey: 'rabbit_id', onDelete: 'CASCADE' });

// Breeding associations
Rabbit.hasMany(Breeding, { as: 'breedings_as_male', foreignKey: 'male_id', onDelete: 'RESTRICT' });
Rabbit.hasMany(Breeding, { as: 'breedings_as_female', foreignKey: 'female_id', onDelete: 'RESTRICT' });
Breeding.belongsTo(Rabbit, { as: 'male', foreignKey: 'male_id' });
Breeding.belongsTo(Rabbit, { as: 'female', foreignKey: 'female_id' });

// Birth associations
Breeding.hasMany(Birth, { foreignKey: 'breeding_id', onDelete: 'CASCADE' });
Birth.belongsTo(Breeding, { foreignKey: 'breeding_id' });
Birth.belongsTo(Rabbit, { as: 'mother', foreignKey: 'mother_id' });
Rabbit.hasMany(Birth, { as: 'births', foreignKey: 'mother_id', onDelete: 'RESTRICT' });

// Other associations
RabbitWeight.belongsTo(Rabbit, { foreignKey: 'rabbit_id' });
Vaccination.belongsTo(Rabbit, { foreignKey: 'rabbit_id' });
MedicalRecord.belongsTo(Rabbit, { foreignKey: 'rabbit_id' });

Feed.hasMany(FeedingRecord, { foreignKey: 'feed_id', onDelete: 'RESTRICT' });
FeedingRecord.belongsTo(Rabbit, { foreignKey: 'rabbit_id' });
FeedingRecord.belongsTo(Feed, { foreignKey: 'feed_id' });
FeedingRecord.belongsTo(Cage, { foreignKey: 'cage_id' });
FeedingRecord.belongsTo(User, { foreignKey: 'fed_by' });

Transaction.belongsTo(Rabbit, { foreignKey: 'rabbit_id' });
Transaction.belongsTo(User, { foreignKey: 'created_by' });

Task.belongsTo(Rabbit, { foreignKey: 'rabbit_id' });
Task.belongsTo(Cage, { foreignKey: 'cage_id' });
Task.belongsTo(User, { as: 'assignedUser', foreignKey: 'assigned_to' });
Task.belongsTo(User, { as: 'creator', foreignKey: 'created_by' });

Photo.belongsTo(Rabbit, { foreignKey: 'rabbit_id' });
Photo.belongsTo(User, { foreignKey: 'uploaded_by' });

Note.belongsTo(Rabbit, { foreignKey: 'rabbit_id' });
Note.belongsTo(Cage, { foreignKey: 'cage_id' });
Note.belongsTo(User, { foreignKey: 'created_by' });

// Export models and sequelize instance
module.exports = {
  sequelize,
  Sequelize,
  User,
  RefreshToken,
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
