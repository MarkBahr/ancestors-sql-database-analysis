/*
    Author: Mark Bahr
    Project: Family History PostgreSQL Database
    Tasks: Use PostgreSQL to 
        - create new columns for
            - the date columns, including day, month and year.
            - the place columns, including city, state & country.
        - Fix any format issues caused by placing the data in new columns
*/

--------------------------------------------------------------------
/*	                *** NEW DATE COLUMNS ***                      */
--------------------------------------------------------------------
-- Make sure that EXTRACT() selects the values in the way that we want. 
SELECT EXTRACT('YEAR' FROM birth_date)::INT AS birth_year,
    EXTRACT('MONTH' FROM birth_date)::INT AS birth_month,
    EXTRACT('DAY' FROM birth_date)::INT AS birth_day
FROM ancestors
LIMIT 10;

-- Add day, months, and year columns for birhts, marriages and deaths
ALTER TABLE ancestors
    ADD COLUMN birth_day INT CHECK (birth_day >= 1 AND birth_day < 32),
    ADD COLUMN birth_month INT CHECK (birth_month >= 1 AND birth_month < 13),
    ADD COLUMN birth_year INT,
    ADD COLUMN marriage_day INT CHECK (marriage_day >= 1 AND marriage_day < 32),
    ADD COLUMN marriage_month INT CHECK (marriage_month >= 1 AND marriage_month < 13),
    ADD COLUMN marriage_year INT,
    ADD COLUMN death_day INT CHECK (death_day >= 1 AND death_day < 32),
    ADD COLUMN death_month INT CHECK (death_month >= 1 AND death_month < 13),
    ADD COLUMN death_year INT;

-- Update those new columns with values from original date columns
UPDATE ancestors
SET birth_day = (EXTRACT('DAY' FROM birth_date)::INT),
    birth_month = (EXTRACT('MONTH' FROM birth_date)::INT),
    birth_year = (EXTRACT('YEAR' FROM birth_date)::INT),
    marriage_day = (EXTRACT('DAY' FROM marriage_date)::INT),
    marriage_month = (EXTRACT('MONTH' FROM marriage_date)::INT),
    marriage_year = (EXTRACT('YEAR' FROM marriage_date)::INT),
    death_day = (EXTRACT('DAY' FROM death_date)::INT),
    death_month = (EXTRACT('MONTH' FROM death_date)::INT),
    death_year = (EXTRACT('YEAR' FROM death_date)::INT);

-- Double check that the new colunn values match the original dates
SELECT birth_date, birth_year, birth_month, birth_day
FROM ancestors
LIMIT 20;

SELECT marriage_date, marriage_year, marriage_month, marriage_day
FROM ancestors
LIMIT 20;

SELECT death_date, death_year, death_month, death_day
FROM ancestors
LIMIT 20;


--------------------------------------------------------------------
/*	                *** NEW PLACE COLUMNS ***                      */
--------------------------------------------------------------------
-- Select  City, state, country using split_part. And it works!
SELECT SPLIT_PART(birth_place, ',', 1) City,
    SPLIT_PART(birth_place, ',', 2) State,
    SPLIT_PART(birth_place, ',', 3) Contry
from ancestors; 

-- Add new columns for locations
ALTER TABLE ancestors
	ADD COLUMN birth_city VARCHAR(100),
    ADD COLUMN birth_state VARCHAR(80),
    ADD COLUMN birth_country VARCHAR(70),
    ADD COLUMN marriage_city VARCHAR(100),
    ADD COLUMN marriage_state VARCHAR(80),
    ADD COLUMN marriage_country VARCHAR(70),
    ADD COLUMN death_city VARCHAR(100),
    ADD COLUMN death_state VARCHAR(80),
    ADD COLUMN death_country VARCHAR(70);

