CREATE OR REPLACE PROCEDURE Insert_Membership(
    price NUMBER,
    client_id NUMBER
  ) IS
  CURSOR max_id_membership_cursor IS
  SELECT MAX(id) FROM membership;
  last_id membership.id%TYPE := NULL;
BEGIN
  OPEN max_id_membership_cursor;
  FETCH max_id_membership_cursor INTO last_id;
  CLOSE max_id_membership_cursor;

  last_id := Get_Last_Id(last_id);

  INSERT INTO membership VALUES (last_id, ADD_MONTHS(SYSDATE, 12), price, client_id);
  COMMIT;
END Insert_Membership;
/