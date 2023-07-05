--1
SELECT * FROM (
  SELECT 'Pelicula' Tipo, m.title Titulo,
  EXTRACT(YEAR FROM m.year) Lanzamiento,
  c.name Pais,
  (SELECT LISTAGG(g.name, ', ') WITHIN GROUP (ORDER BY g.name) FROM genre g
    INNER JOIN movie_genre mg ON mg.genre_id = g.id
    WHERE mg.movie_id = m.id
  ) Generos,
  (SELECT LISTAGG(a.name || ' ' || a.last_name, ', ') WITHIN GROUP (ORDER BY a.name || ' ' || a.last_name) FROM artist a
    INNER JOIN cast_movie cm ON cm.artist_id = a.id
    INNER JOIN cast_movie_role cmr ON cmr.cast_movie_id = cm.id
    WHERE cm.movie_id = m.id AND cmr.role_id = 3
  ) Directores
  FROM movie m
  INNER JOIN country c ON c.id = m.country_id
  UNION
  SELECT 'Serie' Tipo, s.title Titulo,
  EXTRACT(YEAR FROM s.begin_date) Lanzamiento,
  c.name Pais,
  (SELECT LISTAGG(g.name, ', ') WITHIN GROUP (ORDER BY g.name) FROM genre g
    INNER JOIN serie_genre sg ON sg.genre_id = g.id
    WHERE sg.serie_id = s.id
  ) Generos,
  (SELECT LISTAGG(a.name || ' ' || a.last_name, ', ') WITHIN GROUP (ORDER BY a.name || ' ' || a.last_name) FROM artist a
    INNER JOIN cast_serie cs ON cs.artist_id = a.id
    INNER JOIN cast_serie_role csr ON csr.cast_serie_id = cs.id
    WHERE cs.serie_id = s.id AND csr.role_id = 3
  ) Directores
  FROM serie s
  INNER JOIN country c ON c.id = s.country_id
);