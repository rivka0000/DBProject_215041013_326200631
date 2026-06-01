/* =========================================================
   StageB_SelectQueries.sql
   Advanced SELECT queries for Stage B
   Transportation Management System
   ========================================================= */


/*=========================================================
QUERY 1A
Ride Management Screen
All rides with full details - JOIN version
=========================================================*/
SELECT 
    R.rideid,

    TI.t_date AS ride_date,
    EXTRACT(YEAR FROM TI.t_date) AS ride_year,
    EXTRACT(MONTH FROM TI.t_date) AS ride_month,
    EXTRACT(DAY FROM TI.t_date) AS ride_day,

    R.status AS ride_status,

    C.c_id,
    C.c_first_name || ' ' || C.c_last_name AS customer_name,
    C.c_phone AS customer_phone,

    D.licensenumber,
    D.fullname AS driver_name,

    V.platenumber,
    V.model AS vehicle_model,
    V.carcolor,

    R.origin,
    R.destination,

    RT.distancekm,
    RT.estimatedtraveltime

FROM ride R

JOIN tourinstance TI 
    ON R.t_i_id = TI.t_i_id

JOIN driver D 
    ON R.licensenumber = D.licensenumber

JOIN vehicle V 
    ON R.platenumber = V.platenumber

JOIN route RT 
    ON R.origin = RT.origin 
   AND R.destination = RT.destination

JOIN bookings B 
    ON B.t_i_id = R.t_i_id

JOIN customer C 
    ON C.c_id = B.c_id

ORDER BY TI.t_date DESC;


/* =========================================================
QUERY 1B
Ride Management Screen
All rides with full details - subquery version

Difference from 1A:
1A uses JOINs to combine all related tables in a single query.
1B retrieves the same information using subqueries for each related value,
instead of direct JOIN operations.

Result:
Both queries return the same logical output:
a full ride dashboard including ride details, customer, driver,
vehicle, route, and date breakdown from tourinstance.
========================================================= */
SELECT 
    R.rideid,

    (SELECT TI.t_date 
     FROM tourinstance TI 
     WHERE TI.t_i_id = R.t_i_id) AS ride_date,

    EXTRACT(YEAR FROM (SELECT TI.t_date FROM tourinstance TI WHERE TI.t_i_id = R.t_i_id)) AS ride_year,
    EXTRACT(MONTH FROM (SELECT TI.t_date FROM tourinstance TI WHERE TI.t_i_id = R.t_i_id)) AS ride_month,
    EXTRACT(DAY FROM (SELECT TI.t_date FROM tourinstance TI WHERE TI.t_i_id = R.t_i_id)) AS ride_day,

    R.status AS ride_status,

    R.platenumber,
    R.licensenumber,
    R.origin,
    R.destination,

    (SELECT D.fullname 
     FROM driver D 
     WHERE D.licensenumber = R.licensenumber) AS driver_name,

    (SELECT V.model 
     FROM vehicle V 
     WHERE V.platenumber = R.platenumber) AS vehicle_model,

    (SELECT V.carcolor 
     FROM vehicle V 
     WHERE V.platenumber = R.platenumber) AS carcolor,

    (SELECT C.c_id
     FROM customer C
     JOIN bookings B ON B.c_id = C.c_id
     WHERE B.t_i_id = R.t_i_id
     LIMIT 1) AS c_id,

    (SELECT C.c_first_name || ' ' || C.c_last_name
     FROM customer C
     JOIN bookings B ON B.c_id = C.c_id
     WHERE B.t_i_id = R.t_i_id
     LIMIT 1) AS customer_name,

    (SELECT C.c_phone
     FROM customer C
     JOIN bookings B ON B.c_id = C.c_id
     WHERE B.t_i_id = R.t_i_id
     LIMIT 1) AS customer_phone,

    (SELECT RT.distancekm
     FROM route RT
     WHERE RT.origin = R.origin 
       AND RT.destination = R.destination) AS distancekm,

    (SELECT RT.estimatedtraveltime
     FROM route RT
     WHERE RT.origin = R.origin 
       AND RT.destination = R.destination) AS estimatedtraveltime

FROM ride R

ORDER BY ride_date DESC;

/* =========================================================
QUERY 2A
Driver Directory / Dashboard
Drivers with the highest number of rides in a given year
GROUP BY + ORDER BY version
========================================================= */
SELECT 
    D.licensenumber,
    D.fullname,
    D.status,

    COUNT(R.rideid) AS total_rides,

    EXTRACT(YEAR FROM TI.t_date) AS ride_year

FROM driver D

JOIN ride R 
    ON R.licensenumber = D.licensenumber

JOIN tourinstance TI 
    ON R.t_i_id = TI.t_i_id

