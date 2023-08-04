CREATE OR REPLACE PROCEDURE Add_Documentary_To_Docuserie(
    docuserie NUMBER,
    documentary_id NUMBER
  ) IS
BEGIN
  UPDATE documentary
    SET docuserie_id = docuserie
    WHERE id = documentary_id;
  COMMIT;
END Add_Documentary_To_Docuserie;
/