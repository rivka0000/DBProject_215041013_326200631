-- =====================================================
-- Constraint 1:
-- קיבולת רכב חייבת להיות גדולה מ-0
-- =====================================================

ALTER TABLE VEHICLE
ADD CONSTRAINT chk_vehicle_capacity_positive
CHECK (capacity > 0);

-- בדיקה - אמור להיכשל
INSERT INTO VEHICLE (plateNumber, model, capacity, carColor, year, status)
VALUES ('TEST001', 'Test Model', -1, 'White', 2020, 'Available');



-- =====================================================
-- Constraint 2:
-- מרחק נסיעה חייב להיות הגיוני (בתוך ישראל)
-- =====================================================

ALTER TABLE ROUTE
ADD CONSTRAINT chk_route_distance_valid
CHECK (distanceKm > 0 AND distanceKm <= 500)
NOT VALID;

-- בדיקה - אמור להיכשל
INSERT INTO ROUTE (origin, destination, distanceKm, estimatedTravelTime)
VALUES ('Test Origin', 'Test Destination', 800, 60);



-- =====================================================
-- Constraint 3:
-- זמן נסיעה משוער חייב להיות גדול מ-0
-- =====================================================

ALTER TABLE ROUTE
ADD CONSTRAINT chk_route_time_positive
CHECK (estimatedTravelTime > 0);

-- בדיקה - אמור להיכשל
INSERT INTO ROUTE (origin, destination, distanceKm, estimatedTravelTime)
VALUES ('Test Origin2', 'Test Destination2', 50, 0);