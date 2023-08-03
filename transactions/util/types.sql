CREATE OR REPLACE TYPE number_list AS TABLE OF NUMBER;
/

CREATE OR REPLACE TYPE language_data AS OBJECT (
  audio_id NUMBER,
  subtitles_id NUMBER
);
/
CREATE OR REPLACE TYPE language_list AS TABLE OF language_data;
/

CREATE OR REPLACE TYPE casting_data AS OBJECT (
  artist_id NUMBER,
  roles number_list
);
/
CREATE OR REPLACE TYPE casting_list AS TABLE OF casting_data;
/