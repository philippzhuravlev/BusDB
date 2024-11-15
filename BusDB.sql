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
	( AddressID         INT AUTO_INCREMENT -- must be an auto-increment, otherwise you need 4 primary keys
	, Street            VARCHAR(50) 
	, City              VARCHAR(50) 
	, Zipcode           VARCHAR(10) -- would be INT, but some may include locality w/ a dash ("12345-6789")
	, CivicNumber       INT 		-- NB: A number assigned to each plot of land. DK: Matrikelnummer, 5 ints
	, Country           VARCHAR(30) -- in cases users type full country name ("Democratic Republic of Congo")
    , PRIMARY KEY		(AddressID)
    );

CREATE TABLE Passenger
	( IDCardNumber		VARCHAR(20)	-- example used: rejsekort's format ("123456 789 123 456 7"), hence VARCHAR
    , Email				VARCHAR(50) 
    , FirstName			VARCHAR(50) -- also includes middle name
    , LastName			VARCHAR(20)
    , PhoneNumber		VARCHAR(20) -- longest phone number is 17 chars. Varchar due to plus sign in "+45" etc
    , AddressID			INT
    , PRIMARY KEY		(IDCardNumber)
    , FOREIGN KEY		(AddressID)			REFERENCES 	Address(AddressID)
    ); 

CREATE TABLE BusStop
	( BusStopName		VARCHAR(50) -- longest stop name in DK is 43 chars
	, GPSCoordinates	POINT		-- MySQL datatype, has latitude, longitude (and a 3rd, irrelevant value)
    , PRIMARY KEY		(BusStopName)
	);

CREATE TABLE BusLine
	( BusLineName		VARCHAR(5) 	-- e.g. 6A, 300S
	, FinalDestination	VARCHAR(50) -- compare 6A Buddinge vs 6A Emdrup Torv
    , StopOrder			INT			-- 1., 2., 3. stop etc. Primary key since busline contains all stops on lines
    , BusStop			VARCHAR(50)	-- all bus stops on the line, so DTU -> Lyngby -> Hellerup etc
    , PRIMARY KEY		(BusLineName, FinalDestination, StopOrder)
    , FOREIGN KEY		(FinalDestination)	REFERENCES	BusStop(BusStopName)
    , FOREIGN KEY		(BusStop)			REFERENCES	BusStop(BusStopName)
	);

CREATE TABLE Ride
	( StartDate     	DATE
	, StartTime     	TIME
	, Duration      	INT
	, IDCardNumber   	VARCHAR(20)
	, BusLineName   	VARCHAR(5)
    , FinalDestination	VARCHAR(50)
	, StartStop     	VARCHAR(50)
	, EndStop       	VARCHAR(50)
    , PRIMARY KEY		(StartDate, StartTime, IDCardNumber)
	, FOREIGN KEY		(IDCardNumber)	REFERENCES Passenger(IDCardNumber)
	, FOREIGN KEY 		(BusLineName)	REFERENCES BusLine(BusLineName)
    , FOREIGN KEY		(FinalDestination)	REFERENCES	BusStop(BusStopName)
	, FOREIGN KEY 		(StartStop)		REFERENCES BusStop(BusStopName)
	, FOREIGN KEY 		(EndStop)		REFERENCES BusStop(BusStopName)
	);
    
