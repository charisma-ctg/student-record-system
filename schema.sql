-- Run once in phpMyAdmin / MySQL.
CREATE DATABASE IF NOT EXISTS student_db
  CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE student_db;

CREATE TABLE IF NOT EXISTS students (
    id          INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    student_id  VARCHAR(20)  NOT NULL,          -- numbers + dashes, e.g. 2024-0123
    name        VARCHAR(100) NOT NULL,
    program     VARCHAR(100) NOT NULL,
    created_at  DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at  DATETIME     NULL ON UPDATE CURRENT_TIMESTAMP,
    deleted_at  DATETIME     NULL DEFAULT NULL, -- NULL = active, value = archived
    UNIQUE KEY uq_student_id (student_id),
    KEY idx_deleted_at (deleted_at)
) ENGINE=InnoDB;

-- If you ALREADY have the students table (this fixes Save/Update failing
-- when the ID has a dash): run these one at a time in phpMyAdmin > SQL.
-- ALTER TABLE students MODIFY student_id VARCHAR(20) NOT NULL;
-- ALTER TABLE students ADD UNIQUE KEY uq_student_id (student_id);   -- skip if it already exists
-- (If the UNIQUE step errors, you have duplicate IDs. Find them with:
--  SELECT student_id, COUNT(*) FROM students GROUP BY student_id HAVING COUNT(*) > 1; )
--
-- Older version of the steps:
-- ALTER TABLE students
--   MODIFY student_id VARCHAR(20) NOT NULL,
--   MODIFY name VARCHAR(100) NOT NULL,
--   MODIFY program VARCHAR(100) NOT NULL,
--   ADD COLUMN IF NOT EXISTS created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
--   ADD COLUMN IF NOT EXISTS updated_at DATETIME NULL ON UPDATE CURRENT_TIMESTAMP,
--   ADD COLUMN IF NOT EXISTS deleted_at DATETIME NULL DEFAULT NULL,
--   ADD UNIQUE KEY uq_student_id (student_id);
