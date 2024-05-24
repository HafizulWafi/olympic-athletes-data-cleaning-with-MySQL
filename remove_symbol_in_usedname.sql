ALTER TABLE athletes
ADD COLUMN name VARCHAR(100);

-- remove symbol in `Used name`
UPDATE athletes
SET name = REPLACE(`Used name`, '•', ' ');