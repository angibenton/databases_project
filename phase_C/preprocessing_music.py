#INPUT DATA: billboard_yearly.csv, hotStuff.csv
#OUTPUT DATA: Song.txt, Genre.txt, SongGenre.txt, BillboardChart.txt

def removeFeature(artistName):
  return artistName.split(' featuring')[0]

import pandas as pd 
bb = pd.read_csv("sourceData/billboard_yearly.csv")
#hotSpotify = pd.read_csv("sourceData/hotSpotify.csv") why is this broken 

#Set up the dataframes for each of our relations 
#the columns here are just the ones I have needed so far, add more as we go 
Song = pd.DataFrame(columns = ['songId', 'title', 'artist'], dtype = int)
BillboardChart = pd.DataFrame(columns = ['songId', 'chartYear', 'chartPosition'], dtype = int)
Genre = pd.DataFrame()
SongGenre = pd.DataFrame()


#CLEAN THE BILLBOARD DATA
bb = bb.sort_values(by = ['title', 'artist', 'year']) #sort by song (useful for removing duplicates)
bb = bb.reset_index(drop=True) 
bb = bb.drop("Unnamed: 0",axis=1)
print(bb)
print(bb.loc[0]['title'])

#extract everything relevant from bb
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

#TODO -> FIX HOTSPOTIFY READ CSV  

#TODO -> ASSOCIATE SONG W/ DATA FROM HOTSPOTIFY 

#TODO -> GENRES

print(Song)
BillboardChart = BillboardChart.sort_values(by = ["chartYear"])
print(BillboardChart)
  








