DROP DATABASE IF EXISTS BusDB;
CREATE DATABASE BusDB;
USE BusDB;

SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS Ride;
DROP TABLE IF EXISTS StopsOnLine;
DROP TABLE IF EXISTS BusStop;
DROP TABLE IF EXISTS BusLine;
DROP TABLE IF EXISTS Passenger;
DROP TABLE IF EXISTS Address;

SET FOREIGN_KEY_CHECKS = 1;


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
    #, StopName			VARCHAR(45)
    #, FOREIGN KEY		(StopName)		REFERENCES	BusStop(StopName)
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
	('Lilla Torg', 'Malmö', '21134', '2001', 'SwedenEw'),
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


INSERT INTO Passenger (Email, Fullname, PhoneNumber, AddressID)
VALUES 
('johndoe@example.com', 'John Doe', '+4512345678', 1),
('janedoe@example.com', 'Jane Doe', '4522345678', 2),
('alice@example.com', 'Alice Smith', '+4533345678', 3),
('nielslarsen@gmail.com', 'Niels Larsen', '+4523041579', 4),
('henrikhansen@hotmail.com', 'Henrik Hansen', '+4521938746', 5),
('annasorensen@gmail.com', 'Anna Sørensen', '+4525678129', 6),
('jegharboereniminkaelder@gmail.com', 'Peter Jensen', '+4526789301', 7),
('karinnielsen@gmail.com', 'Karin Nielsen', '+4523456781', 8),
('andersandersen@hotmail.dk', 'Anders Andersen', '+4529085672', 9),
('lisbethnielsen@gmail.com', 'Lisbeth Nielsen', '+4523902178', 10),
('jørgenschmidt@gmail.dk', 'Jørgen Schmidt', '+4529481567', 11),
('poulchristensen@gmail.com', 'Poul Christensen', '+4521379865', 12),
('wallahhabbibi@gmail.se','Jemal Ali','+46701234567',13),
('mariapedersen@gmail.com', 'Maria Pedersen', '+4529684321', 14),
('karlnielsen@hotmail.com', 'Karl Nielsen', '+4521839567', 15),
('henrikhansen@gmail.com', 'Henrik Hansen', '+4523092187', 16),
('mortenmadsen@gmail.dk', 'Morten Madsen', '+4527653412', 17),
('ingeborglarsen@hotmail.com', 'Ingeborg Larsen', '+4524738956', 18),
('susannejensen@gmail.com', 'Susanne Jensen', '+4529471258', 19),
('clausnielsen@hotmail.dk', 'Claus Nielsen', '+4523512478', 20),
('karennielsen@gmail.com', 'Karen Nielsen', '+4523945871', 21),
('ingedamgaard@gmail.dk', 'Inge Damgaard', '+4520784561', 22),
('larskristensen@hotmail.com', 'Lars Kristensen', '+4529873456', 23),
('falafelking2024@hotmail.se','Leila AlRashid','+46701234567',24),
('michaeljensen@gmail.com', 'Michael Jensen', '+4523871645', 25),
('annkristensen@gmail.dk', 'Ann Kristensen', '+4520146987', 26),
('jacobolesen@hotmail.dk', 'Jacob Olesen', '+4525698342', 27),
('katrinedamgaard@gmail.com', 'Katrine Damgaard', '+4529801347', 28),
('sorennielsen@gmail.com', 'Søren Nielsen', '+4523168475', 29),
('piasorensen@gmail.dk', 'Pia Sørensen', '+4529083476', 30),
('brianthomsen@gmail.com', 'Brian Thomsen', '+4521978432', 31),
('stinenielsen@hotmail.com', 'Stine Nielsen', '+4523890147', 32),
('jørgennielsen@gmail.dk', 'Jørgen Nielsen', '+4521765839', 33),
('linuslauthomsen@gmai.com','Linus Lau Thomsen','+4523908217',34),
('anneolsen@gmail.com', 'Anne Olsen', '+4521459873', 35),
('pernielsen@gmail.com', 'Per Nielsen', '+4526087453', 36),
('kathrineholm@hotmail.dk', 'Kathrine Holm', '+4523978562', 37),
('johannesenlund@gmail.com', 'Johanne Svendson', '+4527834065', 38),
('kimnielsen@gmail.dk', 'Kim Nielsen', '+4521938475', 39),
('maibrittnielsen@hotmail.dk', 'Maibritt Nielsen', '+4524902837', 40),
('jørgenlarsen@gmail.com', 'Jørgen Larsen', '+4520394856', 41),
('mariannepedersen@gmail.dk', 'Marianne Pedersen', '+4527163049', 42),
('thomasjensen@gmail.com', 'Thomas Jensen', '+4529871304', 43),
('Giovanni Meroni','giom@dtu.dk','+393595356721',44),
('bettinasorensen@hotmail.com', 'Bettina Sørensen', '+4520367849', 45),
('henrikmadsen@gmail.com', 'Henrik Madsen', '+4521587394', 46),
('annetheresejensen@gmail.dk', 'Anne-Therese Jensen', '+4523904872', 47),
('leifjohansen@gmail.com', 'Leif Johansen', '+4521768394', 48),
('johnnielsen@gmail.dk', 'John Nielsen', '+4528375912', 49),
('ninarasmussen@hotmail.dk', 'Nina Rasmussen', '+4526103978', 50),
('svendnielsen@gmail.com', 'Svend Nielsen', '+4520183467', 51),
('tineholm@gmail.dk', 'Tine Holm', '+4529375016', 52),
('mariannielsen@hotmail.com', 'Marian Nielsen', '+4526785014', 53),
('s246246@student.dtu.dk','Philipp Zhuravlev','+4551443708',54),
('mathiasjensen@gmail.com', 'Mathias Jensen', '+4520173645', 55),
('annettehansen@hotmail.com', 'Annette Hansen', '+4529183745', 56),
('fredeholm@gmail.dk', 'Frede Holm', '+4520148392', 57),
('lenejohansen@gmail.com', 'Lene Johansen', '+4529876453', 58),
('tinalarsen@hotmail.dk', 'Tina Larsen', '+4526384917', 59),
('vibekenielsen@gmail.com', 'Vibeke Nielsen', '+4523901754', 60),
('mikkelnielsen@gmail.dk', 'Mikkel Nielsen', '+4524971308', 61),
('hannelarsen@hotmail.com', 'Hanne Larsen', '+4521785409', 62),
('mortennielsen@gmail.com', 'Morten Nielsen', '+4520891346', 63),
('s226381@student.dtu.dk','Carl Christian Tegner','+4521293598',64),
('andersmadsen@gmail.com', 'Anders Madsen', '+4529301456', 65),
('s244968@student.dtu.dk','Christian Seestern Hyllested','+4560535254',66),
('s246544@student.dtu.dk','Akkash Vigneswaran','+4520672487',67),
('birgitnielsen@hotmail.dk', 'Birgit Nielsen', '+4520934875', 68);


