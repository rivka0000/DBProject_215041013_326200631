-- =====================================================
-- VIEW 1: Transportation Department
-- This view shows each driver and the number of rides
-- assigned to him in the transportation system.
-- =====================================================

DROP VIEW IF EXISTS driver_rides_view;

CREATE VIEW driver_rides_view AS
SELECT
    d.licensenumber,
    d.fullname AS driver_name,
    COUNT(r.rideid) AS total_rides
FROM driver d
JOIN ride r
    ON d.licensenumber = r.licensenumber
GROUP BY
    d.licensenumber,
    d.fullname;


-- Query 1:
-- Display 10 drivers with their number of rides.

SELECT *
FROM driver_rides_view
LIMIT 10;


-- Query 2:
-- Display drivers who have more than 5 rides,
-- ordered from the highest number of rides to the lowest.

SELECT *
FROM driver_rides_view
WHERE total_rides > 5
ORDER BY total_rides DESC;



-- =====================================================
-- VIEW 2: Guided Tours Department
-- This view shows approved bookings together with
-- the matching tour instance and tour details.
-- =====================================================

DROP VIEW IF EXISTS approved_bookings_view;

CREATE VIEW approved_bookings_view AS
SELECT
    b.b_id,
    b.c_id,
    b.amount_pepole,
    b.total_price,
    b.b_date,
    ti.t_i_id,
    ti.t_date,
    ti.start_time,
    ti.end_time,
    t.t_name,
    t.area,
    t.t_type,
    t.price
FROM bookings b
JOIN tourinstance ti
    ON b.t_i_id = ti.t_i_id
JOIN tour t
    ON ti.t_name = t.t_name
WHERE b.b_status = true;


-- Query 1:
-- Display 10 approved bookings with tour details.

SELECT *
FROM approved_bookings_view
LIMIT 10;


-- Query 2:
-- Show the number of approved bookings and total income
-- for each tour.

SELECT
    t_name,
    COUNT(*) AS approved_bookings_count,
    SUM(total_price) AS total_income
FROM approved_bookings_view
GROUP BY t_name
ORDER BY total_income DESC;




SELECT
    EXTRACT(YEAR FROM b_date) AS year,
    EXTRACT(MONTH FROM b_date) AS month,
    AVG(total_price) AS average_price
FROM approved_bookings_view
GROUP BY
    EXTRACT(YEAR FROM b_date),
    EXTRACT(MONTH FROM b_date)
ORDER BY
    year,
    month;




-- =====================================================
-- VIEW 3: Integrated System View
-- This view connects the transportation department
-- with the guided tours department.
-- It shows which ride transports which tour instance.
-- =====================================================

DROP VIEW IF EXISTS integrated_transport_view;

CREATE VIEW integrated_transport_view AS
SELECT
    r.rideid,
    r.status AS ride_status,
    d.fullname AS driver_name,
    v.platenumber,
    v.model AS vehicle_model,
    v.capacity,
    r.origin,
    r.destination,
    ti.t_i_id,
    ti.t_date,
    ti.start_time,
    ti.end_time,
    t.t_name,
    t.area,
    t.t_type
FROM ride r
JOIN driver d
    ON r.licensenumber = d.licensenumber
JOIN vehicle v
    ON r.platenumber = v.platenumber
JOIN tourinstance ti
    ON r.t_i_id = ti.t_i_id
JOIN tour t
    ON ti.t_name = t.t_name;


-- Query 1:
-- Display 10 records from the integrated view.

SELECT *
FROM integrated_transport_view
LIMIT 10;


-- Query 2:
-- Count how many rides are connected to each tour.

SELECT
    t_name,
    COUNT(*) AS total_rides_for_tour
FROM integrated_transport_view
GROUP BY t_name
ORDER BY total_rides_for_tour DESC;