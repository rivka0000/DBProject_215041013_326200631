-- =====================================================
-- File: 05_function_customer_bookings.sql
-- Stage D - PL/pgSQL Function
--
-- Function name:
-- get_customer_bookings_report
--
-- Description:
-- This function returns a Ref Cursor with a customer bookings report.
-- It also scans the data with an explicit cursor and prints a short summary.
--
-- Programming elements:
-- 1. Explicit Cursor
-- 2. Ref Cursor
-- 3. Record variable
-- 4. Loop
-- 5. IF conditions
-- 6. Exception handling
-- =====================================================

CREATE OR REPLACE FUNCTION get_customer_bookings_report(
    p_min_total_price NUMERIC DEFAULT 0
)
RETURNS REFCURSOR
LANGUAGE plpgsql
AS $$

DECLARE
    report_cursor REFCURSOR := 'customer_bookings_report_cursor';
    customer_record RECORD;

    total_customers INTEGER := 0;
    active_customers INTEGER := 0;
    total_income NUMERIC := 0;

    top_customer_name TEXT := NULL;
    top_customer_paid NUMERIC := 0;

    -- Explicit cursor for scanning customer booking summaries
    cur_customer_bookings CURSOR FOR
        SELECT
            c.c_id,
            c.c_first_name || ' ' || c.c_last_name AS customer_name,
            COUNT(b.b_id) AS total_bookings,
            COUNT(b.b_id) FILTER (WHERE b.b_status = TRUE) AS approved_bookings,
            COUNT(b.b_id) FILTER (WHERE b.b_status = FALSE) AS unapproved_bookings,
            COALESCE(SUM(b.total_price), 0) AS total_paid
        FROM customer c
        LEFT JOIN bookings b
            ON c.c_id = b.c_id
        GROUP BY
            c.c_id,
            c.c_first_name,
            c.c_last_name
        HAVING COALESCE(SUM(b.total_price), 0) >= p_min_total_price
        ORDER BY total_paid DESC;

BEGIN
    IF p_min_total_price < 0 THEN
        RAISE EXCEPTION 'Minimum total price cannot be negative';
    END IF;

    -- Loop over the explicit cursor, but print only a summary
    FOR customer_record IN cur_customer_bookings LOOP

        total_customers := total_customers + 1;
        total_income := total_income + customer_record.total_paid;

        IF customer_record.approved_bookings > 0 THEN
            active_customers := active_customers + 1;
        END IF;

        IF customer_record.total_paid > top_customer_paid THEN
            top_customer_paid := customer_record.total_paid;
            top_customer_name := customer_record.customer_name;
        END IF;

    END LOOP;

    RAISE NOTICE 'Customer booking report summary:';
    RAISE NOTICE 'Total customers checked: %', total_customers;
    RAISE NOTICE 'Active customers found: %', active_customers;
    RAISE NOTICE 'Total income in report: %', total_income;
    RAISE NOTICE 'Top customer: %, total paid: %',
        top_customer_name,
        top_customer_paid;

    -- Returned Ref Cursor with the detailed report
    OPEN report_cursor FOR
        SELECT
            c.c_id AS customer_id,
            c.c_first_name || ' ' || c.c_last_name AS customer_name,
            COUNT(b.b_id) AS total_bookings,
            COUNT(b.b_id) FILTER (WHERE b.b_status = TRUE) AS approved_bookings,
            COUNT(b.b_id) FILTER (WHERE b.b_status = FALSE) AS unapproved_bookings,
            COALESCE(SUM(b.total_price), 0) AS total_paid,
            CASE
                WHEN COUNT(b.b_id) FILTER (WHERE b.b_status = TRUE) >= 5 THEN 'Frequent customer'
                WHEN COUNT(b.b_id) FILTER (WHERE b.b_status = TRUE) >= 1 THEN 'Regular customer'
                ELSE 'Inactive customer'
            END AS customer_type
        FROM customer c
        LEFT JOIN bookings b
            ON c.c_id = b.c_id
        GROUP BY
            c.c_id,
            c.c_first_name,
            c.c_last_name
        HAVING COALESCE(SUM(b.total_price), 0) >= p_min_total_price
        ORDER BY total_paid DESC;

    RETURN report_cursor;

EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Error in get_customer_bookings_report: %', SQLERRM;
        RAISE;
END;
$$;