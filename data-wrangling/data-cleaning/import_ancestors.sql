/*
    Author: Mark Bahr
    Project: Family History PostgreSQL Database
    Tasks: Use PostgreSQL to import raw data by
        - Importing data using simple CREATE TABLE and COPY statements.
*/

--------------------------------------------------------------------
/*	           Drop Table  		 	                  */
--------------------------------------------------------------------
-- Drop the ancestors table if it exists.
DROP TABLE IF EXISTS ancestors;

--------------------------------------------------------------------
/*                Table Creation	                          */
--------------------------------------------------------------------
-- Create the table with appropriate data types for the data in the csv file.
CREATE TABLE ancestors (
    person_id CHAR(5) PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    sex CHAR(1),
    living VARCHAR(8),
    birth_date DATE,
    birth_place VARCHAR(200),
    mother_id CHAR(5),
    father_id CHAR(5),
    spouse_id CHAR(5),
    marriage_date DATE,
    marriage_Place VARCHAR(200),
    death_date DATE,
    death_place VARCHAR(200)
);


--------------------------------------------------------------------
/*	              Import Data      	  		          */
--------------------------------------------------------------------

-- Execute a copy statement to bring the data into the database
COPY ancestors
FROM 'C:\Users\Public\data\ancestors-raw-data.csv'
WITH (FORMAT CSV, HEADER);


-- Check to make sure data was imported correctly.
SELECT * FROM ancestors;

