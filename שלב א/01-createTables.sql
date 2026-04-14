CREATE TABLE DRIVER
(
  phoneNumber VARCHAR(20) NOT NULL,
  status VARCHAR(20) NOT NULL,
  licenseNumber INT NOT NULL,
  fullName VARCHAR(100) NOT NULL,
  PRIMARY KEY (licenseNumber)
);

CREATE TABLE ROUTE
(
  origin VARCHAR(100) NOT NULL,
  destination VARCHAR(100) NOT NULL,
  distanceKm INT NOT NULL,
  estimatedTravelTime INT NOT NULL,
  PRIMARY KEY (origin, destination)
);

CREATE TABLE CUSTOMER
(
  id INT NOT NULL,
  phoneNumber VARCHAR(20) NOT NULL,
  email VARCHAR(100) NOT NULL,
  fullName VARCHAR(100) NOT NULL,
  PRIMARY KEY (id)
);

CREATE TABLE VEHICLE
(
  plateNumber VARCHAR(20) NOT NULL,
  model VARCHAR(50) NOT NULL,
  capacity INT NOT NULL,
  carColor VARCHAR(30) NOT NULL,
  year INT NOT NULL,
  status VARCHAR(20) NOT NULL,
  PRIMARY KEY (plateNumber)
);

CREATE TABLE RIDE
(
  rideId INT NOT NULL,
  orderDate DATE NOT NULL,
  startTime TIME NOT NULL,
  status VARCHAR(20) NOT NULL,
  endTime TIME,
  paymentMethod VARCHAR(30) NOT NULL,
  licenseNumber INT NOT NULL,
  plateNumber VARCHAR(20) NOT NULL,
  id INT NOT NULL,
  origin VARCHAR(100) NOT NULL,
  destination VARCHAR(100) NOT NULL,
  PRIMARY KEY (rideId),
  FOREIGN KEY (licenseNumber) REFERENCES DRIVER(licenseNumber),
  FOREIGN KEY (plateNumber) REFERENCES VEHICLE(plateNumber),
  FOREIGN KEY (id) REFERENCES CUSTOMER(id),
  FOREIGN KEY (origin, destination) REFERENCES ROUTE(origin, destination)
);

CREATE TABLE MAINTENANCE
(
  maintenanceDate DATE NOT NULL,
  MaintenanceType VARCHAR(50) NOT NULL,
  Cost INT NOT NULL,
  Description VARCHAR(255) NOT NULL,
  plateNumber VARCHAR(20) NOT NULL,
  PRIMARY KEY (maintenanceDate, plateNumber),
  FOREIGN KEY (plateNumber) REFERENCES VEHICLE(plateNumber)
);