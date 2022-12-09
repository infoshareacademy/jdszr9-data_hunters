/*Cel: czy pogoda, położenie geograficzne, pora dnia wpływają na liczbę wypadków
drogowych*/

SELECT *
FROM accidents a 

SELECT state, count(id) AS ilosc FROM accidents a  /* stany o najwiekszych wypadkach*/
GROUP BY  state
ORDER BY ilosc DESC;
/* najwiecej wypadkow w CA - Kalifornia 265,5k, pozniej FL - Floryda 170k, najmniej SD - Dakota Poludniowa 21, 
 * VT-Vermont przedostantnie miejsce 79*/

SELECT city, count(id) AS ilosc FROM accidents a  /* miasta o najczestszych wypadkach */
GROUP BY  city
ORDER BY ilosc DESC;
/*najwiecej wypadkow w Miami - FL/Floryda 47k, prawie 2xwiecej niz w nastepnym Orlando - FL/Floryda 26k, 
 trzecie miejsce zajmuje Los Angeles - CL/Kalifornia 23k*/

SELECT *
FROM accidents a 
WHERE a.state = 'CA'

SELECT 
avg(severity),
state 
FROM accidents a 
GROUP BY state 
ORDER BY avg(severity ) DESC ;
/* najwyzsza srednia powaznosc wypadkow byla w VT-Vermont, CA-Kalifornia dopiero na 45/49 miejscu, FL-Floryda wyzej na 43 miejscu*/

/*VT - Vermont ma prawie najmniej wypadkow (48/49 miejsce), ale ma najwyzsza srednia powaznosci*/

CREATE VIEW wypadki AS
SELECT
id,
severity ,
start_time ,
end_time ,
city ,
state ,
temperature_f ,
humidity_per ,
pressure_in ,
visibility_mi ,
wind_speed_mph ,
precipitation_in ,
weather_condition ,
sunrise_sunset 
FROM accidents a 

SELECT * FROM wypadki w 

SELECT 
avg(wind_speed_mph),
state 
FROM accidents a 
GROUP BY state 
ORDER BY avg(wind_speed_mph  ) DESC ;

/*najwieksza srednia predkosci wiatru byla w WY - Wyoming, FL - FLoryda 29/49 miejsce, CA-Karolina 40/49 miejsce*/

SELECT 
avg(temperature_f),
state 
FROM accidents a 
GROUP BY state 
ORDER BY avg(temperature_f) DESC 
LIMIT 10;
/* najwyzsza srednia temperatura byla na FL-Floryda 77.78*/
/*najnizsza srednia temperatura byla SD - Dakota Pludniowa 34.68*/

SELECT 
avg(temperature_f),
state 
FROM accidents a 
GROUP BY state  
ORDER BY avg(temperature_f) asc;
/*najnizsza srednia temperatura byla Drayton - Dakota Polnocna -8*/

SELECT 
avg(visibility_mi),
state 
FROM accidents a 
GROUP BY state 
ORDER BY avg(visibility_mi) DESC  ;


SELECT state , ABS (corr(severity , temperature_f)) korelacja
FROM accidents a
GROUP BY state 
ORDER BY korelacja DESC ;
/*korelacja 0.23*/

SELECT city , ABS (corr(severity , temperature_f)) korelacja
FROM accidents a
GROUP BY city  
ORDER BY korelacja DESC;

SELECT state , ABS (corr(severity , pressure_in)) korelacja
FROM accidents a
GROUP BY state 
ORDER BY korelacja DESC ;
/*wieksza korelacja z cisnieniem*/


SELECT city  , ABS (corr(severity , pressure_in)) korelacja
FROM accidents a
GROUP BY city 
ORDER BY korelacja DESC ;

SELECT state , ABS (corr(severity , humidity_per)) korelacja
FROM accidents a
GROUP BY state 
ORDER BY korelacja DESC ;
/*mala korelacja*/

SELECT state , ABS (corr(severity , visibility_mi)) korelacja
FROM accidents a
GROUP BY state 
ORDER BY korelacja DESC ;
/*mala korelacja*/

SELECT state , ABS (corr(severity , wind_speed_mph)) korelacja
FROM accidents a
GROUP BY state 
ORDER BY korelacja DESC ;
/*mala korelacja*/

SELECT state , ABS (corr(severity , precipitation_in)) korelacja
FROM accidents a
GROUP BY state 
ORDER BY korelacja DESC ;
/*mala korelacja*/

SELECT state , ABS (corr(severity , precipitation_in)) korelacja
FROM accidents a
GROUP BY state 
ORDER BY korelacja DESC ;
/*mala korelacja*/

SELECT city, state , ABS (corr(severity , precipitation_in)) korelacja
FROM accidents a
WHERE state = 'CA' 
GROUP BY city, state
ORDER BY korelacja DESC ;

CREATE VIEW ilosc_stany AS
SELECT id, 
severity , state , temperature_f ,
humidity_per ,
pressure_in ,
visibility_mi ,
wind_speed_mph ,
precipitation_in,
count(id) AS ilosc
FROM accidents a  
GROUP BY  state, id
ORDER BY ilosc DESC;


sum(ilosc) suma,
ABS (corr(severity , temperature_f)) korelacja
FROM ilosc_stany is2 
GROUP BY state, ilosc 
ORDER BY suma DESC ;

SELECT state ,
sum(ilosc) suma,
ABS (corr(severity , temperature_f)) korelacja
FROM ilosc_stany is2 
GROUP BY state, ilosc 
ORDER BY korelacja DESC ;
/*najwieksza korelacja ta gdzie najmniej wypadkow*/

SELECT state ,
sum(ilosc) suma,
ABS (corr(severity , humidity_per)) korelacja
FROM ilosc_stany is2 
GROUP BY state, ilosc 
ORDER BY korelacja DESC ;

SELECT state ,
sum(ilosc) suma,
ABS (corr(severity , pressure_in)) korelacja
FROM ilosc_stany is2 
GROUP BY state, ilosc 
ORDER BY korelacja DESC ;
/*korelacja 0,5 SD*/

SELECT state ,
sum(ilosc) suma,
ABS (corr(severity , visibility_mi)) korelacja
FROM ilosc_stany is2 
GROUP BY state, ilosc 
ORDER BY korelacja DESC ;
/*korelacja 0.39 SD*/



SELECT state ,
sum(ilosc) suma,
ABS (corr(severity , wind_speed_mph)) korelacja
FROM ilosc_stany is2 
GROUP BY state, ilosc 
ORDER BY korelacja DESC ;
/*korelacja 0.1*/

SELECT state ,
sum(ilosc) suma,
ABS (corr(severity , precipitation_in)) korelacja
FROM ilosc_stany is2 
GROUP BY state, ilosc 
ORDER BY korelacja DESC ;
/*korelacja 0.16*/




CREATE VIEW ilosc_city AS
SELECT id, 
severity , state , temperature_f ,
humidity_per ,
pressure_in ,
visibility_mi ,
wind_speed_mph ,
city,
precipitation_in,
count(id) AS ilosc
FROM accidents a  
GROUP BY  state, id
ORDER BY ilosc DESC;

SELECT city ,
sum(ilosc) suma,
ABS (corr(severity , pressure_in)) korelacja
FROM ilosc_city ic 
GROUP BY city, ilosc 
ORDER BY city DESC ;