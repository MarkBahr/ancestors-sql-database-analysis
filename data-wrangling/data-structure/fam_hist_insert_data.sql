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


-- Insert data into SOURCES table
INSERT INTO sources (source_id, source_creator, source_title, source_type, source_format, source_year, source_month, source_day, source_location, source_description)
SELECT source_id, source_creator, source_title, source_type, source_format, source_year, source_month, source_day, source_location, source_description
from sources_original;


-- Insert data into PERSONS table
INSERT INTO persons (person_id, first_name, last_name, gender, living)
SELECT person_id, first_name, last_name, gender, living
FROM ancestors;


-- Insert data into BIRTHS table
INSERT INTO births (birth_id, person_id, birth_year, birth_month, birth_day, birth_city, birth_state, birth_country, mother_id, father_id, source_id)
SELECT birth_id, person_id, birth_year, birth_month, birth_day, birth_city, birth_state, birth_country, mother_id, father_id, birth_source_id
FROM ancestors;


-- Insert data into MARRIAGES table
INSERT INTO marriages (marraige_id, person_id, marraige_year, marraige_month, marraige_day, marraige_city, marraige_state, marraige_country, source_id)
SELECT marraige_id, person_id, marraige_year, marraige_month, marraige_day, marraige_city, marraige_state, marraige_country, marriage_source_id
from ancestors;


-- Insert data into DEATHS table
INSERT INTO deaths (death_id, person_id, death_year, death_month, death_day, death_city, death_state, death_country, source_id)
SELECT death_id, person_id, death_year, death_month, death_day, death_city, death_state, death_country, death_source_id
from ancestors;