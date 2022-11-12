import requests
import os
from dotenv import load_dotenv
import pandas as pd
import firebase_admin
from firebase_admin import firestore, credentials
from datetime import datetime
import random

load_dotenv()

movie_genres = requests.get('https://api.themoviedb.org/3/genre/movie/list?api_key={}&language=en-US'.format(os.environ.get('MOVIE_API'))).json()
movie_genres = {genre['id']: genre['name'] for genre in movie_genres['genres']}
tv_genres = requests.get('https://api.themoviedb.org/3/genre/tv/list?api_key={}&language=en-US'.format(os.environ.get('MOVIE_API'))).json()
tv_genres = {genre['id']: genre['name'] for genre in tv_genres['genres']}

streaming_services = ['Netflix', 'Hulu', 'Prime Video', 'Disney+', 'HBO Max', 'Apple TV+']

def choose_streaming_services():
    return random.sample(streaming_services, random.randint(1, 4))


def append_url(image_path):
    return 'https://image.tmdb.org/t/p/w1280' + image_path if image_path else "null"


def get_genre(media_type, genre_id):
    if media_type == 'movie':
        return movie_genres[genre_id]
    elif media_type == 'tv':
        return tv_genres[genre_id]
    else:
        return 'null'

cred = credentials.Certificate('env/serviceAccountKey.json')
firebase_admin.initialize_app(cred)
db = firestore.client()

df_movies = pd.DataFrame()
df_shows = pd.DataFrame()

for page in range(1,10):
  r = requests.get('https://api.themoviedb.org/3/trending/movie/week?page={}&api_key={}'.format(page, os.environ.get('MOVIE_API')))
  json = r.json()['results']
  df = pd.json_normalize(json)
  df_movies = pd.concat([df_movies, df], ignore_index=True)

for page in range(1,10):
  r = requests.get('https://api.themoviedb.org/3/trending/tv/week?page={}&api_key={}'.format(page, os.environ.get('MOVIE_API')))
  json = r.json()['results']
  df = pd.json_normalize(json)
  df_shows = pd.concat([df_shows, df], ignore_index=True)

df_movies['poster_path'] = df_movies['poster_path'].apply(append_url)
df_shows['poster_path'] = df_shows['poster_path'].apply(append_url)

df_movies['backdrop_path'] = df_movies['backdrop_path'].apply(append_url)
df_shows['backdrop_path'] = df_shows['backdrop_path'].apply(append_url)

df_movies['genre_ids'] = df_movies['genre_ids'].apply(lambda x: [get_genre('movie', i) for i in x])
df_shows['genre_ids'] = df_shows['genre_ids'].apply(lambda x: [get_genre('tv', i) for i in x])

df_movies['release_date'] = df_movies['release_date'].apply(lambda x: datetime.strptime(x, '%Y-%m-%d'))
df_shows['first_air_date'] = df_shows['first_air_date'].apply(lambda x: datetime.strptime(x, '%Y-%m-%d'))

df_movies.drop(columns=['adult', 'id', 'video'], inplace=True)
df_shows.drop(columns=['adult', 'id', 'origin_country'], inplace=True)

df_shows.rename(columns={'name': 'title', 'original_name': 'original_title', 'first_air_date': 'release_date'}, inplace=True)

df_combined = pd.concat([df_movies, df_shows], ignore_index=True)

# Add a column for streaming services to each row in dataframe
df_combined['streaming_services'] = df_combined.apply(lambda x: choose_streaming_services(), axis=1)

df_combined.rename(columns={'genre_ids': 'genres'}, inplace=True)

df_combined.to_csv('titles.csv', index=False)

# Iterate through each row in the dataframe
for index, row in df_combined.iterrows():
    # Create a dictionary from the row
    data = row.to_dict()
    # Add the dictionary to the database
    db.collection('titles').document().set(data)
