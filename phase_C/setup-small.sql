--Emilia Ochoa (eochoa6)
--Angi Benton (abenton3)

DROP TABLE IF EXISTS EconomicHealth;
CREATE TABLE EconomicHealth 
(
year INT,
unemploymentRate REAL,
realGdpPch REAL,
snpRoi REAL,
PRIMARY KEY (year),
CHECK (1948 <= year AND year <= 2020),
CHECK (0 <= unemploymentRate AND unemploymentRate <= 100),
CHECK (-100 <= snpRoi)
);


-- @Emilia change this to your own full path for it to work (it is a hate crime thta you have to do it though)
LOAD DATA LOCAL INFILE '/Users/emi.ochoa/databases1/databases_project/phase_C/EconomicHealth-small.txt' 
INTO TABLE EconomicHealth
COLUMNS TERMINATED BY ','
LINES TERMINATED BY '\n'; 

SELECT * FROM EconomicHealth 


--Create Administratin relation

DROP TABLE IF EXISTS Administration;
CREATE TABLE Administration
(
president VARCHAR(25),
startYear INT,
endYear INT,
PRIMARY KEY (startYear, endYear),
CHECK (1953 <= startYear AND startYear <= 2017)
);


LOAD DATA LOCAL INFILE '/Users/emi.ochoa/databases1/databases_project/phase_C/Administration-small.txt' 
INTO TABLE Administration
COLUMNS TERMINATED BY ','
LINES TERMINATED BY '\n'; 

SELECT * FROM Administration 


--Create Genre relation
DROP TABLE IF EXISTS Genre;
CREATE TABLE Genre
(
genre VARCHAR(25),
PRIMARY KEY (genre)
);


LOAD DATA LOCAL INFILE '/Users/emi.ochoa/databases1/databases_project/phase_C/Genre-small.txt' 
INTO TABLE Genre
COLUMNS TERMINATED BY '  '
LINES TERMINATED BY '\n'; 

SELECT * FROM Genre 