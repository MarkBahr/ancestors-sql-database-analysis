/*
    Name: Mark Bahr
    Project: Family History SQL Database & Analysis
    Tasks: Use PostgreSQL to 
        - Insert the correct data into each table using the cleaned data in the ancestors and soureces_original tables.
*/

-- Use the following syntax
-- INSERT INTO table_2 (col1, col2, col3, ...)
-- SELECT col1, col2, col3, ...
-- FROM table_1
-- WHERE cond;

-- Insert data into PERSONS table
INSERT INTO persons (person_id, first_name, last_name, gender, living)
SELECT person_id, first_name, last_name, sex, living
FROM ancestors;


-- Insert data into BIRTHS table
INSERT INTO births (person_id, birth_year, birth_month, birth_day, birth_city, birth_state, birth_country, mother_id, father_id)
SELECT person_id, birth_year, birth_month, birth_day, birth_city, birth_state, birth_country, mother_id, father_id
FROM ancestors;


-- Insert data into MARRIAGES table
INSERT INTO marriages (groom_id, bride_id, marriage_year, marriage_month, marriage_day, marriage_city, marriage_state, marriage_country)
SELECT person_id groom_id, spouse_id bride_id, marriage_year, marriage_month, marriage_day, marriage_city, marriage_state, marriage_country
FROM ancestors
WHERE sex = 'M';


-- Insert data into DEATHS table
INSERT INTO deaths (person_id, death_year, death_month, death_day, death_city, death_state, death_country)
SELECT person_id, death_year, death_month, death_day, death_city, death_state, death_country
from ancestors;

-- Check that data seems correct
SELECT * FROM persons LIMIT 10;
SELECT * FROM births LIMIT 10;
SELECT * FROM marriages LIMIT 10;
SELECT * FROM deaths LIMIT 10;