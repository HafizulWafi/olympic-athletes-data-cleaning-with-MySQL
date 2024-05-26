# olympic-athletes-data-cleaning-with-MySQL

This project involves cleaning and preparing a raw dataset of Olympic Athletes for analysis using SQL. The dataset contains various inconsistencies and missing values that need to be addressed.

## Table of Contents

- [Project Overview](#project-overview)
- [Dataset](#dataset)
- [Setup](#setup)
- [Data Cleaning Steps](#data-cleaning-steps)
  - [Step 1: Removing Unnecessary Columns](#step-1-removing-unnecessary-columns)
  - [Step 2: Removing Symbol in `Used name` column](#step-2-removing-symbol-in-Used-name-column)
  - [Step 3: Splitting `Measurements` into different columns](#step-3-splitting-measurements-into-different-columns)
  - [Step 4: Extracting Date info from `Born` column](#step-4-extracting-date-info-from-Born-column)
  - [Step 5: Extracting Date info from `Died` column](#step-4-extracting-date-info-from-Died-column)
  - [Step 6: Extracting place and country infos from `Died` column](#step-4-extracting-place-and-country-infos-from-Died-column)
  - [Step 7: Creating `cleaned_athletes` table](#step-4-creating-cleaned_athletes-table)
- [Usage](#usage)
  - [Exporting Cleaned Data](#exporting-cleaned-data)
  - [Python Integration](#python-integration)

## Project Overview

The goal of this project is to clean and prepare the provided dataset for subsequent analysis. The data contains issues such as duplicates, missing values, inconsistent formats, and incorrect data types that need to be addressed to ensure data quality. 

## Dataset

The dataset used in this project is provided by @KeithGalli on Youtube who scraped a website to get the dataset. You can extract the zip file in the repo to get the dataset.

## Setup

For the purpose of importing the dataset into database, we will be using Python libraries to achieve that.

1. Clone the repository:

    ```bash
    git clone https://github.com/HafizulWafi/olympic-athletes-data-cleaning-with-MySQL.git
    ```

2. Installed the required Python libraries:

   ```bash
   pip install pandas numpy sqlalchemy
   ```
   
4. Create a new database for the project in MySQL:

    ```sql
    CREATE DATABASE athletes_db;
    ```

5. Switch to the newly created database:

    ```sql
    USE athletes_db;
    ```
    
6. Run the Python script to import the dataset into the MySQL database:

    ```python
    import pandas as pd
    import numpy as np
    from sqlalchemy import create_engine

    # Database connection details
    user = 'your_username'
    password = 'your_password'
    host = 'localhost'
    database = 'athletes_db'

    # Create a connection to your MySQL database
    engine = create_engine(f'mysql+mysqlconnector://{user}:{password}@{host}/{database}')
    
    # Read CSV into DataFrame
    df = pd.read_csv('bios.csv')

    # Ensure empty values are translated correctly as NULL values in MySQL
    df = df.replace({np.nan: None})
    
    # Convert the DataFrame to a list of dictionaries
    records = df.to_dict('records')
    
    # Insert the data into a MySQL table
    df.to_sql('athletes', con=engine, if_exists='append', index=False)
    ```

## Data Cleaning Steps

### Step 1: Removing Unnecessary Columns

Identify and remove unnecessary columns that are not relevant for analysis.

```sql
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
```

### Step 2: Removing Symbol in `Used name` column

Create a new column. Remove '•' symbol in `Used name` and update it into the new column.

```sql
ALTER TABLE athletes
ADD COLUMN name VARCHAR(100);

UPDATE athletes
SET name = REPLACE(`Used name`, '•', ' ');
```

### Step 3: Splitting `Measurements` into different columns

Create `height_cm` and `weight_kg` columns. Extract height and weight values and update it into their respective columns.

```sql
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
                        WHEN INSTR(Measurements, '/') > 0 THEN
                            TRIM(SUBSTRING(Measurements, INSTR(Measurements,'/') + 2, INSTR(Measurements,' kg') - INSTR(Measurements,'/ ') - 2))
                        ELSE TRIM(SUBSTRING(Measurements, 1, INSTR(Measurements, ' kg') - 1))
                    END
                ELSE NULL
            END;
```

### Step 4: Extracting Date info from `Born` column

Create a new column to store the date info. Use REGEXP to filter non-date info and to handle different date format.

```sql
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
                            -- Year-only pattern (e.g., "1876 in Natal, KwaZulu-Natal (RSA)")
                            WHEN Born REGEXP '^[0-9]{4}' THEN
                                CASE
                                    WHEN INSTR(Born, ' in ') > 0 THEN SUBSTRING(Born, 1, INSTR(Born, ' in') - 1)
                                    ELSE Born
                                END
                            ELSE NULL
                        END
                    ELSE NULL
                END;
```

### Step 5: Extracting Date info from `Died` column

Create a new column to store the date info. Use REGEXP to filter non-date info and to handle different date format.

```sql
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
```

### Step 6: Extracting place and country infos from `Died` column

Create `born_place` and `born_country` columns. Extract place and country infos and update it into their respective columns.

```sql
ALTER TABLE athletes
ADD COLUMN born_place VARCHAR(100);
ADD COLUMN born_country VARCHAR(100);

UPDATE athletes
SET born_place =    CASE
                        WHEN Born LIKE '% in %' THEN TRIM(SUBSTRING_INDEX(Born, ' in ', -1))
                        ELSE NULL
                    END,
    born_country =  CASE
                        WHEN Born LIKE '%(%)' THEN 
                            TRIM(BOTH ')' FROM SUBSTRING_INDEX(SUBSTRING_INDEX(Born, '(', -1), ')', 1))
                        ELSE NULL
                    END
WHERE 
    Born NOT LIKE '%[0-9][0-9] [A-Za-z]%' OR 
    Born LIKE '%(%(%';
```

### Step 7: Creating `cleaned_athletes` table

Create a new table to store the cleaned data.

```sql
CREATE TABLE cleaned_athletes AS
SELECT * FROM athletes;
```

## Usage

Once the data is cleaned and stored in the `cleaned_athletes` table, it can be used for various types of analysis. 

To retrieve all records from the cleaned data table:

```sql
SELECT *
FROM raw_data_cleaned;
```

### Exporting Cleaned Data

You may also want to export the cleaned data for use in other tools or for analysis. Make sure to adjust the /path/to/bios_cleaned.csv to a valid path on your system where you have write permissions.

```sql
SELECT 'Used name', 'Born', 'Died', 'NOC', 'athlete_id', 'Measurements', 'name', 'height_cm', 'weight_kg', 'born_date', 'died_date', 'born_place', 'born_country'
UNION ALL
SELECT 
    IFNULL(`Used name`, '') AS `Used name`, 
    IFNULL(Born, '') AS Born, 
    IFNULL(Died, '') AS Died, 
    IFNULL(NOC, '') AS NOC,
    IFNULL(athlete_id, '') AS athlete_id,
    IFNULL(Measurements, '') AS Measurements,  
    IFNULL(name, '') AS name, 
    IFNULL(height_cm, '') AS height_cm, 
    IFNULL(weight_kg, '') AS weight_kg, 
    IFNULL(born_date, '') AS born_date, 
    IFNULL(died_date, '') AS died_date, 
    IFNULL(born_place, '') AS born_place, 
    IFNULL(born_country, '') AS born_country
INTO OUTFILE '/path/to/bios_cleaned.csv'
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
FROM athletes;
```

### Python Integration

You can also choose to access and analyze the cleaned data using Python. 

```python
import pandas as pd
from sqlalchemy import create_engine

# Database connection details
user = 'your_username'
password = 'your_password'
host = 'localhost'
database = 'athletes_db'

engine = create_engine(f'mysql+mysqlconnector://{user}:{password}@{host}/{database}')

# Query the cleaned data
query = 'SELECT * FROM athletes'
df = pd.read_sql(query, engine)

# Display the first few rows of the DataFrame
print(df.head())
```
