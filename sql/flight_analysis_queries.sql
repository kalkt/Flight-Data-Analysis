-- 		AUTHOR : KARTIK K NARIYA

--     PROJECT : FLIGHT DATA ANALYSIS (FDA)

/*									-- PROJECT OBJECTIVES --

Objective 1: Analyze Flight Performance and Trends
	1.	What is the average delay time across all flights?
	2.	Which airline has the highest percentage of on-time flights?
	3.	Identify the top 5 most delayed routes in terms of average delay time.
	4.	Determine the total number of canceled flights for each airline.
	5.	What is the average journey time (scheduled and actual) for each route?
    
Objective 2: Assess Airline and Route Efficiency
	6.	Which airline operates the most number of flights?
	7.	Which routes have the shortest and longest scheduled journey times?
	8.	Calculate the percentage of delayed flights for each airline.
	9.	Identify the routes with the highest average delay minutes.
	10.	For each airline, calculate the average delay time per flight.

Objective 3: Passenger and Traffic Insights
	11.	Which airports had the highest total passengers boarding in 2023?
	12.	Identify the top 10 busiest routes based on the number of flights.
	13.	What is the average distance of flights departing from each airport?
	14.	For each city, calculate the total number of flights departing and arriving.
	15.	Which state has the highest number of originating flights?

Objective 4: Weather Impact on Flights
	16.	Analyze the correlation between precipitation levels and average delay minutes.
	17.	Identify the top 5 airports with the worst visibility conditions.
	18.	How does wind speed impact the average delay time at each airport?
	19.	For each weather condition (e.g., rain, fog), calculate the average delay time.
	20.	Determine the average delay time for flights under clear weather conditions.

Objective 5: Cancellations Analysis
	21.	What are the most common reasons for flight cancellations?
	22.	For each airline, calculate the percentage of flights canceled.
	23.	Which routes have the highest number of cancellations?
	24.	Determine the average scheduled and actual journey time for canceled flights.
    
*/

/*							-- Objective 1: Analyze Flight Performance and Trends --

			-- 	1.	What is the average delay time across all flights?
			-- 	2.	Which airline has the highest percentage of on-time flights?
			-- 	3.	Identify the top 5 most delayed routes in terms of average delay time.
			-- 	4.	Determine the total number of canceled flights for each airline.
			-- 	5.	What is the average journey time (scheduled and actual) for each route?
*/

-- 	>> 1.	What is the average delay time across all flights?
-- >> ANS: 126.89 MINUTES

SELECT ROUND(AVG(delay_minutes),2) AS Avg_Delay_in_Minutes 
FROM flights
WHERE flight_status = 'Delayed';

-- 	>> 2.	Which airline has the highest percentage of on-time flights?
-- >> ANS: Hawaiian Airlines, 76.57%

SELECT A.airline_name,
	  ROUND( (COUNT(CASE WHEN F.flight_status = 'On Time' THEN 1 END)/ COUNT(*)) * 100 , 2) AS On_Time_Percentage
FROM flights F
JOIN airlines A ON F.airline_id = A.airline_id
GROUP BY A.airline_name
ORDER BY On_Time_Percentage DESC 
LIMIT 1;

-- 	>> 3.	Identify the top 5 most delayed routes in terms of average delay time.
-- >> ANS: 
			/* ROUTE IDs: 188, 483,415,31,131&9
188	Salt Lake City International Airport				San Francisco International Airport			Salt Lake City-San Francisco	SLC-SFO	65.79 MIN
483	Louis Armstrong New Orleans International Airport	LaGuardia									New Orleans-New York			MSY-LGA	62.03 MIN
415	William P Hobby Airport								Southwest Florida International Airport		Houston-Fort Myers				HOU-RSW	54.81 MIN
31	Newark Liberty International Airport				O'Hare International Airport				Newark-Chicago					EWR-ORD	51.53 MIN
131	Chicago Midway International Airport				Dallas/Fort Worth International Airport		Chicago-Dallas					MDW-DFW	50.32 MIN        
				
			*/
