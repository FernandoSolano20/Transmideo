CREATE OR REPLACE TRIGGER insert_reproduction_serie_trg
BEFORE INSERT ON reproduction_serie
FOR EACH ROW
DECLARE
  CURSOR client_cursor IS
  SELECT MAX(m.expiration_day), c.account_status_id
  FROM membership m
  INNER JOIN client c ON c.id = m.client_id
  WHERE client_id = :NEW.client_id
  GROUP BY c.account_status_id;

  max_expiration_day DATE;
  account_status NUMBER;
BEGIN
  OPEN client_cursor;
  FETCH client_cursor INTO max_expiration_day, account_status;
  CLOSE client_cursor;

  IF max_expiration_day < SYSDATE OR account_status = 2 THEN
    IF account_status = 1 THEN
      Update_Client_Status(:NEW.client_id, 2);
    END IF;
    RAISE_APPLICATION_ERROR(-20502,'Su membresia ha expirado.');
  END IF;
END;
/