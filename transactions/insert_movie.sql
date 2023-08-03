CREATE OR REPLACE PROCEDURE Insert_Movie(
    title VARCHAR2,
    year Date,
    length NUMBER,
    country_id NUMBER,
    studio_id NUMBER,
    rated_id NUMBER,
    saga_id NUMBER DEFAULT NULL
  ) IS
  CURSOR max_id_movie_cursor IS
  SELECT MAX(id) FROM movie;
  last_id movie.id%TYPE := NULL;
BEGIN
  OPEN max_id_movie_cursor;
  FETCH max_id_movie_cursor INTO last_id;
  CLOSE max_id_movie_cursor;

  last_id := Get_Last_Id(last_id);

  INSERT INTO movie VALUES (last_id, title, year, length, country_id, studio_id, rated_id, saga_id);
  COMMIT;
END Insert_Movie;
/