WITH delayed_routes AS (
	SELECT R.route_id AS ROUTES_ID, R.origin_airport_id AS ORIGIN_AIRPORT, R.destination_airport_id AS DESTINATION_AIRPORT,
		   ROUND(AVG(delay_minutes),2) AS Avg_Delay_in_Minutes 
	FROM flights F
	JOIN routes R ON F.route_id = R.route_id
	GROUP BY R.route_id
	ORDER BY Avg_Delay_in_Minutes DESC
)

SELECT  DR.ROUTES_ID, AP1.city AS Origin_City, AP2.city AS Destination_City, AP1.airport_code AS ORIGIN, AP2.airport_code AS DESTINATION, DR.Avg_Delay_in_Minutes
FROM airports AP1, airports AP2, delayed_routes DR
WHERE AP1.airport_id = DR.ORIGIN_AIRPORT AND AP2.airport_id = DR.DESTINATION_AIRPORT
ORDER BY DR.Avg_Delay_in_Minutes DESC
LIMIT 5;

-- 	>> 4.	Determine the total number of canceled flights for each airline.
-- >> ANS:
/*
AIRLINES			CANCELED FLIGHTS
Endeavor Air			87
Repulic Airways			81
Mesa Airlines			80
Hawaiian Airlines		77
United Airlines			77
JetBlue Airways			77
Tradewind Aviation		76
Delta Air Lines			75
Allegiant Air			70
American Airlines		70
NetJets					67
Southwest Airlines		67
Frontier Airlines		65
Spirit Airlines			62
Alaska Airlines			59
*/
SELECT  A.airline_name,
		COUNT(F.flight_id) AS Total_Flights_Cancelled
FROM flights AS F
JOIN airlines AS A ON F.airline_id = A.airline_id
WHERE F.flight_status = "Canceled"
GROUP BY F.airline_id
ORDER BY Total_Flights_Cancelled DESC;

-- 	>> 5.	What is the average journey time (scheduled and actual) for each route?
-- >> ANS:
SELECT R.route_id, 
       ROUND(AVG(F.scheduled_journey_time),2) AS avg_scheduled_time_MIN, 
       ROUND(AVG(F.actual_journey_time),2) AS avg_actual_time_MIN 
FROM flights F 
JOIN routes R ON F.route_id = R.route_id 
GROUP BY R.route_id
ORDER BY avg_actual_time_MIN;

/*							-- Objective 2: Assess Airline and Route Efficiency --
             
			-- 	6.	Which airline operates the most number of flights?
			-- 	7.	Which routes have the shortest and longest scheduled journey times?
			-- 	8.	Calculate the percentage of delayed flights for each airline.
			-- 	9.	Identify the routes with the highest average delay minutes.
			-- 	10.	For each airline, calculate the average delay time per flight.
*/

-- 	>> 6.	Which airline operates the most number of flights?
/*	>> ANS:
AIRLINES		TOTAL FLIGHTS
Endeavor Air	1044
United Airlines	1040
Repulic Airways	1037
*/
SELECT A.airline_name, COUNT(F.flight_id) AS Total_Flights
FROM flights F
JOIN airlines A ON F.airline_id = A.airline_id
GROUP BY F.airline_id
ORDER BY Total_Flights DESC
LIMIT 1;

-- 	>> 7.	Which routes have the shortest and longest scheduled journey times?
-- >> ANS:
-- ROUTES WITH LONGEST SCHEDULED JOURNEY TIMES (TIME = 600 MIN)
		SELECT F.route_id, A1.airport_code AS ORIGIN, A2.airport_code AS DESTINATION, MAX(F.scheduled_journey_time) AS Longest_Journey_Time
		FROM flights F, routes R, airports A1, airports A2
        WHERE F.route_id = R.route_id AND R.origin_airport_id = A1.airport_id AND R.destination_airport_id = A2.airport_id
        GROUP BY F.route_id
        HAVING Longest_Journey_Time = (SELECT MAX(scheduled_journey_time)FROM flights)
		ORDER BY Longest_Journey_Time DESC;

