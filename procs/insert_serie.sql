CREATE OR REPLACE PROCEDURE Insert_Serie(
    title VARCHAR2,
    abstract VARCHAR2,
    begin_date Date,
    length NUMBER,
    seasons NUMBER,
    chapters NUMBER,
    rated_id NUMBER,
    country_id NUMBER,
    genres number_list,
    formats number_list,
    languages language_list,
    castings casting_list,
    macroserie_id NUMBER DEFAULT NULL
  ) IS
  CURSOR max_id_serie_cursor IS
  SELECT MAX(id) FROM serie;
  last_serie_id serie.id%TYPE := NULL;
  new_serie_id serie.id%TYPE := NULL;


  CURSOR max_id_casting_cursor IS
  SELECT MAX(id) FROM cast_serie;
  last_serie_casting_id cast_serie.id%TYPE := NULL;
  new_serie_casting_id cast_serie.id%TYPE := NULL;

  CURSOR max_id_language_cursor IS
  SELECT MAX(id) FROM serie_language;
  last_serie_language_id serie_language.id%TYPE := NULL;
  new_serie_language_id serie_language.id%TYPE := NULL;

  foreign_violated EXCEPTION;
  PRAGMA EXCEPTION_INIT(foreign_violated, -2291);
BEGIN
  OPEN max_id_serie_cursor;
  FETCH max_id_serie_cursor INTO last_serie_id;
  CLOSE max_id_serie_cursor;

  OPEN max_id_casting_cursor;
  FETCH max_id_casting_cursor INTO last_serie_casting_id;
  CLOSE max_id_casting_cursor;

  OPEN max_id_language_cursor;
  FETCH max_id_language_cursor INTO last_serie_language_id;
  CLOSE max_id_language_cursor;

  new_serie_id := Get_Last_Id(last_serie_id);
  new_serie_casting_id := Get_Last_Id(last_serie_casting_id);
  new_serie_language_id := Get_Last_Id(last_serie_language_id);


  INSERT INTO serie VALUES (new_serie_id, title, abstract, begin_date, length, seasons, chapters, rated_id, macroserie_id, country_id);
  COMMIT;


  BEGIN
    FOR i IN 1..genres.COUNT LOOP
      INSERT INTO serie_genre VALUES (genres(i), new_serie_id);
    END LOOP;
    COMMIT;
    EXCEPTION
      WHEN foreign_violated THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Los generos no fueron relacionados con serie con exito.');
      WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Ocurrio un error con la relacion de generos y serie.');
  END;

  
  BEGIN
    FOR i IN 1..formats.COUNT LOOP
      INSERT INTO serie_format VALUES (formats(i), new_serie_id);
    END LOOP;
    COMMIT;
    EXCEPTION
      WHEN foreign_violated THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Los formatos no fueron relacionados con serie con exito.');
      WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Ocurrio un error con la relacion de formatos y serie.');
  END;

  
  BEGIN
    FOR i IN 1..languages.COUNT LOOP
      INSERT INTO serie_language VALUES (new_serie_language_id, languages(i).audio_id, languages(i).subtitles_id, new_serie_id);
      new_serie_language_id := new_serie_language_id + 1;
    END LOOP;
    COMMIT;
    EXCEPTION
      WHEN foreign_violated THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Los lenguajes no fueron relacionados con serie con exito.');
      WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Ocurrio un error con la relacion de lenguajes y serie.');
  END;

  
  BEGIN
    FOR i IN 1..castings.COUNT LOOP
      INSERT INTO cast_serie VALUES (new_serie_casting_id, castings(i).artist_id, new_serie_id);
      FOR j in 1..castings(i).roles.COUNT LOOP
        INSERT INTO cast_serie_role VALUES (new_serie_casting_id, castings(i).roles(j));
      END LOOP;
      new_serie_casting_id := new_serie_casting_id + 1;
    END LOOP;
    COMMIT;
    EXCEPTION
      WHEN foreign_violated THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('El reparto no fueron relacionados con serie con exito.');
      WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Ocurrio un error con la relacion de reparto y serie.');
  END;

  EXCEPTION
    WHEN foreign_violated THEN
      ROLLBACK;
      DBMS_OUTPUT.PUT_LINE('La serie no fue creado con exito, revise las llaves foraneas.');
    WHEN OTHERS THEN
      ROLLBACK;
      DBMS_OUTPUT.PUT_LINE('Ocurrio un error con serie.');
END Insert_Serie;
/