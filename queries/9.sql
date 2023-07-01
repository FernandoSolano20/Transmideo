SELECT ROWNUM Top, r.* FROM (
  SELECT Titulo, Tipo, Reproducciones, Descargas, last_reproduction "ULT. REPR.", last_download "ULT. DESC." FROM (
    SELECT 'Pelicula' Tipo, m.title Titulo, 
      COUNT(DISTINCT dm.id) Descargas,
      COUNT(DISTINCT rm.id) Reproducciones,
      MAX(rm.begin_date) last_reproduction,
      MAX(dm.begin_date) last_download,
      COUNT(DISTINCT dm.id) + COUNT(DISTINCT rm.id) Total
      FROM movie m
      LEFT JOIN movie_language ml ON ml.movie_id = m.id
      LEFT JOIN download_movie dm ON dm.movie_language_id = ml.id
      LEFT JOIN reproduction_movie rm ON rm.movie_language_id = ml.id
      HAVING COUNT(DISTINCT dm.id) > 0 OR COUNT(DISTINCT rm.id) > 0
      GROUP BY m.title
    UNION
    SELECT 'Serie' Tipo, s.title Titulo,
      COUNT(DISTINCT ds.id) Descargas,
      COUNT(DISTINCT rs.id) Reproducciones,
      MAX(rs.begin_date) last_reproduction,
      MAX(ds.begin_date) last_download,
      COUNT(DISTINCT ds.id) + COUNT(DISTINCT rs.id) Total
      FROM serie s
      LEFT JOIN serie_language sl ON sl.serie_id = s.id
      LEFT JOIN download_serie ds ON ds.serie_language_id = sl.id
      LEFT JOIN reproduction_serie rs ON rs.serie_language_id = sl.id
      HAVING COUNT(DISTINCT ds.id) > 0 OR COUNT(DISTINCT rs.id) > 0
      GROUP BY s.title
    UNION
    SELECT 'Documental' Tipo, d.title Titulo,
      COUNT(DISTINCT dd.id) Descargas,
      COUNT(DISTINCT rd.id) Reproducciones,
      MAX(rd.begin_date) last_reproduction,
      MAX(dd.begin_date) last_download,
      COUNT(DISTINCT dd.id) + COUNT(DISTINCT rd.id) Total
      FROM documentary d
      LEFT JOIN documentary_language dl ON dl.documentary_id = d.id
      LEFT JOIN download_documentary dd ON dd.documentary_language_id = dl.id
      LEFT JOIN reproduction_documentary rd ON rd.documentary_language_id = dl.id
      GROUP BY d.title
  )
  ORDER BY Total DESC
) r
WHERE ROWNUM <= 10;