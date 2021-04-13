--Emilia Ochoa (eochoa6)
--Angi Benton (abenton3)

-- 1. Who was the most popular musician during each U.S. president's administration?

WITH 
        songNArtist AS (SELECT artist, Song.id AS songID, position, year
                        FROM BillboardChart JOIN Song
                        WHERE Song.id = BillboardChart.songID),
                        
        songPosOverAdmin AS (SELECT B.songID, B.artist, A.president, AVG(B.position) AS songPos
                        FROM Administration AS A JOIN songNArtist AS B
                        WHERE B.year >= A.startYear AND B.year < A.endYear
                        GROUP BY songID),

        artistsPosOverAdmin AS (SELECT artist, president, AVG(songPos)
                                FROM songPosOverAdmin
                                GROUP BY artist, president)
                                
        
        
        maxPosOverAdmin AS (SELECT MIN(artistPos) as m, president
                            FROM artistsPosOverAdmin
                            GROUP BY president)
SELECT *
FROM artistsPosOverAdmin AS A JOIN maxPosOverAdmin AS M
ON A.president = M.president 
WHERE A.artistPos = M.m
        





--2. During which years did the most popular music genre change?
--3. What is the average 'energy' of the top 100 songs during years when unemployment has fallen dramatically (e.g., < 5%)?
--4. What is the average number of songs released each year, ordered by the average S&P 500 price during that year, adjusted for inflation?
--5. What is the average song duration, grouped by genre?
--6. What were the years where the average tempo of the top 100 tracks was > 120 bpm, the average 'energy' was > 0.5, the and the S&P 500 grew by > 10%?
--*7. What was the mean track popularity during recession years, grouped by genre?
--*8. What song was most popular on days that the unemployment rate hit record lows?
--9. Which artists released their greatest hits during recessions?

--10. What is the average ‘danceability’ of the most popular songs during years where the S&P Roi fell > 5%s?
WITH 
        yrs AS( SELECT year
                FROM EconomicHealth
                WHERE snpRoi < 5.0),
                
        songs AS (SELECT Song.danceability, Song.id AS songID, position, year
                  FROM BillboardChart JOIN Song
                  WHERE Song.id = BillboardChart.songID AND danceability != 0.0)
                
SELECT songs.year, AVG(danceability)
FROM songs JOIN yrs 
        ON songs.year = yrs.year
GROUP BY songs.year

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
--13. What was the average ‘valence’ of the top 100 songs in years where the unemployment rate was above 4%, listed in increasing order?
--*14. What was the average unemployment date during years when the majority of the top 100 songs were ‘minor’ ?
--*15. What was the percentage of songs listed as ‘explicit’ during years where the stock market fell more than 300 points?

--16. List the years where the most popular genre in the top 100 songs was ‘rap’

WITH rapCntByYr AS  (SELECT BC.year, COUNT(SG.songID) AS cnt
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


--17. For each year where unemployment decreased by more than 1%, what was the average  ‘liveliness’ of the top 100 songs released in January, vs those released in December?
--18. What was the average tempo of the top 100 songs of each decade, compared to the average tempo of the top 100 songs in the year with the highest unemployment rate in each decade? 
--*19. What was the average ‘popularity’ of songs with a tempo over 125, during years where the average unemployment rate was below 3%? 
--*20. What was the average unemployment rate of years where the top song was labeled 'explicit', and years where it was not? 

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



