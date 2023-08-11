CREATE OR REPLACE PROCEDURE Update_Client_Status(
  client NUMBER,
  client_status NUMBER
  ) IS
PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
  UPDATE client 
    SET account_status_id = client_status
    WHERE id = client;
  COMMIT;
END;
/