--- Update those new columns with values from original place columns 
UPDATE ancestors
    SET birth_city = TRIM(SPLIT_PART(birth_place, ',', 1)),
    birth_state = TRIM(SPLIT_PART(birth_place, ',', 2)),
    birth_country = TRIM(SPLIT_PART(birth_place, ',', 3)),
    marriage_city = TRIM(SPLIT_PART(marriage_place, ',', 1)),
    marriage_state = TRIM(SPLIT_PART(marriage_place, ',', 2)),
    marriage_country = TRIM(SPLIT_PART(marriage_place, ',', 3)),
    death_city = TRIM(SPLIT_PART(death_place, ',', 1)),
    death_state = TRIM(SPLIT_PART(death_place, ',', 2)),
    death_country = TRIM(SPLIT_PART(death_place, ',', 3));

-- Take a look to check that the values om the new place columns match the values in the original place columnns
SELECT birth_place, birth_city, birth_state, birth_country
from ancestors
limit 10;

SELECT marriage_place, marriage_city, marriage_state, marriage_country
from ancestors
limit 10;

SELECT death_place, death_city, death_state, death_country
from ancestors
limit 10;


--------------------------------------------------------------------
/*	                    DATA CLEANING                           */
--------------------------------------------------------------------
-- There are some nulls because someont entered "Bern Switzerland" without a comma
-- Find where these are by checking for unique values in all 3 state columns
SELECT DISTINCT(birth_state)
FROM ancestors
ORDER BY 1;

SELECT DISTINCT(marriage_state)
FROM ancestors
ORDER BY 1;

SELECT DISTINCT(death_state)
FROM ancestors
ORDER BY 1;

-- We found two versions or spellings of several states. So we'll fix that so that all spellings are the same & correct.
UPDATE ancestors
    SET birth_state = 'Bern',
        birth_country = 'Switzerland'
    WHERE birth_state = 'Bern Switzerland';

UPDATE ancestors
    SET death_state = 'Bern',
        death_country = 'Switzerland'
    WHERE death_state = 'Bern Switzerland';

UPDATE ancestors
    SET birth_state = 'Cambridgeshire'
    WHERE birth_state = 'Cabridgeshire';

UPDATE ancestors
    SET birth_state = 'Hertfordshire'
    WHERE birth_state = 'Herfordshire';

UPDATE ancestors
    SET death_state = 'Hertfordshire'
    WHERE death_state = 'Herfordshire';

UPDATE ancestors
    SET death_state = 'Bern'
    WHERE death_state = 'Berne';

-- Now, check for distinct values in the city and country columns
SELECT DISTINCT(birth_city)
FROM ancestors
ORDER BY 1;

SELECT DISTINCT(marriage_city)
FROM ancestors
ORDER BY 1;

SELECT DISTINCT(death_city)
FROM ancestors
ORDER BY 1;

SELECT DISTINCT(birth_country)
FROM ancestors
ORDER BY 1;

SELECT DISTINCT(marriage_country)
FROM ancestors
ORDER BY 1;

SELECT DISTINCT(death_country)
FROM ancestors
ORDER BY 1;


-- birth_city has baligen and bolligen, it should be 'Bolligen'
-- There are different versions of several countries. Let's make them match.
UPDATE ancestors
    SET birth_city = 'Bolligen'
    WHERE birth_city = 'Baligen';

UPDATE ancestors
    SET birth_country = 'United States of America'
    WHERE birth_country IN ('United States', 'USA');

UPDATE ancestors
    SET marriage_country = 'United States of America'
    WHERE marriage_country IN ('United States', 'USA');

UPDATE ancestors
    SET death_country = 'United States of America'
    WHERE death_country = 'United States';

UPDATE ancestors
    SET marriage_country = 'England'
    WHERE marriage_country ILIKE 'Eng%';

UPDATE ancestors
    SET marriage_country = 'Switzerland'
    WHERE marriage_country ILIKE 'switz%';

UPDATE ancestors
    SET death_country = 'Scotland'
    WHERE death_country ILIKE 'scotl%';

UPDATE ancestors
    SET death_country = 'Scotland'
    WHERE death_country ILIKE '%otland';


-- drop origincal place and date columns
ALTER TABLE ancestors
    DROP COLUMN birth_place,
    DROP COLUMN marriage_place,
    DROP COLUMN death_place,
    DROP COLUMN birth_date,
    DROP COLUMN marriage_date,
    DROP COLUMN death_date;