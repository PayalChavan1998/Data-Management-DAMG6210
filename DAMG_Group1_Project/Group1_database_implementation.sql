USE Group1_FlightBookingSystem;



-- Table Creation and Data Insert--
-- Airline --
CREATE TABLE Airline(
	AirlineID INT IDENTITY(1,1) PRIMARY KEY,
	AirlineName VARCHAR(255) NOT NULL,
	ContactInfo VARCHAR(255) NOT NULL,
	Rating DECIMAL(3,2) CHECK (Rating >= 0 AND Rating <= 5)
);

INSERT INTO Airline (AirlineName, ContactInfo, Rating)
VALUES
('Delta Air Lines', 'contact@delta.com', 4.5),
('American Airlines', 'contact@american.com', 4.2),
('United Airlines', 'contact@united.com', 4.0),
('Lufthansa', 'contact@lufthansa.com', 4.7),
('Emirates', 'contact@emirates.com', 4.8),
('British Airways', 'contact@britishairways.com', 4.3),
('Air France', 'contact@airfrance.com', 4.1),
('Qatar Airways', 'contact@qatarairways.com', 4.9),
('Singapore Airlines', 'contact@singaporeair.com', 4.6),
('Cathay Pacific', 'contact@cathaypacific.com', 4.4);

-- Airplane --
CREATE TABLE Airplane(
	AirplaneID INT IDENTITY(1,1) PRIMARY KEY,
	AirlineID INT, 
	FOREIGN KEY (AirlineID) REFERENCES Airline (AirlineID), 
	Model VARCHAR(255) NOT NULL, 
	Capacity INT NOT NULL, 
	YearOfManufacture DATE NOT NULL, 
	LastMaintenanceDate DATE NOT NULL
); 

INSERT INTO Airplane (AirlineID, Model, Capacity, YearOfManufacture, LastMaintenanceDate)
VALUES
(1, 'Boeing 777', 300, '2020-01-01', '2023-06-15'),
(2, 'Airbus A320', 180, '2018-05-10', '2022-11-20'),
(3, 'Boeing 787', 250, '2019-03-20', '2023-09-30'),
(4, 'Airbus A350', 350, '2021-07-05', '2024-01-12'),
(5, 'Boeing 737', 200, '2017-12-12', '2022-08-25'),
(6, 'Airbus A380', 500, '2016-09-30', '2022-04-18'),
(7, 'Boeing 767', 250, '2019-11-18', '2023-12-05'),
(8, 'Airbus A330', 300, '2020-04-02', '2023-10-10'),
(9, 'Boeing 747', 400, '2018-08-25', '2022-06-30'),
(10, 'Airbus A319', 150, '2022-02-15', '2024-03-20');


-- Promotion --
CREATE TABLE Promotion (
	PromotionID INT IDENTITY(1,1) PRIMARY KEY,
	AirlineID INT, 
	FOREIGN KEY (AirlineID) REFERENCES Airline (AirlineID), 
	DiscountPrice DECIMAL(10,2) NOT NULL,
	StartDate DATETIME NOT NULL,
	EndDate DATETIME NOT NULL, 
	PromoCode VARCHAR(255) NOT NULL
);

INSERT INTO Promotion (AirlineID, DiscountPrice, StartDate, EndDate, PromoCode)
VALUES
(1, 100.00, '2024-04-01 00:00:00', '2024-04-30 23:59:59', 'SPRING100'),
(2, 75.50, '2024-05-05 00:00:00', '2024-05-31 23:59:59', 'SUMMER75'),
(3, 50.25, '2024-06-10 00:00:00', '2024-06-30 23:59:59', 'JUNE50'),
(4, 120.75, '2024-07-15 00:00:00', '2024-08-15 23:59:59', 'SUMMERDEAL'),
(5, 90.00, '2024-08-20 00:00:00', '2024-09-30 23:59:59', 'SEPTEMBER90'),
(6, 85.25, '2024-10-01 00:00:00', '2024-10-31 23:59:59', 'FALL85'),
(7, 110.50, '2024-11-05 00:00:00', '2024-11-30 23:59:59', 'NOVEMBERDEAL'),
(8, 95.75, '2024-12-01 00:00:00', '2025-01-15 23:59:59', 'WINTER95'),
(9, 70.00, '2025-02-01 00:00:00', '2025-02-28 23:59:59', 'FEBRUARY70'),
(10, 80.25, '2025-03-05 00:00:00', '2025-03-31 23:59:59', 'SPRINGBREAK80');

