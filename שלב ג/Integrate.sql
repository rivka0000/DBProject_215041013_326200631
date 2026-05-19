-- Remove columns from the ride table that are no longer needed after integration
ALTER TABLE ride
DROP COLUMN orderdate,
DROP COLUMN starttime,
DROP COLUMN endtime,
DROP COLUMN paymentmethod;

-- Display all column namedocker exec -it PostgreSQL_DB psql -U tirtsa -d restore_final_db -c "\dt"s in the ride table to verify the updated structure
SELECT column_name
FROM information_schema.columns
WHERE table_name = 'ride';


-- =====================================================
-- Integration Step: Convert our CUSTOMER table
-- to the structure of the received CUSTOMER table
-- =====================================================

-- Rename the customer ID column to match the received database structure
ALTER TABLE customer
RENAME COLUMN id TO c_id;

-- Rename the phone number column to match the received database structure
ALTER TABLE customer
RENAME COLUMN phonenumber TO c_phone;

-- Rename the email column to match the received database structure
ALTER TABLE customer
RENAME COLUMN email TO c_email;

-- Add separate columns for first name and last name
ALTER TABLE customer
ADD COLUMN c_first_name VARCHAR(30),
ADD COLUMN c_last_name VARCHAR(30);

-- Split the existing full name into first name and last name
UPDATE customer
SET
    c_first_name = LEFT(SPLIT_PART(fullname, ' ', 1), 30),
    c_last_name = LEFT(
        COALESCE(NULLIF(TRIM(REGEXP_REPLACE(fullname, '^[^ ]+[ ]*', '')), ''), 'Unknown'),
        30
    );

-- Set the new name columns as required after filling them with data
ALTER TABLE customer
ALTER COLUMN c_first_name SET NOT NULL,
ALTER COLUMN c_last_name SET NOT NULL;

-- Remove the old full name column because it was replaced by first and last name columns
ALTER TABLE customer
DROP COLUMN fullname;


-- Display the updated columns and data types of the customer table
SELECT column_name, data_type
FROM information_schema.columns
WHERE table_name = 'customer';


-- Enable the dblink extension if it does not already exist
CREATE EXTENSION IF NOT EXISTS dblink;


-- Insert customers from the received database into the current customer table
INSERT INTO customer (
    c_id,
    c_first_name,
    c_last_name,
    c_email,
    c_phone
)
SELECT
    c_id + 10000,
    c_first_name,
    c_last_name,
    c_email,
    c_phone
FROM dblink(
    'host=PostgreSQL_DB dbname=other_db user=db_rivka password=db_rivka_4100899',
    'SELECT c_id, c_first_name, c_last_name, c_email, c_phone FROM customer'
)
AS other_customer(
    c_id INT,
    c_first_name VARCHAR(30),
    c_last_name VARCHAR(30),
    c_email VARCHAR(60),
    c_phone VARCHAR(15)
);


-- Count all customers after inserting the received customers
SELECT COUNT(*) FROM customer;

-- Display sample customers that were imported from the received database
SELECT *
FROM customer
WHERE c_id >= 10000
LIMIT 10;

-- Display sample customers from the original database
SELECT *
FROM customer
WHERE c_id < 10000
LIMIT 10;



-- Enable the dblink extension if it does not already exist
CREATE EXTENSION IF NOT EXISTS dblink;



-- Remove old copies of the received tables before importing them again
DROP TABLE IF EXISTS guide CASCADE;
DROP TABLE IF EXISTS station CASCADE;
DROP TABLE IF EXISTS tour CASCADE;
DROP TABLE IF EXISTS tourinstance CASCADE;
DROP TABLE IF EXISTS tourstation CASCADE;

-- =====================================================
-- GUIDE
-- =====================================================

-- Create the guide table by copying data from the received database
CREATE TABLE guide AS
SELECT *
FROM dblink(
    'host=PostgreSQL_DB dbname=other_db user=db_rivka password=db_rivka_4100899',
    'SELECT * FROM guide'
)
AS t(
    g_id INT,
    g_first_name VARCHAR(30),
    g_last_name VARCHAR(30),
    g_phone VARCHAR(15),
    g_email VARCHAR(60),
    school VARCHAR(60)
);

