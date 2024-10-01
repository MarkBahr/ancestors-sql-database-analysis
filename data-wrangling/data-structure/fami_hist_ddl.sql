/*
    Name: Mark Bahr
    Project: Family History SQL Database & Analysis
    Tasks: Use PostgreSQL to 
        - CREATE tables and columns with specified data types
        - CREATE constraints, such as Primary keys, check constraints, foreign keys
*/


-- TO DO BEFORE executing CREATe TABLE statements: 
    -- Create data for the fictitious (but believable) source info for each event for each person. Add to the ancestor's table the brith_source_id, marriage_source_id, and death_source_id.

-- Note: constraint naming pattern: table_column_constraint. Example: births_birth_id_pk

-- Define table for sources
CREATE TABLE sources (
    source_id CHAR(6),
    source_creator VARCHAR(100),
    source_title VARCHAR(100),
    source_type VARCHAR(20),
    source_format VARCHAR(20),
    source_year INT,
    source_month VARCHAR(9),
    source_day INT,
    source_location VARCHAR(150),
    source_description TEXT,
    CONSTRAINT sources_source_id_pk PRIMARY KEY (source_id),
);

-- Define table for each person's name, gender, whether living
CREATE TABLE Persons (
    person_id CHAR(5),
    first_name VARCHAR(50),
	last_name VARCHAR(50),
    gender char(1),
    living VARCHAR(8)
);

-- Define table for births
CREATE TABLE births (
	birth_id CHAR(5),
    person_id CHAR(6),
	birth_year INT CHECK(birth_year > 1600 AND birth_year < 2000),
    birth_month INT CHECK (birth_month >= 1 AND birth_month < 13),
    birth_day INT CHECK (birth_day >= 1 AND birth_day < 32),  
	birth_city VARCHAR(100),
    birth_state VARCHAR(80),
    birth_country VARCHAR(70),
    mother_id CHAR(5),
    father_id CHAR(5),
    source_id INT,
	CONSTRAINT births_birth_id_pk PRIMARY KEY (birth_id),
    CONSTRAINT births_person_id_fk FOREIGN KEY (person_id)
    REFERENCES persons,
    CONSTRAINT births_mother_id_fk FOREIGN KEY (person_id)
    REFERENCES persons,
    CONSTRAINT births_father_id_fk FOREIGN KEY (person_id)
    REFERENCES persons,
    CONSTRAINT births_source_id_fk Foreign Key (source_id)
	REFERENCES sources (source_id)
);

-- Define table for deaths
CREATE TABLE deaths (
	death_id CHAR(5),
    person_id CHAR(5),
	death_year INT,
    daath_month VARCHAR(9),
    death_day INT,
	death_city VARCHAR(100),
    death_state VARCHAR(80),
    death_country VARCHAR(70),
    source_id INT,
    CONSTRAINT deaths_death_id_pk PRIMARY KEY (death_id),
	CONSTRAINT deaths_person_id_fk Foreign Key (person_id)
	REFERENCES persons (person_id),
    CONSTRAINT deaths_source_id_fk Foreign Key (source_id)
	REFERENCES sources (source_id)
);

-- Define table for marriages
CREATE TABLE marriages (
	marriage_id CHAR(4),
	Groom_Id CHAR(5) NOT NULL,
	Bride_Id CHAR(5) NOT NULL,
    marriage_year INT,
    marriage_month VARCHAR(9),
    marriage_day INT,
	marriage_city VARCHAR(100),
    marriage_state VARCHAR(80),
    marriage_country VARCHAR(70),
    source_id INT,
	CONSTRAINT marriages_marriage_id_pk Primary Key (marriage_Id),
	CONSTRAINT marriages_groom_id_fk Foreign Key (groom_Id)
	REFERENCES persons (person_id),
	CONSTRAINT marriages_bride_id_fk Foreign Key (bride_Id)
	REFERENCES persons (person_id),
    CONSTRAINT marriages_source_id_fk Foreign Key (source_id)
	REFERENCES sources (source_id)
);

-- Optional relationships table
-- CREATE TABLE relationships (
--     relationship_id CHAR(7),
--     person_id CHAR(5),
--     relationship_type VARCHAR(12),
--     source_id int,
--     CONSTRAINT relationships_person_fk Foreign Key (person_id)
-- 	REFERENCES persons (person_id),
--     CONSTRAINT relative_fk Foreign Key (relation_id)
-- 	REFERENCES persons (person_id)
--     CONSTRAINT relate_source_fk Foreign Key (source_id)
-- 	REFERENCES sources (source_id)
-- );