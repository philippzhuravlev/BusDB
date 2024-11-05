DROP DATABASE IF EXISTS BusDB;
CREATE DATABASE BusDB;
USE BusDB;

DROP TABLE IF EXISTS Ride;
DROP TABLE IF EXISTS StopsOnLine;
DROP TABLE IF EXISTS BusStop;
DROP TABLE IF EXISTS BusLine;
DROP TABLE IF EXISTS Passenger;
DROP TABLE IF EXISTS Address;

CREATE TABLE Address
	( AddressID        INT AUTO_INCREMENT PRIMARY KEY
	, Street           VARCHAR(50) 
	, City             VARCHAR(50) 
	, Zipcode          VARCHAR(10) # would be INT, but some countries use a dash ("12345-6789"). Same below.
	, CivicNumber      VARCHAR(10) # NB: A number assigned to each plot of land. DK: Matrikelnummer, 5 ints
	, Country          VARCHAR(30) # on case users type full country name ("Democratic Republic of Congo")
    );

CREATE TABLE Passenger
	( PassengerID		INT AUTO_INCREMENT PRIMARY KEY
    , Email				VARCHAR(50) 
    , Fullname			VARCHAR(50) # not worth splitting up into first and last name due to middle names
    , PhoneNumber		VARCHAR(20) # longest phone number is 17. Varchar due to "+45" etc
    , AddressID			INT
    , FOREIGN KEY		(AddressID) 	REFERENCES 	Address(AddressID)
    ); 

CREATE TABLE BusStop
	( StopID			INT AUTO_INCREMENT PRIMARY KEY
    , StopName			VARCHAR(45) UNIQUE # longest stop name is 43 char
	, GPSCoordinates	POINT # contains latitude, longitude. Can be split.
	);

CREATE TABLE BusLine
	( BusLineID			INT AUTO_INCREMENT PRIMARY KEY
    , BusLineName		VARCHAR(5) UNIQUE # e.g. 6A, 300S
	, FinalDestination	VARCHAR(45) # compare 6A Buddinge vs 6A Emdrup Torv. Can be combined into BusLineName
    , StopName			VARCHAR(45) # not a foreign key; just an attribute for reference
	);

CREATE TABLE StopsOnLine
	( StopsOnLineID		INT AUTO_INCREMENT PRIMARY KEY
	, BusLineID			INT
    , BusLineName		VARCHAR(45)
	, StopID			INT
    , StopName			VARCHAR(45)
    , StopOrder			INT
    , FOREIGN KEY		(BusLineID) 	REFERENCES 	BusLine(BusLineID)
    , FOREIGN KEY		(BusLineName)	REFERENCES	BusLine(BusLineName)
    , FOREIGN KEY		(StopID) 		REFERENCES 	BusStop(StopID)
    , FOREIGN KEY		(StopName)		REFERENCES	BusStop(StopName)
    );   

CREATE TABLE Ride
	( RideID        	INT AUTO_INCREMENT PRIMARY KEY
	, StartDate     	DATE
	, StartTime     	TIME
	, Duration      	INT
	, PassengerID   	INT
	, BusLineName   	VARCHAR(5)
	, StartStop     	VARCHAR(45)
	, EndStop       	VARCHAR(45)
	, FOREIGN KEY		(PassengerID)	REFERENCES Passenger(PassengerID)
	, FOREIGN KEY 		(BusLineName)	REFERENCES BusLine(BusLineName)
	, FOREIGN KEY 		(StartStop)		REFERENCES BusStop(StopName)
	, FOREIGN KEY 		(EndStop)		REFERENCES BusStop(StopName)
	);
    
INSERT INTO Address (Street, City, Zipcode, CivicNumber, Country)
VALUES 
    ('Maple Street', 'Copenhagen', '1000', '12345', 'Denmark'),
    ('Oak Avenue', 'Aarhus', '8000', '23456', 'Denmark'),
    ('Pine Road', 'Odense', '5000', '34567', 'Denmark');

INSERT INTO Passenger (Email, Fullname, PhoneNumber, AddressID)
VALUES 
    ('johndoe@example.com', 'John Doe', '+4512345678', 1),
    ('janedoe@example.com', 'Jane Doe', '4522345678', 2),
    ('alice@example.com', 'Alice Smith', '+4533345678', 3);

