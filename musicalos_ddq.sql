-- ----------------------------------------------------------------------
-- Team Quaranteam
-- Gerrit Van Ruiswyk, Kathleen O'Connor
-- Musicalos Data Definition Queries
-- Project Step 4 Draft Version
-- ----------------------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

-- ----------------------------------------------------------------------
-- 
-- Table structure for table `customers`
-- 

DROP TABLE IF EXISTS `customers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `customers` (
  `customerID` INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
  `firstName` VARCHAR(255) NOT NULL,
  `lastName` VARCHAR(255) NOT NULL,
  `email` VARCHAR(255) UNIQUE NOT NULL,
  `paymentMethod` ENUM('Credit Card','Pay at the door')
)Engine=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

-- 
-- Dumping data for table `customers`
-- 

LOCK TABLES `customers` WRITE;
/*!40000 ALTER TABLE `customers` DISABLE KEYS */;
INSERT INTO `customers` (`firstName`, `lastName`, `email`, `paymentMethod`) VALUES
  ('John', 'Smith', 'jazz4lyfe@email.com', 'Pay at the door'),
  ('Louis', 'Armstrong', 'kinglouie@no.com','Pay at the door'),
  ('Troy', 'Andrews', 'hurricane_season@backatown.com', 'Credit Card');
/*!40000 ALTER TABLE `customers` ENABLE KEYS */;
UNLOCK TABLES;

-- ----------------------------------------------------------------------
-- 
-- Table structure for table `venues`
-- 

DROP TABLE IF EXISTS `venues`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `venues` (
  `venueID` INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
  `venueName` VARCHAR(255) NOT NULL,
  `capacity` INT NOT NULL
)Engine=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

-- 
-- Dumping data for table `venues`
-- 

LOCK TABLES `venues` WRITE;
/*!40000 ALTER TABLE `venues` DISABLE KEYS */;
INSERT INTO `venues` (`venueName`, `capacity`) VALUES
  ('Preservation Hall', 200),
  ('House of Blues', 1000),
  ('Blue Nile', 763);
/*!40000 ALTER TABLE `venues` ENABLE KEYS */;
UNLOCK TABLES;

-- ----------------------------------------------------------------------
-- 
-- Table structure for table `artists`
-- 

DROP TABLE IF EXISTS `artists`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `artists` (
  `artistID` INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
  `bandName` VARCHAR(255) NOT NULL,
  `bandGenre` VARCHAR(255) NOT NULL
)Engine=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

-- 
-- Dumping data for table `artists`
-- 

LOCK TABLES `artists` WRITE;
/*!40000 ALTER TABLE `artists` DISABLE KEYS */;
INSERT INTO `artists` (`bandName`, `bandGenre`) VALUES
  ('Trombone Shorty', 'Jazz/rock'),
  ('Preservation Hall Jazz Band', 'Jazz'),
  ('Tom Misch', 'Rock');
/*!40000 ALTER TABLE `artists` ENABLE KEYS */;
UNLOCK TABLES;

-- ----------------------------------------------------------------------
-- 
-- Table structure for table `concerts`
-- 

DROP TABLE IF EXISTS `concerts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `concerts` (
  `concertID` INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
  `artistID` INT NOT NULL,
  `venueID` INT NULL,
  `startTime` TIME(0) NOT NULL,
  `concertDate` DATE NOT NULL,
  `cost` DECIMAL(4, 2) NOT NULL CHECK (cost>=10.00 AND cost<=50.00),
  FOREIGN KEY (`artistID`) REFERENCES `artists` (`artistID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  FOREIGN KEY (`venueID`) REFERENCES venues (`venueID`)
)Engine=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

-- 
-- Dumping data for table `concerts`
-- 

LOCK TABLES `concerts` WRITE;
/*!40000 ALTER TABLE `concerts` DISABLE KEYS */;
INSERT INTO `concerts` (`artistID`, `venueID`, `startTime`, `concertDate`, `cost`) VALUES 
  (1,2,'18:00:00','2020-07-14','20.00'),
  (2,1,'20:00:00','2020-07-04','30.00'),
  (3,3,'19:00:00','2020-07-20','40.00');
/*!40000 ALTER TABLE `concerts` ENABLE KEYS */;
UNLOCK TABLES;

-- ----------------------------------------------------------------------
-- 
-- Table structure for table `orders`
-- 

DROP TABLE IF EXISTS `orders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `orders` (
  `orderID` INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
  `customerID` INT NOT NULL,
  FOREIGN KEY (`customerID`) REFERENCES `customers` (`customerID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE
)Engine=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

-- 
-- Dumping data for table `orders`
-- 

LOCK TABLES `orders` WRITE;
/*!40000 ALTER TABLE `orders` DISABLE KEYS */;
INSERT INTO `orders` (`customerID`) VALUES 
  (1),
  (2),
  (3);
/*!40000 ALTER TABLE `orders` ENABLE KEYS */;
UNLOCK TABLES;

-- ----------------------------------------------------------------------
-- 
-- Table structure for table `concerts_orders`
-- 

DROP TABLE IF EXISTS concerts_orders;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `concerts_orders` (
  `concertID` INT NOT NULL,
  `orderID` INT NOT NULL,
  `quantity` INT NOT NULL CHECK (quantity>=1 AND quantity<=5), 
  PRIMARY KEY (`concertID`, `orderID`),
  FOREIGN KEY (`concertID`) REFERENCES concerts (`concertID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  FOREIGN KEY (`orderID`) REFERENCES orders (`orderID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE
)Engine=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

-- 
-- Dumping data for table `concerts_orders`
-- 

LOCK TABLES `concerts_orders`WRITE;
/*!40000 ALTER TABLE `concerts_orders` DISABLE KEYS */;
INSERT INTO `concerts_orders` (`concertID`, `orderID`, `quantity`) VALUES 
  (1,1,2),
  (2,2,3),
  (3,3,5);
/*!40000 ALTER TABLE `concerts_orders` ENABLE KEYS */;
UNLOCK TABLES;

-- ----------------------------------------------------------------------