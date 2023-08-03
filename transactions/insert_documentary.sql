CREATE OR REPLACE PROCEDURE Insert_Documentary(
    title VARCHAR2,
    abstract VARCHAR2,
    begin_date Date,
    length NUMBER,
    seasons NUMBER,
    chapters NUMBER,
    rated_id NUMBER,
    docuserie_id NUMBER DEFAULT NULL
  ) IS
  CURSOR max_id_documentary_cursor IS
  SELECT MAX(id) FROM documentary;
  last_id documentary.id%TYPE := NULL;
BEGIN
  OPEN max_id_documentary_cursor;
  FETCH max_id_documentary_cursor INTO last_id;
  CLOSE max_id_documentary_cursor;

  last_id := Get_Last_Id(last_id);

  INSERT INTO documentary VALUES (last_id, title, abstract, begin_date, length, seasons, chapters, rated_id, docuserie_id);
  COMMIT;
END Insert_Documentary;
/