-- Date info is only stored as STR
ALTER TABLE athletes
ADD COLUMN died_date VARCHAR(50);

UPDATE athletes
SET died_date = CASE
					WHEN Died IS NOT NULL THEN
						CASE
                           -- Full date pattern (e.g., "12 December 1886 in Bordeaux, Gironde (FRA)")
							WHEN Died REGEXP '^[0-9]{1,2} [A-Za-z]+ [0-9]{4}' THEN
								CASE 
									WHEN Died LIKE '% in %' THEN SUBSTRING(Died, 1, INSTR(Died, ' in') - 1)
									ELSE Died
								END
							-- Year only pattern (e.g., "1876 in Natal, KwaZulu-Natal (RSA)")
                            WHEN Died REGEXP '^[0-9]{4}' THEN
								CASE
									WHEN instr(Died, ' in ') > 0 THEN SUBSTRING(Died, 1, INSTR(Died, ' in') - 1)
                                    ELSE Died
                                END
							ELSE NULL
						END
					ELSE NULL
				END;

SELECT Died, athlete_id, died_date FROM athletes;
SELECT * FROM athletes; 