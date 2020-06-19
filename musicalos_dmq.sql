-- Team Quaranteam
-- Musicalos Data Manipulation Queries
-- Project Step 4 Draft Version


-- ----------------------------------------------------------------------
-- 
-- Home Page
-- 
-- filter concerts by date 
SELECT * FROM concerts WHERE concertDate = :dateInput;
SELECT concerts.concertDate, artists.bandName, concerts.startTime, concerts.cost FROM concerts INNER JOIN artists ON concerts.artistID = artists.artistID WHERE concerts.concertDate = :dateInput;

-- ----------------------------------------------------------------------
-- 
-- Artists
-- 
-- get all artist IDs, band names, and band genres to populate the Artists page
SELECT artistID, bandName, bandGenre FROM artists;

-- add a new artist
INSERT INTO artists (bandName, bandGenre) VALUES (:bandNameInput, :bandGenreInput);

-- ----------------------------------------------------------------------
-- 
-- Venues
-- 
-- get all venue IDs, venue names, and capacities to populate the Venues page
SELECT venueID, venueName, capacity FROM venues;

-- add new venue
INSERT INTO venues (venueName, capacity) VALUES (:venueNameInput, :capacityInput);

-- ----------------------------------------------------------------------
-- 
-- Concerts
-- 
-- get all concert IDs, artist IDs, venue IDs, start times, dates, and costs to populate the Concerts page
SELECT concertID, artistID, venueID, startTime, concertDate, cost FROM concerts;

-- update concer to make venue of concert nullable
UPDATE concerts SET venueID = :venueIDInput WHERE concertID = concertIDInput

-- add new concert
INSERT INTO concerts (artistID, venueID, startTime, concertDate, cost) VALUES (:artistIDInput, :venueIDInput, :startTimeInput, :concertDateInput, :costInput);


-- ----------------------------------------------------------------------
-- 
-- Customers
-- 
-- get all customer IDs, first names, last names, emails, and payment methods to populate the Customers tabs
SELECT customerID, firstName, lastName, email, paymentMethod FROM customers;

-- update a customer's data based on submission of the Update Customer Form
UPDATE customers SET firstName = :firstNameInput, lastName = :lastNameInput, email = :emailInput, paymentMethod = :paymentMethod_selected_from_dropdown_list WHERE customerID = :customerID_from_update_customer_form;

-- add new customer
INSERT INTO customers (firstName, lastName, email, paymentMethod) VALUES (:firstNameInput, :lastNameInput, :emailInput, :paymentMethodInput);

-- ----------------------------------------------------------------------
-- 
-- Orders
-- 
-- get all order IDs and customer IDs to populate the Orders page
SELECT orderID, customerID FROM orders ORDER BY orderID ASC;

-- add new order, which also inserts into Concerts Orders table 
INSERT INTO concerts_orders (concertID, orderID, quantity) VALUES (:concertIDInput,(SELECT max(orderID) FROM orders),:quantityInput);

-- delete an order
DELETE FROM orders WHERE orderID = :orderID_selected_from_display_orders_page;

-- ----------------------------------------------------------------------
-- 
-- Concerts Orders
-- 
-- get all concert IDs and order IDs to populate the Concert_Orders page
SELECT concertID, orderID, quantity FROM concerts_orders;



























