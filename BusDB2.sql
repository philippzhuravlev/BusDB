-- SQL TABLE MODIFICATIONS
-- use case 1: passenger moves
INSERT INTO Address(Street, City, Zipcode, CivicNumber, Country)
	VALUES ('Carlsgatan', 'Malmö', '211 20', '54321', 'Sweden');
UPDATE Passenger
    SET AddressID = (SELECT AddressID FROM Address WHERE CivicNumber = '54321')
    WHERE IDCardNumber = '789012 345 789 012 7';
DELETE FROM Address
    WHERE AddressID = 7;

SELECT p.IDCardNumber, p.Email,  p.FirstName, p.LastName, p.PhoneNumber, p.AddressID, a.Street, a.City, a.Zipcode, a.CivicNumber, a.Country
	FROM Passenger p
	JOIN Address a ON p.AddressID = a.AddressID
	WHERE p.IDCardNumber = '789012 345 789 012 7';

-- use case 2: a bus stop changes to a temporary stop
INSERT INTO BusStop(BusStopName, GPSCoordinates)
	VALUES ('Østerbrogade (Midlertidigt Stop)', ST_GeomFromText('POINT(55.5333 12.5123)'));
UPDATE BusLine
	SET BusStopName = 'Østerbrogade (Midlertidigt Stop)' -- will affect all lines
	WHERE BusStopName = 'Østerbrogade';
    
SELECT * FROM BusLine WHERE BusLineName = '150S';

-- use case 3: new 5C "Nørrebro St." line ends 2 stops earlier 
INSERT INTO BusLine (BusLineName, FinalDestination, BusStopName, StopOrder)
	SELECT BusLineName, 'Husum Torv', BusStopName, StopOrder
	FROM BusLine
	WHERE BusLineName = '5C' AND FinalDestination = 'Herlev St.';
SET FOREIGN_KEY_CHECKS = 0;
DELETE FROM BusLine
	WHERE BusLineName = '5C' 
	AND FinalDestination = 'Husum Torv'
	AND (StopOrder = 9 OR StopOrder = 10);
SET FOREIGN_KEY_CHECKS = 1;
INSERT INTO BusLine (BusLineName, FinalDestination, BusStopName, StopOrder)
VALUES 
    ('5C', 'Husum Torv', 'Brønshøj Torv', 9),
    ('5C', 'Husum Torv', 'Husum Torv', 10);

SELECT * FROM BusLine Where BusLineName = '5C';

-- SQL DATA QUERIES
-- get all passenger id's where their ride started at the first stop on a bus line.
SELECT DISTINCT R.IDCardNumber FROM Ride R
JOIN BusLine BL
    ON R.BusLineName = BL.BusLineName 
    AND R.StartStop = BL.BusStopName
WHERE BL.StopOrder = 1;

-- get the name of the bus stop served by the most bus lines.
SELECT BusStopName, COUNT(*)
FROM BusLine
GROUP BY BusStopName
HAVING COUNT(*) = (
	SELECT MAX(StopCount)
	FROM (
		SELECT COUNT(*) AS StopCount
        FROM BusLine
        GROUP BY BusStopName
	) AS Count
);

-- for each line, get the ID of the passenger who took the ride that lasted longer.
SELECT DISTINCT IDCardNumber, BusLineName, Duration FROM Ride AS OuterRide
WHERE Duration = (
	SELECT MAX(Duration) FROM Ride AS InnerRide
    WHERE InnerRide.BusLineName = OuterRide.BusLineName);

-- get the ID of the passengers who never took a bus line more than once per day.
SELECT DISTINCT IDCardNumber FROM Ride
GROUP BY StartDate, IDCardNumber
HAVING COUNT(*) = 1;

-- get the name of the bus stops that are never used, i.e. they are neither the start nor the end stop for any ride.
SELECT BusStopName FROM BusStop
WHERE BusStopName NOT IN (SELECT StartStop FROM Ride)
AND BusStopName NOT IN (SELECT EndStop FROM Ride);




-- SQL PROGRAMMING
-- a trigger that prevents inserting a ride starting and ending at the same stop, or at a stop not served by that line. 
DROP TRIGGER IF EXISTS Ride_Before_Insert;

DELIMITER //
CREATE TRIGGER Ride_Before_Insert
BEFORE INSERT ON Ride
FOR EACH ROW
BEGIN
	-- check if StartStop and EndStop is the same
	IF NEW.StartStop = NEW.EndStop
	THEN
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'StartStop and EndStop cannot be the same';
    END IF;
    
    -- check if StartStop is served by the given Bus Line
    IF NOT EXISTS (
		SELECT BusStopName FROM BusLine
        WHERE NEW.StartStop = BusStopName AND NEW.BusLineName = BusLineName)
	THEN 
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'The StartStop is not served by the BusLineName';
	END IF;
    
    -- check if EndStop is served by the given Bus Line
    IF NOT EXISTS (
		SELECT BusStopName FROM BusLine
        WHERE NEW.EndStop = BusStopName AND NEW.BusLineName = BusLineName)
	THEN 
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'The EndStop is not served by the BusLineName';
	END IF;
END //
DELIMITER ;

# EndStop not served by busline (should fail)
INSERT INTO Ride (StartDate, StartTime, Duration, IDCardNumber, BusLineName, FinalDestination, StartStop, EndStop)
VALUES ('2024-11-01', '08:30:00', 15, '123456 789 123 456 1', '6A', 'Gladsaxe Trafikplads', 'Københavns Hovedbanegård', 'DTU');

