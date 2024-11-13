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
	( AddressID         INT AUTO_INCREMENT -- must be an auto_increment, otherwise you need 3-4 primary keys
	, Street            VARCHAR(50) 
	, City              VARCHAR(50) 
	, Zipcode           VARCHAR(10) -- would be INT, but some countries use a dash ("12345-6789"). Same below.
	, CivicNumber       VARCHAR(10) -- NB: A number assigned to each plot of land. DK: Matrikelnummer, 5 ints
	, Country           VARCHAR(30) -- on case users type full country name ("Democratic Republic of Congo")
    , PRIMARY KEY		(AddressID)
    );

CREATE TABLE Passenger
	( IDCardNumber		VARCHAR(20)	-- example used: rejsekort's format ("123456 789 123 456 7")
    , Email				VARCHAR(50) 
    , FirstName			VARCHAR(50) -- also includes middle name
    , LastName			VARCHAR(20)
    , PhoneNumber		VARCHAR(20) -- longest phone number is 17 chars. Varchar due to "+45" etc
    , AddressID			INT
    , PRIMARY KEY		(IDCardNumber)
    , FOREIGN KEY		(AddressID)			REFERENCES 	Address(AddressID)
    ); 

CREATE TABLE BusStop
	( BusStopName		VARCHAR(50) -- longest stop name in DK is 43 char
	, GPSCoordinates	POINT		-- contains latitude and longitude
    , PRIMARY KEY		(BusStopName)
	);

CREATE TABLE BusLine
	( BusLineName		VARCHAR(5) 	-- e.g. 6A, 300S
	, FinalDestination	VARCHAR(50) -- compare 6A Buddinge vs 6A Emdrup Torv. Can be combined into BusLineName
    , StopOrder			INT			-- i.e. 1st stop, 2nd stop, 3rd stop etc
    , StopOnBusLine		VARCHAR(50)	
    , PRIMARY KEY		(BusLineName, FinalDestination, StopOrder)
    , FOREIGN KEY		(FinalDestination)	REFERENCES	BusStop(BusStopName)
    , FOREIGN KEY		(StopOnBusLine)		REFERENCES	BusStop(BusStopName)
	);

CREATE TABLE Ride
	# RideID            AUTO_INCREMENT	PRIMARY KEY	-- to support two trips on the same rejsekort, a RideID is necessary
	( StartDate     	DATE
	, StartTime     	TIME
	, Duration      	INT
	, IDCardNumber   	VARCHAR(20)
	, BusLineName   	VARCHAR(5)
	, StartStop     	VARCHAR(50)
	, EndStop       	VARCHAR(50)
    , PRIMARY KEY		(StartDate, StartTime, IDCardNumber)
	, FOREIGN KEY		(IDCardNumber)	REFERENCES Passenger(IDCardNumber)
	, FOREIGN KEY 		(BusLineName)	REFERENCES BusLine(BusLineName)
	, FOREIGN KEY 		(StartStop)		REFERENCES BusStop(BusStopName)
	, FOREIGN KEY 		(EndStop)		REFERENCES BusStop(BusStopName)
	);
    
