-- ======================
-- DRIVERS
-- ======================
INSERT INTO DRIVER (phoneNumber, status, licenseNumber, fullName) VALUES
('0501234567', 'available', 101, 'David Cohen'),
('0527654321', 'busy', 102, 'Moshe Levi'),
('0539876543', 'available', 103, 'Yossi Katz'),
('0544444444', 'available', 104, 'Eitan Mizrahi'),
('0555555555', 'busy', 105, 'Avi Peretz'),
('0566666666', 'available', 106, 'Shlomi Biton'),
('0577777777', 'busy', 107, 'Nir Azulay'),
('0588888888', 'available', 108, 'Oren Malka');

-- ======================
-- CUSTOMERS
-- ======================
INSERT INTO CUSTOMER (id, phoneNumber, email, fullName) VALUES
(1, '0501111111', 'noa@gmail.com', 'Noa Israel'),
(2, '0522222222', 'dan@gmail.com', 'Dan Cohen'),
(3, '0533333333', 'maya@gmail.com', 'Maya Levi'),
(4, '0541111111', 'ron@gmail.com', 'Ron Ben David'),
(5, '0552222222', 'liron@gmail.com', 'Liron Azulay'),
(6, '0563333333', 'adi@gmail.com', 'Adi Peretz'),
(7, '0574444444', 'tal@gmail.com', 'Tal Mizrahi'),
(8, '0585555555', 'shira@gmail.com', 'Shira Cohen');

-- ======================
-- VEHICLES
-- ======================
INSERT INTO VEHICLE (plateNumber, model, capacity, carColor, year, status) VALUES
('123-45-678', 'Toyota Corolla', 4, 'White', 2020, 'active'),
('234-56-789', 'Hyundai i30', 4, 'Black', 2019, 'active'),
('345-67-890', 'Kia Picanto', 4, 'Red', 2021, 'active'),
('456-78-901', 'Mazda 3', 5, 'Gray', 2022, 'active'),
('567-89-012', 'Skoda Octavia', 5, 'White', 2021, 'active'),
('678-90-123', 'Honda Civic', 4, 'Blue', 2020, 'active'),
('789-01-234', 'Ford Focus', 5, 'Silver', 2018, 'inactive'),
('890-12-345', 'Chevrolet Spark', 4, 'Green', 2023, 'active');

-- ======================
-- ROUTES
-- ======================
INSERT INTO ROUTE (origin, destination, distanceKm, estimatedTravelTime) VALUES
('Jerusalem', 'Tel Aviv', 65, 60),
('Tel Aviv', 'Haifa', 90, 80),
('Jerusalem', 'Haifa', 150, 120),
('Jerusalem', 'Eilat', 300, 240),
('Tel Aviv', 'Beer Sheva', 110, 90),
('Haifa', 'Nazareth', 40, 35),
('Netanya', 'Herzliya', 20, 25),
('Ashdod', 'Jerusalem', 70, 65);

-- ======================
-- RIDES
-- ======================
INSERT INTO RIDE VALUES
(1, '2026-03-18', '08:00:00', 'completed', '09:00:00', 'credit', 101, '123-45-678', 1, 'Jerusalem', 'Tel Aviv'),
(2, '2026-03-18', '10:00:00', 'completed', '11:20:00', 'cash', 102, '234-56-789', 2, 'Tel Aviv', 'Haifa'),
(3, '2026-03-18', '12:00:00', 'in_progress', NULL, 'credit', 103, '345-67-890', 3, 'Jerusalem', 'Haifa'),

(4, '2026-03-19', '09:00:00', 'completed', '10:30:00', 'credit', 104, '456-78-901', 4, 'Jerusalem', 'Eilat'),
(5, '2026-03-19', '11:00:00', 'completed', '12:30:00', 'cash', 105, '567-89-012', 5, 'Tel Aviv', 'Beer Sheva'),
(6, '2026-03-19', '13:00:00', 'cancelled', NULL, 'credit', 106, '678-90-123', 6, 'Haifa', 'Nazareth'),

(7, '2026-03-20', '08:30:00', 'completed', '09:00:00', 'credit', 107, '789-01-234', 7, 'Netanya', 'Herzliya'),
(8, '2026-03-20', '10:00:00', 'in_progress', NULL, 'cash', 108, '890-12-345', 8, 'Ashdod', 'Jerusalem'),

(9, '2026-03-21', '07:00:00', 'completed', '08:00:00', 'credit', 101, '123-45-678', 2, 'Jerusalem', 'Tel Aviv'),
(10, '2026-03-21', '09:30:00', 'completed', '10:50:00', 'cash', 102, '234-56-789', 3, 'Tel Aviv', 'Haifa'),
(11, '2026-03-21', '11:00:00', 'completed', '12:40:00', 'credit', 103, '345-67-890', 1, 'Jerusalem', 'Haifa'),
(12, '2026-03-21', '14:00:00', 'completed', '15:20:00', 'cash', 104, '456-78-901', 5, 'Jerusalem', 'Eilat');

-- ======================
-- MAINTENANCE
-- ======================
INSERT INTO MAINTENANCE VALUES
('2026-01-10', 'Oil Change', 200, 'Engine oil replacement', '123-45-678'),
('2026-02-15', 'Tire Replacement', 800, 'Changed two tires', '234-56-789'),
('2026-03-01', 'Brake Check', 300, 'Brake pads inspection', '345-67-890'),

('2026-03-05', 'Battery Replacement', 500, 'Replaced battery', '456-78-901'),
('2026-03-06', 'Oil Change', 220, 'Routine oil change', '567-89-012'),
('2026-03-07', 'Brake Replacement', 900, 'Brake pads replaced', '678-90-123'),
('2026-03-08', 'Engine Check', 400, 'Engine diagnostics', '789-01-234'),
('2026-03-09', 'Tire Check', 150, 'Checked tire pressure', '890-12-345'),

-- עוד טיפולים לאותו רכב (עובד כי מחקת UNIQUE)
('2026-03-15', 'Oil Change', 210, 'Second oil change', '123-45-678'),
('2026-03-18', 'Filter Change', 180, 'Air filter replaced', '123-45-678');

COMMIT;