--Create a database
CREATE DATABASE "DAMG_Lab4_Payal";

--Set the database context
USE "DAMG_Lab4_Payal";

CREATE TABLE dbo.Person
(
    PersonID INT IDENTITY NOT NULL PRIMARY KEY,
    LastName VARCHAR(40) NOT NULL,
    FirstName VARCHAR(40) NOT NULL,
    DateOfBirth DATE NOT NULL
);

CREATE TABLE dbo.Speciality
(
    SpecialityID INT IDENTITY NOT NULL PRIMARY KEY,
    Name VARCHAR(40) NOT NULL,
    Description TEXT
);

CREATE TABLE dbo.Organization
(
    OrganizationID INT IDENTITY NOT NULL PRIMARY KEY,
    Name VARCHAR(40) NOT NULL,
    MainPhone VARCHAR(12) NOT NULL
);

CREATE TABLE dbo.Volunterring
(
    VolunterringID INT IDENTITY NOT NULL PRIMARY KEY,
    PersonID INT NOT NULL REFERENCES dbo.Person(PersonID),
    OrganizationID INT NOT NULL REFERENCES dbo.Organization(OrganizationID),
    SpecialityID INT NOT NULL REFERENCES dbo.Speciality(SpecialityID)
);



-- Set the database context
USE AdventureWorks2008R2;


-- Part B-1

WITH YearlySales AS (
    SELECT 
        YEAR(OrderDate) AS OrderYear,
        CustomerID,
        -- Cast the Sum of TotalPurchase as an integer
        CAST(SUM(TotalDue) AS INT) AS TotalPurchase   
    FROM 
        Sales.SalesOrderHeader
    GROUP BY 
    -- Take the OrderDate and extract the year
    -- Group the data by year and customer ID
        YEAR(OrderDate),
        CustomerID
),
RankedCustomers AS (
    SELECT 
        OrderYear,
        CustomerID,
        TotalPurchase,
        -- generate a sequential number for each row, starting from 1 for the first row in the result set
        ROW_NUMBER() OVER (PARTITION BY OrderYear ORDER BY TotalPurchase DESC) AS Rank
    FROM 
        YearlySales
)
SELECT 
    RC.OrderYear AS Year,
    SUM(RC.TotalPurchase) AS TotalSale,
    -- Combining the top 3 customerlDs separated by ", "
    STRING_AGG(RC.CustomerID, ', ') AS Top3Customers
FROM 
    RankedCustomers RC
WHERE 
-- Reduce the number of results to just the top 3 customers for each year
    RC.Rank <= 3
GROUP BY 
-- Group the results by year
    RC.OrderYear
ORDER BY 
-- Order the results by year
    RC.OrderYear;


-- Part B-2

WITH OrderQuantities AS (
    SELECT 
        SOH.SalesPersonID,
        SOH.SalesOrderID,
        SUM(SOD.OrderQty) AS TotalSoldQuantity,
        SOH.TotalDue
    FROM Sales.SalesOrderHeader SOH
    INNER JOIN Sales.SalesOrderDetail SOD ON SOH.SalesOrderID = SOD.SalesOrderID
    WHERE SOH.SalesPersonID IS NOT NULL
    GROUP BY SOH.SalesPersonID, SOH.SalesOrderID, SOH.TotalDue
),
RankedOrders AS (
    SELECT *,
        ROW_NUMBER() OVER (PARTITION BY SalesPersonID ORDER BY TotalDue ASC) AS ValueRank,
        ROW_NUMBER() OVER (PARTITION BY SalesPersonID ORDER BY TotalSoldQuantity ASC) AS QuantityRank
    FROM OrderQuantities
),
LowestQuantityTbl AS (
    SELECT SalesPersonID, MIN(TotalSoldQuantity) AS LowestQuantity
    FROM RankedOrders
    WHERE QuantityRank = 1
    GROUP BY SalesPersonID
),
Lowest3ValuesTbl AS (
    SELECT 
        SalesPersonID,
        STUFF((
            SELECT TOP 3 ', ' + CAST(TotalDue AS VARCHAR(10))
            FROM RankedOrders
            WHERE RankedOrders.SalesPersonID = OrderQtys.SalesPersonID
            ORDER BY TotalDue
            FOR XML PATH(''), TYPE
        ).value('.', 'NVARCHAR(MAX)'), 1, 2, '') AS Lowest3ValuesString
    FROM OrderQuantities OrderQtys
    GROUP BY SalesPersonID
)
SELECT 
    LQ.SalesPersonID,
    COUNT(DISTINCT RO.SalesOrderID) AS TotalOrderCount,
    LQ.LowestQuantity,
    L3V.Lowest3ValuesString AS Lowest3Values
FROM RankedOrders RO
JOIN LowestQuantityTbl LQ ON RO.SalesPersonID = LQ.SalesPersonID
JOIN Lowest3ValuesTbl L3V ON RO.SalesPersonID = L3V.SalesPersonID
GROUP BY LQ.SalesPersonID, LQ.LowestQuantity, L3V.Lowest3ValuesString
ORDER BY LQ.SalesPersonID;


-- Part C

WITH Parts(AssemblyID, ComponentID, PerAssemblyQty, EndDate, ComponentLevel) AS
(
    SELECT
        b.ProductAssemblyID,
        b.ComponentID,
        b.PerAssemblyQty,
        b.EndDate,
        0 AS ComponentLevel
    FROM Production.BillOfMaterials AS b
    WHERE b.ProductAssemblyID = 992 
        AND b.EndDate IS NULL
        AND (
            SELECT ListPrice
            FROM Production.Product AS pr
            WHERE pr.ProductID = b.ComponentID
        ) > 0  -- Filter out components with list price of 0
    UNION ALL
    SELECT
        bom.ProductAssemblyID,
        bom.ComponentID,
        bom.PerAssemblyQty,
        bom.EndDate,
        ComponentLevel + 1
    FROM Production.BillOfMaterials AS bom
    INNER JOIN Parts AS p
        ON bom.ProductAssemblyID = p.ComponentID AND bom.EndDate IS NULL
)
SELECT
    AssemblyID,
    ComponentID,
    Name,
    PerAssemblyQty,
    ComponentLevel,
    MAX(pr.ListPrice) AS MostExpensivePrice  -- Select max list price 
FROM Parts AS p
INNER JOIN Production.Product AS pr
    ON p.ComponentID = pr.ProductID
WHERE p.AssemblyID = 992     -- Filter only rows related to Product 992
GROUP BY p.AssemblyID, p.ComponentID, pr.Name, p.PerAssemblyQty, p.ComponentLevel
ORDER BY ComponentLevel, AssemblyID, ComponentID;  -- Sort the data by component level