INSERT INTO Address(Street, City, Zipcode, CivicNumber, Country)
VALUES 
	  ('Nørrebrogade', 'Copenhagen', '2200', '10001', 'Denmark')
	, ('Frederiksborggade', 'Copenhagen', '1360', '10002', 'Denmark')
	, ('Østerbrogade', 'Copenhagen', '2100', '10003', 'Denmark')
	, ('Vesterbrogade', 'Copenhagen', '1620', '10004', 'Denmark')
	, ('Amagerbrogade', 'Copenhagen', '2300', '10005', 'Denmark')
	, ('Strandgade', 'Copenhagen', '1401', '10006', 'Denmark')
	, ('Rådhuspladsen', 'Copenhagen', '1550', '10007', 'Denmark')
	, ('Kongens Nytorv', 'Copenhagen', '1050', '10008', 'Denmark')
	, ('Gothersgade', 'Copenhagen', '1123', '10009', 'Denmark')
	, ('Nytorv', 'Copenhagen', '1450', '10010', 'Denmark')
	, ('Skt. Peders Stræde', 'Copenhagen', '1453', '10011', 'Denmark')
	, ('Studiestræde', 'Copenhagen', '1455', '10012', 'Denmark')
	, ('Frederiksholms Kanal', 'Copenhagen', '1220', '10013', 'Denmark')
	, ('Lille Strandstræde', 'Copenhagen', '1255', '10014', 'Denmark')
	, ('Borgergade', 'Copenhagen', '1300', '10015', 'Denmark')
	, ('Gammel Kongevej', 'Copenhagen', '1610', '10016', 'Denmark')
	, ('Enghavevej', 'Copenhagen', '1674', '10017', 'Denmark')
	, ('Fælledvej', 'Copenhagen', '2200', '10018', 'Denmark')
	, ('Vestergade', 'Copenhagen', '1456', '10019', 'Denmark')
	, ('Pilestræde', 'Copenhagen', '1112', '10020', 'Denmark')
	, ('Toldbodgade', 'Copenhagen', '1253', '10021', 'Denmark')
	, ('Landemærket', 'Copenhagen', '1119', '10022', 'Denmark')
	, ('Slagelsegade', 'Copenhagen', '2100', '10034', 'Denmark')
	, ('Lilla Torg', 'Malmö', '21134', NULL, 'Sweden')
	, ('Adelgade', 'Copenhagen', '1304', '10024', 'Denmark')
	, ('Store Kongensgade', 'Copenhagen', '1264', NULL, 'Denmark')
	, ('Sølvgade', 'Copenhagen', '1307', '10026', 'Denmark')
	, ('Rigensgade', 'Copenhagen', '1316', NULL, 'Denmark')
	, ('Krystalgade', 'Copenhagen', '1172', '1028', 'Denmark')
	, ('Vingårdsstræde', 'Copenhagen', '1070', '10029', 'Denmark')
	, ('Skindergade', 'Copenhagen', '1159', '10030', 'Denmark')
	, ('Læderstræde', 'Copenhagen', '1201', '10031', 'Denmark')
	, ('Fiolstræde', 'Copenhagen', '1171', '10032', 'Denmark')
	, ('Klosterstræde', 'Copenhagen', '1157', '10033', 'Denmark')
	, ('Rådhusstræde', 'Copenhagen', '1466', '10034', 'Denmark')
	, ('Vestervoldgade', 'Copenhagen', '1552', '10035', 'Denmark')
	, ('Hyskenstræde', 'Copenhagen', '1207', '10036', 'Denmark')
	, ('Stormgade', 'Copenhagen', '1470', '10037', 'Denmark')
	, ('Langebrogade', 'Copenhagen', '1411', '10038', 'Denmark')
	, ('Christianshavn', 'Copenhagen', '1400', '10039', 'Denmark')
	, ('Nyhavn', 'Copenhagen', '1051', '10040', 'Denmark')
	, ('Bremerholm', 'Copenhagen', '1069', NULL, 'Denmark')
	, ('Holmens Kanal', 'Copenhagen', '1060', NULL, 'Denmark')
	, ('Amagertorv', 'Copenhagen', '1160', '10043', 'Denmark')
	, ('Bredgade', 'Copenhagen', '1260', '10044', 'Denmark')
	, ('Hauser Plads', 'Copenhagen', '1127', '10045', 'Denmark')
	, ('Axeltorv', 'Copenhagen', '1609', '10046', 'Denmark')
	, ('Farvergade', 'Copenhagen', '1463', NULL, 'Denmark')
	, ('Antonigade', 'Copenhagen', '1106', '10048', 'Denmark')
	, ('Tullinsgade', 'Copenhagen', '1618', '10049', 'Denmark')
	, ('Elmegade', 'Copenhagen', '2200', '10050', 'Denmark')
	, ('Sønder Boulevard', 'Copenhagen', '1720', '10051', 'Denmark')
	, ('Frederiks Allé', 'Copenhagen', '2200', '10052', 'Denmark')
	, ('Godthåbsvej', 'Copenhagen', '2000', '10053', 'Denmark')
	, ('Griffenfeldsgade', 'Copenhagen', '2200', '10054', 'Denmark')
	, ('Langelinie Allé', 'Copenhagen', '2100', '10055', 'Denmark')
	, ('Dag Hammarskjölds Allé', 'Copenhagen', '2100', NULL, 'Denmark')
	, ('Sankt Hans Gade', 'Copenhagen', '2200', '10057', 'Denmark')
	, ('Istedgade', 'Copenhagen', '1650', '10058', 'Denmark')
	, ('Halmtorvet', 'Copenhagen', '1700', '10059', 'Denmark')
	, ('Kalvebod Brygge', 'Copenhagen', '1560', '10060', 'Denmark')
	, ('Vester Voldgade', 'Copenhagen', '1552', '10061', 'Denmark')
	, ('Flensborggade', 'Copenhagen', '1669', NULL, 'Denmark')
	, ('Valby Langgade', 'Copenhagen', '2500', NULL, 'Denmark')
	, ('Vigerslev Allé', 'Copenhagen', '2500', NULL, 'Denmark')
	, ('Bernstorffsgade', 'Copenhagen', '1577', '10066', 'Denmark')
    ;

