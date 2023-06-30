SELECT * FROM (
  SELECT 'Pelicula' Tipo, m.title Titulo, m.year Lazamiento, m.length Duracion, MAX(dm.day) "ULT. DESC.", COUNT(1) Descargas 
  FROM download_movie dm
  INNER JOIN movie_language ml ON ml.id = dm.movie_language_id
  INNER JOIN movie m ON m.id = ml.movie_id
  GROUP BY m.title, m.year, m.length
  UNION
  SELECT 'Serie' Tipo, s.title Titulo, s.begin_date Lazamiento, 10 Duracion, MAX(ds.begin_date) "ULT. DESC.", COUNT(1) Descargas 
  FROM download_serie ds
  INNER JOIN serie_language sl ON sl.id = ds.serie_language_id
  INNER JOIN serie s ON s.id = sl.serie_id
  GROUP BY s.title, s.begin_date, 10
  UNION
  SELECT 'Documental' Tipo, d.title Titulo, d.begin_date Lazamiento, 10 Duracion, MAX(dd.begin_date) "ULT. DESC.", COUNT(1) Descargas 
  FROM download_documentary dd
  INNER JOIN documentary_language dl ON dl.id = dd.documentary_language_id
  INNER JOIN documentary d ON d.id = dl.documentary_id
  GROUP BY d.title, d.begin_date, 10
)
ORDER BY Descargas DESC;