-- =====================================================
-- File: 08_main_customer_bookings.sql
-- Stage D - Main Program
--
-- Purpose:
-- Main program that calls:
-- 1. Function: get_customer_bookings_report
-- 2. Procedure: clean_old_unapproved_bookings
--
-- It also demonstrates the booking trigger by running an UPDATE.
--
-- Programming elements:
-- 1. Ref Cursor
-- 2. Record variable
-- 3. Loop
-- 4. Function call
-- 5. Procedure call
-- 6. UPDATE statement that activates the trigger
-- 7. Exception handling
-- =====================================================

DO $$

DECLARE
    report_cursor REFCURSOR;
    report_record RECORD;
    row_counter INTEGER := 0;

    test_booking_id INTEGER;
    price_before NUMERIC;
    price_after NUMERIC;

BEGIN
    RAISE NOTICE '================================';
    RAISE NOTICE 'Customer bookings main program started';
    RAISE NOTICE '================================';

    -- Call function 05 and receive a Ref Cursor
    report_cursor := get_customer_bookings_report(0);

    RAISE NOTICE 'Top 5 customers from Ref Cursor:';

    LOOP
        FETCH report_cursor INTO report_record;

        EXIT WHEN NOT FOUND;
        EXIT WHEN row_counter >= 5;

        row_counter := row_counter + 1;

        RAISE NOTICE
        '% | Customer: % | Approved: % | Unapproved: % | Total paid: % | Type: %',
        row_counter,
        report_record.customer_name,
        report_record.approved_bookings,
        report_record.unapproved_bookings,
        report_record.total_paid,
        report_record.customer_type;
    END LOOP;

    CLOSE report_cursor;

    RAISE NOTICE 'Displayed rows: %', row_counter;

    -- Call procedure 06
    CALL clean_old_unapproved_bookings('2026-01-01', 10);

    -- Demonstrate trigger 07
    SELECT b_id, total_price
    INTO test_booking_id, price_before
    FROM bookings
    WHERE b_status = FALSE
    LIMIT 1;

    IF test_booking_id IS NOT NULL THEN

        UPDATE bookings
        SET total_price = 999
        WHERE b_id = test_booking_id;

        SELECT total_price
        INTO price_after
        FROM bookings
        WHERE b_id = test_booking_id;

        RAISE NOTICE 'Trigger demonstration:';
        RAISE NOTICE 'Booking id: %', test_booking_id;
        RAISE NOTICE 'Tried to set total_price to: 999';
        RAISE NOTICE 'Actual total_price after trigger: %', price_after;

    ELSE
        RAISE NOTICE 'No unapproved booking found for trigger demonstration';
    END IF;

    RAISE NOTICE '================================';
    RAISE NOTICE 'Customer bookings main program finished';
    RAISE NOTICE '================================';

EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Error in customer bookings main program: %', SQLERRM;
END;
$$;