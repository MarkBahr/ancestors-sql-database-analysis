/*
    Author: Mark Bahr
    Project: Family History PostgreSQL Database
    Tasks: Use PostgreSQL to clean the data, by
        - Discovering where cleaning is needed, such as duplicates and errors
        - Removing duplicate rows.
        - Removing unwanted outliers
        - Fixing structural errors
        - Handling missing values
*/


--------------------------------------------------------------------
/*	               Find and Remove Duplicates  	                  */
--------------------------------------------------------------------
-- Check for duplicates
SELECT dup.str, count(dup.id)
FROM (SELECT CONCAT(last_name, first_name) id, Concat(first_name, last_name, birth_date, birth_place, marriage_date) AS str
FROM ancestors) dup
GROUP BY dup.str
HAVING COUNT(dup.id) > 1;

-- The query above shows that Franczi Krauss and Amelia Carter both have one duplicate row
-- Take a look at those duplicates
SELECT * 
FROM ancestors
WHERE CONCAT(first_name, last_name) IN ('FrancziKrauss', 'AmeliaCarter');

-- Delete the duplicates, which also contain missing data ('A-035', 'A-036')
DELETE FROM ancestors
WHERE person_id IN ('A-035', 'A-036');

-- Check to ensure duplicates were deleted
SELECT * 
FROM ancestors
WHERE person_id IN ('A-035', 'A-036');
-- 0 rows returened


--------------------------------------------------------------------
/*	              Find and Remove Unwanted Outliers               */
--------------------------------------------------------------------
-- Find any person born before 1600 or after 1999
SELECT person_id, first_name, last_name, birth_date, mother_id, father_id, spouse_id
FROM ancestors
WHERE birth_date < '01-01-1600'
    OR birth_date > '12-31-1999';


-- We find John Smith and Rider Jones
-- Since John Smith has names listed for mother and father, let us check for those, incase his birth year was entered incorrectly.
SELECT person_id, first_name, last_name
FROM ancestors
WHERE first_name IN ('Alice', 'Smith')
    OR last_name IN ('Alice', 'Smith');

-- John is the only one return, so we can delete both John and Rider
DELETE FROM ancestors
WHERE person_id IN ('A-033', 'A-000');

-- Confirm deletions successful
SELECT person_id, first_name, last_name, birth_date, mother_id, father_id, spouse_id
FROM ancestors
WHERE birth_date < '01-01-1600'
    OR birth_date > '12-31-1999';

-- Find any person without a listed mother, father or husband
SELECT person_id, last_name, mother_id, father_id, spouse_id
FROM ancestors
WHERE mother_id IS NULL
    AND father_id IS NULL 
    AND spouse_id IS NULL;
-- None found


--------------------------------------------------------------------
/*	              Find and Fix Structural Errors                   */
--------------------------------------------------------------------
-- Make sure that values for each column follow the correct format

-- ids should begin with A-
SELECT person_id
FROM ancestors
WHERE person_id NOT LIKE 'A-%';

SELECT mother_id
FROM ancestors
WHERE mother_id NOT LIKE 'A-%';

SELECT father_id
FROM ancestors
WHERE father_id NOT LIKE 'A-%';

SELECT spouse_id
FROM ancestors
WHERE spouse_id NOT LIKE 'A-%';

-- Names should begin with a capital and the remaining letters should be lower case.
SELECT first_name
FROM ancestors
WHERE first_name <> INITCAP(first_name)
    OR first_name = UPPER(first_name)
    OR first_name = LOWER(first_name);

SELECT last_name
FROM ancestors
WHERE last_name <> INITCAP(last_name)
    OR last_name = UPPER(last_name)
    OR last_name = LOWER(last_name);

-- Genders should only include F and M (binary)
SELECT DISTINCT(sex)
FROM ancestors;

-- Living should only include "Deceased" or "Living" (binary)
SELECT DISTINCT(living)
FROM ancestors;

-- Found multiple spellings of deceased, update them to match
UPDATE ancestors
SET living = 'Deceased'
WHERE living = 'diceased'
    OR living = 'deceased';

-- For dates, PostgreSQL already checks these whwen importing data using the DATE type. We can also check the numbers and months after creating separate columns for days, months and years.
-- For places, we'll check these after we ahve separated them into city, state & country.

--------------------------------------------------------------------
/*	               Handle Missing Values      	                  */
--------------------------------------------------------------------
