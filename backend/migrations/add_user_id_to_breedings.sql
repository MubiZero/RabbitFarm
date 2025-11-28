-- Migration: Add user_id to breedings table
-- Date: 2025-11-26
-- Description: Add user_id column to breedings table for data isolation between users

USE rabbitfarm;

-- Add user_id column to breedings table
ALTER TABLE breedings 
ADD COLUMN user_id INT NOT NULL AFTER id;

-- Add foreign key constraint
ALTER TABLE breedings
ADD CONSTRAINT fk_breedings_user
FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE;

-- Add index for better query performance
CREATE INDEX idx_breedings_user_id ON breedings(user_id);

-- Verify the changes
DESCRIBE breedings;

SELECT 'Migration completed successfully: user_id added to breedings table' AS status;
