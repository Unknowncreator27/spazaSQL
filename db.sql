CREATE DATABASE spazaDB

ON PRIMARY
(
   NAME = spazaDB,
   FILENAME = 'C:\spazaDB_Data.mdf', -- not sure where to place the data  file
   SIZE = 50GB --update as we go
   MAXSIZE = 100GB
   FILEGROWTH = 10GB
),

-- Secondary filegroup for non-clustered indexes or historic data
FILEGROUP Secondary
(
    NAME = spazaDBSecondary,
    FILENAME = 'C:\spazaDB_Data_Secondary.ndf',
    SIZE = 50GB,
    MAXSIZE = 100GB,
    FILEGROWTH = 5GB
),
-- Log file
LOG ON
(
    NAME = spazaDBLog,
    FILENAME = 'C:\spazaDB_Log.ldf',
    SIZE = 20GB,
    MAXSIZE = 40GB,
    FILEGROWTH = 2GB
);
GO

USE spazaDB
GO

----------------------------------------------------------
--- Where we will add the data file and log file ---
---- test1234


----------------------------------------------------------

CREATE TABLE Category (
    CategoryID INT IDENTITY(1,1) PRIMARY KEY,
    CategoryName VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE Supplier (
    SupplierID INT IDENTITY(1,1) PRIMARY KEY,
    SupplierName VARCHAR(100) NOT NULL,
    SupplierCategory VARCHAR(50) NOT NULL,
    ContactNumber VARCHAR(20) NULL,
    SupplierAddress VARCHAR(200) NULL
);

CREATE TABLE Employee (
    EmployeeID INT IDENTITY(1,1) PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    EmployeeRole VARCHAR(30) NOT NULL,
    ContactNumber VARCHAR(20) NULL
);

CREATE TABLE Customer (
    CustomerID INT IDENTITY(1,1) PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    ContactNumber VARCHAR(20) NULL
);

CREATE TABLE Product (
    ProductID INT IDENTITY(1,1) PRIMARY KEY,
    CategoryID INT NOT NULL,
    ProductName VARCHAR(100) NOT NULL,
    UnitPrice DECIMAL(10,2) NOT NULL CHECK (UnitPrice >= 0),
    CostPrice DECIMAL(10,2) NOT NULL CHECK (CostPrice >= 0),
    QuantityInStock INT NOT NULL DEFAULT 0 CHECK (QuantityInStock >= 0),
    ReorderLevel INT NOT NULL DEFAULT 0 CHECK (ReorderLevel >= 0),
    ExpiryDate DATE NULL,
    CONSTRAINT FK_Product_Category FOREIGN KEY (CategoryID)
        REFERENCES Category (CategoryID)
);

-- Buying stock from Suppliers
CREATE TABLE Purchase (
    PurchaseID INT IDENTITY(1,1) PRIMARY KEY,
    SupplierID INT NOT NULL,
    PurchaseDate DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT FK_Purchase_Supplier FOREIGN KEY (SupplierID)    
        REFERENCES Supplier(SupplierID)
);

-- Line items for each Purchase
CREATE TABLE PurchaseItem (
    PurchaseItemID INT IDENTITY(1,1) PRIMARY KEY,
    PurchaseID INT NOT NULL,
    ProductID INT NOT NULL,
    QuantityBought INT NOT NULL CHECK (QuantityBought > 0),
    UnitCost DECIMAL(10,2) NOT NULL CHECK (UnitCost >=0),
    CONSTRAINT FK_PurchaseItem_Purchase FOREIGN KEY (PurchaseID) 
        REFERENCES Purchase(PurchaseID),
    CONSTRAINT FK_PurchaseItem_Product FOREIGN KEY (ProductID)
        REFERENCES Product(ProductID)
);

-- Customer transactions at the till
CREATE TABLE Sale (
    SaleID INT IDENTITY(1,1) PRIMARY KEY,
    CustomerID INT NULL,
    EmployeeID INT NOT NULL,
    SaleDate DATETIME NOT NULL DEFAULT GETDATE(),
    PaymentType VARCHAR(30) NOT NULL,
    CONSTRAINT FK_Sale_Customer FOREIGN KEY (CustomerID)
        REFERENCES Customer(CustomerID),
    CONSTRAINT FK_Sale_Employee FOREIGN KEY (EmployeeID)
        REFERENCES Employee(EmployeeID)
);

-- Line items for each sale
CREATE TABLE SaleItem (
    SaleItemID INT IDENTITY(1,1) PRIMARY KEY,
    SaleID INT NOT NULL,
    ProductID INT NOT NULL,
    QuantitySold INT NOT NULL CHECK (QuantitySold > 0),
    UnitPriceAtSale DECIMAL(10,2) NOT NULL CHECK (UnitPriceAtSale >= 0),
    CONSTRAINT FK_SaleItem_Sale FOREIGN KEY (SaleID)
        REFERENCES Sale(SaleID),
    CONSTRAINT FK_SaleItem_Product FOREIGN KEY (ProductID)
        REFERENCES Product(ProductID)
);

-- Adjusting stock for spoilage, stock count fixes, etc.
CREATE TABLE InventoryAdjustments (
    AdjustmentID INT IDENTITY(1,1) PRIMARY KEY,
    ProductID INT NOT NULL,
    EmployeeID INT NOT NULL,
    AdjustmentDate DATETIME NOT NULL DEFAULT GETDATE(),
    QuantityAdjusted INT NOT NULL,
    Reason VARCHAR(50) NOT NULL,
    CONSTRAINT FK_InvAdj_Product FOREIGN KEY (ProductID)
        REFERENCES Product(ProductID),
    CONSTRAINT FK_InvAdj_Employee FOREIGN KEY (EmployeeID)
        REFERENCES Employee(EmployeeID)
);

--------------------------------------------------------------------------------------------------

INSERT INTO Category (CategoryName)
VALUES
('Groceries'), 
('Beverages'), 
('Snacks'), 
('Bakery'), 
('Toiletries'), 
('Household Cleaning'), 
('Airtime & Data'), 
('Sweets & Chocolates'), 
('Dairy'), 
('Canned Goods');

INSERT INTO Supplier(SupplierName, SupplierCategory, ContactNumber, SupplierAddress)
VALUES
('Distribution One', 'Fast-Moving Consumer Goods', '0626372441', 'Plot 54 Third Avenue, Gerhardsville, Centurion, 0157'),
('Makro Wholesale', 'Cash & Carry Wholesaler', '086030000', '16 Peltier Drive, Sunninghill, Sandton, 2157'),
('Pioneer Foos (PepsiCo SA', 'FMCG & Bakery', '080 021 2360', 'Parc Du Cap Office Park, Building 5, 10 Willie van Schoor Avenue, Bellville, 7530'),
('Flash Mobile Vending', 'Digital Aggregator', '0839035274', '36 Stellenberg Road, Parow Industria, Cape Town, 7493');

INSERT INTO Employee
(FirstName, LastName, EmployeeRole, ContactNumber)
VALUES
('Thabo', 'Mokoena', 'Manager', '0821112233'),
('Sarah', 'Jacobs', 'Cashier', '0832223344'),
('Michael', 'du Toit', 'Stock Clerk', '0843334455'),
('Lerato', 'Dlamini', 'Cashier', '0854445566'),
('Jaco', 'Pieterson', 'Supervisor', '0865556677');


INSERT INTO Customer (FirstName, LastName, ContactNumber)
VALUES 
('Sipho', 'Nkosi', '0712345678'),
('Nomsa', 'Dube', '0723456789'),
('Pieter', 'Van Wyk', '0734567890'),
('Ayanda', 'Mthembu', '0745678901'),
('Jessica', 'Williams', '0756789012'),
('Grace', 'Ndlovu', '0831112222'),
('Bheki', 'Cele', '0832223333'),
('Sandy', 'van Tonder', '0833334444'),
('David', 'Naidoo', '0834445555'),
('Sarah', 'van der Merwe', '0835556654'),
('Tebogo', 'Mahlangu', '0836667777'),
('Johan', 'Botha', '0837778888'),
('Fatima', 'Patel', '0838889999'),
('Mpho', 'Phiri', '0839990034'),
('Kabelo', 'Modise', '0841142552'),
('Zanele', 'Khumalo', '0843243333'),
('Mandla', 'Hlatshwayo', '0846336464');


INSERT INTO Product (CategoryID, ProductName, UnitPrice, CostPrice, QuantityInStock, ReorderLevel, ExpiryDate) 
VALUES 
(4, 'Albany White Bread', 15.99, 14.50, 15, 10, '2026-09-16'),
(4, 'Albany Brown Bread', 13.99, 12.50, 13, 10, '2026-09-16'),
(4, 'Blue Ribbon White Bread', 14.99, 12.50, 10, 10, '2026-09-17'),
(4, 'Blue Ribbon Brown Bread', 12.99, 11.50, 11, 10, '2026-09-17'),
(2, 'Coca-Cola 2L', 23.99, 20.00, 32, 20, '2027-06-01'),
(2, 'Fanta Orange 2L', 21.99, 18.50, 30, 15, '2027-06-01'),
(1, 'Iwisa Super Maize Meal 2.5kg', 61.99, 52.00, 36, 15, '2027-01-01'),
(1, 'White Star Maize Meal 5kg', 114.99, 95.50, 21, 10, '2027-01-01'),
(1, 'Tastic Rice 2kg', 44.99, 35.00, 35, 15, '2028-01-01'),
(10, 'Rhodes Baked Beans 410g', 19.50, 14.00, 39, 25, '2028-05-01'),
(10, 'Lucky Star Tuna 400g', 24.99, 19.00, 45, 25, '2028-03-01'),
(3, 'NikNaks Cheese 150g', 16.00, 11.50, 50, 20, '2027-02-01'),
(3, 'Simba Smoked Beef 120g', 19.99, 14.00, 28, 20, '2027-02-01'),
(3, 'Lays Salt & Vinegar 120g', 21.99, 15.50, 33, 20, '2027-02-01'),
(6, 'Sunlight Dishwashing Liquid 750ml', 34.99, 27.00, 19, 10, NULL),
(6, 'Omo Auto Washing Powder 2kg', 94.99, 75.00, 20, 8, NULL),
(6, 'Domestos Thick Bleach 750ml', 39.99, 30.00, 17, 8, NULL),
(9, 'Clover Fresh Milk 2L', 36.00, 29.00, 18, 12, '2026-09-20'),
(9, 'Inkomazi Full Cream Maas 2L', 32.99, 27.00, 12, 10, '2026-09-25'),
(9, 'Rama Original Margarine 500g', 34.99, 25.00, 24, 10, '2027-01-15'),
(5, 'Colgate Triple Action Toothpaste', 23.99, 17.00, 34, 15, NULL),
(5, 'Lifebuoy Hygiene Soap', 14.99, 10.50, 43, 20, NULL),
(5, 'Shield Roll-on Men', 31.99, 22.00, 25, 10, NULL),
(8, 'Beacon Allsorts 150g', 29.99, 20.00, 19, 10, '2027-08-01'),
(8, 'Chappies Bubblegum 100s', 53.99, 40.00, 15, 5, '2028-01-01'),
(8, 'Cadbury Dairy Milk 80g', 23.99, 17.50, 32, 15, '2027-11-01'),
(7, 'Vodacom R30 Airtime', 30.00, 27.50, 98, 30, NULL),
(7, 'MTN R30 Airtime', 30.00, 27.50, 89, 30, NULL),
(7, 'Cell C R30 Airtime', 30.00, 27.50, 83, 30, NULL),
(1, 'Huletts White Sugar 2.5kg', 64.99, 55.00, 35, 15, NULL),
(1, 'Huletts Brown Sugar 2kg', 54.99, 45.00, 20, 15, NULL),
(1, 'Huletts White Sugar 1kg', 33.99, 25.00, 24, 15, NULL),
(1, 'Huletts Brown Sugar 1kg', 29.99, 22.00, 28, 15, NULL),
(1, 'Huletts White Sugar 500g', 19.99, 14.00, 31, 15, NULL),
(1, 'Huletts Brown Sugar 500g', 17.99, 13.00, 22, 15, NULL),
(2, 'Five Roses Tea 100s', 51.99, 39.00, 25, 10, '2028-06-01'),
(2, 'Nescafe Ricoffy 500g', 94.99, 55.00, 24, 10, '2028-02-01');

INSERT INTO Purchase (SupplierID, PurchaseDate) 
VALUES 
(2, '2026-09-03 14:22:00'),
(3, '2026-08-26 09:15:00'),
(4, '2026-09-08 10:45:00'),
(1, '2026-08-28 16:30:00'),
(2, '2026-09-01 11:05:00'),
(1, '2026-09-09 08:20:00'),
(3, '2026-08-25 07:50:00'),
(2, '2026-09-05 13:10:00'),
(4, '2026-09-02 15:40:00'),
(1, '2026-09-07 12:25:00'),
(3, '2026-08-29 09:30:00'),
(2, '2026-09-04 14:15:00'),
(3, '2026-09-10 07:10:00'),
(2, '2026-08-31 16:55:00'),
(1, '2026-09-06 10:50:00');

INSERT INTO PurchaseItem (PurchaseID, ProductID, QuantityBought, UnitCost) 
VALUES 
(1, 9, 20, 35.00), (1, 10, 30, 14.00), (1, 11, 20, 19.00), 
(2, 1, 15, 14.50), (2, 2, 10, 12.50), (2, 7, 15, 52.00), (2, 8, 10, 95.50),  
(3, 27, 50, 27.50), (3, 28, 50, 27.50), (3, 29, 30, 27.50), 
(4, 12, 40, 11.50), (4, 13, 30, 14.00), (4, 14, 20, 15.50), (4, 25, 10, 40.00), 
(5, 15, 20, 27.00), (5, 16, 15, 75.00), (5, 21, 30, 17.00), (5, 22, 40, 10.50), 
(6, 30, 20, 55.00), (6, 32, 20, 25.00), (6, 36, 15, 39.00), (6, 37, 10, 55.00), 
(7, 3, 20, 12.50), (7, 4, 15, 11.50), (7, 1, 10, 14.50),  
(8, 5, 30, 20.00), (8, 6, 20, 18.50), (8, 18, 15, 29.00), (8, 20, 15, 25.00), 
(9, 27, 30, 27.50), (9, 28, 30, 27.50), 
(10, 17, 15, 30.00), (10, 23, 20, 22.00), (10, 24, 15, 20.00), (10, 26, 20, 17.50), 
(11, 1, 15, 14.50), (11, 3, 15, 12.50), (11, 19, 10, 27.00), 
(12, 9, 20, 35.00), (12, 31, 15, 45.00), (12, 34, 20, 14.00), 
(13, 1, 15, 14.50), (13, 2, 10, 12.50),  
(14, 16, 10, 75.00), (14, 10, 20, 14.00), 
(15, 14, 20, 15.50), (15, 12, 20, 11.50);

INSERT INTO Sale (CustomerID, EmployeeID, SaleDate, PaymentType) 
VALUES 
(1, 2, '2026-09-08 14:15:00', 'Card'),
(NULL, 3, '2026-08-26 09:30:00', 'Cash'),
(4, 2, '2026-09-02 18:45:00', 'Card'),
(NULL, 3, '2026-08-30 11:20:00', 'Cash'),
(8, 2, '2026-09-05 16:10:00', 'Card'),
(NULL, 2, '2026-09-01 07:55:00', 'Cash'),
(3, 3, '2026-09-09 13:40:00', 'Card'),
(NULL, 3, '2026-08-27 15:25:00', 'Cash'),
(6, 2, '2026-09-04 10:15:00', 'Card'),
(NULL, 3, '2026-09-07 12:05:00', 'Cash'),
(10, 2, '2026-08-28 17:30:00', 'Card'),
(NULL, 2, '2026-09-06 08:50:00', 'Cash'),
(1, 3, '2026-08-31 14:20:00', 'Card'),
(NULL, 3, '2026-09-03 11:10:00', 'Cash'),
(NULL, 2, '2026-09-10 09:15:00', 'Cash'),
(8, 3, '2026-08-29 16:40:00', 'Card'),
(NULL, 2, '2026-09-02 07:30:00', 'Cash'),
(3, 3, '2026-09-08 12:55:00', 'Card'),
(NULL, 2, '2026-08-25 10:45:00', 'Cash'),
(12, 3, '2026-09-05 18:20:00', 'Card'),
(NULL, 2, '2026-09-01 15:10:00', 'Cash'),
(NULL, 3, '2026-09-07 08:35:00', 'Card'),
(4, 2, '2026-08-26 13:25:00', 'Card'),
(NULL, 3, '2026-09-04 17:00:00', 'Cash'),
(1, 2, '2026-08-28 09:15:00', 'Card'),
(NULL, 3, '2026-09-09 11:50:00', 'Cash'),
(8, 2, '2026-09-03 16:30:00', 'Card'),
(NULL, 2, '2026-08-27 08:10:00', 'Cash'),
(10, 3, '2026-09-06 14:45:00', 'Card'),
(NULL, 2, '2026-08-31 10:20:00', 'Cash');
GO

INSERT INTO SaleItem (SaleID, ProductID, QuantitySold, UnitPriceAtSale) 
VALUES 
(1, 1, 2, 15.99), (1, 18, 1, 36.00),
(2, 5, 1, 23.99), (2, 12, 2, 16.00),
(3, 8, 1, 114.99), (3, 30, 1, 64.99),
(4, 27, 1, 30.00),
(5, 16, 1, 94.99), (5, 17, 1, 39.99),
(6, 2, 1, 13.99), (6, 19, 1, 32.99),
(7, 37, 1, 94.99), (7, 36, 1, 51.99),
(8, 25, 1, 53.99),
(9, 10, 2, 19.50), (9, 11, 1, 24.99),
(10, 3, 2, 14.99),
(11, 21, 1, 23.99), (11, 22, 2, 14.99),
(12, 5, 2, 23.99), (12, 14, 1, 21.99),
(13, 7, 1, 61.99), (13, 20, 1, 34.99),
(14, 15, 1, 34.99), (14, 22, 1, 14.99),
(15, 28, 2, 30.00),
(16, 9, 1, 44.99), (16, 11, 2, 24.99),
(17, 4, 1, 12.99), (17, 18, 1, 36.00),
(18, 1, 2, 15.99),
(19, 31, 1, 54.99), (19, 36, 1, 51.99),
(20, 13, 2, 19.99),
(21, 26, 2, 23.99),
(22, 6, 1, 21.99),
(23, 34, 1, 19.99), (23, 36, 1, 51.99),
(24, 24, 1, 29.99),
(25, 29, 1, 30.00),
(26, 8, 1, 114.99), (26, 9, 1, 44.99),
(27, 10, 3, 19.50),
(28, 23, 1, 31.99),
(29, 32, 1, 33.99),
(30, 1, 1, 15.99), (30, 20, 1, 34.99);

INSERT INTO InventoryAdjustments (ProductID, EmployeeID, AdjustmentDate, QuantityAdjusted, Reason) 
VALUES 
(18, 1, '2026-09-02 08:30:00', -1, 'Spoiled milk'),
(5, 4, '2026-08-25 10:15:00', -1, 'Bottle dropped and broken'),
(12, 4, '2026-09-08 11:30:00', 2, 'Found extra during stocktake'),
(1, 1, '2026-08-27 18:00:00', -2, 'Expired - Thrown away'),
(2, 1, '2026-09-09 18:15:00', -3, 'Expired - Thrown away'),
(15, 4, '2026-09-01 16:45:00', -1, 'Leaking bottle - damaged'),
(26, 1, '2026-08-30 17:00:00', -2, 'Theft at till point'),
(10, 4, '2026-09-06 14:00:00', -1, 'Dented can'),
(19, 1, '2026-09-04 07:10:00', -1, 'Spoiled'),
(30, 4, '2026-09-07 15:00:00', -1, 'Packet broke in storeroom'),
(7, 4, '2026-09-05 09:20:00', 1, 'Found extra during stocktake');
GO


---------------------------------------------------------------------------------

-- Created this view to automatically calculate Sale Totals
CREATE VIEW vw_SaleSummary AS
SELECT
    s.SaleID,
    s.SaleDate,
    s.PaymentType,
    c.FirstName + ' ' + c.LastName AS CustomerName,
    e.FirstName AS CashierName,
    SUM (si.QuantitySold * si.UnitPriceAtSale) AS TotalSaleAmount
FROM Sale s
LEFT JOIN Customer c ON s.CustomerID = c.CustomerID
JOIN Employee e ON s.EmployeeID = e.EmployeeID
JOIN SaleItem si ON s.SaleID = si.SaleID
GROUP BY s.SaleID, s.SaleDate, s.PaymentType, c.FirstName, c.LastName, e.FirstName;
GO

-- Created this view to automatically calculate Purchase Totals
CREATE VIEW vw_PurchaseSummary AS
SELECT
    p.PurchaseID,
    p.PurchaseDate,
    sup.SupplierName,
    SUM(pi.QuantityBought * pi.UnitCost) AS TotalPurchaseAmount
FROM Purchase p
JOIN Supplier sup ON p.SupplierID = sup.SupplierID
JOIN PurchaseItem pi ON p.PurchaseID = pi.PurchaseID
GROUP BY p.PurchaseID, p.PurchaseDate, sup.SupplierName;
GO

----------------------------------------------------------------
		        -- STORED PROCEDURES --
-----------------------------------------------------------------
---- SP for creating a new sale

CREATE PROCEDURE sp_AddNewSale
(
    @CustomerID INT = NULL,
    @EmployeeID INT,
    @PaymentType VARCHAR(30),
    @ProductID INT,
    @QuantitySold INT
)
AS
BEGIN

    BEGIN TRY

        BEGIN TRANSACTION;

        DECLARE @SaleID INT;
        DECLARE @UnitPrice DECIMAL(10,2);
        DECLARE @TotalAmount DECIMAL(10,2);


        -- Get current product price
        SELECT @UnitPrice = UnitPrice
        FROM Product
        WHERE ProductID = @ProductID;


        -- Check stock availability
        IF (SELECT QuantityInStock FROM Product WHERE ProductID = @ProductID) < @QuantitySold
        BEGIN
            THROW 50001, 'Not enough stock available', 1;
        END;


        -- Calculate total
        SET @TotalAmount = @UnitPrice * @QuantitySold;


        -- Insert sale
        INSERT INTO Sale
        (
            CustomerID,
            EmployeeID,
            PaymentType,
            TotalAmount
        )
        VALUES
        (
            @CustomerID,
            @EmployeeID,
            @PaymentType,
            @TotalAmount
        );


        SET @SaleID = SCOPE_IDENTITY();


        -- Insert sale item
        INSERT INTO SaleItem
        (
            SaleID,
            ProductID,
            QuantitySold,
            UnitPriceAtSale
        )
        VALUES
        (
            @SaleID,
            @ProductID,
            @QuantitySold,
            @UnitPrice
        );


        -- Update stock
        UPDATE Product
        SET QuantityInStock = QuantityInStock - @QuantitySold
        WHERE ProductID = @ProductID;


        COMMIT TRANSACTION;


        PRINT 'Sale added successfully';


    END TRY

    BEGIN CATCH

        ROLLBACK TRANSACTION;

        THROW;

    END CATCH

END;
GO

--- SP to update stock after purchases

CREATE PROCEDURE sp_UpdateStockAfterPurchase
(
    @ProductID INT,
    @QuantityPurchased INT
)
AS
BEGIN

    BEGIN TRY

        BEGIN TRANSACTION;


        -- Check that the product exists
        IF NOT EXISTS 
        (
            SELECT 1 
            FROM Product 
            WHERE ProductID = @ProductID
        )
        BEGIN
            THROW 50002, 'Product does not exist', 1;
        END;


        -- Check quantity is valid
        IF @QuantityPurchased <= 0
        BEGIN
            THROW 50003, 'Purchase quantity must be greater than zero', 1;
        END;


        -- Increase stock
        UPDATE Product
        SET QuantityInStock = QuantityInStock + @QuantityPurchased
        WHERE ProductID = @ProductID;


        COMMIT TRANSACTION;


        PRINT 'Stock updated successfully';


    END TRY


    BEGIN CATCH

        ROLLBACK TRANSACTION;

        THROW;

    END CATCH

END;
GO

-- SP to search productss

CREATE PROCEDURE sp_SearchProducts
(
    @SearchTerm VARCHAR(100) = NULL
)
AS
BEGIN

    BEGIN TRY

        SELECT
            P.ProductID,
            P.ProductName,
            C.CategoryName,
            P.UnitPrice,
            P.QuantityInStock,
            P.ReorderLevel,
            P.ExpiryDate
        FROM Product P
        INNER JOIN Category C
            ON P.CategoryID = C.CategoryID
        WHERE 
            @SearchTerm IS NULL
            OR P.ProductName LIKE '%' + @SearchTerm + '%'
            OR C.CategoryName LIKE '%' + @SearchTerm + '%';

    END TRY

    BEGIN CATCH

        THROW;

    END CATCH

END;
GO


-----------------------------------------------------------------
		-- DATABASE BACKUP (DON'T RUN)
-----------------------------------------------------------------
CREATE BACKUP spazaDB
TO DISK = 'C:\backups\spazadb.bak',
WITH FORMAT, -- overwrites any existing backups and creates a clean new backup
GO

-- RESTORE DATABASE (IF NEEDED)
-- Force existing connections to close
ALTER DATABASE spazaDB SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
GO

ALTER DATABASE spazaDB
FROM DISK 'C:\backups\spazadb.bak'
WITH REPLACE -- overwrites the existing database

-- set back to multi-user mode
ALTER DATABASE spazaDB SET MULTI_USER;
GO
