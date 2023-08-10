CREATE OR REPLACE PROCEDURE Insert_Movie(
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
  
  FOR i IN 1..genres.COUNT LOOP
    INSERT INTO movie_genre VALUES (genres(i), new_movie_id);
  END LOOP;

  FOR i IN 1..formats.COUNT LOOP
    INSERT INTO movie_format VALUES (formats(i), new_movie_id);
  END LOOP;

  FOR i IN 1..languages.COUNT LOOP
    INSERT INTO movie_language VALUES (new_movie_language_id, languages(i).audio_id, languages(i).subtitles_id, new_movie_id);
    new_movie_language_id := new_movie_language_id + 1;
  END LOOP;

  FOR i IN 1..castings.COUNT LOOP
    INSERT INTO cast_movie VALUES (new_movie_casting_id, castings(i).artist_id, new_movie_id);
    FOR j in 1..castings(i).roles.COUNT LOOP
      INSERT INTO cast_movie_role VALUES (new_movie_casting_id, castings(i).roles(j));
    END LOOP;
    new_movie_casting_id := new_movie_casting_id + 1;
  END LOOP;

  COMMIT;
END Insert_Movie;
/