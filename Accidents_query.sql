
CREATE TABLE Accidents (
	id varchar(55) PRIMARY key,
	severity integer NULL,
	start_time timestamp NULL,
	end_time timestamp NULL,
	start_lat real NULL,
	start_lng real NULL,
	end_lat real NULL,
	end_lng real NULL,
	distance_ml real NULL,
	description varchar(1999) NULL,
	numbers real NULL,
	street varchar(70) NULL,
	side varchar(55) NULL,
	city varchar(55) NULL,
	county varchar(55) NULL,
	state varchar(55) NULL,
	zipcode varchar(50) NULL,
	country varchar(60) NULL,
	timezone varchar(60) NULL,
	airport_code varchar(60) NULL,
	weather_timestamp timestamp NULL,
	temperature_f real NULL,
	wind_chill_f real NULL,
	humidity_per real NULL,
	pressure_in real NULL,
	visibility_mi real NULL,
	wind_direction varchar(55) NULL,
	wind_speed_mph real NULL,
	precipitation_in real NULL,
	weather_condition varchar(55) NULL,
	amenity boolean NULL,
	bump boolean NULL,
	crossing boolean NULL,
	give_way boolean NULL,
	junction boolean NULL,
	no_exit boolean NULL,
	railway boolean NULL,
	roundabout boolean NULL,
	station boolean NULL,
	stop boolean NULL,
	traffic_calming boolean NULL,
	traffic_signal boolean NULL,
	turning_loop boolean NULL,
	sunrise_sunset varchar(55) NULL,
	civil_twilight varchar(55) NULL,
	nautical_twilight varchar(55) NULL,
	astronomical_twilight varchar(55) NULL
);


SELECT count(*) FROM accidents a;   /* wczytanych jest 2845342 wierszy  */

SELECT * FROM accidents a  /* pogląd widoku danych */
LIMIT 10;

SELECT count(*) FROM accidents a WHERE humidity_per IS null;

/* brakuje wartości numbers ( 1 743 911), (zipcode='', 1319), teimzone(''), weather timestamp, temperature_f (69 274), 
   humidity_per( 73 092), pressure_in,  visibility_mi, wind_direction('' 73 775), wind_speed_mph ( 157 944), 
   precipitation_in, weather_condition('' 70 636)
    
 */

SELECT * FROM accidents a  /* pogląd widoku danych */
LIMIT 10;

SELECT state, count(id) AS ilosc FROM accidents a  /* kraje o najwiekszych wypadkach*/
GROUP BY  state
ORDER BY ilosc DESC;

SELECT city, count(id) AS ilosc FROM accidents a  /* miasta o najczestszych wypadkach */
GROUP BY  city
ORDER BY ilosc DESC;

SELECT min(start_time), max(start_time) FROM accidents a2;   /* zakres czasu */

SELECT mode()  WITHIN GROUP ( ORDER BY start_time) FROM accidents a ;
SELECT percentile_disc(0.5)  WITHIN GROUP ( ORDER BY start_time) FROM accidents a ;


/* licze dlugosc trwania wypadku */
WITH cte AS(
SELECT id, (end_time- start_time) AS dlugosc_trwania FROM accidents
)
SELECT  percentile_disc(0.1)  WITHIN GROUP ( ORDER BY dlugosc_trwania desc) najdluzsze,
percentile_disc(0.1)  WITHIN GROUP ( ORDER BY dlugosc_trwania asc) najkrotsze,
percentile_disc(0.5)  WITHIN GROUP ( ORDER BY dlugosc_trwania asc) mediana
FROM cte;

SELECT weather_condition , count(id) AS ilosc FROM accidents a  /* w jaka pogode sa wypadki */
GROUP BY  weather_condition 
ORDER BY ilosc DESC;

SELECT sunrise_sunset , count(id) AS ilosc FROM accidents a  /* sunrise_sunset a wypadki */
GROUP BY  sunrise_sunset  
ORDER BY ilosc DESC;

SELECT visibility_mi  , count(id) AS ilosc
FROM accidents a  /* widoczność  a wypadki */
GROUP BY  visibility_mi  
ORDER BY ilosc DESC;


CREATE VIEW rozklad_lat AS /* tworzę widok, w którym dodaje dwie kolumny, rok i miesiąc, w którym dany wypadek się rozpoczął */
SELECT
id, 
to_char(start_time, 'YYYY') AS rok,
to_char(start_time, 'MM') AS miesiac 
FROM accidents a 

DROP VIEW rozklad_lat


SELECT count(id) AS ilosc, rok /* sprawdzam ilość wypadków w danym roku */
FROM rozklad_lat
GROUP BY rok 
ORDER BY rok 

SELECT count(id) AS ilosc, rok, miesiac /* ilość wypadków w danym roku w podziale na miesiące przez co będzie można sprawdzić czy jest może jakaś sezonowośc danych*/
FROM rozklad_lat
GROUP BY rok, miesiac
ORDER BY rok, miesiac


