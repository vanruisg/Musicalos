-- Team Quaranteam
-- Musicalos Data Definition Queries
-- Project Step 4 Draft Version


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

-- Orders
CREATE TABLE orders (
  orderID INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
  customerID INT NOT NULL,
  FOREIGN KEY (customerID) REFERENCES customers (customerID)
    ON DELETE CASCADE
    ON UPDATE CASCADE
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

-- Concerts_Orders
CREATE TABLE concerts_orders (
  concertID INT NOT NULL,
  orderID INT NOT NULL,
  quantity INT NOT NULL,
  CONSTRAINT quantity CHECK (quantity BETWEEN 1 AND 5), 
  PRIMARY KEY (concertID, orderID),
  FOREIGN KEY (concertID) REFERENCES concerts (concertID)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  FOREIGN KEY (orderID) REFERENCES orders (orderID)
    ON DELETE CASCADE
    ON UPDATE CASCADE
)Engine=InnoDB;
