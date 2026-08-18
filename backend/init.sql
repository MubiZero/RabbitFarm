-- RabbitFarm Database Initialization Script

-- Create database
CREATE DATABASE IF NOT EXISTS rabbitfarm CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Create user (if doesn't exist)
-- Пароль не хранится в репозитории: подставьте его при запуске, например
--   mysql -u root -p < init.sql   (предварительно задав переменную)
-- или используйте docker-compose, который берёт значение из .env.
SET @db_password = IFNULL(@db_password, '');
SET @sql = CONCAT(
  "CREATE USER IF NOT EXISTS 'rabbitfarm_user'@'localhost' IDENTIFIED BY '",
  @db_password, "'"
);
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Grant privileges
GRANT ALL PRIVILEGES ON rabbitfarm.* TO 'rabbitfarm_user'@'localhost';
FLUSH PRIVILEGES;

-- Verify
SELECT 'Database rabbitfarm created successfully!' AS status;
SHOW DATABASES LIKE 'rabbitfarm';
