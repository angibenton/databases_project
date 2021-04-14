--Emilia Ochoa (eochoa6)
--Angi Benton (abenton3)

-- 1. What artist had the most songs in the top 100s during each U.S presidents administration?
-- *Note: since we only have music data up till 2017, the max number of times an artist appears in top 100
--        during the trump admin was 3 times. Four different artists appeared 3 times
WITH 
        songNArtist AS (SELECT artist, Song.id AS songID, position, year
                        FROM BillboardChart JOIN Song
                        WHERE Song.id = BillboardChart.songID),
                        
        artistsNums AS (SELECT president, artist, COUNT(songID) AS numHits
                                FROM songNArtist JOIN Administration
                                ON songNArtist.year >= startYear AND songNArtist.year < endYear
                                GROUP BY artist, president
                                ORDER BY startYear),
                                
        maxNums AS (SELECT MAX(numHits) AS m, president
                            FROM artistsNums
                            GROUP BY president)
                            
SELECT M.president, A.artist
FROM artistsNums AS A JOIN maxNums AS M
ON A.president = M.president 
WHERE A.numHits = M.m

--2. List the top song of each year of the administrations where unemployment increased (from start to end of administration)

--5. What is the average song duration, grouped by genre?


--6. What were the years where the average tempo of the top 100 tracks was > 120 bpm, the average 'energy' was > 0.5, the and the S&P 500 grew by > 10%?
--*7. What was the mean track popularity during recession years, grouped by genre?
--9. Which artists released their greatest hits during recessions?

--10. What is the average ‘danceability’ of the most popular songs during years where the S&P ROI expectionally low (< -15%)?
WITH 
        yrs AS( SELECT year
                FROM EconomicHealth
                WHERE snpRoi < -15.0),
                
        songs AS (SELECT Song.danceability, Song.id AS songID, position, year
                  FROM BillboardChart JOIN Song
                  WHERE Song.id = BillboardChart.songID AND danceability != 0.0)
                
SELECT songs.year, AVG(danceability)
FROM songs JOIN yrs 
        ON songs.year = yrs.year
GROUP BY songs.year;



-- ^^ What about the average 'danceability' when the S&P ROI was exceptionally high (> 28%)?
WITH 
        yrs AS( SELECT year
                FROM EconomicHealth
                WHERE snpRoi >= 28.0),
                
        songs AS (SELECT Song.danceability, Song.id AS songID, position, year
                  FROM BillboardChart JOIN Song
                  WHERE Song.id = BillboardChart.songID AND danceability != 0.0)
                
SELECT songs.year, AVG(danceability)
FROM songs JOIN yrs 
        ON songs.year = yrs.year
GROUP BY songs.year;


--11. What was the most popular genre of music in each of the years where overall GDP decreased?
WITH 
        yrs AS( SELECT year
                FROM EconomicHealth
                WHERE realGdpPch < 0),
                
       genreCntPerYr AS  (SELECT BC.year, SG.genre, COUNT(SG.songID) AS cnt
                     FROM SongGenre AS SG JOIN BillboardChart AS BC
                     ON SG.songID = BC.songID
                     GROUP BY SG.genre, BC.year),
                     
       yearMaxes AS (SELECT year, MAX(cnt) AS maxs
                     FROM genreCntPerYr
                     GROUP BY year),

       topGenreByYr AS (SELECT YM.year, genre, cnt
                        FROM yearMaxes AS YM JOIN genreCntPerYr AS GC
                        ON YM.maxs = GC.cnt AND YM.year = GC.year)
                        
SELECT yrs.year, genre, cnt
FROM yrs JOIN topGenreByYr
        ON yrs.year = topGenreByYr.year


--12. What was the average unemployment rate during years where ‘pop’ was the most popular genre?
WITH popcntbyyr AS  (SELECT BC.year, COUNT(SG.songID) AS cnt
                     FROM SongGenre AS SG JOIN BillboardChart AS BC
                     ON SG.songID = BC.songID
                     WHERE SG.genre LIKE 'pop'        
                     GROUP BY BC.year),

     yearMaxes AS (SELECT A.year, MAX(A.cnt) AS maxs
                   FROM (SELECT BC.year, SG.genre, count(SG.genre) AS cnt
                         FROM SongGenre AS SG JOIN BillboardChart AS BC
                         ON SG.songID = BC.songID
                         GROUP BY SG.genre, BC.year) AS A
                   GROUP BY A.year)

SELECT popyrs.year, unemploymentRate
FROM EconomicHealth JOIN (  SELECT yearMaxes.year AS year
                            FROM popcntbyyr JOIN yearMaxes 
                            ON popcntbyyr.cnt = maxs AND popcntbyyr.year = yearMaxes.year) AS popyrs
WHERE EconomicHealth.year = popyrs.year


--13. What was the average ‘valence’ of the top 100 songs in years where the unemployment rate was above 4%, listed in increasing order?
WITH  vsongsbyyr AS (SELECT year, AVG(Song.valence) AS avgv
                    FROM BillboardChart JOIN Song
                    WHERE Song.id = BillboardChart.songID 
                    GROUP BY BillboardChart.year)
                    
SELECT yrs.year, avgv AS avgValence
FROM vsongsbyyr JOIN (SELECT year
                      FROM EconomicHealth
                      WHERE unemploymentRate > 4.0) AS yrs
WHERE vsongsbyyr.year = yrs.year
                    

