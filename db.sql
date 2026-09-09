CREATE DATABASE spazaDB
go

CREATE TABLE Category (
    CategoryID     INT IDENTITY(1,1) PRIMARY KEY,
    CategoryName   NVARCHAR(50) NOT NULL UNIQUE
);
GO



CREATE TABLE Supplier (
    SupplierID     INT IDENTITY(1,1) PRIMARY KEY,
    SupplierName   NVARCHAR(100) NOT NULL,
    ContactNumber  NVARCHAR(20)  NULL,
    Address        NVARCHAR(200) NULL
);
GO

CREATE TABLE Employee (
    EmployeeID     INT IDENTITY(1,1) PRIMARY KEY,
    FirstName      NVARCHAR(50) NOT NULL,
    LastName       NVARCHAR(50) NOT NULL,
    Role           NVARCHAR(30) NOT NULL,
    ContactNumber  NVARCHAR(20) NULL
);
GO

CREATE TABLE Customer (
    CustomerID     INT IDENTITY(1,1) PRIMARY KEY,
    FirstName      NVARCHAR(50) NOT NULL,
    LastName       NVARCHAR(50) NOT NULL,
    ContactNumber  NVARCHAR(20) NULL,
    CreditLimit    DECIMAL(10,2) NOT NULL DEFAULT 0 CHECK (CreditLimit >= 0)
);
GO
CREATE TABLE Product (
    ProductID        INT IDENTITY(1,1) PRIMARY KEY,
    CategoryID       INT NOT NULL,
    ProductName      NVARCHAR(100) NOT NULL,
    UnitPrice        DECIMAL(10,2) NOT NULL CHECK (UnitPrice >= 0),
    CostPrice        DECIMAL(10,2) NOT NULL CHECK (CostPrice >= 0),
    QuantityInStock  INT NOT NULL DEFAULT 0 CHECK (QuantityInStock >= 0),
    ReorderLevel     INT NOT NULL DEFAULT 0 CHECK (ReorderLevel >= 0),
    ExpiryDate       DATE NULL,
    CONSTRAINT FK_Product_Category FOREIGN KEY (CategoryID)
        REFERENCES Category (CategoryID)
);
GO