INSERT INTO Passenger(IDCardNumber, Email, FirstName, LastName, PhoneNumber, AddressID)
VALUES 
	  ('123456 789 123 456 1', 'johndoe@gmail.com', 'John', 'Doe', '+4512345678', 1)
	, ('234567 890 234 567 2', 'janedoe@hotmail.com', 'Jane', 'Doe', '4522345678', 2)
	, ('345678 901 345 678 3', 'alice@gmail.com', 'Alice', 'Smith', '+4533345678', 3)
	, ('456789 012 456 789 4', 'nielslarsen@gmail.com', 'Niels', 'Larsen', '+4523041579', 4)
	, ('567890 123 567 890 5', 'henrikhansen@hotmail.com', 'Henrik', 'Hansen', '+4521938746', 5)
	, ('678901 234 678 901 6', 'annasorensen@gmail.com', 'Anna', 'Sørensen', '+4525678129', 6)
	, ('789012 345 789 012 7', 'peterjensen@gmail.com', 'Peter', 'Jensen', '+4526789301', 7)
	, ('890123 456 890 123 8', 'karinnielsen@gmail.com', 'Karin', 'Nielsen', '+4523456781', 8)
	, ('901234 567 901 234 9', 'andersandersen@hotmail.dk', 'Anders', 'Andersen', '+4529085672', 9)
	, ('012345 678 012 345 1', 'lisbethnielsen@gmail.com', 'Lisbeth', 'Nielsen', '+4523902178', 10)
	, ('123456 789 123 456 2', 'jørgenschmidt@gmail.dk', 'Jørgen', 'Schmidt', '+4529481567', 11)
	, ('234567 890 234 567 3', 'poulchristensen@gmail.com', 'Poul', 'Christensen', '+4521379865', 12)
	, ('345678 901 345 678 4', 'jemalali@gmail.se', 'Jemal', 'Ali', '+46701234567', 13)
	, ('456789 012 456 789 5', 'mariapedersen@gmail.com', 'Maria', 'Pedersen', '+4529684321', 14)
	, ('567890 123 567 890 6', 'karlnielsen@hotmail.com', 'Karl', 'Nielsen', '+4521839567', 15)
	, ('678901 234 678 901 7', 'henrikhansen@gmail.com', 'Henrik', 'Hansen', '+4523092187', 16)
	, ('789012 345 789 012 8', 'mortenmadsen@gmail.dk', 'Morten', 'Madsen', '+4527653412', 17)
	, ('890123 456 890 123 9', 'ingeborglarsen@hotmail.com', 'Ingeborg', 'Larsen', '+4524738956', 18)
	, ('901234 567 901 234 1', 'susannejensen@gmail.com', 'Susanne', 'Jensen', '+4529471258', 19)
	, ('012345 678 012 345 2', 'clausnielsen@hotmail.dk', 'Claus', 'Nielsen', '+4523512478', 20)
	, ('123456 789 123 456 3', 'karennielsen@gmail.com', 'Karen', 'Nielsen', '+4523945871', 21)
	, ('234567 890 234 567 4', 'ingedamgaard@gmail.dk', 'Inge', 'Damgaard', '+4520784561', 22)
	, ('345678 901 345 678 5', 'larskristensen@hotmail.com', 'Lars', 'Kristensen', '+4529873456', 23)
	, ('456789 012 456 789 6', 'leilaalrashid@hotmail.se', 'Leila', 'AlRashid', '+46701234567', 24)
	, ('567890 123 567 890 7', 'michaeljensen@gmail.com', 'Michael', 'Jensen', '+4523871645', 25)
	, ('678901 234 678 901 8', 'annkristensen@gmail.dk', 'Ann', 'Kristensen', '+4520146987', 26)
	, ('789012 345 789 012 9', 'jacobolesen@hotmail.dk', 'Jacob', 'Olesen', '+4525698342', 27)
	, ('890123 456 890 123 1', 'katrinedamgaard@gmail.com', 'Katrine', 'Damgaard', '+4529801347', 28)
	, ('901234 567 901 234 2', 'sorennielsen@gmail.com', 'Søren', 'Nielsen', '+4523168475', 29)
	, ('012345 678 012 345 3', 'piasorensen@gmail.dk', 'Pia', 'Sørensen', '+4529083476', 30)
	, ('123456 789 123 456 4', 'brianthomsen@gmail.com', 'Brian', 'Thomsen', '+4521978432', 31)
	, ('234567 890 234 567 5', 'stinenielsen@hotmail.com', 'Stine', 'Nielsen', '+4523890147', 32)
	, ('345678 901 345 678 6', 'jørgennielsen@gmail.dk', 'Jørgen', 'Nielsen', '+4521765839', 33)
	, ('456789 012 456 789 7', 'linuslauthomsen@gmai.com', 'Linus', 'Lau Thomsen', '+4523908217', 34)
	, ('567890 123 567 890 8', 'anneolsen@gmail.com', 'Anne', 'Olsen', '+4521459873', 35)
	, ('678901 234 678 901 9', 'pernielsen@gmail.com', 'Per', 'Nielsen', '+4526087453', 36)
	, ('789012 345 789 012 1', 'kathrineholm@hotmail.dk', 'Kathrine', 'Holm', '+4523978562', 37)
	, ('890123 456 890 123 2', 'johannesenlund@gmail.com', 'Johanne', 'Svendson', '+4527834065', 38)
	, ('901234 567 901 234 3', 'kimnielsen@gmail.dk', 'Kim', 'Nielsen', '+4521938475', 39)
	, ('012345 678 012 345 4', 'maibrittnielsen@hotmail.dk', 'Maibritt', 'Nielsen', '+4524902837', 40)
	, ('123456 789 123 456 5', 'jørgenlarsen@gmail.com', 'Jørgen', 'Larsen', '+4520394856', 41)
	, ('234567 890 234 567 6', 'mariannepedersen@gmail.dk', 'Marianne', 'Pedersen', '+4527163049', 42)
	, ('345678 901 345 678 7', 'thomasjensen@gmail.com', 'Thomas', 'Jensen', '+4529871304', 43)
	, ('456789 012 456 789 8', 'kennethjensen@hotmail.com', 'Kenneth', 'Jensen', '+393595356721', 44)
	, ('567890 123 567 890 9', 'bettinasorensen@hotmail.com', 'Bettina', 'Sørensen', '+4520367849', 45)
	, ('678901 234 678 901 1', 'henrikmadsen@gmail.com', 'Henrik', 'Madsen', '+4521587394', 46)
	, ('789012 345 789 012 2', 'annetheresejensen@gmail.dk', 'Anne-Therese', 'Jensen', '+4523904872', 47)
	, ('890123 456 890 123 3', 'leifjohansen@gmail.com', 'Leif', 'Johansen', '+4521768394', 48)
	, ('901234 567 901 234 4', 'johnnielsen@gmail.dk', 'John', 'Nielsen', '+4528375912', 49)
	, ('012345 678 012 345 5', 'ninarasmussen@hotmail.dk', 'Nina', 'Rasmussen', '+4526103978', 50)
	, ('123456 789 123 456 6', 'svendnielsen@gmail.com', 'Svend', 'Nielsen', '+4520183467', 51)
	, ('234567 890 234 567 7', 'tineholm@gmail.dk', 'Tine', 'Holm', '+4529375016', 52)
	, ('345678 901 345 678 8', 'mariannielsen@hotmail.com', 'Marian', 'Nielsen', '+4526785014', 53)
	, ('456789 012 456 789 9', 'kirstenolsen@gmail.com', 'Kirsten', 'Olsen', '+4521938467', 54)
	, ('567890 123 567 890 1', 'joakimlarsen@gmail.com', 'Joakim', 'Larsen', '+4526079873', 55)
	; 


