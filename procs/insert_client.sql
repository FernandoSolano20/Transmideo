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
BEGIN
  OPEN max_id_client_cursor;
  FETCH max_id_client_cursor INTO last_id;
  CLOSE max_id_client_cursor;

  last_id := Get_Last_Id(last_id);

  INSERT INTO client VALUES (last_id, name, last_name, direction, phone, birth, email, SYSDATE, country_id, account_type_id);
  COMMIT;
END Insert_Client;
/