INSERT INTO Address(Street, City, Zipcode, CivicNumber, Country)
VALUES 
    ('Maple Street', 'Copenhagen', '1000', '12345', 'Denmark'),
    ('Oak Avenue', 'Aarhus', '8000', '23456', 'Denmark'),
	('Pine Road', 'Odense', '5000', '34567', 'Denmark'),
	('Nørrebrogade', 'Copenhagen', '2200', '1001', 'Denmark'),
	('Frederiksborggade', 'Copenhagen', '1360', '1002', 'Denmark'),
	('Østerbrogade', 'Copenhagen', '2100', '1003', 'Denmark'),
	('Vesterbrogade', 'Copenhagen', '1620', '1004', 'Denmark'),
	('Amagerbrogade', 'Copenhagen', '2300', '1505', 'Denmark'),
	('Strandgade', 'Copenhagen', '1401', '1006', 'Denmark'),
	('Rådhuspladsen', 'Copenhagen', '1550', '1007', 'Denmark'),
	('Kongens Nytorv', 'Copenhagen', '1050', '1608', 'Denmark'),
	('Gothersgade', 'Copenhagen', '1123', '1009', 'Denmark'),
	('Nytorv', 'Copenhagen', '1450', '1010', 'Denmark'),
	('Skt. Peders Stræde', 'Copenhagen', '1453', '1011', 'Denmark'),
	('Studiestræde', 'Copenhagen', '1455', '1012', 'Denmark'),
	('Frederiksholms Kanal', 'Copenhagen', '1220', '1013', 'Denmark'),
	('Lille Strandstræde', 'Copenhagen', '1255', '1014', 'Denmark'),
	('Borgergade', 'Copenhagen', '1300', '1015', 'Denmark'),
	('Gammel Kongevej', 'Copenhagen', '1610', '1016', 'Denmark'),
	('Enghavevej', 'Copenhagen', '1674', '1017', 'Denmark'),
	('Fælledvej', 'Copenhagen', '2200', '1018', 'Denmark'),
	('Vestergade', 'Copenhagen', '1456', '1019', 'Denmark'),
	('Pilestræde', 'Copenhagen', '1112', '1020', 'Denmark'),
	('Toldbodgade', 'Copenhagen', '1253', '1021', 'Denmark'),
	('Landemærket', 'Copenhagen', '1119', '1022', 'Denmark'),
	('Slagelsegade', 'Copenhagen', '2100', '1034', 'Denmark'),
	('Lilla Torg', 'Malmö', '21134', '2001', 'Sweden'),
	('Adelgade', 'Copenhagen', '1304', '1024', 'Denmark'),
	('Store Kongensgade', 'Copenhagen', '1264', '1025', 'Denmark'),
	('Sølvgade', 'Copenhagen', '1307', '1026', 'Denmark'),
	('Rigensgade', 'Copenhagen', '1316', '1027', 'Denmark'),
	('Krystalgade', 'Copenhagen', '1172', '1028', 'Denmark'),
	('Vingårdsstræde', 'Copenhagen', '1070', '1029', 'Denmark'),
	('Skindergade', 'Copenhagen', '1159', '1030', 'Denmark'),
	('Læderstræde', 'Copenhagen', '1201', '1031', 'Denmark'),
	('Fiolstræde', 'Copenhagen', '1171', '1032', 'Denmark'),
	('Klosterstræde', 'Copenhagen', '1157', '1033', 'Denmark'),
	('Rådhusstræde', 'Copenhagen', '1466', '1034', 'Denmark'),
	('Vestervoldgade', 'Copenhagen', '1552', '1035', 'Denmark'),
	('Hyskenstræde', 'Copenhagen', '1207', '1036', 'Denmark'),
	('Stormgade', 'Copenhagen', '1470', '1037', 'Denmark'),
	('Langebrogade', 'Copenhagen', '1411', '1038', 'Denmark'),
	('Christianshavn', 'Copenhagen', '1400', '1039', 'Denmark'),
	('Nyhavn', 'Copenhagen', '1051', '1040', 'Denmark'),
	('Bremerholm', 'Copenhagen', '1069', '1041', 'Denmark'),
	('Holmens Kanal', 'Copenhagen', '1060', '1042', 'Denmark'),
	('Amagertorv', 'Copenhagen', '1160', '1043', 'Denmark'),
	('Bredgade', 'Copenhagen', '1260', '1044', 'Denmark'),
	('Hauser Plads', 'Copenhagen', '1127', '1045', 'Denmark'),
	('Axeltorv', 'Copenhagen', '1609', '1046', 'Denmark'),
	('Farvergade', 'Copenhagen', '1463', '1047', 'Denmark'),
	('Antonigade', 'Copenhagen', '1106', '1048', 'Denmark'),
	('Tullinsgade', 'Copenhagen', '1618', '1049', 'Denmark'),
	('Elmegade', 'Copenhagen', '2200', '1050', 'Denmark'),
	('Sønder Boulevard', 'Copenhagen', '1720', '1051', 'Denmark'),
	('Frederiks Allé', 'Copenhagen', '2200', '1052', 'Denmark'),
	('Godthåbsvej', 'Copenhagen', '2000', '1053', 'Denmark'),
	('Griffenfeldsgade', 'Copenhagen', '2200', '1054', 'Denmark'),
	('Langelinie Allé', 'Copenhagen', '2100', '1055', 'Denmark'),
	('Dag Hammarskjölds Allé', 'Copenhagen', '2100', '1056', 'Denmark'),
	('Sankt Hans Gade', 'Copenhagen', '2200', '1057', 'Denmark'),
	('Istedgade', 'Copenhagen', '1650', '1058', 'Denmark'),
	('Halmtorvet', 'Copenhagen', '1700', '1059', 'Denmark'),
	('Kalvebod Brygge', 'Copenhagen', '1560', '1060', 'Denmark'),
	('Vester Voldgade', 'Copenhagen', '1552', '1061', 'Denmark'),
	('Flensborggade', 'Copenhagen', '1669', '1062', 'Denmark'),
	('Valby Langgade', 'Copenhagen', '2500', '1063', 'Denmark'),
	('Vigerslev Allé', 'Copenhagen', '2500', '1064', 'Denmark'),
	('Bernstorffsgade', 'Copenhagen', '1577', '1066', 'Denmark');

