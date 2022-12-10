select count(*) FROM accidents a;

SELECT  weather_condition, count(*) AS ilosc FROM accidents a GROUP BY weather_condition
ORDER BY ilosc DESC;

/* Find and compare the number of accidents for each station per day, and the number of accidents per day on extreme days
  * weather phenomena.
 */
/* 181,220 with weather / (598,961 observations on days with weather) from 2,845,342 */
SELECT * FROM accidents a LIMIT 5;

/* groups accidents into a set of 8 weather phenomena   */



CREATE TEMPORARY VIEW group_weather AS
(
SELECT   severity, start_time ::date AS start_date, state, airport_code , weather_condition ,
CASE
    WHEN weather_condition IN ('Fair',
'Mostly Cloudy',
'Cloudy',
'Partly Cloudy',
'Clear',
'Light Rain',
'Overcast',
'Scattered Clouds',
'Light Snow',
'Fair / Windy',
'Light Drizzle',
'Rain',
'Cloudy / Windy',
'Mostly Cloudy / Windy',
'Partly Cloudy / Windy',
'Light Rain / Windy',
'Light Snow / Windy',
'Drizzle',
'Rain / Windy',
'N/A Precipitation',
'Light Freezing Drizzle',
'Heavy Drizzle',
'Light Rain Shower',
'Light Drizzle / Windy',
'Light Rain Showers',
'Sand / Dust Whirlwinds / Windy',
'Funnel Cloud',
'Dust Whirls'
) THEN 1
    ELSE 0
END AS ordinary,
CASE
    WHEN weather_condition IN ('Snow',
'Wintry Mix',
'Heavy Snow',
'Snow / Windy',
'Heavy Snow / Windy',
'Blowing Snow',
'Light Sleet',
'Wintry Mix / Windy',
'Snow and Sleet',
'Light Ice Pellets',
'Ice Pellets',
'Light Freezing Rain / Windy',
'Snow and Sleet / Windy',
'Light Snow and Sleet / Windy',
'Snow Grains',
'Heavy Freezing Rain',
'Freezing Rain / Windy',
'Blowing Snow Nearby',
'Heavy Ice Pellets',
'Snow and Thunder / Windy',
'Heavy Freezing Drizzle',
'Heavy Blowing Snow',
'Sleet / Windy'
) THEN 1
    ELSE 0
END AS snow,
CASE
    WHEN weather_condition IN ('Fog',
'Haze',
'Smoke',
'Patches of Fog',
'Mist',
'Shallow Fog',
'Light Freezing Fog',
'Fog / Windy',
'Haze / Windy',
'Light Fog',
'Mist / Windy',
'Patches of Fog / Windy',
'Drizzle and Fog',
'Partial Fog'
) THEN 1
    ELSE 0
END AS fog,
CASE
    WHEN weather_condition IN ('Heavy Rain',
'Thunder in the Vicinity',
'T-Storm',
'Thunder',
'Light Rain with Thunder',
'Heavy T-Storm',
'Thunderstorm',
'Light Freezing Rain',
'Heavy Rain / Windy',
'Showers in the Vicinity',
'Heavy T-Storm / Windy',
'Heavy Thunderstorms and Rain',
'Thunderstorms and Rain',
'T-Storm / Windy',
'Thunder / Windy',
'Rain Shower',
'Small Hail',
'Rain Showers',
'Heavy Thunderstorms and Snow',
'Hail',
'Heavy Rain Shower',
'Heavy Snow with Thunder',
'Thunder / Wintry Mix / Windy',
'Thunder and Hail',
'Heavy Rain Showers',
'Heavy Thunderstorms with Small Hail',
'Light Thunderstorms and Rain'
) THEN 1
    ELSE 0
END AS thunder,
CASE
    WHEN weather_condition IN (
'Volcanic Ash',
'Tornado'
) THEN 1
    ELSE 0
END AS tornado,
CASE
 WHEN weather_condition IN ('Sand / Dust Whirlwinds',
'Blowing Dust / Windy',
'Blowing Dust',
'Blowing Snow / Windy',
'Widespread Dust',
'Smoke / Windy',
'Squalls / Windy',
'Widespread Dust / Windy',
'Duststorm',
'Sand',
'Sand / Windy'
) THEN 1
    ELSE 0
END AS dust
 FROM accidents a
);
 /* I count the accidents that occurred due to atmospheric phenomena in a given group */

