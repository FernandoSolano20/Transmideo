--4
SELECT m.title Titulo, g.name Genero, EXTRACT(YEAR FROM m.year) Lanzamiento, COUNT(DISTINCT rm.id) "Conteo Peliculas"
FROM movie m
INNER JOIN movie_genre mg ON mg.movie_id = m.id
INNER JOIN genre g ON g.id = mg.genre_id
INNER JOIN movie_language ml ON ml.movie_id = m.id
INNER JOIN reproduction_movie rm ON rm.movie_language_id = ml.id
INNER JOIN client c ON c.id = rm.client_id
GROUP BY m.title, g.name, m.year;