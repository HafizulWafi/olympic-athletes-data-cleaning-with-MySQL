SELECT 'athlete_id', 'Used name', 'Born', 'Died', 'Measurements', 'NOC', 'name', 'height_cm', 'weight_kg', 'born_date', 'died_date', 'born_place', 'born_country'
UNION ALL
SELECT 
    IFNULL(athlete_id, '') AS athlete_id, 
    IFNULL(`Used name`, '') AS `Used name`, 
    IFNULL(Born, '') AS Born, 
    IFNULL(Died, '') AS Died, 
    IFNULL(Measurements, '') AS Measurements, 
    IFNULL(NOC, '') AS NOC, 
    IFNULL(name, '') AS name, 
    IFNULL(height_cm, '') AS height_cm, 
    IFNULL(weight_kg, '') AS weight_kg, 
    IFNULL(born_date, '') AS born_date, 
    IFNULL(died_date, '') AS died_date, 
    IFNULL(born_place, '') AS born_place, 
    IFNULL(born_country, '') AS born_country
INTO OUTFILE 'C://ProgramData//MySQL//MySQL Server 8.0//Uploads//bios_cleaned.csv'
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
FROM athletes;

