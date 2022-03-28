-- SQL tables for a small diner

CREATE TABLE tblOrder (
  OrderId INTEGER PRIMARY KEY,
  OrderDate DATE NOT NULL,
  TotalCost DECIMAL NOT NULL
);

CREATE TABLE tblOrderLineItem (
  OrderLineItemId INTEGER PRIMARY KEY,
  OrderId INTEGER NOT NULL,
  GuestId INTEGER NOT NULL,
  DishId INTEGER NOT NULL
);

CREATE TABLE tblGuest (
  GuestId INTEGER PRIMARY KEY,
  FirstName VARCHAR(50) NOT NULL,
  LastName VARCHAR(50) NOT NULL,
  Email VARCHAR(50),
  Phone VARCHAR(20)
);

CREATE TABLE tblDish (
  DishId INTEGER PRIMARY KEY,
  DishName VARCHAR(50) NOT NULL,
  Price DECIMAL NOT NULL
);

INSERT INTO tblGuest VALUES (0001, 'Cameron', 'Diaz', 'cdiaz@email.com', '555-555-5555');
INSERT INTO tblGuest VALUES (0002, 'Denzel', 'Washington', '', '888-123-4567');
INSERT INTO tblGuest VALUES (0003, 'Matt', 'Damon', 'apples@school.edu', NULL);
INSERT INTO tblGuest (FirstName, LastName, GuestId, Email) VALUES ('Bruce', 'Lee', 0004, 'dragon@master.fu');
INSERT INTO tblGuest VALUES (0005, 'Kerry', 'Washington', NULL, NULL);

INSERT INTO tblOrder VALUES (1001, '2020-01-01 12:00', 50.25);
INSERT INTO tblOrder VALUES (1002, '2020-01-02 11:15', 110.99);
INSERT INTO tblOrder VALUES (1003, '2020-01-11 13:30', 35.75);

INSERT INTO tblDish VALUES (5001, 'Breakfast Sandwich', 9.50);
INSERT INTO tblDish VALUES (5002, 'Biscuits and Gravy', 12.99);
INSERT INTO tblDish VALUES (5003, 'Eggs Benedict', 15.00);

INSERT INTO tblOrderLineItem VALUES (10100, 1001, 0001, 5001);
INSERT INTO tblOrderLineItem VALUES (10101, 1002, 0002, 5002);
INSERT INTO tblOrderLineItem VALUES (10102, 1002, 0002, 5003);
INSERT INTO tblOrderLineItem VALUES (10103, 1002, 0003, 5001);
INSERT INTO tblOrderLineItem VALUES (10104, 1003, 0004, 5001);
INSERT INTO tblOrderLineItem VALUES (10105, 1003, 0004, 5001);
INSERT INTO tblOrderLineItem VALUES (10106, 1003, 0004, 5001);
INSERT INTO tblOrderLineItem VALUES (10107, 1004, 0010, 5002);
INSERT INTO tblOrderLineItem VALUES (10108, 1005, 0010, 5003);
INSERT INTO tblOrderLineItem VALUES (10109, 1006, 0010, 5004);


SELECT tblGuest.FirstName, tblGuest.LastName, tblOrderLineItem.OrderId
FROM tblGuest
INNER JOIN tblOrderLineItem ON tblGuest.GuestId = tblOrderLineItem.GuestId; 
-- Includes only the Guests and their matching orders

SELECT tblGuest.FirstName, tblGuest.LastName, tblOrderLineItem.OrderId
FROM tblGuest
LEFT JOIN tblOrderLineItem ON tblGuest.GuestId = tblOrderLineItem.GuestId;
-- Includes all Guests and their matching orders if present

SELECT tblGuest.FirstName, tblGuest.LastName, tblOrderLineItem.OrderId
FROM tblGuest
RIGHT JOIN tblOrderLineItem ON tblGuest.GuestId = tblOrderLineItem.GuestId;
-- Includes all OrderLineItems and their matching guests if present

SELECT g.FirstName, g.LastName, lineitem.OrderId, dish.DishName
FROM tblGuest g
JOIN tblOrderLineItem lineitem ON g.GuestId = lineitem.GuestId
JOIN tblDish dish ON dish.DishId = lineitem.DishId
WHERE dish.DishId > 5001;
-- Includes only the Guests who ordered Dishes with id greater than 5001

SELECT g.FirstName, g.LastName, lineitem.OrderId, dish.DishName
FROM tblGuest g
RIGHT JOIN tblOrderLineItem lineitem ON g.GuestId = lineitem.GuestId
JOIN tblDish dish ON dish.DishId = lineitem.DishId
WHERE dish.DishId > 5001;
-- Includes all LineItems where Dishes with id greater than 5001


--Nested Loop Join
-- Essentially a nested for loop for the two tables - for each entry in table1, look at every entry in table2 for matching records
-- Very CPU intensive, Big O(n^2)
-- Possible optimizations by using ordered indexes where SQL will seek instead of scan, or clustered index, where SQL can do key lookups
-- https://sqlserverfast.com/epr/nested-loops/

--Merge Join
-- If data is sorted, SQL Server will go through each row in each table only once, incrementing the lowest indexed pointer in either table when matches do not occur
-- Very efficient execution plan! Ideal for joining data streams that are sorted by the join key. Not ideal with data that includes many duplicates
-- https://sqlserverfast.com/epr/merge-join/

--Hash Match
-- Workhorse of the physical joins, as long as there is an equality predicate and enough space in tempdb
-- In the first phase known as the hash phase, a hash table is created in memory (using tempdb memory on disk if it runs out) with the first table in the join
-- In the second phase known as the probe phase, the hash table is queried against the second table in the join
-- Most effective for joining large unsorted sets
-- Blocking operation though
-- https://sqlserverfast.com/epr/hash-match/cd