# StartStop and EndStop are the same (should fail)
INSERT INTO Ride (StartDate, StartTime, Duration, IDCardNumber, BusLineName, FinalDestination, StartStop, EndStop)
VALUES ('2024-11-02', '10:00:00', 14, '123456 789 123 456 1', '1A', 'Gentofte St.', 'Gentofte St.', 'Gentofte St.');

# StartStop not served by the busline (should fail)
INSERT INTO Ride (StartDate, StartTime, Duration, IDCardNumber, BusLineName, FinalDestination, StartStop, EndStop)
VALUES ('2024-11-03', '08:20:00', 18, '123456 789 123 456 1', '150S', 'Ordrup', 'Non-existent Stop', 'Nørreport');

# End stop not served by the busline (should fail)
INSERT INTO Ride (StartDate, StartTime, Duration, IDCardNumber, BusLineName, FinalDestination, StartStop, EndStop)
VALUES ('2024-11-03', '08:45:00', 15, '123456 789 123 456 1', '5C', 'Herlev St.', 'Amagerbro St.', 'Non-existent Stop');

# Everything is good (should succeed)
INSERT INTO Ride (StartDate, StartTime, Duration, IDCardNumber, BusLineName, FinalDestination, StartStop, EndStop)
VALUES ('2024-11-05', '09:00:00', 20, '123456 789 123 456 1', '6A', 'Gladsaxe Trafikplads', 'Københavns Hovedbanegård', 'Nørreport');

SELECT * FROM Ride;

-- a function that, given two stops, returns how many lines serve both stops.
DROP FUNCTION IF EXISTS TwoStops;
DELIMITER //
CREATE FUNCTION TwoStops(st1 VARCHAR(50), st2 VARCHAR(50)) RETURNS INT
BEGIN
	DECLARE vAmountServed INT DEFAULT 0;
    SELECT COUNT(DISTINCT s1.BusLineName) 
    INTO vAmountServed
    FROM BusLine s1
    JOIN BusLine s2 ON s1.BusLineName = s2.BusLineName
	WHERE s1.BusStopName = st1 AND s2.BusStopName = st2;
    
    RETURN vAmountServed;
    
END//
DELIMITER ;

SELECT 'Stops that share multiple bus lines' AS Description, TwoStops('Nørreport', 'Rådhuspladsen') AS AmountSharedLines
UNION ALL
SELECT 'Stops that share a single bus line', TwoStops('Svanemøllen St.', 'Østerport St.')
UNION ALL
SELECT 'Stops that do not share any bus line', TwoStops('Avedøre Station', 'Holte St.')
UNION ALL
SELECT 'Stops that are endpoints for different lines', TwoStops('Gladsaxe Trafikplads', 'Herlev St.')
UNION ALL
SELECT 'Stops that are the same (testing for self-reference)', TwoStops('Nørreport', 'Nørreport');



DROP PROCEDURE IF EXISTS AddStop;
DELIMITER //
CREATE PROCEDURE AddStop (IN vBusLineName VARCHAR(45), IN vStopName VARCHAR(45)) 
BEGIN
    DECLARE vStopExists VARCHAR(45) DEFAULT NULL; 	 -- var to hold StopID
    DECLARE vBusLineExists VARCHAR(45) DEFAULT NULL; -- var to hold BusLineID
    DECLARE vFinalDestination VARCHAR(50);
    DECLARE vMaxStopOrder INT;

    main: BEGIN  -- labeling the main block for use with LEAVE

        -- check if StopName exists in the BusStop table
        SELECT BusStopName INTO vStopExists FROM BusStop WHERE BusStopName = vStopName;
        IF vStopExists IS NULL THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Stop does not exist in BusStop table';
            LEAVE main;
        END IF;

        -- check if BusLineName exists in the BusLine table
        SELECT BusLineName INTO vBusLineExists FROM BusLine WHERE BusLineName = vBusLineName
        LIMIT 1;
        IF vBusLineExists IS NULL THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Bus line does not exist in BusLine table';
            LEAVE main;
        END IF;

        -- if stop does exist Check if the stop is already on the bus line's route
        IF EXISTS (
            SELECT 1
            FROM BusLine
            WHERE BusLineName = vBusLineName AND BusStopName = vStopName
        ) THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Stop already exists on this line';
            LEAVE main;
        ELSE
            -- if it is not on the route, add the new stop
            SELECT FinalDestination, MAX(StopOrder) + 1
			INTO vFinalDestination, vMaxStopOrder
			FROM BusLine
			WHERE BusLineName = vBusLineName;
            
            INSERT INTO BusLine (BusLineName, FinalDestination, StopOrder, BusStopName)
            VALUES (
                vBusLineName,
                vFinalDestination,
				vMaxStopOrder,
                vStopName
            );
            SELECT 'Stop added to the route successfully' AS Message;
        END IF; 

    END main;  

END //
DELIMITER ;

-- adding a Stop That Exists and Is Not Already on the Line
CALL AddStop('6A', 'Lyngby St.');

-- adding a Stop That Does Not Exist in BusStop
CALL AddStop('6A', 'NonExistent Stop');

-- adding a Stop That Is Already on the Line
CALL AddStop('6A', 'Nørreport');

-- adding a Stop to a Non-Existent Bus Line
CALL AddStop('10B', 'Forum');

-- adding a Stop to Extend the Line
CALL AddStop('6A', 'Hellerup St.');

SELECT * FROM BusLine
ORDER BY BusLineName;
