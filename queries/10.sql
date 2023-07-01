SELECT g.name Genero,
COUNT(DISTINCT m.id) Peliculas,
COUNT(DISTINCT s.id) Series,
EXTRACT(YEAR FROM MIN(m.year)) "PRIMER PELICULA",
EXTRACT(YEAR FROM MIN(s.begin_date)) "PRIMER SERIE"
FROM genre g
LEFT JOIN movie_genre mg ON mg.genre_id = g.id
LEFT JOIN movie m ON m.id = mg.movie_id
LEFT JOIN serie_genre sg ON sg.genre_id = g.id
LEFT JOIN serie s ON s.id = sg.serie_id
GROUP BY g.name
ORDER BY MIN(m.year) ASC;