#INPUT DATA: billboard_yearly.csv, hotStuff.csv, spotify_genre_list.txt
#OUTPUT DATA: Song.txt, Genre.txt, SongGenre.txt, BillboardChart.txt
import pandas as pd 
import json 

#Helper functions!
def removeFeature(artistName):
  return artistName.split(' featuring')[0]

def getGenreArrayFromString(str):
  try: 
    str = str.replace("'", '"')
    str = '{"genres":' + str + '}'
    obj = json.loads(str)
    return obj['genres']
  except Exception as e: #bad str 
    return []
  
bb = pd.read_csv("sourceData/billboard_yearly.csv")
hotSpotify = pd.read_csv("sourceData/hotSpotify.csv", encoding ='latin1')

#Set up the dataframes for each of our relations 
Song = pd.DataFrame(columns = ['songId', 'title', 'artist', 'genres', 'key', 'tempo', 
'danceability', 'energy', 'acousticness', 'instrumentalness', 'liveness', 'valence'])
BillboardChart = pd.DataFrame(columns = ['songId', 'chartYear', 'chartPosition'], dtype = int)
Genre = pd.read_csv("sourceData/spotify_genre_list.txt") #might modify this a little 
SongGenre = pd.DataFrame(columns = ["songId", "genreName"])

#CLEAN THE BILLBOARD DATA
bb = bb.sort_values(by = ['title', 'artist', 'year']) #sort by song (useful for removing duplicates)
bb = bb.reset_index(drop=True) 
bb = bb.drop("Unnamed: 0",axis=1)

#LOG 
print("Building Song and BillboardChart from billboard data...")

#extract everything relevant from bb (Part of Song relation, all of BillboardChart relation)
curSongId = -1
curTitle = ""
curArtist = ""
for i, row in bb.iterrows():
  if((curTitle != row['title']) | (curArtist  != row['artist'])): 
    #new song!! 
    curTitle, curArtist = row['title'], row['artist']
    curSongId += 1 #get a new id for this song 
    new_song = {'songId': curSongId, 'title': curTitle, 'artist': removeFeature(curArtist)} #strip artist name of "featuring ... "
    Song = Song.append(new_song, ignore_index = True)
  #new song or not, we should associate this song with the chart   
  new_chart = {'songId': curSongId, 'chartYear': row['year'], 'chartPosition': row['number']}
  BillboardChart = BillboardChart.append(new_chart, ignore_index = True)

BillboardChart = BillboardChart.sort_values(by = ["chartYear"])


#Song = Song.sample(30) #TEMPORARILY make Song much smaller 

#LOG 
print("Matching Song with spotify data...")

#Match the songs in Song with songs in hotspotify, which contains additional metadata 
    #criteria for matching a song in the billboard data to one in spotify data:
    #exact matching titles, and artist in billboard is substring of Performer in spotify 
    #change this maybe?
Song['spotifyMatchFound'] = 0
for bbIndex, bbRow in Song.iterrows():
  name_matches = hotSpotify[hotSpotify['Song'] == bbRow['title']]
  for spotIndex, spotRow in name_matches.iterrows():
    if (bbRow['artist'] in spotRow['Performer']):
      Song.loc[bbIndex, 'spotifyMatchFound'] = 1
      Song.loc[bbIndex, 'genres'] = spotRow['spotify_genre']
      Song.loc[bbIndex, 'key'] = spotRow['key']
      Song.loc[bbIndex, 'tempo'] = spotRow['tempo']
      #special spotify characteristics 
      Song.loc[bbIndex, 'danceability'] = spotRow['danceability']
      Song.loc[bbIndex, 'energy'] = spotRow['energy']
      Song.loc[bbIndex, 'acousticness'] = spotRow['acousticness']
      Song.loc[bbIndex, 'instrumentalness'] = spotRow['instrumentalness']
      Song.loc[bbIndex, 'liveness'] = spotRow['liveness']
      Song.loc[bbIndex, 'valence'] = spotRow['valence']
      break
  
#LOG 
print("Building Genre and SongGenre from spotify data...")

#GENRES
#parse the genres string 
#associate Song and Genre using the SongGenre relation
#add in any genres that are missing from Genre
Genre["relevant"] = 0;
songsWithGoodGenreString = 0;
Genre.set_index("genreName", inplace = True)
for index, song in Song[Song.spotifyMatchFound == 1].iterrows():
  genres = getGenreArrayFromString(song["genres"])
  if(len(genres) > 0):
    songsWithGoodGenreString += 1
  for genre in genres: 
    try: #rememeber that this genre is relevant!
      Genre.loc[genre]["relevant"] = 1
    except KeyError as e: # genre is not already a genreName in the Genre table
      #just add it, and mark relevant 
      new_genre = {"genreName": genre, "relevant": 1}
      Genre = Genre.append(new_genre, ignore_index = True)
    #record that this song is in this genre 
    new_song_genre = {'songId': song['songId'], 'genreName': genre }
    SongGenre = SongGenre.append(new_song_genre, ignore_index = True)
#remove genres that we don't have songs for 
Genre = Genre[Genre.relevant == 1]

#report statistics
spotifyMatchPercent = Song[Song.spotifyMatchFound == 1].shape[0] / Song.shape[0] * 100
genreParsePercent = songsWithGoodGenreString / Song[Song.spotifyMatchFound == 1].shape[0] * 100
print("%.1f%% of billboard songs have a spotify match, and %.1f%% of those had parseable genres"%(spotifyMatchPercent, genreParsePercent))

#remove temporary columns 
Song = Song.drop(columns = ["genres", "spotifyMatchFound"]) #should we keep spotify match found ? 
Genre = Genre.drop(columns = ["relevant"])

#Final exports 
BillboardChart.to_csv("BillboardChart.txt", header = False, index = False)
Song.to_csv("Song.txt", header = False, index = False)
Genre.to_csv("Genre.txt", header = False, index = False)
SongGenre.to_csv("SongGenre.txt", header = False, index = False)








