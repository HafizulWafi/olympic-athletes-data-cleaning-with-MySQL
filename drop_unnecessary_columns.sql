-- columns to drop Roles, Sex, `Full name`, Affiliations, Nick/petnames, `Titles(s)`, `Other names`, Nationality, `Original name`, `Name order` 
-- drop unnecessary column
ALTER TABLE athletes
DROP COLUMN Roles,
DROP COLUMN Sex,
DROP COLUMN `Full name`,
DROP COLUMN Affiliations,
DROP COLUMN `Nick/petnames`,
DROP COLUMN `Title(s)`,
DROP COLUMN `Other names`,
DROP COLUMN Nationality,
DROP COLUMN `Original name`,
DROP COLUMN `Name order`;