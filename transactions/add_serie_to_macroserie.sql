CREATE OR REPLACE PROCEDURE Add_Serie_To_Macroserie(
    macroserie NUMBER,
    serie_id NUMBER
  ) IS
BEGIN
  UPDATE serie
    SET macroserie_id = macroserie
    WHERE id = serie_id;
  COMMIT;
END Add_Serie_To_Macroserie;
/