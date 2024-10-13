-- Set the database context
USE AdventureWorks2008R2; 

-- Que 2
WITH QuarterlySales AS (
    SELECT 
        YEAR(soh.OrderDate) AS "Year",
        DATEPART(QUARTER, soh.OrderDate) AS "Quarter",
        SUM(sod.UnitPrice * sod.OrderQty) AS "TotalSales"
    FROM Sales.SalesOrderHeader soh
    JOIN Sales.SalesOrderDetail sod ON soh.SalesOrderID = sod.SalesOrderID
    JOIN Production.Product p ON sod.ProductID = p.ProductID
    WHERE p.Color = 'Black' OR p.Color IS NULL
    GROUP BY YEAR(soh.OrderDate), DATEPART(QUARTER, soh.OrderDate)
)
SELECT 
    qt.Year,
    qt.Quarter,
    SUM(TotalSales) AS "TotalQuarterlySales",
    SUM(qt.TotalSales) AS "TotalProductSales"
FROM QuarterlySales qt
GROUP BY qt.Year, qt.Quarter
HAVING SUM(qt.TotalSales) > 4000000         --include total sales greater than 4000000
ORDER BY qt.Year, qt.Quarter;               --sort the data by year & quarter



-- Que 3
WITH TerritoryCustomer AS (
    SELECT T.TerritoryID,
    COUNT(DISTINCT C.CustomerID) AS CustomerCount
    FROM Sales.SalesTerritory T
    INNER JOIN Sales.Customer C ON T.TerritoryID = C.TerritoryID
    GROUP BY T.TerritoryID
    HAVING COUNT(DISTINCT C.CustomerID) > 3500
)

SELECT
    TC.TerritoryID,
    P.ProductID AS MostSoldProductID,
    O.SalesOrderID AS OrderIDWithHighestTotalQuantity,
    TC.CustomerCount AS TotalCustomers
FROM TerritoryCustomer TC
JOIN Sales.SalesOrderHeader O ON TC.TerritoryID = O.TerritoryID
JOIN Sales.SalesOrderDetail D ON O.SalesOrderID = D.SalesOrderID
JOIN Production.Product P ON D.ProductID = P.ProductID
WHERE D.OrderQty = (
        SELECT MAX(OrderQty)
        FROM Sales.SalesOrderDetail
        WHERE SalesOrderID = O.SalesOrderID
    )
ORDER BY TC.TerritoryID;   --sort the data based on territoryid
