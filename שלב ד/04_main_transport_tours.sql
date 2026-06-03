-- =====================================================
-- File: 04_main_transport_tours.sql
-- Stage D - Main Program
-- Student: Tirtsa Abuhasira
-- Database: restore_final_db
--
-- Purpose:
-- Main program that calls:
-- 1. Function: get_transport_tours_report
-- 2. Procedure: update_pending_transport_rides
--
-- Programming elements demonstrated:
-- - Ref Cursor
-- - Record Variable
-- - Loop
-- - Function Call
-- - Procedure Call
-- - Exception Handling
-- =====================================================

DO $$

DECLARE
    -- Cursor returned from the function
    report_cursor REFCURSOR;

    -- Record used for FETCH operations
    report_record RECORD;

    -- Counter of displayed rows
    row_counter INTEGER := 0;

BEGIN
    RAISE NOTICE '================================';
    RAISE NOTICE 'Main program started';
    RAISE NOTICE '================================';

    -- Call function with minimum tour price 300.
    -- This keeps the output readable but still returns rows.
    report_cursor := get_transport_tours_report(300);

    RAISE NOTICE
    'Function get_transport_tours_report executed successfully';

    -- Display only first 5 rows from the Ref Cursor
    LOOP
        FETCH report_cursor INTO report_record;

        EXIT WHEN NOT FOUND;
        EXIT WHEN row_counter >= 5;

        row_counter := row_counter + 1;

        RAISE NOTICE
        'Row % | Ride % | Tour % | Driver % | Vehicle % | Income %',
        row_counter,
        report_record.rideid,
        report_record.t_name,
        report_record.driver_name,
        report_record.vehicle_model,
        report_record.total_income;
    END LOOP;

    -- Close cursor after using it
    CLOSE report_cursor;

    RAISE NOTICE
    'Displayed rows from cursor: %',
    row_counter;

    -- Call procedure.
    -- It updates 3 Pending rides to Completed.
    CALL update_pending_transport_rides(3);

    RAISE NOTICE
    'Procedure update_pending_transport_rides executed successfully';

    RAISE NOTICE '================================';
    RAISE NOTICE 'Main program finished';
    RAISE NOTICE '================================';

EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE
        'Error in main program: %',
        SQLERRM;
END;
$$;