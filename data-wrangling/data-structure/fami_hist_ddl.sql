/*
    Name: Mark Bahr
    Project: Family History SQL Database & Analysis
    Tasks: Use PostgreSQL to 
        - CREATE tables and columns with specified data types
        - CREATE constraints, such as Primary keys, check constraints, foreign keys
*/

-- Note: constraint naming pattern: table_column_constraint. Example: births_birth_id_pk

-- Drop tables if they exist
DROP TABLE IF EXISTS marriages;
DROP TABLE IF EXISTS deaths;
DROP TABLE IF EXISTS births;
DROP TABLE IF EXISTS persons;

-- Define table for each person's name, gender, whether living
CREATE TABLE Persons (
    person_id CHAR(5),
    first_name VARCHAR(50),
	last_name VARCHAR(50),
    gender char(1) CHECK(gender IN ('M', 'F')),
    living VARCHAR(8) CHECK(living IN ('Deceased', 'Living')),
    CONSTRAINT persons_person_id_pk PRIMARY KEY (person_id)
);

-- Define table for births
CREATE TABLE births (
	birth_id SERIAL,
    person_id CHAR(5),
	birth_year INT CHECK(birth_year > 1600 AND birth_year < 2000),
    birth_month INT CHECK(birth_month > 0 AND birth_month < 13),
    birth_day INT CHECK(birth_day > 0 AND birth_day < 32),  
	birth_city VARCHAR(100),
    birth_state VARCHAR(80),
    birth_country VARCHAR(70),
    mother_id CHAR(5),
    father_id CHAR(5),
	CONSTRAINT births_birth_id_pk PRIMARY KEY (birth_id),
    CONSTRAINT births_person_id_fk FOREIGN KEY (person_id)
    REFERENCES persons,
    CONSTRAINT births_mother_id_fk FOREIGN KEY (person_id)
    REFERENCES persons,
    CONSTRAINT births_father_id_fk FOREIGN KEY (person_id)
    REFERENCES persons
);

-- Define table for deaths
CREATE TABLE deaths (
	death_id SERIAL,
    person_id CHAR(5),
	death_year INT CHECK(death_year > 1600 AND death_year < 2000),
    death_month INT CHECK(death_month > 0 AND death_month < 13),
    death_day INT CHECK(death_day > 0 AND death_day < 32),
	death_city VARCHAR(100),
    death_state VARCHAR(80),
    death_country VARCHAR(70),
    CONSTRAINT deaths_death_id_pk PRIMARY KEY (death_id),
	CONSTRAINT deaths_person_id_fk FOREIGN KEY (person_id)
	REFERENCES persons (person_id)
);

-- Define table for marriages
CREATE TABLE marriages (
	marriage_id SERIAL,
	groom_Id CHAR(5) NOT NULL,
	bride_Id CHAR(5) NOT NULL,
    marriage_year INT CHECK(marriage_year > 1600 AND marriage_year < 2000),
    marriage_month INT CHECK(marriage_month > 0 AND marriage_month < 13),
    marriage_day INT CHECK(marriage_day > 0 AND marriage_day < 32),
	marriage_city VARCHAR(100),
    marriage_state VARCHAR(80),
    marriage_country VARCHAR(70),
	CONSTRAINT marriages_marriage_id_pk Primary Key (marriage_Id),
	CONSTRAINT marriages_groom_id_fk Foreign Key (groom_Id)
	REFERENCES persons (person_id),
	CONSTRAINT marriages_bride_id_fk Foreign Key (bride_Id)
	REFERENCES persons (person_id)
);

