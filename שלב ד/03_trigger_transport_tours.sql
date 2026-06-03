-- =====================================================
-- File: 03_trigger_transport_tours.sql
-- Stage D - PL/pgSQL Trigger
-- Database: restore_final_db
--
-- Trigger name:
-- trg_check_ride_status_update
--
-- Description:
-- This trigger runs before updating the status of a ride.
-- It checks status changes on rides that are connected
-- to tour instances in the integrated database.
--
-- Programming elements used:
-- 1. UPDATE Trigger
-- 2. IF conditions
-- 3. OLD and NEW records
-- 4. Exception handling
--
-- Tables used:
-- ride
-- tourinstance
-- =====================================================

-- First, create the trigger function.
CREATE OR REPLACE FUNCTION check_ride_status_update()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$

DECLARE
    tour_date DATE;

BEGIN

    -- Get the tour date of the tour instance connected to this ride.
    SELECT ti.t_date
    INTO tour_date
    FROM tourinstance ti
    WHERE ti.t_i_id = NEW.t_i_id;

    -- Check if the ride status was really changed.
    IF OLD.status IS DISTINCT FROM NEW.status THEN

        RAISE NOTICE
        'Ride % status changed from % to %',
        OLD.rideid,
        OLD.status,
        NEW.status;

        -- Business rule:
        -- A cancelled ride should not be changed to completed.
        IF OLD.status = 'Cancelled'
           AND NEW.status = 'Completed' THEN

            RAISE EXCEPTION
            'Invalid update: cancelled ride % cannot be changed to Completed',
            OLD.rideid;

        END IF;

        -- Business warning:
        -- If the ride belongs to a future tour and is marked completed,
        -- print a warning.
        IF NEW.status = 'Completed'
           AND tour_date > CURRENT_DATE THEN

            RAISE NOTICE
            'Warning: ride % belongs to a future tour date %',
            NEW.rideid,
            tour_date;

        END IF;

    END IF;

    -- Return the updated row.
    RETURN NEW;

EXCEPTION

    WHEN OTHERS THEN

        RAISE NOTICE
        'Error in check_ride_status_update: %',
        SQLERRM;

        RAISE;

END;
$$;


-- Remove old trigger if it already exists.
DROP TRIGGER IF EXISTS trg_check_ride_status_update ON ride;


-- Create UPDATE trigger on ride.status.
CREATE TRIGGER trg_check_ride_status_update
BEFORE UPDATE OF status
ON ride
FOR EACH ROW
EXECUTE FUNCTION check_ride_status_update();