-- User --
CREATE TABLE [User](
	UserID INT IDENTITY(1,1) PRIMARY KEY,
	FirstName VARCHAR(255) NOT NULL, 
	LastName VARCHAR(255) NOT NULL,
	Email VARCHAR(255) NOT NULL,
	Password VARCHAR(255) NOT NULL,
	Phone VARCHAR(20) NOT NULL
);

INSERT INTO [User] (FirstName, LastName, Email, Password, Phone)
VALUES
('John', 'Doe', 'johndoe@example.com', 'akjdkasj122', '123-456-7890'),
('Jane', 'Smith', 'janesmith@example.com', 'hskhak8889', '234-567-8901'),
('Michael', 'Johnson', 'michaelj@example.com', 'shshdkf777', '345-678-9012'),
('Emily', 'Brown', 'emilybrown@example.com', 'akdsakjd222', '456-789-0123'),
('Daniel', 'Wilson', 'danielwilson@example.com', 'skfuhash836', '567-890-1234'),
('Jessica', 'Martinez', 'jessicam@example.com', 'fhakwjdoiqwj00', '678-901-2345'),
('David', 'Anderson', 'davida@example.com', 'adhkuayeyrge98273', '789-012-3456'),
('Sarah', 'Taylor', 'sarahtaylor@example.com', 'fahdwqiyeiw22', '890-123-4567'),
('Christopher', 'Thomas', 'christophert@example.com', 'akijwoireoi3947', '901-234-5678'),
('Amanda', 'Clark', 'amandaclark@example.com', 'qlwejwioqruor2434', '012-345-6789');


---Airport---
CREATE TABLE Airport (
    AirportID INT IDENTITY(1,1) PRIMARY KEY,
    AirportName VARCHAR(255) NOT NULL,
    City VARCHAR(100) NOT NULL,
    State VARCHAR(100) NOT NULL,
    Country VARCHAR(100) NOT NULL,
    Code VARCHAR(10) NOT NULL
);
INSERT INTO Airport (AirportName, City, State, Country, Code) VALUES
('Los Angeles International Airport', 'Los Angeles', 'CA', 'USA', 'LAX'),
('John F. Kennedy International Airport', 'New York', 'NY', 'USA', 'JFK'),
('Chicago O''Hare International Airport', 'Chicago', 'IL', 'USA', 'ORD'),
('San Francisco International Airport', 'San Francisco', 'CA', 'USA', 'SFO'),
('Seattle-Tacoma International Airport', 'Seattle', 'WA', 'USA', 'SEA'),
('Denver International Airport', 'Denver', 'CO', 'USA', 'DEN'),
('Hartsfield-Jackson Atlanta International Airport', 'Atlanta', 'GA', 'USA', 'ATL'),
('Dallas/Fort Worth International Airport', 'Dallas-Fort Worth', 'TX', 'USA', 'DFW'),
('Heathrow Airport', 'London', '', 'UK', 'LHR'),
('Charles de Gaulle Airport', 'Paris', '', 'France', 'CDG');

