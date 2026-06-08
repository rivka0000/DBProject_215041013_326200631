-- =====================================================
-- File: 07_trigger_customer_bookings.sql
-- Stage D - PL/pgSQL Trigger
--
-- Trigger name:
-- trg_customer_bookings_update
--
-- Description:
-- This trigger runs before INSERT or UPDATE on bookings.
-- If a booking is not approved, total_price is automatically set to 0.
--
-- Programming elements:
-- 1. BEFORE INSERT trigger
-- 2. BEFORE UPDATE trigger
-- 3. OLD and NEW records
-- 4. IF conditions
-- 5. Exception handling
-- =====================================================

CREATE OR REPLACE FUNCTION check_customer_booking_update()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$

BEGIN
    IF NEW.b_date IS NULL THEN
        RAISE EXCEPTION 'Booking date cannot be null';
    END IF;

    IF NEW.b_status = FALSE THEN
        NEW.total_price := 0;
    END IF;

    IF TG_OP = 'UPDATE' THEN
        IF OLD.b_status IS DISTINCT FROM NEW.b_status THEN
            RAISE NOTICE
            'Trigger notice: booking % status changed from % to %',
            NEW.b_id,
            OLD.b_status,
            NEW.b_status;
        END IF;

        IF OLD.total_price IS DISTINCT FROM NEW.total_price THEN
            RAISE NOTICE
            'Trigger notice: booking % total_price changed from % to %',
            NEW.b_id,
            OLD.total_price,
            NEW.total_price;
        END IF;
    END IF;

    RETURN NEW;

EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Error in check_customer_booking_update: %', SQLERRM;
        RAISE;
END;
$$;

DROP TRIGGER IF EXISTS trg_customer_bookings_update ON bookings;

CREATE TRIGGER trg_customer_bookings_update
BEFORE INSERT OR UPDATE OF b_status, total_price, b_date
ON bookings
FOR EACH ROW
EXECUTE FUNCTION check_customer_booking_update();