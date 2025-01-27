/*
AUTHOR : KARTIK K NARIYA

  PROJECT : FLIGHT DATA ANALYSIS (FDA)
FILE INFO : Setup file for FDA project. CREATES and LOADS data info from 
			existing csv files usings inline commands for faster imports.
*/

-- -------------------------------DELETING TABLES AND RECORDS-------------------------------
DROP TABLE IF EXISTS airlines;
DROP TABLE IF EXISTS airports;
DROP TABLE IF EXISTS delays;
DROP TABLE IF EXISTS flights;
DROP TABLE IF EXISTS routes;
DROP TABLE IF EXISTS weather;

-- COMMANDS TO DELETE RECORDS FROM TABLE, IN CASE DATA IMPORTED INCORRECTLY OR IF HALF DATA IMPORTED HALF DATA 
SET SQL_SAFE_UPDATES = 0;	-- disable safe mode to delete all records from a table
DELETE FROM flights; -- delete all records from a table
DELETE FROM airports;
DELETE FROM airlines;
DELETE FROM routes;
DELETE FROM weather;
SET SQL_SAFE_UPDATES = 1;	-- enable safe mode to delete all records from a table


-- -------------------------------CREATING TABLES-------------------------------

CREATE TABLE flights (
	flight_id INT PRIMARY KEY,
    airline_id INT,
    route_id INT, 
    flight_number VARCHAR(10),
    scheduled_departure TEXT,
    scheduled_arrival TEXT,
    actual_departure TEXT,
    actual_arrival TEXT,
    scheduled_journey_time DOUBLE,
    actual_journey_time DOUBLE,
    flight_status VARCHAR(20),
    delay_minutes DOUBLE,
    cancellation_reason TEXT
);

CREATE TABLE routes (
    route_id INT PRIMARY KEY,
    origin_airport_id INT,
    destination_airport_id INT,
    distance_miles DOUBLE
    -- FOREIGN KEY (flight_id) REFERENCES flights(flight_id)
);

CREATE TABLE airlines (
    airline_id INT PRIMARY KEY,
    airline_name VARCHAR(50),
    iata_code VARCHAR(2),
    country VARCHAR(50)
);

CREATE TABLE airports (
	airport_id INT PRIMARY KEY,
	airport_code VARCHAR(3),
    airport_name VARCHAR(100),
    city VARCHAR(50),
    state VARCHAR(10),
	country VARCHAR(50),
    latitude double,
    longitude double,
    total_passengers_boarding_2023 INT
);

CREATE TABLE delays (
    delay_id INT PRIMARY KEY,
    flight_id INT,
    delay_type TEXT,
    delay_type_id INT,
    delay_minutes INT,
	FOREIGN KEY (flight_id) REFERENCES flights(flight_id)
);

CREATE TABLE weather (
    weather_id INT PRIMARY KEY,
    airport_id INT,
    date_time DATETIME,
    temperature DOUBLE,
    precipitation DOUBLE,
    wind_speed DOUBLE,
    visibility DOUBLE,
    conditions TEXT,
	FOREIGN KEY (airport_id) REFERENCES airports(airport_id)
);
-- -------------------------------LOADING DATA-------------------------------

-- LOADING DATE INTO >>FLIGHTS<< TABLE
LOAD DATA INFILE 'D:/Homeworks/DataScience/DSHomeworks/DSSQL/DSSQL_Projects/Flights/PythonFIles/flights.csv' 
INTO TABLE flights
FIELDS TERMINATED BY ',' 
LINES TERMINATED BY '\n' 
IGNORE 1 LINES;

-- LOADING DATE INTO >>ROUTES<< TABLE
LOAD DATA INFILE 'D:/Homeworks/DataScience/DSHomeworks/DSSQL/DSSQL_Projects/Flights/PythonFiles/routes.csv' 
INTO TABLE routes
FIELDS TERMINATED BY ',' 
LINES TERMINATED BY '\n' 
IGNORE 1 LINES;

-- LOADING DATE INTO >>AIRLINES<< TABLE
LOAD DATA INFILE 'D:/Homeworks/DataScience/DSHomeworks/DSSQL/DSSQL_Projects/Flights/PythonFIles/airlines.csv' 
INTO TABLE airlines
FIELDS TERMINATED BY ',' 
LINES TERMINATED BY '\n' 
IGNORE 1 LINES;

-- LOADING DATE INTO >>AIRPORTS<< TABLE
LOAD DATA INFILE 'D:/Homeworks/DataScience/DSHomeworks/DSSQL/DSSQL_Projects/Flights/PythonFIles/airports.csv' 
INTO TABLE airports
FIELDS TERMINATED BY ',' 
LINES TERMINATED BY '\n' 
IGNORE 1 LINES;

-- LOADING DATE INTO >>DELAYS<< TABLE
LOAD DATA INFILE 'D:/Homeworks/DataScience/DSHomeworks/DSSQL/DSSQL_Projects/Flights/PythonFIles/delays.csv' 
INTO TABLE delays
FIELDS TERMINATED BY ',' 
LINES TERMINATED BY '\n' 
IGNORE 1 LINES;

-- LOADING DATE INTO >>WEATHER<< TABLE
LOAD DATA INFILE 'D:/Homeworks/DataScience/DSHomeworks/DSSQL/DSSQL_Projects/Flights/PythonFIles/weather.csv' 
INTO TABLE weather
FIELDS TERMINATED BY ',' 
LINES TERMINATED BY '\n' 
IGNORE 1 LINES;




-- -------------------------------VIEWING TABLES-------------------------------
SELECT * FROM airlines;
SELECT * FROM airports;
select * from delays;
SELECT * FROM flights;
select * from routes;
select * from weather;

-- F	14912	8	217	F92111	4/25/2023 9:07	4/25/2023 12:35	4/25/2023 12:23	4/25/2023 15:51	208	404	Delayed	196	
-- R 	id-217	Ori-16	Dest-2		1285.96miles
-- A	16	BOS	Logan International Airport	Boston	MA	United States	42.363056	-71.006389	19961410

-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>> END OF FILE <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<