INSERT INTO BusStop(BusStopName, GPSCoordinates)
VALUES
-- NB: ST_GeomFromText SQL statement is necessary for MySQL to interpret the insert as "geometric"/GPS data
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

INSERT INTO BusLine(BusLineName, FinalDestination, BusStop, StopOrder)
VALUES
      ('6A', 'Gladsaxe Trafikplads', 'Københavns Hovedbanegård', 1)
    , ('6A', 'Gladsaxe Trafikplads', 'Rådhuspladsen', 2)
    , ('6A', 'Gladsaxe Trafikplads', 'Nørreport', 3)
    , ('6A', 'Gladsaxe Trafikplads', 'Forum', 4)
    , ('6A', 'Gladsaxe Trafikplads', 'Frederiksberg Allé', 5)
    , ('6A', 'Gladsaxe Trafikplads', 'Åboulevard', 6)
    , ('6A', 'Gladsaxe Trafikplads', 'Falkoner Allé', 7)
    , ('6A', 'Gladsaxe Trafikplads', 'Flintholm St.', 8)
    , ('6A', 'Gladsaxe Trafikplads', 'Bellahøj', 9)
    , ('6A', 'Gladsaxe Trafikplads', 'Gladsaxe Trafikplads', 10)

	, ('300S', 'Holte St.', 'Københavns Hovedbanegård', 1)
    , ('300S', 'Holte St.', 'Rådhuspladsen', 2)
    , ('300S', 'Holte St.', 'Nørreport', 3)
    , ('300S', 'Holte St.', 'Østerport St.', 4)
    , ('300S', 'Holte St.', 'Svanemøllen St.', 5)
    , ('300S', 'Holte St.', 'Ryparken', 6)
    , ('300S', 'Holte St.', 'Lundtofteparken', 7)
    , ('300S', 'Holte St.', 'DTU', 8)
    , ('300S', 'Holte St.', 'Lyngby St.', 9)
    , ('300S', 'Holte St.', 'Holte St.', 10)

	, ('150S', 'Ordrup', 'Nørreport', 1)
    , ('150S', 'Ordrup', 'DTU', 2)
    , ('150S', 'Ordrup', 'Rådhuspladsen', 3)
    , ('150S', 'Ordrup', 'Københavns Hovedbanegård', 4)
    , ('150S', 'Ordrup', 'Trianglen', 5)
    , ('150S', 'Ordrup', 'Østerbrogade', 6)
    , ('150S', 'Ordrup', 'Svanemøllen St.', 7)
    , ('150S', 'Ordrup', 'Ryparken', 8)
    , ('150S', 'Ordrup', 'Hellerup St.', 9)
    , ('150S', 'Ordrup', 'Ordrup', 10)

	, ('600S', 'Kastrup', 'Nørreport', 1)
    , ('600S', 'Kastrup', 'Københavns Hovedbanegård', 2)
    , ('600S', 'Kastrup', 'Rådhuspladsen', 3)
    , ('600S', 'Kastrup', 'Amagerbro St.', 4)
    , ('600S', 'Kastrup', 'Islands Brygge', 5)
    , ('600S', 'Kastrup', 'DR Byen', 6)
    , ('600S', 'Kastrup', 'Universitetet St.', 7)
    , ('600S', 'Kastrup', 'Vestamager', 8)
    , ('600S', 'Kastrup', 'Tårnby St.', 9)
    , ('600S', 'Kastrup', 'Kastrup', 10)

    , ('5C', 'Herlev St.', 'Lufthavnen', 1)
    , ('5C', 'Herlev St.', 'Kastrup', 2)
    , ('5C', 'Herlev St.', 'Amager Strand', 3)
    , ('5C', 'Herlev St.', 'Amagerbro St.', 4)
    , ('5C', 'Herlev St.', 'Christianshavn', 5)
    , ('5C', 'Herlev St.', 'Rådhuspladsen', 6)
    , ('5C', 'Herlev St.', 'Nørreport', 7)
    , ('5C', 'Herlev St.', 'Nørrebro St.', 8)
    , ('5C', 'Herlev St.', 'Bispebjerg St.', 9)
    , ('5C', 'Herlev St.', 'Herlev St.', 10)
    
    , ('1A', 'Gentofte St.', 'Avedøre Station', 1)
    , ('1A', 'Gentofte St.', 'Friheden St.', 2)
    , ('1A', 'Gentofte St.', 'Hvidovrevej', 3)
    , ('1A', 'Gentofte St.', 'Valby St.', 4)
    , ('1A', 'Gentofte St.', 'Enghave Plads', 5)
    , ('1A', 'Gentofte St.', 'Københavns Hovedbanegård', 6)
    , ('1A', 'Gentofte St.', 'Trianglen', 7)
    , ('1A', 'Gentofte St.', 'Nordhavn St.', 8)
    , ('1A', 'Gentofte St.', 'Hellerup St.', 9)
    , ('1A', 'Gentofte St.', 'Gentofte St.', 10)

    , ('2A', 'Lergravsparken St.', 'Tingbjerg', 1)
    , ('2A', 'Lergravsparken St.', 'Brønshøj Torv', 2)
    , ('2A', 'Lergravsparken St.', 'Nørrebro St.', 3)
    , ('2A', 'Lergravsparken St.', 'Fælledparken', 4)
    , ('2A', 'Lergravsparken St.', 'Trianglen', 5)
    , ('2A', 'Lergravsparken St.', 'Østerport St.', 6)
    , ('2A', 'Lergravsparken St.', 'Kongens Nytorv', 7)
    , ('2A', 'Lergravsparken St.', 'Christianshavn', 8)
    , ('2A', 'Lergravsparken St.', 'Amagerbro St.', 9)
    , ('2A', 'Lergravsparken St.', 'Lergravsparken St.', 10)

    
    , ('9A', 'Rødovre Centrum', 'Glostrup Station', 1)
    , ('9A', 'Rødovre Centrum', 'Brøndbyvester', 2)
    , ('9A', 'Rødovre Centrum', 'Brøndbyøster', 3)
    , ('9A', 'Rødovre Centrum', 'Rødovre Centrum', 4)
    , ('9A', 'Rødovre Centrum', 'Husum Torv', 5)
    , ('9A', 'Rødovre Centrum', 'Nørrebro St.', 6)
    , ('9A', 'Rødovre Centrum', 'Rigshospitalet', 7)
    , ('9A', 'Rødovre Centrum', 'Svanemøllen St.', 8)
    , ('9A', 'Rødovre Centrum', 'Hellerup St.', 9)
    , ('9A', 'Rødovre Centrum', 'Ordrup', 10)
    
    , ('350S', 'Lindevang', 'Ballerup St.', 1)
    , ('350S', 'Lindevang', 'Måløv', 2)
    , ('350S', 'Lindevang', 'Herlev St.', 3)
    , ('350S', 'Lindevang', 'Husum Torv', 4)
    , ('350S', 'Lindevang', 'Bispebjerg Hospital', 5)
    , ('350S', 'Lindevang', 'Nørrebro St.', 6)
    , ('350S', 'Lindevang', 'Forum', 7)
    , ('350S', 'Lindevang', 'Frederiksberg St.', 8)
    , ('350S', 'Lindevang', 'Fasanvej St.', 9)
    , ('350S', 'Lindevang', 'Lindevang', 10)

	, ('250S', 'Langgade St.', 'Bella Center', 1)
    , ('250S', 'Langgade St.', 'Ørestad St.', 2)
    , ('250S', 'Langgade St.', 'Amager Strand', 3)
    , ('250S', 'Langgade St.', 'Islands Brygge', 4)
    , ('250S', 'Langgade St.', 'Christianshavn', 5)
    , ('250S', 'Langgade St.', 'Københavns Hovedbanegård', 6)
    , ('250S', 'Langgade St.', 'Rådhuspladsen', 7)
    , ('250S', 'Langgade St.', 'Forum', 8)
    , ('250S', 'Langgade St.', 'Søndre Fasanvej', 9)
    , ('250S', 'Langgade St.', 'Langgade St.', 10)
    
    , ('7A', 'Hellerup St.', 'Rødovre St.', 1)
    , ('7A', 'Hellerup St.', 'Hvidovre Hospital', 2)
    , ('7A', 'Hellerup St.', 'Valby St.', 3)
    , ('7A', 'Hellerup St.', 'Enghave Plads', 4)
    , ('7A', 'Hellerup St.', 'Nørrebro St.', 5)
    , ('7A', 'Hellerup St.', 'Rigshospitalet', 6)
    , ('7A', 'Hellerup St.', 'Trianglen', 7)
    , ('7A', 'Hellerup St.', 'Østerport St.', 8)
    , ('7A', 'Hellerup St.', 'Nordhavn St.', 9)
    , ('7A', 'Hellerup St.', 'Hellerup St.', 10)

	, ('33', 'Rødovre Centrum', 'Sundbyvester Plads', 1)
    , ('33', 'Rødovre Centrum', 'Amagerbro St.', 2)
    , ('33', 'Rødovre Centrum', 'Christianshavn', 3)
    , ('33', 'Rødovre Centrum', 'Københavns Hovedbanegård', 4)
    , ('33', 'Rødovre Centrum', 'Rådhuspladsen', 5)
    , ('33', 'Rødovre Centrum', 'Nørreport', 6)
    , ('33', 'Rødovre Centrum', 'Forum', 7)
    , ('33', 'Rødovre Centrum', 'Flintholm St.', 8)
    , ('33', 'Rødovre Centrum', 'Vanløse St.', 9)
    , ('33', 'Rødovre Centrum', 'Rødovre Centrum', 10)
    ;