---Flight---
CREATE TABLE Flight (
    FlightID INT IDENTITY(1,1) PRIMARY KEY,
    AirlineID INT,  
    AirplaneID INT,  
    DepartureDateTime DATETIME NOT NULL,
    ArrivalDateTime DATETIME NOT NULL,
    AvailableSeats INT NOT NULL,
    Price DECIMAL(10, 2) NOT NULL,
    DepartureAirportID INT,
    ArrivalAirportID INT,
    FOREIGN KEY (AirlineID) REFERENCES Airline(AirlineID),
    FOREIGN KEY (AirplaneID) REFERENCES Airplane(AirplaneID),
    FOREIGN KEY (DepartureAirportID) REFERENCES Airport(AirportID),
    FOREIGN KEY (ArrivalAirportID) REFERENCES Airport(AirportID)
);
INSERT INTO Flight (AirlineID, AirplaneID, DepartureDateTime, ArrivalDateTime, AvailableSeats, Price, DepartureAirportID, ArrivalAirportID) VALUES
(1, 1, '2024-04-01 06:00', '2024-04-01 09:00', 180, 500, 1, 2),
(1, 2, '2024-04-02 09:30', '2024-04-02 12:30', 180, 450, 2, 3),
(2, 3, '2024-04-03 13:00', '2024-04-03 16:00', 250, 700, 3, 4),
(2, 4, '2024-04-04 16:30', '2024-04-04 19:30', 250, 650, 4, 5),
(3, 5, '2024-04-05 20:00', '2024-04-05 23:00', 300, 750, 5, 6),
(3, 6, '2024-04-06 23:30', '2024-04-07 02:30', 300, 800, 6, 7),
(4, 7, '2024-04-07 03:00', '2024-04-07 06:00', 350, 900, 7, 8),
(4, 8, '2024-04-08 06:30', '2024-04-08 09:30', 350, 850, 8, 9),
(5, 9, '2024-04-09 10:00', '2024-04-09 13:00', 400, 950, 9, 10),
(5, 10, '2024-04-10 13:30', '2024-04-10 16:30', 400, 1000, 10, 1);

---Seats---
CREATE TABLE Seats (
    SeatID INT IDENTITY(1,1) PRIMARY KEY,
    FlightID INT,
    SeatNumber VARCHAR(10) NOT NULL,
    IsBooked BIT NOT NULL,
    ClassType VARCHAR(50) NOT NULL,
    FOREIGN KEY (FlightID) REFERENCES Flight(FlightID),
    CONSTRAINT CHK_ClassType CHECK (ClassType IN ('Economy', 'Business', 'First'))
);
INSERT INTO Seats (FlightID, SeatNumber, IsBooked, ClassType) VALUES
(1, '1A', 0, 'First'),
(1, '1B', 1, 'Economy'),
(2, '2A', 0, 'Business'),
(2, '2B', 1, 'Economy'),
(3, '3A', 0, 'First'),
(3, '3B', 1, 'Economy'),
(4, '4A', 0, 'Business'),
(4, '4B', 1, 'Economy'),
(5, '5A', 0, 'First'),
(5, '5B', 1, 'Economy');

---FlightStatus---
CREATE TABLE FlightStatus (
    FlightStatusID INT IDENTITY(1,1) PRIMARY KEY,
    FlightID INT,
    Status VARCHAR(255) NOT NULL,
    StatusDateTime DATETIME NOT NULL,
    CONSTRAINT FK_FlightStatus_FlightID FOREIGN KEY (FlightID) REFERENCES Flight(FlightID)
);
INSERT INTO FlightStatus (FlightID, Status, StatusDateTime) VALUES
(1, 'On Time', '2024-04-01 05:00'),
(2, 'Delayed', '2024-04-02 08:45'),
(3, 'On Time', '2024-04-03 12:00'),
(4, 'Cancelled', '2024-04-04 15:30'),
(5, 'On Time', '2024-04-05 19:00'),
(6, 'Delayed', '2024-04-06 22:45'),
(7, 'On Time', '2024-04-07 02:00'),
(8, 'Cancelled', '2024-04-08 05:30'),
(9, 'On Time', '2024-04-09 09:00'),
(10, 'Delayed', '2024-04-10 12:45');