INSERT INTO Passenger(IDCardNumber, Email, FirstName, LastName, PhoneNumber, AddressID)
VALUES 
	('123456 789 123 456 1', 'johndoe@example.com', 'John', 'Doe', '+4512345678', 1),
	('234567 890 234 567 2', 'janedoe@example.com', 'Jane', 'Doe', '4522345678', 2),
	('345678 901 345 678 3', 'alice@example.com', 'Alice', 'Smith', '+4533345678', 3),
	('456789 012 456 789 4', 'nielslarsen@gmail.com', 'Niels', 'Larsen', '+4523041579', 4),
	('567890 123 567 890 5', 'henrikhansen@hotmail.com', 'Henrik', 'Hansen', '+4521938746', 5),
	('678901 234 678 901 6', 'annasorensen@gmail.com', 'Anna', 'Sørensen', '+4525678129', 6),
	('789012 345 789 012 7', 'peterjensen@gmail.com', 'Peter', 'Jensen', '+4526789301', 7),
	('890123 456 890 123 8', 'karinnielsen@gmail.com', 'Karin', 'Nielsen', '+4523456781', 8),
	('901234 567 901 234 9', 'andersandersen@hotmail.dk', 'Anders', 'Andersen', '+4529085672', 9),
	('012345 678 012 345 1', 'lisbethnielsen@gmail.com', 'Lisbeth', 'Nielsen', '+4523902178', 10),
	('123456 789 123 456 2', 'jørgenschmidt@gmail.dk', 'Jørgen', 'Schmidt', '+4529481567', 11),
	('234567 890 234 567 3', 'poulchristensen@gmail.com', 'Poul', 'Christensen', '+4521379865', 12),
	('345678 901 345 678 4', 'jemalali@gmail.se', 'Jemal', 'Ali', '+46701234567', 13),
	('456789 012 456 789 5', 'mariapedersen@gmail.com', 'Maria', 'Pedersen', '+4529684321', 14),
	('567890 123 567 890 6', 'karlnielsen@hotmail.com', 'Karl', 'Nielsen', '+4521839567', 15),
	('678901 234 678 901 7', 'henrikhansen@gmail.com', 'Henrik', 'Hansen', '+4523092187', 16),
	('789012 345 789 012 8', 'mortenmadsen@gmail.dk', 'Morten', 'Madsen', '+4527653412', 17),
	('890123 456 890 123 9', 'ingeborglarsen@hotmail.com', 'Ingeborg', 'Larsen', '+4524738956', 18),
	('901234 567 901 234 1', 'susannejensen@gmail.com', 'Susanne', 'Jensen', '+4529471258', 19),
	('012345 678 012 345 2', 'clausnielsen@hotmail.dk', 'Claus', 'Nielsen', '+4523512478', 20),
	('123456 789 123 456 3', 'karennielsen@gmail.com', 'Karen', 'Nielsen', '+4523945871', 21),
	('234567 890 234 567 4', 'ingedamgaard@gmail.dk', 'Inge', 'Damgaard', '+4520784561', 22),
	('345678 901 345 678 5', 'larskristensen@hotmail.com', 'Lars', 'Kristensen', '+4529873456', 23),
	('456789 012 456 789 6', 'leilaalrashid@hotmail.se', 'Leila', 'AlRashid', '+46701234567', 24),
	('567890 123 567 890 7', 'michaeljensen@gmail.com', 'Michael', 'Jensen', '+4523871645', 25),
	('678901 234 678 901 8', 'annkristensen@gmail.dk', 'Ann', 'Kristensen', '+4520146987', 26),
	('789012 345 789 012 9', 'jacobolesen@hotmail.dk', 'Jacob', 'Olesen', '+4525698342', 27),
	('890123 456 890 123 1', 'katrinedamgaard@gmail.com', 'Katrine', 'Damgaard', '+4529801347', 28),
	('901234 567 901 234 2', 'sorennielsen@gmail.com', 'Søren', 'Nielsen', '+4523168475', 29),
	('012345 678 012 345 3', 'piasorensen@gmail.dk', 'Pia', 'Sørensen', '+4529083476', 30),
	('123456 789 123 456 4', 'brianthomsen@gmail.com', 'Brian', 'Thomsen', '+4521978432', 31),
	('234567 890 234 567 5', 'stinenielsen@hotmail.com', 'Stine', 'Nielsen', '+4523890147', 32),
	('345678 901 345 678 6', 'jørgennielsen@gmail.dk', 'Jørgen', 'Nielsen', '+4521765839', 33),
	('456789 012 456 789 7', 'linuslauthomsen@gmai.com', 'Linus', 'Lau Thomsen', '+4523908217', 34),
	('567890 123 567 890 8', 'anneolsen@gmail.com', 'Anne', 'Olsen', '+4521459873', 35),
	('678901 234 678 901 9', 'pernielsen@gmail.com', 'Per', 'Nielsen', '+4526087453', 36),
	('789012 345 789 012 1', 'kathrineholm@hotmail.dk', 'Kathrine', 'Holm', '+4523978562', 37),
	('890123 456 890 123 2', 'johannesenlund@gmail.com', 'Johanne', 'Svendson', '+4527834065', 38),
	('901234 567 901 234 3', 'kimnielsen@gmail.dk', 'Kim', 'Nielsen', '+4521938475', 39),
	('012345 678 012 345 4', 'maibrittnielsen@hotmail.dk', 'Maibritt', 'Nielsen', '+4524902837', 40),
	('123456 789 123 456 5', 'jørgenlarsen@gmail.com', 'Jørgen', 'Larsen', '+4520394856', 41),
	('234567 890 234 567 6', 'mariannepedersen@gmail.dk', 'Marianne', 'Pedersen', '+4527163049', 42),
	('345678 901 345 678 7', 'thomasjensen@gmail.com', 'Thomas', 'Jensen', '+4529871304', 43),
	('456789 012 456 789 8', 'kennethjensen@hotmail.com', 'Kenneth', 'Jensen', '+393595356721', 44),
	('567890 123 567 890 9', 'bettinasorensen@hotmail.com', 'Bettina', 'Sørensen', '+4520367849', 45),
	('678901 234 678 901 1', 'henrikmadsen@gmail.com', 'Henrik', 'Madsen', '+4521587394', 46),
	('789012 345 789 012 2', 'annetheresejensen@gmail.dk', 'Anne-Therese', 'Jensen', '+4523904872', 47),
	('890123 456 890 123 3', 'leifjohansen@gmail.com', 'Leif', 'Johansen', '+4521768394', 48),
	('901234 567 901 234 4', 'johnnielsen@gmail.dk', 'John', 'Nielsen', '+4528375912', 49),
	('012345 678 012 345 5', 'ninarasmussen@hotmail.dk', 'Nina', 'Rasmussen', '+4526103978', 50),
	('123456 789 123 456 6', 'svendnielsen@gmail.com', 'Svend', 'Nielsen', '+4520183467', 51),
	('234567 890 234 567 7', 'tineholm@gmail.dk', 'Tine', 'Holm', '+4529375016', 52),
	('345678 901 345 678 8', 'mariannielsen@hotmail.com', 'Marian', 'Nielsen', '+4526785014', 53),
	('456789 012 456 789 9', 'kirstenolsen@gmail.com', 'Kirsten', 'Olsen', '+4521938467', 54),
	('567890 123 567 890 1', 'joakimlarsen@gmail.com', 'Joakim', 'Larsen', '+4526079873', 55)
	;


