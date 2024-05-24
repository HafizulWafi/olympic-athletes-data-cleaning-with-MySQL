ALTER TABLE athletes
ADD COLUMN height_cm VARCHAR(10),
ADD COLUMN weight_kg VARCHAR(10);

UPDATE athletes
SET height_cm = CASE
					WHEN Measurements LIKE '% cm%' THEN SUBSTRING(Measurements, 1, INSTR(Measurements, ' cm') - 1)
                    ELSE NULL 
				END,
	weight_kg = CASE
					WHEN Measurements LIKE '% kg%' THEN 
                    CASE 
                        WHEN INSTR(Measurements, '/') > 0 THEN TRIM(SUBSTRING(Measurements, INSTR(Measurements, '/') + 2, INSTR(Measurements, ' kg') - INSTR(Measurements, '/ ') - 2))
                        ELSE TRIM(SUBSTRING(Measurements, 1, INSTR(Measurements, ' kg') - 1))
                    END
					ELSE NULL
				 END;

-- Finding rows with height but no weight
SELECT * FROM athletes

WHERE height_cm IS NULL AND weight_kg IS NOT NULL;

-- Check all edge cases
SELECT Measurements,height_cm,weight_kg FROM athletes
WHERE athlete_id = 88;

SELECT Measurements,height_cm,weight_kg FROM athletes
WHERE athlete_id = 243;

SELECT Measurements,height_cm,weight_kg FROM athletes
WHERE athlete_id = 166;

SELECT Measurements,height_cm,weight_kg FROM athletes
WHERE athlete_id = 433;

SELECT Measurements,height_cm,weight_kg FROM athletes
WHERE athlete_id = 37416;

SELECT Measurements,height_cm,weight_kg FROM athletes
WHERE athlete_id = 301;
