--1
SELECT * FROM (
  SELECT 'Pelicula' Tipo, m.title Titulo, g.name Genero, EXTRACT(YEAR FROM m.year) Lanzamiento, c.name Pais, a.name Nombre, a.last_name Apellido
  FROM movie m
  INNER JOIN movie_genre mg ON mg.movie_id = m.id
  INNER JOIN genre g ON g.id = mg.genre_id
  INNER JOIN country c ON c.id = m.country_id
  INNER JOIN cast_movie cm ON cm.movie_id = m.id
  INNER JOIN artist a ON a.id = cm.artist_id
  INNER JOIN cast_movie_role cmr ON cmr.cast_movie_id = cm.id
  INNER JOIN role r ON r.id = cmr.role_id
  WHERE r.id = 3
  UNION
  SELECT 'Serie' Tipo, s.title Titulo, g.name Genero, EXTRACT(YEAR FROM s.begin_date) Lanzamiento, a.name Nombre, a.last_name Apellido
  FROM serie s
  INNER JOIN serie_genre sg ON sg.serie_id = s.id
  INNER JOIN genre g ON g.id = sg.genre_id
  INNER JOIN cast_serie cs ON cs.serie_id = s.id
  INNER JOIN artist a ON a.id = cs.artist_id
  INNER JOIN cast_serie_role csr ON csr.cast_serie_id = cs.id
  INNER JOIN role r ON r.id = csr.role_id
  WHERE r.id = 3
);

INNER JOIN country c ON c.id = s.country_id