INSERT INTO BusStop(BusStopName, GPSCoordinates)
VALUES
-- NB: ST_GeomFromText SQL statement is necessary for MySQL to interpret the insert as "geometric" data
      ('Københavns Hovedbanegård', ST_GeomFromText('POINT(55.6761 12.5683)'))
    , ('Rådhuspladsen', ST_GeomFromText('POINT(55.6759 12.5655)'))
    , ('Nørreport', ST_GeomFromText('POINT(55.6838 12.5713)'))
    , ('Forum', ST_GeomFromText('POINT(55.6805 12.5523)'))
    , ('Frederiksberg Allé', ST_GeomFromText('POINT(55.6732 12.5469)'))
    , ('Åboulevard', ST_GeomFromText('POINT(55.6837 12.5448)'))
    , ('Falkoner Allé', ST_GeomFromText('POINT(55.6811 12.5354)'))
    , ('Flintholm St.', ST_GeomFromText('POINT(55.6821 12.5103)'))
    , ('Bellahøj', ST_GeomFromText('POINT(55.7067 12.5233)'))
    , ('Gladsaxe Trafikplads', ST_GeomFromText('POINT(55.7333 12.4894)'))
    , ('Østerport St.', ST_GeomFromText('POINT(55.6910 12.5939)'))
    , ('Svanemøllen St.', ST_GeomFromText('POINT(55.7026 12.5778)'))
    , ('Ryparken', ST_GeomFromText('POINT(55.7096 12.5735)'))
    , ('Lundtofteparken', ST_GeomFromText('POINT(55.7616 12.5084)'))
    , ('DTU', ST_GeomFromText('POINT(55.7856 12.5214)'))
    , ('Lyngby St.', ST_GeomFromText('POINT(55.7705 12.5033)'))
    , ('Holte St.', ST_GeomFromText('POINT(55.8144 12.4758)'))
    , ('Trianglen', ST_GeomFromText('POINT(55.6988 12.5836)'))
    , ('Østerbrogade', ST_GeomFromText('POINT(55.7052 12.5795)'))
    , ('Hellerup St.', ST_GeomFromText('POINT(55.7298 12.5644)'))
    , ('Ordrup', ST_GeomFromText('POINT(55.7476 12.5665)'))
    , ('Amagerbro St.', ST_GeomFromText('POINT(55.6612 12.6031)'))
    , ('Islands Brygge', ST_GeomFromText('POINT(55.6631 12.5899)'))
    , ('DR Byen', ST_GeomFromText('POINT(55.6587 12.5916)'))
    , ('Universitetet St.', ST_GeomFromText('POINT(55.6506 12.5902)'))
    , ('Vestamager', ST_GeomFromText('POINT(55.6316 12.5768)'))
    , ('Tårnby St.', ST_GeomFromText('POINT(55.6305 12.5992)'))
    , ('Kastrup', ST_GeomFromText('POINT(55.6179 12.6553)'))
    , ('Lufthavnen', ST_GeomFromText('POINT(55.6181 12.6568)'))
    , ('Amager Strand', ST_GeomFromText('POINT(55.6669 12.6253)'))
    , ('Christianshavn', ST_GeomFromText('POINT(55.6735 12.5914)'))
    , ('Nørrebro St.', ST_GeomFromText('POINT(55.7008 12.5353)'))
    , ('Bispebjerg St.', ST_GeomFromText('POINT(55.7116 12.5407)'))
    , ('Herlev St.', ST_GeomFromText('POINT(55.7247 12.4442)'))
    , ('Avedøre Station', ST_GeomFromText('POINT(55.6177 12.4746)'))
    , ('Friheden St.', ST_GeomFromText('POINT(55.6422 12.4763)'))
    , ('Hvidovrevej', ST_GeomFromText('POINT(55.6547 12.4878)'))
    , ('Valby St.', ST_GeomFromText('POINT(55.6617 12.5014)'))
    , ('Enghave Plads', ST_GeomFromText('POINT(55.6642 12.5483)'))
    , ('Nordhavn St.', ST_GeomFromText('POINT(55.7110 12.5913)'))
    , ('Gentofte St.', ST_GeomFromText('POINT(55.7518 12.5481)'))
    , ('Tingbjerg', ST_GeomFromText('POINT(55.7111 12.4927)'))
    , ('Brønshøj Torv', ST_GeomFromText('POINT(55.7033 12.5045)'))
    , ('Fælledparken', ST_GeomFromText('POINT(55.7011 12.5781)'))
    , ('Kongens Nytorv', ST_GeomFromText('POINT(55.6781 12.5821)'))
    , ('Lergravsparken St.', ST_GeomFromText('POINT(55.6639 12.6202)'))
    , ('Glostrup Station', ST_GeomFromText('POINT(55.6663 12.4049)'))
    , ('Brøndbyvester', ST_GeomFromText('POINT(55.6518 12.4117)'))
    , ('Brøndbyøster', ST_GeomFromText('POINT(55.6693 12.4204)'))
    , ('Rødovre Centrum', ST_GeomFromText('POINT(55.6844 12.4538)'))
    , ('Husum Torv', ST_GeomFromText('POINT(55.7118 12.4772)'))
    , ('Rigshospitalet', ST_GeomFromText('POINT(55.6954 12.5705)'))
    , ('Bispebjerg Hospital', ST_GeomFromText('POINT(55.7098 12.5422)'))
    , ('Ballerup St.', ST_GeomFromText('POINT(55.7317 12.3655)'))
    , ('Måløv', ST_GeomFromText('POINT(55.7479 12.3279)'))
    , ('Frederiksberg St.', ST_GeomFromText('POINT(55.6780 12.5307)'))
    , ('Fasanvej St.', ST_GeomFromText('POINT(55.6808 12.5188)'))
    , ('Lindevang', ST_GeomFromText('POINT(55.6836 12.5056)'))
    , ('Bella Center', ST_GeomFromText('POINT(55.6374 12.5775)'))
    , ('Ørestad St.', ST_GeomFromText('POINT(55.6290 12.5760)'))
    , ('Søndre Fasanvej', ST_GeomFromText('POINT(55.6587 12.4974)'))
    , ('Langgade St.', ST_GeomFromText('POINT(55.6622 12.4891)'))
    , ('Rødovre St.', ST_GeomFromText('POINT(55.6823 12.4531)'))
    , ('Hvidovre Hospital', ST_GeomFromText('POINT(55.6546 12.4845)'))
    , ('Sundbyvester Plads', ST_GeomFromText('POINT(55.6543 12.6028)'))
    , ('Vanløse St.', ST_GeomFromText('POINT(55.6836 12.4876)'))
    ;

