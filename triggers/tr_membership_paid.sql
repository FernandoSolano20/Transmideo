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

    DBMS_OUTPUT.PUT_LINE(SYSDATE);
    DBMS_OUTPUT.PUT_LINE('Max day' || expiration_day);
    IF expiration_day >= SYSDATE THEN
      DBMS_OUTPUT.PUT_LINE('Issue');
      RAISE_APPLICATION_ERROR(-20502,'Su membresia aun no ha expirado.');
    END IF;

    IF expiration_day <> NULL THEN
      UPDATE client
        SET account_status_id = 1
        WHERE id = :NEW.client_id;
    END IF;
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