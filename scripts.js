var log = (text) => console.log(text);
function getRandomInt(min, max) {
  min = Math.ceil(min);
  max = Math.floor(max);
  var num = Math.floor(Math.random() * (max - min) + min);
  return num; // The maximum is exclusive and the minimum is inclusive
}
function getRandomIntDate(min, max) {
  min = Math.ceil(min);
  max = Math.floor(max);
  var num = Math.floor(Math.random() * (max - min) + min);
  return num <= 9 ? `0${num}` : num; // The maximum is exclusive and the minimum is inclusive
}

for (let index = 1; index < 41; index++) {
    log(`INSERT INTO documentary_genre VALUES (${getRandomInt(1, 4)}, ${index});`);
}
for (let index = 1; index < 41; index++) {
    log(`INSERT INTO documentary_genre VALUES (${getRandomInt(4, 7)}, ${index});`);
}
for (let index = 1; index < 41; index++) {
    log(`INSERT INTO documentary_genre VALUES (${getRandomInt(7, 10)}, ${index});`);
}
for (let index = 1; index < 41; index++) {
    log(`INSERT INTO documentary_genre VALUES (${getRandomInt(10, 13)}, ${index});`);
}


for (let index = 1; index < 41; index++) {
  log(`INSERT INTO serie_format VALUES (${getRandomInt(1, 3)}, ${index});`);
}
for (let index = 1; index < 41; index++) {
  log(`INSERT INTO serie_format VALUES (${getRandomInt(3, 5)}, ${index});`);
}
for (let index = 1; index < 41; index++) {
  log(`INSERT INTO serie_format VALUES (${getRandomInt(5, 7)}, ${index});`);
}

var i = 1;
for (let index = 1; index < 41; index++) {
    log(`INSERT INTO movie_language VALUES (${i}, ${getRandomInt(1, 4)}, null, ${index});`);
    i++;
}
for (let index = 1; index < 41; index++) {
    log(`INSERT INTO movie_language VALUES (${i}, ${getRandomInt(1, 4)}, ${getRandomInt(1, 4)}, ${index});`);
    i++;
}
var i = 1;
for (let index = 1; index < 31; index++) {
    log(`INSERT INTO documentary_language VALUES (${i}, ${getRandomInt(1, 4)}, null, ${index});`);
    i++;
}
for (let index = 1; index < 31; index++) {
    log(`INSERT INTO documentary_language VALUES (${i}, ${getRandomInt(1, 4)}, ${getRandomInt(1, 4)}, ${index});`);
    i++;
}

for (let index = 1; index < 81; index++) {
  log(`INSERT INTO reproduction_movie VALUES (${index}, to_date('${getRandomIntDate(1,28)}/${getRandomIntDate(1,13)}/${getRandomIntDate(21,24)}', 'DD/MM/RR'), ${getRandomInt(10, 45)}, ${getRandomInt(1, 51)}, ${getRandomInt(1, 3)}, ${getRandomInt(1, 81)});`);
}
for (let index = 1; index < 71; index++) {
  log(`INSERT INTO reproduction_serie VALUES (${index}, to_date('${getRandomIntDate(1,28)}/${getRandomIntDate(1,13)}/${getRandomIntDate(21,24)}', 'DD/MM/RR'), ${getRandomInt(10, 45)}, ${getRandomInt(1, 51)}, ${getRandomInt(1, 3)}, ${getRandomInt(1, 81)});`);
}
for (let index = 1; index < 51; index++) {
  log(`INSERT INTO reproduction_documentary VALUES (${index}, to_date('${getRandomIntDate(1,28)}/${getRandomIntDate(1,13)}/${getRandomIntDate(21,24)}', 'DD/MM/RR'), ${getRandomInt(10, 45)}, ${getRandomInt(1, 51)}, ${getRandomInt(1, 3)}, ${getRandomInt(1, 61)});`);
}


