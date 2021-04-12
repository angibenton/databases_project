-- our original data goes up to 2017, so we would like to manually insert the top 4 most popular songs of 2018 
-- add the song data (these IDs are much higher than the rest of them so they are safe to add)
INSERT INTO Song 
(id,song,artist,musicKey,tempo,explicit,popularity,danceability,energy,acousticness,instrumentalness,liveness,valence)
VALUES 
(201801, "God's Plan", "Drake", 7, 77.169, "TRUE", 87, 0.754, 0.449, 0.0332, 8.29E-05, 0.552, 0.357),
(201802, "Perfect", "Ed Sheeran", 8, 95.05, "FALSE", 88, 0.599, 0.448, 0.163, 0, 0.106, 0.168),
(201803, "Meant To Be", "Bebe Rexha", 10, "", "FALSE", 82, 0.643, 0.783, 0.047, 0, 0.083, 0.579),
(201804, "Havana", "Camila Cabello", 10, "", "FALSE", 86, 0.765, 0.523, 0.184, 3.56E-05, 0.132, 0.394);
-- establish that they topped the chart in 2018
INSERT INTO BillboardChart(songId, year, position)
VALUES 
(201801, 2018, 1),
(201802, 2018, 2),
(201802, 2018, 3);

-- the genres these songs are listed under ALREADY exist in the Genre table, no need to add them

-- associate songs with their genres
INSERT INTO SongGenre (song, genre)
VALUES 
(201801, 'canadian hip hop'),
(201801, 'canadian pop'),
(201801, 'hip hop'),
(201801, 'pop rap'),
(201801, 'rap'),
(201801, 'toronto rap'),
(201802, 'pop'),
(201802, 'uk pop'),
(201803, 'dance pop'),
(201803, 'pop'),
(201803, 'post-teen pop'),
(201804, 'dance pop'),
(201804, 'pop'),
(201804, 'post-teen pop');

DELETE FROM Song
WHERE id like '20180%';

-- TODO, will on delete cascade take care of the rest?

-- TODO EconomicHealth 

-- TODO Administration 
