-- Generated by Oracle SQL Developer Data Modeler 20.2.0.167.1538
--   at:        2023-06-25 20:06:33 CST
--   site:      Oracle Database 11g
--   type:      Oracle Database 11g



-- predefined type, no DDL - MDSYS.SDO_GEOMETRY

-- predefined type, no DDL - XMLTYPE

CREATE TABLE account_type (
    id    INTEGER NOT NULL,
    type  VARCHAR2(15) NOT NULL
);

ALTER TABLE account_type ADD CONSTRAINT account_type_pk PRIMARY KEY ( id );

CREATE TABLE artist (
    id          INTEGER NOT NULL,
    name        VARCHAR2(20) NOT NULL,
    last_name   VARCHAR2(20) NOT NULL,
    birth       DATE NOT NULL,
    country_id  INTEGER NOT NULL,
    gender_id   INTEGER NOT NULL
);

ALTER TABLE artist ADD CONSTRAINT artist_pk PRIMARY KEY ( id );

CREATE TABLE based (
    id    INTEGER NOT NULL,
    name  VARCHAR2(20) NOT NULL
);

ALTER TABLE based ADD CONSTRAINT based_pk PRIMARY KEY ( id );

CREATE TABLE cast_documentary (
    id              INTEGER NOT NULL,
    artist_id       INTEGER NOT NULL,
    documentary_id  INTEGER NOT NULL
);

ALTER TABLE cast_documentary ADD CONSTRAINT cast_documentary_pk PRIMARY KEY ( id );

CREATE TABLE cast_documentary_role (
    cast_documentary_id  INTEGER NOT NULL,
    role_id              INTEGER NOT NULL
);

ALTER TABLE cast_documentary_role ADD CONSTRAINT cast_documentary_role_pk PRIMARY KEY ( cast_documentary_id,
                                                                                        role_id );

CREATE TABLE cast_movie (
    id         INTEGER NOT NULL,
    artist_id  INTEGER NOT NULL,
    movie_id   INTEGER NOT NULL
);

ALTER TABLE cast_movie ADD CONSTRAINT cast_movie_pk PRIMARY KEY ( id );

CREATE TABLE cast_movie_role (
    cast_movie_id  INTEGER NOT NULL,
    role_id        INTEGER NOT NULL
);

ALTER TABLE cast_movie_role ADD CONSTRAINT cast_movie_role_pk PRIMARY KEY ( cast_movie_id,
                                                                            role_id );

CREATE TABLE cast_serie (
    id         INTEGER NOT NULL,
    artist_id  INTEGER NOT NULL,
    serie_id   INTEGER NOT NULL
);

ALTER TABLE cast_serie ADD CONSTRAINT cast_serie_pk PRIMARY KEY ( id );

CREATE TABLE cast_serie_role (
    cast_serie_id  INTEGER NOT NULL,
    role_id        INTEGER NOT NULL
);

ALTER TABLE cast_serie_role ADD CONSTRAINT cast_serie_role_pk PRIMARY KEY ( role_id,
                                                                            cast_serie_id );

CREATE TABLE client (
    id               INTEGER NOT NULL,
    name             VARCHAR2(30) NOT NULL,
    last_name        VARCHAR2(30) NOT NULL,
    direction        VARCHAR2(20) NOT NULL,
    phone            VARCHAR2(15) NOT NULL,
    birth            DATE NOT NULL,
    email            VARCHAR2(60) NOT NULL,
    inclusion        DATE NOT NULL,
    country_id       INTEGER NOT NULL,
    account_type_id  INTEGER NOT NULL
);

ALTER TABLE client ADD CONSTRAINT client_pk PRIMARY KEY ( id );

CREATE TABLE country (
    id    INTEGER NOT NULL,
    name  VARCHAR2(20) NOT NULL
);

ALTER TABLE country ADD CONSTRAINT country_pk PRIMARY KEY ( id );

CREATE TABLE device (
    id         INTEGER NOT NULL,
    name       VARCHAR2(45) NOT NULL,
    client_id  INTEGER NOT NULL
);

ALTER TABLE device ADD CONSTRAINT device_pk PRIMARY KEY ( id );

CREATE TABLE documentary (
    id            INTEGER NOT NULL,
    title         VARCHAR2(50) NOT NULL,
    abstract      VARCHAR2(70) NOT NULL,
    begin_date    DATE NOT NULL,
    seasons       INTEGER NOT NULL,
    chapters      INTEGER NOT NULL,
    rated_id      INTEGER NOT NULL,
    docuserie_id  INTEGER
);

