/* =========================================================
   StageB_SelectQueries.sql
   Advanced SELECT queries for Stage B
   Transportation Management System
   ========================================================= */


/* =========================================================
   QUERY 1A
   Ride Management Screen
   All rides with full details - JOIN version
   ========================================================= */
SELECT 
    R.rideId,
    R.orderDate,
    R.startTime,
    R.endTime,
    R.status AS rideStatus,
    R.paymentMethod,
    C.id AS customerId,
    C.fullName AS customerName,
    C.phoneNumber AS customerPhone,
    D.licenseNumber,
    D.fullName AS driverName,
    D.phoneNumber AS driverPhone,
    V.plateNumber,
    V.model AS vehicleModel,
    V.carColor,
    V.status AS vehicleStatus,
    RT.origin,
    RT.destination,
    RT.distanceKm,
    RT.estimatedTravelTime
FROM RIDE R
JOIN CUSTOMER C ON R.id = C.id
JOIN DRIVER D ON R.licenseNumber = D.licenseNumber
JOIN VEHICLE V ON R.plateNumber = V.plateNumber
JOIN ROUTE RT ON R.origin = RT.origin AND R.destination = RT.destination
ORDER BY R.orderDate DESC, R.startTime DESC;


/* =========================================================
   QUERY 1B
   Ride Management Screen
   All rides with full details - subquery version
   ========================================================= */
SELECT 
    R.rideId,
    R.orderDate,
    R.startTime,
    R.endTime,
    R.status AS rideStatus,
    R.paymentMethod,
    R.id AS customerId,
    (SELECT C.fullName
     FROM CUSTOMER C
     WHERE C.id = R.id) AS customerName,
    (SELECT C.phoneNumber
     FROM CUSTOMER C
     WHERE C.id = R.id) AS customerPhone,
    R.licenseNumber,
    (SELECT D.fullName
     FROM DRIVER D
     WHERE D.licenseNumber = R.licenseNumber) AS driverName,
    (SELECT D.phoneNumber
     FROM DRIVER D
     WHERE D.licenseNumber = R.licenseNumber) AS driverPhone,
    R.plateNumber,
    (SELECT V.model
     FROM VEHICLE V
     WHERE V.plateNumber = R.plateNumber) AS vehicleModel,
    (SELECT V.carColor
     FROM VEHICLE V
     WHERE V.plateNumber = R.plateNumber) AS carColor,
    (SELECT V.status
     FROM VEHICLE V
     WHERE V.plateNumber = R.plateNumber) AS vehicleStatus,
    R.origin,
    R.destination,
    (SELECT RT.distanceKm
     FROM ROUTE RT
     WHERE RT.origin = R.origin AND RT.destination = R.destination) AS distanceKm,
    (SELECT RT.estimatedTravelTime
     FROM ROUTE RT
     WHERE RT.origin = R.origin AND RT.destination = R.destination) AS estimatedTravelTime
FROM RIDE R
ORDER BY R.orderDate DESC, R.startTime DESC;


/* =========================================================
   QUERY 2A
   Driver Directory / Dashboard
   Drivers with the highest number of rides in a given year
   GROUP BY + ORDER BY version
   ========================================================= */
SELECT 
    D.licenseNumber,
    D.fullName,
    D.phoneNumber,
    D.status,
    COUNT(R.rideId) AS totalRides
FROM DRIVER D
JOIN RIDE R ON D.licenseNumber = R.licenseNumber
WHERE EXTRACT(YEAR FROM R.orderDate) = 2025
GROUP BY D.licenseNumber, D.fullName, D.phoneNumber, D.status
ORDER BY totalRides DESC;


/* =========================================================
   QUERY 2B
   Driver Directory / Dashboard
   Drivers with the maximum number of rides in a given year
   MAX subquery version
   ========================================================= */
SELECT 
    D.licenseNumber,
    D.fullName,
    D.phoneNumber,
    D.status,
    COUNT(R.rideId) AS totalRides
FROM DRIVER D
JOIN RIDE R ON D.licenseNumber = R.licenseNumber
WHERE EXTRACT(YEAR FROM R.orderDate) = 2025
GROUP BY D.licenseNumber, D.fullName, D.phoneNumber, D.status
HAVING COUNT(R.rideId) = (
    SELECT MAX(driverRideCount)
    FROM (
        SELECT COUNT(R2.rideId) AS driverRideCount
        FROM RIDE R2
        WHERE EXTRACT(YEAR FROM R2.orderDate) = 2025
        GROUP BY R2.licenseNumber
    ) AS DriverCounts
)
ORDER BY D.licenseNumber;


/* =========================================================
   QUERY 3A
   Customers Directory
   Customers with the highest number of rides in a given month/year
   GROUP BY + ORDER BY version
   ========================================================= */
SELECT 
    C.id,
    C.fullName,
    C.phoneNumber,
    C.email,
    COUNT(R.rideId) AS totalRides
FROM CUSTOMER C
JOIN RIDE R ON C.id = R.id
WHERE EXTRACT(YEAR FROM R.orderDate) = 2025
  AND EXTRACT(MONTH FROM R.orderDate) = 6
GROUP BY C.id, C.fullName, C.phoneNumber, C.email
ORDER BY totalRides DESC;


