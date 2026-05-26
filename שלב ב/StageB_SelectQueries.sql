/* =========================================================
   StageB_SelectQueries.sql
   Updated for Integrated Database
   ========================================================= */


/* =========================================================
   QUERY 1A
   Ride Management Screen
   All rides with full details - JOIN version

   מטרת השאילתה:
   להציג את כל פרטי הנסיעות במערכת המשולבת,
   כולל:
   - פרטי נסיעה
   - פרטי לקוח
   - פרטי נהג
   - פרטי רכב
   - פרטי מסלול
   - תאריך ושעות הסיור

   לאחר האינטגרציה:
   - תאריך ושעות נמצאים ב-tourinstance
   - לקוחות נמצאים דרך bookings
   ========================================================= */

SELECT 
    -- Ride information
    R.rideid,
    R.status AS rideStatus,

    -- Booking information
    B.b_date,

    -- Tour instance information
    TI.start_time,
    TI.end_time,

    -- Customer information
    C.c_id AS customerId,
    C.c_first_name,
    C.c_last_name,
    C.c_phone,

    -- Driver information
    D.licensenumber,
    D.fullname AS driverName,
    D.phonenumber AS driverPhone,

    -- Vehicle information
    V.platenumber,
    V.model AS vehicleModel,
    V.carcolor,
    V.status AS vehicleStatus,

    -- Route information
    RT.origin,
    RT.destination,
    RT.distancekm,
    RT.estimatedtraveltime

FROM ride R

-- Connect ride to booking through tour instance
JOIN bookings B
    ON R.t_i_id = B.t_i_id

-- Connect booking to customer
JOIN customer C
    ON B.c_id = C.c_id

-- Connect ride to driver
JOIN driver D
    ON R.licensenumber = D.licensenumber

-- Connect ride to vehicle
JOIN vehicle V
    ON R.platenumber = V.platenumber

-- Connect ride to route
JOIN route RT
    ON R.origin = RT.origin
   AND R.destination = RT.destination

-- Connect ride to tour instance
JOIN tourinstance TI
    ON R.t_i_id = TI.t_i_id

-- Display newest bookings first
ORDER BY B.b_date DESC, TI.start_time DESC;


/* =========================================================
   QUERY 2A
   Driver Dashboard

   Drivers with highest number of rides in 2025

   מטרת השאילתה:
   להציג את הנהגים שביצעו הכי הרבה נסיעות בשנת 2025.

   משתמשים ב:
   - JOIN לחיבור נהגים ונסיעות
   - GROUP BY לקיבוץ לפי נהג
   - COUNT לספירת נסיעות
   ========================================================= */

SELECT 
    -- Driver information
    D.licensenumber,
    D.fullname,
    D.phonenumber,
    D.status,

    -- Count total rides per driver
    COUNT(R.rideid) AS totalRides

FROM driver D

-- Connect driver to rides
JOIN ride R
    ON D.licensenumber = R.licensenumber

-- Connect rides to tour instances
-- because the date now exists in tourinstance
JOIN tourinstance TI
    ON R.t_i_id = TI.t_i_id

-- Filter only rides from 2025
WHERE EXTRACT(YEAR FROM TI.t_date) = 2025

-- Group all rides of the same driver together
GROUP BY
    D.licensenumber,
    D.fullname,
    D.phonenumber,
    D.status

-- Show drivers with most rides first
ORDER BY totalRides DESC;


/* =========================================================
   QUERY 3A
   Customer Dashboard

   Customers with highest number of rides
   in June 2025

   מטרת השאילתה:
   להציג אילו לקוחות ביצעו הכי הרבה נסיעות
   בחודש מסוים.

   לאחר האינטגרציה:
   - לקוחות מחוברים דרך bookings
   - תאריך נמצא ב-tourinstance
   ========================================================= */

SELECT 
    -- Customer information
    C.c_id,
    C.c_first_name,
    C.c_last_name,
    C.c_phone,
    C.c_email,

    -- Count rides per customer
    COUNT(R.rideid) AS totalRides

FROM customer C

-- Connect customer to bookings
JOIN bookings B
    ON C.c_id = B.c_id

-- Connect bookings to rides
JOIN ride R
    ON B.t_i_id = R.t_i_id

-- Connect rides to tour instances
JOIN tourinstance TI
    ON R.t_i_id = TI.t_i_id

-- Filter by year and month
WHERE EXTRACT(YEAR FROM TI.t_date) = 2025
  AND EXTRACT(MONTH FROM TI.t_date) = 6

-- Group rides by customer
GROUP BY
    C.c_id,
    C.c_first_name,
    C.c_last_name,
    C.c_phone,
    C.c_email

-- Show customers with most rides first
ORDER BY totalRides DESC;


/* =========================================================
   QUERY 4A
   Vehicle Management Screen

   Vehicles not assigned to rides in 2025

   מטרת השאילתה:
   להציג רכבים שלא שויכו לאף נסיעה בשנת 2025.

   משתמשים ב:
   - NOT IN
   - תאריך מתוך tourinstance
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

    -- Connect ride to tour instance
    JOIN tourinstance TI
        ON R.t_i_id = TI.t_i_id

    -- Filter only rides from 2025
    WHERE EXTRACT(YEAR FROM TI.t_date) = 2025
)

-- Sort by model and plate number
ORDER BY V.model, V.platenumber;


/* =========================================================
   QUERY 5
   Dashboard

   Number of rides by year and month

   מטרת השאילתה:
   להציג כמה נסיעות קיימות בכל חודש ובכל שנה.

   משתמשים ב:
   - EXTRACT לפירוק תאריך
   - GROUP BY לפי שנה וחודש
   ========================================================= */

SELECT 
    -- Extract year from tour date
    EXTRACT(YEAR FROM TI.t_date) AS rideYear,

    -- Extract month from tour date
    EXTRACT(MONTH FROM TI.t_date) AS rideMonth,

    -- Count rides
    COUNT(*) AS totalRides

FROM ride R

-- Connect ride to tour instance
JOIN tourinstance TI
    ON R.t_i_id = TI.t_i_id

-- Group by year and month
GROUP BY
    EXTRACT(YEAR FROM TI.t_date),
    EXTRACT(MONTH FROM TI.t_date)

-- Sort chronologically
ORDER BY rideYear, rideMonth;


/* =========================================================
   QUERY 6
   Route Analysis

   Most popular routes

   מטרת השאילתה:
   להציג אילו מסלולים הם הכי פופולריים
   לפי מספר הנסיעות שבוצעו בהם.

   משתמשים ב:
   - JOIN בין route ל-ride
   - COUNT לספירת נסיעות
   ========================================================= */

SELECT 
    -- Route information
    RT.origin,
    RT.destination,
    RT.distancekm,
    RT.estimatedtraveltime,

    -- Count rides on each route
    COUNT(R.rideid) AS totalRidesOnRoute

FROM route RT

-- Connect rides to routes
JOIN ride R
    ON RT.origin = R.origin
   AND RT.destination = R.destination

-- Group by route
GROUP BY
    RT.origin,
    RT.destination,
    RT.distancekm,
    RT.estimatedtraveltime

-- Most popular routes first
ORDER BY totalRidesOnRoute DESC;