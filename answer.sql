-- ============================================================
-- Week 7 Assignment: Database Design and Normalization
-- ============================================================

-- Create a fresh database so it doesn't clash with old tables
CREATE DATABASE IF NOT EXISTS week7_assignment;
USE week7_assignment;

-- ============================================================
-- QUESTION 1: Achieving First Normal Form (1NF)
-- Problem: Products column had multiple values like 'Laptop, Mouse'
-- Solution: Each row = 1 product per order. Atomic values only.
-- ============================================================

DROP TABLE IF EXISTS ProductDetail_1NF;

CREATE TABLE ProductDetail_1NF (
    OrderID INT NOT NULL,
    CustomerName VARCHAR(100) NOT NULL,
    Product VARCHAR(100) NOT NULL,
    PRIMARY KEY (OrderID, Product)
);

INSERT INTO ProductDetail_1NF (OrderID, CustomerName, Product) VALUES
(101, 'John Doe', 'Laptop'),
(101, 'John Doe', 'Mouse'),
(102, 'Jane Smith', 'Tablet'),
(102, 'Jane Smith', 'Keyboard'),
(102, 'Jane Smith', 'Mouse'),
(103, 'Emily Clark', 'Phone');

-- ============================================================
-- QUESTION 2: Achieving Second Normal Form (2NF)
-- Problem: Partial Dependency
-- CustomerName depends only on OrderID, not on full key (OrderID, Product)
-- Solution: Split into Orders + OrderItems
-- ============================================================

SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS OrderItems;
DROP TABLE IF EXISTS Orders;
SET FOREIGN_KEY_CHECKS = 1;

-- Orders table: CustomerName depends on OrderID alone, so it lives here
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerName VARCHAR(100) NOT NULL
);

-- OrderItems table: Product + Quantity depend on full key (OrderID, Product)
CREATE TABLE OrderItems (
    OrderID INT NOT NULL,
    Product VARCHAR(100) NOT NULL,
    Quantity INT NOT NULL,
    PRIMARY KEY (OrderID, Product),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);

INSERT INTO Orders (OrderID, CustomerName) VALUES
(101, 'John Doe'),
(102, 'Jane Smith'),
(103, 'Emily Clark');

INSERT INTO OrderItems (OrderID, Product, Quantity) VALUES
(101, 'Laptop', 2),
(101, 'Mouse', 1),
(102, 'Tablet', 3),
(102, 'Keyboard', 1),
(102, 'Mouse', 2),
(103, 'Phone', 1);

-- Verification queries
SELECT * FROM ProductDetail_1NF;
SELECT * FROM Orders;
SELECT * FROM OrderItems;