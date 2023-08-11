CREATE OR REPLACE PROCEDURE Insert_Membership(
    price NUMBER,
    client_id NUMBER
  ) IS
  CURSOR max_id_membership_cursor IS
  SELECT MAX(id) FROM membership;
  last_id membership.id%TYPE := NULL;

  foreign_violated EXCEPTION;
  PRAGMA EXCEPTION_INIT(foreign_violated, -2291);
  not_expired_membership EXCEPTION;
  PRAGMA EXCEPTION_INIT(not_expired_membership, -20503);
BEGIN
  OPEN max_id_membership_cursor;
  FETCH max_id_membership_cursor INTO last_id;
  CLOSE max_id_membership_cursor;

  last_id := Get_Last_Id(last_id);

  INSERT INTO membership VALUES (last_id, ADD_MONTHS(SYSDATE, 12), price, client_id);
  COMMIT;
  DBMS_OUTPUT.PUT_LINE('Membresia pagada con existo.');

  EXCEPTION
    WHEN foreign_violated THEN
      ROLLBACK;
      DBMS_OUTPUT.PUT_LINE('Ocurrio un error el id del client no existe, no se realizo la transaccion.');
    WHEN not_expired_membership THEN
      ROLLBACK;
      DBMS_OUTPUT.PUT_LINE('Su membresia no ha expirado aun, no se realizo la transaccion.');
    WHEN OTHERS THEN
      ROLLBACK;
      DBMS_OUTPUT.PUT_LINE('Ocurrio un error, no se realizo la transaccion.');
END Insert_Membership;
/