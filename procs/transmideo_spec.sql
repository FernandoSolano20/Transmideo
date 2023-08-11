CREATE OR REPLACE PACKAGE transmideo IS
  PROCEDURE Update_Client_Status(client_id NUMBER, client_status NUMBER);
  PROCEDURE Add_Documentary_To_Docuserie(docuserie NUMBER, documentary_id NUMBER);
  PROCEDURE Add_Movie_To_Saga(saga NUMBER, movie_id NUMBER);
  PROCEDURE Add_Serie_To_Macroserie(macroserie NUMBER, serie_id NUMBER);
  PROCEDURE Insert_Download_Doc(documentary_language_id NUMBER, client_id NUMBER);
  PROCEDURE Insert_Download_Movie(movie_language_id NUMBER, client_id NUMBER);
  PROCEDURE Insert_Download_Serie(serie_language_id NUMBER, client_id NUMBER);
  PROCEDURE Insert_Membership(price NUMBER, client_id NUMBER);
  PROCEDURE Insert_Reproduction_Doc(documentary_language_id NUMBER, client_id NUMBER);
  PROCEDURE Insert_Reproduction_Movie(movie_language_id NUMBER, client_id NUMBER);
  PROCEDURE Insert_Reproduction_Serie(serie_language_id NUMBER, client_id NUMBER);
  PROCEDURE Insert_Client(
    name VARCHAR2,
    last_name VARCHAR2,
    direction VARCHAR2,
    phone VARCHAR2,
    birth Date,
    email VARCHAR2,
    country_id NUMBER,
    account_type_id NUMBER
  );
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
  );
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
  );
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
  );
END transmideo;
/