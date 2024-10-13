-- Set the database context
USE AdventureWorks2008R2;


-- Que 1
USE AdventureWorks2008R2;

WITH YearlyTotalCustomers AS (
    SELECT
        SalesOH.CustomerID,
        YEAR(SalesOH.OrderDate) AS Year,
        MAX(SalesOH.TotalDue) AS TotalSales,
        SUM(SalesOH.TotalDue) AS TotalAmount
        
    FROM
        Sales.SalesOrderHeader SalesOH
    GROUP BY
        SalesOH.CustomerID, YEAR(SalesOH.OrderDate)
),
CustomerRanking AS (
    SELECT
        tc.CustomerID,
        tc.Year,
        tc.TotalAmount,
        tc.TotalSales,
        RANK() OVER (PARTITION BY tc.Year ORDER BY tc.TotalAmount DESC) AS Rank
    FROM
        YearlyTotalCustomers tc
),
DistinctCount AS (
    SELECT
        SalesOH.CustomerID,
        YEAR(SalesOH.OrderDate) AS Year,
        COUNT(DISTINCT SalesOD.ProductID) AS UniqueCount
    FROM
        Sales.SalesOrderDetail SalesOD
    JOIN
        Sales.SalesOrderHeader SalesOH ON SalesOD.SalesOrderID = SalesOH.SalesOrderID
    GROUP BY
        SalesOH.CustomerID, YEAR(SalesOH.OrderDate)
),
CustName AS (
    SELECT
        customer.CustomerID,
        per.LastName
    FROM
        Sales.Customer customer
    JOIN
        Person.Person per ON customer.PersonID = per.BusinessEntityID
),
CustomerDetails AS (
    SELECT
        cr.CustomerID,
        cr.Year,
        cn.LastName AS CustomerLastName,
        dc.UniqueCount,
        FORMAT((cr.TotalSales / cr.TotalAmount * 100), 'N2') AS PerOfTotal,
        cr.Rank
    FROM
        CustomerRanking cr
    JOIN
        DistinctCount dc ON cr.CustomerID = dc.CustomerID AND cr.Year = dc.Year
    JOIN
        CustName cn ON cr.CustomerID = cn.CustomerID
    WHERE
        cr.Rank <= 2 AND dc.UniqueCount > 55
),
CustomersPivot AS (
    SELECT
        Year,
        [1] AS Customer1,
        [2] AS Customer2
    FROM
        (SELECT Year, Rank, CONCAT(CustomerID, ' ', CustomerLastName, ' ', UniqueCount, ' Unique Products ', PerOfTotal, '%') AS CustomerInfo FROM CustomerDetails) AS SourceTable
    PIVOT
    (
        MAX(CustomerInfo)
        FOR Rank IN ([1], [2])
    ) AS PivotTable
)
SELECT
    Year,
    CONCAT(
        ISNULL(Customer1, 'No data'), 
        ', ', 
        ISNULL(Customer2, 'No data')
    ) AS Top2Customers
FROM
    CustomersPivot
ORDER BY Year;

-- Que 2

CREATE DATABASE Quiz2_Payal;

USE Quiz2_Payal;

create table department
(departmentid int primary key,
departmentname varchar(50) not null,
description varchar(1000));


create table faculty
(facultyid int primary key,
facultylastname varchar(50) not null,
facultyfirstname varchar(50) not null,
departmentid int not null references department(departmentid));


create table classroom
(classroomid int primary key,
building varchar(20) not null,
capacity smallint not null);


create table class
(classid varchar(20) primary key,
status varchar(10) not null, -- For simplicity, either Active or Inactive
description varchar(100),
semester varchar(20) not null,
departmentid int not null references department(departmentid),
facultyid int not null references faculty(facultyid),
credit tinyint not null,
classroomid int not null references classroom(classroomid));


create table student
(studentid int primary key,
studentlastname varchar(50) not null,
studentfirstname varchar(50) not null,
departmentid int not null references department(departmentid),
gpa decimal(3,2) not null);



create table enrollment
(classid varchar(20) references class(classid),
studentid int not null references student(studentid),
semester varchar(20) not null,
status varchar(10) not null -- For simplicity, either active or complete
primary key (classid, studentid, semester));



create table audittrail
(audittrailid int identity primary key,
departmentid int not null references department(departmentid),
classid varchar(20) not null references class (classid),
timing datetime not null default getdate());



CREATE TRIGGER WangInstituteRules
ON enrollment
AFTER INSERT
AS
BEGIN
    -- Checking rule 1: A class cannot have more than 100 students
    IF EXISTS (
        SELECT classid
        FROM inserted i
        GROUP BY classid
        HAVING COUNT(*) > 100
    )
    BEGIN
        INSERT INTO audittrail (departmentid, classid, timing)
        SELECT c.departmentid, i.classid, GETDATE()
        FROM inserted i
        INNER JOIN class c ON i.classid = c.classid
        WHERE EXISTS (
            SELECT classid
            FROM inserted
            WHERE classid = i.classid
            GROUP BY classid
            HAVING COUNT(*) > 100
        )
    END

    -- Check rule 2: A department cannot have more than 20 registered classes
    IF EXISTS (
        SELECT departmentid
        FROM (
            SELECT ei.semester, c.departmentid, COUNT(DISTINCT ei.classid) AS numberofclasses
            FROM inserted ei
            INNER JOIN class c ON ei.classid = c.classid
            GROUP BY ei.semester, c.departmentid
        ) AS classes_in_dept
        WHERE numberofclasses > 20
    )
    BEGIN
        INSERT INTO audittrail (departmentid, classid, timing)
        SELECT classes_in_dept.departmentid, NULL, GETDATE()
        FROM (
            SELECT ei.semester, c.departmentid, COUNT(DISTINCT ei.classid) AS numberofclasses
            FROM inserted ei
            INNER JOIN class c ON ei.classid = c.classid
            GROUP BY ei.semester, c.departmentid
        ) AS classes_in_dept
        WHERE numberofclasses > 20
    END
END;


SELECT * FROM sys.triggers WHERE name = 'WangInstituteRules';


-- Insert some sample data into the department table

INSERT INTO department (departmentid, departmentname, description)
VALUES
    (101, 'Physics', 'Physics Dept'),
    (102, 'Mathematics', 'Math Dept');


select * from department;