-- ROUTES WITH LONGEST SCHEDULED JOURNEY TIMES (TIME = 45 MIN)
		SELECT F.route_id, A1.airport_code AS ORIGIN, A2.airport_code AS DESTINATION, MIN(F.scheduled_journey_time) AS Longest_Journey_Time
		FROM flights F, routes R, airports A1, airports A2
        WHERE F.route_id = R.route_id AND R.origin_airport_id = A1.airport_id AND R.destination_airport_id = A2.airport_id
        GROUP BY F.route_id
        HAVING Longest_Journey_Time = (SELECT MIN(scheduled_journey_time)FROM flights)
		ORDER BY Longest_Journey_Time DESC;
        
-- 	>> 8.	Calculate the percentage of delayed flights for each airline.
-- >> ANS:
SELECT A.airline_name,
	  ROUND( (COUNT(CASE WHEN F.flight_status = 'Delayed' THEN 1 END)/ COUNT(*)) * 100 , 2) AS Flights_Delayed_Percentage
FROM flights F
JOIN airlines A ON F.airline_id = A.airline_id
GROUP BY A.airline_name
ORDER BY Flights_Delayed_Percentage DESC;

-- 	>> 9.	Identify the routes with the highest average delay minutes.
-- >> ANS:
SELECT 	R.route_id, 
		A1.airport_code AS Origin_Airport, A2.airport_code AS Destination_Airport,
		ROUND(AVG(F.delay_minutes),2) AS AVG_Delay_Minutes
FROM flights F, routes R, airports A1, airports A2
WHERE F.route_id = R.route_id AND R.origin_airport_id = A1.airport_id AND R.destination_airport_id = A2.airport_id
		AND F.flight_status = 'Delayed' 
GROUP BY R.route_id 
ORDER BY AVG_Delay_Minutes DESC 
LIMIT 5;


-- 	>> 10.	For each airline, calculate the average delay time per flight.
-- >> ANS:
SELECT A.airline_name, 
       ROUND(AVG(F.delay_minutes),2) AS avg_delay_per_flight_MIN 
FROM flights F 
JOIN airlines A ON F.airline_id = A.airline_id 
WHERE F.flight_status = 'Delayed' 
GROUP BY A.airline_name
ORDER BY avg_delay_per_flight_MIN;

/*							-- Objective 3: Passenger and Traffic Insights --

		-- 	11.	Which airports had the highest total passengers boarding in 2023?
		-- 	12.	Identify the top 10 busiest routes based on the number of flights.
		-- 	13.	What is the average distance of flights departing from each airport?
		-- 	14.	For each city, calculate the total number of flights departing and arriving.
		-- 	15.	Which state has the highest number of originating flights?
*/

-- 	>> 11.	Which airports had the highest total passengers boarding in 2023?
-- >> ANS:
SELECT airport_code, airport_name, city, state, total_passengers_boarding_2023
FROM airports
ORDER BY total_passengers_boarding_2023 DESC
LIMIT 5;

-- 	>> 12.	Identify the top 10 busiest routes based on the number of flights.
-- >> ANS:
/*
PHX - SEA	50
AUS - HOU	47
DTW - SMF	47
LAS - AUS	46
RSW - FLL	43
ORD - SEA	42
PDX - BWI	42
LAS - IND	41
HOU - BWI	41
SMF - MCO	41
*/

SELECT CONCAT(A1.airport_code,' - ',A2.airport_code) AS Busiest_Routes, COUNT(*) AS No_Of_Flights 
FROM flights F, routes R, airports A1, airports A2
WHERE F.route_id = R.route_id AND R.origin_airport_id = A1.airport_id AND R.destination_airport_id = A2.airport_id
GROUP BY F.route_id
ORDER BY No_Of_Flights DESC
LIMIT 10;

