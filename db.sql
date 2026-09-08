CREATE DATABASE spazaDB
go

CREATE TABLE Supplier (
    SupplierID     INT IDENTITY(1,1) PRIMARY KEY,
    SupplierName   NVARCHAR(100) NOT NULL,
    ContactNumber  NVARCHAR(20)  NULL,
    Address        NVARCHAR(200) NULL
);
GO
