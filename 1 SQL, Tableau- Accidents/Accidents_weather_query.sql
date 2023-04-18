
CREATE VIEW dane as
SELECT id, start_time , end_time , state , county ,  start_lat , start_lng , severity , distance_ml ,temperature_f , wind_chill_f , humidity_per ,
pressure_in , visibility_mi , wind_speed_mph , precipitation_in , weather_condition , sunrise_sunset 
FROM accidents a;

/* Zbadać percentile, oraz skrajne wartości pogody na  distance_ml i severity Przykładowe Pytania:                      
   Dla jakiej pogody były najdluzsze wypadki , oraz najbardziej poważniejsze? 
   Jakie wypadki były dla najbardziej zjawisk atmosferycznych? 
   Jak często i jakie pojawiały się wypadki dla danego percentila wartości pogodowych? 
   Jakie zjaiwska atmosferyczne najbardziej wpływają na wypadki?
   
   */



/* Poważniejsze wypadki ( severity 4) są dla mniejszych temperature, mniejszego wind_chill, większego humidity. Dla większych severity są większe distance.
 * Co to w ogóle jest wind_chill?
 */ 

SELECT severity, avg(temperature_f) AS tmp, avg(wind_chill_f) AS wind, avg(humidity_per) AS humidity, 
avg(pressure_in) AS press, avg(visibility_mi)AS vis, avg(wind_speed_mph) AS mph,avg(precipitation_in)  AS prec
FROM dane 
GROUP BY severity;   

-- MAX i MIN wydają się być bezużyteczne. 
SELECT severity, max(temperature_f) AS tmp, max(wind_chill_f) AS wind, max(humidity_per) AS humidity, 
max(pressure_in) AS press, max(visibility_mi)AS vis, max(wind_speed_mph) AS mph,max(precipitation_in)  AS prec
FROM dane 
GROUP BY severity;  

SELECT severity, min(temperature_f) AS tmp, min(wind_chill_f) AS wind, min(humidity_per) AS humidity, 
min(pressure_in) AS press, min(visibility_mi)AS vis, min(wind_speed_mph) AS mph,min(precipitation_in)  AS prec
FROM dane 
GROUP BY severity;  



-- Dziele obserwacje o dystansie >5 na 20 grup sortując po distance i sprawdzam średnie wartości dla każdej z grup
-- Dłuższe wypadki powoduje przede wszystkim mniejsza temperature_f, mniejszy wind_chill_f. 
WITH cte AS(
SELECT *, NTILE(20) OVER(ORDER BY distance_ml asc) AS Distance_num FROM dane
WHERE distance_ml>10
)
SELECT Distance_num, avg(severity), avg(distance_ml) AS avg_dist, avg(temperature_f) AS tmp, avg(wind_chill_f) AS wind, avg(humidity_per) AS humidity, 
avg(pressure_in) AS press, avg(visibility_mi)AS vis, avg(wind_speed_mph) AS mph,avg(precipitation_in)  AS prec
FROM cte
GROUP BY Distance_num
ORDER BY Distance_num asc;







-- badam skrajne wartości pogodowe. 0.001 największych temperatur i najmniejszych temperatur
CREATE TEMPORARY VIEW srednia_danych as
SELECT 'srednia danych' AS opis, avg(severity) AS severity, avg(distance_ml) AS distance, avg(temperature_f) AS tmp, avg(wind_chill_f) AS wind, avg(humidity_per) AS humidity, 
avg(pressure_in) AS press, avg(visibility_mi)AS vis, avg(wind_speed_mph) AS mph,avg(precipitation_in) FROM dane
;

CREATE TEMPORARY VIEW najwyzsze_temperatury AS 
SELECT 'najwyzsze temperatury' AS opis, avg(severity) AS severity, avg(distance_ml) AS distance, avg(temperature_f) AS tmp, avg(wind_chill_f) AS wind, avg(humidity_per) AS humidity, 
avg(pressure_in) AS press, avg(visibility_mi)AS vis, avg(wind_speed_mph) AS mph,avg(precipitation_in) FROM dane
WHERE temperature_f > (
SELECT percentile_disc(0.001) WITHIN group(ORDER BY temperature_f desc) FROM dane
);


CREATE TEMPORARY VIEW najnizsze_temperatury AS 
SELECT 'najnizsze temperatury' AS opis, avg(severity) AS severity, avg(distance_ml) AS distance, avg(temperature_f) AS tmp, avg(wind_chill_f) AS wind, avg(humidity_per) AS humidity, 
avg(pressure_in) AS press, avg(visibility_mi)AS vis, avg(wind_speed_mph) AS mph,avg(precipitation_in) FROM dane
WHERE temperature_f < (
SELECT percentile_disc(0.001) WITHIN group(ORDER BY temperature_f asc) FROM dane
);

