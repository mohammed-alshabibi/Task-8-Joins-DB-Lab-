 Create database Oreder --& Populate Tables for Smart Order Dashboard
-- Customers Table
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    FullName NVARCHAR(100),
    Phone VARCHAR(20),
    ReferralID INT NULL,
    FOREIGN KEY (ReferralID) REFERENCES Customers(CustomerID)
);

-- Restaurants Table
CREATE TABLE Restaurants (
    RestaurantID INT PRIMARY KEY,
    Name NVARCHAR(100),
    City NVARCHAR(50)
);

-- Orders Table
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    RestaurantID INT,
    OrderDate DATE,
    Status VARCHAR(20),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    FOREIGN KEY (RestaurantID) REFERENCES Restaurants(RestaurantID)
);

-- OrderItems Table
CREATE TABLE OrderItems (
    OrderItemID INT PRIMARY KEY,
    OrderID INT,
    ItemName NVARCHAR(100),
    Quantity INT,
    Price DECIMAL(6,2),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);

-- Menu Table
CREATE TABLE Menu (
    MenuID INT PRIMARY KEY,
    RestaurantID INT,
    ItemName NVARCHAR(100),
    Price DECIMAL(6,2),
    FOREIGN KEY (RestaurantID) REFERENCES Restaurants(RestaurantID)
);

-- Insert Sample Data

-- Customers
INSERT INTO Customers VALUES 
(1, 'Ahmed AlHarthy', '91234567', NULL),
(2, 'Fatma AlBalushi', '92345678', 1),
(3, 'Salim AlZadjali', '93456789', NULL),
(4, 'Aisha AlHinai', '94567890', 2);

-- Restaurants
INSERT INTO Restaurants VALUES 
(1, 'Shawarma King', 'Muscat'),
(2, 'Pizza World', 'Sohar'),
(3, 'Burger Spot', 'Nizwa');

-- Menu
INSERT INTO Menu VALUES
(1, 1, 'Shawarma Chicken', 1.500),
(2, 1, 'Shawarma Beef', 1.800),
(3, 2, 'Pepperoni Pizza', 3.000),
(4, 2, 'Cheese Pizza', 2.500),
(5, 3, 'Classic Burger', 2.000),
(6, 3, 'Zinger Burger', 2.200);

-- Orders
INSERT INTO Orders VALUES
(101, 1, 1, '2024-05-01', 'Delivered'),
(102, 2, 2, '2024-05-02', 'Preparing'),
(103, 3, 1, '2024-05-03', 'Cancelled'),
(104, 4, 3, '2024-05-04', 'Delivered');

-- OrderItems
INSERT INTO OrderItems VALUES
(1, 101, 'Shawarma Chicken', 2, 1.500),
(2, 101, 'Shawarma Beef', 1, 1.800),
(3, 102, 'Pepperoni Pizza', 1, 3.000),
(4, 104, 'Classic Burger', 2, 2.000),
(5, 104, 'Zinger Burger', 1, 2.200);



--////////////////////////////////////////////////////////////////////the tasks////////////////////////////////////////////////////////////////////////////
-- Widget 1: Active Orders Summary
SELECT C.FullName, R.Name AS RestaurantName, O.OrderDate
FROM Orders O
JOIN Customers C ON O.CustomerID = C.CustomerID
JOIN Restaurants R ON O.RestaurantID = R.RestaurantID
WHERE O.Status = 'Preparing';

-- Widget 2: Restaurant Menu Coverage
SELECT R.Name AS RestaurantName, M.ItemName, 
       CASE WHEN OI.ItemName IS NOT NULL THEN 'Ordered' ELSE 'Never Ordered' END AS OrderStatus
FROM Restaurants R
JOIN Menu M ON R.RestaurantID = M.RestaurantID
LEFT JOIN OrderItems OI ON M.ItemName = OI.ItemName AND R.RestaurantID = M.RestaurantID;

-- Widget 3: Customers Without Orders
SELECT C.CustomerID, C.FullName
FROM Customers C
LEFT JOIN Orders O ON C.CustomerID = O.CustomerID
WHERE O.CustomerID IS NULL;


-- Widget 4: Full Engagement Report
SELECT C.CustomerID, C.FullName, O.OrderID
FROM Customers C
LEFT JOIN Orders O ON C.CustomerID = O.CustomerID
UNION
SELECT NULL, NULL, O.OrderID
FROM Orders O
LEFT JOIN Customers C ON O.CustomerID = C.CustomerID
WHERE C.CustomerID IS NULL;

-- Widget 5: Referral Tree
SELECT C.FullName AS Customer, R.FullName AS ReferredBy
FROM Customers C
LEFT JOIN Customers R ON C.ReferralID = R.CustomerID;

