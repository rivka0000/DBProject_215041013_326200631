-- =====================================================
-- File: 02_procedure_transport_tours.sql
-- Stage D - PL/pgSQL Procedure
-- Database: restore_final_db
--
-- Procedure name:
-- update_pending_transport_rides
--
-- Description:
-- This procedure scans transportation rides that are
-- connected to tour instances and updates a limited
-- number of rides from 'Pending' to 'Completed'.
--
-- Programming elements used:
-- 1. Record variable
-- 2. Implicit Cursor
-- 3. Loop
-- 4. IF condition
-- 5. UPDATE statement (DML)
-- 6. Exception handling
--
-- Tables used:
-- ride
-- tourinstance
-- tour
-- =====================================================

CREATE OR REPLACE PROCEDURE update_pending_transport_rides(
    p_max_updates INTEGER DEFAULT 5
)
LANGUAGE plpgsql
AS $$
DECLARE

    -- Record variable used in the loop
    ride_record RECORD;

    -- Counter for updated rows
    updated_counter INTEGER := 0;

BEGIN

    RAISE NOTICE
    'Procedure started. Maximum updates allowed: %',
    p_max_updates;

    -- Implicit cursor:
    -- Scan rides that are currently Pending
    FOR ride_record IN

        SELECT
            r.rideid,
            r.status,
            r.t_i_id,
            t.t_name,
            ti.t_date

        FROM ride r
        JOIN tourinstance ti
            ON r.t_i_id = ti.t_i_id
        JOIN tour t
            ON ti.t_name = t.t_name

        WHERE r.status = 'Pending'

        ORDER BY ti.t_date

    LOOP

        -- Stop when the required number of updates is reached
        EXIT WHEN updated_counter >= p_max_updates;

        -- Business condition
        IF ride_record.status = 'Pending' THEN

            UPDATE ride
            SET status = 'Completed'
            WHERE rideid = ride_record.rideid;

            updated_counter := updated_counter + 1;

            RAISE NOTICE
            'Ride % updated from Pending to Completed',
            ride_record.rideid;

        END IF;

    END LOOP;

    RAISE NOTICE
    'Procedure finished. Total updated rides: %',
    updated_counter;

EXCEPTION

    WHEN OTHERS THEN

        RAISE NOTICE
        'Error in update_pending_transport_rides: %',
        SQLERRM;

END;
$$;