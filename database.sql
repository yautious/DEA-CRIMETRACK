-- Create database
CREATE DATABASE IF NOT EXISTS dea_crime_tracker;
USE dea_crime_tracker;

-- Create tables
CREATE TABLE Officer 
(
    Officer_ID INT PRIMARY KEY,
    Name VARCHAR(100),
    `Rank` VARCHAR(50),
    Phone VARCHAR(15),
    Email VARCHAR(100),
    Branch_ID INT
);

CREATE TABLE Suspect (
    Suspect_ID INT PRIMARY KEY,
    Name VARCHAR(100),
    DOB DATE,
    Gender VARCHAR(10),
    Crime_Record TEXT,
    Arrest_Date DATE
);

CREATE TABLE Drug (
    Drug_ID INT PRIMARY KEY,
    Name VARCHAR(100),
    Type VARCHAR(50),
    Description TEXT,
    Legal_Status VARCHAR(50)
);

CREATE TABLE `Case` (
    Case_ID INT PRIMARY KEY,
    Title VARCHAR(100),
    Description TEXT,
    Start_Date DATE,
    Status VARCHAR(20),
    Lead_Officer_ID INT,
    FOREIGN KEY (Lead_Officer_ID) REFERENCES Officer(Officer_ID)
);

CREATE TABLE Violation (
    Violation_ID INT PRIMARY KEY,
    Drug_ID INT,
    Suspect_ID INT,
    Case_ID INT,
    Violation_Type VARCHAR(50),
    Law_Code VARCHAR(50),
    Penalty VARCHAR(100),
    FOREIGN KEY (Drug_ID) REFERENCES Drug(Drug_ID),
    FOREIGN KEY (Suspect_ID) REFERENCES Suspect(Suspect_ID),
    FOREIGN KEY (Case_ID) REFERENCES `Case`(Case_ID)
);

CREATE TABLE Seizure (
    Seizure_ID INT PRIMARY KEY,
    Case_ID INT,
    Drug_ID INT,
    Quantity DECIMAL(10, 2),
    Location VARCHAR(100),
    Date DATE,
    FOREIGN KEY (Case_ID) REFERENCES `Case` (Case_ID),
    FOREIGN KEY (Drug_ID) REFERENCES Drug(Drug_ID)
);

CREATE TABLE Evidence (
    Evidence_ID INT PRIMARY KEY,
    Case_ID INT,
    Description TEXT,
    Date_Collected DATE,
    Collected_By INT,
    FOREIGN KEY (Case_ID) REFERENCES `Case` (Case_ID),
    FOREIGN KEY (Collected_By) REFERENCES Officer(Officer_ID)
);

CREATE TABLE Arrest (
    Arrest_ID INT PRIMARY KEY,
    Suspect_ID INT,
    Officer_ID INT,
    Case_ID INT,
    Date_of_Arrest DATE,
    Location VARCHAR(100),
    Charges TEXT,
    FOREIGN KEY (Suspect_ID) REFERENCES Suspect(Suspect_ID),
    FOREIGN KEY (Officer_ID) REFERENCES Officer(Officer_ID),
    FOREIGN KEY (Case_ID) REFERENCES `Case` (Case_ID)
);

CREATE TABLE Legal_Proceeding (
    Proceeding_ID INT PRIMARY KEY,
    Case_ID INT,
    Court_Name VARCHAR(100),
    Judge_Name VARCHAR(100),
    Verdict VARCHAR(100),
    Sentence TEXT,
    Date_of_Trial DATE,
    FOREIGN KEY (Case_ID) REFERENCES `Case` (Case_ID)
);

CREATE TABLE Reward (
    Reward_ID INT PRIMARY KEY,
    Suspect_ID INT,
    Tip_Provider_Name VARCHAR(100),
    Contact_Info VARCHAR(100),
    Tip_Date DATE,
    Reward_Amount DECIMAL(10,2),
    Reward_Date DATE,
    Officer_ID INT,
    FOREIGN KEY (Suspect_ID) REFERENCES Suspect(Suspect_ID),
    FOREIGN KEY (Officer_ID) REFERENCES Officer(Officer_ID)
);


