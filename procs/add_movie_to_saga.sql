CREATE OR REPLACE PROCEDURE Add_Movie_To_Saga(
    saga NUMBER,
    movie_id NUMBER
  ) IS
  foreign_violated EXCEPTION;
  PRAGMA EXCEPTION_INIT(foreign_violated, -2291);
BEGIN
  UPDATE movie
    SET saga_id = saga
    WHERE id = movie_id;
  COMMIT;
  DBMS_OUTPUT.PUT_LINE('Pelicula relacionado con saga con exito.');

  EXCEPTION
    WHEN foreign_violated THEN
      DBMS_OUTPUT.PUT_LINE('Ocurrio un error el valor de la saga no existe, no se realizo la transaccion.');
      ROLLBACK;
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('Ocurrio un error, no se realizo la transaccion.');
      ROLLBACK;
END Add_Movie_To_Saga;
/