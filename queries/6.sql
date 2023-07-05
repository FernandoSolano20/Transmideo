--6
SELECT d.title Titulo, EXTRACT(YEAR FROM d.begin_date) Lanzamiento, d.seasons Temporadas, COUNT(DISTINCT rd.id) Reproducciones
FROM documentary d
INNER JOIN documentary_language dl ON dl.documentary_id = d.id
INNER JOIN reproduction_documentary rd ON rd.documentary_language_id = dl.id
INNER JOIN client c ON c.id = rd.client_id
GROUP BY d.title, d.seasons, d.begin_date
ORDER BY Lanzamiento, Titulo;