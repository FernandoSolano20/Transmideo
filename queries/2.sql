--2
SELECT * FROM (
  SELECT 'Serie' Tipo, s.title Titulo, g.name Genero, EXTRACT(YEAR FROM s.begin_date) Lanzamiento, s.seasons Temporadas, a.name Nombre, a.last_name Apellido
  FROM serie s
  INNER JOIN serie_genre sg ON sg.serie_id = s.id
  INNER JOIN genre g ON g.id = sg.genre_id
  INNER JOIN cast_serie cs ON cs.serie_id = s.id
  INNER JOIN artist a ON a.id = cs.artist_id
  INNER JOIN cast_serie_role csr ON csr.cast_serie_id = cs.id
  INNER JOIN role r ON r.id = csr.role_id
  WHERE r.id = 3
  UNION
  SELECT 'Documental' Tipo, d.title Titulo, g.name Genero, EXTRACT(YEAR FROM d.begin_date) Lanzamiento, d.seasons Temporadas, a.name Nombre, a.last_name Apellido
  FROM documentary d
  INNER JOIN documentary_genre dg ON dg.documentary_id = d.id
  INNER JOIN genre g ON g.id = dg.genre_id
  INNER JOIN cast_documentary cd ON cd.documentary_id = d.id
  INNER JOIN artist a ON a.id = cd.artist_id
  INNER JOIN cast_documentary_role cdr ON cdr.cast_documentary_id = cd.id
  INNER JOIN role r ON r.id = cdr.role_id
  WHERE r.id = 3
);