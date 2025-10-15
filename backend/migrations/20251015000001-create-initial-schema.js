'use strict';

module.exports = {
  up: async (queryInterface, Sequelize) => {
    // Users table
    await queryInterface.createTable('users', {
      id: {
        type: Sequelize.INTEGER,
        primaryKey: true,
        autoIncrement: true
      },
      email: {
        type: Sequelize.STRING(255),
        allowNull: false,
        unique: true
      },
      password_hash: {
        type: Sequelize.STRING(255),
        allowNull: false
      },
      full_name: {
        type: Sequelize.STRING(255),
        allowNull: false
      },
      role: {
        type: Sequelize.ENUM('owner', 'manager', 'worker'),
        allowNull: false,
        defaultValue: 'worker'
      },
      phone: {
        type: Sequelize.STRING(20),
        allowNull: true
      },
      avatar_url: {
        type: Sequelize.STRING(500),
        allowNull: true
      },
      is_active: {
        type: Sequelize.BOOLEAN,
        allowNull: false,
        defaultValue: true
      },
      last_login_at: {
        type: Sequelize.DATE,
        allowNull: true
      },
      created_at: {
        type: Sequelize.DATE,
        allowNull: false,
        defaultValue: Sequelize.literal('CURRENT_TIMESTAMP')
      },
      updated_at: {
        type: Sequelize.DATE,
        allowNull: false,
        defaultValue: Sequelize.literal('CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP')
      }
    });

    await queryInterface.addIndex('users', ['email']);
    await queryInterface.addIndex('users', ['role']);
    await queryInterface.addIndex('users', ['is_active']);

    // Refresh tokens table
    await queryInterface.createTable('refresh_tokens', {
      id: {
        type: Sequelize.INTEGER,
        primaryKey: true,
        autoIncrement: true
      },
      user_id: {
        type: Sequelize.INTEGER,
        allowNull: false,
        references: {
          model: 'users',
          key: 'id'
        },
        onDelete: 'CASCADE'
      },
      token: {
        type: Sequelize.STRING(500),
        allowNull: false,
        unique: true
      },
      expires_at: {
        type: Sequelize.DATE,
        allowNull: false
      },
      created_at: {
        type: Sequelize.DATE,
        allowNull: false,
        defaultValue: Sequelize.literal('CURRENT_TIMESTAMP')
      }
    });

    await queryInterface.addIndex('refresh_tokens', ['token']);
    await queryInterface.addIndex('refresh_tokens', ['user_id']);
    await queryInterface.addIndex('refresh_tokens', ['expires_at']);

    // Breeds table
    await queryInterface.createTable('breeds', {
      id: {
        type: Sequelize.INTEGER,
        primaryKey: true,
        autoIncrement: true
      },
      name: {
        type: Sequelize.STRING(100),
        allowNull: false,
        unique: true
      },
      description: {
        type: Sequelize.TEXT,
        allowNull: true
      },
      average_weight: {
        type: Sequelize.DECIMAL(5, 2),
        allowNull: true
      },
      average_litter_size: {
        type: Sequelize.INTEGER,
        allowNull: true
      },
      purpose: {
        type: Sequelize.ENUM('meat', 'fur', 'decorative', 'combined'),
        defaultValue: 'combined'
      },
      photo_url: {
        type: Sequelize.STRING(500),
        allowNull: true
      },
      created_at: {
        type: Sequelize.DATE,
        allowNull: false,
        defaultValue: Sequelize.literal('CURRENT_TIMESTAMP')
      },
      updated_at: {
        type: Sequelize.DATE,
        allowNull: false,
        defaultValue: Sequelize.literal('CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP')
      }
    });

    await queryInterface.addIndex('breeds', ['name']);
    await queryInterface.addIndex('breeds', ['purpose']);

    // Cages table
    await queryInterface.createTable('cages', {
      id: {
        type: Sequelize.INTEGER,
        primaryKey: true,
        autoIncrement: true
      },
      number: {
        type: Sequelize.STRING(50),
        allowNull: false,
        unique: true
      },
      type: {
        type: Sequelize.ENUM('single', 'group', 'maternity'),
        allowNull: false,
        defaultValue: 'single'
      },
      size: {
        type: Sequelize.STRING(50),
        allowNull: true
      },
      capacity: {
        type: Sequelize.INTEGER,
        allowNull: false,
        defaultValue: 1
      },
      location: {
        type: Sequelize.STRING(255),
        allowNull: true
      },
      condition: {
        type: Sequelize.ENUM('good', 'needs_repair', 'broken'),
        allowNull: false,
        defaultValue: 'good'
      },
      last_cleaned_at: {
        type: Sequelize.DATE,
        allowNull: true
      },
      notes: {
        type: Sequelize.TEXT,
        allowNull: true
      },
      created_at: {
        type: Sequelize.DATE,
        allowNull: false,
        defaultValue: Sequelize.literal('CURRENT_TIMESTAMP')
      },
      updated_at: {
        type: Sequelize.DATE,
        allowNull: false,
        defaultValue: Sequelize.literal('CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP')
      }
    });

    await queryInterface.addIndex('cages', ['number']);
    await queryInterface.addIndex('cages', ['type']);
    await queryInterface.addIndex('cages', ['condition']);

    // Rabbits table
    await queryInterface.createTable('rabbits', {
      id: {
        type: Sequelize.INTEGER,
        primaryKey: true,
        autoIncrement: true
      },
      tag_id: {
        type: Sequelize.STRING(50),
        unique: true,
        allowNull: true
      },
      name: {
        type: Sequelize.STRING(100),
        allowNull: true
      },
      breed_id: {
        type: Sequelize.INTEGER,
        allowNull: false,
        references: {
          model: 'breeds',
          key: 'id'
        },
        onDelete: 'RESTRICT'
      },
      sex: {
        type: Sequelize.ENUM('male', 'female'),
        allowNull: false
      },
      birth_date: {
        type: Sequelize.DATEONLY,
        allowNull: false
      },
      color: {
        type: Sequelize.STRING(100),
        allowNull: true
      },
      cage_id: {
        type: Sequelize.INTEGER,
        allowNull: true,
        references: {
          model: 'cages',
          key: 'id'
        },
        onDelete: 'SET NULL'
      },
      father_id: {
        type: Sequelize.INTEGER,
        allowNull: true,
        references: {
          model: 'rabbits',
          key: 'id'
        },
        onDelete: 'SET NULL'
      },
      mother_id: {
        type: Sequelize.INTEGER,
        allowNull: true,
        references: {
          model: 'rabbits',
          key: 'id'
        },
        onDelete: 'SET NULL'
      },
      status: {
        type: Sequelize.ENUM('healthy', 'sick', 'quarantine', 'pregnant', 'sold', 'dead'),
        allowNull: false,
        defaultValue: 'healthy'
      },
      purpose: {
        type: Sequelize.ENUM('breeding', 'meat', 'sale', 'show'),
        allowNull: false,
        defaultValue: 'breeding'
      },
      acquired_date: {
        type: Sequelize.DATEONLY,
        allowNull: true
      },
      sold_date: {
        type: Sequelize.DATEONLY,
        allowNull: true
      },
      death_date: {
        type: Sequelize.DATEONLY,
        allowNull: true
      },
      death_reason: {
        type: Sequelize.STRING(255),
        allowNull: true
      },
      current_weight: {
        type: Sequelize.DECIMAL(5, 2),
        allowNull: true
      },
      temperament: {
        type: Sequelize.STRING(100),
        allowNull: true
      },
      notes: {
        type: Sequelize.TEXT,
        allowNull: true
      },
      photo_url: {
        type: Sequelize.STRING(500),
        allowNull: true
      },
      created_at: {
        type: Sequelize.DATE,
        allowNull: false,
        defaultValue: Sequelize.literal('CURRENT_TIMESTAMP')
      },
      updated_at: {
        type: Sequelize.DATE,
        allowNull: false,
        defaultValue: Sequelize.literal('CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP')
      }
    });

    await queryInterface.addIndex('rabbits', ['tag_id']);
    await queryInterface.addIndex('rabbits', ['name']);
    await queryInterface.addIndex('rabbits', ['breed_id']);
    await queryInterface.addIndex('rabbits', ['sex']);
    await queryInterface.addIndex('rabbits', ['status']);
    await queryInterface.addIndex('rabbits', ['purpose']);
    await queryInterface.addIndex('rabbits', ['birth_date']);
    await queryInterface.addIndex('rabbits', ['cage_id']);
    await queryInterface.addIndex('rabbits', ['father_id']);
    await queryInterface.addIndex('rabbits', ['mother_id']);

    // Rabbit weights table
    await queryInterface.createTable('rabbit_weights', {
      id: {
        type: Sequelize.INTEGER,
        primaryKey: true,
        autoIncrement: true
      },
      rabbit_id: {
        type: Sequelize.INTEGER,
        allowNull: false,
        references: {
          model: 'rabbits',
          key: 'id'
        },
        onDelete: 'CASCADE'
      },
      weight: {
        type: Sequelize.DECIMAL(5, 2),
        allowNull: false
      },
      measured_at: {
        type: Sequelize.DATE,
        allowNull: false
      },
      notes: {
        type: Sequelize.TEXT,
        allowNull: true
      },
      created_at: {
        type: Sequelize.DATE,
        allowNull: false,
        defaultValue: Sequelize.literal('CURRENT_TIMESTAMP')
      }
    });

    await queryInterface.addIndex('rabbit_weights', ['rabbit_id']);
    await queryInterface.addIndex('rabbit_weights', ['measured_at']);

    // Breedings table
    await queryInterface.createTable('breedings', {
      id: {
        type: Sequelize.INTEGER,
        primaryKey: true,
        autoIncrement: true
      },
      male_id: {
        type: Sequelize.INTEGER,
        allowNull: false,
        references: {
          model: 'rabbits',
          key: 'id'
        },
        onDelete: 'RESTRICT'
      },
      female_id: {
        type: Sequelize.INTEGER,
        allowNull: false,
        references: {
          model: 'rabbits',
          key: 'id'
        },
        onDelete: 'RESTRICT'
      },
      breeding_date: {
        type: Sequelize.DATEONLY,
        allowNull: false
      },
      status: {
        type: Sequelize.ENUM('planned', 'completed', 'failed', 'cancelled'),
        allowNull: false,
        defaultValue: 'planned'
      },
      palpation_date: {
        type: Sequelize.DATEONLY,
        allowNull: true
      },
      is_pregnant: {
        type: Sequelize.BOOLEAN,
        allowNull: true
      },
      expected_birth_date: {
        type: Sequelize.DATEONLY,
        allowNull: true
      },
      notes: {
        type: Sequelize.TEXT,
        allowNull: true
      },
      created_at: {
        type: Sequelize.DATE,
        allowNull: false,
        defaultValue: Sequelize.literal('CURRENT_TIMESTAMP')
      },
      updated_at: {
        type: Sequelize.DATE,
        allowNull: false,
        defaultValue: Sequelize.literal('CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP')
      }
    });

    await queryInterface.addIndex('breedings', ['male_id']);
    await queryInterface.addIndex('breedings', ['female_id']);
    await queryInterface.addIndex('breedings', ['breeding_date']);
    await queryInterface.addIndex('breedings', ['status']);
    await queryInterface.addIndex('breedings', ['expected_birth_date']);

    // Births table
    await queryInterface.createTable('births', {
      id: {
        type: Sequelize.INTEGER,
        primaryKey: true,
        autoIncrement: true
      },
      breeding_id: {
        type: Sequelize.INTEGER,
        allowNull: false,
        references: {
          model: 'breedings',
          key: 'id'
        },
        onDelete: 'CASCADE'
      },
      mother_id: {
        type: Sequelize.INTEGER,
        allowNull: false,
        references: {
          model: 'rabbits',
          key: 'id'
        },
        onDelete: 'RESTRICT'
      },
      birth_date: {
        type: Sequelize.DATEONLY,
        allowNull: false
      },
      kits_born_alive: {
        type: Sequelize.INTEGER,
        allowNull: false,
        defaultValue: 0
      },
      kits_born_dead: {
        type: Sequelize.INTEGER,
        allowNull: false,
        defaultValue: 0
      },
      kits_weaned: {
        type: Sequelize.INTEGER,
        defaultValue: 0
      },
      weaning_date: {
        type: Sequelize.DATEONLY,
        allowNull: true
      },
      complications: {
        type: Sequelize.TEXT,
        allowNull: true
      },
      notes: {
        type: Sequelize.TEXT,
        allowNull: true
      },
      created_at: {
        type: Sequelize.DATE,
        allowNull: false,
        defaultValue: Sequelize.literal('CURRENT_TIMESTAMP')
      },
      updated_at: {
        type: Sequelize.DATE,
        allowNull: false,
        defaultValue: Sequelize.literal('CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP')
      }
    });

    await queryInterface.addIndex('births', ['breeding_id']);
    await queryInterface.addIndex('births', ['mother_id']);
    await queryInterface.addIndex('births', ['birth_date']);

    // Vaccinations table
    await queryInterface.createTable('vaccinations', {
      id: {
        type: Sequelize.INTEGER,
        primaryKey: true,
        autoIncrement: true
      },
      rabbit_id: {
        type: Sequelize.INTEGER,
        allowNull: false,
        references: {
          model: 'rabbits',
          key: 'id'
        },
        onDelete: 'CASCADE'
      },
      vaccine_name: {
        type: Sequelize.STRING(255),
        allowNull: false
      },
      vaccine_type: {
        type: Sequelize.ENUM('vhd', 'myxomatosis', 'pasteurellosis', 'other'),
        allowNull: false
      },
      vaccination_date: {
        type: Sequelize.DATEONLY,
        allowNull: false
      },
      next_vaccination_date: {
        type: Sequelize.DATEONLY,
        allowNull: true
      },
      batch_number: {
        type: Sequelize.STRING(100),
        allowNull: true
      },
      veterinarian: {
        type: Sequelize.STRING(255),
        allowNull: true
      },
      notes: {
        type: Sequelize.TEXT,
        allowNull: true
      },
      created_at: {
        type: Sequelize.DATE,
        allowNull: false,
        defaultValue: Sequelize.literal('CURRENT_TIMESTAMP')
      },
      updated_at: {
        type: Sequelize.DATE,
        allowNull: false,
        defaultValue: Sequelize.literal('CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP')
      }
    });

    await queryInterface.addIndex('vaccinations', ['rabbit_id']);
    await queryInterface.addIndex('vaccinations', ['vaccine_type']);
    await queryInterface.addIndex('vaccinations', ['vaccination_date']);
    await queryInterface.addIndex('vaccinations', ['next_vaccination_date']);

    // Medical records table
    await queryInterface.createTable('medical_records', {
      id: {
        type: Sequelize.INTEGER,
        primaryKey: true,
        autoIncrement: true
      },
      rabbit_id: {
        type: Sequelize.INTEGER,
        allowNull: false,
        references: {
          model: 'rabbits',
          key: 'id'
        },
        onDelete: 'CASCADE'
      },
      symptoms: {
        type: Sequelize.TEXT,
        allowNull: false
      },
      diagnosis: {
        type: Sequelize.STRING(255),
        allowNull: true
      },
      treatment: {
        type: Sequelize.TEXT,
        allowNull: true
      },
      medication: {
        type: Sequelize.STRING(255),
        allowNull: true
      },
      dosage: {
        type: Sequelize.STRING(100),
        allowNull: true
      },
      started_at: {
        type: Sequelize.DATEONLY,
        allowNull: false
      },
      ended_at: {
        type: Sequelize.DATEONLY,
        allowNull: true
      },
      outcome: {
        type: Sequelize.ENUM('recovered', 'ongoing', 'died', 'euthanized'),
        allowNull: true
      },
      cost: {
        type: Sequelize.DECIMAL(10, 2),
        allowNull: true
      },
      veterinarian: {
        type: Sequelize.STRING(255),
        allowNull: true
      },
      notes: {
        type: Sequelize.TEXT,
        allowNull: true
      },
      created_at: {
        type: Sequelize.DATE,
        allowNull: false,
        defaultValue: Sequelize.literal('CURRENT_TIMESTAMP')
      },
      updated_at: {
        type: Sequelize.DATE,
        allowNull: false,
        defaultValue: Sequelize.literal('CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP')
      }
    });

    await queryInterface.addIndex('medical_records', ['rabbit_id']);
    await queryInterface.addIndex('medical_records', ['started_at']);
    await queryInterface.addIndex('medical_records', ['outcome']);

    // Feeds table
    await queryInterface.createTable('feeds', {
      id: {
        type: Sequelize.INTEGER,
        primaryKey: true,
        autoIncrement: true
      },
      name: {
        type: Sequelize.STRING(255),
        allowNull: false
      },
      type: {
        type: Sequelize.ENUM('pellets', 'hay', 'vegetables', 'grain', 'supplements', 'other'),
        allowNull: false
      },
      brand: {
        type: Sequelize.STRING(255),
        allowNull: true
      },
      unit: {
        type: Sequelize.ENUM('kg', 'liter', 'piece'),
        allowNull: false,
        defaultValue: 'kg'
      },
      current_stock: {
        type: Sequelize.DECIMAL(10, 2),
        allowNull: false,
        defaultValue: 0
      },
      min_stock: {
        type: Sequelize.DECIMAL(10, 2),
        allowNull: false,
        defaultValue: 0
      },
      cost_per_unit: {
        type: Sequelize.DECIMAL(10, 2),
        allowNull: true
      },
      notes: {
        type: Sequelize.TEXT,
        allowNull: true
      },
      created_at: {
        type: Sequelize.DATE,
        allowNull: false,
        defaultValue: Sequelize.literal('CURRENT_TIMESTAMP')
      },
      updated_at: {
        type: Sequelize.DATE,
        allowNull: false,
        defaultValue: Sequelize.literal('CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP')
      }
    });

    await queryInterface.addIndex('feeds', ['name']);
    await queryInterface.addIndex('feeds', ['type']);

    // Feeding records table
    await queryInterface.createTable('feeding_records', {
      id: {
        type: Sequelize.INTEGER,
        primaryKey: true,
        autoIncrement: true
      },
      rabbit_id: {
        type: Sequelize.INTEGER,
        allowNull: true,
        references: {
          model: 'rabbits',
          key: 'id'
        },
        onDelete: 'CASCADE'
      },
      feed_id: {
        type: Sequelize.INTEGER,
        allowNull: false,
        references: {
          model: 'feeds',
          key: 'id'
        },
        onDelete: 'RESTRICT'
      },
      cage_id: {
        type: Sequelize.INTEGER,
        allowNull: true,
        references: {
          model: 'cages',
          key: 'id'
        },
        onDelete: 'SET NULL'
      },
      quantity: {
        type: Sequelize.DECIMAL(10, 2),
        allowNull: false
      },
      fed_at: {
        type: Sequelize.DATE,
        allowNull: false
      },
      fed_by: {
        type: Sequelize.INTEGER,
        allowNull: true,
        references: {
          model: 'users',
          key: 'id'
        },
        onDelete: 'SET NULL'
      },
      notes: {
        type: Sequelize.TEXT,
        allowNull: true
      },
      created_at: {
        type: Sequelize.DATE,
        allowNull: false,
        defaultValue: Sequelize.literal('CURRENT_TIMESTAMP')
      }
    });

    await queryInterface.addIndex('feeding_records', ['rabbit_id']);
    await queryInterface.addIndex('feeding_records', ['feed_id']);
    await queryInterface.addIndex('feeding_records', ['cage_id']);
    await queryInterface.addIndex('feeding_records', ['fed_at']);

    // Transactions table
    await queryInterface.createTable('transactions', {
      id: {
        type: Sequelize.INTEGER,
        primaryKey: true,
        autoIncrement: true
      },
      type: {
        type: Sequelize.ENUM('income', 'expense'),
        allowNull: false
      },
      category: {
        type: Sequelize.ENUM(
          'sale_rabbit', 'sale_meat', 'sale_fur', 'breeding_fee',
          'feed', 'veterinary', 'equipment', 'utilities', 'other'
        ),
        allowNull: false
      },
      amount: {
        type: Sequelize.DECIMAL(10, 2),
        allowNull: false
      },
      transaction_date: {
        type: Sequelize.DATEONLY,
        allowNull: false
      },
      rabbit_id: {
        type: Sequelize.INTEGER,
        allowNull: true,
        references: {
          model: 'rabbits',
          key: 'id'
        },
        onDelete: 'SET NULL'
      },
      description: {
        type: Sequelize.TEXT,
        allowNull: true
      },
      receipt_url: {
        type: Sequelize.STRING(500),
        allowNull: true
      },
      created_by: {
        type: Sequelize.INTEGER,
        allowNull: true,
        references: {
          model: 'users',
          key: 'id'
        },
        onDelete: 'SET NULL'
      },
      created_at: {
        type: Sequelize.DATE,
        allowNull: false,
        defaultValue: Sequelize.literal('CURRENT_TIMESTAMP')
      },
      updated_at: {
        type: Sequelize.DATE,
        allowNull: false,
        defaultValue: Sequelize.literal('CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP')
      }
    });

    await queryInterface.addIndex('transactions', ['type']);
    await queryInterface.addIndex('transactions', ['category']);
    await queryInterface.addIndex('transactions', ['transaction_date']);
    await queryInterface.addIndex('transactions', ['rabbit_id']);

    // Tasks table
    await queryInterface.createTable('tasks', {
      id: {
        type: Sequelize.INTEGER,
        primaryKey: true,
        autoIncrement: true
      },
      title: {
        type: Sequelize.STRING(255),
        allowNull: false
      },
      description: {
        type: Sequelize.TEXT,
        allowNull: true
      },
      type: {
        type: Sequelize.ENUM('feeding', 'cleaning', 'vaccination', 'checkup', 'breeding', 'other'),
        allowNull: false
      },
      status: {
        type: Sequelize.ENUM('pending', 'in_progress', 'completed', 'cancelled'),
        allowNull: false,
        defaultValue: 'pending'
      },
      priority: {
        type: Sequelize.ENUM('low', 'medium', 'high', 'urgent'),
        allowNull: false,
        defaultValue: 'medium'
      },
      due_date: {
        type: Sequelize.DATE,
        allowNull: false
      },
      completed_at: {
        type: Sequelize.DATE,
        allowNull: true
      },
      rabbit_id: {
        type: Sequelize.INTEGER,
        allowNull: true,
        references: {
          model: 'rabbits',
          key: 'id'
        },
        onDelete: 'CASCADE'
      },
      cage_id: {
        type: Sequelize.INTEGER,
        allowNull: true,
        references: {
          model: 'cages',
          key: 'id'
        },
        onDelete: 'CASCADE'
      },
      assigned_to: {
        type: Sequelize.INTEGER,
        allowNull: true,
        references: {
          model: 'users',
          key: 'id'
        },
        onDelete: 'SET NULL'
      },
      created_by: {
        type: Sequelize.INTEGER,
        allowNull: true,
        references: {
          model: 'users',
          key: 'id'
        },
        onDelete: 'SET NULL'
      },
      is_recurring: {
        type: Sequelize.BOOLEAN,
        allowNull: false,
        defaultValue: false
      },
      recurrence_rule: {
        type: Sequelize.STRING(255),
        allowNull: true
      },
      reminder_before: {
        type: Sequelize.INTEGER,
        allowNull: true
      },
      notes: {
        type: Sequelize.TEXT,
        allowNull: true
      },
      created_at: {
        type: Sequelize.DATE,
        allowNull: false,
        defaultValue: Sequelize.literal('CURRENT_TIMESTAMP')
      },
      updated_at: {
        type: Sequelize.DATE,
        allowNull: false,
        defaultValue: Sequelize.literal('CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP')
      }
    });

    await queryInterface.addIndex('tasks', ['status']);
    await queryInterface.addIndex('tasks', ['due_date']);
    await queryInterface.addIndex('tasks', ['assigned_to']);
    await queryInterface.addIndex('tasks', ['rabbit_id']);
    await queryInterface.addIndex('tasks', ['cage_id']);

    // Photos table
    await queryInterface.createTable('photos', {
      id: {
        type: Sequelize.INTEGER,
        primaryKey: true,
        autoIncrement: true
      },
      rabbit_id: {
        type: Sequelize.INTEGER,
        allowNull: false,
        references: {
          model: 'rabbits',
          key: 'id'
        },
        onDelete: 'CASCADE'
      },
      url: {
        type: Sequelize.STRING(500),
        allowNull: false
      },
      caption: {
        type: Sequelize.TEXT,
        allowNull: true
      },
      taken_at: {
        type: Sequelize.DATE,
        allowNull: true
      },
      uploaded_by: {
        type: Sequelize.INTEGER,
        allowNull: true,
        references: {
          model: 'users',
          key: 'id'
        },
        onDelete: 'SET NULL'
      },
      created_at: {
        type: Sequelize.DATE,
        allowNull: false,
        defaultValue: Sequelize.literal('CURRENT_TIMESTAMP')
      }
    });

    await queryInterface.addIndex('photos', ['rabbit_id']);
    await queryInterface.addIndex('photos', ['taken_at']);

    // Notes table
    await queryInterface.createTable('notes', {
      id: {
        type: Sequelize.INTEGER,
        primaryKey: true,
        autoIncrement: true
      },
      rabbit_id: {
        type: Sequelize.INTEGER,
        allowNull: true,
        references: {
          model: 'rabbits',
          key: 'id'
        },
        onDelete: 'CASCADE'
      },
      cage_id: {
        type: Sequelize.INTEGER,
        allowNull: true,
        references: {
          model: 'cages',
          key: 'id'
        },
        onDelete: 'CASCADE'
      },
      content: {
        type: Sequelize.TEXT,
        allowNull: false
      },
      created_by: {
        type: Sequelize.INTEGER,
        allowNull: true,
        references: {
          model: 'users',
          key: 'id'
        },
        onDelete: 'SET NULL'
      },
      created_at: {
        type: Sequelize.DATE,
        allowNull: false,
        defaultValue: Sequelize.literal('CURRENT_TIMESTAMP')
      },
      updated_at: {
        type: Sequelize.DATE,
        allowNull: false,
        defaultValue: Sequelize.literal('CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP')
      }
    });

    await queryInterface.addIndex('notes', ['rabbit_id']);
    await queryInterface.addIndex('notes', ['cage_id']);
  },

  down: async (queryInterface, Sequelize) => {
    // Drop tables in reverse order to avoid foreign key constraints
    await queryInterface.dropTable('notes');
    await queryInterface.dropTable('photos');
    await queryInterface.dropTable('tasks');
    await queryInterface.dropTable('transactions');
    await queryInterface.dropTable('feeding_records');
    await queryInterface.dropTable('feeds');
    await queryInterface.dropTable('medical_records');
    await queryInterface.dropTable('vaccinations');
    await queryInterface.dropTable('births');
    await queryInterface.dropTable('breedings');
    await queryInterface.dropTable('rabbit_weights');
    await queryInterface.dropTable('rabbits');
    await queryInterface.dropTable('cages');
    await queryInterface.dropTable('breeds');
    await queryInterface.dropTable('refresh_tokens');
    await queryInterface.dropTable('users');
  }
};
