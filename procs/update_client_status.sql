CREATE OR REPLACE PROCEDURE Update_Client_Status(
  client NUMBER,
  client_status NUMBER
  ) IS
  PRAGMA AUTONOMOUS_TRANSACTION;
  foreign_violated EXCEPTION;
  PRAGMA EXCEPTION_INIT(foreign_violated, -2291);
BEGIN
  UPDATE client 
    SET account_status_id = client_status
    WHERE id = client;
  COMMIT;
  
  EXCEPTION
    WHEN foreign_violated THEN
      ROLLBACK;
      DBMS_OUTPUT.PUT_LINE('Ocurrio un error el estado no existe.');
    WHEN OTHERS THEN
      ROLLBACK;
      DBMS_OUTPUT.PUT_LINE('Ocurrio un error.');
END;
/