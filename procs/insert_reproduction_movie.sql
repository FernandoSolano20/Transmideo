CREATE OR REPLACE PROCEDURE Insert_Reproduction_Movie(
    movie_language_id NUMBER,
    client_id NUMBER
  ) IS
  CURSOR max_id_rm_cursor IS
  SELECT MAX(id) FROM reproduction_movie;
  last_id reproduction_movie.id%TYPE := NULL;

  foreign_violated EXCEPTION;
  PRAGMA EXCEPTION_INIT(foreign_violated, -2291);
BEGIN
  OPEN max_id_rm_cursor;
  FETCH max_id_rm_cursor INTO last_id;
  CLOSE max_id_rm_cursor;

  last_id := Get_Last_Id(last_id);

  INSERT INTO reproduction_movie VALUES (last_id, SYSDATE, 0, client_id, 1, movie_language_id);
  COMMIT;

  EXCEPTION
    WHEN foreign_violated THEN
      ROLLBACK;
      DBMS_OUTPUT.PUT_LINE('El un error con las llaves foraneas al insertar.');
    WHEN OTHERS THEN
      ROLLBACK;
      DBMS_OUTPUT.PUT_LINE('Ocurrio un error.');
END Insert_Reproduction_Movie;
/