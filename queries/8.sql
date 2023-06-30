SELECT name, last_name, inclusion, SUM(downloads), SUM(repro), MAX(last_reproduction), last_movie_title
FROM (
  SELECT c.id, c.name, c.last_name, c.inclusion,
  COUNT(DISTINCT CASE WHEN dm.client_id = c.id THEN dm.id END) downloads,
  COUNT(DISTINCT CASE WHEN rm.client_id = c.id THEN rm.id END) repro,
  MAX(rm.begin_date) last_reproduction
  FROM client c
  LEFT JOIN download_movie dm ON dm.client_id = c.id
  LEFT JOIN reproduction_movie rm ON rm.client_id = c.id
  GROUP BY c.id, c.name, c.last_name, c.inclusion
  UNION
  SELECT c.id, c.name, c.last_name, c.inclusion,
  COUNT(DISTINCT CASE WHEN ds.client_id = c.id THEN ds.id END) downloads, 0,
  MAX(rs.begin_date) last_reproduction
  FROM client c
  LEFT JOIN download_serie ds ON ds.client_id = c.id
  LEFT JOIN reproduction_serie rs ON rs.client_id = c.id
  GROUP BY c.id, c.name, c.last_name, c.inclusion
  UNION
  SELECT c.id, c.name, c.last_name, c.inclusion,
  COUNT(DISTINCT CASE WHEN dd.client_id = c.id THEN dd.id END) downloads, 0,
  MAX(rd.begin_date) last_reproduction
  FROM client c
  LEFT JOIN download_documentary dd ON dd.client_id = c.id
  LEFT JOIN reproduction_documentary rd ON rd.client_id = c.id
  GROUP BY c.id, c.name, c.last_name, c.inclusion
) t
LEFT JOIN (
  SELECT rm.client_id, m.title AS last_movie_title
  FROM reproduction_movie rm
  INNER JOIN movie_language ml ON ml.id = rm.movie_language_id
  INNER JOIN movie m ON m.id = ml.movie_id
  WHERE rm.begin_date = (
    SELECT MAX(rm_inner.begin_date)
    FROM reproduction_movie rm_inner
    WHERE rm_inner.client_id = rm.client_id
  )
) r ON r.client_id = t.id
GROUP BY name, last_name, inclusion, last_movie_title;