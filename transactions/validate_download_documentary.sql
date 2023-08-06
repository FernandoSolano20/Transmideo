CREATE OR REPLACE TRIGGER insert_download_doc_trg
BEFORE INSERT ON download_documentary
FOR EACH ROW
DECLARE
  CURSOR client_cursor IS
  SELECT MAX(expiration_day)
  FROM membership
  WHERE client_id = :NEW.client_id;
  max_expiration_day DATE;
BEGIN
  OPEN client_cursor;
  FETCH client_cursor INTO max_expiration_day;
  CLOSE client_cursor;

  IF max_expiration_day < SYSDATE THEN
    RAISE_APPLICATION_ERROR(-20502,'Su membresia ha expirado.');
  END IF;
END;
/