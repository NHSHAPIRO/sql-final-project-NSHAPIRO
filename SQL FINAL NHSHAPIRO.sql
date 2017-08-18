#1 Create new database Building Energy
#1 Clear the schema 1st

DROP SCHEMA if exists buildingenergy;

CREATE SCHEMA IF NOT EXISTS buildingEnergy;

#Use building energy db
USE buildingenergy;


#2 Electricity, Gas, Steam, and Fuel Oil are Fossil.
#2 Solar and Wind are renewable.

#2 Create table EnergyCategories
CREATE TABLE EnergyCategories (ECatID int PRIMARY KEY, ECatName VARCHAR(50) not null);

#2 Create table EnergyTypes
CREATE TABLE EnergyTypes(ETypeID int PRIMARY KEY, ETypeName VARCHAR(50) not null, ECatID int not null);

#2 Insert into EnergyCategories table Fossil and Renewable
INSERT INTO EnergyCategories
VALUES
(EcatID, EcatName),
(1,'Fossil'),
(2,'Renewable')


#2 Insert into EnergyTypes table  Electricity, Gas, Steam, Fuel Oil, Solar, and Wind
#2 Energy Types to the Engery Category

INSERT INTO EnergyTypes
VALUES
(ETypeID, ETypeName, ECatID),
(1,'Electricity',1),
(2,'Gas',1),
(3,'Steam',1),
(4,'Fuel Oil',1),
(5,'Solar',2),
(6,'Wind',2)


#3 Join the tables to show the energy categoires and associated energy type.
SELECT ECatName, ETypeName
from EnergyCategories EC
join EnergyTypes ET
on EC.ECatID = ET.ECatID
group by ECatName, ETypeName
order by ETypeName ASC;


#4 Create Buildings table.
CREATE TABLE Buildings (BuildID int PRIMARY KEY, BuildingName VARCHAR(40));


#Empire State Building; Energy Types: Electricity, Gas, Steam
#Chrysler Building; Energy Types: Electricity, Steam
#Borough of Manhattan Community College; Energy Types: Electricity, Steam, Solar 
INSERT INTO Buildings
VALUES
(BuildID, BuildingName),
(1,'Empire State Building'),
(2,'Chrysler Building'),
(3,'Borrough of Manhattan Community College')


#5 Join Buildings Table to Energy Type Table via linking table
#5 Create the linking table first.  (Need to create one to many relationship)
#Used References to get column specs
#5 Used Constraint to restrict the values 

CREATE TABLE Buildings_EnergyTypes (BuildID int NOT NULL REFERENCES Buildings(BuildID), ETypeID int NOT NULL REFERENCES EnergyTypes (ETypeID), CONSTRAINT pk_Buildings_EnergyTypes PRIMARY KEY(BuildID, ETypeID));

INSERT INTO Buildings_EnergyTypes (BuildID, ETypeID) VALUES (1,1);
INSERT INTO Buildings_EnergyTypes (BuildID, ETypeID) VALUES (1,2);
INSERT INTO Buildings_EnergyTypes (BuildID, ETypeID) VALUES (1,3);
INSERT INTO Buildings_EnergyTypes (BuildID, ETypeID) VALUES (2,1);
INSERT INTO Buildings_EnergyTypes (BuildID, ETypeID) VALUES (2,3);
INSERT INTO Buildings_EnergyTypes (BuildID, ETypeID) VALUES (3,1);
INSERT INTO Buildings_EnergyTypes (BuildID, ETypeID) VALUES (3,3);
INSERT INTO Buildings_EnergyTypes (BuildID, ETypeID) VALUES (3,5);

#5 Now Join the data

select b.BuildingName, et.ETypeName
from Buildings b left join Buildings_EnergyTypes bet on b.BuildID = bet.BuildID
left join EnergyTypes et on bet.ETypeID = et.ETypeID
group by b. BuildingName, et.ETypeNAME
ORDER BY  BuildingName;


#6 Update Buildings Table and Energy Category Table and Energy Types Table 
#Bronx Lion House, Geothermal
#Brooklyn Childrens Museum, Electricity, Geothermal

INSERT INTO Buildings values(4, 'Bronx Lion House');
INSERT INTO Buildings values(5, 'Brooklyn Childrens Museum');

INSERT INTO EnergyTypes values(7, 'Geothermal', 2);

INSERT INTO Buildings_EnergyTypes (BuildID, ETypeID) VALUES (4,7);
INSERT INTO Buildings_EnergyTypes (BuildID, ETypeID) VALUES (5,1);
INSERT INTO Buildings_EnergyTypes (BuildID, ETypeID) VALUES (5,7);

#7 Show the buildings that use renewable energy
#7 Renewable = 2

select b.BuildingName, et.ETypeName, ec.ECatNAME
from Buildings b left join Buildings_EnergyTypes bet on b.BuildID = bet.BuildID
left join EnergyTypes et on bet.ETypeID = et.ETypeID
left join EnergyCategories ec on et.ECatID = ec.ECatID
WHERE ec.ECatID =  2
group by b. BuildingName, et.ETypeNAME, ec.ECatName
ORDER BY  BuildingName;

#8 Get the frequency of Engery Type
SELECT et.ETypeNAME, count(BuildID) as COUNT
from Buildings_EnergyTypes bet
left join EnergyTypes et on bet.ETypeID = et.ETypeID
group by et.ETypeName
order by count desc;



#9a  Create the  the appropriate foreign key constraints.
#ON UPDATE CASCADE - If the parent primary key is changed, the child value will also change to reflect that.
#ON DELETE CASCADE -  If the parent record is deleted, any child records are also deleted. 

#ALTER TABLE EnergyTypes;
#FOREGIN CONSTRAINT FK_EC
#FOREGIN KEY(ECatID) references EnergyCategories(ECatID)
#ON UPDATE CASCADE
#ON DELETE CASCADE
