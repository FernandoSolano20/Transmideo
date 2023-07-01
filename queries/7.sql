SELECT * FROM (
  SELECT 'Pelicula' Tipo, m.title Titulo, EXTRACT(YEAR FROM m.year) Lazamiento, m.length Duracion, COUNT(1) Descargas, MAX(dm.begin_date) "ULT. DESC."
  FROM download_movie dm
  INNER JOIN movie_language ml ON ml.id = dm.movie_language_id
  INNER JOIN movie m ON m.id = ml.movie_id
  GROUP BY m.title, m.year, m.length
  UNION
  SELECT 'Serie' Tipo, s.title Titulo, EXTRACT(YEAR FROM s.begin_date) Lazamiento, s.length Duracion, COUNT(1) Descargas, MAX(ds.begin_date) "ULT. DESC."
  FROM download_serie ds
  INNER JOIN serie_language sl ON sl.id = ds.serie_language_id
  INNER JOIN serie s ON s.id = sl.serie_id
  GROUP BY s.title, s.begin_date, s.length
  UNION
  SELECT 'Documental' Tipo, d.title Titulo, EXTRACT(YEAR FROM d.begin_date) Lazamiento, d.length Duracion, COUNT(1) Descargas, MAX(dd.begin_date) "ULT. DESC."
  FROM download_documentary dd
  INNER JOIN documentary_language dl ON dl.id = dd.documentary_language_id
  INNER JOIN documentary d ON d.id = dl.documentary_id
  GROUP BY d.title, d.begin_date, d.length
)
ORDER BY Descargas DESC;