-- Booking --
CREATE TABLE Booking (
    BookingID INT PRIMARY KEY,
    UserID INT, 
    FlightID INT,  
    BookingDateTime DATETIME NOT NULL,
    Status VARCHAR(20) NOT NULL, 
    FOREIGN KEY (UserID) REFERENCES [User](UserID),
    FOREIGN KEY (FlightID) REFERENCES Flight(FlightID)
);

INSERT INTO Booking (BookingID, UserID, FlightID, BookingDateTime, Status)
VALUES
    (1, 1, 1, '2024-04-15 10:00:00', 'Confirmed'),
    (2, 2, 2, '2024-04-20 15:30:00', 'Confirmed'),
    (3, 3, 3, '2024-04-25 12:45:00', 'Confirmed'),
    (4, 4, 4, '2024-05-01 09:00:00', 'Confirmed'),
    (5, 5, 5, '2024-05-05 14:20:00', 'Canceled'),
    (6, 6, 6, '2024-05-10 11:10:00', 'Confirmed'),
    (7, 7, 7, '2024-05-15 08:30:00', 'Confirmed'),
    (8, 8, 8, '2024-05-20 16:00:00', 'Confirmed'),
    (9, 9, 9, '2024-05-25 13:15:00', 'Confirmed'),
    (10, 10, 10, '2024-06-01 10:45:00', 'Confirmed');
   
-- Passenger --
CREATE TABLE Passenger (
    PassengerID INT PRIMARY KEY,
    BookingID INT,  
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Birthdate DATE NOT NULL,
    Age AS DATEDIFF(YEAR, Birthdate, GETDATE()),  -- Calculated field (can be computed based on Birthdate)
    Gender CHAR(1) NOT NULL,  -- 'M' for Male, 'F' for Female, etc.
    FOREIGN KEY (BookingID) REFERENCES Booking(BookingID)
);

INSERT INTO Passenger (PassengerID, BookingID, FirstName, LastName, Birthdate, Gender)
VALUES
    (1, 1, 'John', 'Doe', '1990-05-15', 'M'),
    (2, 2, 'Jane', 'Smith', '1985-08-20', 'F'),
    (3, 3, 'David', 'Johnson', '1978-03-10', 'M'),
    (4, 4, 'Emily', 'Brown', '1995-11-25', 'F'),
    (5, 5, 'Michael', 'Wilson', '1982-06-08', 'M'),
    (6, 6, 'Sarah', 'Davis', '1998-09-12', 'F'),
    (7, 7, 'Chris', 'Anderson', '1970-12-03', 'M'),
    (8, 8, 'Laura', 'Martinez', '1987-04-18', 'F'),
    (9, 9, 'Kevin', 'Garcia', '1993-02-28', 'M'),
    (10, 10, 'Rachel', 'Taylor', '1989-07-07', 'F');
   

-- Ticket --
CREATE TABLE Ticket (
    TicketID INT PRIMARY KEY,
    BookingID INT,  
    PassengerID INT, 
    SeatNumber VARCHAR(10) NOT NULL,
    BoardingPassURL VARCHAR(255) NOT NULL,
    FOREIGN KEY (BookingID) REFERENCES Booking(BookingID),
    FOREIGN KEY (PassengerID) REFERENCES Passenger(PassengerID)
);

INSERT INTO Ticket (TicketID, BookingID, PassengerID, SeatNumber, BoardingPassURL)
VALUES
    (1, 1, 1, 'A1', 'https://flightbooking.com/boardingpass/1'),
    (2, 2, 2, 'B2', 'https://flightbooking.com/boardingpass/2'),
    (3, 3, 3, 'C3', 'https://flightbooking.com/boardingpass/3'),
    (4, 4, 4, 'D4', 'https://flightbooking.com/boardingpass/4'),
    (5, 5, 5, 'E5', 'https://flightbooking.com/boardingpass/5'),
    (6, 6, 6, 'F6', 'https://flightbooking.com/boardingpass/6'),
    (7, 7, 7, 'G7', 'https://flightbooking.com/boardingpass/7'),
    (8, 8, 8, 'H8', 'https://flightbooking.com/boardingpass/8'),
    (9, 9, 9, 'I9', 'https://flightbooking.com/boardingpass/9'),
    (10, 10, 10, 'J10', 'https://flightbooking.com/boardingpass/10');