-- Officer Table
INSERT INTO Officer VALUES (1000, 'Amit Sharma', 'Inspector', '9876585278', 'amit@dea.gov.in', 1);
INSERT INTO Officer VALUES (1001, 'Priya Mehta', 'Sub-Inspector', '9876530842', 'priya@dea.gov.in', 2);
INSERT INTO Officer VALUES (1002, 'Rahul Verma', 'Sub-Inspector', '9876539739', 'rahul@dea.gov.in', 2);
INSERT INTO Officer VALUES (1003, 'Neha Joshi', 'Sergeant', '9876562614', 'neha@dea.gov.in', 1);
INSERT INTO Officer VALUES (1004, 'Vikram Patel', 'Sergeant', '9876585650', 'vikram@dea.gov.in', 1);
INSERT INTO Officer VALUES (1005, 'Sneha Reddy', 'Inspector', '9876563451', 'sneha@dea.gov.in', 3);
INSERT INTO Officer VALUES (1006, 'Anil Kumar', 'Sub-Inspector', '9876541234', 'anil@dea.gov.in', 3);
INSERT INTO Officer VALUES (1007, 'Pooja Singh', 'Sergeant', '9876567890', 'pooja@dea.gov.in', 2);
INSERT INTO Officer VALUES (1008, 'Ravi Desai', 'Inspector', '9876509876', 'ravi@dea.gov.in', 1);
INSERT INTO Officer VALUES (1009, 'Kiran Rao', 'Sub-Inspector', '9876512345', 'kiran@dea.gov.in', 2);

-- Suspect Table
INSERT INTO Suspect VALUES (2000, 'Rajesh Kumar', '1982-01-15', 'Male', 'Caught with illegal drugs', '2023-01-10');
INSERT INTO Suspect VALUES (2001, 'Suman Gupta', '1985-02-12', 'Female', 'Repeat offender', '2023-01-11');
INSERT INTO Suspect VALUES (2002, 'Deepak Singh', '1988-03-10', 'Male', 'Trafficking case', '2023-01-12');
INSERT INTO Suspect VALUES (2003, 'Aarti Jain', '1981-04-05', 'Female', 'Possession', '2023-01-13');
INSERT INTO Suspect VALUES (2004, 'Manoj Yadav', '1983-05-20', 'Male', 'Drug dealing', '2023-01-14');
INSERT INTO Suspect VALUES (2005, 'Kavita Nair', '1984-06-22', 'Female', 'Suspicious activity', '2023-01-15');
INSERT INTO Suspect VALUES (2006, 'Rakesh Bhat', '1980-07-30', 'Male', 'Illegal possession', '2023-01-16');
INSERT INTO Suspect VALUES (2007, 'Lata Thakur', '1986-08-25', 'Female', 'Informant tipped off', '2023-01-17');
INSERT INTO Suspect VALUES (2008, 'Naveen Joshi', '1989-09-19', 'Male', 'Repeat offender', '2023-01-18');
INSERT INTO Suspect VALUES (2009, 'Pinky Rani', '1987-10-21', 'Female', 'Suspected smuggler', '2023-01-19');

-- Drug Table
INSERT INTO Drug VALUES (3000, 'Cocaine', 'Narcotic', 'Illegal substance', 'Illegal');
INSERT INTO Drug VALUES (3001, 'Heroin', 'Narcotic', 'Highly addictive drug', 'Illegal');
INSERT INTO Drug VALUES (3002, 'MDMA', 'Stimulant', 'Known as ecstasy', 'Illegal');
INSERT INTO Drug VALUES (3003, 'LSD', 'Hallucinogen', 'Psychedelic substance', 'Illegal');
INSERT INTO Drug VALUES (3004, 'Meth', 'Stimulant', 'Crystal meth form', 'Illegal');
INSERT INTO Drug VALUES (3005, 'Ganja', 'Cannabis', 'Plant-based drug', 'Illegal');
INSERT INTO Drug VALUES (3006, 'Opium', 'Narcotic', 'Derived from poppy', 'Illegal');
INSERT INTO Drug VALUES (3007, 'Hashish', 'Cannabis', 'Concentrated form', 'Illegal');
INSERT INTO Drug VALUES (3008, 'Morphine', 'Narcotic', 'Used in medicine, controlled', 'Controlled');
INSERT INTO Drug VALUES (3009, 'Ketamine', 'Dissociative', 'Veterinary and medical use', 'Controlled');

-- Case Table
INSERT INTO `Case` VALUES (4000, 'Case-0', 'Drug case in Mumbai', '2023-01-10', 'Open', 1000);
INSERT INTO `Case` VALUES (4001, 'Case-1', 'Raid in Delhi', '2023-01-11', 'Open', 1001);
INSERT INTO `Case` VALUES (4002, 'Case-2', 'Seizure in Bangalore', '2023-01-12', 'Closed', 1002);
INSERT INTO `Case` VALUES (4003, 'Case-3', 'Smuggling case in Pune', '2023-01-13', 'Open', 1003);
INSERT INTO `Case` VALUES (4004, 'Case-4', 'Drug bust in Chennai', '2023-01-14', 'Closed', 1004);
INSERT INTO `Case` VALUES (4005, 'Case-5', 'Undercover operation in Hyderabad', '2023-01-15', 'Open', 1005);
INSERT INTO `Case` VALUES (4006, 'Case-6', 'Informant tip in Kolkata', '2023-01-16', 'Closed', 1006);
INSERT INTO `Case` VALUES (4007, 'Case-7', 'International link in Ahmedabad', '2023-01-17', 'Open', 1007);
INSERT INTO `Case` VALUES (4008, 'Case-8', 'Distribution in Jaipur', '2023-01-18', 'Closed', 1008);
INSERT INTO `Case` VALUES (4009, 'Case-9', 'Rehabilitation escapee in Lucknow', '2023-01-19', 'Open', 1009);

