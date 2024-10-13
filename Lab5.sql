-- Set the database context
USE AdventureWorks2008R2;

-- Que 5.1
/* Using the SQL PIVOT command, rewrite the following query to present the same data
in a horizontal format, as listed below. Please use AdventureWorks2008R2 for this
question. */

SELECT *
FROM (
    SELECT
        datepart(yy, OrderDate) AS "Year",
        CONCAT(SalesPersonID, ' ', FirstName, ' ', LastName) AS "SalesPerson",
        CAST(SUM(TotalDue) AS INT) AS "TotalSales"
    FROM Sales.SalesOrderHeader soh
    JOIN Person.Person p ON soh.SalesPersonID = p.BusinessEntityID
    WHERE YEAR(OrderDate) IN (2006, 2007)
        AND SalesPersonID BETWEEN 275 AND 278
    GROUP BY datepart(yy, OrderDate), SalesPersonID, FirstName, LastName
    HAVING SUM(TotalDue) > 1500000
) AS SourceData
-- Pivot query to present source data in a horizontal format
PIVOT (
    SUM(TotalSales)
    FOR SalesPerson IN ([275 Michael Blythe], [276 Linda Mitchell], [277 Jillian Carson], [278 Garrett Vargas])
) AS HorizontalPivotTable
ORDER BY Year;




-- Que 5.2
/* Using data from AdventureWorks2008R2, create a function that accepts
a customer id and returns the full name (last name + first name)
of the customer. */

-- Switch to database DAMG_Lab4_Payal
USE "DAMG_Lab4_Payal";

-- Create a table-valued function
CREATE FUNCTION dbo.GetCustomerFullName
(
    @CustomerID INT
)
RETURNS NVARCHAR(100)
AS
BEGIN
    DECLARE @FullName NVARCHAR(100);

    SELECT @FullName = LastName + ' ' + FirstName
    FROM Person.Person
    WHERE BusinessEntityID = @CustomerID;

    RETURN @FullName;
END;


-- Execute the new function
SELECT * 
FROM sys.objects 
WHERE type = 'FN' 
AND name = 'GetCustomerFullName';

select * from dbo.GetCustomerFullName(11000)


-- Que 5.3
/* Given the following tables, there is a university rule
preventing a student from enrolling in a new class if there is
an unpaid fine. Please write a table-level CHECK constraint
to implement the rule. */

-- Create a database
CREATE DATABASE "DAMG_Lab5_Payal";

-- Set the database context
USE "DAMG_Lab5_Payal";

-- Create tables: Course, Student, Enrollment, Fine
create table Course
(CourseID int primary key,
CourseName varchar(50),
InstructorID int,
AcademicYear int,
Semester smallint);


create table Student
(StudentID int primary key,
LastName varchar (50),
FirstName varchar (50),
Email varchar(30),
PhoneNumber varchar (20));


create table Enrollment
(CourseID int references Course(CourseID),
StudentID int references Student(StudentID),
RegisterDate date,
primary key (CourseID, StudentID));



create table Fine
(StudentID int references Student(StudentID),
IssueDate date,
Amount money,
PaidDate date
primary key (StudentID, IssueDate));


-- Create the function to check for unpaid fines
CREATE FUNCTION dbo.HasUnpaidFine(@StudentID INT)
RETURNS BIT
AS
BEGIN
    DECLARE @UnpaidFine BIT;
    -- Check if there are any unpaid fines for the student
    IF EXISTS (
        SELECT 1
        FROM Fine
        WHERE StudentID = @StudentID
        AND PaidDate IS NULL
    )
    BEGIN
        SET @UnpaidFine = 1; -- There are unpaid fines
    END
    ELSE
    BEGIN
        SET @UnpaidFine = 0; -- No unpaid fines
    END

    RETURN @UnpaidFine;
END;
GO

-- Add the CHECK constraint using the function
ALTER TABLE Enrollment
ADD CONSTRAINT CHK_UnpaidFine CHECK (dbo.HasUnpaidFine(StudentID) = 0);



-- Que 5.4
/* Given the following tables, there is a $4 shipping fee
for each ordered product. For example, if the order quantity is 4,
then the shipping fee is $16. If the order value is
greater than 600, then the shipping fee is $2 for each
ordered product.
Write a trigger to calculate the shipping fee for an order. Save
the shipping fee in the ShippingFee column of the SalesOrder table. */


create table Customer
(CustomerID int primary key,
LastName varchar(50),
FirstName varchar(50),
Membership varchar(10));


create table SalesOrder
(OrderID int primary key,
CustomerID int references Customer(CustomerID),
OrderDate date,
ShippingFee money,
Tax as OrderValue * 0.08,
OrderValue money);


create table OrderDetail
(OrderID int references SalesOrder(OrderID),
ProductID int,
Quantity int,
UnitPrice money
primary key(OrderID, ProductID));



-- Create a trigger to calculate and update the shipping fee
CREATE OR ALTER TRIGGER CalculateShippingFee
ON OrderDetail
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @OrderID INT;
    DECLARE @TotalQuantity INT;
    DECLARE @OrderValue MONEY;
    DECLARE @ShippingFee MONEY;


     -- Get the OrderID from the inserted or updated row
     -- Calculate the total quantity and total value for the order
    DECLARE orderDetailCursor CURSOR FOR
    SELECT OrderID, SUM(Quantity) AS TotalQuantity, SUM(UnitPrice * Quantity) AS OrderValue
    FROM inserted
    GROUP BY OrderID;

    OPEN orderDetailCursor;

    FETCH NEXT FROM orderDetailCursor INTO @OrderID, @TotalQuantity, @OrderValue;

    WHILE @@FETCH_STATUS = 0
    BEGIN
         -- Determine the shipping fee based on the total value
        IF @OrderValue <= 600
            SET @ShippingFee = @TotalQuantity * 4;   -- $4 per ordered product
        ELSE
            SET @ShippingFee = @TotalQuantity * 2;   -- $2 per ordered product

        -- Update the ShippingFee column in the SalesOrder table
        UPDATE SalesOrder
        SET ShippingFee = @ShippingFee
        WHERE OrderID = @OrderID;

        FETCH NEXT FROM orderDetailCursor INTO @OrderID, @TotalQuantity, @OrderValue;
    END;

    CLOSE orderDetailCursor;
    DEALLOCATE orderDetailCursor;
END;



-- Check if the trigger is executed
SELECT * FROM sys.triggers WHERE name = 'CalculateShippingFee';


-- Insert some sample data into the Customer table
INSERT INTO Customer (CustomerID, LastName, FirstName, Membership)
VALUES 
     (5, 'Smith', 'John', 'Gold'),     -- Sample customerid 5
     (6, 'Dale', 'Chris', 'Silver');   -- Sample customerid 6


-- Insert some sample data into the SalesOrder table
INSERT INTO SalesOrder (OrderID, CustomerID, OrderDate, ShippingFee, OrderValue)
VALUES
    (1, 5, '2023-01-01', NULL, NULL),  -- Sample order 1
    (2, 6, '2023-01-02', NULL, NULL);  -- Sample order 2


-- Insert some sample data into the OrderDetail table with valid OrderID values
INSERT INTO OrderDetail (OrderID, ProductID, Quantity, UnitPrice)
VALUES
    (1, 101, 2, 10.00), -- Sample order detail 1
    (2, 102, 3, 15.00); -- Sample order detail 2


-- Check if the trigger has been executed successfully by inspecting the SalesOrder table
SELECT * FROM SalesOrder;