INSERT INTO BusLine(BusLineName, StopOnBusLine, FinalDestination, StopOrder)
VALUES
	  ('6A', 'Københavns Hovedbanegård', 'Gladsaxe Trafikplads', 1)
	, ('6A', 'Rådhuspladsen', 'Gladsaxe Trafikplads', 2)
	, ('6A', 'Nørreport', 'Gladsaxe Trafikplads', 3)
	, ('6A', 'Forum', 'Gladsaxe Trafikplads', 4)
	, ('6A', 'Frederiksberg Allé', 'Gladsaxe Trafikplads', 5)
	, ('6A', 'Åboulevard', 'Gladsaxe Trafikplads', 6)
	, ('6A', 'Falkoner Allé', 'Gladsaxe Trafikplads', 7)
	, ('6A', 'Flintholm St.', 'Gladsaxe Trafikplads', 8)
	, ('6A', 'Bellahøj', 'Gladsaxe Trafikplads', 9)
	, ('6A', 'Gladsaxe Trafikplads', 'Gladsaxe Trafikplads', 10)
    
	, ('300S', 'Københavns Hovedbanegård', 'Holte St.', 1)
	, ('300S', 'Rådhuspladsen', 'Holte St.', 2)
	, ('300S', 'Nørreport', 'Holte St.', 3)
	, ('300S', 'Østerport St.', 'Holte St.', 4)
	, ('300S', 'Svanemøllen St.', 'Holte St.', 5)
	, ('300S', 'Ryparken', 'Holte St.', 6)
	, ('300S', 'Lundtofteparken', 'Holte St.', 7)
	, ('300S', 'DTU', 'Holte St.', 8)
	, ('300S', 'Lyngby St.', 'Holte St.', 9)
	, ('300S', 'Holte St.', 'Holte St.', 10)
    
	, ('150S', 'Nørreport', 'Ordrup', 1)
	, ('150S', 'DTU', 'Ordrup', 2)
	, ('150S', 'Rådhuspladsen', 'Ordrup', 3)
	, ('150S', 'Københavns Hovedbanegård', 'Ordrup', 4)
	, ('150S', 'Trianglen', 'Ordrup', 5)
	, ('150S', 'Østerbrogade', 'Ordrup', 6)
	, ('150S', 'Svanemøllen St.', 'Ordrup', 7)
	, ('150S', 'Ryparken', 'Ordrup', 8)
	, ('150S', 'Hellerup St.', 'Ordrup', 9)
	, ('150S', 'Ordrup', 'Ordrup', 10)
    
	, ('600S', 'Nørreport', 'Kastrup', 1)
	, ('600S', 'Københavns Hovedbanegård', 'Kastrup', 2)
	, ('600S', 'Rådhuspladsen', 'Kastrup', 3)
	, ('600S', 'Amagerbro St.', 'Kastrup', 4)
	, ('600S', 'Islands Brygge', 'Kastrup', 5)
	, ('600S', 'DR Byen', 'Kastrup', 6)
	, ('600S', 'Universitetet St.', 'Kastrup', 7)
	, ('600S', 'Vestamager', 'Kastrup', 8)
	, ('600S', 'Tårnby St.', 'Kastrup', 9)
	, ('600S', 'Kastrup', 'Kastrup', 10)
    
	, ('5C', 'Lufthavnen', 'Herlev St.', 1)
	, ('5C', 'Kastrup', 'Herlev St.', 2)
	, ('5C', 'Amager Strand', 'Herlev St.', 3)
	, ('5C', 'Amagerbro St.', 'Herlev St.', 4)
	, ('5C', 'Christianshavn', 'Herlev St.', 5)
	, ('5C', 'Rådhuspladsen', 'Herlev St.', 6)
	, ('5C', 'Nørreport', 'Herlev St.', 7)
	, ('5C', 'Nørrebro St.', 'Herlev St.', 8)
	, ('5C', 'Bispebjerg St.', 'Herlev St.', 9)
	, ('5C', 'Herlev St.', 'Herlev St.', 10)
    
	, ('1A', 'Avedøre Station', 'Gentofte St.', 1)
	, ('1A', 'Friheden St.', 'Gentofte St.', 2)
	, ('1A', 'Hvidovrevej', 'Gentofte St.', 3)
	, ('1A', 'Valby St.', 'Gentofte St.', 4)
	, ('1A', 'Enghave Plads', 'Gentofte St.', 5)
	, ('1A', 'Københavns Hovedbanegård', 'Gentofte St.', 6)
	, ('1A', 'Trianglen', 'Gentofte St.', 7)
	, ('1A', 'Nordhavn St.', 'Gentofte St.', 8)
	, ('1A', 'Hellerup St.', 'Gentofte St.', 9)
	, ('1A', 'Gentofte St.', 'Gentofte St.', 10)
    
	, ('2A', 'Tingbjerg', 'Lergravsparken St.', 1)
	, ('2A', 'Brønshøj Torv', 'Lergravsparken St.', 2)
	, ('2A', 'Nørrebro St.', 'Lergravsparken St.', 3)
	, ('2A', 'Fælledparken', 'Lergravsparken St.', 4)
	, ('2A', 'Trianglen', 'Lergravsparken St.', 5)
	, ('2A', 'Østerport St.', 'Lergravsparken St.', 6)
	, ('2A', 'Kongens Nytorv', 'Lergravsparken St.', 7)
	, ('2A', 'Christianshavn', 'Lergravsparken St.', 8)
	, ('2A', 'Amagerbro St.', 'Lergravsparken St.', 9)
	, ('2A', 'Lergravsparken St.', 'Lergravsparken St.', 10)
    
	, ('9A', 'Glostrup Station', 'Rødovre Centrum', 1)
	, ('9A', 'Brøndbyvester', 'Rødovre Centrum', 2)
	, ('9A', 'Brøndbyøster', 'Rødovre Centrum', 3)
	, ('9A', 'Rødovre Centrum', 'Rødovre Centrum', 4)
	, ('9A', 'Husum Torv', 'Rødovre Centrum', 5)
	, ('9A', 'Nørrebro St.', 'Rødovre Centrum', 6)
	, ('9A', 'Rigshospitalet', 'Rødovre Centrum', 7)
	, ('9A', 'Svanemøllen St.', 'Rødovre Centrum', 8)
	, ('9A', 'Hellerup St.', 'Rødovre Centrum', 9)
	, ('9A', 'Ordrup', 'Rødovre Centrum', 10)
    
	, ('350S', 'Ballerup St.', 'Lindevang', 1)
	, ('350S', 'Måløv', 'Lindevang', 2)
	, ('350S', 'Herlev St.', 'Lindevang', 3)
	, ('350S', 'Husum Torv', 'Lindevang', 4)
	, ('350S', 'Bispebjerg Hospital', 'Lindevang', 5)
	, ('350S', 'Nørrebro St.', 'Lindevang', 6)
	, ('350S', 'Forum', 'Lindevang', 7)
	, ('350S', 'Frederiksberg St.', 'Lindevang', 8)
	, ('350S', 'Fasanvej St.', 'Lindevang', 9)
	, ('350S', 'Lindevang', 'Lindevang', 10)
    
	, ('250S', 'Bella Center', 'Langgade St.', 1)
	, ('250S', 'Ørestad St.', 'Langgade St.', 2)
	, ('250S', 'Amager Strand', 'Langgade St.', 3)
	, ('250S', 'Islands Brygge', 'Langgade St.', 4)
	, ('250S', 'Christianshavn', 'Langgade St.', 5)
	, ('250S', 'Københavns Hovedbanegård', 'Langgade St.', 6)
	, ('250S', 'Rådhuspladsen', 'Langgade St.', 7)
	, ('250S', 'Forum', 'Langgade St.', 8)
	, ('250S', 'Søndre Fasanvej', 'Langgade St.', 9)
	, ('250S', 'Langgade St.', 'Langgade St.', 10)
    
	, ('7A', 'Rødovre St.', 'Hellerup St.', 1)
	, ('7A', 'Hvidovre Hospital', 'Hellerup St.', 2)
	, ('7A', 'Valby St.', 'Hellerup St.', 3)
	, ('7A', 'Enghave Plads', 'Hellerup St.', 4)
	, ('7A', 'Nørrebro St.', 'Hellerup St.', 5)
	, ('7A', 'Rigshospitalet', 'Hellerup St.', 6)
	, ('7A', 'Trianglen', 'Hellerup St.', 7)
	, ('7A', 'Østerport St.', 'Hellerup St.', 8)
	, ('7A', 'Nordhavn St.', 'Hellerup St.', 9)
	, ('7A', 'Hellerup St.', 'Hellerup St.', 10)
    
	, ('33', 'Sundbyvester Plads', 'Rødovre Centrum', 1)
	, ('33', 'Amagerbro St.', 'Rødovre Centrum', 2)
	, ('33', 'Christianshavn', 'Rødovre Centrum', 3)
	, ('33', 'Københavns Hovedbanegård', 'Rødovre Centrum', 4)
	, ('33', 'Rådhuspladsen', 'Rødovre Centrum', 5)
	, ('33', 'Nørreport', 'Rødovre Centrum', 6)
	, ('33', 'Forum', 'Rødovre Centrum', 7)
	, ('33', 'Flintholm St.', 'Rødovre Centrum', 8)
	, ('33', 'Vanløse St.', 'Rødovre Centrum', 9)
	, ('33', 'Rødovre Centrum', 'Rødovre Centrum', 10)
    ;

