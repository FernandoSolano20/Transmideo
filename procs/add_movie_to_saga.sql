CREATE OR REPLACE PROCEDURE Add_Movie_To_Saga(
    saga NUMBER,
    movie_id NUMBER
  ) IS
BEGIN
  UPDATE movie
    SET saga_id = saga
    WHERE id = movie_id;
  COMMIT;
END Add_Movie_To_Saga;
/