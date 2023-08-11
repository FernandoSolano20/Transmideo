CREATE OR REPLACE PROCEDURE Insert_Documentary(
    title VARCHAR2,
    abstract VARCHAR2,
    begin_date Date,
    length NUMBER,
    seasons NUMBER,
    chapters NUMBER,
    rated_id NUMBER,
    genres number_list,
    formats number_list,
    languages language_list,
    castings casting_list,
    docuserie_id NUMBER DEFAULT NULL
  ) IS
  CURSOR max_id_documentary_cursor IS
  SELECT MAX(id) FROM documentary;
  last_documentary_id documentary.id%TYPE := NULL;
  new_documentary_id documentary.id%TYPE := NULL;

  CURSOR max_id_casting_cursor IS
  SELECT MAX(id) FROM cast_documentary;
  last_documentary_casting_id cast_documentary.id%TYPE := NULL;
  new_documentary_casting_id cast_documentary.id%TYPE := NULL;

  CURSOR max_id_language_cursor IS
  SELECT MAX(id) FROM documentary_language;
  last_documentary_language_id documentary_language.id%TYPE := NULL;
  new_documentary_language_id documentary_language.id%TYPE := NULL;

  foreign_violated EXCEPTION;
  PRAGMA EXCEPTION_INIT(foreign_violated, -2291);
BEGIN
  OPEN max_id_documentary_cursor;
  FETCH max_id_documentary_cursor INTO last_documentary_id;
  CLOSE max_id_documentary_cursor;

  OPEN max_id_casting_cursor;
  FETCH max_id_casting_cursor INTO last_documentary_casting_id;
  CLOSE max_id_casting_cursor;

  OPEN max_id_language_cursor;
  FETCH max_id_language_cursor INTO last_documentary_language_id;
  CLOSE max_id_language_cursor;

  new_documentary_id := Get_Last_Id(last_documentary_id);
  new_documentary_casting_id := Get_Last_Id(last_documentary_casting_id);
  new_documentary_language_id := Get_Last_Id(last_documentary_language_id);

  INSERT INTO documentary VALUES (new_documentary_id, title, abstract, begin_date, length, seasons, chapters, rated_id, docuserie_id);
  COMMIT;


  BEGIN
    FOR i IN 1..genres.COUNT LOOP
      INSERT INTO documentary_genre VALUES (genres(i), new_documentary_id);
    END LOOP;
    COMMIT;
    EXCEPTION
      WHEN foreign_violated THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Los generos no fueron relacionados con documental con exito.');
      WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Ocurrio un error con la relacion de generos y documental.');
  END;


  BEGIN
    FOR i IN 1..formats.COUNT LOOP
      INSERT INTO documentary_format VALUES (formats(i), new_documentary_id);
    END LOOP;
    COMMIT;
    EXCEPTION
      WHEN foreign_violated THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Los formatos no fueron relacionados con documental con exito.');
      WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Ocurrio un error con la relacion de formatos y documental.');
  END;


  BEGIN
    FOR i IN 1..languages.COUNT LOOP
      INSERT INTO documentary_language VALUES (new_documentary_language_id, languages(i).audio_id, languages(i).subtitles_id, new_documentary_id);
      new_documentary_language_id := new_documentary_language_id + 1;
    END LOOP;
    COMMIT;
    EXCEPTION
      WHEN foreign_violated THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Los lenguajes no fueron relacionados con documental con exito.');
      WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Ocurrio un error con la relacion de lenguajes y documental.');
  END;


  BEGIN
    FOR i IN 1..castings.COUNT LOOP
      INSERT INTO cast_documentary VALUES (new_documentary_casting_id, castings(i).artist_id, new_documentary_id);
      FOR j in 1..castings(i).roles.COUNT LOOP
        INSERT INTO cast_documentary_role VALUES (new_documentary_casting_id, castings(i).roles(j));
      END LOOP;
      new_documentary_casting_id := new_documentary_casting_id + 1;
    END LOOP;
    COMMIT;
    EXCEPTION
      WHEN foreign_violated THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('El reparto no fueron relacionados con documental con exito.');
      WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Ocurrio un error con la relacion de reparto y documental.');
  END;


  EXCEPTION
    WHEN foreign_violated THEN
      ROLLBACK;
      DBMS_OUTPUT.PUT_LINE('El documental no fue creado con exito, revise las llaves foraneas.');
    WHEN OTHERS THEN
      ROLLBACK;
      DBMS_OUTPUT.PUT_LINE('Ocurrio un error con documental.');
END Insert_Documentary;
/