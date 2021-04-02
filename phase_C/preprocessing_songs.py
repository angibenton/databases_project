import pandas as pd

#empty dataframe analogous to the Songs relation 
Songs = pd.DataFrame()

#SPOTIFY ATTRIBUTES


songs_by_year = pd.read_csv("sourceData/spotify_songs_by_year.csv") 
print(songs_by_year) 
#ue_monthly_noyear = ue_monthly.drop(columns = ['Year']) #take off the year for averaging 
Songs['releasedDate'] = songs_by_year['year']
Songs['acousticness'] = songs_by_year['acousticness']
Songs['danceability'] = songs_by_year['danceability']
Songs['energy'] = songs_by_year['instrumentalness']
Songs['liveness'] = songs_by_year['liveness']
Songs['loudness'] = songs_by_year['loudness']
Songs['speechiness'] = songs_by_year['speechiness']
Songs['tempo'] = songs_by_year['tempo']

# ARTIST NAME

#ARTIST NAME  
songs_with_artists = pd.read_csv("sourceData/spotify_songs.csv")
print(songs_with_artists) 
Songs['artist'] = songs_with_artists['artists']
Songs['key'] = songs_with_artists['key']
Songs['explicit'] = songs_with_artists['explicit']

#GENRE

songs_with_genres = pd.read_csv("sourceData/songs_by_genres.csv")
print(songs_with_artists)
Songs['genre'] = songs_with_genres['genres']


#export to a text file with no row numbers, and 4 decimal places 
Songs.to_csv("Songs.txt", index = False, float_format = "%.4f") 

#TODO: get the 8-15 row subset of econHealth for EconomicHealth-small.txt






print(Songs)