/* =========================================================
   QUERY 3B
   Customers Directory
   Customers with the maximum number of rides in a given month/year
   MAX subquery version
   ========================================================= */
SELECT 
    C.id,
    C.fullName,
    C.phoneNumber,
    C.email,
    COUNT(R.rideId) AS totalRides
FROM CUSTOMER C
JOIN RIDE R ON C.id = R.id
WHERE EXTRACT(YEAR FROM R.orderDate) = 2025
  AND EXTRACT(MONTH FROM R.orderDate) = 6
GROUP BY C.id, C.fullName, C.phoneNumber, C.email
HAVING COUNT(R.rideId) = (
    SELECT MAX(customerRideCount)
    FROM (
        SELECT COUNT(R2.rideId) AS customerRideCount
        FROM RIDE R2
        WHERE EXTRACT(YEAR FROM R2.orderDate) = 2025
          AND EXTRACT(MONTH FROM R2.orderDate) = 6
        GROUP BY R2.id
    ) AS CustomerCounts
)
ORDER BY C.id;


/* =========================================================
   QUERY 4A
   Vehicle Management Screen
   Vehicles that were not assigned to any ride in a given year
   NOT IN version
   ========================================================= */
SELECT 
    V.plateNumber,
    V.model,
    V.capacity,
    V.carColor,
    V.year,
    V.status
FROM VEHICLE V
WHERE V.plateNumber NOT IN (
    SELECT R.plateNumber
    FROM RIDE R
    WHERE EXTRACT(YEAR FROM R.orderDate) = 2025
)
ORDER BY V.model, V.plateNumber;


/* =========================================================
   QUERY 4B
   Vehicle Management Screen
   Vehicles that were not assigned to any ride in a given year
   NOT EXISTS version
   ========================================================= */
SELECT 
    V.plateNumber,
    V.model,
    V.capacity,
    V.carColor,
    V.year,
    V.status
FROM VEHICLE V
WHERE NOT EXISTS (
    SELECT 1
    FROM RIDE R
    WHERE R.plateNumber = V.plateNumber
      AND EXTRACT(YEAR FROM R.orderDate) = 2025
)
ORDER BY V.model, V.plateNumber;


/* =========================================================
   QUERY 5
   Dashboard
   Number of rides by year and month
   ========================================================= */
SELECT 
    EXTRACT(YEAR FROM orderDate) AS rideYear,
    EXTRACT(MONTH FROM orderDate) AS rideMonth,
    COUNT(*) AS totalRides
FROM RIDE
GROUP BY EXTRACT(YEAR FROM orderDate), EXTRACT(MONTH FROM orderDate)
ORDER BY rideYear, rideMonth;


/* =========================================================
   QUERY 6
   Reports / Route Analysis
   Most popular routes by number of rides
   ========================================================= */
SELECT 
    RT.origin,
    RT.destination,
    RT.distanceKm,
    RT.estimatedTravelTime,
    COUNT(R.rideId) AS totalRidesOnRoute
FROM ROUTE RT
JOIN RIDE R
    ON RT.origin = R.origin
   AND RT.destination = R.destination
GROUP BY RT.origin, RT.destination, RT.distanceKm, RT.estimatedTravelTime
ORDER BY totalRidesOnRoute DESC, RT.origin, RT.destination;


/* =========================================================
   QUERY 7
   Track & Maintenance Screen
   Vehicles with many rides but no maintenance in the last 6 months
   ========================================================= */
SELECT 
    V.plateNumber,
    V.model,
    V.status,
    COUNT(R.rideId) AS totalRides,
    MAX(M.maintenanceDate) AS lastMaintenanceDate
FROM VEHICLE V
JOIN RIDE R ON V.plateNumber = R.plateNumber
LEFT JOIN MAINTENANCE M ON V.plateNumber = M.plateNumber
GROUP BY V.plateNumber, V.model, V.status
HAVING COUNT(R.rideId) >= 3
   AND (
       MAX(M.maintenanceDate) IS NULL
       OR MAX(M.maintenanceDate) < CURRENT_DATE - INTERVAL '6 months'
   )
ORDER BY totalRides DESC, V.plateNumber;


/* =========================================================
   QUERY 8
   Customer Details Screen
   Ride history of a specific customer
   ========================================================= */
SELECT 
    C.id AS customerId,
    C.fullName AS customerName,
    R.rideId,
    R.orderDate,
    EXTRACT(DAY FROM R.orderDate) AS rideDay,
    EXTRACT(MONTH FROM R.orderDate) AS rideMonth,
    EXTRACT(YEAR FROM R.orderDate) AS rideYear,
    R.startTime,
    R.endTime,
    R.status AS rideStatus,
    R.paymentMethod,
    D.fullName AS driverName,
    V.plateNumber,
    V.model AS vehicleModel,
    R.origin,
    R.destination
FROM CUSTOMER C
JOIN RIDE R ON C.id = R.id
JOIN DRIVER D ON R.licenseNumber = D.licenseNumber
JOIN VEHICLE V ON R.plateNumber = V.plateNumber
WHERE C.id = 1001
ORDER BY R.orderDate DESC, R.startTime DESC;