ALTER TABLE documentary ADD CONSTRAINT documentary_pk PRIMARY KEY ( id );

CREATE TABLE documentary_format (
    format_id       INTEGER NOT NULL,
    documentary_id  INTEGER NOT NULL
);

ALTER TABLE documentary_format ADD CONSTRAINT documentary_format_pk PRIMARY KEY ( format_id,
                                                                                  documentary_id );

CREATE TABLE documentary_genre (
    genre_id        INTEGER NOT NULL,
    documentary_id  INTEGER NOT NULL
);

ALTER TABLE documentary_genre ADD CONSTRAINT documentary_genre_pk PRIMARY KEY ( documentary_id,
                                                                                genre_id );

CREATE TABLE documentary_language (
    id              INTEGER NOT NULL,
    audio_id        INTEGER NOT NULL,
    subtitles_id    INTEGER,
    documentary_id  INTEGER NOT NULL
);

ALTER TABLE documentary_language ADD CONSTRAINT documentary_language_pk PRIMARY KEY ( id );

CREATE TABLE docuserie (
    id        INTEGER NOT NULL,
    title     VARCHAR2(50) NOT NULL,
    abstract  VARCHAR2(70) NOT NULL,
    based_id  INTEGER NOT NULL
);

ALTER TABLE docuserie ADD CONSTRAINT docuserie_pk PRIMARY KEY ( id );

CREATE TABLE download_documentary (
    id                       INTEGER NOT NULL,
    begin_date               DATE NOT NULL,
    recent_minute            INTEGER NOT NULL,
    client_id                INTEGER NOT NULL,
    state_id                 INTEGER NOT NULL,
    documentary_language_id  INTEGER NOT NULL
);

ALTER TABLE download_documentary ADD CONSTRAINT download_documentary_pk PRIMARY KEY ( id );

CREATE TABLE download_movie (
    id                 INTEGER NOT NULL,
    day                DATE NOT NULL,
    recent_minute      INTEGER NOT NULL,
    client_id          INTEGER NOT NULL,
    state_id           INTEGER NOT NULL,
    movie_language_id  INTEGER NOT NULL
);

ALTER TABLE download_movie ADD CONSTRAINT download_movie_pk PRIMARY KEY ( id );

CREATE TABLE download_serie (
    id                 INTEGER NOT NULL,
    begin_date         DATE NOT NULL,
    recent_minute      INTEGER NOT NULL,
    client_id          INTEGER NOT NULL,
    state_id           INTEGER NOT NULL,
    serie_language_id  INTEGER NOT NULL
);

ALTER TABLE download_serie ADD CONSTRAINT download_serie_pk PRIMARY KEY ( id );

CREATE TABLE format (
    id    INTEGER NOT NULL,
    type  VARCHAR2(20) NOT NULL
);

ALTER TABLE format ADD CONSTRAINT format_pk PRIMARY KEY ( id );

CREATE TABLE gender (
    id    INTEGER NOT NULL,
    name  VARCHAR2(20) NOT NULL
);

ALTER TABLE gender ADD CONSTRAINT gender_pk PRIMARY KEY ( id );

CREATE TABLE genre (
    id    INTEGER NOT NULL,
    name  VARCHAR2(20) NOT NULL
);

ALTER TABLE genre ADD CONSTRAINT genre_pk PRIMARY KEY ( id );

CREATE TABLE language (
    id    INTEGER NOT NULL,
    name  VARCHAR2(20) NOT NULL
);

ALTER TABLE language ADD CONSTRAINT language_pk PRIMARY KEY ( id );

CREATE TABLE macroserie (
    id        INTEGER NOT NULL,
    title     VARCHAR2(50) NOT NULL,
    abstract  VARCHAR2(70) NOT NULL,
    based_id  INTEGER NOT NULL
);

ALTER TABLE macroserie ADD CONSTRAINT macroserie_pk PRIMARY KEY ( id );

CREATE TABLE movie (
    id          INTEGER NOT NULL,
    title       VARCHAR2(50) NOT NULL,
    year        DATE NOT NULL,
    length      INTEGER NOT NULL,
    country_id  INTEGER NOT NULL,
    studio_id   INTEGER NOT NULL,
    rated_id    INTEGER NOT NULL,
    saga_id     INTEGER
);

ALTER TABLE movie ADD CONSTRAINT movie_pk PRIMARY KEY ( id );

