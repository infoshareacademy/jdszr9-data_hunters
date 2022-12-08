select count(*) FROM accidents a;

/* Find and compare the number of accidents for each station per day, and the number of accidents per day on extreme days
  * weather phenomena.
 */
/* 181,220 with weather / (598,961 observations on days with weather) from 2,845,342 */
DROP VIEW out_days;
CREATE TEMPORARY VIEW  out_days AS (
SELECT  DISTINCT start_time ::date AS start_date, airport_code  FROM accidents a 
WHERE weather_condition IN ('Fog',
'Haze',
'Rain',
'Smoke',
'Thunder in the Vicinity',
'Cloudy / Windy',
'T-Storm',
'Mostly Cloudy / Windy',
'Thunder',
'Snow',
'Light Rain with Thunder',
'Partly Cloudy / Windy',
'Wintry Mix',
'Heavy T-Storm',
'Mist',
'Thunderstorm',
'Shallow Fog',
'Light Freezing Rain',
'Heavy Rain / Windy',
'Showers in the Vicinity',
'Haze / Windy',
'Heavy Thunderstorms and Rain',
'Thunderstorms and Rain',
'Snow / Windy',
'Light Freezing Fog',
'Heavy T-Storm / Windy',
'Light Freezing Drizzle',
'Fog / Windy',
'T-Storm / Windy',
'Thunder / Windy',
'Heavy Snow / Windy',
'Blowing Snow',
'Blowing Dust / Windy',
'Blowing Dust',
'Heavy Drizzle',
'Light Rain Shower',
'Drizzle and Fog',
'Snow and Sleet',
'Light Drizzle / Windy',
'Blowing Snow / Windy',
'Light Ice Pellets',
'Wintry Mix / Windy',
'Light Sleet',
'Widespread Dust',
'Smoke / Windy',
'Sleet',
'Freezing Rain')
);


DROP VIEW out_view;


CREATE TEMPORARY VIEW  out_view AS (
SELECT  a.airport_code AS out_air_code,  od.start_date AS out_start  FROM out_days od
LEFT JOIN accidents a
ON od.airport_code = a.airport_code AND od.start_date =a.start_time ::date
);

DROP VIEW out_view_days;
DROP VIEW all_view_days;

CREATE TEMPORARY VIEW  out_view_days AS (
SELECT out_air_code, count(*)::float AS q_count, COUNT(DISTINCT(out_start::date)) AS out_days FROM out_view
GROUP BY out_air_code 
);

CREATE TEMPORARY VIEW  all_view_days AS (
SELECT airport_code AS all_air_code, count(*)::float AS q_count, COUNT(DISTINCT(start_time ::date)) AS all_days FROM accidents a 
GROUP BY airport_code 
);

/* statistics on accidents on days when accidents occurred at a given station */
WITH cte as(
SELECT all_air_code , (avd.q_count/ avd.all_days)::float AS all_acc_per_day,(ovd.q_count/ (ovd.out_days))::float AS out_acc_per_day,
(ovd.q_count/ (ovd.out_days))::float / (avd.q_count/ avd.all_days)::float AS out_all_ratio, 
avd.q_count AS all_count, avd.all_days AS all_period, ovd.q_count AS out_count, ovd.out_days AS out_period
FROM all_view_days avd
LEFT JOIN out_view_days ovd
ON avd.all_air_code=ovd.out_air_code
WHERE ovd.out_days>-1    /* sprawdzam dla min. 10( -1 !!!!!!)  dni aby usunąć szumy */
ORDER BY (ovd.q_count/ (ovd.out_days))::float / (avd.q_count/ avd.all_days)::float desc 
) 
SELECT sum(all_count) AS all_accidents, sum(all_period) AS all_period,
sum(all_count) / sum(all_period) AS all_ratio,
sum(out_count) AS out_accidents, sum(out_period) AS out_period,
sum(out_count) / sum(out_period) AS out_ratio
FROM cte;
