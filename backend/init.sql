-- RabbitFarm Database Initialization Script

-- Create database
CREATE DATABASE IF NOT EXISTS rabbitfarm CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Create user (if doesn't exist)
CREATE USER IF NOT EXISTS 'rabbitfarm_user'@'localhost' IDENTIFIED BY 'RabbitFarm2024!';

-- Grant privileges
GRANT ALL PRIVILEGES ON rabbitfarm.* TO 'rabbitfarm_user'@'localhost';
FLUSH PRIVILEGES;

-- Verify
SELECT 'Database rabbitfarm created successfully!' AS status;
SHOW DATABASES LIKE 'rabbitfarm';