CREATE TABLE movie_format (
    format_id  INTEGER NOT NULL,
    movie_id   INTEGER NOT NULL
);

ALTER TABLE movie_format ADD CONSTRAINT movie_format_pk PRIMARY KEY ( format_id,
                                                                      movie_id );

CREATE TABLE movie_genre (
    genre_id  INTEGER NOT NULL,
    movie_id  INTEGER NOT NULL
);

ALTER TABLE movie_genre ADD CONSTRAINT movie_genre_pk PRIMARY KEY ( genre_id,
                                                                    movie_id );

CREATE TABLE movie_language (
    id            INTEGER NOT NULL,
    audio_id      INTEGER NOT NULL,
    subtitles_id  INTEGER,
    movie_id      INTEGER NOT NULL
);

ALTER TABLE movie_language ADD CONSTRAINT movie_language_pk PRIMARY KEY ( id );

CREATE TABLE rated (
    id    INTEGER NOT NULL,
    name  VARCHAR2(20) NOT NULL
);

ALTER TABLE rated ADD CONSTRAINT rated_pk PRIMARY KEY ( id );

CREATE TABLE reproduction_documentary (
    id                       INTEGER NOT NULL,
    begin_date               DATE NOT NULL,
    recent_minute            INTEGER NOT NULL,
    client_id                INTEGER NOT NULL,
    state_id                 INTEGER NOT NULL,
    documentary_language_id  INTEGER NOT NULL
);

ALTER TABLE reproduction_documentary ADD CONSTRAINT reproduction_documentary_pk PRIMARY KEY ( id );

CREATE TABLE reproduction_movie (
    id                 INTEGER NOT NULL,
    begin_date         DATE NOT NULL,
    recent_minute      INTEGER NOT NULL,
    client_id          INTEGER NOT NULL,
    state_id           INTEGER NOT NULL,
    movie_language_id  INTEGER NOT NULL
);

ALTER TABLE reproduction_movie ADD CONSTRAINT reproduction_movie_pk PRIMARY KEY ( id );

CREATE TABLE reproduction_serie (
    id                 INTEGER NOT NULL,
    begin_date         DATE NOT NULL,
    recent_minute      INTEGER NOT NULL,
    client_id          INTEGER NOT NULL,
    state_id           INTEGER NOT NULL,
    serie_language_id  INTEGER NOT NULL
);

ALTER TABLE reproduction_serie ADD CONSTRAINT reproduction_serie_pk PRIMARY KEY ( id );

CREATE TABLE role (
    id    INTEGER NOT NULL,
    name  VARCHAR2(20) NOT NULL
);

ALTER TABLE role ADD CONSTRAINT role_pk PRIMARY KEY ( id );

CREATE TABLE saga (
    id        INTEGER NOT NULL,
    title     VARCHAR2(50) NOT NULL,
    abstract  VARCHAR2(70) NOT NULL,
    based_id  INTEGER NOT NULL
);

ALTER TABLE saga ADD CONSTRAINT saga_pk PRIMARY KEY ( id );

CREATE TABLE serie (
    id             INTEGER NOT NULL,
    title          VARCHAR2(50) NOT NULL,
    abstract       VARCHAR2(70) NOT NULL,
    begin_date     DATE NOT NULL,
    seasons        INTEGER NOT NULL,
    chapters       INTEGER NOT NULL,
    rated_id       INTEGER NOT NULL,
    macroserie_id  INTEGER
);

ALTER TABLE serie ADD CONSTRAINT serie_pk PRIMARY KEY ( id );

CREATE TABLE serie_format (
    format_id  INTEGER NOT NULL,
    serie_id   INTEGER NOT NULL
);

ALTER TABLE serie_format ADD CONSTRAINT serie_format_pk PRIMARY KEY ( format_id,
                                                                      serie_id );

CREATE TABLE serie_genre (
    genre_id  INTEGER NOT NULL,
    serie_id  INTEGER NOT NULL
);

ALTER TABLE serie_genre ADD CONSTRAINT serie_genre_pk PRIMARY KEY ( genre_id,
                                                                    serie_id );

CREATE TABLE serie_language (
    id            INTEGER NOT NULL,
    audio_id      INTEGER NOT NULL,
    subtitles_id  INTEGER,
    serie_id      INTEGER NOT NULL
);

ALTER TABLE serie_language ADD CONSTRAINT serie_language_pk PRIMARY KEY ( id );