-- Payment --
CREATE TABLE Payment (
    PaymentID INT PRIMARY KEY,
    BookingID INT,  
    Amount DECIMAL(10, 2) NOT NULL,
    PaymentDate DATETIME NOT NULL,
    PaymentMethod VARCHAR(50) NOT NULL,
    Status VARCHAR(20) NOT NULL,  -- e.g., 'Successful', 'Pending', 'Failed'
    FOREIGN KEY (BookingID) REFERENCES Booking(BookingID)
);

INSERT INTO Payment (PaymentID, BookingID, Amount, PaymentDate, PaymentMethod, Status)
VALUES
    (1, 1, 500.00, '2024-04-15 11:00:00', 'Credit Card', 'Successful'),
    (2, 2, 350.75, '2024-04-21 16:45:00', 'PayPal', 'Successful'),
    (3, 3, 600.25, '2024-04-26 13:30:00', 'Credit Card', 'Successful'),
    (4, 4, 800.00, '2024-05-02 10:30:00', 'Debit Card', 'Pending'),
    (5, 5, 400.50, '2024-05-06 09:15:00', 'PayPal', 'Failed'),
    (6, 6, 720.00, '2024-05-11 12:20:00', 'Credit Card', 'Successful'),
    (7, 7, 550.00, '2024-05-16 08:45:00', 'Debit Card', 'Successful'),
    (8, 8, 670.25, '2024-05-21 17:00:00', 'Credit Card', 'Successful'),
    (9, 9, 480.75, '2024-05-26 14:00:00', 'PayPal', 'Successful'),
    (10, 10, 900.00, '2024-06-02 11:30:00', 'Credit Card', 'Successful');

---------------------------------------------------------------------------------------------------

-- FlightSchedule View: This view displays the flight schedule information,
-- including flight ID, airline name, departure and arrival cities, and departure and arrival times.

-- 1. FlightSchedule View
CREATE VIEW FlightSchedule
AS
SELECT
    f.FlightID,
    a.AirlineName,
    da.City AS DepartureCity,
    aa.City AS ArrivalCity,
    f.DepartureDateTime,
    f.ArrivalDateTime
FROM
    Flight f
    INNER JOIN Airline a ON f.AirlineID = a.AirlineID
    INNER JOIN Airport da ON f.DepartureAirportID = da.AirportID
    INNER JOIN Airport aa ON f.ArrivalAirportID = aa.AirportID;

-- BookingDetails View: This view shows the details of each booking, 
-- including the booking ID, passenger name, email, flight details, airline name, 
-- departure and arrival cities, departure and arrival times, booking date and time, and booking status.

-- 2. BookingDetails View
go
CREATE VIEW BookingDetails
AS
SELECT
    b.BookingID,
    u.FirstName,
    u.LastName,
    u.Email,
    f.FlightID,
    a.AirlineName,
    da.City AS DepartureCity,
    aa.City AS ArrivalCity,
    f.DepartureDateTime,
    f.ArrivalDateTime,
    b.BookingDateTime,
    b.Status
FROM
    Booking b
    INNER JOIN [User] u ON b.UserID = u.UserID
    INNER JOIN Flight f ON b.FlightID = f.FlightID
    INNER JOIN Airline a ON f.AirlineID = a.AirlineID
    INNER JOIN Airport da ON f.DepartureAirportID = da.AirportID
    INNER JOIN Airport aa ON f.ArrivalAirportID = aa.AirportID;

-- PassengerTicketDetails View: This view combines passenger information, 
-- ticket details, flight details, airline name, departure and arrival cities, 
-- and departure and arrival times. 
-- It can be useful for retrieving comprehensive information about passengers and their associated tickets and flights.