WHERE EXTRACT(YEAR FROM TI.t_date) = 2025

GROUP BY 
    D.licensenumber,
    D.fullname,
    D.status,
    EXTRACT(YEAR FROM TI.t_date)

ORDER BY total_rides DESC;


/* =========================================================
QUERY 2B
Driver Directory / Dashboard
Drivers with number of rides in a given year
Subquery version
Difference from 2A:
2A calculates the ride count using JOIN + GROUP BY directly.
2B calculates the ride count in a subquery first,
then joins the aggregated result to the DRIVER table.
Result:
Both queries return the same logical output:
drivers ranked by number of rides in 2025.
========================================================= */
SELECT 
    D.licensenumber,
    D.fullname,
    D.status,
    DriverCounts.total_rides,
    DriverCounts.ride_year

FROM driver D

JOIN (
    SELECT 
        R.licensenumber,
        COUNT(R.rideid) AS total_rides,
        EXTRACT(YEAR FROM TI.t_date) AS ride_year

    FROM ride R

    JOIN tourinstance TI 
        ON R.t_i_id = TI.t_i_id

    WHERE EXTRACT(YEAR FROM TI.t_date) = 2025

    GROUP BY 
        R.licensenumber,
        EXTRACT(YEAR FROM TI.t_date)
) AS DriverCounts

ON DriverCounts.licensenumber = D.licensenumber

ORDER BY DriverCounts.total_rides DESC;


/* =========================================================
   QUERY 3A
   Customers Directory
Customers with the highest number of rides in a given month/year
GROUP BY + ORDER BY version
========================================================= */
SELECT 
    C.c_id,
    C.c_first_name || ' ' || C.c_last_name AS full_name,
    C.c_phone,
    C.c_email,

    COUNT(R.rideid) AS total_rides,

    EXTRACT(YEAR FROM TI.t_date) AS ride_year,
    EXTRACT(MONTH FROM TI.t_date) AS ride_month

FROM customer C

JOIN bookings B 
    ON B.c_id = C.c_id

JOIN ride R 
    ON R.t_i_id = B.t_i_id

JOIN tourinstance TI 
    ON TI.t_i_id = R.t_i_id

WHERE EXTRACT(YEAR FROM TI.t_date) = 2025
  AND EXTRACT(MONTH FROM TI.t_date) = 6

GROUP BY 
    C.c_id,
    C.c_first_name,
    C.c_last_name,
    C.c_phone,
    C.c_email,
    EXTRACT(YEAR FROM TI.t_date),
    EXTRACT(MONTH FROM TI.t_date)

ORDER BY total_rides DESC;


/* =========================================================
   QUERY 3B - corrected
   Customers Directory
Customers with number of rides in a given month and year
Subquery version
Difference from 3A:
3A calculates the ride count using JOIN + GROUP BY directly.
3B calculates the ride count per customer inside a subquery,
and then joins the aggregated result back to the CUSTOMER table.
Result:
Both queries return the same logical output:
customers ranked by number of rides in June 2025.
   ========================================================= */
SELECT 
    C.c_id,
    C.c_first_name || ' ' || C.c_last_name AS full_name,
    C.c_phone,
    C.c_email,

    CustomerCounts.total_rides,
    CustomerCounts.ride_year,
    CustomerCounts.ride_month

FROM customer C

JOIN (
    SELECT 
        B.c_id,
        COUNT(R.rideid) AS total_rides,

        EXTRACT(YEAR FROM TI.t_date) AS ride_year,
        EXTRACT(MONTH FROM TI.t_date) AS ride_month

    FROM bookings B

    JOIN ride R 
        ON R.t_i_id = B.t_i_id

    JOIN tourinstance TI 
        ON TI.t_i_id = R.t_i_id

    WHERE EXTRACT(YEAR FROM TI.t_date) = 2025
      AND EXTRACT(MONTH FROM TI.t_date) = 6

    GROUP BY 
        B.c_id,
        EXTRACT(YEAR FROM TI.t_date),
        EXTRACT(MONTH FROM TI.t_date)
) AS CustomerCounts

ON CustomerCounts.c_id = C.c_id

ORDER BY CustomerCounts.total_rides DESC;

/* =========================================================
   QUERY 4A
   Vehicle Management Screen
Vehicles that were not assigned to any ride in a given year
NOT IN version
   ========================================================= */
SELECT 
    V.platenumber,
    V.model,
    V.capacity,
    V.carcolor,
    V.year,
    V.status

FROM vehicle V

WHERE V.platenumber NOT IN (
    SELECT R.platenumber
    FROM ride R
    JOIN tourinstance TI 
        ON R.t_i_id = TI.t_i_id
    WHERE EXTRACT(YEAR FROM TI.t_date) = 2025
)

