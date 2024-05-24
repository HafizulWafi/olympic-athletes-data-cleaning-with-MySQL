-- Update born_place and born_country columns based on the 'Born' column
UPDATE athletes
SET 
    born_place = 	CASE
						WHEN Born LIKE '% in %' THEN TRIM(SUBSTRING_INDEX(Born, ' in ', -1))
						ELSE NULL
					END
WHERE 
    Born NOT LIKE '%[0-9][0-9] [A-Za-z]%' OR 
    Born LIKE '%(%(%';

UPDATE athletes
SET 
    born_country = CASE
						WHEN Born LIKE '%(%)' THEN 
							TRIM(BOTH ')' FROM SUBSTRING_INDEX(SUBSTRING_INDEX(Born, '(', -1), ')', 1))
						ELSE NULL
					END
WHERE 
    Born NOT LIKE '%[0-9][0-9] [A-Za-z]%' OR 
    Born LIKE '%(%(%';

SELECT athlete_id, Born, born_place, born_country FROM athletes;