-- 3. PassengerTicketDetails View
go
CREATE VIEW PassengerTicketDetails
AS
SELECT
    p.PassengerID,
    p.FirstName,
    p.LastName,
    p.Birthdate,
    p.Age,
    p.Gender,
    t.TicketID,
    t.SeatNumber,
    t.BoardingPassURL,
    b.BookingID,
    f.FlightID,
    a.AirlineName,
    da.City AS DepartureCity,
    aa.City AS ArrivalCity,
    f.DepartureDateTime,
    f.ArrivalDateTime
FROM
    Passenger p
    INNER JOIN Ticket t ON p.PassengerID = t.PassengerID
    INNER JOIN Booking b ON t.BookingID = b.BookingID
    INNER JOIN Flight f ON b.FlightID = f.FlightID
    INNER JOIN Airline a ON f.AirlineID = a.AirlineID
    INNER JOIN Airport da ON f.DepartureAirportID = da.AirportID
    INNER JOIN Airport aa ON f.ArrivalAirportID = aa.AirportID;

-- check if the views work correctly
go
    -- FlightSchedule View:
    SELECT * FROM FlightSchedule;
    -- BookingDetails View:
    SELECT * FROM BookingDetails WHERE BookingID = 1;
    -- PassengerTicketDetails View:
    SELECT * FROM PassengerTicketDetails WHERE PassengerID = 3;

GO
---------------------------------------------------------------------------------------------------

-- Function to Calculate Age: A function dbo.CalculateAge is created to calculate the age based on the birthdate.
-- Creating a function to calculate age from birthdate

CREATE FUNCTION dbo.CalculateAge(@Birthdate DATE)
RETURNS INT
AS
BEGIN
    DECLARE @Age INT;
    SET @Age = DATEDIFF(YEAR, @Birthdate, GETDATE());
    RETURN @Age;
END;
GO

-- Creating a computed column for age based on a function
ALTER TABLE Passenger
ADD AgeFromFunction AS (dbo.CalculateAge(Birthdate));

-- Creating a CHECK constraint using the function
ALTER TABLE Passenger
ADD CONSTRAINT CHK_PassengerAge CHECK (dbo.CalculateAge(Birthdate) >= 18);

Select * From Passenger;

---------------------------------------------------------------------------------------------------
-- Table-level CHECK Function and Constraint for Airline Rating: 
-- A function dbo.IsValidRating is created to check if a rating is valid (between 0 and 5), 
-- and a CHECK constraint is added to the Airline table to enforce this constraint.
-- Table-level CHECK constraints based on a function 
go
CREATE or ALTER FUNCTION dbo.IsValidRating(@Rating DECIMAL(3,2))
RETURNS BIT
AS
BEGIN
    DECLARE @IsValid BIT = 0;
    IF @Rating BETWEEN 0 AND 5
        SET @IsValid = 1;
    RETURN @IsValid;
END;
GO

ALTER TABLE Airline
ADD CONSTRAINT CHK_ValidRating CHECK (dbo.IsValidRating(Rating) = 1);

-- Checking function is working or not
SELECT dbo.IsValidRating(4.5); -- Should return 1
SELECT dbo.IsValidRating(6.0); -- Should return 0
SELECT dbo.IsValidRating(-1.0); -- Should return 0

---------------------------------------------------------------------------------------------------
-- Function and Constraint for Flight Departure Date: A function dbo.IsDepartureDateValid is created 
-- to check if a departure date is valid (greater than or equal to the current date), and 
-- a CHECK constraint is added to the Flight table to enforce this constraint.
GO
CREATE FUNCTION dbo.IsDepartureDateValid(@DepartureDate DATETIME)
RETURNS BIT
AS
BEGIN
    DECLARE @IsValid BIT = CASE WHEN @DepartureDate >= GETDATE() THEN 1 ELSE 0 END;
    RETURN @IsValid;
END;
GO

