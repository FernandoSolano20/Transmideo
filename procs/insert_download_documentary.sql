CREATE OR REPLACE PROCEDURE Insert_Download_Doc(
    documentary_language_id NUMBER,
    client_id NUMBER
  ) IS
  CURSOR max_id_rm_cursor IS
  SELECT MAX(id) FROM download_documentary;
  last_id download_documentary.id%TYPE := NULL;

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

  INSERT INTO download_documentary VALUES (last_id, SYSDATE, 0, client_id, 1, documentary_language_id);
  COMMIT;
  DBMS_OUTPUT.PUT_LINE('Solictud de descarga creada con existo.');

  EXCEPTION
    WHEN foreign_violated THEN
      ROLLBACK;
      DBMS_OUTPUT.PUT_LINE('Error con las llaves foraneas al insertar, no se ha procesado la solicitud de descarga.');
    WHEN expired_membership THEN
      ROLLBACK;
      DBMS_OUTPUT.PUT_LINE('Su membresia ha expirado, no se ha procesado la solicitud de descarga.');
    WHEN inactive_client THEN
      DBMS_OUTPUT.PUT_LINE('El cliente esta inactivo, no se ha procesado la solicitud de descarga.');
    WHEN not_pay_yet THEN
      DBMS_OUTPUT.PUT_LINE('El cliente no ha echo su primer pago, no se ha procesado la solicitud de descarga.');
    WHEN OTHERS THEN
      ROLLBACK;
      DBMS_OUTPUT.PUT_LINE('Ocurrio un error.');
END Insert_Download_Doc;
/