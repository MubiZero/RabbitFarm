-- Migration: Add user_id to cages and feeds tables
-- Date: 2025-11-28
-- Description: Add user_id column to cages and feeds tables for data isolation

USE rabbitfarm;

-- Add user_id to cages (allow NULL initially)
ALTER TABLE cages ADD COLUMN user_id INT AFTER id;

-- Update existing cages to belong to the first user (admin)
UPDATE cages SET user_id = (SELECT id FROM users ORDER BY id ASC LIMIT 1) WHERE user_id IS NULL;

-- If no users exist, we can't enforce NOT NULL yet without deleting data or adding a user. 
-- Assuming users exist or table is empty.
-- Now enforce NOT NULL
ALTER TABLE cages MODIFY COLUMN user_id INT NOT NULL;

ALTER TABLE cages
ADD CONSTRAINT fk_cages_user
FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE;

CREATE INDEX idx_cages_user_id ON cages(user_id);
-- Add unique constraint for cage number per user
-- Note: You might need to drop existing unique index on number if it exists
-- DROP INDEX number ON cages; 
ALTER TABLE cages ADD CONSTRAINT unique_user_cage_number UNIQUE (user_id, number);

-- Add user_id to feeds (allow NULL initially)
ALTER TABLE feeds ADD COLUMN user_id INT AFTER id;

-- Update existing feeds
UPDATE feeds SET user_id = (SELECT id FROM users ORDER BY id ASC LIMIT 1) WHERE user_id IS NULL;

-- Enforce NOT NULL
ALTER TABLE feeds MODIFY COLUMN user_id INT NOT NULL;

ALTER TABLE feeds
ADD CONSTRAINT fk_feeds_user
FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE;

CREATE INDEX idx_feeds_user_id ON feeds(user_id);
-- Add unique constraint for feed name per user
ALTER TABLE feeds ADD CONSTRAINT unique_user_feed_name UNIQUE (user_id, name);

-- Verify changes
DESCRIBE cages;
DESCRIBE feeds;

SELECT 'Migration completed successfully: user_id added to cages and feeds tables' AS status;
