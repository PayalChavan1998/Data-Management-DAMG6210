-- Set the database context
USE AdventureWorks2008R2;

-- Que 3.1
/* Modify the following query to add a column that identifies the
frequency of repeat customers and contains the following values
based on the number of orders:
'No Order' for count = 0
'One Time' for count = 1
'Regular' for count range of 2-5
'Often' for count range of 6-10
'Loyal' for count greater than 10
Give the new column an alias to make the report more readable.
*/

SELECT c.CustomerID, c.TerritoryID, FirstName, LastName,
    COUNT(o.SalesOrderid) [Total Orders],
-- Use "CASE" to create new columns values based on the no. of orders from SalesOrderHeader table
    CASE
    WHEN COUNT(o.SalesOrderid) = 0 THEN 'No Order'
    WHEN COUNT(o.SalesOrderid) = 1 THEN 'One Time'
    WHEN COUNT(o.SalesOrderid) BETWEEN 2 AND 5 THEN 'Regular'
    WHEN COUNT(o.SalesOrderid) BETWEEN 6 AND 10 THEN 'Often'
    ELSE 'Loyal'
END AS CustomerFrequency -- Create new Column name "CustomerFrequency"
FROM Sales.Customer c
    JOIN Sales.SalesOrderHeader o
    ON c.CustomerID = o.CustomerID
    JOIN Person.Person p
    ON p.BusinessEntityID = c.PersonID
WHERE c.CustomerID > 25000                 
GROUP BY c.TerritoryID, c.CustomerID, FirstName, LastName;



-- Lab 3.2
/* Modify the following query to add a rank without gaps in the
ranking based on total orders in the descending order. Also
partition by territory.
*/

SELECT o.TerritoryID, s.Name, year(o.OrderDate) Year,
        COUNT(o.SalesOrderid) [Total Orders],
-- Use "Dense Rank" for adding a rank with no gaps 
-- Use "Partition By" clause on "TerritoryID" for the ranking to be performed within each partitioning value
-- Sort the no. of SalesOrder in Descending order
DENSE_RANK() OVER (PARTITION BY o.TerritoryID ORDER BY COUNT(o.SalesOrderid) DESC) AS Rank
FROM Sales.SalesTerritory s
JOIN Sales.SalesOrderHeader o
    ON s.TerritoryID = o.TerritoryID
GROUP BY o.TerritoryID, s.Name, year(o.OrderDate)
ORDER BY o.TerritoryID;



-- Lab 3.3
/* Write a query to retrieve the most valuable customer of each year.
The most valuable customer of a year is the customer who has
made the most purchase for the year. Use the yearly sum of the
TotalDue column in SalesOrderHeader as a customer's total purchase
for a year. If there is a tie for the most valuable customer,
your solution should retrieve it.
Include the customer's id, total purchase, and total order count
for the year. Display the total purchase as an integer using CAST.
Sort the returned data by the year.
*/


-- Retrieve the most valuable CustomerID of each year based on the TotalPurchase from SalesOrderHeader table
-- Find the rank and partition by on year, and sort by TotalPurchase in Descending oredr
SELECT CustomerID, TotalPurchase, TotalOrderCount, OrderYear
FROM(
    SELECT  soh.CustomerID, 
            CAST(SUM(soh.TotalDue) AS INT) AS TotalPurchase,
            COUNT(soh.SalesOrderID) AS TotalOrderCount, 
            YEAR(soh.OrderDate) AS OrderYear,
            RANK() OVER (PARTITION BY YEAR(soh.OrderDate) ORDER BY SUM(soh.TotalDue) DESC) AS Rank
    FROM Sales.SalesOrderHeader soh
    GROUP BY  YEAR(soh.OrderDate), soh.CustomerID
) As subQuery
WHERE Rank = 1
ORDER BY OrderYear;

-- Lab 3.4
/* Provide a unique list of customer id’s which have ordered both
the red and yellow products after May 1, 2008. Sort the list
by customer id.
*/