INSERT INTO BusStop (StopName, GPSCoordinates)
VALUES 
    ('Københavns Hovedbanegård', ST_GeomFromText('POINT(55.6761 12.5683)')),
    ('Rådhuspladsen', ST_GeomFromText('POINT(55.6759 12.5655)')),
    ('DTU', ST_GeomFromText('POINT(55.6767 12.5700)')),
    ('Nørreport', ST_GeomFromText('POINT(55.6770 12.5722)'));

INSERT INTO BusLine (BusLineName, FinalDestination) 
VALUES 
    ('6A', 'Københavns Hovedbanegård'), 
    ('300S', 'Københavns Hovedbanegård'), 
    ('150S', 'Nørreport'), 
    ('600S', 'Nørreport');

INSERT INTO StopsOnLine (BusLineID, BusLineName, StopID, StopName, StopOrder) # 6A
VALUES 
    (1, '6A', 1, 'Københavns Hovedbanegård', 1),  # Københavns Hovedbanegård
    (1, '6A', 2, 'Rådhuspladsen', 2),              # Rådhuspladsen
    (1, '6A', 3, 'DTU', 3),                        # DTU
    (1, '6A', 4, 'Nørreport', 4);                  # Nørreport

INSERT INTO StopsOnLine (BusLineID, BusLineName, StopID, StopName, StopOrder) # 300S
VALUES 
    (2, '300S', 1, 'Københavns Hovedbanegård', 1), # Københavns Hovedbanegård
    (2, '300S', 2, 'Rådhuspladsen', 2),             # Rådhuspladsen
    (2, '300S', 4, 'Nørreport', 3);                 # Nørreport

INSERT INTO StopsOnLine (BusLineID, BusLineName, StopID, StopName, StopOrder) # 150S
VALUES 
    (3, '150S', 4, 'Nørreport', 1),                # Nørreport
    (3, '150S', 3, 'DTU', 2),                       # DTU
    (3, '150S', 2, 'Rådhuspladsen', 3),             # Rådhuspladsen
    (3, '150S', 1, 'Københavns Hovedbanegård', 4); # Københavns Hovedbanegård

INSERT INTO StopsOnLine (BusLineID, BusLineName, StopID, StopName, StopOrder) # 600S
VALUES 
    (4, '600S', 4, 'Nørreport', 1),                # Nørreport
    (4, '600S', 1, 'Københavns Hovedbanegård', 2), # Københavns Hovedbanegård
    (4, '600S', 2, 'Rådhuspladsen', 3),             # Rådhuspladsen
    (4, '600S', 3, 'DTU', 4);                       # DTU


INSERT INTO Ride (StartDate, StartTime, Duration, PassengerID, BusLineName, StartStop, EndStop)
VALUES 
    ('2024-11-01', '08:30:00', 15, 1, '6A', 'Københavns Hovedbanegård', 'DTU'),
    ('2024-11-01', '09:00:00', 10, 2, '6A', 'Rådhuspladsen', 'Nørreport'),
    ('2024-11-02', '07:45:00', 20, 3, '6A', 'DTU', 'Københavns Hovedbanegård');

SELECT * FROM StopsOnLine;

# Get all passenger id's where their ride started at the first stop on a bus line.
SELECT PassengerID FROM Ride
JOIN 
    StopsOnLine AS StartStopLine 
    ON Ride.BusLineName = StartStopLine.BusLineName
    AND Ride.StartStop = StartStopLine.StopName
WHERE StopOrder = 1;

# The name of the bus stop served by the most bus lines.
# Without Counter
SELECT StopName FROM StopsOnLine
GROUP BY StopID, StopName
HAVING COUNT(*) = (
	SELECT MAX(StopCount)
    FROM (
		SELECT COUNT(*) AS StopCount
        FROM StopsOnLine
        GROUP BY StopID
	) AS Count
);

# With Counter
SELECT StopName, COUNT(*) FROM StopsOnLine
GROUP BY StopID, StopName
HAVING COUNT(*) = (
	SELECT MAX(StopCount)
    FROM (
		SELECT COUNT(*) AS StopCount
        FROM StopsOnLine
        GROUP BY StopID
	) AS Count
);