CREATE TEMPORARY VIEW najwyzsze_wind_speed AS 
SELECT 'najwyzsze wind_speed' AS opis, avg(severity) AS severity, avg(distance_ml) AS distance, avg(temperature_f) AS tmp, avg(wind_chill_f) AS wind, avg(humidity_per) AS humidity, 
avg(pressure_in) AS press, avg(visibility_mi)AS vis, avg(wind_speed_mph) AS mph,avg(precipitation_in) FROM dane
WHERE wind_speed_mph > (
SELECT percentile_disc(0.001) WITHIN group(ORDER BY wind_speed_mph desc) FROM dane
);


CREATE TEMPORARY VIEW najnizsze_wind_speed AS 
SELECT 'najnizsze wind_speed' AS opis, avg(severity) AS severity, avg(distance_ml) AS distance, avg(temperature_f) AS tmp, avg(wind_chill_f) AS wind, avg(humidity_per) AS humidity, 
avg(pressure_in) AS press, avg(visibility_mi)AS vis, avg(wind_speed_mph) AS mph,avg(precipitation_in) FROM dane
WHERE wind_speed_mph < (
SELECT percentile_disc(0.001) WITHIN group(ORDER BY wind_speed_mph asc) FROM dane
);

CREATE TEMPORARY VIEW najwyzsze_humidity AS 
SELECT 'najwyzsze humidity' AS opis, avg(severity) AS severity, avg(distance_ml) AS distance, avg(temperature_f) AS tmp, avg(wind_chill_f) AS wind, avg(humidity_per) AS humidity, 
avg(pressure_in) AS press, avg(visibility_mi)AS vis, avg(wind_speed_mph) AS mph,avg(precipitation_in) FROM dane
WHERE humidity_per > (
SELECT percentile_disc(0.001) WITHIN group(ORDER BY humidity_per desc) FROM dane
);


CREATE TEMPORARY VIEW najnizsze_humidity AS 
SELECT 'najnizsze humidity' AS opis, avg(severity) AS severity, avg(distance_ml) AS distance, avg(temperature_f) AS tmp, avg(wind_chill_f) AS wind, avg(humidity_per) AS humidity, 
avg(pressure_in) AS press, avg(visibility_mi)AS vis, avg(wind_speed_mph) AS mph,avg(precipitation_in) FROM dane
WHERE humidity_per < (
SELECT percentile_disc(0.001) WITHIN group(ORDER BY humidity_per asc) FROM dane
);
CREATE TEMPORARY VIEW najwyzsze_wind_chill AS 
SELECT 'najwyzsze wind_chill' AS opis, avg(severity) AS severity, avg(distance_ml) AS distance, avg(temperature_f) AS tmp, avg(wind_chill_f) AS wind, avg(humidity_per) AS humidity, 
avg(pressure_in) AS press, avg(visibility_mi)AS vis, avg(wind_speed_mph) AS mph,avg(precipitation_in) FROM dane
WHERE wind_chill_f > (
SELECT percentile_disc(0.001) WITHIN group(ORDER BY wind_chill_f desc) FROM dane
);


CREATE TEMPORARY VIEW najnizsze_wind_chill AS 
SELECT 'najnizsze wind_chill' AS opis, avg(severity) AS severity, avg(distance_ml) AS distance, avg(temperature_f) AS tmp, avg(wind_chill_f) AS wind, avg(humidity_per) AS humidity, 
avg(pressure_in) AS press, avg(visibility_mi)AS vis, avg(wind_speed_mph) AS mph,avg(precipitation_in) FROM dane
WHERE wind_chill_f < (
SELECT percentile_disc(0.001) WITHIN group(ORDER BY wind_chill_f asc) FROM dane
);

wind_chill_f


-- łącze informacje o skrajnych zjawiskach pogodowych  ( percentyl = 0.001) w tableke odsumowującą
SELECT * FROM srednia_danych
union
SELECT * FROM najwyzsze_temperatury 
UNION 
SELECT * FROM najnizsze_temperatury
UNION
SELECT * FROM najwyzsze_wind
UNION 
SELECT * FROM najnizsze_wind
UNION
SELECT * FROM najwyzsze_humidity
UNION 
SELECT * FROM najnizsze_humidity
UNION
SELECT * FROM najnizsze_wind_chill
UNION 
SELECT * FROM najwyzsze_wind_chill;

