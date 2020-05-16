-- Team Quaranteam
-- Musicalos Data Manipulation Queries
-- Project Step 4 Draft Version


-- get all artist IDs, band names, and band genres to populate the Artists page
SELECT artistID, bandName, bandGenre FROM artists;

-- get all venue IDs, venue names, and capacities to populate the Venues page
SELECT venueID, venueName, capacity FROM venues;

-- get all customer IDs, first names, last names, emails, and payment methods to populate the Customers tabs
SELECT customerID, firstName, lastName, email, paymentMethod FROM customers;

-- get all concert IDs, artist IDs, venue IDs, start times, dates, and costs to populate the Concerts page
SELECT concertID, artistID, venueID, startTime, concertDate, cost FROM concerts;

-- get all order IDs and customer IDs to populate the Orders page
SELECT orderID, customerID FROM orders;

-- get all concert IDs and order IDs to populate the Concert_Orders page
SELECT concertID, orderID, quantity FROM concerts_orders;



-- add a new artist
INSERT INTO artists (bandName, bandGenre) VALUES (:bandNameInput, :bandGenreInput);

-- add new venue
INSERT INTO venues (venueName, capacity) VALUES (:venueNameInput, :capacityInput);

-- add new customer
INSERT INTO customers (firstName, lastName, email, paymentMethod) VALUES (:firstNameInput, :lastNameInput, :emailInput, :paymentMethodInput);

-- add new concert
INSERT INTO concerts (artistID, venueID, startTime, concertDate, cost) VALUES (:artistIDInput, :venueIDInput, :startTimeInput, :concertDateInput, :costInput);

-- add new order
INSERT INTO orders (customerID) VALUES (:customerIDInput);

-- add new concert_order
INSERT INTO concerts_orders (concertID, orderID, quantity) VALUES (:concertID_selected_from_homepage, :orderIDinput, :quantityInput);

-- update a customer's data based on submission of the Update Customer Form
UPDATE customers SET firstName = :firstNameInput, lastName = :lastNameInput, email = :emailInput, paymentMethod = :paymentMethod_selected_from_dropdown_list WHERE customerID = :customerID_from_update_customer_form;

-- delete an order
DELETE FROM orders WHERE orderID = :orderID_selected_from_display_orders_page;

-- disassociate an order from a concert (M-to-M relationship deletion)
DELETE FROM concerts_orders WHERE orderID = :orderID_selected_from_display_orders_page;