ORDER BY V.model, V.platenumber;


/* =========================================================
   QUERY 4B
   Vehicle Management Screen
Vehicles that were not assigned to any ride in a given year
NOT EXISTS version
Difference from 4A:
4A uses NOT IN with a subquery list of plate numbers.
4B uses NOT EXISTS to check for existence of matching rides.
Result:
Both queries return the same logical output:
vehicles that were not used in rides during 2025.
   ========================================================= */
SELECT 
    V.platenumber,
    V.model,
    V.capacity,
    V.carcolor,
    V.year,
    V.status

FROM vehicle V

WHERE NOT EXISTS (
    SELECT 1
    FROM ride R
    JOIN tourinstance TI 
        ON R.t_i_id = TI.t_i_id
    WHERE R.platenumber = V.platenumber
      AND EXTRACT(YEAR FROM TI.t_date) = 2025
)

ORDER BY V.model, V.platenumber;


/* =========================================================
QUERY 5
Ride Activity Dashboard
Shows number of rides grouped by year and month
based on TOURINSTANCE date.
========================================================= */
SELECT 
    EXTRACT(YEAR FROM TI.t_date) AS ride_year,
    EXTRACT(MONTH FROM TI.t_date) AS ride_month,

    COUNT(R.rideid) AS total_rides

FROM ride R

JOIN tourinstance TI 
    ON R.t_i_id = TI.t_i_id

GROUP BY 
    EXTRACT(YEAR FROM TI.t_date),
    EXTRACT(MONTH FROM TI.t_date)

ORDER BY 
    ride_year,
    ride_month;


/* =========================================================
QUERY 6
Route Analysis Report
Shows most popular routes based on ride count
with yearly breakdown using TOURINSTANCE date. 
========================================================= */
SELECT 
    RT.origin,
    RT.destination,
    RT.distancekm,
    RT.estimatedtraveltime,

    COUNT(R.rideid) AS total_rides_on_route,

    EXTRACT(YEAR FROM TI.t_date) AS ride_year

FROM route RT

JOIN ride R
    ON RT.origin = R.origin
   AND RT.destination = R.destination

JOIN tourinstance TI
    ON R.t_i_id = TI.t_i_id

GROUP BY 
    RT.origin,
    RT.destination,
    RT.distancekm,
    RT.estimatedtraveltime,
    EXTRACT(YEAR FROM TI.t_date)

ORDER BY 
    total_rides_on_route DESC,
    RT.origin,
    RT.destination;


/* =========================================================
QUERY 7
Fleet & Maintenance Report
Shows vehicle usage, last maintenance date
and ride activity per year.
========================================================= */
SELECT 
    V.platenumber,
    V.model,
    V.carcolor,
    V.year,
    V.capacity,
    V.status,

    COUNT(R.rideid) AS total_rides,

    MAX(M.maintenancedate) AS last_maintenance_date,

    EXTRACT(YEAR FROM TI.t_date) AS activity_year

FROM vehicle V

LEFT JOIN ride R
    ON V.platenumber = R.platenumber

LEFT JOIN tourinstance TI
    ON R.t_i_id = TI.t_i_id

LEFT JOIN maintenance M
    ON V.platenumber = M.platenumber

GROUP BY 
    V.platenumber,
    V.model,
    V.carcolor,
    V.year,
    V.capacity,
    V.status,
    EXTRACT(YEAR FROM TI.t_date)

ORDER BY total_rides DESC;


/* =========================================================
QUERY 8
Customer Profile Screen
Shows customer details and full ride history
including drivers, vehicles and dates
========================================================= */
SELECT 
    C.c_id AS customer_id,
    C.c_first_name || ' ' || C.c_last_name AS customer_name,
    C.c_phone AS customer_phone,
    C.c_email,

    R.rideid,

    TI.t_date AS ride_date,
    EXTRACT(DAY FROM TI.t_date) AS ride_day,
    EXTRACT(MONTH FROM TI.t_date) AS ride_month,
    EXTRACT(YEAR FROM TI.t_date) AS ride_year,

    R.status AS ride_status,

    D.fullname AS driver_name,
    V.platenumber,
    V.model AS vehicle_model,

    R.origin,
    R.destination

FROM customer C

JOIN bookings B 
    ON B.c_id = C.c_id

JOIN ride R 
    ON R.t_i_id = B.t_i_id

JOIN tourinstance TI 
    ON TI.t_i_id = R.t_i_id

JOIN driver D 
    ON R.licensenumber = D.licensenumber

JOIN vehicle V 
    ON R.platenumber = V.platenumber

WHERE C.c_id = 1

ORDER BY TI.t_date DESC;