INSERT INTO Ride(StartDate, StartTime, Duration, IDCardNumber, BusLineName, StartStop, EndStop) 
VALUES
	  ('2024-11-01', '08:30:00', 15, '234567 890 234 567 2', '6A', 'Københavns Hovedbanegård', 'DTU')
	, ('2024-11-01', '09:00:00', 10, '345678 901 345 678 3', '6A', 'Rådhuspladsen', 'Nørreport')
	, ('2024-11-02', '07:45:00', 20, '456789 012 456 789 4', '6A', 'Kastrup', 'Københavns Hovedbanegård')
	, ('2024-11-02', '08:15:00', 12, '567890 123 567 890 5', '300S', 'Københavns Hovedbanegård', 'Lyngby St.')
	, ('2024-11-02', '08:45:00', 25, '678901 234 678 901 6', '150S', 'Nørreport', 'Ordrup')
	, ('2024-11-02', '09:15:00', 30, '789012 345 789 012 7', '600S', 'Amagerbro St.', 'Vestamager')
	, ('2024-11-02', '09:30:00', 18, '890123 456 890 123 8', '5C', 'Kastrup', 'Lufthavnen')
	, ('2024-11-02', '10:00:00', 14, '901234 567 901 234 9', '1A', 'Vestamager', 'Gentofte St.')
	, ('2024-11-02', '10:15:00', 12, '012345 678 012 345 1', '2A', 'Tingbjerg', 'Kongens Nytorv')
	, ('2024-11-02', '11:00:00', 35, '123456 789 123 456 2', '9A', 'Glostrup Station', 'Ordrup')
	, ('2024-11-02', '11:30:00', 15, '234567 890 234 567 3', '350S', 'Vanløse St.', 'Lindevang')
	, ('2024-11-02', '12:00:00', 28, '345678 901 345 678 4', '250S', 'Bella Center', 'Langgade St.')
	, ('2024-11-02', '12:15:00', 20, '456789 012 456 789 5', '7A', 'Ordrup', 'Enghave Plads')
	, ('2024-11-02', '12:30:00', 18, '567890 123 567 890 6', '33', 'Sundbyvester Plads', 'Vanløse St.')
	, ('2024-11-02', '13:00:00', 15, '678901 234 678 901 7', '6A', 'Flintholm St.', 'Københavns Hovedbanegård')
	, ('2024-11-03', '08:00:00', 25, '789012 345 789 012 8', '300S', 'Københavns Hovedbanegård', 'Holte St.')
	, ('2024-11-03', '08:20:00', 18, '890123 456 890 123 9', '150S', 'Rådhuspladsen', 'Trianglen')
	, ('2024-11-03', '08:30:00', 20, '901234 567 901 234 1', '600S', 'DR Byen', 'Kastrup')
	, ('2024-11-03', '08:45:00', 15, '012345 678 012 345 2', '5C', 'Rådhuspladsen', 'Amagerbro St.')
	, ('2024-11-03', '09:00:00', 15, '123456 789 123 456 3', '1A', 'Nordhavn St.', 'Hvidovrevej')
	, ('2024-11-03', '09:15:00', 10, '234567 890 234 567 4', '2A', 'Brønshøj Torv', 'Amagerbro St.')
	, ('2024-11-03', '09:30:00', 25, '345678 901 345 678 5', '9A', 'Rødovre Centrum', 'Rigshospitalet')
	, ('2024-11-03', '09:45:00', 18, '456789 012 456 789 6', '350S', 'Frederiksberg St.', 'Måløv')
	, ('2024-11-03', '10:00:00', 16, '567890 123 567 890 7', '250S', 'Bella Center', 'Amager Strand')
	, ('2024-11-03', '10:15:00', 30, '678901 234 678 901 8', '7A', 'Hvidovre Hospital', 'Nørrebro St.')
	, ('2024-11-03', '10:30:00', 20, '789012 345 789 012 9', '33', 'Sundbyvester Plads', 'Christianshavn')
	, ('2024-11-03', '11:00:00', 12, '890123 456 890 123 1', '6A', 'Københavns Hovedbanegård', 'Frederiksberg Allé')
	, ('2024-11-03', '11:15:00', 30, '901234 567 901 234 2', '300S', 'Københavns Hovedbanegård', 'Svanemøllen St.')
	, ('2024-11-03', '11:30:00', 10, '012345 678 012 345 3', '150S', 'Trianglen', 'Hellerup St.')
	, ('2024-11-03', '12:00:00', 18, '123456 789 123 456 4', '600S', 'Christianshavn', 'Tårnby St.')
	, ('2024-11-03', '12:15:00', 12, '234567 890 234 567 5', '5C', 'Lufthavnen', 'Kastrup')
	, ('2024-11-03', '12:30:00', 10, '345678 901 345 678 6', '1A', 'Friheden St.', 'Gentofte St.')
	, ('2024-11-03', '12:45:00', 22, '456789 012 456 789 7', '2A', 'Nørrebro St.', 'Kongens Nytorv')
	, ('2024-11-03', '13:00:00', 15, '567890 123 567 890 8', '9A', 'Glostrup Station', 'Bispebjerg Hospital')
	, ('2024-11-03', '13:15:00', 25, '678901 234 678 901 9', '350S', 'Ballerup St.', 'Nørrebro St.')
	, ('2024-11-03', '13:30:00', 10, '789012 345 789 012 1', '250S', 'Langgade St.', 'Ørestad St.')
	, ('2024-11-03', '14:00:00', 10, '890123 456 890 123 2', '7A', 'Enghave Plads', 'Vanløse St.')
	, ('2024-11-04', '08:15:00', 12, '901234 567 901 234 3', '33', 'Københavns Hovedbanegård', 'Rådhuspladsen')
	, ('2024-11-04', '08:30:00', 12, '012345 678 012 345 4', '6A', 'Nørreport', 'Københavns Hovedbanegård')
	, ('2024-11-04', '08:45:00', 10, '123456 789 123 456 5', '300S', 'Holte St.', 'Svanemøllen St.')
	, ('2024-11-04', '09:00:00', 12, '234567 890 234 567 6', '150S', 'Ordrup', 'Nørreport')
	, ('2024-11-04', '09:30:00', 15, '345678 901 345 678 7', '600S', 'DR Byen', 'Islands Brygge')
	, ('2024-11-04', '09:45:00', 10, '456789 012 456 789 8', '5C', 'Christianshavn', 'Amagerbro St.')
	, ('2024-11-04', '10:00:00', 12, '567890 123 567 890 9', '1A', 'Enghave Plads', 'Friheden St.')
	, ('2024-11-04', '10:30:00', 25, '678901 234 678 901 1', '2A', 'Brønshøj Torv', 'Fælledparken')
	, ('2024-11-04', '10:45:00', 20, '789012 345 789 012 2', '9A', 'Herlev St.', 'Rigshospitalet')
	, ('2024-11-04', '11:00:00', 22, '890123 456 890 123 3', '350S', 'Bispebjerg Hospital', 'Forum')
	, ('2024-11-04', '11:15:00', 28, '901234 567 901 234 4', '250S', 'Amager Strand', 'Rådhuspladsen')
	, ('2024-11-04', '11:30:00', 14, '012345 678 012 345 5', '7A', 'Valby St.', 'Nordhavn St.')
    ;