ALTER TABLE Flight
ADD CONSTRAINT CHK_ValidDepartureDate CHECK (dbo.IsDepartureDateValid(DepartureDateTime) = 1);

-- Check if the function is working properly or not
SELECT dbo.IsDepartureDateValid('2024-04-05') AS IsValid; -- Should return 1
SELECT dbo.IsDepartureDateValid('2023-04-05') AS IsValid; -- Should return 0

---------------------------------------------------------------------------------------------------

Go
--Computed column to calculate the number of days until the flight departure:
CREATE FUNCTION dbo.CalculateDaysUntilDeparture(@DepartureDateTime DATETIME)
RETURNS INT
AS
BEGIN
    DECLARE @DaysUntilDeparture INT;
    SET @DaysUntilDeparture = DATEDIFF(DAY, GETDATE(), @DepartureDateTime);
    RETURN @DaysUntilDeparture;
END;
GO

ALTER TABLE Flight
ADD DaysUntilDeparture AS (dbo.CalculateDaysUntilDeparture(DepartureDateTime));
---------------------------------------------------------------------------------------------------

-- Function to Calculate Flight Duration: A function dbo.CalculateFlightDuration
-- is created to calculate the duration between the departure and arrival times of 
-- a flight, and a computed column FlightDuration is added to the Flight table to store this duration.
-- Calculate the Duration between the flights
GO
CREATE FUNCTION dbo.CalculateFlightDuration(@DepartureDateTime DATETIME, @ArrivalDateTime DATETIME)
RETURNS TIME
AS
BEGIN
    DECLARE @Duration TIME = DATEADD(MINUTE, DATEDIFF(MINUTE, @DepartureDateTime, @ArrivalDateTime), 0);
    RETURN @Duration;
END;
GO

ALTER TABLE Flight
ADD FlightDuration AS (dbo.CalculateFlightDuration(DepartureDateTime, ArrivalDateTime));


SELECT *  from Flight;

---------------------------------------------------------------------------------------------------
-- Step 1: Create a symmetric key
CREATE SYMMETRIC KEY f_BookingSymmetricKey
WITH ALGORITHM = AES_256
ENCRYPTION BY PASSWORD = 'Group1@password';

--Step 2: Encrypt the column data
ALTER TABLE [User]
ADD Password_EncryptedColumn VARBINARY(MAX);

-- Encrypt the data in the column
OPEN SYMMETRIC KEY f_BookingSymmetricKey
DECRYPTION BY PASSWORD = 'Group1@password';
UPDATE [User]
SET Password_EncryptedColumn = ENCRYPTBYKEY(KEY_GUID('f_BookingSymmetricKey'), CAST([Password] AS NVARCHAR(50)));

-- select the encrypted data
SELECT * FROM [User];

-- Decrypt the data
OPEN SYMMETRIC KEY f_BookingSymmetricKey
DECRYPTION BY PASSWORD = 'Group1@password';
SELECT  Password,  Password_EncryptedColumn ,  CONVERT(NVARCHAR(MAX), DECRYPTBYKEY(Password_EncryptedColumn)) AS Password_DecryptedColumn
FROM [User];

Go
-- Step 3: Create a trigger to automatically encrypt new data or update existing data
CREATE TRIGGER EncryptUserPassword
ON [User]
AFTER INSERT, UPDATE
AS
BEGIN
    OPEN SYMMETRIC KEY f_BookingSymmetricKey
    DECRYPTION BY PASSWORD = 'Group1@password';

    IF EXISTS (SELECT * FROM inserted)
    BEGIN
        -- Encrypt new passwords from INSERT
        UPDATE f
        SET f.Password_EncryptedColumn = ENCRYPTBYKEY(KEY_GUID('f_BookingSymmetricKey'), CAST(i.Password AS NVARCHAR(50)))
        FROM [User] f
        INNER JOIN inserted i ON f.UserID = i.UserID;
    END

    IF EXISTS (SELECT * FROM deleted)
    BEGIN
        -- Encrypt updated passwords from UPDATE
        UPDATE f
        SET f.Password_EncryptedColumn = ENCRYPTBYKEY(KEY_GUID('f_BookingSymmetricKey'), CAST(i.Password AS NVARCHAR(50)))
        FROM [User] f
        INNER JOIN inserted i ON f.UserID = i.UserID
        INNER JOIN deleted d ON f.UserID = d.UserID
        WHERE i.Password <> d.Password;
    END
