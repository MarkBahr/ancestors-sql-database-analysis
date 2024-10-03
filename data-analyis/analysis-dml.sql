/*
    Name: Mark Bahr
    Project: Family History SQL Database & Analysis
    Tasks: Use PostgreSQL to 
        - Query the database for reports that contain the desired information in tabular format.
*/


--------------------------------------------------------------------
/*	     QUERY 1: NUMBER OF ANCESTORS FROM EACH COUNTRY          */
--------------------------------------------------------------------
-- List the number of ancestors born in each country, along with the percentage of ancestors born in each country. List those countries with the most ancestors at the top (descending order).
WITH stats AS(
    -- This subquery (called "stats") lists the # of ancestor and the total count of ancestors
    SELECT  birth_country, COUNT(person_id) ancestor_count, 
            (select count(person_id) total from births)
    FROM births
    GROUP BY birth_country
)
-- Then, use the "stats" subquery data to calculate the percentages, as well as list the other attribute values.
SELECT  birth_country, ancestor_count, 
        ROUND(((ancestor_count::NUMERIC / total::NUMERIC) * 100), 1) percent
FROM stats
ORDER BY ancestor_count DESC;



--------------------------------------------------------------------
/*	         QUERY 2: ANCESTORS WITH LONGEST LIFE SPANS           */
--------------------------------------------------------------------
-- List the 10 ancestors who lived the longest in descending order by their life span. Include their birth and death countries.
SELECT  P.first_name, P.last_name,
        -- Calculate life span by finding the difference between the death date and birth date. Here, I cast the integer values for month, day and year to varchar so that the to_date function works correctly.
        FLOOR((TO_DATE(D.death_month::VARCHAR || '/' || D.death_day::VARCHAR || '/' || D.death_year::VARCHAR , 'MM/DD/YYYY')
        - TO_DATE(B.birth_month::VARCHAR || '/' || B.birth_day::VARCHAR || '/' || B.birth_year::VARCHAR , 'MM/DD/YYYY')) / 365.25) life_span, 
        B.birth_country, D.death_country
from births B 
    INNER JOIN deaths D ON B.person_id = D.person_id
    INNER JOIN persons P ON P.person_id = B.person_id
ORDER BY life_span DESC
LIMIT 10;



--------------------------------------------------------------------
/*	     QUERY 3: BRIDES & GROOMS MARRIED IN ENGLAND          */
--------------------------------------------------------------------
-- List marriages held in England with names of grooms and brides, sort by groom's last name in alphabetical order.
SELECT  groom.first_name || ' ' || groom.last_name groom_name,
        bride.first_name || ' ' || bride.last_name bride_name,
        M.marriage_year, M.marriage_city
from    marriages M 
    INNER JOIN persons groom ON M.groom_id = groom.person_id
    INNER JOIN persons bride ON M.bride_id = bride.person_id
WHERE marriage_country = 'England'
ORDER BY groom.last_name;



--------------------------------------------------------------------
/*	            QUERY 4: PARENTS AND GRANDPARENTS                */
--------------------------------------------------------------------
-- For each person with grandparents listed, include the person's name along with their parents and grandparents. Sort the child names by birth year.
WITH parents AS (
    -- First, get a query of the child and parents
    SELECT 	child.first_name || ' ' || child.last_name child, B.person_id, B.birth_year,
            father.first_name || ' ' || father.last_name father, B.father_id,
            mother.first_name || ' ' || mother.last_name mother, B.mother_id
    FROM births B
        INNER JOIN persons child ON B.person_id = child.person_id
        INNER JOIN persons father ON B.father_id = father.person_id
        INNER JOIN persons mother ON B.mother_id = mother.person_id)
-- Then, use the subquery above to identify grandparents.
SELECT  P.child, P.mother, P.father,
        maternal.mother maternal_grandmother, maternal.father maternal_grandfather,
        paternal.mother paternal_grandmother, paternal.father paternal_grandfather
FROM parents P
        INNER JOIN parents paternal ON P.father_id = paternal.person_id
        INNER JOIN parents maternal ON P.mother_id = maternal.person_id
ORDER BY P.birth_year DESC;