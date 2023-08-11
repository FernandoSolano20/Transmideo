CREATE OR REPLACE PROCEDURE Add_Serie_To_Macroserie(
    macroserie NUMBER,
    serie_id NUMBER
  ) IS
  foreign_violated EXCEPTION;
  PRAGMA EXCEPTION_INIT(foreign_violated, -2291);
BEGIN
  UPDATE serie
    SET macroserie_id = macroserie
    WHERE id = serie_id;
  COMMIT;

  EXCEPTION
    WHEN foreign_violated THEN
      DBMS_OUTPUT.PUT_LINE('Ocurrio un error, el valor de la macroserie no existe.');
      ROLLBACK;
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('Ocurrio un error.');
      ROLLBACK;
END Add_Serie_To_Macroserie;
/