CREATE OR REPLACE PROCEDURE Insert_Reproduction_Movie(
    movie_language_id NUMBER,
    client_id NUMBER
  ) IS
  CURSOR max_id_rm_cursor IS
  SELECT MAX(id) FROM reproduction_movie;
  last_id reproduction_movie.id%TYPE := NULL;

  foreign_violated EXCEPTION;
  PRAGMA EXCEPTION_INIT(foreign_violated, -2291);
  expired_membership EXCEPTION;
  PRAGMA EXCEPTION_INIT(expired_membership, -20502);
  inactive_client EXCEPTION;
  PRAGMA EXCEPTION_INIT(inactive_client, -20501);
  not_pay_yet EXCEPTION;
  PRAGMA EXCEPTION_INIT(inactive_client, -20504);
BEGIN
  OPEN max_id_rm_cursor;
  FETCH max_id_rm_cursor INTO last_id;
  CLOSE max_id_rm_cursor;

  last_id := Get_Last_Id(last_id);

  INSERT INTO reproduction_movie VALUES (last_id, SYSDATE, 0, client_id, 1, movie_language_id);
  COMMIT;
  DBMS_OUTPUT.PUT_LINE('Solictud de reproduccion creada con existo.');

  EXCEPTION
    WHEN foreign_violated THEN
      ROLLBACK;
      DBMS_OUTPUT.PUT_LINE('Error con las llaves foraneas al insertar, no se ha procesado la solicitud de reproduccion.');
    WHEN expired_membership THEN
      ROLLBACK;
      DBMS_OUTPUT.PUT_LINE('Su membresia ha expirado, no se ha procesado la solicitud de reproduccion.');
    WHEN inactive_client THEN
      DBMS_OUTPUT.PUT_LINE('El cliente esta inactivo, no se ha procesado la solicitud de reproduccion.');
    WHEN not_pay_yet THEN
      DBMS_OUTPUT.PUT_LINE('El cliente no ha echo su primer pago, no se ha procesado la solicitud de reproduccion.');
    WHEN OTHERS THEN
      ROLLBACK;
      DBMS_OUTPUT.PUT_LINE('Ocurrio un error, no se ha procesado la solicitud de reproduccion.');
END Insert_Reproduction_Movie;
/