WITH movie_genres_cte AS (
  SELECT mg.movie_id, LISTAGG(g.name, ', ') WITHIN GROUP (ORDER BY g.name) AS generos
  FROM movie_genre mg
  INNER JOIN genre g ON g.id = mg.genre_id
  GROUP BY mg.movie_id
)
SELECT
  m.title AS Titulo,
  EXTRACT(YEAR FROM m.year) AS Lanzamiento,
  mgc.generos AS Generos,
  COUNT(DISTINCT rm.id) AS Reproducciones
FROM movie m
INNER JOIN movie_language ml ON ml.movie_id = m.id
INNER JOIN reproduction_movie rm ON rm.movie_language_id = ml.id
INNER JOIN client c ON c.id = rm.client_id
LEFT JOIN movie_genres_cte mgc ON mgc.movie_id = m.id
GROUP BY m.title, mgc.generos, EXTRACT(YEAR FROM m.year);
