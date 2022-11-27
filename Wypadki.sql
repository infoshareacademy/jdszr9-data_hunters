SELECT *
FROM accidents a 

SELECT state, count(id) AS ilosc FROM accidents a  /* stany o najwiekszych wypadkach*/
GROUP BY  state
ORDER BY ilosc DESC;
/* najwiecej wypadkow w CA - Kolorado 265,5k, pozniej FL - Floryda 170k, najmniej SD - Dakota Poludniowa 21, 
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
/* najwyzsza srednia powaznosc wypadkow byla w VT-Vermont, CA-Kalifornia dopiero na 45 miejscu, FL-Floryda wyzej na 43 miejscu*/

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
ORDER BY avg(temperature_f) DESC ;
/* najwyzsza srednia temperatura byla na FL-Floryda 77.78*/
/*najnizsza srednia temperatura byla SD - Dakota Pludniowa 34.68*/

SELECT 
avg(temperature_f),
city 
FROM accidents a 
GROUP BY city 
ORDER BY avg(temperature_f) asc;
/*najnizsza srednia temperatura byla Drayton - Dakota Polnocna -8*/

SELECT 
avg(visibility_mi),
state 
FROM accidents a 
GROUP BY state 
ORDER BY avg(visibility_mi) DESC  ;