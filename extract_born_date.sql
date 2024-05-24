-- Date info is only stored as STR
ALTER TABLE athletes
ADD COLUMN born_date VARCHAR(50);

UPDATE athletes
SET born_date = CASE
					WHEN Born IS NOT NULL THEN
						CASE
                           -- Full date pattern (e.g., "12 December 1886 in Bordeaux, Gironde (FRA)")
							WHEN Born REGEXP '^[0-9]{1,2} [A-Za-z]+ [0-9]{4}' THEN
								CASE 
									WHEN Born LIKE '% in %' THEN SUBSTRING(Born, 1, INSTR(Born, ' in') - 1)
									ELSE Born
								END
							-- Year only pattern (e.g., "1876 in Natal, KwaZulu-Natal (RSA)")
                            WHEN Born REGEXP '^[0-9]{4}' THEN
								CASE
									WHEN INSTR(Born, ' in ') > 0 THEN SUBSTRING(Born, 1, INSTR(Born, ' in') - 1)
                                    ELSE Born
                                END
							ELSE NULL
						END
					ELSE NULL
				END;

SELECT Born, athlete_id, born_date FROM athletes;
SELECT * FROM athletes; 

-- edge cases
SELECT Born, athlete_id, born_date FROM athletes
WHERE athlete_id = 165;

SELECT Born, athlete_id, born_date FROM athletes
WHERE athlete_id = 18022;

SELECT Born, athlete_id, born_date FROM athletes
WHERE athlete_id = 3926;

SELECT Born, athlete_id, born_date FROM athletes
WHERE athlete_id = 92;