SELECT sum(ordinary) AS c_ordinary, sum(tornado) AS c_tornado, sum(snow) AS c_snow, 
sum(fog) AS c_fog, sum(thunder) AS c_thunder, sum( dust) AS c_dust   FROM group_weather;

DROP VIEW ord_days;


CREATE TEMPORARY VIEW all_day AS (
SELECT DISTINCT start_date, airport_code   FROM group_weather
);

CREATE TEMPORARY VIEW ord_day AS (
SELECT DISTINCT start_date, airport_code   FROM group_weather
WHERE ordinary =1
);

CREATE TEMPORARY VIEW torn_day AS (
SELECT DISTINCT start_date, airport_code   FROM group_weather
WHERE tornado =1
);

CREATE TEMPORARY VIEW snow_day AS (
SELECT DISTINCT start_date, airport_code   FROM group_weather
WHERE snow =1
);

CREATE TEMPORARY VIEW fog_day AS (
SELECT DISTINCT start_date, airport_code   FROM group_weather
WHERE fog =1
);

CREATE TEMPORARY VIEW thun_day AS (
SELECT DISTINCT start_date, airport_code   FROM group_weather
WHERE thunder =1
);

CREATE TEMPORARY VIEW dust_day AS (
SELECT DISTINCT start_date, airport_code   FROM group_weather
WHERE dust =1
);

CREATE TEMPORARY VIEW out_day AS (
SELECT DISTINCT start_date, airport_code   FROM group_weather
WHERE dust=1 OR thunder = 1 OR fog =1 OR snow = 1 OR ordinary = 1 OR tornado = 1
);


CREATE TEMPORARY VIEW all_acc AS (
SELECT  gw.*  FROM all_day td
LEFT JOIN group_weather gw
ON td.airport_code = gw.airport_code AND td.start_date =gw.start_date
);

CREATE TEMPORARY VIEW ord_acc AS (
SELECT  gw.*  FROM ord_day td
LEFT JOIN group_weather gw
ON td.airport_code = gw.airport_code AND td.start_date =gw.start_date
);

CREATE TEMPORARY VIEW torn_acc AS (
SELECT  gw.*  FROM torn_day td
LEFT JOIN group_weather gw
ON td.airport_code = gw.airport_code AND td.start_date =gw.start_date
);

CREATE TEMPORARY VIEW snow_acc AS (
SELECT  gw.*  FROM snow_day td
LEFT JOIN group_weather gw
ON td.airport_code = gw.airport_code AND td.start_date =gw.start_date
);

CREATE TEMPORARY VIEW fog_acc AS (
SELECT  gw.*  FROM fog_day td
LEFT JOIN group_weather gw
ON td.airport_code = gw.airport_code AND td.start_date =gw.start_date
);


CREATE TEMPORARY VIEW thun_acc AS (
SELECT  gw.*  FROM thun_day td
LEFT JOIN group_weather gw
ON td.airport_code = gw.airport_code AND td.start_date =gw.start_date
);

CREATE TEMPORARY VIEW dust_acc AS (
SELECT  gw.*  FROM dust_day td
LEFT JOIN group_weather gw
ON td.airport_code = gw.airport_code AND td.start_date =gw.start_date
);

CREATE TEMPORARY VIEW out_acc AS (
SELECT  gw.*  FROM dust_day td
LEFT JOIN group_weather gw
ON td.airport_code = gw.airport_code AND td.start_date =gw.start_date
);

 /* I count the accidents that occurred due to atmospheric phenomena in a given group */

