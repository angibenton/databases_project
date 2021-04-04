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
LOAD DATA LOCAL INFILE '/Users/angibenton/Desktop/databases/databases_project/phase_C/EconomicHealth.txt' 
INTO TABLE EconomicHealth
COLUMNS TERMINATED BY ','
LINES TERMINATED BY '\n'; 

SELECT * FROM Administration 


--Create Administratin relation

DROP TABLE IF EXISTS Administration;
CREATE TABLE Administration
(
president VARCHAR(20),
startYear INT,
endYear INT,
PRIMARY KEY (startYear, endYear),
CHECK (1953 <= startYear AND startYear <= 2017)
);


--change to ur own local path -_-
LOAD DATA LOCAL INFILE '/Users/emi.ochoa/databases1/databases_project/phase_C/Administration.txt' 
INTO TABLE Administration
COLUMNS TERMINATED BY ','
LINES TERMINATED BY '\n'; 


SELECT * FROM Administration 