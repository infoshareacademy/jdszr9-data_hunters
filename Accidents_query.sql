
DELETE FROM accidents WHERE 1=1;

SELECT count(*) FROM accidents a;   /* wczytanych jest 2845339 wierszy  */

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