-- 	>> 13.	What is the average distance of flights departing from each airport?
-- >> ANS:
/*
Hartsfield-Jackson Atlanta International Airport			ATL	2039.016522781778
Miami International Airport									MIA	2021.8825732898965
Logan International Airport									BOS	1990.4064673913035
Minneapolis-St Paul International Airport					MSP	1959.4690566037723
Denver International Airport								DEN	1956.3791194968549
John Glenn Columbus International Airport					CMH	1950.5521839080436
Dallas Love Field Airport									DAL	1946.63534562212
Lambert-St. Louis International Airport						STL	1919.6580097087358
George Bush International Airport							IAH	1841.694523809524
Phoenix Sky Harbor International Airport					PHX	1833.4862325581403
Ronald Reagan Washington National							DCA	1813.994943396222
John F. Kennedy International Airport						JFK	1763.630372093019
Orlando International Airport								MCO	1758.8899688473566
Fort Lauderdale-Hollywood International Airport				FLL	1750.325302593667
Cincinnati/Northern Kentucky International Airport			CVG	1739.6941999999988
San Antonio International Airport							SAT	1716.471410256406
LaGuardia													LGA	1690.4304195804223
San Diego International Airport								SAN	1677.3688349514593
Nashville International Airport								BNA	1669.9839224137909
Newark Liberty International Airport						EWR	1642.7583922829579
San Francisco International Airport							SFO	1629.8347482014415
Indianapolis International Airport							IND	1599.1728756476696
Detroit Metropolitan Airport								DTW	1567.1692487046646
Raleigh-Durham International Airport						RDU	1547.327060240963
Charlotte Douglas International Airport						CLT	1534.4597387173399
Oakland International Airport								OAK	1531.790070921983
Salt Lake City International Airport						SLC	1529.9560260586334
Seattle-Tacoma International Airport						SEA	1526.7303682719535
Kansas City International Airport							MCI	1513.1457591623039
Louis Armstrong New Orleans International Airport			MSY	1498.0662857142893
Luis Munoz Marin International Airport						SJU	1434.8335023041464
Norman Y. Mineta San Jose International Airport				SJC	1422.5104780876502
McCarran International Airport								LAS	1410.0862155388481
Tampa International Airport									TPA	1409.9547148288982
Honolulu International Airport								HNL	1405.6973684210536
Southwest Florida International Airport						RSW	1399.4328693181776
Dulles International Airport								IAD	1396.493413793102
Philadelphia International Airport							PHL	1383.8097252747223
Chicago Midway International Airport						MDW	1375.9669576719543
Portland International Airport								PDX	1363.6481767955793
Baltimore/Washington International Thurgood  Airport		BWI	1342.9182582582569
Dallas/Fort Worth International Airport						DFW	1319.9998148148136
Cleveland-Hopkins International Airport						CLE	1317.894651162792
Austin - Bergstrom International Airport					AUS	1267.3999664429523
Los Angeles International Airport							LAX	1244.07284745763
William P Hobby Airport										HOU	1236.5889036544854
John Wayne Airport											SNA	1219.5907812499995
Pittsburgh International Airport							PIT	1196.227845528453
Sacramento International Airport							SMF	1154.333935742972
O'Hare International Airport								ORD	1076.153820598007
*/
SELECT A1.airport_name AS Origin_Airport, A1.airport_code AS Origin_Airport_Code, 
       AVG(R.distance_miles) AS AVG_Distance 
FROM routes R, flights F, airports A1, airports A2 
WHERE R.route_id = F.route_id AND R.origin_airport_id = A1.airport_id AND R.destination_airport_id = A2.airport_id
GROUP BY R.origin_airport_id
ORDER BY AVG_Distance DESC;

-- 	>> 14.	For each city, calculate the total number of flights departing and arriving.
-- >> ANS:
SELECT A.city, 
       SUM(CASE WHEN R.origin_airport_id = A.airport_id THEN 1 ELSE 0 END) AS departing_flights, 
       SUM(CASE WHEN R.destination_airport_id = A.airport_id THEN 1 ELSE 0 END) AS arriving_flights 
