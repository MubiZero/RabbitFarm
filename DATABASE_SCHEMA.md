# RabbitFarm - Database Schema

## 📊 Database Overview

**Database**: MySQL 8.0
**Charset**: utf8mb4 (full Unicode support including emojis)
**Collation**: utf8mb4_unicode_ci
**Engine**: InnoDB (for foreign key support and transactions)
**Total Tables**: 15

## 🗂️ Table Relationships

```
users (1) ──────────────────────────── (*) rabbits
  │                                        │
  │                                        ├── (1) breed
  │                                        ├── (*) cage
  │                                        ├── (*) photos
  │                                        ├── (*) weights
  │                                        ├── (*) notes
  │                                        │
rabbits (2) ────┬─────────────────────────┤
  (male/female) │                          │
                ├── (*) breedings          │
                │      │                   │
                │      └── (*) births ─────┤
                │                          │
                ├── (*) vaccinations       │
                ├── (*) medical_records    │
                └── (*) feeding_records    │
                                           │
users ────────── (*) tasks                │
users ────────── (*) transactions         │
users ────────── (*) feeds                │
                     │                     │
                     └── (*) feeding_records
```

## 📋 Tables

### 1. users
Пользователи системы (владельцы, менеджеры, работники)

```sql
CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    email VARCHAR(255) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    full_name VARCHAR(255) NOT NULL,
    role ENUM('owner', 'manager', 'worker') NOT NULL DEFAULT 'worker',
    phone VARCHAR(20),
    avatar_url VARCHAR(500),
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    last_login_at DATETIME,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    INDEX idx_email (email),
    INDEX idx_role (role),
    INDEX idx_is_active (is_active)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

**Fields:**
- `id`: Уникальный идентификатор
- `email`: Email (для входа)
- `password_hash`: Хэш пароля (bcrypt)
- `full_name`: Полное имя
- `role`: Роль (owner/manager/worker)
- `phone`: Телефон (опционально)
- `avatar_url`: URL аватара
- `is_active`: Активен ли аккаунт
- `last_login_at`: Последний вход
- `created_at`: Дата создания
- `updated_at`: Дата обновления

---

### 2. refresh_tokens
Refresh токены для JWT аутентификации

```sql
CREATE TABLE refresh_tokens (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    token VARCHAR(500) NOT NULL UNIQUE,
    expires_at DATETIME NOT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_token (token),
    INDEX idx_user_id (user_id),
    INDEX idx_expires_at (expires_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

---

### 3. breeds
Породы кроликов

```sql
CREATE TABLE breeds (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT,
    average_weight DECIMAL(5, 2), -- кг
    average_litter_size INT, -- среднее количество крольчат
    purpose ENUM('meat', 'fur', 'decorative', 'combined') DEFAULT 'combined',
    photo_url VARCHAR(500),
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    INDEX idx_name (name),
    INDEX idx_purpose (purpose)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

**Common Breeds (для seed данных):**
- Калифорнийская
- Новозеландская белая
- Советская шиншилла
- Серый великан
- Фландр (Бельгийский великан)
- Рекс
- Венский голубой

---

### 4. cages
Клетки/вольеры

```sql
CREATE TABLE cages (
    id INT PRIMARY KEY AUTO_INCREMENT,
    number VARCHAR(50) NOT NULL UNIQUE, -- Номер клетки (A1, B2, etc.)
    type ENUM('single', 'group', 'maternity') NOT NULL DEFAULT 'single',
    size VARCHAR(50), -- Размер (например "60x80x45")
    capacity INT NOT NULL DEFAULT 1, -- Вместимость
    location VARCHAR(255), -- Расположение на ферме
    condition ENUM('good', 'needs_repair', 'broken') NOT NULL DEFAULT 'good',
    last_cleaned_at DATETIME,
    notes TEXT,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    INDEX idx_number (number),
    INDEX idx_type (type),
    INDEX idx_condition (condition)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

---

### 5. rabbits
Основная таблица кроликов

```sql
CREATE TABLE rabbits (
    id INT PRIMARY KEY AUTO_INCREMENT,
    tag_id VARCHAR(50) UNIQUE, -- Номер клейма/чипа
    name VARCHAR(100),
    breed_id INT NOT NULL,
    sex ENUM('male', 'female') NOT NULL,
    birth_date DATE NOT NULL,
    color VARCHAR(100), -- Окрас
    cage_id INT,

    -- Родители
    father_id INT,
    mother_id INT,

    -- Статус
    status ENUM('healthy', 'sick', 'quarantine', 'pregnant', 'sold', 'dead') NOT NULL DEFAULT 'healthy',
    purpose ENUM('breeding', 'meat', 'sale', 'show') NOT NULL DEFAULT 'breeding',

    -- Даты событий
    acquired_date DATE, -- Дата приобретения (если не родился на ферме)
    sold_date DATE,
    death_date DATE,
    death_reason VARCHAR(255),

    -- Характеристики
    current_weight DECIMAL(5, 2), -- кг
    temperament VARCHAR(100), -- Характер

    -- Дополнительно
    notes TEXT,
    photo_url VARCHAR(500), -- Основное фото

    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    FOREIGN KEY (breed_id) REFERENCES breeds(id) ON DELETE RESTRICT,
    FOREIGN KEY (cage_id) REFERENCES cages(id) ON DELETE SET NULL,
    FOREIGN KEY (father_id) REFERENCES rabbits(id) ON DELETE SET NULL,
    FOREIGN KEY (mother_id) REFERENCES rabbits(id) ON DELETE SET NULL,

    INDEX idx_tag_id (tag_id),
    INDEX idx_name (name),
    INDEX idx_breed_id (breed_id),
    INDEX idx_sex (sex),
    INDEX idx_status (status),
    INDEX idx_purpose (purpose),
    INDEX idx_birth_date (birth_date),
    INDEX idx_cage_id (cage_id),
    INDEX idx_father_id (father_id),
    INDEX idx_mother_id (mother_id),

    FULLTEXT INDEX idx_search (name, tag_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

---

### 6. rabbit_weights
История взвешиваний кроликов

```sql
CREATE TABLE rabbit_weights (
    id INT PRIMARY KEY AUTO_INCREMENT,
    rabbit_id INT NOT NULL,
    weight DECIMAL(5, 2) NOT NULL, -- кг
    measured_at DATETIME NOT NULL,
    notes TEXT,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (rabbit_id) REFERENCES rabbits(id) ON DELETE CASCADE,
    INDEX idx_rabbit_id (rabbit_id),
    INDEX idx_measured_at (measured_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

---

### 7. breedings
Случки (спаривания)

```sql
CREATE TABLE breedings (
    id INT PRIMARY KEY AUTO_INCREMENT,
    male_id INT NOT NULL,
    female_id INT NOT NULL,
    breeding_date DATE NOT NULL,

    -- Статус
    status ENUM('planned', 'completed', 'failed', 'cancelled') NOT NULL DEFAULT 'planned',

    -- Проверки
    palpation_date DATE, -- Дата пальпации (проверка беременности)
    is_pregnant BOOLEAN,

    -- Ожидаемый окрол (автоматически: breeding_date + 31 день)
    expected_birth_date DATE,

    notes TEXT,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    FOREIGN KEY (male_id) REFERENCES rabbits(id) ON DELETE RESTRICT,
    FOREIGN KEY (female_id) REFERENCES rabbits(id) ON DELETE RESTRICT,

    INDEX idx_male_id (male_id),
    INDEX idx_female_id (female_id),
    INDEX idx_breeding_date (breeding_date),
    INDEX idx_status (status),
    INDEX idx_expected_birth_date (expected_birth_date)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

---

### 8. births
Окролы (роды)

```sql
CREATE TABLE births (
    id INT PRIMARY KEY AUTO_INCREMENT,
    breeding_id INT NOT NULL,
    mother_id INT NOT NULL,
    birth_date DATE NOT NULL,

    -- Количество крольчат
    kits_born_alive INT NOT NULL DEFAULT 0,
    kits_born_dead INT NOT NULL DEFAULT 0,
    kits_total INT GENERATED ALWAYS AS (kits_born_alive + kits_born_dead) STORED,

    -- Выживаемость
    kits_weaned INT DEFAULT 0, -- Отсажено (обычно через 28-45 дней)
    weaning_date DATE, -- Дата отсадки

    -- Осложнения
    complications TEXT,

    notes TEXT,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    FOREIGN KEY (breeding_id) REFERENCES breedings(id) ON DELETE CASCADE,
    FOREIGN KEY (mother_id) REFERENCES rabbits(id) ON DELETE RESTRICT,

    INDEX idx_breeding_id (breeding_id),
    INDEX idx_mother_id (mother_id),
    INDEX idx_birth_date (birth_date)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

---

### 9. vaccinations
Прививки

```sql
CREATE TABLE vaccinations (
    id INT PRIMARY KEY AUTO_INCREMENT,
    rabbit_id INT NOT NULL,
    vaccine_name VARCHAR(255) NOT NULL, -- Название вакцины
    vaccine_type ENUM('vhd', 'myxomatosis', 'pasteurellosis', 'other') NOT NULL,
    vaccination_date DATE NOT NULL,
    next_vaccination_date DATE, -- Следующая прививка
    batch_number VARCHAR(100), -- Номер партии вакцины
    veterinarian VARCHAR(255), -- Ветеринар
    notes TEXT,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    FOREIGN KEY (rabbit_id) REFERENCES rabbits(id) ON DELETE CASCADE,

    INDEX idx_rabbit_id (rabbit_id),
    INDEX idx_vaccine_type (vaccine_type),
    INDEX idx_vaccination_date (vaccination_date),
    INDEX idx_next_vaccination_date (next_vaccination_date)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

**Типичные вакцины:**
- ВГБК (Вирусная геморрагическая болезнь кроликов)
- Миксоматоз
- Пастереллез
- Комплексная (ВГБК + Миксоматоз)

---

### 10. medical_records
Медицинские записи (болезни, лечение)

```sql
CREATE TABLE medical_records (
    id INT PRIMARY KEY AUTO_INCREMENT,
    rabbit_id INT NOT NULL,

    -- Диагноз
    symptoms TEXT NOT NULL,
    diagnosis VARCHAR(255),

    -- Лечение
    treatment TEXT, -- Описание лечения
    medication VARCHAR(255), -- Препараты
    dosage VARCHAR(100), -- Дозировка

    -- Даты
    started_at DATE NOT NULL,
    ended_at DATE,

    -- Результат
    outcome ENUM('recovered', 'ongoing', 'died', 'euthanized'),

    -- Расходы
    cost DECIMAL(10, 2), -- Стоимость лечения

    veterinarian VARCHAR(255),
    notes TEXT,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    FOREIGN KEY (rabbit_id) REFERENCES rabbits(id) ON DELETE CASCADE,

    INDEX idx_rabbit_id (rabbit_id),
    INDEX idx_started_at (started_at),
    INDEX idx_outcome (outcome)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

---

### 11. feeds
Корма (справочник)

```sql
CREATE TABLE feeds (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    type ENUM('pellets', 'hay', 'vegetables', 'grain', 'supplements', 'other') NOT NULL,
    brand VARCHAR(255),
    unit ENUM('kg', 'liter', 'piece') NOT NULL DEFAULT 'kg',

    -- Склад
    current_stock DECIMAL(10, 2) NOT NULL DEFAULT 0,
    min_stock DECIMAL(10, 2) NOT NULL DEFAULT 0, -- Минимальный запас

    -- Стоимость
    cost_per_unit DECIMAL(10, 2), -- Цена за единицу

    notes TEXT,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    INDEX idx_name (name),
    INDEX idx_type (type)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

---

### 12. feeding_records
Записи о кормлении

```sql
CREATE TABLE feeding_records (
    id INT PRIMARY KEY AUTO_INCREMENT,
    rabbit_id INT,
    feed_id INT NOT NULL,
    cage_id INT, -- Если групповое кормление

    quantity DECIMAL(10, 2) NOT NULL, -- Количество
    fed_at DATETIME NOT NULL,
    fed_by INT, -- Кто кормил (user_id)

    notes TEXT,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (rabbit_id) REFERENCES rabbits(id) ON DELETE CASCADE,
    FOREIGN KEY (feed_id) REFERENCES feeds(id) ON DELETE RESTRICT,
    FOREIGN KEY (cage_id) REFERENCES cages(id) ON DELETE SET NULL,
    FOREIGN KEY (fed_by) REFERENCES users(id) ON DELETE SET NULL,

    INDEX idx_rabbit_id (rabbit_id),
    INDEX idx_feed_id (feed_id),
    INDEX idx_cage_id (cage_id),
    INDEX idx_fed_at (fed_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

---

### 13. transactions
Финансовые операции (доходы и расходы)

```sql
CREATE TABLE transactions (
    id INT PRIMARY KEY AUTO_INCREMENT,
    type ENUM('income', 'expense') NOT NULL,

    -- Категории
    category ENUM(
        -- Доходы
        'sale_rabbit', 'sale_meat', 'sale_fur', 'breeding_fee',
        -- Расходы
        'feed', 'veterinary', 'equipment', 'utilities', 'other'
    ) NOT NULL,

    amount DECIMAL(10, 2) NOT NULL,
    transaction_date DATE NOT NULL,

    -- Связи
    rabbit_id INT, -- Если связано с кроликом

    description TEXT,
    receipt_url VARCHAR(500), -- Фото чека

    created_by INT,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    FOREIGN KEY (rabbit_id) REFERENCES rabbits(id) ON DELETE SET NULL,
    FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE SET NULL,

    INDEX idx_type (type),
    INDEX idx_category (category),
    INDEX idx_transaction_date (transaction_date),
    INDEX idx_rabbit_id (rabbit_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

---

### 14. tasks
Задачи и напоминания

```sql
CREATE TABLE tasks (
    id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(255) NOT NULL,
    description TEXT,

    -- Тип задачи
    type ENUM('feeding', 'cleaning', 'vaccination', 'checkup', 'breeding', 'other') NOT NULL,

    -- Статус
    status ENUM('pending', 'in_progress', 'completed', 'cancelled') NOT NULL DEFAULT 'pending',
    priority ENUM('low', 'medium', 'high', 'urgent') NOT NULL DEFAULT 'medium',

    -- Даты
    due_date DATETIME NOT NULL,
    completed_at DATETIME,

    -- Связи
    rabbit_id INT,
    cage_id INT,
    assigned_to INT, -- Кому назначена
    created_by INT,

    -- Повторяющаяся задача
    is_recurring BOOLEAN NOT NULL DEFAULT FALSE,
    recurrence_rule VARCHAR(255), -- Правило повторения (daily, weekly, etc.)

    -- Напоминание
    reminder_before INT, -- Напомнить за X минут

    notes TEXT,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    FOREIGN KEY (rabbit_id) REFERENCES rabbits(id) ON DELETE CASCADE,
    FOREIGN KEY (cage_id) REFERENCES cages(id) ON DELETE CASCADE,
    FOREIGN KEY (assigned_to) REFERENCES users(id) ON DELETE SET NULL,
    FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE SET NULL,

    INDEX idx_status (status),
    INDEX idx_due_date (due_date),
    INDEX idx_assigned_to (assigned_to),
    INDEX idx_rabbit_id (rabbit_id),
    INDEX idx_cage_id (cage_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

---

### 15. photos
Фотографии (галерея)

```sql
CREATE TABLE photos (
    id INT PRIMARY KEY AUTO_INCREMENT,
    rabbit_id INT NOT NULL,
    url VARCHAR(500) NOT NULL,
    caption TEXT,
    taken_at DATETIME,
    uploaded_by INT,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (rabbit_id) REFERENCES rabbits(id) ON DELETE CASCADE,
    FOREIGN KEY (uploaded_by) REFERENCES users(id) ON DELETE SET NULL,

    INDEX idx_rabbit_id (rabbit_id),
    INDEX idx_taken_at (taken_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

---

### 16. notes
Заметки (общие заметки к кроликам, клеткам и т.д.)

```sql
CREATE TABLE notes (
    id INT PRIMARY KEY AUTO_INCREMENT,
    rabbit_id INT,
    cage_id INT,
    content TEXT NOT NULL,
    created_by INT,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    FOREIGN KEY (rabbit_id) REFERENCES rabbits(id) ON DELETE CASCADE,
    FOREIGN KEY (cage_id) REFERENCES cages(id) ON DELETE CASCADE,
    FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE SET NULL,

    INDEX idx_rabbit_id (rabbit_id),
    INDEX idx_cage_id (cage_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

---

## 📈 Common Queries

### 1. Get all rabbits with their breed and cage info
```sql
SELECT
    r.*,
    b.name AS breed_name,
    c.number AS cage_number,
    f.name AS father_name,
    m.name AS mother_name
FROM rabbits r
LEFT JOIN breeds b ON r.breed_id = b.id
LEFT JOIN cages c ON r.cage_id = c.id
LEFT JOIN rabbits f ON r.father_id = f.id
LEFT JOIN rabbits m ON r.mother_id = m.id
WHERE r.status IN ('healthy', 'pregnant', 'sick')
ORDER BY r.birth_date DESC;
```

### 2. Upcoming tasks
```sql
SELECT
    t.*,
    r.name AS rabbit_name,
    c.number AS cage_number,
    u.full_name AS assigned_to_name
FROM tasks t
LEFT JOIN rabbits r ON t.rabbit_id = r.id
LEFT JOIN cages c ON t.cage_id = c.id
LEFT JOIN users u ON t.assigned_to = u.id
WHERE t.status = 'pending'
    AND t.due_date BETWEEN NOW() AND DATE_ADD(NOW(), INTERVAL 7 DAY)
ORDER BY t.due_date ASC;
```

### 3. Pregnant rabbits and expected births
```sql
SELECT
    r.name,
    r.tag_id,
    b.breeding_date,
    b.expected_birth_date,
    DATEDIFF(b.expected_birth_date, CURDATE()) AS days_until_birth
FROM rabbits r
JOIN breedings b ON r.id = b.female_id
WHERE r.status = 'pregnant'
    AND b.status = 'completed'
    AND b.expected_birth_date >= CURDATE()
ORDER BY b.expected_birth_date ASC;
```

### 4. Vaccination schedule (upcoming)
```sql
SELECT
    r.name,
    r.tag_id,
    v.vaccine_name,
    v.vaccine_type,
    v.next_vaccination_date
FROM vaccinations v
JOIN rabbits r ON v.rabbit_id = r.id
WHERE v.next_vaccination_date BETWEEN CURDATE() AND DATE_ADD(CURDATE(), INTERVAL 30 DAY)
    AND r.status IN ('healthy', 'pregnant')
ORDER BY v.next_vaccination_date ASC;
```

### 5. Financial summary
```sql
SELECT
    type,
    category,
    SUM(amount) AS total
FROM transactions
WHERE transaction_date BETWEEN '2025-01-01' AND '2025-12-31'
GROUP BY type, category
ORDER BY type, total DESC;
```

### 6. Rabbit pedigree (3 generations)
```sql
-- Recursive CTE for pedigree
WITH RECURSIVE pedigree AS (
    -- Base: target rabbit
    SELECT
        id, name, tag_id, father_id, mother_id, 1 AS generation
    FROM rabbits
    WHERE id = ? -- target rabbit_id

    UNION ALL

    -- Recursive: parents
    SELECT
        r.id, r.name, r.tag_id, r.father_id, r.mother_id, p.generation + 1
    FROM rabbits r
    JOIN pedigree p ON r.id = p.father_id OR r.id = p.mother_id
    WHERE p.generation < 3
)
SELECT * FROM pedigree ORDER BY generation;
```

### 7. Low stock feeds alert
```sql
SELECT
    name,
    type,
    current_stock,
    min_stock,
    unit,
    (min_stock - current_stock) AS deficit
FROM feeds
WHERE current_stock < min_stock
ORDER BY deficit DESC;
```

### 8. Breeding performance by doe (female)
```sql
SELECT
    r.name AS doe_name,
    r.tag_id,
    COUNT(DISTINCT bi.id) AS total_litters,
    SUM(bi.kits_born_alive) AS total_kits_born,
    AVG(bi.kits_born_alive) AS avg_kits_per_litter,
    SUM(bi.kits_weaned) AS total_kits_weaned,
    ROUND(SUM(bi.kits_weaned) / SUM(bi.kits_born_alive) * 100, 2) AS survival_rate
FROM rabbits r
JOIN births bi ON r.id = bi.mother_id
WHERE r.sex = 'female'
GROUP BY r.id
HAVING total_litters > 0
ORDER BY total_kits_born DESC;
```

---

## 🔄 Triggers

### Auto-update rabbit status on birth
```sql
DELIMITER $$

CREATE TRIGGER after_birth_insert
AFTER INSERT ON births
FOR EACH ROW
BEGIN
    UPDATE rabbits
    SET status = 'healthy'
    WHERE id = NEW.mother_id AND status = 'pregnant';
END$$

DELIMITER ;
```

### Auto-calculate expected birth date
```sql
DELIMITER $$

CREATE TRIGGER before_breeding_insert
BEFORE INSERT ON breedings
FOR EACH ROW
BEGIN
    IF NEW.breeding_date IS NOT NULL THEN
        SET NEW.expected_birth_date = DATE_ADD(NEW.breeding_date, INTERVAL 31 DAY);
    END IF;
END$$

DELIMITER ;
```

### Update feed stock on feeding
```sql
DELIMITER $$

CREATE TRIGGER after_feeding_insert
AFTER INSERT ON feeding_records
FOR EACH ROW
BEGIN
    UPDATE feeds
    SET current_stock = current_stock - NEW.quantity
    WHERE id = NEW.feed_id;
END$$

DELIMITER ;
```

---

## 📊 Views (Optional)

### Active rabbits summary
```sql
CREATE VIEW v_active_rabbits AS
SELECT
    r.id,
    r.tag_id,
    r.name,
    r.sex,
    r.birth_date,
    TIMESTAMPDIFF(MONTH, r.birth_date, CURDATE()) AS age_months,
    b.name AS breed_name,
    c.number AS cage_number,
    r.current_weight,
    r.status,
    r.purpose
FROM rabbits r
LEFT JOIN breeds b ON r.breed_id = b.id
LEFT JOIN cages c ON r.cage_id = c.id
WHERE r.status NOT IN ('sold', 'dead');
```

---

## 🗃️ Indexes Summary

**Critical indexes** (already included above):
- Primary keys on all tables
- Foreign keys
- Status fields (for filtering)
- Date fields (for sorting/filtering)
- Composite indexes for common queries

**Performance tip**: Monitor slow queries and add indexes as needed.

---

## 💾 Backup Strategy

```bash
# Daily backup
mysqldump -u root -p rabbitfarm > backup_$(date +%Y%m%d).sql

# Restore
mysql -u root -p rabbitfarm < backup_20251015.sql
```

---

## 📝 Seed Data

Initial data to populate:

1. **Breeds**: 5-10 common rabbit breeds
2. **User**: 1 default admin user
3. **Cages**: 10 example cages
4. **Feeds**: Common feed types

---

**Database Version**: 1.0
**Last Updated**: 2025-10-15
