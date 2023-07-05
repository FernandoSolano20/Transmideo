--2
SELECT * FROM (
  SELECT 'Serie' Tipo, s.title Titulo,
  EXTRACT(YEAR FROM s.begin_date) Lanzamiento,
  s.seasons Temporadas,
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
  UNION
  SELECT 'Documental' Tipo, d.title Titulo,
  EXTRACT(YEAR FROM d.begin_date) Lanzamiento,
  d.seasons Temporadas,
  (SELECT LISTAGG(g.name, ', ') WITHIN GROUP (ORDER BY g.name) FROM genre g
    INNER JOIN documentary_genre dg ON dg.genre_id = g.id
    WHERE dg.documentary_id = d.id
  ) Generos,
  (SELECT LISTAGG(a.name || ' ' || a.last_name, ', ') WITHIN GROUP (ORDER BY a.name || ' ' || a.last_name) FROM artist a
    INNER JOIN cast_documentary cd ON cd.artist_id = a.id
    INNER JOIN cast_documentary_role cdr ON cdr.cast_documentary_id = cd.id
    WHERE cd.documentary_id = d.id AND cdr.role_id = 3
  ) Directores
  FROM documentary d
);