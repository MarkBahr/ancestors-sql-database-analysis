/*
    Name: Mark Bahr
    Project: Family History Database
    Skill: Use PostgreSQL to 
        - Import data using simple CREATE TABLE and COPY statements
        - Add new columns and use UPDATE to set values, then drop a column
        - Filter, group and sort data using WHERE, GROUP BY and ORDER BY
*/

-- Find out if it's advisable to separate out year, month, day, or to list a date. 
-- Find out if postgres convention is to name pks and fks with pk or fk first? 
-- Find out max length of a few columns
-- Add check constraints and primary/foreign keys
-- Find sources for each event


CREATE TABLE Persons (
    person_id INT,
    first_name VARCHAR(40),
	last_name VARCHAR(40),
    gender char(1),
    living boolean
);

CREATE TABLE sources (
    source_id INT,
    source_creator VARCHAR,
    source_title VARCHAR,
    source_type VARCHAR,
    source_format VARCHAR,
    source_year INT,
    source_month VARCHAR(9),
    source_day INT,
    source_location VARCHAR(150),
    source_description TEXT
);

CREATE TABLE births (
	birth_id INT,
    person_id INT,
	birth_year INT CHECK(birth_year > 1500 AND birth_year < 2000),
    birth_month INT CHECK (birth_month >= 1 AND birth_month < 13),
    birth_day INT CHECK (birth_day >= 1 AND birth_day < 32),  
	birth_city VARCHAR(100),
    birth_state VARCHAR(80),
    birth_country VARCHAR(70),
    source_id INT,
	CONSTRAINT births_pk PRIMARY KEY (birth_id),
    CONSTRAINT birth_person_fk FOREIGN KEY (person_id)
    REFERENCES persons,
    CONSTRAINT birth_source_fk Foreign Key (source_id)
	REFERENCES sources (source_id)
);

CREATE TABLE deaths (
	death_id INT,
    person_id INT,
	death_year INT,
    daath_month VARCHAR(9),
    death_day INT,
	death_city VARCHAR(100),
    death_state VARCHAR(80),
    death_country VARCHAR(70),
    source_id INT,
    CONSTRAINT death_pk PRIMARY KEY (death_id),
	CONSTRAINT death_person Foreign Key (person_id)
	REFERENCES persons (person_id),
    CONSTRAINT death_source_fk Foreign Key (source_id)
	REFERENCES sources (source_id)
);

CREATE TABLE marriages (
	marriage_id INT,
	Groom_Id INT NOT NULL,
	Bride_Id INT NOT NULL,
    marriage_year INT,
    marriage_month VARCHAR(9),
    marriage_day INT,
	marriage_city VARCHAR(100),
    marriage_state VARCHAR(80),
    marriage_country VARCHAR(70),
    source_id INT,
	CONSTRAINT marriage_pk Primary Key (marriage_Id),
	CONSTRAINT FK_Groom_Id Foreign Key (groom_Id)
	REFERENCES persons (person_id),
	CONSTRAINT FK_Bride_Id Foreign Key (bride_Id)
	REFERENCES persons (person_id),
    CONSTRAINT marriage_source_fk Foreign Key (source_id)
	REFERENCES sources (source_id)
);

CREATE TABLE relationships (
    relationship_id,
    person_id int,
    relationship_type VARCHAR(12),
    relation_id int,
    source_id int,
    CONSTRAINT relate_person_fk Foreign Key (person_id)
	REFERENCES persons (person_id),
    CONSTRAINT relative_fk Foreign Key (relation_id)
	REFERENCES persons (person_id)
    CONSTRAINT relate_source_fk Foreign Key (source_id)
	REFERENCES sources (source_id)
);

