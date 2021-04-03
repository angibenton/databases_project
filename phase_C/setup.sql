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

SELECT * FROM EconomicHealth 