-- Get all passenger id's where their ride started at the first stop on a bus line.
SELECT DISTINCT R.IDCardNumber FROM Ride R
JOIN BusLine BL
    ON R.BusLineName = BL.BusLineName 
    AND R.StartStop = BL.StopOnBusLine
WHERE BL.StopOrder = 1;

-- Get the name of the bus stop served by the most bus lines.
# Without Counter
SELECT StopOnBusLine, COUNT(*)
FROM BusLine
GROUP BY StopOnBusLine
HAVING COUNT(*) = (
	SELECT MAX(StopCount)
	FROM (
		SELECT COUNT(*) AS StopCount
        FROM BusLine
        GROUP BY StopOnBusLine
	) AS Count
);


-- For each line, get the ID of the passenger who took the ride that lasted longer.
SELECT IDCardNumber, BusLineName, Duration FROM Ride AS OuterRide
WHERE Duration = (
	SELECT MAX(Duration) FROM Ride AS InnerRide
    WHERE InnerRide.BusLineName = OuterRide.BusLineName);
# Erhm det her giver alle id'er der har taget den længste tur på en BusLine og ikke kun en enkelt. Tænker det var det de ville have. Even tho der ikke står "passengers" men "passenger". Men altså hvad nu hvis der var flere der havde kørt den samme tid du forstår yeh

