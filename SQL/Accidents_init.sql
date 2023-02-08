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


