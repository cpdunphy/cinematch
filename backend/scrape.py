import requests
import os
from dotenv import load_dotenv
import pandas as pd
import firebase_admin
from firebase_admin import firestore, credentials

def append_url(image_path):
    return 'https://image.tmdb.org/t/p/w1280' + image_path if image_path else "null"

cred = credentials.Certificate('env/serviceAccountKey.json')
firebase_admin.initialize_app(cred)
db = firestore.client()

load_dotenv()

df_movies = pd.DataFrame()
df_shows = pd.DataFrame()

for page in range(1,10):
  r = requests.get('https://api.themoviedb.org/3/trending/movie/week?page={}&api_key={}'.format(page, os.environ.get('MOVIE_API')))
  json = r.json()['results']
  df = pd.json_normalize(json)
  df_movies = pd.concat([df_movies, df], ignore_index=True)

for page in range(1,10):
  r = requests.get('https://api.themoviedb.org/3/trending/tv/week?page={}&api_key={}'.format(page, os.environ.get('MOVIE_API')))
  print(r.json()['results'])
  json = r.json()['results']
  df = pd.json_normalize(json)
  df_shows = pd.concat([df_shows, df], ignore_index=True)

df_movies['poster_path'] = df_movies['poster_path'].apply(append_url)
df_shows['poster_path'] = df_shows['poster_path'].apply(append_url)

df_movies['backdrop_path'] = df_movies['backdrop_path'].apply(append_url)
df_shows['backdrop_path'] = df_shows['backdrop_path'].apply(append_url)

df_movies.drop(columns=['adult', 'id', 'video'], inplace=True)
df_shows.drop(columns=['adult', 'id', 'origin_country'], inplace=True)

df_shows.rename(columns={'name': 'title', 'original_name': 'original_title', 'first_air_date': 'release_date'}, inplace=True)

df_combined = pd.concat([df_movies, df_shows], ignore_index=True)

df_combined.to_csv('titles.csv', index=False)

# Iterate through each row in the dataframe
for index, row in df_combined.iterrows():
    # Create a dictionary from the row
    data = row.to_dict()
    # Add the dictionary to the database
    db.collection('titles').document().set(data)