-- Widget 6: Menu Performance Tracker
SELECT R.Name AS RestaurantName, M.ItemName,
       COUNT(OI.OrderItemID) AS TimesOrdered,
       SUM(OI.Quantity) AS TotalQuantitySold
FROM Restaurants R
JOIN Menu M ON R.RestaurantID = M.RestaurantID
LEFT JOIN OrderItems OI ON M.ItemName = OI.ItemName
GROUP BY R.Name, M.ItemName;

-- Widget 7: Unused Customers and Items
SELECT C.FullName AS Name, 'Unused Customer' AS Type
FROM Customers C
LEFT JOIN Orders O ON C.CustomerID = O.CustomerID
WHERE O.CustomerID IS NULL

UNION

SELECT M.ItemName, 'Unused Item'
FROM Menu M
LEFT JOIN OrderItems OI ON M.ItemName = OI.ItemName
WHERE OI.ItemName IS NULL;


-- Widget 8: Orders with Missing Menu Price Match
SELECT O.OrderID, OI.ItemName
FROM Orders O
JOIN OrderItems OI ON O.OrderID = OI.OrderID
LEFT JOIN Menu M 
 ON OI.ItemName = M.ItemName AND O.RestaurantID = M.RestaurantID
WHERE M.MenuID IS NULL;


-- Widget 9: Repeat Customers Report
SELECT C.FullName, COUNT(O.OrderID) AS TotalOrders,
       MIN(O.OrderDate) AS FirstOrderDate,
       MAX(O.OrderDate) AS LastOrderDate
FROM Customers C
JOIN Orders O ON C.CustomerID = O.CustomerID
GROUP BY C.FullName
HAVING COUNT(O.OrderID) > 1;


-- Widget 10: Item Referral Revenue
SELECT R.FullName AS Referrer, C.FullName AS ReferredCustomer,
       SUM(OI.Quantity * OI.Price) AS TotalSpent
FROM Customers C
JOIN Customers R ON C.ReferralID = R.CustomerID
JOIN Orders O ON C.CustomerID = O.CustomerID
JOIN OrderItems OI ON O.OrderID = OI.OrderID
GROUP BY R.FullName, C.FullName;

-- Widget 11: Update Prices for Bestsellers
UPDATE M
SET M.Price = M.Price * 1.10
FROM Menu M
JOIN (
    SELECT OI.ItemName
    FROM OrderItems OI
    GROUP BY OI.ItemName
    HAVING COUNT(*) > 3
) BestSellers ON M.ItemName = BestSellers.ItemName;

-- Widget 12: Delete Inactive Customers
DELETE FROM Customers
WHERE CustomerID IN (
    SELECT C.CustomerID
    FROM Customers C
    LEFT JOIN Orders O ON C.CustomerID = O.CustomerID
    WHERE O.OrderID IS NULL AND C.ReferralID IS NULL
);

-- Widget 13: Adjust Prices for Inactive Restaurants
UPDATE M
SET M.Price = M.Price * 0.85
FROM Menu M
JOIN Restaurants R ON M.RestaurantID = R.RestaurantID
LEFT JOIN Orders O ON R.RestaurantID = O.RestaurantID
WHERE O.OrderID IS NULL;

-- Widget 14: Register VIP Customers (Step 1: Verify)
SELECT DISTINCT C.CustomerID, C.FullName
FROM Customers C
JOIN Orders O ON C.CustomerID = O.CustomerID
JOIN OrderItems OI ON O.OrderID = OI.OrderID;

-- Widget 14: Register VIP Customers (Step 2: Insert)
--INSERT INTO VIPCustomers (CustomerID, FullName)
--VALUES (101, 'Mohammed Said'),
       --(102, 'Fatma Al Balushi');

-- Widget 15: Order Dispatch Overview
SELECT 
    C.FullName AS CustomerName,
    R.Name AS RestaurantName,
    OI.ItemName,
    O.Status
FROM Orders O
JOIN Customers C ON O.CustomerID = C.CustomerID
JOIN Restaurants R ON O.RestaurantID = R.RestaurantID
JOIN OrderItems OI ON O.OrderID = OI.OrderID;



--/////////////////////////////////////////////////////////////////////////////insert to test some fuctions ////////////////////////////////////

INSERT INTO Customers (CustomerID, FullName, Phone, ReferralID)
VALUES (7, 'Zahra AlMaqbali', '97890123', NULL);


INSERT INTO Orders (OrderID, CustomerID, RestaurantID, OrderDate, Status)
VALUES (108, 1, 1, '2024-05-08', 'Preparing');


INSERT INTO OrderItems (OrderItemID, OrderID, ItemName, Quantity, Price)
VALUES (7, 108, 'Nonexistent Item', 1, 1.000);