-- Violation Table
INSERT INTO Violation VALUES (5000, 3000, 2000, 4000, 'Possession', 'NDPS-100', 'Prison');
INSERT INTO Violation VALUES (5001, 3001, 2001, 4001, 'Trafficking', 'NDPS-101', 'Prison');
INSERT INTO Violation VALUES (5002, 3002, 2002, 4002, 'Distribution', 'NDPS-102', 'Prison');
INSERT INTO Violation VALUES (5003, 3003, 2003, 4003, 'Possession', 'NDPS-103', 'Fine');
INSERT INTO Violation VALUES (5004, 3004, 2004, 4004, 'Possession', 'NDPS-104', 'Prison');
INSERT INTO Violation VALUES (5005, 3005, 2005, 4005, 'Trafficking', 'NDPS-105', 'Prison');
INSERT INTO Violation VALUES (5006, 3006, 2006, 4006, 'Possession', 'NDPS-106', 'Fine');
INSERT INTO Violation VALUES (5007, 3007, 2007, 4007, 'Distribution', 'NDPS-107', 'Prison');
INSERT INTO Violation VALUES (5008, 3008, 2008, 4008, 'Possession', 'NDPS-108', 'Fine');
INSERT INTO Violation VALUES (5009, 3009, 2009, 4009, 'Trafficking', 'NDPS-109', 'Prison');

-- Seizure Table
INSERT INTO Seizure VALUES (6000, 4000, 3000, 25.0, 'Mumbai', '2023-02-10');
INSERT INTO Seizure VALUES (6001, 4001, 3001, 30.0, 'Delhi', '2023-02-11');
INSERT INTO Seizure VALUES (6002, 4002, 3002, 20.0, 'Bangalore', '2023-02-12');
INSERT INTO Seizure VALUES (6003, 4003, 3003, 15.0, 'Pune', '2023-02-13');
INSERT INTO Seizure VALUES (6004, 4004, 3004, 40.0, 'Chennai', '2023-02-14');
INSERT INTO Seizure VALUES (6005, 4005, 3005, 10.0, 'Hyderabad', '2023-02-15');
INSERT INTO Seizure VALUES (6006, 4006, 3006, 12.0, 'Kolkata', '2023-02-16');
INSERT INTO Seizure VALUES (6007, 4007, 3007, 18.0, 'Ahmedabad', '2023-02-17');
INSERT INTO Seizure VALUES (6008, 4008, 3008, 22.0, 'Jaipur', '2023-02-18');
INSERT INTO Seizure VALUES (6009, 4009, 3009, 28.0, 'Lucknow', '2023-02-19');

-- Evidence Table
INSERT INTO Evidence VALUES (7000, 4000, 'Sample of drug seized', '2023-03-10', 1000);
INSERT INTO Evidence VALUES (7001, 4001, 'Plastic bag with substance', '2023-03-11', 1001);
INSERT INTO Evidence VALUES (7002, 4002, 'Liquid chemical found', '2023-03-12', 1002);
INSERT INTO Evidence VALUES (7003, 4003, 'Syringes with residue', '2023-03-13', 1003);
INSERT INTO Evidence VALUES (7004, 4004, 'Pill packets seized', '2023-03-14', 1004);
INSERT INTO Evidence VALUES (7005, 4005, 'Powdered substance', '2023-03-15', 1005);
INSERT INTO Evidence VALUES (7006, 4006, 'Suspicious capsules', '2023-03-16', 1006);
INSERT INTO Evidence VALUES (7007, 4007, 'Cloth wrap with hashish', '2023-03-17', 1007);
INSERT INTO Evidence VALUES (7008, 4008, 'Syringe and tubes', '2023-03-18', 1008);
INSERT INTO Evidence VALUES (7009, 4009, 'Plastic container', '2023-03-19', 1009);