-- =====================================================
-- STATION
-- =====================================================

-- Create the station table by copying data from the received database
CREATE TABLE station AS
SELECT *
FROM dblink(
    'host=PostgreSQL_DB dbname=other_db user=db_rivka password=db_rivka_4100899',
    'SELECT * FROM station'
)
AS t(
    s_name VARCHAR(50),
    s_address VARCHAR(100),
    descrip TEXT
);

-- =====================================================
-- TOUR
-- =====================================================

-- Create the tour table by copying data from the received database
CREATE TABLE tour AS
SELECT *
FROM dblink(
    'host=PostgreSQL_DB dbname=other_db user=db_rivka password=db_rivka_4100899',
    'SELECT * FROM tour'
)
AS t(
    t_name VARCHAR(50),
    max_participants INT,
    price INT,
    t_type VARCHAR(40),
    area VARCHAR(40),
    accessibility INT,
    t_level INT,
    t_duration INT
);

-- =====================================================
-- TOURINSTANCE
-- =====================================================

-- Create the tourinstance table by copying data from the received database
CREATE TABLE tourinstance AS
SELECT *
FROM dblink(
    'host=PostgreSQL_DB dbname=other_db user=db_rivka password=db_rivka_4100899',
    'SELECT * FROM tourinstance'
)
AS t(
    t_i_id INT,
    t_date DATE,
    start_time TIME,
    end_time TIME,
    g_id INT,
    t_name VARCHAR(50)
);

-- =====================================================
-- TOURSTATION
-- =====================================================

-- Create the tourstation table by copying data from the received database
CREATE TABLE tourstation AS
SELECT *
FROM dblink(
    'host=PostgreSQL_DB dbname=other_db user=db_rivka password=db_rivka_4100899',
    'SELECT * FROM tourstation'
)
AS t(
    t_index INT,
    s_during DOUBLE PRECISION,
    t_name VARCHAR(50),
    s_name VARCHAR(50)
);

-- Display the number of records in each imported table
SELECT 'guide', COUNT(*) FROM guide
UNION ALL
SELECT 'station', COUNT(*) FROM station
UNION ALL
SELECT 'tour', COUNT(*) FROM tour
UNION ALL
SELECT 'tourinstance', COUNT(*) FROM tourinstance
UNION ALL
SELECT 'tourstation', COUNT(*) FROM tourstation;


-- Create the bookings table using data imported from the received database
CREATE TABLE bookings AS
SELECT
    b_id,
    amount_pepole,
    b_date,
    b_status,
    t_i_id,
    c_id + 10000 AS c_id,
    total_price
FROM dblink(
    'host=PostgreSQL_DB dbname=other_db user=db_rivka password=db_rivka_4100899',
    'SELECT b_id, amount_pepole, b_date, b_status, t_i_id, c_id, total_price FROM bookings'
)
AS t(
    b_id INT,
    amount_pepole INT,
    b_date DATE,
    b_status BOOLEAN,
    t_i_id INT,
    c_id INT,
    total_price NUMERIC
);

-- Count all rows in the bookings table
SELECT COUNT(*) FROM bookings;

-- Display sample rows from the bookings table
SELECT *
FROM bookings
LIMIT 10;


-- Search for foreign key constraints in the ride table that reference the customer table
SELECT
    tc.constraint_name
FROM information_schema.table_constraints tc
JOIN information_schema.constraint_column_usage ccu
ON tc.constraint_name = ccu.constraint_name
WHERE tc.table_name = 'ride'
AND tc.constraint_type = 'FOREIGN KEY'
AND ccu.table_name = 'customer';

-- Remove the foreign key constraint from the ride table
ALTER TABLE ride
DROP CONSTRAINT ride_id_fkey;

-- Remove the old customer ID column from the ride table
ALTER TABLE ride
DROP COLUMN id;

-- Add a new column to connect rides with tour instances
ALTER TABLE ride
ADD COLUMN t_i_id INT;




-- =====================================================
-- PRIMARY KEYS
-- =====================================================


