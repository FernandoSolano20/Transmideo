CREATE OR REPLACE PROCEDURE Insert_Client(
    name VARCHAR2,
    last_name VARCHAR2,
    direction VARCHAR2,
    phone VARCHAR2,
    birth Date,
    email VARCHAR2,
    country_id NUMBER,
    account_type_id NUMBER
  ) IS
  CURSOR max_id_client_cursor IS
  SELECT MAX(id) FROM client;
  last_id client.id%TYPE := NULL;

  foreign_violated EXCEPTION;
  PRAGMA EXCEPTION_INIT(foreign_violated, -2291);
BEGIN
  OPEN max_id_client_cursor;
  FETCH max_id_client_cursor INTO last_id;
  CLOSE max_id_client_cursor;

  last_id := Get_Last_Id(last_id);

  INSERT INTO client VALUES (last_id, name, last_name, direction, phone, birth, email, SYSDATE, country_id, account_type_id, 2);
  COMMIT;

  EXCEPTION
    WHEN foreign_violated THEN
      DBMS_OUTPUT.PUT_LINE('Ocurrio un error al insertar al cliente con las llaves foraneas.');
      ROLLBACK;
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('Ocurrio un error.');
      ROLLBACK;
END Insert_Client;
/