CREATE OR REPLACE PROCEDURE Insert_Serie(
    title VARCHAR2,
    abstract VARCHAR2,
    begin_date Date,
    length NUMBER,
    seasons NUMBER,
    chapters NUMBER,
    rated_id NUMBER,
    country_id NUMBER,
    macroserie_id NUMBER DEFAULT NULL
  ) IS
  CURSOR max_id_serie_cursor IS
  SELECT MAX(id) FROM serie;
  last_id serie.id%TYPE := NULL;
BEGIN
  OPEN max_id_serie_cursor;
  FETCH max_id_serie_cursor INTO last_id;
  CLOSE max_id_serie_cursor;

  last_id := Get_Last_Id(last_id);

  INSERT INTO serie VALUES (last_id, title, abstract, begin_date, length, seasons, chapters, rated_id, macroserie_id, country_id);
  COMMIT;
END Insert_Serie;
/