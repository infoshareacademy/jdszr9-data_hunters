SELECT * FROM accidents a 

SELECT count(*) FROM accidents a;

SELECT count(*) FROM accidents a WHERE humidity_per IS null;

SELECT state, count(id) AS ilosc FROM accidents a  /* stany o najwiekszych wypadkach*/
GROUP BY  state
ORDER BY ilosc DESC;




SELECT city, count(id) AS ilosc FROM accidents a  /* miasta o najczestszych wypadkach */
GROUP BY  city
ORDER BY ilosc DESC;





---- korelacja pogody z danymi o wypadkach


SELECT count(severity) powdzial_na_powage  FROM accidents a  
GROUP BY severity; --- policzenie ilosci wypadkow w podziale na powagę wypadku


SELECT CORR(distance_ml, severity) FROM accidents a;
-- zakładamy że distance oraz severity powinny mieć dużą korelację, ale z powodu wartości severity
-- (90% posiada wartość 2) nie występuje między nimi korelacja, funkcja pokazuje wartość 0.0921
-- przez to wartość severity jest mało przydatna. chociaz tam gdzie odleglosc jest duza severity wynosi 4
-- dodatkowo wartosc distance w 99% to 0-3m


--korelacje warunkow pogodowych z dystansem:


SELECT CORR(visibility_mi, distance_ml) FROM accidents a;
-- wartość korelacji -0.034000551498645254


SELECT CORR(visibility_mi, distance_ml) FROM accidents a
WHERE city  = 'San Francisco'
AND severity = 4
-- wartość korelacji dla miasta San Francisco-0.045606334569294624


SELECT CORR(temperature_f , distance_ml) FROM accidents a;
-- wartość korelacji -0.051212337187799


SELECT CORR(wind_chill_f , distance_ml) FROM accidents a;
-- wartość korelacji -0.060094091645575935

SELECT CORR(humidity_per , distance_ml) FROM accidents a;
-- wartość korelacji 0.026860300999359633

SELECT CORR(pressure_in , distance_ml) FROM accidents a;
-- wartość korelacji -0.06911502664472892


SELECT CORR(wind_speed_mph , distance_ml) FROM accidents a;
-- wartość korelacji 0.011126628365851089    (wartość 0 dla predkosci wiatru stanowi 99% danych)

SELECT CORR(precipitation_in, distance_ml) FROM accidents a;
-- wartość korelacji 0.0030500123624382287   (wartość 0 dla opadów stanowi 99% danych)

SELECT CORR(sunrise_sunset, distance_ml) FROM accidents a; -- tu nie wiem jak określić korelacje dla pory dnia



--korelacje warunkow pogodowych z severity:


SELECT CORR(visibility_mi, severity) FROM accidents a;
-- wartość korelacji 0.007371407991880157


SELECT CORR(temperature_f , severity) FROM accidents a;
-- wartość korelacji -0.04533515865154848


SELECT CORR(wind_chill_f , severity) FROM accidents a;
-- wartość korelacji -0.0974591152695552

SELECT CORR(humidity_per , severity) FROM accidents a;
-- wartość korelacji 0.037802230516228115

SELECT CORR(pressure_in , severity) FROM accidents a;
-- wartość korelacji 0.04388287643300951


SELECT CORR(wind_speed_mph , severity) FROM accidents a;
-- wartość korelacji  0.04838158062036668  (wartość 0 dla predkosci wiatru stanowi 99% danych)

SELECT CORR(precipitation_in, severity) FROM accidents a;
-- wartość korelacji 0.013844912096698829  (wartość 0 dla opadów stanowi 99% danych)

SELECT CORR(sunrise_sunset, severity) FROM accidents a; -- tu nie wiem jak określić korelacje dla pory dnia


/*Zbadać korelacje pogody z danymi o wypadkach:
(temperature_f,, wind_chill_f, humidity_per, pressure_in, visability_mi,
wind_speed_mph, precipitation_in, sunrise_sunset .)
z danymi : distance_ml oraz severity. Które zjawiska pogodowe najsilniej korelują z
distance_ml oraz severity? Dla jakiej pogody( temperatury, wiatru itd.) jest najwięcej wypadków? */


--najwyższa zanotowana temperatura 196 st f = 91 st c. temperatura stopniowa wzrasta do 120 st f
--najniższa zanotowana temperatura  -89 st f = -67 st c. temperatura stopniowo maleje do - 30 st f




--wyliczenie najwiekszej ilości wypadków dla poszczególnych warunków pogodowych


SELECT 
round(temperature_f) AS temperature_f,
count(id) l_wypadkow
FROM accidents a 
GROUP BY temperature_f
ORDER BY count(id) desc

SELECT 
round(temperature_f) AS temperature_f,
count(id)
FROM accidents a 
GROUP BY temperature_f
ORDER BY temperature_f --- kolejnosc po temperaturze


SELECT 
round(wind_chill_f) AS,
count(id) l_wypadkow
FROM accidents a 
GROUP BY wind_chill_f 
ORDER BY count(id) DESC

SELECT 
round(humidity_per),
count(id) l_wypadkow
FROM accidents a 
GROUP BY humidity_per  
ORDER BY count(id) DESC


SELECT 
round(pressure_in),
count(id) l_wypadkow
FROM accidents a 
GROUP BY pressure_in  
ORDER BY count(id) DESC


SELECT 
round(wind_speed_mph),
count(id) l_wypadkow
FROM accidents a 
GROUP BY wind_speed_mph  
ORDER BY count(id) DESC


SELECT 
round(precipitation_in),
count(id) l_wypadkow
FROM accidents a 
GROUP BY precipitation_in  
ORDER BY count(id) DESC 


-- zostalo jeszcze uzupelnienie o pore dnia/nocy

-- wnioski: z danych wynika ze najwieksza ilosc wypadkow ma miejsce wtedy kiedy sa najczesciej pojawiajace sie warunki atmosferyczne.
-- Aby moc okreslic nasilenie sie ilosci wypadkow przy zmianach pogowoych musialisbysmy miec dodatkowy wskaznik tj. ilosc aut na drogach w danym momencie/ momencie wystapienia takiego warunku pogodowego.
-- Wowczas mozna byloby porownac 10 wypadkow na 100 aut przy ekstremalnym warunku pogodowym do 100 wypdakow na 100 000 aut przy standardowych warunkach pogodowych.
-- chyba ze powyzsze da sie uzyskac z naszych danych, zliczajac ilosc wystapien poszczegolnych warunkow pogodowych[?]



/*Zbadać korelacje pogody z danymi o wypadkach:
(temperature_f,, wind_chill_f, humidity_per, pressure_in, visability_mi,
wind_speed_mph, precipitation_in, sunrise_sunset .)
z danymi : distance_ml oraz severity. Które zjawiska pogodowe najsilniej korelują z
distance_ml oraz severity? Dla jakiej pogody( temperatury, wiatru itd.) jest najwięcej wypadków? */
