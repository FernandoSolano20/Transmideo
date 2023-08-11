CREATE OR REPLACE TRIGGER on_membership_paid_trg
  FOR INSERT ON membership
  COMPOUND TRIGGER

    CURSOR client_cursor IS
    SELECT MAX(m.expiration_day), c.id
    FROM membership m
    INNER JOIN client c ON c.id = m.client_id
    GROUP BY c.id;
    max_expiration_day DATE;
    client NUMBER;

    expiration_day DATE := NULL;    
  BEFORE STATEMENT IS
  BEGIN
    OPEN client_cursor;
  END BEFORE STATEMENT;

  BEFORE EACH ROW IS
  BEGIN
    LOOP
      FETCH client_cursor INTO max_expiration_day, client;
      IF client = :NEW.client_id THEN
        expiration_day := max_expiration_day;
      END IF;
      EXIT WHEN client = :NEW.client_id OR client_cursor%NOTFOUND;
    END LOOP;

    IF expiration_day >= SYSDATE THEN
      RAISE_APPLICATION_ERROR(-20503,'Su membresia aun no ha expirado.');
    END IF;

    transmideo.Update_Client_Status(:NEW.client_id, 1);
  END BEFORE EACH ROW;


  AFTER EACH ROW IS
  BEGIN
    NULL;
  END AFTER EACH ROW;


  AFTER STATEMENT IS
  BEGIN
    CLOSE client_cursor;
  END AFTER STATEMENT;
END on_membership_paid_trg;
/