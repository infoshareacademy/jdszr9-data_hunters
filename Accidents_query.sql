
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

SELECT count(id) FROM accidents a 


CREATE VIEW rozklad_lat AS /* tworzę widok, w którym dodaje dwie kolumny, rok i miesiąc, w którym dany wypadek się rozpoczął */
SELECT
id, 
to_char(start_time, 'YYYY') AS Year_,
to_char(start_time, 'YYYY-MM') AS Year_and_month,
to_char(start_time, 'MM') AS Month_,
to_char(start_time, 'MM-DD') AS Month_and_day,
to_char(start_time, 'YYYY-MM-DD') AS date_ 
FROM accidents a;

DROP VIEW rozklad_lat ;

CREATE VIEW daty AS
SELECT id, Year_, CAST(date_ AS date)  FROM rozklad_lat rl
LIMIT 10

DROP VIEW daty ;

CREATE VIEW ilosc_w_roku as
		SELECT 	count(id) AS number_of_accidents, 
				YEAR_ 
		FROM rozklad_lat
		GROUP BY  YEAR_
		ORDER BY  YEAR_
		


-- Widzimy, że z każdym rokiem liczba wypadków zwiększa się w 2021 wzrost jest znaczny 

CREATE VIEW ilosc_wypadków_w_czasie AS 
SELECT count(id) AS number_of_accidents, Year_and_month 
GROUP BY Year_and_month
ORDER BY Year_and_month;

CREATE VIEW ilosc_wypadków_rozdzielone_mieisace AS 
SELECT  Year_, Month_ ,count(id) AS number_of_accidents 
FROM rozklad_lat
GROUP BY Year_,  Month_
ORDER BY Year_,  Month_;

SELECT * FROM ilosc_wypadków_w_czasie;

DROP VIEW ilosc_wypadków_w_czasie;

--Chcemy teraz sprawdzić czy względniem miesiąca w poprzednim roku urosły wypadki czy zmalały 
CREATE VIEW roznica_pomiedzy_miesiacami as
WITH ilosc_w_miesiacach AS (
		SELECT  Year_, Month_ ,
				count(id) AS number_of_accidents
		FROM rozklad_lat
		GROUP BY Year_,  Month_ 
		ORDER BY Year_,  Month_ 
), poprzednie_miesiace AS (
 		SELECT 	*, 
  				LAG( number_of_accidents,12) OVER (ORDER BY Year_,  Month_ ) AS last_year
  		FROM ilosc_w_miesiacach
), roznica AS (
		SELECT 	*, 
				number_of_accidents - last_year AS difference
		FROM poprzednie_miesiace
		WHERE Last_year IS NOT NULL
) 		SELECT 	*, 
  				Max(difference) OVER (PARTITION BY  Year_) AS Maximum 
  		FROM roznica
DROP VIEW roznica_pomiedzy_miesiacami;
SELECT * FROM roznica_pomiedzy_miesiacami


