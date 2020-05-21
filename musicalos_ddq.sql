-- Team Quaranteam
-- Musicalos Data Definition Queries
-- Project Step 4 Draft Version

-- Create Tables
-- Customers
CREATE TABLE customers (
  customerID INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
  firstName VARCHAR(255) NOT NULL,
  lastName VARCHAR(255) NOT NULL,
  email VARCHAR(255) UNIQUE NOT NULL,
  paymentMethod ENUM('Credit Card','Pay at the door')
)Engine=InnoDB;

-- Venues
CREATE TABLE venues (
  venueID INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
  venueName VARCHAR(255) NOT NULL,
  capacity INT NOT NULL
)Engine=InnoDB;

-- Artists
CREATE TABLE artists (
  artistID INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
  bandName VARCHAR(255) NOT NULL,
  bandGenre VARCHAR(255)
)Engine=InnoDB;

-- Concerts
CREATE TABLE concerts (
  concertID INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
  artistID INT NOT NULL,
  venueID INT NOT NULL,
  startTime TIME(0) NOT NULL,
  concertDate DATE NOT NULL,
  cost DECIMAL(13, 2) NOT NULL,
  FOREIGN KEY (artistID) REFERENCES artists (artistID)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  FOREIGN KEY (venueID) REFERENCES venues (venueID)
    ON DELETE CASCADE
    ON UPDATE CASCADE
)Engine=InnoDB;

-- Orders
CREATE TABLE orders (
  orderID INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
  customerID INT NOT NULL,
  FOREIGN KEY (customerID) REFERENCES customers (customerID)
    ON DELETE CASCADE
    ON UPDATE CASCADE
)Engine=InnoDB;

-- Concerts_Orders
CREATE TABLE concerts_orders (
  concertID INT NOT NULL,
  orderID INT NOT NULL,
  quantity INT NOT NULL CHECK (quantity>=1 AND quantity<=5), 
  PRIMARY KEY (concertID, orderID),
  FOREIGN KEY (concertID) REFERENCES concerts (concertID)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  FOREIGN KEY (orderID) REFERENCES orders (orderID)
    ON DELETE CASCADE
    ON UPDATE CASCADE
)Engine=InnoDB;

-- Insert Sample Data 
-- Customers
INSERT INTO customers (firstName, lastName, email, paymentMethod) VALUES
  ('John', 'Smith', 'jazz4lyfe@email.com', 'Pay at the door'),
  ('Louis', 'Armstrong', 'kinglouie@no.com','Pay at the door'),
  ('Troy', 'Andrews', 'hurricane_season@backatown.com', 'Credit Card');

-- Venues
INSERT INTO venues (venueName, capacity) VALUES
  ('Preservation Hall', 200),
  ('House of Blues', 1000),
  ('Blue Nile', 763);

-- Artists
INSERT INTO artists (bandName, bandGenre) VALUES
  ('Trombone Shorty', 'Jazz/rock'),
  ('Preservation Hall Jazz Band', 'Jazz'),
  ('Tom Misch', 'Rock');

-- Concerts
INSERT INTO concerts (artistID, venueID, startTime, concertDate, cost) VALUES 
  (1,2,'18:00:00','2020-07-14','20.00'),
  (2,1,'20:00:00','2020-07-04','30.00'),
  (3,3,'19:00:00','2020-07-20','40.00');

-- Orders
INSERT INTO orders (customerID) VALUES 
  (1),
  (2),
  (3);

-- Concerts_Orders
INSERT INTO concerts_orders (concertID, orderID, quantity) VALUES 
  (1,1,2),
  (2,2,3),
  (3,3,5);
