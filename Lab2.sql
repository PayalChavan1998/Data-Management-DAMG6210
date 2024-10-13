USE AdventureWorks2008R2;  -- Set the database context


--Que 2.1
/* Write a query to select the product id, name, list price,
and selling start date for the product(s) that have a list
price greater than the highest list price - $10.
Use the CAST function to display the date only for
the selling start date. Use an alias to make the report more
presentable if a column header is missing.
Sort the returned data by the selling start date.
Hint: a) You need to work with the Production.Product table.
b) You’ll need to use a simple subquery to get the highest
list price and use it in a WHERE clause.
c) The syntax for CAST is CAST(expression AS data_type),
where expression is the column name we want to format and
we can use DATE as data_type for this question to display
just the date. */
SELECT ProductID, Name, ListPrice, CAST (SellStartDate AS DATE) AS StartDate  -- Cast StartDate
FROM Production.Product AS p
WHERE ListPrice > 
   (
    SELECT MAX (ListPrice) - 10 
    FROM Production.Product p
    ) 
ORDER BY SellStartDate;  --Sort the StartDate


--Que 2.2
/* Retrieve the customer ID, most recent order date, and total number
of orders for each customer. Use a column alias to make the report
more presentable if a column header is missing.
Sort the returned data by the total number of orders in
the descending order.
Hint: You need to work with the Sales.SalesOrderHeader table. */
SELECT CustomerID, MAX(CAST (OrderDate AS DATE)) AS "Most Recent Order Date",  --Use the most recent order date
COUNT(*) AS "Total Orders"   
FROM Sales.SalesOrderHeader
GROUP BY CustomerID
ORDER BY "Total Orders" DESC;  --Sort the TotalOrders in Descending order

--Que 2.3
/* Write a query to calculate the "orders to customer ratio"
(number of orders / unique customers) for each sales territory.
Return only the sales territories which have a ratio >= 5.
Include the Territory ID and Territory Name in the returned data.
Sort the returned data by TerritoryID.*/

SELECT
    ST.TerritoryID,
    ST.Name AS TerritoryName,
    COUNT(*) / COUNT(DISTINCT SOH.CustomerID) AS "Order to Customer Ratio"  --select unique CustomerID
FROM
    Sales.SalesOrderHeader SOH
JOIN
    Sales.SalesTerritory ST
ON SOH.TerritoryID = ST.TerritoryID
GROUP BY
    ST.TerritoryID, ST.Name
HAVING
    COUNT(*) / COUNT(DISTINCT SOH.CustomerID) >= 5   --filter the ratio which is greater than 5
ORDER BY
    ST.TerritoryID;


-- Que 2.4
/* Write a query to create a report containing the customer id,
first name, last name and email address for all customers.
Make sure a customer is returned even if the names and/or
email address is missing.
Sort the returned data by CustomerID. Return only the customers
who have a customer id between 25000 and 27000. */

SELECT       
-- Coalesce function is used to handle the Null values
    C.CustomerID,
    COALESCE(P.FirstName, 'N/A') AS FirstName,   -- replace the firstname with NA(not available) if null
    COALESCE(P.LastName, 'N/A') AS LastName,     -- replace the lastname with NA(not available) if null
    COALESCE(E.EmailAddress, 'N/A') AS EmailAddress  -- replace the emailaddress with NA(not available) if null
FROM
    Sales.Customer C
LEFT JOIN
    Person.Person P ON C.PersonID = P.BusinessEntityID
LEFT JOIN 
    Person.EmailAddress E ON E.BusinessEntityID = P.BusinessEntityID
WHERE 
    C.CustomerID BETWEEN 25000 AND 27000
ORDER BY C.CustomerID;  -- sort by CustomerID

-- Que 2.5
/* Write a query to retrieve the years in which there were orders
placed but no order worth more than $150000 was placed.
Use TotalDue in Sales.SalesOrderHeader as the order value.
Return the "year" and "total product quantity sold for the year"
columns. The order quantity column is in SalesOrderDetail.
Sort the returned data by the
"total product quantity sold for the year" column in desc. */

SELECT
    YEAR(SOH.OrderDate) AS "Year",
    SUM(SOD.OrderQty) AS "total product quantity sold for the year"
FROM Sales.SalesOrderHeader AS SOH
LEFT JOIN                                                          -- Use left join as we want to retrieve all the records from SalesOrderHeader
    Sales.SalesOrderDetail AS SOD ON SOH.SalesOrderID = SOD.SalesOrderID 
WHERE
    SOH.TotalDue < 150000
GROUP BY YEAR(SOH.OrderDate)
ORDER BY "total product quantity sold for the year" DESC;           --  Sort the order quantity in descending order


-- Que 2.6
/*
Using AdventureWorks2008R2, write a query to return the territory id
and total sales of orders on all new year days for each territory.
Please keep in mind it's one combined total sales per territory for
all new year days regardless of the year as reflected by the data
stored in the database. The database has several years' data.
Include only orders which contained at least a product in black and
more than 40 unique products when calculating the total sales.
Use TotalDue in SalesOrderHeader as an order's value when calculating
the total sales. Return the total sales as an integer. Sort the returned
data by the territory id in asc.
*/

WITH NewYearsOrders AS (           -- Select orders placed on New Year's Day
    SELECT
        SOH.TerritoryID,
        SOH.SalesOrderID,
        SOH.TotalDue
    FROM
        Sales.SalesOrderHeader SOH
    WHERE
        MONTH(SOH.OrderDate) = 1 AND DAY(SOH.OrderDate) = 1
),
OrdersWithBlackProducts AS (  -- Select orders with at least one product in black color
    SELECT DISTINCT
        NYO.SalesOrderID,
        NYO.TotalDue,
        NYO.TerritoryID
    FROM
        NewYearsOrders NYO
        JOIN Sales.SalesOrderDetail SOD ON NYO.SalesOrderID = SOD.SalesOrderID
        JOIN Production.Product P ON SOD.ProductID = P.ProductID
    WHERE
        P.Color = 'Black'
),
OrdersWithMoreThan40UniqueProducts AS (  -- Select orders with more than 40 unique products
    SELECT
        SalesOrderID,
        TotalDue,
        TerritoryID
    FROM
        OrdersWithBlackProducts
    WHERE
        SalesOrderID IN (
            SELECT
                SalesOrderID
            FROM
                Sales.SalesOrderDetail
            GROUP BY
                SalesOrderID
            HAVING
                COUNT(DISTINCT ProductID) > 40
        )
),
TotalSalesByTerritory AS (      -- Calculate total sales per territory
    SELECT
        TerritoryID,
        CAST(SUM(TotalDue) AS INT) AS TotalSales
    FROM
        OrdersWithMoreThan40UniqueProducts
    GROUP BY
        TerritoryID
)

SELECT
    TerritoryID,
    TotalSales
FROM
    TotalSalesByTerritory
ORDER BY
    TerritoryID;   --   sort by territory ID in ascending order