-- Teraz chcemy sprawdzić jak zachowują się dane z podziałem na pory roku
-- Tworzymy widok, w którym będzie dodatkowa kolumna z nazwą pory roku  	
CREATE VIEW Pory_roku AS 		
SELECT * ,
case 
			when date_ BETWEEN '2016-01-01' and '2016-03-20'  THEN 'winter'
			when date_ BETWEEN '2016-03-21' and '2016-06-21'  THEN 'spring' 
			when date_ BETWEEN '2016-06-22' and '2016-09-22'  THEN 'summer' 
			when date_ BETWEEN '2016-09-23' and '2016-12-20'  THEN 'autumn' 
			when date_ BETWEEN '2016-12-21' and '2017-03-20'  THEN 'winter'
			when date_ BETWEEN '2017-03-21' and '2017-06-21'  THEN 'spring' 
			when date_ BETWEEN '2017-06-22' and '2017-09-22'  THEN 'summer' 
			when date_ BETWEEN '2017-09-23' and '2017-12-20'  THEN 'autumn'
			when date_ BETWEEN '2017-12-21' and '2018-03-20'  THEN 'winter'
			when date_ BETWEEN '2018-03-21' and '2018-06-21'  THEN 'spring' 
			when date_ BETWEEN '2018-06-22' and '2018-09-22'  THEN 'summer' 
			when date_ BETWEEN '2018-09-23' and '2018-12-20'  THEN 'autumn'
			when date_ BETWEEN '2018-12-21' and '2019-03-20'  THEN 'winter'
			when date_ BETWEEN '2019-03-21' and '2019-06-21'  THEN 'spring' 
			when date_ BETWEEN '2019-06-22' and '2019-09-22'  THEN 'summer' 
			when date_ BETWEEN '2019-09-23' and '2019-12-20'  THEN 'autumn' 
			when date_ BETWEEN '2019-12-21' and '2020-03-20'  THEN 'winter'
			when date_ BETWEEN '2020-03-21' and '2020-06-21'  THEN 'spring' 
			when date_ BETWEEN '2020-06-22' and '2020-09-22'  THEN 'summer' 
			when date_ BETWEEN '2020-09-23' and '2020-12-20'  THEN 'autumn' 
			when date_ BETWEEN '2020-12-21' and '2021-03-20'  THEN 'winter'
			when date_ BETWEEN '2021-03-21' and '2021-06-21'  THEN 'spring' 
			when date_ BETWEEN '2021-06-22' and '2021-09-22'  THEN 'summer' 
			when date_ BETWEEN '2021-09-23' and '2021-12-20'  THEN 'autumn'
			when date_ BETWEEN '2021-12-21' and '2021-12-31'  THEN 'winter'
			end as season
FROM daty;

-- Sprawdzamy teraz liczbę wypadków przypadających na daną porę roku

CREATE VIEW Liczba_wypadków_z_podzialem_na_pory_roku AS 
SELECT count (id), season 
FROM Pory_roku 
GROUP BY season 

-- Teraz sprawdzamy jak to wyglądało z rozbiciem na poszczególe lata

CREATE VIEW Liczba_wypadków_z_podzialem_na_pory_roku_i_lata AS 
SELECT count (id), season, year_ 
FROM Pory_roku 
GROUP BY season, year_ 






/* Chcemy sprawdzić częstość występowania wypadków w danej godzinie, gdzie podamy zaokrąglone wartości godzin*/
CREATE VIEW minuty AS /* tworzymy widok, w którym mamy dodatkowe dane, rozbicie godziny statu wypadku oraz minuty*/
SELECT id, start_time, 
	date_part('minute', start_time)  AS minuty, 
	date_part('hour', start_time)  AS godziny 
FROM accidents a;  


CREATE VIEW zaokraglona_godzina AS /* tworzymy widok, w którym zaokrąglamy godzinędo pełnej */
SELECT * ,
case 
			when minuty <= 30 then date_part('hour', start_time) 
			when minuty > 30  then date_part('hour', start_time)  +1 
			end as zaokraglenie_godziny 
FROM minuty;

/* MAmy problem, gdyż powstają dwie wersje godziny 24, musimy to ujednolicić */


CREATE VIEW zaokraglona_godzina_poprawna  AS 
SELECT * ,
case 
			when zaokraglenie_godziny = 0 then 24 /* Zamiast godziny 0 wprowadzamy 24 */

			ELSE zaokraglenie_godziny 
			end as zaokraglenie_godziny_poprawna 
FROM zaokraglona_godzina;

		
/* Teraz możemy policzyć ilość wypadków w danej godzinie*/

CREATE VIEW podzial_wypadkow_na_godziny as
SELECT count(id) AS number_of_accidents, zaokraglenie_godziny_poprawna 
FROM zaokraglona_godzina_poprawna
GROUP BY zaokraglenie_godziny_poprawna 
ORDER BY number_of_accidents DESC;	