INSERT INTO BusStop (StopName, GPSCoordinates)
VALUES 
    ('Københavns Hovedbanegård', ST_GeomFromText('POINT(55.6761 12.5683)')),
    ('Rådhuspladsen', ST_GeomFromText('POINT(55.6759 12.5655)')),
    ('Nørreport', ST_GeomFromText('POINT(55.6838 12.5713)')),
    ('Forum', ST_GeomFromText('POINT(55.6805 12.5523)')),
    ('Frederiksberg Allé', ST_GeomFromText('POINT(55.6732 12.5469)')),
    ('Åboulevard', ST_GeomFromText('POINT(55.6837 12.5448)')),
    ('Falkoner Allé', ST_GeomFromText('POINT(55.6811 12.5354)')),
    ('Flintholm St.', ST_GeomFromText('POINT(55.6821 12.5103)')),
    ('Bellahøj', ST_GeomFromText('POINT(55.7067 12.5233)')),
    ('Gladsaxe Trafikplads', ST_GeomFromText('POINT(55.7333 12.4894)')),
    ('Østerport St.', ST_GeomFromText('POINT(55.6910 12.5939)')),
    ('Svanemøllen St.', ST_GeomFromText('POINT(55.7026 12.5778)')),
    ('Ryparken', ST_GeomFromText('POINT(55.7096 12.5735)')),
    ('Lundtofteparken', ST_GeomFromText('POINT(55.7616 12.5084)')),
    ('DTU', ST_GeomFromText('POINT(55.7856 12.5214)')),
    ('Lyngby St.', ST_GeomFromText('POINT(55.7705 12.5033)')),
    ('Holte St.', ST_GeomFromText('POINT(55.8144 12.4758)')),
    ('Trianglen', ST_GeomFromText('POINT(55.6988 12.5836)')),
    ('Østerbrogade', ST_GeomFromText('POINT(55.7052 12.5795)')),
    ('Hellerup St.', ST_GeomFromText('POINT(55.7298 12.5644)')),
    ('Ordrup', ST_GeomFromText('POINT(55.7476 12.5665)')),
    ('Amagerbro St.', ST_GeomFromText('POINT(55.6612 12.6031)')),
    ('Islands Brygge', ST_GeomFromText('POINT(55.6631 12.5899)')),
    ('DR Byen', ST_GeomFromText('POINT(55.6587 12.5916)')),
    ('Universitetet St.', ST_GeomFromText('POINT(55.6506 12.5902)')),
    ('Vestamager', ST_GeomFromText('POINT(55.6316 12.5768)')),
    ('Tårnby St.', ST_GeomFromText('POINT(55.6305 12.5992)')),
    ('Kastrup', ST_GeomFromText('POINT(55.6179 12.6553)')),
    ('Lufthavnen', ST_GeomFromText('POINT(55.6181 12.6568)')),
    ('Amager Strand', ST_GeomFromText('POINT(55.6669 12.6253)')),
    ('Christianshavn', ST_GeomFromText('POINT(55.6735 12.5914)')),
    ('Nørrebro St.', ST_GeomFromText('POINT(55.7008 12.5353)')),
    ('Bispebjerg St.', ST_GeomFromText('POINT(55.7116 12.5407)')),
    ('Herlev St.', ST_GeomFromText('POINT(55.7247 12.4442)')),
    ('Avedøre Station', ST_GeomFromText('POINT(55.6177 12.4746)')),
    ('Friheden St.', ST_GeomFromText('POINT(55.6422 12.4763)')),
    ('Hvidovrevej', ST_GeomFromText('POINT(55.6547 12.4878)')),
    ('Valby St.', ST_GeomFromText('POINT(55.6617 12.5014)')),
    ('Enghave Plads', ST_GeomFromText('POINT(55.6642 12.5483)')),
    ('Nordhavn St.', ST_GeomFromText('POINT(55.7110 12.5913)')),
    ('Gentofte St.', ST_GeomFromText('POINT(55.7518 12.5481)')),
    ('Tingbjerg', ST_GeomFromText('POINT(55.7111 12.4927)')),
    ('Brønshøj Torv', ST_GeomFromText('POINT(55.7033 12.5045)')),
    ('Fælledparken', ST_GeomFromText('POINT(55.7011 12.5781)')),
    ('Kongens Nytorv', ST_GeomFromText('POINT(55.6781 12.5821)')),
    ('Lergravsparken St.', ST_GeomFromText('POINT(55.6639 12.6202)')),
    ('Glostrup Station', ST_GeomFromText('POINT(55.6663 12.4049)')),
    ('Brøndbyvester', ST_GeomFromText('POINT(55.6518 12.4117)')),
    ('Brøndbyøster', ST_GeomFromText('POINT(55.6693 12.4204)')),
    ('Rødovre Centrum', ST_GeomFromText('POINT(55.6844 12.4538)')),
    ('Husum Torv', ST_GeomFromText('POINT(55.7118 12.4772)')),
    ('Rigshospitalet', ST_GeomFromText('POINT(55.6954 12.5705)')),
    ('Bispebjerg Hospital', ST_GeomFromText('POINT(55.7098 12.5422)')),
    ('Ballerup St.', ST_GeomFromText('POINT(55.7317 12.3655)')),
    ('Måløv', ST_GeomFromText('POINT(55.7479 12.3279)')),
    ('Frederiksberg St.', ST_GeomFromText('POINT(55.6780 12.5307)')),
    ('Fasanvej St.', ST_GeomFromText('POINT(55.6808 12.5188)')),
    ('Lindevang', ST_GeomFromText('POINT(55.6836 12.5056)')),
    ('Bella Center', ST_GeomFromText('POINT(55.6374 12.5775)')),
    ('Ørestad St.', ST_GeomFromText('POINT(55.6290 12.5760)')),
    ('Søndre Fasanvej', ST_GeomFromText('POINT(55.6587 12.4974)')),
    ('Langgade St.', ST_GeomFromText('POINT(55.6622 12.4891)')),
    ('Rødovre St.', ST_GeomFromText('POINT(55.6823 12.4531)')),
    ('Hvidovre Hospital', ST_GeomFromText('POINT(55.6546 12.4845)')),
    ('Sundbyvester Plads', ST_GeomFromText('POINT(55.6543 12.6028)')),
    ('Vanløse St.', ST_GeomFromText('POINT(55.6836 12.4876)'));

INSERT INTO BusLine (BusLineName, FinalDestination) 
VALUES 
    ('6A', 'Københavns Hovedbanegård'), 
    ('300S', 'Københavns Hovedbanegård'), 
    ('150S', 'Nørreport'), 
    ('600S', 'Nørreport'),
    ('5C', 'Lufthavnen'), 
    ('1A', 'Avedøre Station'), 
    ('2A', 'Tingbjerg'), 
    ('9A', 'Glostrup Station'), 
    ('350S', 'Ballerup St.'), 
    ('250S', 'Bella Center'),
    ('7A', 'Rødovre St.'), 
    ('33', 'Sundbyvester Plads');