SELECT sum(ordinary) AS c_ordinary, sum(tornado) AS c_tornado, sum(snow) AS c_snow, 
sum(fog) AS c_fog, sum(thunder) AS c_thunder, sum( dust) AS c_dust   FROM group_weather;

/* creating a summary of statistics for days with a given weather */


WITH 
out_t AS (
SELECT 'outlier_days' AS type_of_day, avg(severity) AS severity, count(*) AS n_accidents, count(DISTINCT(airport_code, start_date)) AS n_days_air_stat,
count(DISTINCT start_date) AS n_days, round(CAST(count(*) AS decimal)/count(DISTINCT(airport_code, start_date)),2) AS n_acc_per_day_air,
round(count(*)/count(DISTINCT start_date),2) AS n_acc_per_day  FROM out_acc
), torn_t as(
SELECT 'tornado_days' AS type_of_day,avg(severity) AS severity, count(*) AS n_accidents, count(DISTINCT(airport_code, start_date)) AS n_days_air_stat,
round(count(DISTINCT start_date), 2) AS n_days, round(CAST(count(*) AS decimal)/count(DISTINCT(airport_code, start_date)), 2) AS n_acc_per_day_air,
round(count(*)/count(DISTINCT start_date),2) AS n_acc_per_day  FROM torn_acc
), ord_t as(
SELECT 'ordinary_days' AS type_of_day, avg(severity) AS severity, count(*) AS n_accidents, count(DISTINCT(airport_code, start_date)) AS n_days_air_stat,
count(DISTINCT start_date) AS n_days, round(CAST(count(*) AS decimal)/count(DISTINCT(airport_code, start_date)),2) AS n_acc_per_day_air,
round(count(*)/count(DISTINCT start_date),2) AS n_acc_per_day  FROM ord_acc
), snow_t AS(
SELECT 'snow_days' AS type_of_day, avg(severity) AS severity, count(*) AS n_accidents, count(DISTINCT(airport_code, start_date)) AS n_days_air_stat,
count(DISTINCT start_date) AS n_days, round(CAST(count(*) AS decimal)/count(DISTINCT(airport_code, start_date)),2) AS n_acc_per_day_air,
round(count(*)/count(DISTINCT start_date),2) AS n_acc_per_day  FROM snow_acc
), fog_t AS (
SELECT 'fog_days' AS type_of_day, avg(severity) AS severity, count(*) AS n_accidents, count(DISTINCT(airport_code, start_date)) AS n_days_air_stat,
count(DISTINCT start_date) AS n_days, round(CAST(count(*) AS decimal)/count(DISTINCT(airport_code, start_date)),2) AS n_acc_per_day_air,
round(count(*)/count(DISTINCT start_date),2) AS n_acc_per_day  FROM fog_acc
),thun_t AS (
SELECT 'thunder_days' AS type_of_day, avg(severity) AS severity, count(*) AS n_accidents, count(DISTINCT(airport_code, start_date)) AS n_days_air_stat,
count(DISTINCT start_date) AS n_days, round(CAST(count(*) AS decimal)/count(DISTINCT(airport_code, start_date)),2) AS n_acc_per_day_air,
round(count(*)/count(DISTINCT start_date),2) AS n_acc_per_day  FROM thun_acc
),dust_t AS (
SELECT 'dust_days' AS type_of_day, avg(severity) AS severity, count(*) AS n_accidents, count(DISTINCT(airport_code, start_date)) AS n_days_air_stat,
count(DISTINCT start_date) AS n_days, round(CAST(count(*) AS decimal)/count(DISTINCT(airport_code, start_date)),2) AS n_acc_per_day_air,
round(count(*)/count(DISTINCT start_date),2) AS n_acc_per_day  FROM dust_acc
),all_t AS (
SELECT 'all_days' AS type_of_day, avg(severity) AS severity, count(*) AS n_accidents, count(DISTINCT(airport_code, start_date)) AS n_days_air_stat,
count(DISTINCT start_date) AS n_days, round(CAST(count(*) AS decimal)/count(DISTINCT(airport_code, start_date)),2) AS n_acc_per_day_air,
round(count(*)/count(DISTINCT start_date),2) AS n_acc_per_day  FROM all_acc
) 
SELECT *  FROM torn_t
UNION 
SELECT *  FROM ord_t
UNION 
SELECT *  FROM snow_t
UNION 
SELECT *  FROM fog_t
UNION 
SELECT *  FROM thun_t
UNION 
SELECT *  FROM dust_t
UNION 
SELECT *  FROM all_t
UNION 
SELECT *  FROM out_t;
ORDER BY n_accidents DESC;

 /* creating a summary of statistics for days with a given weather, broken down by state */