for (let index = 1; index < 41; index++) {
  log(`INSERT INTO download_movie VALUES (${index}, to_date('${getRandomIntDate(1,28)}/${getRandomIntDate(1,13)}/${getRandomIntDate(21,24)}', 'DD/MM/RR'), ${getRandomInt(10, 45)}, ${getRandomInt(1, 51)}, ${getRandomInt(1, 3)}, ${getRandomInt(1, 81)});`);
}
for (let index = 1; index < 21; index++) {
  log(`INSERT INTO download_serie VALUES (${index}, to_date('${getRandomIntDate(1,28)}/${getRandomIntDate(1,13)}/${getRandomIntDate(21,24)}', 'DD/MM/RR'), ${getRandomInt(10, 45)}, ${getRandomInt(1, 51)}, ${getRandomInt(1, 3)}, ${getRandomInt(1, 81)});`);
}
for (let index = 1; index < 11; index++) {
  log(`INSERT INTO download_documentary VALUES (${index}, to_date('${getRandomIntDate(1,28)}/${getRandomIntDate(1,13)}/${getRandomIntDate(21,24)}', 'DD/MM/RR'), ${getRandomInt(10, 45)}, ${getRandomInt(1, 51)}, ${getRandomInt(1, 3)}, ${getRandomInt(1, 61)});`);
}


var i = 1;
for (let index = 1; index < 51; index++) {
    log(`INSERT INTO cast_movie VALUES (${i}, ${index}, ${getRandomInt(1, 11)});`);
    i++;
}
for (let index = 1; index < 51; index++) {
    log(`INSERT INTO cast_movie VALUES (${i}, ${index}, ${getRandomInt(11, 21)});`);
    i++;
}
for (let index = 1; index < 51; index++) {
    log(`INSERT INTO cast_movie VALUES (${i}, ${index}, ${getRandomInt(21, 31)});`);
    i++;
}
for (let index = 1; index < 51; index++) {
    log(`INSERT INTO cast_movie VALUES (${i}, ${index}, ${getRandomInt(31, 41)});`);
    i++;
}
var i = 1;
for (let index = 1; index < 51; index++) {
    log(`INSERT INTO cast_serie VALUES (${i}, ${index}, ${getRandomInt(1, 11)});`);
    i++;
}
for (let index = 1; index < 51; index++) {
    log(`INSERT INTO cast_serie VALUES (${i}, ${index}, ${getRandomInt(11, 21)});`);
    i++;
}
for (let index = 1; index < 51; index++) {
    log(`INSERT INTO cast_serie VALUES (${i}, ${index}, ${getRandomInt(21, 31)});`);
    i++;
}
for (let index = 1; index < 51; index++) {
    log(`INSERT INTO cast_serie VALUES (${i}, ${index}, ${getRandomInt(31, 41)});`);
    i++;
}
var i = 1;
for (let index = 1; index < 51; index++) {
    log(`INSERT INTO cast_documentary VALUES (${i}, ${index}, ${getRandomInt(1, 11)});`);
    i++;
}
for (let index = 1; index < 51; index++) {
    log(`INSERT INTO cast_documentary VALUES (${i}, ${index}, ${getRandomInt(11, 21)});`);
    i++;
}
for (let index = 1; index < 51; index++) {
    log(`INSERT INTO cast_documentary VALUES (${i}, ${index}, ${getRandomInt(21, 31)});`);
    i++;
}


for (let index = 1; index < 201; index++) {
    log(`INSERT INTO cast_movie_role VALUES (${index}, ${getRandomInt(1, 3)});`);
}
for (let index = 1; index < 201; index++) {
    log(`INSERT INTO cast_movie_role VALUES (${index}, ${getRandomInt(3, 5)});`);
}
for (let index = 1; index < 201; index++) {
    log(`INSERT INTO cast_serie_role VALUES (${index}, ${getRandomInt(1, 3)});`);
}
for (let index = 1; index < 201; index++) {
    log(`INSERT INTO cast_serie_role VALUES (${index}, ${getRandomInt(3, 5)});`);
}
for (let index = 1; index < 151; index++) {
    log(`INSERT INTO cast_documentary_role VALUES (${index}, ${getRandomInt(1, 3)});`);
}
for (let index = 1; index < 151; index++) {
    log(`INSERT INTO cast_documentary_role VALUES (${index}, ${getRandomInt(3, 5)});`);
}