CREATE TABLE state (
    id     INTEGER NOT NULL,
    state  VARCHAR2(20) NOT NULL
);

ALTER TABLE state ADD CONSTRAINT state_pk PRIMARY KEY ( id );

CREATE TABLE studio (
    id    INTEGER NOT NULL,
    name  VARCHAR2(30) NOT NULL
);

ALTER TABLE studio ADD CONSTRAINT studio_pk PRIMARY KEY ( id );

ALTER TABLE artist
    ADD CONSTRAINT artist_country_fk FOREIGN KEY ( country_id )
        REFERENCES country ( id );

ALTER TABLE artist
    ADD CONSTRAINT artist_gender_fk FOREIGN KEY ( gender_id )
        REFERENCES gender ( id );

ALTER TABLE cast_documentary
    ADD CONSTRAINT cast_documentary_artist_fk FOREIGN KEY ( artist_id )
        REFERENCES artist ( id );

ALTER TABLE cast_documentary
    ADD CONSTRAINT cast_documentary_fk FOREIGN KEY ( documentary_id )
        REFERENCES documentary ( id );

ALTER TABLE cast_documentary_role
    ADD CONSTRAINT cast_documentary_role_fk FOREIGN KEY ( cast_documentary_id )
        REFERENCES cast_documentary ( id );

ALTER TABLE cast_documentary_role
    ADD CONSTRAINT cast_documentary_role_role_fk FOREIGN KEY ( role_id )
        REFERENCES role ( id );

ALTER TABLE cast_movie
    ADD CONSTRAINT cast_movie_artist_fk FOREIGN KEY ( artist_id )
        REFERENCES artist ( id );

ALTER TABLE cast_movie
    ADD CONSTRAINT cast_movie_movie_fk FOREIGN KEY ( movie_id )
        REFERENCES movie ( id );

ALTER TABLE cast_movie_role
    ADD CONSTRAINT cast_movie_role_movie_fk FOREIGN KEY ( cast_movie_id )
        REFERENCES cast_movie ( id );

ALTER TABLE cast_movie_role
    ADD CONSTRAINT cast_movie_role_role_fk FOREIGN KEY ( role_id )
        REFERENCES role ( id );

ALTER TABLE cast_serie
    ADD CONSTRAINT cast_serie_artist_fk FOREIGN KEY ( artist_id )
        REFERENCES artist ( id );

ALTER TABLE cast_serie_role
    ADD CONSTRAINT cast_serie_role_cast_fk FOREIGN KEY ( cast_serie_id )
        REFERENCES cast_serie ( id );

ALTER TABLE cast_serie_role
    ADD CONSTRAINT cast_serie_role_role_fk FOREIGN KEY ( role_id )
        REFERENCES role ( id );

ALTER TABLE cast_serie
    ADD CONSTRAINT cast_serie_serie_fk FOREIGN KEY ( serie_id )
        REFERENCES serie ( id );

ALTER TABLE client
    ADD CONSTRAINT client_account_type_fk FOREIGN KEY ( account_type_id )
        REFERENCES account_type ( id );

ALTER TABLE client
    ADD CONSTRAINT client_country_fk FOREIGN KEY ( country_id )
        REFERENCES country ( id );

ALTER TABLE device
    ADD CONSTRAINT device_client_fk FOREIGN KEY ( client_id )
        REFERENCES client ( id );

ALTER TABLE documentary
    ADD CONSTRAINT documentary_docuserie_fk FOREIGN KEY ( docuserie_id )
        REFERENCES docuserie ( id );

ALTER TABLE documentary_format
    ADD CONSTRAINT documentary_format_fk FOREIGN KEY ( documentary_id )
        REFERENCES documentary ( id );

ALTER TABLE documentary_format
    ADD CONSTRAINT documentary_format_format_fk FOREIGN KEY ( format_id )
        REFERENCES format ( id );

ALTER TABLE documentary_genre
    ADD CONSTRAINT documentary_genre_docu_fk FOREIGN KEY ( documentary_id )
        REFERENCES documentary ( id );

ALTER TABLE documentary_genre
    ADD CONSTRAINT documentary_genre_genre_fk FOREIGN KEY ( genre_id )
        REFERENCES genre ( id );

ALTER TABLE documentary_language
    ADD CONSTRAINT documentary_lang_fk FOREIGN KEY ( documentary_id )
        REFERENCES documentary ( id );

ALTER TABLE documentary_language
    ADD CONSTRAINT documentary_lang_lang_fk FOREIGN KEY ( audio_id )
        REFERENCES language ( id );