INSERT INTO StopsOnLine (BusLineID, BusLineName, StopID, StopName, StopOrder) # 6A
VALUES
    #-- 6A Line
    (1, '6A', 1, 'Københavns Hovedbanegård', 1),
    (1, '6A', 2, 'Rådhuspladsen', 2),
    (1, '6A', 3, 'Nørreport', 3),
    (1, '6A', 4, 'Forum', 4),
    (1, '6A', 5, 'Frederiksberg Allé', 5),
    (1, '6A', 6, 'Åboulevard', 6),
    (1, '6A', 7, 'Falkoner Allé', 7),
    (1, '6A', 8, 'Flintholm St.', 8),
    (1, '6A', 9, 'Bellahøj', 9),
    (1, '6A', 10, 'Gladsaxe Trafikplads', 10),

   # -- 300S Line
    (2, '300S', 1, 'Københavns Hovedbanegård', 1),
    (2, '300S', 2, 'Rådhuspladsen', 2),
    (2, '300S', 3, 'Nørreport', 3),
    (2, '300S', 11, 'Østerport St.', 4),
    (2, '300S', 12, 'Svanemøllen St.', 5),
    (2, '300S', 13, 'Ryparken', 6),
    (2, '300S', 14, 'Lundtofteparken', 7),
    (2, '300S', 15, 'DTU', 8),
    (2, '300S', 16, 'Lyngby St.', 9),
    (2, '300S', 17, 'Holte St.', 10),

    #-- 150S Line
    (3, '150S', 3, 'Nørreport', 1),
    (3, '150S', 15, 'DTU', 2),
    (3, '150S', 2, 'Rådhuspladsen', 3),
    (3, '150S', 1, 'Københavns Hovedbanegård', 4),
    (3, '150S', 18, 'Trianglen', 5),
    (3, '150S', 19, 'Østerbrogade', 6),
    (3, '150S', 12, 'Svanemøllen St.', 7),
    (3, '150S', 13, 'Ryparken', 8),
    (3, '150S', 20, 'Hellerup St.', 9),
    (3, '150S', 21, 'Ordrup', 10),

    #-- 600S Line
    (4, '600S', 3, 'Nørreport', 1),
    (4, '600S', 1, 'Københavns Hovedbanegård', 2),
    (4, '600S', 2, 'Rådhuspladsen', 3),
    (4, '600S', 22, 'Amagerbro St.', 4),
    (4, '600S', 23, 'Islands Brygge', 5),
    (4, '600S', 24, 'DR Byen', 6),
    (4, '600S', 25, 'Universitetet St.', 7),
    (4, '600S', 26, 'Vestamager', 8),
    (4, '600S', 27, 'Tårnby St.', 9),
    (4, '600S', 28, 'Kastrup', 10),

   # -- 5C Line
    (5, '5C', 29, 'Lufthavnen', 1),
    (5, '5C', 28, 'Kastrup', 2),
    (5, '5C', 30, 'Amager Strand', 3),
    (5, '5C', 22, 'Amagerbro St.', 4),
    (5, '5C', 31, 'Christianshavn', 5),
    (5, '5C', 2, 'Rådhuspladsen', 6),
    (5, '5C', 3, 'Nørreport', 7),
    (5, '5C', 32, 'Nørrebro St.', 8),
    (5, '5C', 33, 'Bispebjerg St.', 9),
    (5, '5C', 34, 'Herlev St.', 10),

    #-- 1A Line
    (6, '1A', 35, 'Avedøre Station', 1),
    (6, '1A', 36, 'Friheden St.', 2),
    (6, '1A', 37, 'Hvidovrevej', 3),
    (6, '1A', 38, 'Valby St.', 4),
    (6, '1A', 39, 'Enghave Plads', 5),
    (6, '1A', 1, 'Københavns Hovedbanegård', 6),
    (6, '1A', 18, 'Trianglen', 7),
    (6, '1A', 40, 'Nordhavn St.', 8),
    (6, '1A', 20, 'Hellerup St.', 9),
    (6, '1A', 41, 'Gentofte St.', 10),

   # -- 2A Line
    (7, '2A', 42, 'Tingbjerg', 1),
    (7, '2A', 43, 'Brønshøj Torv', 2),
    (7, '2A', 32, 'Nørrebro St.', 3),
    (7, '2A', 44, 'Fælledparken', 4),
    (7, '2A', 18, 'Trianglen', 5),
    (7, '2A', 11, 'Østerport St.', 6),
    (7, '2A', 45, 'Kongens Nytorv', 7),
    (7, '2A', 31, 'Christianshavn', 8),
    (7, '2A', 22, 'Amagerbro St.', 9),
    (7, '2A', 46, 'Lergravsparken St.', 10),

   # -- 9A Line
    (8, '9A', 47, 'Glostrup Station', 1),
    (8, '9A', 48, 'Brøndbyvester', 2),
    (8, '9A', 49, 'Brøndbyøster', 3),
    (8, '9A', 50, 'Rødovre Centrum', 4),
    (8, '9A', 51, 'Husum Torv', 5),
    (8, '9A', 32, 'Nørrebro St.', 6),
    (8, '9A', 52, 'Rigshospitalet', 7),
    (8, '9A', 12, 'Svanemøllen St.', 8),
    (8, '9A', 20, 'Hellerup St.', 9),
    (8, '9A', 21, 'Ordrup', 10),

   # -- 350S Line
    (9, '350S', 54, 'Ballerup St.', 1),
    (9, '350S', 55, 'Måløv', 2),
    (9, '350S', 34, 'Herlev St.', 3),
    (9, '350S', 51, 'Husum Torv', 4),
    (9, '350S', 53, 'Bispebjerg Hospital', 5),
    (9, '350S', 32, 'Nørrebro St.', 6),
    (9, '350S', 4, 'Forum', 7),
    (9, '350S', 56, 'Frederiksberg St.', 8),
    (9, '350S', 57, 'Fasanvej St.', 9),
    (9, '350S', 58, 'Lindevang', 10),

    #-- 250S Line
    (10, '250S', 59, 'Bella Center', 1),
    (10, '250S', 60, 'Ørestad St.', 2),
    (10, '250S', 30, 'Amager Strand', 3),
    (10, '250S', 23, 'Islands Brygge', 4),
    (10, '250S', 31, 'Christianshavn', 5),
    (10, '250S', 1, 'Københavns Hovedbanegård', 6),
    (10, '250S', 2, 'Rådhuspladsen', 7),
    (10, '250S', 4, 'Forum', 8),
    (10, '250S', 61, 'Søndre Fasanvej', 9),
    (10, '250S', 62, 'Langgade St.', 10),

    #-- 7A Line
    (11, '7A', 63, 'Rødovre St.', 1),
    (11, '7A', 64, 'Hvidovre Hospital', 2),
    (11, '7A', 38, 'Valby St.', 3),
    (11, '7A', 39, 'Enghave Plads', 4),
    (11, '7A', 32, 'Nørrebro St.', 5),
    (11, '7A', 52, 'Rigshospitalet', 6),
    (11, '7A', 18, 'Trianglen', 7),
    (11, '7A', 11, 'Østerport St.', 8),
    (11, '7A', 40, 'Nordhavn St.', 9),
    (11, '7A', 20, 'Hellerup St.', 10),

    #-- 33 Line
    (12, '33', 65, 'Sundbyvester Plads', 1),
    (12, '33', 22, 'Amagerbro St.', 2),
    (12, '33', 31, 'Christianshavn', 3),
    (12, '33', 1, 'Københavns Hovedbanegård', 4),
    (12, '33', 2, 'Rådhuspladsen', 5),
    (12, '33', 3, 'Nørreport', 6),
    (12, '33', 4, 'Forum', 7),
    (12, '33', 8, 'Flintholm St.', 8),
    (12, '33', 66, 'Vanløse St.', 9),
    (12, '33', 50, 'Rødovre Centrum', 10);