# The ID of the passengers who never took a bus line more than once per day.
SELECT DISTINCT IDCardNumber FROM Ride
GROUP BY StartDate, IDCardNumber
HAVING COUNT(*) = 1;


-- Get the name of the bus stops that are never used, that is, they are neither the start nor the end stop for any ride.
SELECT BusStopName FROM BusStop
WHERE BusStopName NOT IN (SELECT StartStop FROM Ride)
AND BusStopName NOT IN (SELECT EndStop FROM Ride);

-- A trigger that prevents inserting a ride starting and ending at the same stop, or at a stop not served by that line. 
DROP TRIGGER IF EXISTS Ride_Before_Insert;

DELIMITER //
CREATE TRIGGER Ride_Before_Insert
BEFORE INSERT ON Ride
FOR EACH ROW
BEGIN
	# check if StartStop and EndStop is the same
	IF NEW.StartStop = NEW.EndStop
	THEN
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'StartStop and EndStop cannot be the same';
    END IF;
    
    # check if StartStop is served by the given Bus Line
    IF NOT EXISTS (
		SELECT BusStopName FROM BusLine
        WHERE NEW.StartStop = StopOnBusLine AND NEW.BusLineName = BusLineName)
	THEN 
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'The StartStop is not served by the BusLineName';
	END IF;
    
    # check if EndStop is served by the given Bus Line
    IF NOT EXISTS (
		SELECT BusStopName FROM BusLine
        WHERE NEW.EndStop = StopOnBusLine AND NEW.BusLineName = BusLineName)
	THEN 
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'The EndStop is not served by the BusLineName';
	END IF;
END //
DELIMITER ;

-- A function that, given two stops, returns how many lines serve both stops.
DROP FUNCTION IF EXISTS TwoStops;
DELIMITER //
CREATE FUNCTION TwoStops(st1 VARCHAR(50), st2 VARCHAR(50)) RETURNS INT
BEGIN
	DECLARE vAmountServed INT DEFAULT 0;
    SELECT COUNT(DISTINCT s1.BusLineName) 
    INTO vAmountServed
    FROM BusLine s1
    JOIN BusLine s2 ON s1.BusLineName = s2.BusLineName
	WHERE s1.StopOnBusLine = st1 AND s2.StopOnBusLine = st2;
    
    RETURN vAmountServed;
    
END//
DELIMITER ;
DELIMITER //

CREATE PROCEDURE AddStop (IN vBusLineName VARCHAR(45), IN vStopName VARCHAR(45)) 
BEGIN
    DECLARE vStopExists INT DEFAULT 0; -- var to hold StopID
    DECLARE vBusLineExists INT DEFAULT 0;     -- var to hold BusLineID

    main: BEGIN  -- Labeling the main block for use with LEAVE

        -- Check if StopName exists in the BusStop table
        SELECT BusStopName INTO vStopExists FROM BusStop WHERE BusStopName = vStopName;
        IF vStopExists IS NULL THEN
            SELECT 'Stop does not exist in BusStop table' AS Message; -- message that will pop up when stop does not exist
            LEAVE main; -- Exit the procedure
        END IF;

        -- Check if BusLineName exists in the BusLine table
        SELECT BusLineID INTO vBusLineID FROM BusLine WHERE BusLineName = vBusLineName; 
        IF vBusLineID IS NULL THEN
            SELECT 'Bus line does not exist in BusLine table' AS Message;
            LEAVE main; -- Exit the procedure
        END IF;

        -- If stop does exist Check if the stop is already on the bus line's route
        IF EXISTS (
            SELECT 1
            FROM StopsOnLine
            WHERE BusLineID = vBusLineID AND StopID = vStopID
        ) THEN
            SELECT 'Stop already exists on this line' AS Message;
            LEAVE main; -- Exit the procedure if the stop already exists on the line

        ELSE
            -- If it is not on the route, add the new stop
            INSERT INTO StopsOnLine (BusLineID, BusLineName, StopID, StopName, StopOrder)
            VALUES (
                vBusLineID,
                vBusLineName,
                vStopID,
                vStopName,
                (SELECT MAX(StopOrder) + 1 FROM StopsOnLine WHERE BusLineID = vBusLineID)
            );
            SELECT 'Stop added to the route successfully' AS Message;
        END IF; 

    END main;  

END //
DELIMITER ;

CALL AddStop('300s', 'Gl. Holte Øverødvej');