FROM routes R 
JOIN airports A ON R.origin_airport_id = A.airport_id OR R.destination_airport_id = A.airport_id 
JOIN flights F ON R.route_id = F.route_id 
GROUP BY A.city
ORDER BY A.city, departing_flights DESC, arriving_flights DESC;


-- 	>> 15.	Which state has the highest number of originating flights?
-- >> ANS: CA,	originating flights = 2225
SELECT A.state, 
       SUM(CASE WHEN R.origin_airport_id = A.airport_id THEN 1 ELSE 0 END) AS departing_flights
FROM routes R 
JOIN airports A ON R.origin_airport_id = A.airport_id OR R.destination_airport_id = A.airport_id 
JOIN flights F ON R.route_id = F.route_id 
GROUP BY A.state
ORDER BY departing_flights DESC
LIMIT 1;


/*							-- Objective 4: Weather Impact on Flights --

			-- 	16.	Analyze the correlation between precipitation levels and average delay minutes.
			-- 	17.	Identify the top 5 airports with the worst visibility conditions.
			-- 	18.	How does wind speed impact the average delay time at each airport?
			-- 	19.	For each weather condition (e.g., rain, fog), calculate the average delay time.
			-- 	20.	Determine the average delay time for flights under clear weather conditions.
*/

-- 	>> 16.	Analyze the correlation between precipitation levels and average delay minutes.
-- >> ANS:
SELECT W.precipitation, 
       ROUND(AVG(F.delay_minutes),3) AS avg_delay_minutes 
FROM weather W 
JOIN airports A ON W.airport_id = A.airport_id 
JOIN routes R ON A.airport_id = R.origin_airport_id 
JOIN flights F ON R.route_id = F.route_id 
GROUP BY W.precipitation 
ORDER BY W.precipitation;
-- 	>> 17.	Identify the top 5 airports with the worst visibility conditions.
-- >> ANS:
/*
AIRPORT NAME									AVG. VISIBILITY
Oakland International Airport						4.738
Dulles International Airport						4.776
Louis Armstrong New Orleans International Airport	4.787
Denver International Airport						4.807
Fort Lauderdale-Hollywood International Airport		4.858
*/
SELECT A.airport_name, 
		ROUND(AVG(W.visibility),3) AS Avg_Visibility
FROM weather W
JOIN airports A ON W.airport_id = A.airport_id
GROUP BY A.airport_name
ORDER BY Avg_Visibility ASC
LIMIT 5;

-- 	>> 18.	How does wind speed impact the average delay time at each airport?
-- >> ANS:
SELECT A.airport_name, 
       W.wind_speed, 
       AVG(F.delay_minutes) AS Avg_Delay_Minutes 
FROM weather W 
JOIN airports A ON W.airport_id = A.airport_id 
JOIN routes R ON A.airport_id = R.origin_airport_id 
JOIN flights F ON R.route_id = F.route_id 
GROUP BY A.airport_name, W.wind_speed 
ORDER BY W.wind_speed;

-- 	>> 19.	For each weather condition (e.g., rain, fog), calculate the average delay time.
-- >> ANS:
/*
CONDITIONS		AVG. DELAY (MINUTES)
Clear				23.954
Thunderstorm		23.919
Rainy				23.913
Cloudy				23.895
Snowy				23.796
*/
SELECT W.conditions, 
       ROUND(AVG(F.delay_minutes),3) AS Avg_Delay_Minutes 
FROM weather W 
JOIN airports A ON W.airport_id = A.airport_id 
JOIN routes R ON A.airport_id = R.origin_airport_id 
JOIN flights F ON R.route_id = F.route_id 
GROUP BY W.conditions
ORDER BY Avg_Delay_Minutes DESC;


-- ---------------------------------- DOUBT : GIVING NULL VALUE ----------------------------------
-- 	>> 20.	Determine the average delay time for flights under clear weather conditions.
-- >> ANS: No delay for flights under clear weather conditions
SELECT 	W.conditions,
		AVG(F.delay_minutes) AS Avg_Delay_Minutes_Clear_Weather 
