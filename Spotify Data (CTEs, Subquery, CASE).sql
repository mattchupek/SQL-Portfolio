/*
For this project, I downloaded Spotify data from Kaggle and created a table to insert Spotify data into. 

I then performed analysis of this data showcasing my knowledge of CTEs, CASE functions, subqueries, aggregates, and more.
*/

--Creating the table: 
CREATE TABLE BIT_DB.Spotifydata (
    id INTEGER PRIMARY KEY,
    artist_name VARCHAR(255) NOT NULL,
    track_name VARCHAR(255) NOT NULL,
    track_id VARCHAR(255) NOT NULL,
    popularity INTEGER NOT NULL,
    danceability DECIMAL(4,3) NOT NULL,
    energy DECIMAL(4,3) NOT NULL,
    key INTEGER NOT NULL,
    loudness DECIMAL(5,3) NOT NULL,
    mode INTEGER NOT NULL,
    speechiness DECIMAL(5,4) NOT NULL,
    acousticness DECIMAL(6,5) NOT NULL,
    instrumentalness TEXT NOT NULL,
    liveness DECIMAL(5,4) NOT NULL,
    valence DECIMAL(4,3) NOT NULL,
    tempo DECIMAL(6,3) NOT NULL,
    duration_ms INTEGER NOT NULL,
    time_signature INTEGER NOT NULL
);
  --Then I inserted the Spotify Data.csv into the table
  --Next, I explored the data answering the following questions:

--Q1.(CTE) Find the most danceable tracks from each artist.
WITH max_danceability AS (
    SELECT 
        artist_name, 
        MAX(danceability) as max_danceability
    FROM 
        BIT_DB.Spotifydata
    GROUP BY 
        artist_name
),
most_danceable_tracks AS (
    SELECT 
        md.artist_name, 
        s.track_name, 
        md.max_danceability
    FROM 
        max_danceability md
    JOIN 
        BIT_DB.Spotifydata s 
    ON 
        md.artist_name = s.artist_name AND md.max_danceability = s.danceability
)
SELECT * FROM most_danceable_tracks;

--Q2.(CTE) Find average popularity of tracks from each artist.
WITH artist_popularity AS (
    SELECT 
        artist_name, 
        AVG(popularity) as avg_popularity
    FROM 
        BIT_DB.Spotifydata
    GROUP BY 
        artist_name
)
SELECT * FROM artist_popularity;


--Q3.(CASE FUNCTION) Print 'Popular' for artists with popularity of 90 or more, 'Well Known' for 70-89 and 'Unpopular' for 69 and below.
SELECT 
  artist_name
  ,popularity
  ,CASE 
      WHEN popularity >=90 THEN 'Popular' 
      WHEN popularity BETWEEN 70 AND 89 THEN 'Well Known'
      ELSE 'Unpopular'
  END Rank
FROM BIT_DB.Spotifydata
GROUP BY artist_name
ORDER BY popularity desc;

--Q4.(SUBQUERY) Determine which artists had a popularity lower than the average.
SELECT 
  artist_name, 
  popularity
FROM BIT_DB.Spotifydata
WHERE popularity < (
    SELECT avg(popularity)
    FROM spotifydata
    )
ORDER BY popularity desc;

--Q5.(AGGREGATE) Determine the avg popularity, danceability, and energy by artist and track. 
SELECT
  artist_name
  ,track_name
  ,AVG(popularity)
  ,AVG(danceability)
  ,AVG(energy)
FROM BIT_DB.spotifydata
GROUP BY artist_name, track_name;

--Q6.(AGGREGATE) Determine what song has the highest danceability.
SELECT 
  artist_name
  ,track_name
  ,AVG(danceability)
FROM BIT_DB.spotifydata
GROUP BY artist_name, track_name
ORDER BY AVG(danceability) DESC;

--Q7. Determine what the longest song is.
SELECT 
  artist_name
  ,track_name
FROM BIT_DB.spotifydata
ORDER BY duration_ms DESC LIMIT 1;
