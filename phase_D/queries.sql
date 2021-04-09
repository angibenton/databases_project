--Emilia Ochoa (eochoa6)
--Angi Benton (abenton3)

-- 1. Who was the most popular musician during each U.S. president's administration?
SELECT B.songID, A.president, AVG(B.position)
FROM Administration AS A JOIN BillboardChart AS B
WHERE B.year >= A.startYear AND B.year < A.endYear
GROUP BY songID;

SELECT S.artist, S.id Sadmin.president, AVG(pos)
FROM Song AS S JOIN (SELECT B.songID, A.president, AVG(B.position) AS pos
                FROM Administration AS A JOIN BillboardChart AS B
                WHERE B.year >= A.startYear AND B.year < A.endYear
                GROUP BY songID) AS Sadmin
WHERE S.id = Sadmin.songID
GROUP BY S.artist, Sadmin.president




--2. During which years did the most popular music genre change?
--3. What is the average 'energy' of the top 100 songs during years when unemployment has fallen dramatically (e.g., < 5%)?
--4. What is the average number of songs released each year, ordered by the average S&P 500 price during that year, adjusted for inflation?
--5. What is the average song duration, grouped by genre?
--6. What were the years where the average tempo of the top 100 tracks was > 120 bpm, the average 'energy' was > 0.5, the and the S&P 500 grew by > 10%?
--*7. What was the mean track popularity during recession years, grouped by genre?
--*8. What song was most popular on days that the unemployment rate hit record lows?
--9. Which artists released their greatest hits during recessions?
--10. What is the average ‘danceability’ of the most popular songs released during years where the stock market fell more than 700 points?
--11. What was the most popular genre of music in each of the years where overall GDP decreased?
--12. What was the average unemployment rate during years where ‘pop’ was the most popular genre?
--13. What was the average ‘valence’ of the top 100 songs in years where the unemployment rate was above 4%, listed in increasing order?
--*14. What was the average unemployment date during years when the majority of the top 100 songs were ‘minor’ ?
--*15. What was the percentage of songs listed as ‘explicit’ during years where the stock market fell more than 300 points?
--16. What was the total number of years where the most popular genre was ‘rap’, and the S&P 500 stayed within 10%?
--17. For each year where unemployment decreased by more than 1%, what was the average  ‘liveliness’ of the top 100 songs released in January, vs those released in December?
--18. What was the average tempo of the top 100 songs of each decade, compared to the average tempo of the top 100 songs in the year with the highest unemployment rate in each decade? 
--*19. What was the average ‘popularity’ of songs with a tempo over 125, during years where the average unemployment rate was below 3%? 
--*20. What was the average unemployment rate of years where the top song was labeled 'explicit', and years where it was not? 