FROM weather W 
JOIN airports A ON W.airport_id = A.airport_id 
JOIN routes R ON A.airport_id = R.origin_airport_id 
JOIN flights F ON R.route_id = F.route_id 
WHERE W.conditions LIKE 'Clear'
GROUP BY W.conditions;

select count(*) from flights where flight_status = 'Delayed';

SELECT COUNT(*) AS TOTAL_FLIGHT_CLEAR_CONDITIONS
FROM flights F, routes R, airports A, weather W
WHERE F.route_id = R.route_id AND R.origin_airport_id = A.airport_id AND W.airport_id=A.airport_id AND W.conditions = 'Clear';

with Unique_delays AS (
					select distinct flight_id, delay_minutes from delays order by flight_id
				)
	select avg(UD.delay_minutes) AS Avg_Delay_Clear_Conditions
    from Unique_delays UD
    join flights F  ON  UD.flight_id = F.flight_id
    join routes R ON F.route_id = R.route_id
    join airports A ON R.origin_airport_id = A.airport_id
    join weather W ON A.airport_id = W.airport_id
    WHERE W.conditions = 'Clear' AND F.flight_id IN (UD.flight_id);
    
select distinct flight_id, delay_minutes from delays order by flight_id;

/*							-- Objective 5: Cancellations Analysis --

			-- 	21.	What are the most common reasons for flight cancellations?
			-- 	22.	For each airline, calculate the percentage of flights canceled.
			-- 	23.	Which routes have the highest number of cancellations?
			-- 	24.	Determine the average scheduled and actual journey time for canceled flights.
*/
-- 	21.	What are the most common reasons for flight cancellations?
-- >> ANS:
/*
CANCELLATION REASON		TOTAL CALCELLATIONS
Weather						 379
Operational					 367
Technical				     344
*/
SELECT cancellation_reason, 
       COUNT(*) AS total_cancellations 
FROM flights 
WHERE flight_status = 'Canceled' 
GROUP BY cancellation_reason 
ORDER BY total_cancellations DESC;

-- 	22.	For each airline, calculate the percentage of flights canceled.
-- >> ANS:
/*
airline_name		Percentage_Flights_Canceled
Endeavor Air			8.33
Tradewind Aviation		8.21
Mesa Airlines			7.86
Repulic Airways			7.81
JetBlue Airways			7.50
Hawaiian Airlines		7.45
United Airlines			7.40
Delta Air Lines			7.29
Allegiant Air			7.11
American Airlines		7.03
NetJets					6.82
Frontier Airlines		6.71
Southwest Airlines		6.69
Spirit Airlines			6.48
Alaska Airlines			6.17
*/
SELECT 	A.airline_name,
		ROUND( (COUNT(CASE WHEN F.flight_status = 'Canceled' THEN 1 END)/COUNT(*)*100) ,2 ) AS Percentage_Flights_Canceled
FROM flights F
JOIN airlines A ON F.airline_id = A.airline_id
GROUP BY A.airline_name
ORDER BY Percentage_Flights_Canceled DESC;

-- 	23.	Which routes have the highest number of cancellations?
-- >> ANS:
SELECT CONCAT(A1.airport_code,' - ',A2.airport_code) AS Routes, 
       COUNT(*) AS total_cancellations 
FROM flights F, routes R, airports A1, airports A2
WHERE F.route_id = R.route_id AND R.origin_airport_id = A1.airport_id AND R.destination_airport_id = A2.airport_id
		AND F.flight_status = 'Canceled' 
GROUP BY R.route_id 
ORDER BY total_cancellations DESC 
LIMIT 5;


-- 	24.	Determine the average scheduled and actual journey time for canceled flights.
-- >> ANS:
/*
SCHEDULED TIME		ACTUAL TIME
319.57					0
*/
SELECT ROUND(AVG(scheduled_journey_time),2) AS avg_scheduled_time_MIN, 
       AVG(actual_journey_time) AS avg_actual_time_MIN 
FROM flights 
WHERE flight_status = 'Canceled';