WITH torn_t as(
SELECT 'tornado_days' AS type_of_day, state, avg(severity) AS severity, count(*) AS n_accidents, count(DISTINCT(airport_code, start_date)) AS n_days_air_stat,
round(CAST(count(*) AS decimal)/count(DISTINCT(airport_code, start_date)), 2) AS n_acc_per_day_air FROM torn_acc
GROUP BY state
), ord_t as(
SELECT 'ordinary_days' AS type_of_day, state, avg(severity) AS severity, count(*) AS n_accidents, count(DISTINCT(airport_code, start_date)) AS n_days_air_stat,
round(CAST(count(*) AS decimal)/count(DISTINCT(airport_code, start_date)), 2) AS n_acc_per_day_air  FROM ord_acc
GROUP BY state
), snow_t AS(
SELECT 'snow_days' AS type_of_day, state, avg(severity) AS severity, count(*) AS n_accidents, count(DISTINCT(airport_code, start_date)) AS n_days_air_stat,
 round(CAST(count(*) AS decimal)/count(DISTINCT(airport_code, start_date)),2) AS n_acc_per_day_air  FROM snow_acc
 GROUP BY state
), fog_t AS (
SELECT 'fog_days' AS type_of_day, state,  avg(severity) AS severity, count(*) AS n_accidents, count(DISTINCT(airport_code, start_date)) AS n_days_air_stat,
 round(CAST(count(*) AS decimal)/count(DISTINCT(airport_code, start_date)),2) AS n_acc_per_day_air  FROM fog_acc
 GROUP BY state
),thun_t AS (
SELECT 'thunder_days' AS type_of_day, state,  avg(severity) AS severity, count(*) AS n_accidents, count(DISTINCT(airport_code, start_date)) AS n_days_air_stat,
 round(CAST(count(*) AS decimal)/count(DISTINCT(airport_code, start_date)),2) AS n_acc_per_day_air  FROM thun_acc
 GROUP BY state
),dust_t AS (
SELECT 'dust_days' AS type_of_day, state,  avg(severity) AS severity, count(*) AS n_accidents, count(DISTINCT(airport_code, start_date)) AS n_days_air_stat,
 round(CAST(count(*) AS decimal)/count(DISTINCT(airport_code, start_date)),2) AS n_acc_per_day_air  FROM dust_acc
 GROUP BY state
),all_t AS (
SELECT 'all_days' AS type_of_day, state,  avg(severity) AS severity, count(*) AS n_accidents, count(DISTINCT(airport_code, start_date)) AS n_days_air_stat,
 round(CAST(count(*) AS decimal)/count(DISTINCT(airport_code, start_date)),2) AS n_acc_per_day_air  FROM all_acc
 GROUP BY state
) 
SELECT *  FROM torn_t
UNION 
SELECT *  FROM ord_t
UNION 
SELECT *  FROM snow_t
UNION 
SELECT *  FROM fog_t
UNION 
SELECT *  FROM thun_t
UNION 
SELECT *  FROM dust_t
UNION 
SELECT *  FROM all_t
ORDER BY n_acc_per_day_air DESC;