--15. What was the percentage of songs listed as ‘explicit’ during years where gdp and S&P Roi both fell 
WITH  songs AS   (SELECT Song.explicit, Song.id AS songID, year
                  FROM BillboardChart JOIN Song
                  WHERE Song.id = BillboardChart.songID),      
                        
      exsongs AS (SELECT year, COUNT(songID) AS exNum
                  FROM songs
                  WHERE explicit = 'TRUE'
                  GROUP BY year),
                  
      perbyyr AS (SELECT exsongs.year, (exNum/100) AS percent
                  FROM exsongs 
                  GROUP BY exsongs.year)
     
 SELECT yrs.year, COALESCE(percent, 0.0)  AS per 
 FROM perbyyr RIGHT JOIN (SELECT year
                          FROM EconomicHealth
                          WHERE realGdpPch < 0 AND snpRoi < 0) AS yrs
        ON perbyyr.year = yrs.year



--16. List the years where the most popular genre in the top 100 songs was some kind of rap
'TODO: would this double count songs with cateogories rap and atl rap'
WITH rapCntByYr AS  (SELECT BC.year, COUNT(DISTINCT SG.songID) AS cnt
                     FROM SongGenre AS SG JOIN BillboardChart AS BC
                     ON SG.songID = BC.songID
                     WHERE SG.genre LIKE '%rap%'        
                     GROUP BY BC.year),

     yearMaxes AS (SELECT A.year, MAX(A.cnt) AS maxs
                   FROM (SELECT BC.year, SG.genre, count(SG.genre) AS cnt
                         FROM SongGenre AS SG JOIN BillboardChart AS BC
                         ON SG.songID = BC.songID
                         GROUP BY SG.genre, BC.year)  AS A
                   GROUP BY A.year)
SELECT yearMaxes.year
FROM rapCntByYr JOIN yearMaxes 
        ON rapCntByYr.cnt = maxs AND rapCntByYr.year = yearMaxes.year

-- For each year, list the amount of songs in the top 100 that are in some kind of rap genre 
-- order by the year, in order to watch how rap music has become more popular 
SELECT BC.year, COUNT(DISTINCT SG.songID) AS numRapSongs
FROM SongGenre AS SG JOIN BillboardChart AS BC
ON SG.songID = BC.songID
WHERE SG.genre LIKE '%rap%'        
GROUP BY BC.year
ORDER BY BC.year 

-- HELPER: FOR QUERIES INVOLVING DECADES 
SELECT DISTINCT B1.year, MOD((SELECT MIN(B2.year) 
                              FROM BillboardChart AS B2 
                              WHERE B1.year DIV 10 = B2.year DIV 10),
                              100) AS decadeID
FROM BillboardChart AS B1
WHERE B1.year != 1959
ORDER BY year

-- NOTE: for queries involving decades, we simply exclude 1959 and start at 1960. 

--17. For each year where unemployment decreased by more than 1%, what was the average  ‘liveliness’ of the top 100 songs released in January, vs those released in December?
--18. What was the average tempo of the top 100 songs of each decade, compared to the average tempo of the top 100 songs in the year with the highest unemployment rate in each decade?

-- What was the average acousticness of the top 100 songs of each decade ?
WITH  Decade AS (SELECT DISTINCT B1.year, (SELECT MIN(B2.year) 
                                           FROM BillboardChart AS B2 
                                           WHERE B1.year DIV 10 = B2.year DIV 10)
                                           AS decade
                  FROM BillboardChart AS B1
                  WHERE B1.year != 1959)
SELECT decade, AVG(S.acousticness) AS avgAcousticness
FROM Decade AS D
JOIN BillboardChart AS BC ON D.year = BC.year 
JOIN Song AS S ON S.id = BC.songId 
WHERE S.acousticness IS NOT NULL
GROUP BY D.decade;             
                 

-- What was the most popular song of the 5 years with the highest unemployment rate ?
SELECT BC.year, EH.unemploymentRate, S.song, S.artist 
FROM BillboardChart AS BC
JOIN Song AS S ON S.id = BC.songId 
JOIN EconomicHealth AS EH ON EH.year = BC.year
WHERE BC.position = 1
ORDER BY EH.unemploymentRate DESC 
LIMIT 5;



--19. What was the average ‘popularity’ of top songs with a tempo over 125, during years where the average unemployment rate was below 3%? 
WITH    yrs     AS (SELECT year
                    FROM EconomicHealth
                    WHERE unemploymentRate < 4.0)

SELECT year, AVG(popularity) AS popAvg
FROM Song JOIN (SELECT songID, yrs.year
                FROM BillboardChart JOIN yrs
                ON BillboardChart.year = yrs.year) AS yr
ON Song.id = yr.songID
WHERE tempo > 125
GROUP BY year;


--20. What was the average unemployment rate of years where the top song was labeled 'explicit'
WITH exyrs       AS (SELECT year, Song.song
                    FROM Song JOIN BillboardChart
                    ON Song.id = BillboardChart.songID
                    WHERE BillboardChart.position = 1 AND Song.explicit = 'TRUE')

SELECT unemploymentRate, exyrs.year, exyrs.song
FROM exyrs JOIN EconomicHealth
ON exyrs.year = EconomicHealth.year


-- For each genre, for how many years was the top song in this genre? (exclude genres without any no. 1s)
WITH NumOneSongs AS (SELECT songId, year 
                     FROM BillboardChart 
                     WHERE position = 1)
SELECT genre, COUNT(year) AS numYearsTopSong
FROM NumOneSongs AS nos 
JOIN SongGenre as sg 
ON nos.songId = sg.songId
GROUP BY genre 
ORDER BY numYearsTopSong DESC