/* Jak widać nawięcej wypadków jest w godzinach od 14 do 18 czyli w momencie powrotów ludzi z pracy , najmniej zaś w godzinach nocnych od 1 do 4 */

-- Teraz chcemy sprawdzić czy jest korelacja pomiędzy ilością wypadków a godziną 
WITH korelacja_godziny AS (
	SELECT 	count(id) AS ilosc_wypadkow, 
			zaokraglenie_godziny_poprawna 
	FROM zaokraglona_godzina_poprawna
	GROUP BY zaokraglenie_godziny_poprawna 
	ORDER BY ilosc_wypadkow desc	
)
SELECT corr(ilosc_wypadkow,zaokraglenie_godziny_poprawna) AS korelacja
FROM korelacja_godziny;

--Wartość korelacji = 0,3465



-- Teraz sprawdzimy ile wypadków jest w kolejne dni tygodnia 

CREATE VIEW wypadki_dni_tygodnia as
WITH dni_tygodnia AS (
	SELECT 	id, 
			start_time, 
			to_char(start_time, 'Day') AS dzien_wypadku
		FROM accidents a
		)
	SELECT count(id) AS ilosc,
			dzien_wypadku
	FROM dni_tygodnia 
	GROUP BY dzien_wypadku
	ORDER BY ilosc desc;


-- Jak widać w piątek jest najwięcej wypadków. 
-- Sprawdźmy zatem czy dane te będą się zmieniać na podstawie lat, 

CREATE VIEW wypadki_dni_tygodnia_z_podzialem_na_lata as
WITH dni_tygodnia_rok AS (
	SELECT 	id, 
			start_time, 
			to_char(start_time, 'Day') AS dzien_wypadku,
			to_char(start_time, 'YYYY') AS rok
		FROM accidents a
		)
	SELECT count(id) AS ilosc,
			rok, 
			dzien_wypadku
	FROM dni_tygodnia_rok
	GROUP BY rok, dzien_wypadku
	ORDER BY rok, ilosc DESC;


-- Obliczenie korelacji liczby wypadków z szerokoscia 
-- początkowo badamy dane bez zaokrąglania 

WITH korelacja_szerokosc AS (
	SELECT 	count(id) AS liczba , 
			start_lat AS szerokosc
	FROM accidents a 
	GROUP BY start_lat
)
	SELECT CORR (liczba,szerokosc)
	FROM korelacja_szerokosc;

--Wówczas korelacja wychodzi nam -0,0467


-- Zaś poniżje kod jeśli zaokrąglimy wartości do pełnych liczb
WITH korelacja_szerokosc AS (
	SELECT 	count(id) AS liczba , 
			round(start_lat) AS szerokosc
	FROM accidents a 
	GROUP BY round(start_lat)
)
	SELECT CORR (liczba,szerokosc)
	FROM korelacja_szerokosc;

-- Wówczas otrzymujemy korelację równą -0,1167


-- Sprawdzamy teraz długość geograficzną 

-- początkowo badamy dane bez zaokrąglania 

WITH korelacja_dlugosc AS (
	SELECT 	count(id) AS liczba , 
			start_lng  AS dlugosc
	FROM accidents a 
	GROUP BY start_lng
)
	SELECT CORR (liczba,dlugosc)
	FROM korelacja_dlugosc;

-- Mamy wynik -0.0447
-- Poniżej kod jeśli zaokrąglimy szerokość do liczb całkowitych 

WITH korelacja_dlugosc AS (
	SELECT 	count(id) AS liczba , 
			round(start_lng)  AS dlugosc
	FROM accidents a 
	GROUP BY round(start_lng)
)
	SELECT CORR (liczba,dlugosc)
	FROM korelacja_dlugosc;

-- Widzimy, że zaokrąglenie niewiele dało, gdyż po zaokrągleniu mamy -0,0498





