-- Team Quaranteam
-- Musicalos Data Definition Queries
-- Project Step 4 Draft Version


-- Customers
CREATE TABLE customers (
  customerID INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
  firstName VARCHAR(255) NOT NULL,
  lastName VARCHAR(255) NOT NULL,
  email VARCHAR(255) UNIQUE NOT NULL,
  paymentMethod VARCHAR(255) NOT NULL
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
  bandGenre VARCHAR(255) NOT NULL
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
  startTime TIME NOT NULL,
  date DATE NOT NULL,
  cost DECIMAL(20, 2) NOT NULL DEFAULT '10.00',
  FOREIGN KEY (artistID) REFERENCES artists (artisID)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  FOREIGN KEY (venueID) REFERENCES venues (venueID)
    ON DELETE CASCADE
    ON UPDATE CASCADE
)Engine=InnoDB;

-- Concerts-Orders
CREATE TABLE concerts-orders (
  concertID INT NOT NULL,
  orderID INT NOT NULL,
  FOREIGN KEY (concertID) REFERENCES concerts (concertID)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  FOREIGN KEY (orderID) REFERENCES orders (orderID)
    ON DELETE CASCADE
    ON UPDATE CASCADE
)Engine=InnoDB;
