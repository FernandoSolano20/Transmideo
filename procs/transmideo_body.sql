CREATE OR REPLACE PACKAGE BODY transmideo IS
  FOREIGN_VIOLATED EXCEPTION;
  PRAGMA EXCEPTION_INIT(FOREIGN_VIOLATED, -2291);
  INACTIVE_CLIENT EXCEPTION;
  PRAGMA EXCEPTION_INIT(INACTIVE_CLIENT, -20501);
  EXPIRED_MEMBERSHIP EXCEPTION;
  PRAGMA EXCEPTION_INIT(EXPIRED_MEMBERSHIP, -20502);
  NOT_EXPIRED_MEMBERSHIP EXCEPTION;
  PRAGMA EXCEPTION_INIT(NOT_EXPIRED_MEMBERSHIP, -20503);
  NOT_PAY_YET EXCEPTION;
  PRAGMA EXCEPTION_INIT(NOT_PAY_YET, -20504);
  CLIENT_NOT_FOUND EXCEPTION;
  PRAGMA EXCEPTION_INIT(CLIENT_NOT_FOUND, -20505);
  MOVIE_NOT_FOUND EXCEPTION;
  PRAGMA EXCEPTION_INIT(MOVIE_NOT_FOUND, -20506);
  SERIE_NOT_FOUND EXCEPTION;
  PRAGMA EXCEPTION_INIT(SERIE_NOT_FOUND, -20507);
  DOCUMENTARY_NOT_FOUND EXCEPTION;
  PRAGMA EXCEPTION_INIT(DOCUMENTARY_NOT_FOUND, -20508);
  SAGA_NOT_FOUND EXCEPTION;
  PRAGMA EXCEPTION_INIT(SAGA_NOT_FOUND, -20509);
  DOCUSERIE_NOT_FOUND EXCEPTION;
  PRAGMA EXCEPTION_INIT(DOCUSERIE_NOT_FOUND, -20510);
  MACROSERIE_NOT_FOUND EXCEPTION;
  PRAGMA EXCEPTION_INIT(MACROSERIE_NOT_FOUND, -20511);

  FUNCTION Get_Client_Name_By_Id(client_id NUMBER) RETURN VARCHAR2 IS
    client_name client.name%TYPE := NULL;
  BEGIN
    SELECT c.name into client_name
    FROM client c
    where c.id = client_id;
    RETURN client_name;

    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        RAISE CLIENT_NOT_FOUND;
  END Get_Client_Name_By_Id;

  FUNCTION Get_Movie_Title_By_Id(movie_id NUMBER) RETURN VARCHAR2 IS
    movie_title movie.title%TYPE := NULL;
  BEGIN
    SELECT m.title into movie_title
    FROM movie m
    where m.id = movie_id;
    RETURN movie_title;

    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        RAISE MOVIE_NOT_FOUND;
  END Get_Movie_Title_By_Id;

  FUNCTION Get_Serie_Title_By_Id(serie_id NUMBER) RETURN VARCHAR2 IS
    serie_title serie.title%TYPE := NULL;
  BEGIN
    SELECT s.title into serie_title
    FROM serie s
    where s.id = serie_id;
    RETURN serie_title;

    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        RAISE SERIE_NOT_FOUND;
  END Get_Serie_Title_By_Id;

  FUNCTION Get_Documentary_Title_By_Id(documentary_id NUMBER) RETURN VARCHAR2 IS
    documentary_title documentary.title%TYPE := NULL;
  BEGIN
    SELECT d.title into documentary_title
    FROM documentary d
    where d.id = documentary_id;
    RETURN documentary_title;

    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        RAISE DOCUMENTARY_NOT_FOUND;
  END Get_Documentary_Title_By_Id;

  FUNCTION Get_Saga_Title_By_Id(saga_id NUMBER) RETURN VARCHAR2 IS
    saga_title saga.title%TYPE := NULL;
  BEGIN
    SELECT s.title into saga_title
    FROM saga s
    where s.id = saga_id;
    RETURN saga_title;

    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        RAISE SAGA_NOT_FOUND;
  END Get_Saga_Title_By_Id;

  FUNCTION Get_Macroserie_Title_By_Id(macroserie_id NUMBER) RETURN VARCHAR2 IS
    macroserie_title macroserie.title%TYPE := NULL;
  BEGIN
    SELECT m.title into macroserie_title
    FROM macroserie m
    where m.id = macroserie_id;
    RETURN macroserie_title;

    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        RAISE MACROSERIE_NOT_FOUND;
  END Get_Macroserie_Title_By_Id;

  FUNCTION Get_Docuserie_Title_By_Id(docuserie_id NUMBER) RETURN VARCHAR2 IS
    docuserie_title docuserie.title%TYPE := NULL;
  BEGIN
    SELECT d.title into docuserie_title
    FROM docuserie d
    where d.id = docuserie_id;
    RETURN docuserie_title;

    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        RAISE DOCUSERIE_NOT_FOUND;
  END Get_Docuserie_Title_By_Id;

  FUNCTION Get_Doc_Title_By_Language(documentary_language_id NUMBER) RETURN VARCHAR2 IS
    documentary_title documentary.title%TYPE := NULL;
  BEGIN
    SELECT d.title into documentary_title
    FROM documentary d
    INNER JOIN documentary_language dl ON dl.documentary_id = d.id
    where dl.id = documentary_language_id;
    RETURN documentary_title;

    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        RAISE DOCUMENTARY_NOT_FOUND;
  END Get_Doc_Title_By_Language;

  FUNCTION Get_Movie_Title_By_Language(movie_language_id NUMBER) RETURN VARCHAR2 IS
    movie_title movie.title%TYPE := NULL;
  BEGIN
    SELECT m.title into movie_title
    FROM movie m
    INNER JOIN movie_language ml ON ml.movie_id = m.id
    where ml.id = movie_language_id;
    RETURN movie_title;

    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        RAISE MOVIE_NOT_FOUND;
  END Get_Movie_Title_By_Language;

  FUNCTION Get_Serie_Title_By_Language(serie_language_id NUMBER) RETURN VARCHAR2 IS
    serie_title serie.title%TYPE := NULL;
  BEGIN
    SELECT s.title into serie_title
    FROM serie s
    INNER JOIN serie_language sl ON sl.serie_id = s.id
    where sl.id = serie_language_id;
    RETURN serie_title;

    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        RAISE SERIE_NOT_FOUND;
  END Get_Serie_Title_By_Language;

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

    client_name := Get_Client_Name_By_Id(client_id);
    
    UPDATE client 
      SET account_status_id = client_status
      WHERE id = client_id;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('El cliente ' || client_name || ' ahora esta ' || status_name);
    
    EXCEPTION
      WHEN FOREIGN_VIOLATED THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Ocurrio un error el estado no existe, no se actualizo el estado del cliente ' || client_name);
      WHEN CLIENT_NOT_FOUND THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('No se encontro al cliente, no se realizo la transaccion.');
      WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Ocurrio un error, no se actualizo el estado del cliente ' || client_name);
  END Update_Client_Status;

  PROCEDURE Add_Documentary_To_Docuserie(
      docuserie_id NUMBER,
      documentary_id NUMBER
    ) IS
    documentary_title documentary.title%TYPE := NULL;
    docuserie_title docuserie.title%TYPE := NULL;
  BEGIN
    documentary_title := Get_Documentary_Title_By_Id(documentary_id);
    docuserie_title := Get_Docuserie_Title_By_Id(docuserie_id);
    UPDATE documentary
      SET docuserie_id = docuserie_id
      WHERE id = documentary_id;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Documental ' || documentary_title || ' relacionado con la docuserie ' || docuserie_title || ' con exito.');

    EXCEPTION
      WHEN FOREIGN_VIOLATED THEN
        DBMS_OUTPUT.PUT_LINE('Ocurrio un error, la docuserie no existe.');
        ROLLBACK;
      WHEN DOCUMENTARY_NOT_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Ocurrio un error, el documental no existe.');
        ROLLBACK;
      WHEN DOCUSERIE_NOT_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Ocurrio un error, la docuserie no existe.');
        ROLLBACK;
      WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Ocurrio un error, no se realizo la transaccion, no se agrego documental ' || documentary_title || ' a la docuserie ' || docuserie_title);
        ROLLBACK;
  END Add_Documentary_To_Docuserie;

  PROCEDURE Add_Movie_To_Saga(
      saga_id NUMBER,
      movie_id NUMBER
    ) IS
    movie_title movie.title%TYPE := NULL;
    saga_title saga.title%TYPE := NULL;
  BEGIN
    movie_title := Get_Movie_Title_By_Id(movie_id);
    saga_title := Get_Saga_Title_By_Id(saga_id);
    UPDATE movie
      SET saga_id = saga_id
      WHERE id = movie_id;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Pelicula ' || movie_title || ' relacionado con la saga ' || saga_title || ' con exito.');

    EXCEPTION
      WHEN FOREIGN_VIOLATED THEN
        DBMS_OUTPUT.PUT_LINE('Ocurrio un error, la saga no existe.');
        ROLLBACK;
      WHEN MOVIE_NOT_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Ocurrio un error, la pelicula no existe.');
        ROLLBACK;
      WHEN SAGA_NOT_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Ocurrio un error, la saga no existe.');
        ROLLBACK;
      WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Ocurrio un error, no se realizo la transaccion, no se agrego la pelicula ' || movie_title || ' a la saga ' || saga_title);
        ROLLBACK;
  END Add_Movie_To_Saga;

  PROCEDURE Add_Serie_To_Macroserie(
      macroserie_id NUMBER,
      serie_id NUMBER
    ) IS
    serie_title serie.title%TYPE := NULL;
    macroserie_title macroserie.title%TYPE := NULL;
  BEGIN
    serie_title := Get_Serie_Title_By_Id(serie_id);
    macroserie_title := Get_Macroserie_Title_By_Id(macroserie_id);
    UPDATE serie
      SET macroserie_id = macroserie_id
      WHERE id = serie_id;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Serie ' || serie_title || ' relacionado con la macroserie ' || macroserie_title || ' con exito.');

    EXCEPTION
      WHEN FOREIGN_VIOLATED THEN
        DBMS_OUTPUT.PUT_LINE('Ocurrio un error, la macroserie no existe.');
        ROLLBACK;
      WHEN SERIE_NOT_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Ocurrio un error, la serie no existe.');
        ROLLBACK;
      WHEN MACROSERIE_NOT_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Ocurrio un error, la macroserie no existe.');
        ROLLBACK;
      WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Ocurrio un error, no se realizo la transaccion, no se agrego la serie ' || serie_title || ' a la macroserie ' || macroserie_title);
        ROLLBACK;
  END Add_Serie_To_Macroserie;

  PROCEDURE Insert_Download_Doc(
      documentary_language_id NUMBER,
      client_id NUMBER
    ) IS
    CURSOR max_id_rm_cursor IS
    SELECT MAX(id) FROM download_documentary;
    last_id download_documentary.id%TYPE := NULL;

    documentary_title documentary.title%TYPE := NULL;
    client_name client.name%TYPE := NULL;
  BEGIN
    OPEN max_id_rm_cursor;
    FETCH max_id_rm_cursor INTO last_id;
    CLOSE max_id_rm_cursor;

    last_id := Get_Last_Id(last_id);
    client_name := Get_Client_Name_By_Id(client_id);
    documentary_title := Get_Doc_Title_By_Language(documentary_language_id);

    INSERT INTO download_documentary VALUES (last_id, SYSDATE, 0, client_id, 1, documentary_language_id);
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Solicitud de descarga exitosa de ' || client_name || ' para el documental ' || documentary_title);

    EXCEPTION
      WHEN CLIENT_NOT_FOUND THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('No se encontro al cliente, no se ha procesado la solicitud de descarga.');
      WHEN DOCUMENTARY_NOT_FOUND THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Ocurrio un error, el documental no existe, no se ha procesado la solicitud de descarga.');
      WHEN FOREIGN_VIOLATED THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Error con las llaves foraneas al insertar, no se ha procesado la solicitud de descarga.');
      WHEN EXPIRED_MEMBERSHIP THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('El cliente ' || client_name || ' tiene la membresia expirada, no se ha procesado la solicitud de descarga de ' || documentary_title);
      WHEN INACTIVE_CLIENT THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('El cliente ' || client_name || ' esta inactivo, no se ha procesado la solicitud de descarga de ' || documentary_title);
      WHEN NOT_PAY_YET THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('El cliente ' || client_name || ' no ha echo su primer pago, no se ha procesado la solicitud de descarga ' || documentary_title);
      WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Ocurrio un error, solicitud de descarga de ' || client_name || ' para el documental ' || documentary_title || ' no fue existosa.');
  END Insert_Download_Doc;

  PROCEDURE Insert_Download_Movie(
      movie_language_id NUMBER,
      client_id NUMBER
    ) IS
    CURSOR max_id_rm_cursor IS
    SELECT MAX(id) FROM download_movie;
    last_id download_movie.id%TYPE := NULL;

    movie_title movie.title%TYPE := NULL;
    client_name client.name%TYPE := NULL;
  BEGIN
    OPEN max_id_rm_cursor;
    FETCH max_id_rm_cursor INTO last_id;
    CLOSE max_id_rm_cursor;

    last_id := Get_Last_Id(last_id);
    client_name := Get_Client_Name_By_Id(client_id);
    movie_title := Get_Movie_Title_By_Language(movie_language_id);

    INSERT INTO download_movie VALUES (last_id, SYSDATE, 0, client_id, 1, movie_language_id);
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Solicitud de descarga exitosa de ' || client_name || ' para la pelicula ' || movie_title);

    EXCEPTION
      WHEN CLIENT_NOT_FOUND THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('No se encontro al cliente, no se ha procesado la solicitud de descarga.');
      WHEN MOVIE_NOT_FOUND THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Ocurrio un error, la pelicula no existe, no se ha procesado la solicitud de descarga.');
      WHEN FOREIGN_VIOLATED THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Error con las llaves foraneas al insertar, no se ha procesado la solicitud de descarga.');
      WHEN EXPIRED_MEMBERSHIP THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('El cliente ' || client_name || ' tiene la membresia expirada, no se ha procesado la solicitud de descarga de ' || movie_title);
      WHEN INACTIVE_CLIENT THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('El cliente ' || client_name || ' esta inactivo, no se ha procesado la solicitud de descarga de ' || movie_title);
      WHEN NOT_PAY_YET THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('El cliente ' || client_name || ' no ha echo su primer pago, no se ha procesado la solicitud de descarga ' || movie_title);
      WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Ocurrio un error, solicitud de descarga exitosa de ' || client_name || ' para la pelicula ' || movie_title);
  END Insert_Download_Movie;

  PROCEDURE Insert_Download_Serie(
      serie_language_id NUMBER,
      client_id NUMBER
    ) IS
    CURSOR max_id_rm_cursor IS
    SELECT MAX(id) FROM download_serie;
    last_id download_serie.id%TYPE := NULL;

    serie_title documentary.title%TYPE := NULL;
    client_name client.name%TYPE := NULL;
  BEGIN
    OPEN max_id_rm_cursor;
    FETCH max_id_rm_cursor INTO last_id;
    CLOSE max_id_rm_cursor;

    last_id := Get_Last_Id(last_id);
    client_name := Get_Client_Name_By_Id(client_id);
    serie_title := Get_Serie_Title_By_Language(serie_language_id);

    INSERT INTO download_serie VALUES (last_id, SYSDATE, 0, client_id, 1, serie_language_id);
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Solicitud de descarga exitosa de ' || client_name || ' para la serie ' || serie_title);

    EXCEPTION
      WHEN CLIENT_NOT_FOUND THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('No se encontro al cliente, no se ha procesado la solicitud de descarga.');
      WHEN SERIE_NOT_FOUND THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Ocurrio un error, la serie no existe, no se ha procesado la solicitud de descarga.');
      WHEN FOREIGN_VIOLATED THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Error con las llaves foraneas al insertar, no se ha procesado la solicitud de descarga.');
      WHEN EXPIRED_MEMBERSHIP THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('El cliente ' || client_name || ' tiene la membresia expirada, no se ha procesado la solicitud de descarga de ' || serie_title);
      WHEN INACTIVE_CLIENT THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('El cliente ' || client_name || ' esta inactivo, no se ha procesado la solicitud de descarga de ' || serie_title);
      WHEN NOT_PAY_YET THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('El cliente ' || client_name || ' no ha echo su primer pago, no se ha procesado la solicitud de descarga ' || serie_title);
      WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Ocurrio un error, solicitud de descarga de ' || client_name || ' para la serie ' || serie_title || ' no fue existosa.');
  END Insert_Download_Serie;

  PROCEDURE Insert_Membership(
      price NUMBER,
      client_id NUMBER
    ) IS
    CURSOR max_id_membership_cursor IS
    SELECT MAX(id) FROM membership;
    last_id membership.id%TYPE := NULL;  
    client_name client.name%TYPE := NULL;  
  BEGIN
    OPEN max_id_membership_cursor;
    FETCH max_id_membership_cursor INTO last_id;
    CLOSE max_id_membership_cursor;

    last_id := Get_Last_Id(last_id);
    client_name := Get_Client_Name_By_Id(client_id);

    INSERT INTO membership VALUES (last_id, ADD_MONTHS(SYSDATE, 12), price, client_id);
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('La membresia del cliente ' || client_name || ' ha sido pagada con existo.');

    EXCEPTION
      WHEN CLIENT_NOT_FOUND THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('No se encontro al cliente, no se ha pagado al membresia.');
      WHEN FOREIGN_VIOLATED THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Ocurrio un error el id del client no existe, no se ha pagado al membresia.');
      WHEN NOT_EXPIRED_MEMBERSHIP THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('La membresia del cliente ' || client_name || ' no ha expirado aun.');
      WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Ocurrio un error, no se ha pagado al membresia de ' || client_name);
  END Insert_Membership;

  PROCEDURE Insert_Reproduction_Doc(
      documentary_language_id NUMBER,
      client_id NUMBER
    ) IS
    CURSOR max_id_rm_cursor IS
    SELECT MAX(id) FROM reproduction_documentary;
    last_id reproduction_documentary.id%TYPE := NULL;

    documentary_title documentary.title%TYPE := NULL;
    client_name client.name%TYPE := NULL;
  BEGIN
    OPEN max_id_rm_cursor;
    FETCH max_id_rm_cursor INTO last_id;
    CLOSE max_id_rm_cursor;

    last_id := Get_Last_Id(last_id);
    client_name := Get_Client_Name_By_Id(client_id);
    documentary_title := Get_Doc_Title_By_Language(documentary_language_id);

    INSERT INTO reproduction_documentary VALUES (last_id, SYSDATE, 0, client_id, 1, documentary_language_id);
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Solicitud de reproduccion exitosa de ' || client_name || ' para el documental ' || documentary_title);

    EXCEPTION
      WHEN CLIENT_NOT_FOUND THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('No se encontro al cliente, no se ha procesado la solicitud de reproduccion.');
      WHEN DOCUMENTARY_NOT_FOUND THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Ocurrio un error, el documental no existe, no se ha procesado la solicitud de reproduccion.');
      WHEN FOREIGN_VIOLATED THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Error con las llaves foraneas al insertar, no se ha procesado la solicitud de reproduccion.');
      WHEN EXPIRED_MEMBERSHIP THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('El cliente ' || client_name || ' tiene la membresia expirada, no se ha procesado la solicitud de reproduccion de ' || documentary_title);
      WHEN INACTIVE_CLIENT THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('El cliente ' || client_name || ' esta inactivo, no se ha procesado la solicitud de reproduccion de ' || documentary_title);
      WHEN NOT_PAY_YET THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('El cliente ' || client_name || ' no ha echo su primer pago, no se ha procesado la solicitud de reproduccion ' || documentary_title);
      WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Ocurrio un error, solicitud de reproduccion de ' || client_name || ' para el documental ' || documentary_title || ' no fue existosa.');
  END Insert_Reproduction_Doc;

  PROCEDURE Insert_Reproduction_Movie(
      movie_language_id NUMBER,
      client_id NUMBER
    ) IS
    CURSOR max_id_rm_cursor IS
    SELECT MAX(id) FROM reproduction_movie;
    last_id reproduction_movie.id%TYPE := NULL;

    movie_title movie.title%TYPE := NULL;
    client_name client.name%TYPE := NULL;
  BEGIN
    OPEN max_id_rm_cursor;
    FETCH max_id_rm_cursor INTO last_id;
    CLOSE max_id_rm_cursor;

    last_id := Get_Last_Id(last_id);
    client_name := Get_Client_Name_By_Id(client_id);
    movie_title := Get_Movie_Title_By_Language(movie_language_id);

    INSERT INTO reproduction_movie VALUES (last_id, SYSDATE, 0, client_id, 1, movie_language_id);
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Solicitud de reproduccion exitosa de ' || client_name || ' para la pelicula ' || movie_title);

    EXCEPTION
      WHEN CLIENT_NOT_FOUND THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('No se encontro al cliente, no se ha procesado la solicitud de reproduccion.');
      WHEN MOVIE_NOT_FOUND THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Ocurrio un error, la pelicula no existe, no se ha procesado la solicitud de reproduccion.');
      WHEN FOREIGN_VIOLATED THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Error con las llaves foraneas al insertar, no se ha procesado la solicitud de reproduccion.');
      WHEN EXPIRED_MEMBERSHIP THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('El cliente ' || client_name || ' tiene la membresia expirada, no se ha procesado la solicitud de reproduccion de ' || movie_title);
      WHEN INACTIVE_CLIENT THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('El cliente ' || client_name || ' esta inactivo, no se ha procesado la solicitud de reproduccion de ' || movie_title);
      WHEN NOT_PAY_YET THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('El cliente ' || client_name || ' no ha echo su primer pago, no se ha procesado la solicitud de reproduccion ' || movie_title);
      WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Ocurrio un error, solicitud de reproduccion exitosa de ' || client_name || ' para la pelicula ' || movie_title);
  END Insert_Reproduction_Movie;

  PROCEDURE Insert_Reproduction_Serie(
      serie_language_id NUMBER,
      client_id NUMBER
    ) IS
    CURSOR max_id_rm_cursor IS
    SELECT MAX(id) FROM reproduction_serie;
    last_id reproduction_serie.id%TYPE := NULL;

    serie_title serie.title%TYPE := NULL;
    client_name client.name%TYPE := NULL;
  BEGIN
    OPEN max_id_rm_cursor;
    FETCH max_id_rm_cursor INTO last_id;
    CLOSE max_id_rm_cursor;

    last_id := Get_Last_Id(last_id);
    client_name := Get_Client_Name_By_Id(client_id);
    serie_title := Get_Serie_Title_By_Language(serie_language_id);

    INSERT INTO reproduction_serie VALUES (last_id, SYSDATE, 0, client_id, 1, serie_language_id);
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Solicitud de reproduccion exitosa de ' || client_name || ' para la serie ' || serie_title);

    EXCEPTION
      WHEN CLIENT_NOT_FOUND THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('No se encontro al cliente, no se ha procesado la solicitud de reproduccion.');
      WHEN SERIE_NOT_FOUND THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Ocurrio un error, la serie no existe, no se ha procesado la solicitud de reproduccion.');
      WHEN FOREIGN_VIOLATED THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Error con las llaves foraneas al insertar, no se ha procesado la solicitud de reproduccion.');
      WHEN EXPIRED_MEMBERSHIP THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('El cliente ' || client_name || ' tiene la membresia expirada, no se ha procesado la solicitud de reproduccion de ' || serie_title);
      WHEN INACTIVE_CLIENT THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('El cliente ' || client_name || ' esta inactivo, no se ha procesado la solicitud de reproduccion de ' || serie_title);
      WHEN NOT_PAY_YET THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('El cliente ' || client_name || ' no ha echo su primer pago, no se ha procesado la solicitud de reproduccion ' || serie_title);
      WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Ocurrio un error, solicitud de reproduccion de ' || client_name || ' para la serie ' || serie_title || ' no fue existosa.');
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
    DBMS_OUTPUT.PUT_LINE('Cliente ' || name || ' agregado con exito.');

    EXCEPTION
      WHEN FOREIGN_VIOLATED THEN
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
        WHEN FOREIGN_VIOLATED THEN
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
        WHEN FOREIGN_VIOLATED THEN
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
        WHEN FOREIGN_VIOLATED THEN
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
        WHEN FOREIGN_VIOLATED THEN
          ROLLBACK;
          DBMS_OUTPUT.PUT_LINE('El reparto no fueron relacionados con documental con exito.');
        WHEN OTHERS THEN
          ROLLBACK;
          DBMS_OUTPUT.PUT_LINE('Ocurrio un error con la relacion de reparto y documental.');
    END;
    DBMS_OUTPUT.PUT_LINE('Documental agregado exito.');


    EXCEPTION
      WHEN FOREIGN_VIOLATED THEN
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
        WHEN FOREIGN_VIOLATED THEN
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
        WHEN FOREIGN_VIOLATED THEN
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
        WHEN FOREIGN_VIOLATED THEN
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
        WHEN FOREIGN_VIOLATED THEN
          ROLLBACK;
          DBMS_OUTPUT.PUT_LINE('El reparto no fueron relacionados con pelicula con exito.');
        WHEN OTHERS THEN
          ROLLBACK;
          DBMS_OUTPUT.PUT_LINE('Ocurrio un error con la relacion de reparto y pelicula.');
    END;
    DBMS_OUTPUT.PUT_LINE('Pelicula agregada con existo.');

    
    EXCEPTION
      WHEN FOREIGN_VIOLATED THEN
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
        WHEN FOREIGN_VIOLATED THEN
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
        WHEN FOREIGN_VIOLATED THEN
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
        WHEN FOREIGN_VIOLATED THEN
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
        WHEN FOREIGN_VIOLATED THEN
          ROLLBACK;
          DBMS_OUTPUT.PUT_LINE('El reparto no fueron relacionados con serie con exito.');
        WHEN OTHERS THEN
          ROLLBACK;
          DBMS_OUTPUT.PUT_LINE('Ocurrio un error con la relacion de reparto y serie.');
    END;
    DBMS_OUTPUT.PUT_LINE('Serie agregada con existo.');

    EXCEPTION
      WHEN FOREIGN_VIOLATED THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('La serie no fue creado con exito, revise las llaves foraneas.');
      WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Ocurrio un error con serie, no se realizo la transaccion.');
  END Insert_Serie;

END transmideo;
/