INSERT INTO Ride (StartDate, StartTime, Duration, PassengerID, BusLineName, StartStop, EndStop)
VALUES 
    ('2024-11-01', '08:30:00', 15, 1, '6A', 'Københavns Hovedbanegård', 'DTU'),
    ('2024-11-01', '09:00:00', 10, 2, '6A', 'Rådhuspladsen', 'Nørreport'),
    ('2024-11-02', '07:45:00', 20, 3, '6A', 'DTU', 'Københavns Hovedbanegård'),
    ('2024-11-02', '08:15:00', 12, 4, '300S', 'Københavns Hovedbanegård', 'Lyngby St.'),
    ('2024-11-02', '08:45:00', 25, 5, '150S', 'Nørreport', 'Ordrup'),
    ('2024-11-02', '09:15:00', 30, 6, '600S', 'Amagerbro St.', 'Vestamager'),
    ('2024-11-02', '09:30:00', 18, 7, '5C', 'Christianshavn', 'Lufthavnen'),
    ('2024-11-02', '10:00:00', 14, 8, '1A', 'Valby St.', 'Gentofte St.'),
    ('2024-11-02', '10:15:00', 12, 9, '2A', 'Tingbjerg', 'Kongens Nytorv'),
    ('2024-11-02', '11:00:00', 35, 10, '9A', 'Glostrup Station', 'Ordrup'),
    ('2024-11-02', '11:30:00', 15, 11, '350S', 'Ballerup St.', 'Lindevang'),
    ('2024-11-02', '12:00:00', 28, 12, '250S', 'Bella Center', 'Langgade St.'),
    ('2024-11-02', '12:15:00', 20, 13, '7A', 'Rødovre St.', 'Enghave Plads'),
    ('2024-11-02', '12:30:00', 18, 14, '33', 'Sundbyvester Plads', 'Vanløse St.'),
    ('2024-11-02', '13:00:00', 15, 15, '6A', 'Flintholm St.', 'Københavns Hovedbanegård'),
    ('2024-11-03', '08:00:00', 25, 16, '300S', 'Københavns Hovedbanegård', 'Holte St.'),
    ('2024-11-03', '08:20:00', 18, 17, '150S', 'Rådhuspladsen', 'Trianglen'),
    ('2024-11-03', '08:30:00', 20, 18, '600S', 'DR Byen', 'Kastrup'),
    ('2024-11-03', '08:45:00', 15, 19, '5C', 'Rådhuspladsen', 'Amagerbro St.'),
    ('2024-11-03', '09:00:00', 15, 20, '1A', 'Nordhavn St.', 'Hvidovrevej'),
    ('2024-11-03', '09:15:00', 10, 21, '2A', 'Brønshøj Torv', 'Amagerbro St.'),
    ('2024-11-03', '09:30:00', 25, 22, '9A', 'Rødovre Centrum', 'Rigshospitalet'),
    ('2024-11-03', '09:45:00', 18, 23, '350S', 'Frederiksberg St.', 'Måløv'),
    ('2024-11-03', '10:00:00', 16, 24, '250S', 'Bella Center', 'Amager Strand'),
    ('2024-11-03', '10:15:00', 30, 25, '7A', 'Hvidovre Hospital', 'Nørrebro St.'),
    ('2024-11-03', '10:30:00', 20, 26, '33', 'Sundbyvester Plads', 'Christianshavn'),
    ('2024-11-03', '11:00:00', 12, 27, '6A', 'Københavns Hovedbanegård', 'Frederiksberg Allé'),
    ('2024-11-03', '11:15:00', 30, 28, '300S', 'Københavns Hovedbanegård', 'Svanemøllen St.'),
    ('2024-11-03', '11:30:00', 10, 29, '150S', 'Trianglen', 'Hellerup St.'),
    ('2024-11-03', '12:00:00', 18, 30, '600S', 'Christianshavn', 'Tårnby St.'),
    ('2024-11-03', '12:15:00', 12, 31, '5C', 'Lufthavnen', 'Kastrup'),
    ('2024-11-03', '12:30:00', 10, 32, '1A', 'Friheden St.', 'Gentofte St.'),
    ('2024-11-03', '12:45:00', 22, 33, '2A', 'Nørrebro St.', 'Kongens Nytorv'),
    ('2024-11-03', '13:00:00', 15, 34, '9A', 'Glostrup Station', 'Bispebjerg Hospital'),
    ('2024-11-03', '13:15:00', 25, 35, '350S', 'Ballerup St.', 'Nørrebro St.'),
    ('2024-11-03', '13:30:00', 10, 36, '250S', 'Langgade St.', 'Ørestad St.'),
    ('2024-11-03', '14:00:00', 10, 37, '7A', 'Enghave Plads', 'Vanløse St.'),
    ('2024-11-04', '08:15:00', 12, 38, '33', 'Københavns Hovedbanegård', 'Rådhuspladsen'),
    ('2024-11-04', '08:30:00', 12, 39, '6A', 'Nørreport', 'Københavns Hovedbanegård'),
    ('2024-11-04', '08:45:00', 10, 40, '300S', 'Holte St.', 'Svanemøllen St.'),
    ('2024-11-04', '09:00:00', 12, 41, '150S', 'Ordrup', 'Nørreport'),
    ('2024-11-04', '09:30:00', 15, 42, '600S', 'DR Byen', 'Islands Brygge'),
    ('2024-11-04', '09:45:00', 10, 43, '5C', 'Christianshavn', 'Amagerbro St.'),
    ('2024-11-04', '10:00:00', 12, 44, '1A', 'Enghave Plads', 'Friheden St.'),
    ('2024-11-04', '10:30:00', 25, 45, '2A', 'Brønshøj Torv', 'Fælledparken'),
    ('2024-11-04', '10:45:00', 20, 46, '9A', 'Herlev St.', 'Rigshospitalet'),
    ('2024-11-04', '11:00:00', 22, 47, '350S', 'Bispebjerg Hospital', 'Forum'),
    ('2024-11-04', '11:15:00', 28, 48, '250S', 'Amager Strand', 'Rådhuspladsen'),
    ('2024-11-04', '11:30:00', 14, 49, '7A', 'Valby St.', 'Nordhavn St.'),
    ('2024-11-04', '11:45:00', 15, 50, '33', 'Vanløse St.', 'Nørreport'),
    ('2024-11-04', '12:00:00', 10, 51, '6A', 'Frederiksberg Allé', 'Nørrebro St.'),
    ('2024-11-04', '12:15:00', 18, 52, '300S', 'Ryparken', 'Lyngby St.'),
    ('2024-11-04', '12:30:00', 15, 53, '150S', 'Rådhuspladsen', 'Københavns Hovedbanegård'),
    ('2024-11-04', '12:45:00', 10, 54, '600S', 'Tårnby St.', 'DR Byen'),
    ('2024-11-04', '13:00:00', 15, 55, '5C', 'Amagerbro St.', 'Rådhuspladsen'),
    ('2024-11-04', '13:15:00', 20, 56, '1A', 'Gentofte St.', 'Valby St.'),
    ('2024-11-04', '13:30:00', 25, 57, '2A', 'Amagerbro St.', 'Østerport St.'),
    ('2024-11-04', '13:45:00', 30, 58, '9A', 'Brøndbyvester', 'Ordrup'),
    ('2024-11-04', '14:00:00', 25, 59, '350S', 'Holte St.', 'Frederiksberg St.'),
    ('2024-11-04', '14:15:00', 18, 60, '250S', 'Søndre Fasanvej', 'Bella Center'),
    ('2024-11-05', '08:00:00', 15, 61, '6A', 'Københavns Hovedbanegård', 'Nørreport'),
    ('2024-11-05', '08:15:00', 12, 62, '6A', 'Flintholm St.', 'Forum'),
    ('2024-11-05', '08:30:00', 15, 63, '6A', 'Bellahøj', 'Københavns Hovedbanegård'),
    ('2024-11-05', '09:00:00', 12, 64, '6A', 'Gladsaxe Trafikplads', 'Rådhuspladsen'),
    ('2024-11-05', '09:15:00', 20, 65, '6A', 'Københavns Hovedbanegård', 'Frederiksberg Allé'),
    ('2024-11-05', '09:30:00', 15, 66, '300S', 'Ryparken', 'Lyngby St.'),
    ('2024-11-05', '10:00:00', 22, 1, '300S', 'Nørreport', 'Holte St.'),
    ('2024-11-05', '10:30:00', 28, 2, '300S', 'Svanemøllen St.', 'Københavns Hovedbanegård'),
    ('2024-11-05', '11:00:00', 15, 3, '300S', 'Frederiksberg St.', 'Forum'),
    ('2024-11-05', '11:15:00', 12, 4, '300S', 'Københavns Hovedbanegård', 'DTU'),
    ('2024-11-05', '11:30:00', 10, 5, '300S', 'Rådhuspladsen', 'Svanemøllen St.'),
    ('2024-11-05', '11:45:00', 20, 6, '300S', 'Lyngby St.', 'Københavns Hovedbanegård'),
    ('2024-11-05', '12:00:00', 15, 7, '150S', 'Københavns Hovedbanegård', 'Nørreport'),
    ('2024-11-05', '12:15:00', 18, 8, '150S', 'Nørreport', 'Hellerup St.'),
    ('2024-11-05', '12:30:00', 20, 9, '150S', 'Ordrup', 'Frederiksberg St.'),
    ('2024-11-05', '12:45:00', 15, 10, '150S', 'Frederiksberg St.', 'Københavns Hovedbanegård'),
    ('2024-11-05', '13:00:00', 12, 11, '150S', 'Trianglen', 'DTU'),
    ('2024-11-05', '13:15:00', 25, 12, '600S', 'Amagerbro St.', 'Tårnby St.'),
    ('2024-11-05', '13:30:00', 28, 13, '600S', 'Nørreport', 'Vestamager'),
    ('2024-11-05', '13:45:00', 15, 14, '600S', 'Islands Brygge', 'Københavns Hovedbanegård'),
    ('2024-11-05', '14:00:00', 12, 15, '600S', 'Lufthavnen', 'DR Byen'),
    ('2024-11-05', '14:15:00', 10, 16, '5C', 'Lufthavnen', 'Christianshavn'),
    ('2024-11-05', '14:30:00', 15, 17, '5C', 'Rådhuspladsen', 'Amagerbro St.'),
    ('2024-11-05', '14:45:00', 10, 16, '5C', 'Amager Strand', 'Lufthavnen'),
    ('2024-11-05', '15:00:00', 12, 19, '5C', 'Nørreport', 'Kastrup'),
    ('2024-11-05', '15:15:00', 20, 20, '1A', 'Valby St.', 'Gentofte St.'),
    ('2024-11-05', '15:30:00', 15, 21, '1A', 'Hvidovrevej', 'Nordhavn St.'),
    ('2024-11-05', '15:45:00', 10, 22, '1A', 'Friheden St.', 'Trianglen'),
    ('2024-11-05', '16:00:00', 22, 23, '2A', 'Amagerbro St.', 'Kongens Nytorv'),
    ('2024-11-05', '16:15:00', 30, 24, '2A', 'Tingbjerg', 'Københavns Hovedbanegård'),
    ('2024-11-05', '16:30:00', 25, 25, '9A', 'Rødovre Centrum', 'Fasanvej St.'),
    ('2024-11-05', '16:45:00', 20, 26, '9A', 'Rigshospitalet', 'Bispebjerg St.'),
    ('2024-11-05', '17:00:00', 15, 27, '350S', 'Ballerup St.', 'Frederiksberg St.'),
    ('2024-11-05', '17:15:00', 12, 28, '350S', 'Københavns Hovedbanegård', 'Nørrebro St.'),
    ('2024-11-05', '17:30:00', 10, 29, '250S', 'Islands Brygge', 'Ørestad St.'),
    ('2024-11-05', '17:45:00', 10, 30, '7A', 'Rødovre St.', 'Valby St.'),
    ('2024-11-05', '18:00:00', 15, 31, '33', 'Vanløse St.', 'Sundbyvester Plads'),
    ('2024-11-05', '18:15:00', 12, 32, '33', 'Christianshavn', 'Rådhuspladsen'),
    ('2024-11-05', '18:30:00', 15, 33, '33', 'Amagerbro St.', 'Forum'),
    ('2024-11-05', '18:45:00', 20, 34, '6A', 'Flintholm St.', 'Frederiksberg Allé'),
    ('2024-11-05', '19:00:00', 15, 35, '6A', 'Bellahøj', 'Nørreport'),
    ('2024-11-05', '19:15:00', 20, 36, '300S', 'Nørrebro St.', 'DTU'),
    ('2024-11-05', '19:30:00', 12, 37, '150S', 'Rådhuspladsen', 'Svanemøllen St.'),
    ('2024-11-05', '19:45:00', 10, 38, '5C', 'Amager Strand', 'Christianshavn'),
    ('2024-11-05', '20:00:00', 18, 39, '1A', 'Gentofte St.', 'Hvidovrevej'),
    ('2024-11-05', '20:15:00', 15, 40, '9A', 'Ordrup', 'Glostrup Station'),
    ('2024-11-05', '20:30:00', 12, 41, '350S', 'Ballerup St.', 'Måløv'),
    ('2024-11-05', '20:45:00', 20, 42, '250S', 'Amagerbro St.', 'Bella Center'),
    ('2024-11-05', '21:00:00', 15, 43, '7A', 'Københavns Hovedbanegård', 'Vanløse St.'),
    ('2024-11-05', '21:15:00', 18, 44, '33', 'Christianshavn', 'Sundbyvester Plads'),
    ('2024-11-05', '21:30:00', 10, 45, '6A', 'Frederiksberg Allé', 'Bellahøj'),
    ('2024-11-05', '21:45:00', 22, 46, '6A', 'Nørreport', 'Københavns Hovedbanegård'),
    ('2024-11-05', '22:00:00', 18, 47, '300S', 'Svanemøllen St.', 'Ryparken'),
    ('2024-11-05', '22:15:00', 25, 48, '150S', 'DTU', 'Nørreport'),
    ('2024-11-05', '22:30:00', 30, 49, '600S', 'Lufthavnen', 'DR Byen'),
    ('2024-11-05', '22:45:00', 15, 50, '5C', 'Christianshavn', 'Lufthavnen'),
    ('2024-11-05', '23:00:00', 12, 51, '1A', 'Hvidovrevej', 'Nordhavn St.'),
    ('2024-11-05', '23:15:00', 18, 52, '2A', 'Brønshøj Torv', 'Østerport St.'),
    ('2024-11-05', '23:30:00', 22, 53, '9A', 'Rødovre Centrum', 'Bispebjerg Hospital'),
    ('2024-11-05', '23:45:00', 10, 54, '350S', 'Frederiksberg St.', 'Ballerup St.'),
    ('2024-11-06', '00:00:00', 15, 55, '250S', 'Amager Strand', 'Søndre Fasanvej'),
    ('2024-11-06', '00:15:00', 25, 56, '7A', 'Nørrebro St.', 'Hvidovre Hospital'),
    ('2024-11-06', '00:30:00', 18, 57, '33', 'Rådhuspladsen', 'Vanløse St.'),
    ('2024-11-06', '00:45:00', 20, 58, '6A', 'Flintholm St.', 'Bellahøj'),
    ('2024-11-06', '01:00:00', 15, 59, '6A', 'Gladsaxe Trafikplads', 'Københavns Hovedbanegård'),
    ('2024-11-06', '01:15:00', 10, 60, '300S', 'Holte St.', 'Københavns Hovedbanegård'),
    ('2024-11-06', '01:30:00', 18, 61, '150S', 'Nørreport', 'DTU'),
    ('2024-11-06', '01:45:00', 20, 62, '600S', 'Tårnby St.', 'Amagerbro St.'),
    ('2024-11-06', '02:00:00', 25, 63, '5C', 'Amager Strand', 'Christianshavn'),
    ('2024-11-06', '02:15:00', 18, 64, '1A', 'Gentofte St.', 'Hvidovrevej'),
    ('2024-11-06', '02:30:00', 22, 65, '9A', 'Rigshospitalet', 'Ordrup'),
    ('2024-11-06', '02:30:00', 22, 67, '9A', 'Rigshospitalet', 'Ordrup'),
    ('2024-11-06', '02:45:00', 30, 66, '350S', 'Forum', 'Holte St.'),
    ('2024-11-06', '06:15:00', 15, 7, '6A', 'Københavns Hovedbanegård', 'Nørreport'),
    ('2024-11-06', '06:30:00', 10, 8, '6A', 'Rådhuspladsen', 'Nørreport'),
    ('2024-11-06', '06:45:00', 20, 7, '6A', 'Nørreport', 'Flintholm St.'),
    ('2024-11-06', '07:00:00', 15, 12, '6A', 'Flintholm St.', 'Forum'),
    ('2024-11-06', '07:15:00', 18, 7, '300S', 'Københavns Hovedbanegård', 'Svanemøllen St.'),
    ('2024-11-06', '07:30:00', 10, 19, '300S', 'Svanemøllen St.', 'Nørreport'),
    ('2024-11-06', '07:45:00', 25, 8, '300S', 'Nørreport', 'Ryparken'),
    ('2024-11-06', '08:00:00', 15, 13, '300S', 'Ryparken', 'Holte St.'),
    ('2024-11-06', '08:15:00', 12, 14, '150S', 'Københavns Hovedbanegård', 'Nørreport'),
    ('2024-11-06', '08:30:00', 10, 7, '150S', 'Nørreport', 'Hellerup St.'),
    ('2024-11-06', '08:45:00', 20, 15, '150S', 'Hellerup St.', 'Ordrup'),
    ('2024-11-06', '09:00:00', 15, 7, '150S', 'Ordrup', 'Trianglen'),
    ('2024-11-06', '09:15:00', 18, 17, '600S', 'Amagerbro St.', 'Tårnby St.'),
    ('2024-11-06', '09:30:00', 25, 16, '600S', 'Tårnby St.', 'Vestamager'),
    ('2024-11-06', '09:45:00', 15, 7, '600S', 'Vestamager', 'DR Byen'),
    ('2024-11-06', '10:00:00', 15, 12, '5C', 'Københavns Hovedbanegård', 'Lufthavnen'),
    ('2024-11-06', '10:15:00', 22, 9, '5C', 'Lufthavnen', 'Christianshavn'),
    ('2024-11-06', '10:30:00', 20, 20, '5C', 'Christianshavn', 'Nørreport'),
    ('2024-11-06', '10:45:00', 15, 7, '5C', 'Nørreport', 'Amagerbro St.'),
    ('2024-11-06', '11:00:00', 18, 22, '1A', 'Valby St.', 'Gentofte St.'),
    ('2024-11-06', '11:15:00', 20, 21, '1A', 'Gentofte St.', 'Nordhavn St.'),
    ('2024-11-06', '11:30:00', 10, 10, '2A', 'Brønshøj Torv', 'Tingbjerg'),
    ('2024-11-06', '11:45:00', 12, 7, '2A', 'Tingbjerg', 'Kongens Nytorv'),
    ('2024-11-06', '12:00:00', 25, 8, '9A', 'Glostrup Station', 'Bispebjerg St.'),
    ('2024-11-06', '12:15:00', 20, 11, '9A', 'Bispebjerg St.', 'Rødovre Centrum'),
    ('2024-11-06', '12:30:00', 18, 7, '9A', 'Rødovre Centrum', 'Rigshospitalet'),
    ('2024-11-06', '12:45:00', 22, 9, '350S', 'Ballerup St.', 'Frederiksberg St.'),
    ('2024-11-06', '13:00:00', 10, 13, '350S', 'Frederiksberg St.', 'Forum'),
    ('2024-11-06', '13:15:00', 20, 17, '250S', 'Bella Center', 'Langgade St.'),
    ('2024-11-06', '13:30:00', 12, 7, '250S', 'Langgade St.', 'Ørestad St.'),
    ('2024-11-06', '13:45:00', 25, 9, '250S', 'Ørestad St.', 'Rådhuspladsen'),
    ('2024-11-06', '14:00:00', 18, 14, '7A', 'Rødovre St.', 'Valby St.'),
    ('2024-11-06', '14:15:00', 20, 7, '7A', 'Valby St.', 'Enghave Plads'),
    ('2024-11-06', '14:30:00', 10, 16, '33', 'Christianshavn', 'Sundbyvester Plads'),
    ('2024-11-06', '14:45:00', 15, 18, '33', 'Sundbyvester Plads', 'Amagerbro St.'),
    ('2024-11-06', '15:00:00', 12, 15, '6A', 'Nørreport', 'Københavns Hovedbanegård'),
    ('2024-11-06', '15:15:00', 10, 10, '6A', 'Københavns Hovedbanegård', 'Bellahøj'),
    ('2024-11-06', '15:30:00', 25, 8, '6A', 'Bellahøj', 'Frederiksberg Allé'),
    ('2024-11-06', '15:45:00', 15, 7, '6A', 'Frederiksberg Allé', 'Flintholm St.'),
    ('2024-11-06', '16:00:00', 18, 13, '300S', 'Nørreport', 'Ryparken'),
    ('2024-11-06', '16:15:00', 20, 7, '300S', 'Ryparken', 'DTU'),
    ('2024-11-06', '16:30:00', 10, 11, '300S', 'DTU', 'Lyngby St.'),
    ('2024-11-06', '16:45:00', 15, 16, '300S', 'Lyngby St.', 'Holte St.'),
    ('2024-11-06', '17:00:00', 12, 14, '150S', 'Ordrup', 'Trianglen'),
    ('2024-11-06', '17:15:00', 10, 17, '150S', 'Trianglen', 'Nørreport'),
    ('2024-11-06', '17:30:00', 20, 7, '150S', 'Nørreport', 'Københavns Hovedbanegård'),
    ('2024-11-06', '17:45:00', 18, 9, '600S', 'DR Byen', 'Vestamager'),
    ('2024-11-06', '18:00:00', 15, 22, '600S', 'Vestamager', 'Nørreport'),
    ('2024-11-07', '06:15:00', 15, 7, '6A', 'Nørreport', 'Københavns Hovedbanegård'),
    ('2024-11-07', '06:30:00', 15, 9, '6A', 'Frederiksberg Allé', 'Forum'),
    ('2024-11-07', '06:45:00', 25, 8, '6A', 'Bellahøj', 'Flintholm St.'),
    ('2024-11-07', '07:00:00', 18, 12, '6A', 'Flintholm St.', 'Frederiksberg Allé'),
    ('2024-11-07', '07:15:00', 20, 17, '300S', 'Nørreport', 'Ryparken'),
    ('2024-11-07', '07:30:00', 22, 14, '300S', 'Ryparken', 'Svanemøllen St.'),
    ('2024-11-07', '07:45:00', 12, 7, '300S', 'Lyngby St.', 'Holte St.'),
    ('2024-11-07', '08:00:00', 18, 9, '300S', 'Svanemøllen St.', 'Nørreport'),
    ('2024-11-07', '08:15:00', 25, 18, '150S', 'Ordrup', 'Trianglen'),
    ('2024-11-07', '08:30:00', 10, 10, '150S', 'Trianglen', 'Nørreport'),
    ('2024-11-07', '08:45:00', 15, 7, '150S', 'Nørreport', 'Hellerup St.'),
    ('2024-11-07', '09:00:00', 12, 8, '600S', 'Tårnby St.', 'Vestamager'),
    ('2024-11-07', '09:15:00', 18, 13, '600S', 'Vestamager', 'DR Byen'),
    ('2024-11-07', '09:30:00', 15, 22, '600S', 'Nørreport', 'Lufthavnen'),
    ('2024-11-07', '09:45:00', 25, 7, '5C', 'Christianshavn', 'Amagerbro St.'),
    ('2024-11-07', '10:00:00', 22, 19, '5C', 'Amager Strand', 'Kastrup'),
    ('2024-11-07', '10:15:00', 15, 14, '5C', 'Lufthavnen', 'Nørreport'),
    ('2024-11-07', '10:30:00', 12, 8, '5C', 'Nørreport', 'Amager Strand'),
    ('2024-11-07', '10:45:00', 10, 12, '1A', 'Gentofte St.', 'Valby St.'),
    ('2024-11-07', '11:00:00', 18, 15, '1A', 'Valby St.', 'Nordhavn St.'),
    ('2024-11-07', '11:15:00', 20, 9, '2A', 'Kongens Nytorv', 'Brønshøj Torv'),
    ('2024-11-07', '11:30:00', 10, 7, '2A', 'Brønshøj Torv', 'Nørrebro St.'),
    ('2024-11-07', '11:45:00', 25, 14, '9A', 'Rødovre Centrum', 'Rigshospitalet'),
    ('2024-11-07', '12:00:00', 20, 7, '9A', 'Glostrup Station', 'Nørreport'),
    ('2024-11-07', '12:15:00', 15, 13, '350S', 'Ballerup St.', 'Frederiksberg St.'),
    ('2024-11-07', '12:30:00', 18, 11, '350S', 'Frederiksberg St.', 'Lyngby St.'),
    ('2024-11-07', '12:45:00', 10, 17, '250S', 'Langgade St.', 'Ørestad St.'),
    ('2024-11-07', '13:00:00', 12, 16, '250S', 'Ørestad St.', 'Rådhuspladsen'),
    ('2024-11-07', '13:15:00', 20, 7, '7A', 'Hvidovre Hospital', 'Nordhavn St.'),
    ('2024-11-07', '13:30:00', 15, 18, '7A', 'Nordhavn St.', 'Enghave Plads'),
    ('2024-11-07', '13:45:00', 10, 22, '33', 'Amagerbro St.', 'Sundbyvester Plads'),
    ('2024-11-07', '14:00:00', 22, 10, '33', 'Sundbyvester Plads', 'Christianshavn'),
    ('2024-11-07', '14:15:00', 18, 7, '6A', 'Frederiksberg Allé', 'Bellahøj'),
    ('2024-11-07', '14:30:00', 15, 15, '6A', 'Bellahøj', 'Forum'),
    ('2024-11-07', '14:45:00', 10, 9, '6A', 'Forum', 'Københavns Hovedbanegård'),
    ('2024-11-07', '15:00:00', 18, 7, '6A', 'Københavns Hovedbanegård', 'Nørreport'),
    ('2024-11-07', '15:15:00', 15, 20, '300S', 'Svanemøllen St.', 'Ryparken'),
    ('2024-11-07', '15:30:00', 10, 8, '300S', 'Nørreport', 'Svanemøllen St.'),
    ('2024-11-07', '15:45:00', 22, 17, '300S', 'Ryparken', 'Lyngby St.'),
    ('2024-11-07', '16:00:00', 12, 7, '150S', 'Københavns Hovedbanegård', 'Trianglen'),
    ('2024-11-07', '16:15:00', 25, 12, '150S', 'Trianglen', 'Ordrup'),
    ('2024-11-07', '16:30:00', 20, 19, '600S', 'Vestamager', 'DR Byen'),
    ('2024-11-07', '16:45:00', 18, 11, '600S', 'DR Byen', 'Tårnby St.'),
    ('2024-11-07', '17:00:00', 15, 8, '5C', 'Lufthavnen', 'Christianshavn'),
    ('2024-11-07', '17:15:00', 10, 7, '5C', 'Christianshavn', 'Nørreport'),
    ('2024-11-07', '17:30:00', 18, 13, '1A', 'Hvidovrevej', 'Gentofte St.'),
    ('2024-11-07', '17:45:00', 12, 17, '2A', 'Tingbjerg', 'Kongens Nytorv'),
    ('2024-11-07', '18:00:00', 20, 7, '9A', 'Rigshospitalet', 'Glostrup Station'),
    ('2024-11-08', '06:00:00', 18, 7, '6A', 'Københavns Hovedbanegård', 'Nørreport'),
    ('2024-11-08', '06:15:00', 12, 9, '6A', 'Flintholm St.', 'Forum'),
    ('2024-11-08', '06:30:00', 15, 8, '6A', 'Bellahøj', 'Københavns Hovedbanegård'),
    ('2024-11-08', '06:45:00', 10, 10, '6A', 'Frederiksberg Allé', 'Bellahøj'),
    ('2024-11-08', '07:00:00', 15, 7, '6A', 'Københavns Hovedbanegård', 'Flintholm St.'),
    ('2024-11-08', '07:15:00', 10, 12, '300S', 'Københavns Hovedbanegård', 'Lyngby St.'),
    ('2024-11-08', '07:30:00', 12, 15, '300S', 'Svanemøllen St.', 'Holte St.'),
    ('2024-11-08', '07:45:00', 18, 17, '300S', 'Nørreport', 'DTU'),
    ('2024-11-08', '08:00:00', 10, 7, '300S', 'Lyngby St.', 'Ryparken'),
    ('2024-11-08', '08:15:00', 15, 19, '150S', 'Nørreport', 'Trianglen'),
    ('2024-11-08', '08:30:00', 20, 18, '150S', 'Trianglen', 'Hellerup St.'),
    ('2024-11-08', '08:45:00', 25, 11, '150S', 'Hellerup St.', 'Nørreport'),
    ('2024-11-08', '09:00:00', 12, 8, '600S', 'DR Byen', 'Kastrup'),
    ('2024-11-08', '09:15:00', 15, 22, '600S', 'Vestamager', 'Amagerbro St.'),
    ('2024-11-08', '09:30:00', 10, 7, '600S', 'Amagerbro St.', 'Tårnby St.'),
    ('2024-11-08', '09:45:00', 20, 9, '5C', 'Christianshavn', 'Amager Strand'),
    ('2024-11-08', '10:00:00', 15, 12, '5C', 'Amager Strand', 'Lufthavnen'),
    ('2024-11-08', '10:15:00', 18, 13, '5C', 'Nørreport', 'Christianshavn'),
    ('2024-11-08', '10:30:00', 22, 7, '5C', 'Christianshavn', 'Rådhuspladsen'),
    ('2024-11-08', '10:45:00', 12, 17, '1A', 'Valby St.', 'Gentofte St.'),
    ('2024-11-08', '11:00:00', 15, 10, '1A', 'Nordhavn St.', 'Hvidovrevej'),
    ('2024-11-08', '11:15:00', 20, 7, '1A', 'Gentofte St.', 'Nørreport'),
    ('2024-11-08', '11:30:00', 25, 20, '2A', 'Tingbjerg', 'Kongens Nytorv'),
    ('2024-11-08', '11:45:00', 15, 9, '2A', 'Kongens Nytorv', 'Brønshøj Torv'),
    ('2024-11-08', '12:00:00', 18, 8, '9A', 'Glostrup Station', 'Ordrup'),
    ('2024-11-08', '12:15:00', 10, 13, '9A', 'Rigshospitalet', 'Nørreport'),
    ('2024-11-08', '12:30:00', 22, 7, '9A', 'Nørreport', 'Rødovre Centrum'),
    ('2024-11-08', '12:45:00', 15, 11, '350S', 'Frederiksberg St.', 'Forum'),
    ('2024-11-08', '13:00:00', 20, 15, '350S', 'Måløv', 'Lyngby St.'),
    ('2024-11-08', '13:15:00', 10, 17, '250S', 'Bella Center', 'Langgade St.'),
    ('2024-11-08', '13:30:00', 15, 8, '250S', 'Langgade St.', 'Københavns Hovedbanegård'),
    ('2024-11-08', '13:45:00', 10, 12, '250S', 'Ørestad St.', 'Rådhuspladsen'),
    ('2024-11-08', '14:00:00', 18, 7, '7A', 'Rødovre St.', 'Enghave Plads'),
    ('2024-11-08', '14:15:00', 20, 10, '7A', 'Valby St.', 'Forum'),
    ('2024-11-08', '14:30:00', 25, 14, '7A', 'Nordhavn St.', 'Vanløse St.'),
    ('2024-11-08', '14:45:00', 12, 9, '33', 'Christianshavn', 'Vanløse St.'),
    ('2024-11-08', '15:00:00', 15, 7, '33', 'Amagerbro St.', 'Rådhuspladsen'),
    ('2024-11-08', '15:15:00', 18, 15, '33', 'Rådhuspladsen', 'Forum'),
    ('2024-11-08', '15:30:00', 10, 11, '6A', 'Flintholm St.', 'Nørrebro St.'),
    ('2024-11-08', '15:45:00', 15, 8, '6A', 'Bellahøj', 'Nørreport'),
    ('2024-11-08', '16:00:00', 12, 7, '6A', 'Nørrebro St.', 'Københavns Hovedbanegård'),
    ('2024-11-08', '16:15:00', 25, 19, '6A', 'Københavns Hovedbanegård', 'Nørreport'),
    ('2024-11-08', '16:30:00', 20, 7, '300S', 'Svanemøllen St.', 'Ryparken'),
    ('2024-11-08', '16:45:00', 18, 10, '300S', 'Ryparken', 'DTU'),
    ('2024-11-08', '17:00:00', 10, 15, '300S', 'DTU', 'Holte St.'),
    ('2024-11-08', '17:15:00', 15, 14, '150S', 'Trianglen', 'Nørreport'),
    ('2024-11-08', '17:30:00', 12, 17, '150S', 'Nørreport', 'Hellerup St.'),
    ('2024-11-08', '17:45:00', 20, 8, '150S', 'Hellerup St.', 'Ordrup'),
    ('2024-11-08', '18:00:00', 18, 7, '600S', 'DR Byen', 'Tårnby St.'),
    ('2024-11-08', '18:15:00', 10, 16, '600S', 'Amagerbro St.', 'Islands Brygge'),
    ('2024-11-08', '18:30:00', 12, 12, '5C', 'Amagerbro St.', 'Christianshavn'),
    ('2024-11-08', '18:45:00', 15, 9, '5C', 'Christianshavn', 'Nørreport'),
    ('2024-11-08', '19:00:00', 20, 7, '5C', 'Nørreport', 'Lufthavnen'),
    ('2024-11-08', '19:15:00', 25, 13, '1A', 'Hvidovrevej', 'Valby St.'),
    ('2024-11-08', '19:30:00', 10, 14, '1A', 'Valby St.', 'Gentofte St.'),
    ('2024-11-08', '19:45:00', 15, 8, '2A', 'Kongens Nytorv', 'Brønshøj Torv'),
    ('2024-11-08', '20:00:00', 12, 7, '2A', 'Brønshøj Torv', 'Tingbjerg'),
    ('2024-11-08', '20:15:00', 10, 12, '9A', 'Rigshospitalet', 'Nørreport'),
    ('2024-11-08', '20:30:00', 22, 17, '9A', 'Nørreport', 'Glostrup Station'),
    ('2024-11-08', '20:45:00', 20, 9, '350S', 'Ballerup St.', 'Frederiksberg St.'),
    ('2024-11-08', '21:00:00', 15, 7, '350S', 'Frederiksberg St.', 'Forum'),
    ('2024-11-08', '21:15:00', 10, 15, '250S', 'Bella Center', 'Langgade St.'),
    ('2024-11-08', '21:30:00', 18, 8, '250S', 'Langgade St.', 'Ørestad St.'),
    ('2024-11-08', '21:45:00', 25, 11, '250S', 'Ørestad St.', 'Rådhuspladsen'),
    ('2024-11-08', '22:00:00', 10, 16, '7A', 'Valby St.', 'Forum'),
    ('2024-11-08', '22:15:00', 15, 13, '7A', 'Enghave Plads', 'Rødovre St.'),
    ('2024-11-08', '22:30:00', 20, 7, '33', 'Københavns Hovedbanegård', 'Christianshavn'),
    ('2024-11-08', '22:45:00', 15, 19, '33', 'Christianshavn', 'Vanløse St.'),
    ('2024-11-08', '23:00:00', 10, 18, '6A', 'Forum', 'Flintholm St.'),
    ('2024-11-08', '23:15:00', 22, 7, '6A', 'Flintholm St.', 'Bellahøj'),
    ('2024-11-08', '23:30:00', 15, 8, '6A', 'Nørreport', 'Frederiksberg Allé'),
    ('2024-11-08', '23:45:00', 20, 12, '300S', 'Nørreport', 'DTU'),
    ('2024-11-09', '06:00:00', 12, 15, '6A', 'Forum', 'Bellahøj'),
    ('2024-11-09', '06:15:00', 20, 9, '6A', 'Nørreport', 'Københavns Hovedbanegård'),
    ('2024-11-09', '06:30:00', 15, 13, '6A', 'Københavns Hovedbanegård', 'Nørrebro St.'),
    ('2024-11-09', '06:45:00', 18, 7, '6A', 'Flintholm St.', 'Københavns Hovedbanegård'),
    ('2024-11-09', '07:00:00', 22, 12, '6A', 'Nørreport', 'Frederiksberg Allé'),
    ('2024-11-09', '07:15:00', 15, 11, '300S', 'Ryparken', 'DTU'),
    ('2024-11-09', '07:30:00', 10, 16, '300S', 'DTU', 'Holte St.'),
    ('2024-11-09', '07:45:00', 15, 10, '300S', 'Lyngby St.', 'Ryparken'),
    ('2024-11-09', '08:00:00', 12, 8, '150S', 'Ordrup', 'Hellerup St.'),
    ('2024-11-09', '08:15:00', 10, 7, '150S', 'Hellerup St.', 'Trianglen'),
    ('2024-11-09', '08:30:00', 25, 15, '150S', 'Trianglen', 'Nørreport'),
    ('2024-11-09', '08:45:00', 18, 17, '600S', 'DR Byen', 'Vestamager'),
    ('2024-11-09', '09:00:00', 12, 19, '600S', 'Vestamager', 'Tårnby St.'),
    ('2024-11-09', '09:15:00', 10, 11, '5C', 'Christianshavn', 'Amagerbro St.'),
    ('2024-11-09', '09:30:00', 15, 14, '5C', 'Nørreport', 'Amager Strand'),
    ('2024-11-09', '09:45:00', 25, 10, '5C', 'Amagerbro St.', 'Københavns Hovedbanegård'),
    ('2024-11-09', '10:00:00', 18, 8, '1A', 'Hvidovrevej', 'Valby St.'),
    ('2024-11-09', '10:15:00', 22, 7, '2A', 'Brønshøj Torv', 'Københavns Hovedbanegård'),
    ('2024-11-09', '10:30:00', 12, 9, '2A', 'Kongens Nytorv', 'Nørreport');

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

