DECLARE
  genres number_list := number_list();
  formats number_list := number_list();
  languages language_list := language_list();
  castings casting_list := casting_list();
Begin
  --Insert_Client('Fernando', 'Solano', 'Hatillo', '8472-7296', to_date('31/07/00','DD/MM/RR'), 'fesolano@gmail.com', 1, 1); 
  --Insert_Membership(10000, 51); 

  --Insert_Reproduction_Movie(41, 51);
  --Insert_Reproduction_Serie(81, 51);
  --Insert_Reproduction_Doc(61, 51);

  Insert_Download_Movie(41, 51);
  Insert_Download_Serie(81, 51);
  Insert_Download_Doc(61, 51);

  genres.extend;
  genres(1) := 3;
  genres.extend;
  genres(2) := 8;
  genres.extend;
  genres(3) := 7;

  formats.extend;
  formats(1) := 1;
  formats.extend;
  formats(2) := 6;
  formats.extend;
  formats(3) := 4;

  languages.extend;
  languages(1) := language_data(1, 2);
  languages.extend;
  languages(2) := language_data(1, NULL);
  languages.extend;
  languages(3) := language_data(2, 1);

  castings.extend;
  castings(1) := casting_data(10, number_list(1,2));
  castings.extend;
  castings(2) := casting_data(11, number_list(2));
  castings.extend;
  castings(3) := casting_data(26, number_list(3, 4));
  castings.extend;
  castings(4) := casting_data(40, number_list(2, 4));

  --Insert_Movie('Peli Z', to_date('15/06/87','DD/MM/RR'), 254, 3, 10, 2, genres, formats, languages, castings); 

  --Insert_Serie('Serie Z', 'Serie sobre z', to_date('15/06/87','DD/MM/RR'), 254, 10, 269, 3, 2, genres, formats, languages, castings, 2); 

  --Insert_Documentary('Documental Z', 'Documental sobre z', to_date('26/09/79','DD/MM/RR'), 158, 4, 58, 1, genres, formats, languages, castings); 

End;
/