-- =====================================================
-- File: 01_function_transport_tours.sql
-- Stage D - PL/pgSQL Function
-- Database: restore_final_db
--
-- Function name:
-- get_transport_tours_report
--
-- Description:
-- This function returns a report about tours that have
-- transportation rides in the integrated database.
--
-- The function uses:
-- 1. Explicit Cursor
-- 2. Ref Cursor
-- 3. Record variable
-- 4. Loop
-- 5. IF / ELSE conditions
-- 6. Exception handling
--
-- Tables used:
-- ride
-- driver
-- vehicle
-- tourinstance
-- tour
-- bookings
--
-- Integrated relation:
-- ride.t_i_id references tourinstance.t_i_id
-- =====================================================

CREATE OR REPLACE FUNCTION get_transport_tours_report(
    p_min_price INTEGER DEFAULT 0
)
RETURNS REFCURSOR
LANGUAGE plpgsql
AS $$

DECLARE
    -- Ref Cursor that will be returned to the main program
    report_cursor REFCURSOR;

    -- Record variable that stores one row from the explicit cursor
    tour_record RECORD;

    -- Counter for the number of processed rows
    total_counter INTEGER := 0;

    -- Counter for tours that have approved bookings
    approved_counter INTEGER := 0;

    -- Explicit cursor:
    -- This cursor scans all tours that are connected to transportation rides.
    cur_transport_tours CURSOR FOR
        SELECT
            r.rideid,
            r.status AS ride_status,
            d.fullname AS driver_name,
            v.platenumber,
            v.model AS vehicle_model,
            v.status AS vehicle_status,
            ti.t_i_id,
            ti.t_date,
            ti.start_time,
            ti.end_time,
            t.t_name,
            t.t_type,
            t.area,
            t.price,
            COUNT(b.b_id) AS total_bookings,
            COALESCE(SUM(b.total_price), 0) AS total_income
        FROM ride r
        JOIN driver d
            ON r.licensenumber = d.licensenumber
        JOIN vehicle v
            ON r.platenumber = v.platenumber
        JOIN tourinstance ti
            ON r.t_i_id = ti.t_i_id
        JOIN tour t
            ON ti.t_name = t.t_name
        LEFT JOIN bookings b
            ON ti.t_i_id = b.t_i_id
            AND b.b_status = TRUE
        WHERE t.price >= p_min_price
        GROUP BY
            r.rideid,
            r.status,
            d.fullname,
            v.platenumber,
            v.model,
            v.status,
            ti.t_i_id,
            ti.t_date,
            ti.start_time,
            ti.end_time,
            t.t_name,
            t.t_type,
            t.area,
            t.price
        ORDER BY
            ti.t_date,
            ti.start_time;

BEGIN
    -- Loop over the explicit cursor.
    -- Each row is stored inside tour_record.
    FOR tour_record IN cur_transport_tours LOOP

        -- Count every processed tour with transportation.
        total_counter := total_counter + 1;

        -- Check if the tour has approved bookings.
        IF tour_record.total_bookings > 0 THEN
            approved_counter := approved_counter + 1;

            RAISE NOTICE
            'Tour % has % approved bookings and income %',
            tour_record.t_name,
            tour_record.total_bookings,
            tour_record.total_income;

        ELSE
            RAISE NOTICE
            'Tour % has transportation but no approved bookings',
            tour_record.t_name;
        END IF;

        -- Additional business check:
        -- A ride with a vehicle that is not available may be problematic.
        IF LOWER(tour_record.vehicle_status) <> 'available' THEN
            RAISE NOTICE
            'Warning: vehicle % status is %',
            tour_record.platenumber,
            tour_record.vehicle_status;
        END IF;

    END LOOP;

    -- Print summary information.
    RAISE NOTICE
    'Total transport tours checked: %',
    total_counter;

    RAISE NOTICE
    'Transport tours with approved bookings: %',
    approved_counter;

    -- Open a Ref Cursor with the final report.
    -- This is the result returned to the caller.
    OPEN report_cursor FOR
        SELECT
            r.rideid,
            r.status AS ride_status,
            d.fullname AS driver_name,
            v.platenumber,
            v.model AS vehicle_model,
            v.status AS vehicle_status,
            ti.t_i_id,
            ti.t_date,
            ti.start_time,
            ti.end_time,
            t.t_name,
            t.t_type,
            t.area,
            t.price,
            COUNT(b.b_id) AS approved_bookings,
            COALESCE(SUM(b.total_price), 0) AS total_income
        FROM ride r
        JOIN driver d
            ON r.licensenumber = d.licensenumber
        JOIN vehicle v
            ON r.platenumber = v.platenumber
        JOIN tourinstance ti
            ON r.t_i_id = ti.t_i_id
        JOIN tour t
            ON ti.t_name = t.t_name
        LEFT JOIN bookings b
            ON ti.t_i_id = b.t_i_id
            AND b.b_status = TRUE
        WHERE t.price >= p_min_price
        GROUP BY
            r.rideid,
            r.status,
            d.fullname,
            v.platenumber,
            v.model,
            v.status,
            ti.t_i_id,
            ti.t_date,
            ti.start_time,
            ti.end_time,
            t.t_name,
            t.t_type,
            t.area,
            t.price
        ORDER BY
            ti.t_date,
            ti.start_time;

    -- Return the Ref Cursor.
    RETURN report_cursor;

EXCEPTION
    -- Exception handling for unexpected runtime errors.
    WHEN OTHERS THEN
        RAISE NOTICE
        'Error in get_transport_tours_report: %',
        SQLERRM;

        RETURN NULL;
END;
$$;