CREATE OR REPLACE PROCEDURE Insert_Download_Movie(
    movie_language_id NUMBER,
    client_id NUMBER
  ) IS
  CURSOR max_id_rm_cursor IS
  SELECT MAX(id) FROM download_movie;
  last_id download_movie.id%TYPE := NULL;
BEGIN
  OPEN max_id_rm_cursor;
  FETCH max_id_rm_cursor INTO last_id;
  CLOSE max_id_rm_cursor;

  last_id := Get_Last_Id(last_id);

  INSERT INTO download_movie VALUES (last_id, SYSDATE, 0, client_id, 1, movie_language_id);
  COMMIT;
END Insert_Download_Movie;
/