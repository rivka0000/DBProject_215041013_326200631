-- =====================================================
-- Index 1: חיפוש נסיעות לפי תאריך
-- מתאים למסך ניהול נסיעות לפי טווח תאריכים
-- =====================================================

DROP INDEX IF EXISTS idx_ride_orderdate;

EXPLAIN ANALYZE
SELECT rideId, orderDate, startTime, endTime, status, paymentMethod
FROM RIDE
WHERE orderDate BETWEEN DATE '2026-03-01' AND DATE '2026-03-31'
ORDER BY orderDate, startTime;

CREATE INDEX idx_ride_orderdate
ON RIDE(orderDate);

EXPLAIN ANALYZE
SELECT rideId, orderDate, startTime, endTime, status, paymentMethod
FROM RIDE
WHERE orderDate BETWEEN DATE '2026-03-01' AND DATE '2026-03-31'
ORDER BY orderDate, startTime;



-- =====================================================
-- Index 2: חיפוש נסיעות לפי נהג ותאריך
-- מתאים למסך פרטי נהג והיסטוריית נסיעות
-- =====================================================

DROP INDEX IF EXISTS idx_ride_driver_date;

EXPLAIN ANALYZE
SELECT rideId, licenseNumber, orderDate, startTime, endTime, status
FROM RIDE
WHERE licenseNumber = (
    SELECT licenseNumber
    FROM RIDE
    GROUP BY licenseNumber
    ORDER BY COUNT(*) DESC
    LIMIT 1
)
AND orderDate BETWEEN DATE '2025-01-01' AND DATE '2025-12-31'
ORDER BY orderDate;

CREATE INDEX idx_ride_driver_date
ON RIDE(licenseNumber, orderDate);

EXPLAIN ANALYZE
SELECT rideId, licenseNumber, orderDate, startTime, endTime, status
FROM RIDE
WHERE licenseNumber = (
    SELECT licenseNumber
    FROM RIDE
    GROUP BY licenseNumber
    ORDER BY COUNT(*) DESC
    LIMIT 1
)
AND orderDate BETWEEN DATE '2025-01-01' AND DATE '2025-12-31'
ORDER BY orderDate;



-- =====================================================
-- Index 3: חיפוש טיפולים לפי רכב ותאריך
-- מתאים למסך רכב והיסטוריית טיפולים
-- =====================================================

DROP INDEX IF EXISTS idx_maintenance_vehicle_date;

EXPLAIN ANALYZE
SELECT plateNumber, maintenanceDate, MaintenanceType, Cost, Description
FROM MAINTENANCE
WHERE plateNumber = (
    SELECT plateNumber
    FROM MAINTENANCE
    GROUP BY plateNumber
    ORDER BY COUNT(*) DESC
    LIMIT 1
)
ORDER BY maintenanceDate DESC;

CREATE INDEX idx_maintenance_vehicle_date
ON MAINTENANCE(plateNumber, maintenanceDate);

EXPLAIN ANALYZE
SELECT plateNumber, maintenanceDate, MaintenanceType, Cost, Description
FROM MAINTENANCE
WHERE plateNumber = (
    SELECT plateNumber
    FROM MAINTENANCE
    GROUP BY plateNumber
    ORDER BY COUNT(*) DESC
    LIMIT 1
)
ORDER BY maintenanceDate DESC;