ALTER TABLE documentary_language
    ADD CONSTRAINT documentary_lang_lang_fkv2 FOREIGN KEY ( subtitles_id )
        REFERENCES language ( id );

ALTER TABLE documentary
    ADD CONSTRAINT documentary_rated_fk FOREIGN KEY ( rated_id )
        REFERENCES rated ( id );

ALTER TABLE docuserie
    ADD CONSTRAINT docuserie_based_fk FOREIGN KEY ( based_id )
        REFERENCES based ( id );

ALTER TABLE download_documentary
    ADD CONSTRAINT download_documentary_client_fk FOREIGN KEY ( client_id )
        REFERENCES client ( id );

ALTER TABLE download_documentary
    ADD CONSTRAINT download_documentary_lang_fk FOREIGN KEY ( documentary_language_id )
        REFERENCES documentary_language ( id );

ALTER TABLE download_documentary
    ADD CONSTRAINT download_documentary_state_fk FOREIGN KEY ( state_id )
        REFERENCES state ( id );

ALTER TABLE download_movie
    ADD CONSTRAINT download_movie_client_fk FOREIGN KEY ( client_id )
        REFERENCES client ( id );

ALTER TABLE download_movie
    ADD CONSTRAINT download_movie_lang_fk FOREIGN KEY ( movie_language_id )
        REFERENCES movie_language ( id );

ALTER TABLE download_movie
    ADD CONSTRAINT download_movie_state_fk FOREIGN KEY ( state_id )
        REFERENCES state ( id );

ALTER TABLE download_serie
    ADD CONSTRAINT download_serie_client_fk FOREIGN KEY ( client_id )
        REFERENCES client ( id );

ALTER TABLE download_serie
    ADD CONSTRAINT download_serie_lang_fk FOREIGN KEY ( serie_language_id )
        REFERENCES serie_language ( id );

ALTER TABLE download_serie
    ADD CONSTRAINT download_serie_state_fk FOREIGN KEY ( state_id )
        REFERENCES state ( id );

ALTER TABLE macroserie
    ADD CONSTRAINT macroserie_based_fk FOREIGN KEY ( based_id )
        REFERENCES based ( id );

ALTER TABLE movie
    ADD CONSTRAINT movie_country_fk FOREIGN KEY ( country_id )
        REFERENCES country ( id );

ALTER TABLE movie_format
    ADD CONSTRAINT movie_format_format_fk FOREIGN KEY ( format_id )
        REFERENCES format ( id );

ALTER TABLE movie_format
    ADD CONSTRAINT movie_format_movie_fk FOREIGN KEY ( movie_id )
        REFERENCES movie ( id );

ALTER TABLE movie_genre
    ADD CONSTRAINT movie_genre_genre_fk FOREIGN KEY ( genre_id )
        REFERENCES genre ( id );

ALTER TABLE movie_genre
    ADD CONSTRAINT movie_genre_movie_fk FOREIGN KEY ( movie_id )
        REFERENCES movie ( id );

ALTER TABLE movie_language
    ADD CONSTRAINT movie_lang_lang_fk FOREIGN KEY ( subtitles_id )
        REFERENCES language ( id );

ALTER TABLE movie_language
    ADD CONSTRAINT movie_lang_lang_fkv2 FOREIGN KEY ( audio_id )
        REFERENCES language ( id );

ALTER TABLE movie_language
    ADD CONSTRAINT movie_lang_movie_fk FOREIGN KEY ( movie_id )
        REFERENCES movie ( id );

ALTER TABLE movie
    ADD CONSTRAINT movie_rated_fk FOREIGN KEY ( rated_id )
        REFERENCES rated ( id );

ALTER TABLE movie
    ADD CONSTRAINT movie_saga_fk FOREIGN KEY ( saga_id )
        REFERENCES saga ( id );

ALTER TABLE movie
    ADD CONSTRAINT movie_studio_fk FOREIGN KEY ( studio_id )
        REFERENCES studio ( id );

ALTER TABLE reproduction_documentary
    ADD CONSTRAINT reproduction_docu_client_fk FOREIGN KEY ( client_id )
        REFERENCES client ( id );

ALTER TABLE reproduction_documentary
    ADD CONSTRAINT reproduction_docu_lang_fk FOREIGN KEY ( documentary_language_id )
        REFERENCES documentary_language ( id );

ALTER TABLE reproduction_documentary
    ADD CONSTRAINT reproduction_docu_state_fk FOREIGN KEY ( state_id )
        REFERENCES state ( id );

