CREATE DATABASE spazaDB
GO

USE spazaDB
GO

CREATE TABLE Category (
    CategoryID INT IDENTITY(1,1) PRIMARY KEY,
    CategoryName VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE Supplier (
    SupplierID INT IDENTITY(1,1) PRIMARY KEY,
    SupplierName VARCHAR(100) NOT NULL,
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
    ContactNumber VARCHAR(20) NULL,
    CreditLimit DECIMAL(10,2) NOT NULL DEFAULT 0 CHECK (CreditLimit >= 0)
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

CREATE TABLE Purchase (
    PurchaseID INT IDENTITY(1,1) PRIMARY KEY,
    SupplierID INT NOT NULL,
    PurchaseDate DATETIME NOT NULL DEFAULT GETDATE(),
    TotalAmount DECIMAL(10,2) NOT NULL DEFAULT 0 CHECK (TotalAmount >= 0),
    CONSTRAINT FK_Purchase_Supplier FOREIGN KEY (SupplierID)    
        REFERENCES Supplier(SupplierID)
);

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

CREATE TABLE Sale (
    SaleID INT IDENTITY(1,1) PRIMARY KEY,
    CustomerID INT NULL,
    EmployeeID INT NOT NULL,
    SaleDate DATETIME NOT NULL DEFAULT GETDATE(),
    PaymentType VARCHAR(30) NOT NULL,
    TotalAmount DECIMAL(10,2) NOT NULL DEFAULT 0 CHECK (TotalAmount >= 0),
    CONSTRAINT FK_Sale_Customer FOREIGN KEY (CustomerID)
        REFERENCES Customer(CustomerID),
    CONSTRAINT FK_Sale_Employee FOREIGN KEY (EmployeeID)
        REFERENCES Employee(EmployeeID)
);

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


INSERT INTO Category (CategoryName)
VALUES
('Beverages'),
('Snacks'),
('Household'),
('Toiletries'),
('Canned Food');

INSERT INTO Supplier (SupplierName, ContactNumber, SupplierAddress)
VALUES
('Coca Cola Distributors', '0215551001', 'Cape Town'),
('Tiger Brands SA', '0115552002', 'Johannesburg'),
('Unilever South Africa', '0315553003', 'Durban'),
('Pioneer Foods', '0215554004', 'Paarl'),
('Local Wholesale Supplies', '0215555005', 'Bellville');

INSERT INTO Emplyee
(Firstname, LastName, EmplyeeRole, ContactNumber)
VALUES
('Thabo', 'Mokoena', 'Manager', '0821112233'),
('Sarah', 'Jacobs', 'Cashier', '0832223344'),
('Michael', 'Smith', 'Stock Clerk', '0843334455'),
('Lerato', 'Dlamini', 'Cashier', '0854445566'),
('Jason', 'Peters', 'Supervisor', '0865556677');


INSERT INTO Customer (FirstName, LastName, ContactNumber, CreditLimit)
VALUES 
('Sipho', 'Nkosi', '0712345678', 500.00),
('Nomsa', 'Dube', '0723456789', 0.00),
('Pieter', 'Van Wyk', '0734567890', 1000.00),
('Ayanda', 'Mthembu', '0745678901', 250.00),
('Jessica', 'Williams', '0756789012', 0.00);