-- Find the distinct customer ids that have ordered both red and yellow products 
-- Choose OrderDate greater than '2008-05-01'
-- Sort the CustomerID in ascending order
SELECT soh.CustomerID
FROM Sales.SalesOrderHeader soh
  JOIN Sales.SalesOrderDetail sod
    ON soh.SalesOrderID = sod.SalesOrderID
  JOIN Production.Product p
    ON sod.ProductID = p.ProductID
WHERE p.Color IN ('Red', 'Yellow')
  AND soh.OrderDate > '2008-05-01'
GROUP BY CustomerID
  HAVING COUNT(DISTINCT p.Color) = 2
  ORDER BY soh.CustomerID



-- Lab 3.5
/*
Use the content of AdventureWorks2008R2, write a query that returns
the Territory which had the smallest difference between the total sold value
of the most sold product color and the total sold value of the least sold
product color. In the same query, also return the territory which had the
largest difference between the total sold value of the most sold product color
and the total sold value of the least sold product color. If there is a tie,
the tie must be returned. Exclude the sold products which didn't have a color
specified for this query.
The most sold product color had the highest total sold value. The least sold
product color had the lowest total sold value. Use UnitPrice * OrderQty to
calculate the total sold value. UnitPrice and OrderQty are in
Sales.SalesOrderDetail.
Include only the orders which had a total due greater than $65000 for
this query. Include the TerritoryID, highest total, lowest total,
and difference in the returned data. Format the numbers as an integer.
Sort the returned data by TerritoryID in asc.
*/

-- Find the total sold value for each territory, product color, and order
WITH TotalSold AS
(
  SELECT soh.TerritoryID, p.Color, soh.SalesOrderID, SUM(sod.UnitPrice * sod.OrderQty) AS "TotalSoldValue"
  FROM Sales.SalesOrderHeader soh
  JOIN Sales.SalesOrderDetail sod
    ON soh.SalesOrderID = sod.SalesOrderID
  JOIN Production.Product p
    ON sod.ProductID = p.ProductID
  WHERE soh.TotalDue > 65000
        AND p.Color IS NOT NULL
  GROUP BY soh.TerritoryID, p.Color, soh.SalesOrderID
),
-- Find the highest and lowest total sold value for each territory and product color
MinMaxSold AS
(
  SELECT TerritoryID, Color, MAX(TotalSoldValue) AS HighestTotal, MIN(TotalSoldValue) AS LowestTotal
  FROM TotalSold
  GROUP BY TerritoryID, Color
),
-- Find the highest and lowest total sold value for each territory
TerritoryMinMax AS
(
  SELECT TerritoryID, MAX(HighestTotal) AS TerritoryHighestTotal, MIN(LowestTotal) AS TerritoryLowestTotal
  FROM MinMaxSold
  GROUP BY TerritoryID
),
-- Find the difference between the highest and lowest total sold value for each territory
TerritoryDiff AS
(
  SELECT TerritoryID, TerritoryHighestTotal, TerritoryLowestTotal, TerritoryHighestTotal - TerritoryLowestTotal AS Difference
  FROM TerritoryMinMax
),
-- Find the minimum and maximum difference among all territories
MinMaxDiff AS
(
  SELECT MIN(Difference) AS MinDiff, MAX(Difference) AS MaxDiff
  FROM TerritoryDiff
)
-- Find the territories that have the smallest and largest difference
SELECT td.TerritoryID, CAST(td.TerritoryHighestTotal AS INT) AS HighestTotal, CAST(td.TerritoryLowestTotal AS INT) AS LowestTotal, CAST(td.Difference AS INT) AS Difference
FROM TerritoryDiff td
JOIN MinMaxDiff mmd
    ON td.Difference = mmd.MinDiff OR td.Difference = mmd.MaxDiff
ORDER BY td.TerritoryID;