END;

SELECT * FROM [User];


----------------------------------------------------------------------------------------------------------------------------------------------------------------

-- function to check the cost of the seat based on class type
GO
CREATE FUNCTION dbo.GetSeatCostByClass (@ClassType VARCHAR(50))
RETURNS DECIMAL(10, 2)  -- Assuming the cost is in decimal format with two decimal places
AS
BEGIN
    DECLARE @Cost DECIMAL(10, 2);
    
    SELECT @Cost = CASE 
                        WHEN @ClassType = 'Economy' THEN 100.00  -- cost for economy class
                        WHEN @ClassType = 'Business' THEN 200.00  --  cost for business class
                        WHEN @ClassType = 'First' THEN 300.00  -- cost for first class
                        ELSE 0.00  -- Default cost for other class types
                   END;
    
    RETURN @Cost;
END;
Go

SELECT dbo.GetSeatCostByClass('Economy') AS SeatCost;
  -- This will return the cost for Economy class

-- Perform table-level check constraint on the above function

CREATE TABLE Seats_Cost (
    SeatID INT PRIMARY KEY,
    ClassType VARCHAR(50),
    Cost DECIMAL(10, 2),
    CONSTRAINT CHK_CostIsValid CHECK (Cost = dbo.GetSeatCostByClass(ClassType))
);


INSERT INTO Seats_Cost (SeatID, ClassType, Cost)
VALUES (101, 'First', 300);

SELECT * FROM Seats_Cost;



-- Column Data Encryption:

-- Step 1: Create a symmetric key
CREATE SYMMETRIC KEY FlightBookingSymmetricKey
WITH ALGORITHM = AES_256
ENCRYPTION BY PASSWORD = 'DAMG_Phase4';

--Step 2: Encrypt the column data
ALTER TABLE Flight
ADD EncryptedColumn VARBINARY(MAX);

-- Encrypt the data in the column
OPEN SYMMETRIC KEY FlightBookingSymmetricKey
DECRYPTION BY PASSWORD = 'DAMG_Phase4';
UPDATE Flight
SET EncryptedColumn = ENCRYPTBYKEY(KEY_GUID('FlightBookingSymmetricKey'), CAST(FlightID AS NVARCHAR(50)));

-- select the encrypted data
SELECT FlightID, DepartureDateTime, ArrivalDateTime, EncryptedColumn
FROM Flight;

-- Decrypt the data
OPEN SYMMETRIC KEY FlightBookingSymmetricKey
DECRYPTION BY PASSWORD = 'DAMG_Phase4';
SELECT FlightID, DepartureDateTime, ArrivalDateTime, CONVERT(NVARCHAR(MAX), DECRYPTBYKEY(EncryptedColumn)) AS DecryptedColumn
FROM Flight;

Go
-- Step 3: Create a trigger to automatically encrypt new data or update existing data
CREATE TRIGGER EncryptFlightData
ON Flight
AFTER INSERT, UPDATE
AS
BEGIN
    OPEN SYMMETRIC KEY FlightBookingSymmetricKey
    DECRYPTION BY PASSWORD = 'DAMG_Phase4';
    
    IF EXISTS (SELECT * FROM inserted)
    BEGIN
        UPDATE f
        SET f.EncryptedColumn = ENCRYPTBYKEY(KEY_GUID('FlightBookingSymmetricKey'), CAST(i.FlightID AS NVARCHAR(50)))
        FROM Flight f
        INNER JOIN inserted i ON f.FlightID = i.FlightID;
    END
END;
Go

SELECT * FROM Flight;