# For each line, the ID of the passenger who took the ride that lasted longer.
SELECT PassengerID, BusLineName, Duration FROM Ride AS OuterRide
WHERE Duration = (
	SELECT MAX(Duration) FROM Ride AS InnerRide
    WHERE InnerRide.BusLineName = OuterRide.BusLineName);
# Erhm det her giver alle id'er der har taget den længste tur på en BusLine og ikke kun en enkelt. Tænker det var det de ville have. Even tho der ikke står "passengers" men "passenger". Men altså hvad nu hvis der var flere der havde kørt den samme tid du forstår yeh

# The ID of the passengers who never took a bus line more than once per day.
SELECT DISTINCT PassengerID FROM Ride
GROUP BY StartDate, PassengerID
HAVING COUNT(*) = 1;


/* The name of the bus stops that are never used, that is, they are neither the start
	nor the end stop for any ride.*/
SELECT StopName FROM BusStop
WHERE StopName NOT IN (SELECT StartStop FROM Ride)
AND StopName NOT IN (SELECT EndStop FROM Ride);

/* A trigger that prevents inserting a ride starting and ending at the same stop,
or at a stop not served by that line. */
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
		SELECT StopName FROM StopsOnLine
        WHERE NEW.StartStop = StopName AND NEW.BusLineName = BusLineName)
	THEN 
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'The StartStop is not served by the BusLineName';
	END IF;
    
    # check if EndStop is served by the given Bus Line
    IF NOT EXISTS (
		SELECT StopName FROM StopsOnLine
        WHERE NEW.EndStop = StopName AND NEW.BusLineName = BusLineName)
	THEN 
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'The EndStop is not served by the BusLineName';
	END IF;
END //
DELIMITER ;

# A function that, given two stops, returns how many lines serve both stops.
DROP FUNCTION IF EXISTS TwoSTops;
DELIMITER //
CREATE FUNCTION TwoStops(st1 INT, st2 INT) RETURNS INT
BEGIN
	DECLARE vAmountServed INT;
    SET vAmountServed = 0;
    SELECT COUNT(DISTINCT s1.BusLineID) 
    INTO vAmountServed
    FROM StopsOnLine s1
    JOIN StopsOnLine s2 ON s1.BusLineID = s2.BusLineID
	WHERE s1.StopID = st1 AND s2.StopID = st2;
    
    RETURN vAmountServed;
    
END//
DELIMITER ;