ALTER TABLE reproduction_movie
    ADD CONSTRAINT reproduction_movie_client_fk FOREIGN KEY ( client_id )
        REFERENCES client ( id );

ALTER TABLE reproduction_movie
    ADD CONSTRAINT reproduction_movie_lang_fk FOREIGN KEY ( movie_language_id )
        REFERENCES movie_language ( id );

ALTER TABLE reproduction_movie
    ADD CONSTRAINT reproduction_movie_state_fk FOREIGN KEY ( state_id )
        REFERENCES state ( id );

ALTER TABLE reproduction_serie
    ADD CONSTRAINT reproduction_serie_client_fk FOREIGN KEY ( client_id )
        REFERENCES client ( id );

ALTER TABLE reproduction_serie
    ADD CONSTRAINT reproduction_serie_lang_fk FOREIGN KEY ( serie_language_id )
        REFERENCES serie_language ( id );

ALTER TABLE reproduction_serie
    ADD CONSTRAINT reproduction_serie_state_fk FOREIGN KEY ( state_id )
        REFERENCES state ( id );

ALTER TABLE saga
    ADD CONSTRAINT saga_based_fk FOREIGN KEY ( based_id )
        REFERENCES based ( id );

ALTER TABLE serie_format
    ADD CONSTRAINT serie_format_format_fk FOREIGN KEY ( format_id )
        REFERENCES format ( id );

ALTER TABLE serie_format
    ADD CONSTRAINT serie_format_serie_fk FOREIGN KEY ( serie_id )
        REFERENCES serie ( id );

ALTER TABLE serie_genre
    ADD CONSTRAINT serie_genre_genre_fk FOREIGN KEY ( genre_id )
        REFERENCES genre ( id );

ALTER TABLE serie_genre
    ADD CONSTRAINT serie_genre_serie_fk FOREIGN KEY ( serie_id )
        REFERENCES serie ( id );

ALTER TABLE serie_language
    ADD CONSTRAINT serie_lang_lang_fk FOREIGN KEY ( audio_id )
        REFERENCES language ( id );

ALTER TABLE serie_language
    ADD CONSTRAINT serie_lang_lang_fkv2 FOREIGN KEY ( subtitles_id )
        REFERENCES language ( id );

ALTER TABLE serie_language
    ADD CONSTRAINT serie_lang_serie_fk FOREIGN KEY ( serie_id )
        REFERENCES serie ( id );

ALTER TABLE serie
    ADD CONSTRAINT serie_macroserie_fk FOREIGN KEY ( macroserie_id )
        REFERENCES macroserie ( id );

ALTER TABLE serie
    ADD CONSTRAINT serie_rated_fk FOREIGN KEY ( rated_id )
        REFERENCES rated ( id );



-- Oracle SQL Developer Data Modeler Summary Report: 
-- 
-- CREATE TABLE                            41
-- CREATE INDEX                             0
-- ALTER TABLE                            108
-- CREATE VIEW                              0
-- ALTER VIEW                               0
-- CREATE PACKAGE                           0
-- CREATE PACKAGE BODY                      0
-- CREATE PROCEDURE                         0
-- CREATE FUNCTION                          0
-- CREATE TRIGGER                           0
-- ALTER TRIGGER                            0
-- CREATE COLLECTION TYPE                   0
-- CREATE STRUCTURED TYPE                   0
-- CREATE STRUCTURED TYPE BODY              0
-- CREATE CLUSTER                           0
-- CREATE CONTEXT                           0
-- CREATE DATABASE                          0
-- CREATE DIMENSION                         0
-- CREATE DIRECTORY                         0
-- CREATE DISK GROUP                        0
-- CREATE ROLE                              0
-- CREATE ROLLBACK SEGMENT                  0
-- CREATE SEQUENCE                          0
-- CREATE MATERIALIZED VIEW                 0
-- CREATE MATERIALIZED VIEW LOG             0
-- CREATE SYNONYM                           0
-- CREATE TABLESPACE                        0
-- CREATE USER                              0
-- 
-- DROP TABLESPACE                          0
-- DROP DATABASE                            0
-- 
-- REDACTION POLICY                         0
-- 
-- ORDS DROP SCHEMA                         0
-- ORDS ENABLE SCHEMA                       0
-- ORDS ENABLE OBJECT                       0
-- 
-- ERRORS                                   0
-- WARNINGS                                 0