INSERT INTO Ride(StartDate, StartTime, Duration, IDCardNumber, BusLineName, FinalDestination, StartStop, EndStop) 
VALUES
	  ('2024-11-01', '08:30:00', 15, '012345 678 012 345 5', '6A', 'Gladsaxe Trafikplads', 'Københavns Hovedbanegård', 'DTU')
	, ('2024-11-01', '09:00:00', 10, '456789 012 456 789 4', '6A', 'Gladsaxe Trafikplads', 'Rådhuspladsen', 'Nørreport')
	, ('2024-11-02', '07:45:00', 20, '456789 012 456 789 4', '6A', 'Gladsaxe Trafikplads', 'Kastrup', 'Københavns Hovedbanegård')
	, ('2024-11-02', '08:15:00', 12, '567890 123 567 890 5', '300S', 'Holte St.', 'Københavns Hovedbanegård', 'Lyngby St.')
	, ('2024-11-02', '08:45:00', 25, '678901 234 678 901 6', '150S', 'Ordrup', 'Nørreport', 'Ordrup')
	, ('2024-11-02', '09:15:00', 30, '789012 345 789 012 7', '600S', 'Kastrup', 'Amagerbro St.', 'Vestamager')
	, ('2024-11-02', '09:30:00', 18, '890123 456 890 123 8', '5C', 'Herlev St.', 'Kastrup', 'Lufthavnen')
	, ('2024-11-02', '10:00:00', 14, '012345 678 012 345 2', '1A', 'Gentofte St.', 'Vestamager', 'Gentofte St.')
	, ('2024-11-02', '10:15:00', 12, '012345 678 012 345 2', '2A', 'Lergravsparken St.', 'Tingbjerg', 'Kongens Nytorv')
	, ('2024-11-02', '11:00:00', 35, '234567 890 234 567 2', '9A', 'Rødovre Centrum', 'Glostrup Station', 'Ordrup')
	, ('2024-11-02', '11:30:00', 15, '234567 890 234 567 3', '350S', 'Lindevang', 'Vanløse St.', 'Lindevang')
	, ('2024-11-02', '12:00:00', 28, '567890 123 567 890 5', '250S', 'Langgade St.', 'Bella Center', 'Langgade St.')
	, ('2024-11-02', '12:15:00', 20, '456789 012 456 789 5', '7A', 'Hellerup St.', 'Ordrup', 'Enghave Plads')
	, ('2024-11-02', '12:30:00', 18, '567890 123 567 890 6', '33', 'Rødovre Centrum', 'Sundbyvester Plads', 'Vanløse St.')
	, ('2024-11-02', '13:00:00', 15, '678901 234 678 901 7', '6A', 'Gladsaxe Trafikplads', 'Flintholm St.', 'Københavns Hovedbanegård')
	, ('2024-11-03', '08:00:00', 25, '567890 123 567 890 5', '300S', 'Holte St.', 'Københavns Hovedbanegård', 'Holte St.')
	, ('2024-11-03', '08:20:00', 18, '890123 456 890 123 9', '150S', 'Ordrup', 'Rådhuspladsen', 'Trianglen')
	, ('2024-11-03', '08:30:00', 20, '678901 234 678 901 7', '600S', 'Kastrup', 'DR Byen', 'Kastrup')
	, ('2024-11-03', '08:45:00', 15, '012345 678 012 345 2', '5C', 'Herlev St.', 'Rådhuspladsen', 'Amagerbro St.')
	, ('2024-11-03', '09:00:00', 15, '123456 789 123 456 3', '1A', 'Gentofte St.', 'Nordhavn St.', 'Hvidovrevej')
	, ('2024-11-03', '09:15:00', 10, '678901 234 678 901 1', '2A', 'Lergravsparken St.', 'Brønshøj Torv', 'Amagerbro St.')
	, ('2024-11-03', '09:30:00', 25, '890123 456 890 123 9', '9A', 'Rødovre Centrum', 'Rødovre Centrum', 'Rigshospitalet')
	, ('2024-11-03', '09:45:00', 18, '456789 012 456 789 6', '350S', 'Lindevang', 'Frederiksberg St.', 'Måløv')
	, ('2024-11-03', '10:00:00', 16, '567890 123 567 890 7', '250S', 'Langgade St.', 'Bella Center', 'Amager Strand')
	, ('2024-11-03', '10:15:00', 30, '567890 123 567 890 7', '7A', 'Hellerup St.', 'Hvidovre Hospital', 'Nørrebro St.')
	, ('2024-11-03', '10:30:00', 20, '890123 456 890 123 9', '33', 'Rødovre Centrum', 'Vanløse St.', 'Christianshavn')
	, ('2024-11-03', '11:00:00', 12, '890123 456 890 123 1', '6A', 'Gladsaxe Trafikplads', 'Københavns Hovedbanegård', 'Frederiksberg Allé')
	, ('2024-11-03', '11:15:00', 30, '012345 678 012 345 3', '300S', 'Holte St.', 'Københavns Hovedbanegård', 'Svanemøllen St.')
	, ('2024-11-03', '11:30:00', 10, '012345 678 012 345 3', '150S', 'Ordrup', 'Trianglen', 'Hellerup St.')
	, ('2024-11-03', '12:00:00', 18, '123456 789 123 456 4', '600S', 'Kastrup', 'Christianshavn', 'Tårnby St.')
	, ('2024-11-03', '12:15:00', 12, '234567 890 234 567 5', '5C', 'Herlev St.', 'Lufthavnen', 'Kastrup')
	, ('2024-11-03', '12:30:00', 10, '345678 901 345 678 6', '1A', 'Gentofte St.', 'Friheden St.', 'Gentofte St.')
	, ('2024-11-03', '12:45:00', 22, '012345 678 012 345 3', '2A', 'Lergravsparken St.', 'Nørrebro St.', 'Kongens Nytorv')
	, ('2024-11-03', '13:00:00', 15, '345678 901 345 678 6', '9A', 'Rødovre Centrum', 'Glostrup Station', 'Bispebjerg Hospital')
	, ('2024-11-03', '13:15:00', 25, '234567 890 234 567 2', '350S', 'Lindevang', 'Ballerup St.', 'Nørrebro St.')
	, ('2024-11-03', '13:30:00', 10, '789012 345 789 012 1', '250S', 'Langgade St.', 'Langgade St.', 'Ørestad St.')
	, ('2024-11-03', '14:00:00', 10, '234567 890 234 567 2', '7A', 'Hellerup St.', 'Enghave Plads', 'Vanløse St.')
	, ('2024-11-04', '08:15:00', 12, '901234 567 901 234 3', '33', 'Rødovre Centrum', 'Københavns Hovedbanegård', 'Rådhuspladsen')
	, ('2024-11-04', '08:30:00', 12, '678901 234 678 901 1', '6A', 'Gladsaxe Trafikplads', 'Nørreport', 'Københavns Hovedbanegård')
	, ('2024-11-04', '08:45:00', 10, '123456 789 123 456 5', '300S', 'Holte St.', 'Svanemøllen St.', 'Holte St.')
	, ('2024-11-04', '09:00:00', 12, '234567 890 234 567 6', '150S', 'Ordrup', 'Nørreport', 'Nørreport')
	, ('2024-11-04', '09:30:00', 15, '345678 901 345 678 6', '600S', 'Kastrup', 'DR Byen', 'Islands Brygge')
	, ('2024-11-04', '09:45:00', 10, '012345 678 012 345 2', '5C', 'Herlev St.', 'Christianshavn', 'Amagerbro St.')
	, ('2024-11-04', '10:00:00', 12, '012345 678 012 345 2', '1A', 'Gentofte St.', 'Enghave Plads', 'Friheden St.')
	, ('2024-11-04', '10:30:00', 25, '678901 234 678 901 1', '2A', 'Lergravsparken St.', 'Brønshøj Torv', 'Fælledparken')
	, ('2024-11-04', '10:45:00', 20, '123456 789 123 456 5', '9A', 'Rødovre Centrum', 'Herlev St.', 'Rigshospitalet')
	, ('2024-11-04', '11:00:00', 22, '345678 901 345 678 6', '350S', 'Lindevang', 'Bispebjerg Hospital', 'Forum')
	, ('2024-11-04', '11:15:00', 28, '901234 567 901 234 4', '250S', 'Langgade St.', 'Amager Strand', 'Rådhuspladsen')
	, ('2024-11-04', '11:30:00', 14, '345678 901 345 678 6', '7A', 'Hellerup St.', 'Valby St.', 'Nordhavn St.')
	;


