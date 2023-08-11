CREATE OR REPLACE PROCEDURE Add_Documentary_To_Docuserie(
    docuserie NUMBER,
    documentary_id NUMBER
  ) IS
  foreign_violated EXCEPTION;
  PRAGMA EXCEPTION_INIT(foreign_violated, -2291);
BEGIN
  UPDATE documentary
    SET docuserie_id = docuserie
    WHERE id = documentary_id;
  COMMIT;
  DBMS_OUTPUT.PUT_LINE('Documental relacionado con docuserie con exito.');

  EXCEPTION
    WHEN foreign_violated THEN
      DBMS_OUTPUT.PUT_LINE('Ocurrio un error, el valor de docuserie no existe, no se realizo la transaccion.');
      ROLLBACK;
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('Ocurrio un error, no se realizo la transaccion.');
      ROLLBACK;
END Add_Documentary_To_Docuserie;
/