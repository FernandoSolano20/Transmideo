CREATE OR REPLACE PROCEDURE Update_Client_Status(
  client_id NUMBER,
  client_status NUMBER
  ) IS
  PRAGMA AUTONOMOUS_TRANSACTION;
  foreign_violated EXCEPTION;
  PRAGMA EXCEPTION_INIT(foreign_violated, -2291);

  CURSOR status_cursor IS
  SELECT status
  FROM account_status
  where id = client_status;
  status_name account_status.status%TYPE := NULL;
  client_name client.name%TYPE := NULL;

BEGIN
  OPEN status_cursor;
  FETCH status_cursor INTO status_name;
  CLOSE status_cursor;

  SELECT c.name into client_name
  FROM client c
  where c.id = client_id;
  
  UPDATE client 
    SET account_status_id = client_status
    WHERE id = client_id;
  COMMIT;
  DBMS_OUTPUT.PUT_LINE('El cliente ' || client_name || ' ahora esta ' || status_name);
  
  EXCEPTION
    WHEN foreign_violated THEN
      ROLLBACK;
      DBMS_OUTPUT.PUT_LINE('Ocurrio un error el estado no existe, no se realizo la transaccion.');
    WHEN NO_DATA_FOUND THEN
      ROLLBACK;
      DBMS_OUTPUT.PUT_LINE('No se encontro al cliente, no se realizo la transaccion.');
    WHEN OTHERS THEN
      ROLLBACK;
      DBMS_OUTPUT.PUT_LINE('Ocurrio un error, no se realizo la transaccion.');
END;
/