-- Define the primary key for the guide table
ALTER TABLE guide
ADD CONSTRAINT guide_pkey PRIMARY KEY (g_id);

-- Define the primary key for the station table
ALTER TABLE station
ADD CONSTRAINT station_pkey PRIMARY KEY (s_name);

-- Define the primary key for the tour table
ALTER TABLE tour
ADD CONSTRAINT tour_pkey PRIMARY KEY (t_name);

-- Define the primary key for the tourinstance table
ALTER TABLE tourinstance
ADD CONSTRAINT tourinstance_pkey PRIMARY KEY (t_i_id);

-- Define a composite primary key for the tourstation table
ALTER TABLE tourstation
ADD CONSTRAINT tourstation_pkey
PRIMARY KEY (t_index, t_name, s_name);

-- Define the primary key for the bookings table
ALTER TABLE bookings
ADD CONSTRAINT bookings_pkey PRIMARY KEY (b_id);

-- =====================================================
-- UNIQUE
-- =====================================================

-- Ensure that each guide phone number is unique
ALTER TABLE guide
ADD CONSTRAINT uni_guide_phone UNIQUE (g_phone);

-- Ensure that each ride is connected to only one tour instance
ALTER TABLE ride
ADD CONSTRAINT ride_t_i_id_unique UNIQUE (t_i_id);

-- =====================================================
-- FOREIGN KEYS
-- =====================================================

-- Connect each tour instance to a guide
ALTER TABLE tourinstance
ADD CONSTRAINT tourinstance_g_id_fkey
FOREIGN KEY (g_id)
REFERENCES guide(g_id);

-- Connect each tour instance to a tour
ALTER TABLE tourinstance
ADD CONSTRAINT tourinstance_t_name_fkey
FOREIGN KEY (t_name)
REFERENCES tour(t_name);

-- Connect tourstation records to the tour table
ALTER TABLE tourstation
ADD CONSTRAINT tourstation_t_name_fkey
FOREIGN KEY (t_name)
REFERENCES tour(t_name);

-- Connect tourstation records to the station table
ALTER TABLE tourstation
ADD CONSTRAINT tourstation_s_name_fkey
FOREIGN KEY (s_name)
REFERENCES station(s_name);

-- Connect bookings to tour instances
ALTER TABLE bookings
ADD CONSTRAINT bookings_t_i_id_fkey
FOREIGN KEY (t_i_id)
REFERENCES tourinstance(t_i_id);

-- Connect bookings to customers
ALTER TABLE bookings
ADD CONSTRAINT bookings_c_id_fkey
FOREIGN KEY (c_id)
REFERENCES customer(c_id);

-- =====================================================
-- NEW INTEGRATION RELATION:
-- Ride transportFor TourInstance
-- =====================================================


-- Create a relationship between rides and tour instances
ALTER TABLE ride
ADD CONSTRAINT ride_tourinstance_fkey
FOREIGN KEY (t_i_id)
REFERENCES tourinstance(t_i_id);


-- Display all foreign key constraints related to the ride table
SELECT
    tc.constraint_name,
    tc.table_name,
    ccu.table_name AS referenced_table
FROM information_schema.table_constraints tc
JOIN information_schema.constraint_column_usage ccu
ON tc.constraint_name = ccu.constraint_name
WHERE tc.table_name = 'ride'
AND tc.constraint_type = 'FOREIGN KEY';


-- Assign tour instances to rides using row numbering and cyclic distribution
WITH numbered_rides AS (
    SELECT
        rideid,
        ROW_NUMBER() OVER (ORDER BY rideid) AS rn
    FROM ride
),
numbered_tours AS (
    SELECT
        t_i_id,
        ROW_NUMBER() OVER (ORDER BY random()) AS rn,
        COUNT(*) OVER () AS total_tours
    FROM tourinstance
)
UPDATE ride r
SET t_i_id = nt.t_i_id
FROM numbered_rides nr
JOIN numbered_tours nt
  ON nt.rn = ((nr.rn - 1) % nt.total_tours) + 1
WHERE r.rideid = nr.rideid;

