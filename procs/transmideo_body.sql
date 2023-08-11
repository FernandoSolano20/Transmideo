CREATE OR REPLACE PACKAGE BODY transmideo IS
  foreign_violated EXCEPTION;
  PRAGMA EXCEPTION_INIT(foreign_violated, -2291);
  inactive_client EXCEPTION;
  PRAGMA EXCEPTION_INIT(inactive_client, -20501);
  expired_membership EXCEPTION;
  PRAGMA EXCEPTION_INIT(expired_membership, -20502);
  not_expired_membership EXCEPTION;
  PRAGMA EXCEPTION_INIT(not_expired_membership, -20503);
  not_pay_yet EXCEPTION;
  PRAGMA EXCEPTION_INIT(not_pay_yet, -20504);

  FUNCTION Get_Last_Id(last_id NUMBER) RETURN NUMBER IS
  BEGIN
    IF last_id IS NULL THEN
      RETURN 1;
    ELSE
      RETURN last_id + 1;
    END IF;
  END Get_Last_Id;

  PROCEDURE Update_Client_Status(
    client_id NUMBER,
    client_status NUMBER
    ) IS
    PRAGMA AUTONOMOUS_TRANSACTION;

    CURSOR status_cursor IS
    SELECT status
    FROM account_status
    where id = client_status;
    status_name account_status.status%TYPE := NULL;
    client_name client.name%TYPE := NULL;
  BEGIN
    OPEN status_cursor;
    FETCH status_cursor INTO status_name;
    CLOSE status_cursor;

    SELECT c.name into client_name
    FROM client c
    where c.id = client_id;
    
    UPDATE client 
      SET account_status_id = client_status
      WHERE id = client_id;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('El cliente ' || client_name || ' ahora esta ' || status_name);
    
    EXCEPTION
      WHEN foreign_violated THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Ocurrio un error el estado no existe, no se realizo la transaccion.');
      WHEN NO_DATA_FOUND THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('No se encontro al cliente, no se realizo la transaccion.');
      WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Ocurrio un error, no se realizo la transaccion.');
  END Update_Client_Status;

  PROCEDURE Add_Documentary_To_Docuserie(
      docuserie NUMBER,
      documentary_id NUMBER
    ) IS
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

  PROCEDURE Add_Movie_To_Saga(
      saga NUMBER,
      movie_id NUMBER
    ) IS
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

  PROCEDURE Add_Serie_To_Macroserie(
      macroserie NUMBER,
      serie_id NUMBER
    ) IS
  BEGIN
    UPDATE serie
      SET macroserie_id = macroserie
      WHERE id = serie_id;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Serie relacionado con macroserie con exito.');

    EXCEPTION
      WHEN foreign_violated THEN
        DBMS_OUTPUT.PUT_LINE('Ocurrio un error el valor de la macroserie no existe, no se realizo la transaccion.');
        ROLLBACK;
      WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Ocurrio un error, no se realizo la transaccion.');
        ROLLBACK;
  END Add_Serie_To_Macroserie;

  PROCEDURE Insert_Download_Doc(
      documentary_language_id NUMBER,
      client_id NUMBER
    ) IS
    CURSOR max_id_rm_cursor IS
    SELECT MAX(id) FROM download_documentary;
    last_id download_documentary.id%TYPE := NULL;
  BEGIN
    OPEN max_id_rm_cursor;
    FETCH max_id_rm_cursor INTO last_id;
    CLOSE max_id_rm_cursor;

    last_id := Get_Last_Id(last_id);

    INSERT INTO download_documentary VALUES (last_id, SYSDATE, 0, client_id, 1, documentary_language_id);
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Solictud de descarga creada con existo.');

    EXCEPTION
      WHEN foreign_violated THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Error con las llaves foraneas al insertar, no se ha procesado la solicitud de descarga.');
      WHEN expired_membership THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Su membresia ha expirado, no se ha procesado la solicitud de descarga.');
      WHEN inactive_client THEN
        DBMS_OUTPUT.PUT_LINE('El cliente esta inactivo, no se ha procesado la solicitud de descarga.');
      WHEN not_pay_yet THEN
        DBMS_OUTPUT.PUT_LINE('El cliente no ha echo su primer pago, no se ha procesado la solicitud de descarga.');
      WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Ocurrio un error.');
  END Insert_Download_Doc;

  PROCEDURE Insert_Download_Movie(
      movie_language_id NUMBER,
      client_id NUMBER
    ) IS
    CURSOR max_id_rm_cursor IS
    SELECT MAX(id) FROM download_movie;
    last_id download_movie.id%TYPE := NULL;
  BEGIN
    OPEN max_id_rm_cursor;
    FETCH max_id_rm_cursor INTO last_id;
    CLOSE max_id_rm_cursor;

    last_id := Get_Last_Id(last_id);

    INSERT INTO download_movie VALUES (last_id, SYSDATE, 0, client_id, 1, movie_language_id);
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Solictud de descarga creada con existo.');

    EXCEPTION
      WHEN foreign_violated THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Error con las llaves foraneas al insertar, no se ha procesado la solicitud de descarga.');
      WHEN expired_membership THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Su membresia ha expirado, no se ha procesado la solicitud de descarga.');
      WHEN inactive_client THEN
        DBMS_OUTPUT.PUT_LINE('El cliente esta inactivo, no se ha procesado la solicitud de descarga.');
      WHEN not_pay_yet THEN
        DBMS_OUTPUT.PUT_LINE('El cliente no ha echo su primer pago, no se ha procesado la solicitud de descarga.');
      WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Ocurrio un error.');
  END Insert_Download_Movie;

  PROCEDURE Insert_Download_Serie(
      serie_language_id NUMBER,
      client_id NUMBER
    ) IS
    CURSOR max_id_rm_cursor IS
    SELECT MAX(id) FROM download_serie;
    last_id download_serie.id%TYPE := NULL;
  BEGIN
    OPEN max_id_rm_cursor;
    FETCH max_id_rm_cursor INTO last_id;
    CLOSE max_id_rm_cursor;

    last_id := Get_Last_Id(last_id);

    INSERT INTO download_serie VALUES (last_id, SYSDATE, 0, client_id, 1, serie_language_id);
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Solictud de descarga creada con existo.');

    EXCEPTION
      WHEN foreign_violated THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Error con las llaves foraneas al insertar, no se ha procesado la solicitud de descarga.');
      WHEN expired_membership THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Su membresia ha expirado, no se ha procesado la solicitud de descarga.');
      WHEN inactive_client THEN
        DBMS_OUTPUT.PUT_LINE('El cliente esta inactivo, no se ha procesado la solicitud de descarga.');
      WHEN not_pay_yet THEN
        DBMS_OUTPUT.PUT_LINE('El cliente no ha echo su primer pago, no se ha procesado la solicitud de descarga.');
      WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Ocurrio un error.');
  END Insert_Download_Serie;

  PROCEDURE Insert_Membership(
      price NUMBER,
      client_id NUMBER
    ) IS
    CURSOR max_id_membership_cursor IS
    SELECT MAX(id) FROM membership;
    last_id membership.id%TYPE := NULL;    
  BEGIN
    OPEN max_id_membership_cursor;
    FETCH max_id_membership_cursor INTO last_id;
    CLOSE max_id_membership_cursor;

    last_id := Get_Last_Id(last_id);

    INSERT INTO membership VALUES (last_id, ADD_MONTHS(SYSDATE, 12), price, client_id);
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Membresia pagada con existo.');

    EXCEPTION
      WHEN foreign_violated THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Ocurrio un error el id del client no existe, no se realizo la transaccion.');
      WHEN not_expired_membership THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Su membresia no ha expirado aun, no se realizo la transaccion.');
      WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Ocurrio un error, no se realizo la transaccion.');
  END Insert_Membership;

  PROCEDURE Insert_Reproduction_Doc(
      documentary_language_id NUMBER,
      client_id NUMBER
    ) IS
    CURSOR max_id_rm_cursor IS
    SELECT MAX(id) FROM reproduction_documentary;
    last_id reproduction_documentary.id%TYPE := NULL;
  BEGIN
    OPEN max_id_rm_cursor;
    FETCH max_id_rm_cursor INTO last_id;
    CLOSE max_id_rm_cursor;

    last_id := Get_Last_Id(last_id);

    INSERT INTO reproduction_documentary VALUES (last_id, SYSDATE, 0, client_id, 1, documentary_language_id);
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Solictud de reproduccion creada con existo.');

    EXCEPTION
      WHEN foreign_violated THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Error con las llaves foraneas al insertar, no se ha procesado la solicitud de reproduccion.');
      WHEN expired_membership THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Su membresia ha expirado, no se ha procesado la solicitud de reproduccion.');
      WHEN inactive_client THEN
        DBMS_OUTPUT.PUT_LINE('El cliente esta inactivo, no se ha procesado la solicitud de reproduccion.');
      WHEN not_pay_yet THEN
        DBMS_OUTPUT.PUT_LINE('El cliente no ha echo su primer pago, no se ha procesado la solicitud de reproduccion.');
      WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Ocurrio un error, no se ha procesado la solicitud de reproduccion.');
  END Insert_Reproduction_Doc;

  PROCEDURE Insert_Reproduction_Movie(
      movie_language_id NUMBER,
      client_id NUMBER
    ) IS
    CURSOR max_id_rm_cursor IS
    SELECT MAX(id) FROM reproduction_movie;
    last_id reproduction_movie.id%TYPE := NULL;
  BEGIN
    OPEN max_id_rm_cursor;
    FETCH max_id_rm_cursor INTO last_id;
    CLOSE max_id_rm_cursor;

    last_id := Get_Last_Id(last_id);

    INSERT INTO reproduction_movie VALUES (last_id, SYSDATE, 0, client_id, 1, movie_language_id);
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Solictud de reproduccion creada con existo.');

    EXCEPTION
      WHEN foreign_violated THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Error con las llaves foraneas al insertar, no se ha procesado la solicitud de reproduccion.');
      WHEN expired_membership THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Su membresia ha expirado, no se ha procesado la solicitud de reproduccion.');
      WHEN inactive_client THEN
        DBMS_OUTPUT.PUT_LINE('El cliente esta inactivo, no se ha procesado la solicitud de reproduccion.');
      WHEN not_pay_yet THEN
        DBMS_OUTPUT.PUT_LINE('El cliente no ha echo su primer pago, no se ha procesado la solicitud de reproduccion.');
      WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Ocurrio un error, no se ha procesado la solicitud de reproduccion.');
  END Insert_Reproduction_Movie;

  PROCEDURE Insert_Reproduction_Serie(
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
    DBMS_OUTPUT.PUT_LINE('Solictud de reproduccion creada con existo.');

    EXCEPTION
      WHEN foreign_violated THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Error con las llaves foraneas al insertar, no se ha procesado la solicitud de reproduccion.');
      WHEN expired_membership THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Su membresia ha expirado, no se ha procesado la solicitud de reproduccion.');
      WHEN inactive_client THEN
        DBMS_OUTPUT.PUT_LINE('El cliente esta inactivo, no se ha procesado la solicitud de reproduccion.');
      WHEN not_pay_yet THEN
        DBMS_OUTPUT.PUT_LINE('El cliente no ha echo su primer pago, no se ha procesado la solicitud de reproduccion.');
      WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Ocurrio un error, no se ha procesado la solicitud de reproduccion.');
  END Insert_Reproduction_Serie;

  PROCEDURE Insert_Client(
      name VARCHAR2,
      last_name VARCHAR2,
      direction VARCHAR2,
      phone VARCHAR2,
      birth Date,
      email VARCHAR2,
      country_id NUMBER,
      account_type_id NUMBER
    ) IS
    CURSOR max_id_client_cursor IS
    SELECT MAX(id) FROM client;
    last_id client.id%TYPE := NULL;
  BEGIN
    OPEN max_id_client_cursor;
    FETCH max_id_client_cursor INTO last_id;
    CLOSE max_id_client_cursor;

    last_id := Get_Last_Id(last_id);

    INSERT INTO client VALUES (last_id, name, last_name, direction, phone, birth, email, SYSDATE, country_id, account_type_id, 2);
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Cliente agregado con exito.');

    EXCEPTION
      WHEN foreign_violated THEN
        DBMS_OUTPUT.PUT_LINE('Ocurrio un error al insertar al cliente con las llaves foraneas.');
        ROLLBACK;
      WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Ocurrio un error, no se realizo la transaccion.');
        ROLLBACK;
  END Insert_Client;

  PROCEDURE Insert_Documentary(
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
    DBMS_OUTPUT.PUT_LINE('Documental agregado exito.');


    EXCEPTION
      WHEN foreign_violated THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('El documental no fue creado con exito, revise las llaves foraneas.');
      WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Ocurrio un error con documental, no se realizo la transaccion.');
  END Insert_Documentary;

  PROCEDURE Insert_Movie(
      title VARCHAR2,
      year Date,
      length NUMBER,
      country_id NUMBER,
      studio_id NUMBER,
      rated_id NUMBER,
      genres number_list,
      formats number_list,
      languages language_list,
      castings casting_list,
      saga_id NUMBER DEFAULT NULL
    ) IS
    
    CURSOR max_id_movie_cursor IS
    SELECT MAX(id) FROM movie;
    last_movie_id movie.id%TYPE := NULL;
    new_movie_id movie.id%TYPE := NULL;

    CURSOR max_id_casting_cursor IS
    SELECT MAX(id) FROM cast_movie;
    last_movie_casting_id cast_movie.id%TYPE := NULL;
    new_movie_casting_id cast_movie.id%TYPE := NULL;

    CURSOR max_id_language_cursor IS
    SELECT MAX(id) FROM movie_language;
    last_movie_language_id movie_language.id%TYPE := NULL;
    new_movie_language_id movie_language.id%TYPE := NULL;
  BEGIN
    OPEN max_id_movie_cursor;
    FETCH max_id_movie_cursor INTO last_movie_id;
    CLOSE max_id_movie_cursor;

    OPEN max_id_casting_cursor;
    FETCH max_id_casting_cursor INTO last_movie_casting_id;
    CLOSE max_id_casting_cursor;

    OPEN max_id_language_cursor;
    FETCH max_id_language_cursor INTO last_movie_language_id;
    CLOSE max_id_language_cursor;

    new_movie_id := Get_Last_Id(last_movie_id);
    new_movie_casting_id := Get_Last_Id(last_movie_casting_id);
    new_movie_language_id := Get_Last_Id(last_movie_language_id);

    INSERT INTO movie VALUES (new_movie_id, title, year, length, country_id, studio_id, rated_id, saga_id);
    COMMIT;
    
    BEGIN
      FOR i IN 1..genres.COUNT LOOP
        INSERT INTO movie_genre VALUES (genres(i), new_movie_id);
      END LOOP;
      COMMIT;
      EXCEPTION
        WHEN foreign_violated THEN
          ROLLBACK;
          DBMS_OUTPUT.PUT_LINE('Los generos no fueron relacionados con pelicula con exito.');
        WHEN OTHERS THEN
          ROLLBACK;
          DBMS_OUTPUT.PUT_LINE('Ocurrio un error con la relacion de generos y pelicula.');
    END;


    BEGIN
      FOR i IN 1..formats.COUNT LOOP
        INSERT INTO movie_format VALUES (formats(i), new_movie_id);
      END LOOP;
      COMMIT;
      EXCEPTION
        WHEN foreign_violated THEN
          ROLLBACK;
          DBMS_OUTPUT.PUT_LINE('Los formatos no fueron relacionados con pelicula con exito.');
        WHEN OTHERS THEN
          ROLLBACK;
          DBMS_OUTPUT.PUT_LINE('Ocurrio un error con la relacion de formatos y pelicula.');
    END;


    BEGIN
      FOR i IN 1..languages.COUNT LOOP
        INSERT INTO movie_language VALUES (new_movie_language_id, languages(i).audio_id, languages(i).subtitles_id, new_movie_id);
        new_movie_language_id := new_movie_language_id + 1;
      END LOOP;
      COMMIT;
      EXCEPTION
        WHEN foreign_violated THEN
          ROLLBACK;
          DBMS_OUTPUT.PUT_LINE('Los lenguajes no fueron relacionados con pelicula con exito.');
        WHEN OTHERS THEN
          ROLLBACK;
          DBMS_OUTPUT.PUT_LINE('Ocurrio un error con la relacion de lenguajes y pelicula.');
    END;

    
    BEGIN
      FOR i IN 1..castings.COUNT LOOP
        INSERT INTO cast_movie VALUES (new_movie_casting_id, castings(i).artist_id, new_movie_id);
        FOR j in 1..castings(i).roles.COUNT LOOP
          INSERT INTO cast_movie_role VALUES (new_movie_casting_id, castings(i).roles(j));
        END LOOP;
        new_movie_casting_id := new_movie_casting_id + 1;
      END LOOP;
      COMMIT;
      EXCEPTION
        WHEN foreign_violated THEN
          ROLLBACK;
          DBMS_OUTPUT.PUT_LINE('El reparto no fueron relacionados con pelicula con exito.');
        WHEN OTHERS THEN
          ROLLBACK;
          DBMS_OUTPUT.PUT_LINE('Ocurrio un error con la relacion de reparto y pelicula.');
    END;
    DBMS_OUTPUT.PUT_LINE('Pelicula agregada con existo.');

    
    EXCEPTION
      WHEN foreign_violated THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('La pelicula no fue creado con exito, revise las llaves foraneas.');
      WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Ocurrio un error con pelicula, no se realizo la transaccion.');
  END Insert_Movie;

  PROCEDURE Insert_Serie(
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
    DBMS_OUTPUT.PUT_LINE('Serie agregada con existo.');

    EXCEPTION
      WHEN foreign_violated THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('La serie no fue creado con exito, revise las llaves foraneas.');
      WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Ocurrio un error con serie, no se realizo la transaccion.');
  END Insert_Serie;

END transmideo;
/