-- =====================================================
-- File: 06_procedure_customer_bookings.sql
-- Stage D - PL/pgSQL Procedure
--
-- Procedure name:
-- clean_old_unapproved_bookings
--
-- Description:
-- This procedure scans old unapproved bookings and updates
-- their total_price to 0, so they will not be counted as income.
--
-- Programming elements:
-- 1. Explicit Cursor
-- 2. Record variable
-- 3. Loop
-- 4. IF conditions
-- 5. UPDATE statement
-- 6. Exception handling
-- =====================================================

CREATE OR REPLACE PROCEDURE clean_old_unapproved_bookings(
    p_before_date DATE,
    p_max_updates INTEGER DEFAULT 10
)
LANGUAGE plpgsql
AS $$

DECLARE
    booking_record RECORD;

    checked_counter INTEGER := 0;
    updated_counter INTEGER := 0;
    skipped_counter INTEGER := 0;

    cleaned_amount NUMERIC := 0;

    -- Explicit cursor for old unapproved bookings
    cur_old_bookings CURSOR FOR
        SELECT
            b_id,
            c_id,
            b_date,
            b_status,
            total_price
        FROM bookings
        WHERE b_status = FALSE
          AND b_date < p_before_date
        ORDER BY b_date, b_id;

BEGIN
    IF p_before_date IS NULL THEN
        RAISE EXCEPTION 'Date parameter cannot be null';
    END IF;

    IF p_max_updates <= 0 THEN
        RAISE EXCEPTION 'Maximum updates must be greater than zero';
    END IF;

    RAISE NOTICE 'Old unapproved bookings cleaning started';
    RAISE NOTICE 'Before date: %, Max updates: %', p_before_date, p_max_updates;

    FOR booking_record IN cur_old_bookings LOOP

        EXIT WHEN updated_counter >= p_max_updates;

        checked_counter := checked_counter + 1;

        IF booking_record.total_price IS NULL THEN
            skipped_counter := skipped_counter + 1;
            CONTINUE;
        END IF;

        IF booking_record.total_price = 0 THEN
            skipped_counter := skipped_counter + 1;
            CONTINUE;
        END IF;

        UPDATE bookings
        SET total_price = 0
        WHERE b_id = booking_record.b_id;

        cleaned_amount := cleaned_amount + booking_record.total_price;
        updated_counter := updated_counter + 1;

    END LOOP;

    RAISE NOTICE 'Cleaning summary:';
    RAISE NOTICE 'Bookings checked: %', checked_counter;
    RAISE NOTICE 'Bookings updated: %', updated_counter;
    RAISE NOTICE 'Bookings skipped: %', skipped_counter;
    RAISE NOTICE 'Total amount cleaned: %', cleaned_amount;

EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Error in clean_old_unapproved_bookings: %', SQLERRM;
        RAISE;
END;
$$;