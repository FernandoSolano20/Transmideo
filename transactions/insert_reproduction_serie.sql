CREATE OR REPLACE PROCEDURE Insert_Reproduction_Serie(
    serie_language_id NUMBER,
    client_id NUMBER
  ) IS
  CURSOR max_id_rm_cursor IS
  SELECT MAX(id) FROM reproduction_serie;
  last_id reproduction_serie.id%TYPE := NULL;
BEGIN
  OPEN max_id_rm_cursor;
  FETCH max_id_rm_cursor INTO last_id;
  CLOSE max_id_rm_cursor;

  last_id := Get_Last_Id(last_id);

  INSERT INTO reproduction_serie VALUES (last_id, SYSDATE, 0, client_id, 1, serie_language_id);
  COMMIT;
END Insert_Reproduction_Serie;
/