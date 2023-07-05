--5
SELECT s.title Titulo, EXTRACT(YEAR FROM s.begin_date) Lanzamiento, s.seasons Temporadas, COUNT(DISTINCT rs.id) Reproducciones
FROM serie s
INNER JOIN serie_language sl ON sl.serie_id = s.id
INNER JOIN reproduction_serie rs ON rs.serie_language_id = sl.id
INNER JOIN client c ON c.id = rs.client_id
GROUP BY s.title, s.seasons, s.begin_date
ORDER BY Lanzamiento, Titulo;