--3
SELECT c.name Nombre, c.last_name Apellidos, COUNT(DISTINCT rd.id) Documentales, COUNT(DISTINCT rm.id) Peliculas, COUNT(DISTINCT rs.id) Series
FROM client c
INNER JOIN reproduction_documentary rd ON rd.client_id = c.id
INNER JOIN reproduction_movie rm ON rm.client_id = c.id
INNER JOIN reproduction_serie rs ON rs.client_id = c.id
GROUP BY c.name, c.last_name;