-- get all passenger id's where their ride started at the first stop on a bus line.
SELECT DISTINCT R.IDCardNumber FROM Ride R
JOIN BusLine BL
    ON R.BusLineName = BL.BusLineName 
    AND R.StartStop = BL.BusStop
WHERE BL.StopOrder = 1;

-- get the name of the bus stop served by the most bus lines.
SELECT BusStop, COUNT(*)
FROM BusLine
GROUP BY BusStop
HAVING COUNT(*) = (
	SELECT MAX(StopCount)
	FROM (
		SELECT COUNT(*) AS StopCount
        FROM BusLine
        GROUP BY BusStop
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
        WHERE NEW.StartStop = BusStop AND NEW.BusLineName = BusLineName)
	THEN 
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'The StartStop is not served by the BusLineName';
	END IF;
    
    -- check if EndStop is served by the given Bus Line
    IF NOT EXISTS (
		SELECT BusStopName FROM BusLine
        WHERE NEW.EndStop = BusStop AND NEW.BusLineName = BusLineName)
	THEN 
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'The EndStop is not served by the BusLineName';
	END IF;
END //
DELIMITER ;

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
	WHERE s1.BusStop = st1 AND s2.BusStop = st2;
    
    RETURN vAmountServed;
    
END//
DELIMITER ;

DROP PROCEDURE IF EXISTS AddStop;
DELIMITER //
CREATE PROCEDURE AddStop (IN vBusLineName VARCHAR(45), IN vStopName VARCHAR(45)) 
BEGIN
    DECLARE vStopExists VARCHAR(45) DEFAULT NULL; -- var to hold StopID
    DECLARE vBusLineExists VARCHAR(45) DEFAULT NULL;     -- var to hold BusLineID
    DECLARE vFinalDestination VARCHAR(50);
    DECLARE vMaxStopOrder INT;

    main: BEGIN  -- Labeling the main block for use with LEAVE

        -- Check if StopName exists in the BusStop table
        SELECT BusStopName INTO vStopExists FROM BusStop WHERE BusStopName = vStopName;
        IF vStopExists IS NULL THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Stop does not exist in BusStop table';
            LEAVE main;
        END IF;

        -- Check if BusLineName exists in the BusLine table
        SELECT BusLineName INTO vBusLineExists FROM BusLine WHERE BusLineName = vBusLineName
        LIMIT 1;
        IF vBusLineExists IS NULL THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Bus line does not exist in BusLine table';
            LEAVE main;
        END IF;

        -- If stop does exist Check if the stop is already on the bus line's route
        IF EXISTS (
            SELECT 1
            FROM BusLine
            WHERE BusLineName = vBusLineName AND BusStop = vStopName
        ) THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Stop already exists on this line';
            LEAVE main;
        ELSE
            -- If it is not on the route, add the new stop
            SELECT FinalDestination, MAX(StopOrder) + 1
			INTO vFinalDestination, vMaxStopOrder
			FROM BusLine
			WHERE BusLineName = vBusLineName;
            
            INSERT INTO BusLine (BusLineName, FinalDestination, StopOrder, BusStop)
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