-- Arrest Table
INSERT INTO Arrest VALUES (8000, 2000, 1000, 4000, '2023-04-10', 'Mumbai', 'Drug Possession');
INSERT INTO Arrest VALUES (8001, 2001, 1001, 4001, '2023-04-11', 'Delhi', 'Drug Trafficking');
INSERT INTO Arrest VALUES (8002, 2002, 1002, 4002, '2023-04-12', 'Bangalore', 'Illegal Drugs');
INSERT INTO Arrest VALUES (8003, 2003, 1003, 4003, '2023-04-13', 'Pune', 'Possession');
INSERT INTO Arrest VALUES (8004, 2004, 1004, 4004, '2023-04-14', 'Chennai', 'Drug Smuggling');
INSERT INTO Arrest VALUES (8005, 2005, 1005, 4005, '2023-04-15', 'Hyderabad', 'Trafficking');
INSERT INTO Arrest VALUES (8006, 2006, 1006, 4006, '2023-04-16', 'Kolkata', 'Illegal Possession');
INSERT INTO Arrest VALUES (8007, 2007, 1007, 4007, '2023-04-17', 'Ahmedabad', 'Distribution');
INSERT INTO Arrest VALUES (8008, 2008, 1008, 4008, '2023-04-18', 'Jaipur', 'Drug Crime');
INSERT INTO Arrest VALUES (8009, 2009, 1009, 4009, '2023-04-19', 'Lucknow', 'Possession');

-- Legal_Proceeding Table
INSERT INTO Legal_Proceeding VALUES (9000, 4000, 'Mumbai Sessions Court', 'Judge Amit', 'Guilty', '5 years', '2023-05-10');
INSERT INTO Legal_Proceeding VALUES (9001, 4001, 'Delhi Sessions Court', 'Judge Priya', 'Guilty', '10 years', '2023-05-11');
INSERT INTO Legal_Proceeding VALUES (9002, 4002, 'Bangalore Sessions Court', 'Judge Rahul', 'Not Guilty', 'None', '2023-05-12');
INSERT INTO Legal_Proceeding VALUES (9003, 4003, 'Pune Sessions Court', 'Judge Neha', 'Guilty', '7 years', '2023-05-13');
INSERT INTO Legal_Proceeding VALUES (9004, 4004, 'Chennai Sessions Court', 'Judge Vikram', 'Guilty', '8 years', '2023-05-14');
INSERT INTO Legal_Proceeding VALUES (9005, 4005, 'Hyderabad Sessions Court', 'Judge Sneha', 'Guilty', '4 years', '2023-05-15');
INSERT INTO Legal_Proceeding VALUES (9006, 4006, 'Kolkata Sessions Court', 'Judge Anil', 'Guilty', '6 years', '2023-05-16');
INSERT INTO Legal_Proceeding VALUES (9007, 4007, 'Ahmedabad Sessions Court', 'Judge Pooja', 'Guilty', '9 years', '2023-05-17');
INSERT INTO Legal_Proceeding VALUES (9008, 4008, 'Jaipur Sessions Court', 'Judge Ravi', 'Not Guilty', 'None', '2023-05-18');
INSERT INTO Legal_Proceeding VALUES (9009, 4009, 'Lucknow Sessions Court', 'Judge Kiran', 'Guilty', '5 years', '2023-05-19');

-- Reward Table
INSERT INTO Reward VALUES (10000, 2000, 'Rajesh', 'rajesh@mail.com', '2023-06-10', 1000, '2023-07-10', 1000);
INSERT INTO Reward VALUES (10001, 2001, 'Suman', 'suman@mail.com', '2023-06-11', 2000, '2023-07-11', 1001);
INSERT INTO Reward VALUES (10002, 2002, 'Deepak', 'deepak@mail.com', '2023-06-12', 2500, '2023-07-12', 1002);
INSERT INTO Reward VALUES (10003, 2003, 'Aarti', 'aarti@mail.com', '2023-06-13', 3000, '2023-07-13', 1003);
INSERT INTO Reward VALUES (10004, 2004, 'Manoj', 'manoj@mail.com', '2023-06-14', 5000, '2023-07-14', 1004);
INSERT INTO Reward VALUES (10005, 2005, 'Kavita', 'kavita@mail.com', '2023-06-15', 2000, '2023-07-15', 1005);
INSERT INTO Reward VALUES (10006, 2006, 'Rakesh', 'rakesh@mail.com', '2023-06-16', 3000, '2023-07-16', 1006);
INSERT INTO Reward VALUES (10007, 2007, 'Lata', 'lata@mail.com', '2023-06-17', 1000, '2023-07-17', 1007);
INSERT INTO Reward VALUES (10008, 2008, 'Naveen', 'naveen@mail.com', '2023-06-18', 2500, '2023-07-18', 1008);
INSERT INTO Reward VALUES (10009, 2009, 'Pinky', 'pinky@mail.com', '2023-06-19', 3000, '2023-07-19', 1009); 