DECLARE
  genres_movie number_list := number_list(3,8,7);
  formats_movie number_list := number_list(1,6,4);
  languages_movie language_list := language_list(language_data(1, 2), language_data(1, NULL), language_data(2, 1));
  castings_movie casting_list := casting_list(casting_data(10, number_list(1,2)), casting_data(11, number_list(2)), casting_data(26, number_list(3, 4)), casting_data(40, number_list(2, 4)));

  genres_serie number_list := number_list(4,2,1);
  formats_serie number_list := number_list(2,3,5);
  languages_serie language_list := language_list(language_data(2, 2), language_data(2, NULL), language_data(1, 2));
  castings_serie casting_list := casting_list(casting_data(21, number_list(2)), casting_data(13, number_list(1)), casting_data(14, number_list(3, 4)), casting_data(39, number_list(2, 4)));

  genres_documentary number_list := number_list(3,5,7);
  formats_documentary number_list := number_list(6,5,1);
  languages_documentary language_list := language_list(language_data(2, 1), language_data(1, 1), language_data(2, 2));
  castings_documentary casting_list := casting_list(casting_data(5, number_list(3,4)), casting_data(27, number_list(1,2)), casting_data(34, number_list(1,4)), casting_data(18, number_list(2,3)));

  alfa_id client.id%TYPE := NULL;
  beta_id client.id%TYPE := NULL;
  new_movie_id movie.id%TYPE := NULL;
  new_serie_id serie.id%TYPE := NULL;
Begin
  transmideo.Insert_Client('Alfa', 'Alfa', 'Alfa city', '1111-1111', to_date('21/03/95','DD/MM/RR'), 'alfa@gmail.com', 1, 1); 
  transmideo.Insert_Client('Beta', 'Beta', 'Beta city', '2222-2222', to_date('19/04/88','DD/MM/RR'), 'beta@gmail.com', 1, 1);

  SELECT id INTO alfa_id
  FROM client
  WHERE name = 'Alfa';
  
  SELECT id INTO beta_id
  FROM client
  WHERE name = 'Beta';

  transmideo.Insert_Membership(15000, alfa_id);
  transmideo.Insert_Movie('Pelicula nueva', to_date('15/06/87','DD/MM/RR'), 254, 3, 10, 2, genres_movie, formats_movie, languages_movie, castings_movie); 
  transmideo.Insert_Serie('Serie nueva', 'Serie buena', to_date('15/06/87','DD/MM/RR'), 254, 10, 269, 3, 2, genres_serie, formats_serie, languages_serie, castings_serie); 
  transmideo.Insert_Documentary('Documental nuevo', 'Documental bueno', to_date('26/09/79','DD/MM/RR'), 158, 4, 58, 1, genres_documentary, formats_documentary, languages_documentary, castings_documentary); 
  
  SELECT ml.id INTO new_movie_id
  FROM movie m
  INNER JOIN movie_language ml ON ml.movie_id = m.id
  WHERE m.title = 'Pelicula nueva' AND ROWNUM = 1;

  SELECT sl.id INTO new_serie_id
  FROM serie s
  INNER JOIN serie_language sl ON sl.serie_id = s.id
  WHERE s.title = 'Serie nueva' AND ROWNUM = 1;

  transmideo.Insert_Download_Movie(new_movie_id, alfa_id);
  transmideo.Insert_Reproduction_Serie(new_serie_id, beta_id);
End;
/