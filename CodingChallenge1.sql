--1. Provide a SQL script that initializes the database for the Job Board scenario “CareerHub”. 
--2. Create tables for Companies, Jobs, Applicants and Applications. 
--3. Define appropriate primary keys, foreign keys, and constraints. 
--4. Ensure the script handles potential errors, such as if the database or tables already exist.

create database careerhub;
use careerhub;
CREATE TABLE Companies (
CompanyID INT PRIMARY KEY,
CompanyName VARCHAR(20),
Location VARCHAR(20));
CREATE TABLE Jobs (
JobID INT PRIMARY KEY,
CompanyID INT,
JobTitle VARCHAR(255),
JobDescription TEXT,
JobLocation VARCHAR(255),
Salary DECIMAL(10, 2),
JobType VARCHAR(50),
PostedDate DATETIME,
FOREIGN KEY (CompanyID) REFERENCES Companies(CompanyID));
CREATE TABLE Applicants (
ApplicantID INT PRIMARY KEY,
FirstName VARCHAR(255),
LastName VARCHAR(255),
Email VARCHAR(255),
Phone VARCHAR(20),
Resume TEXT);
CREATE TABLE Applications (
ApplicationID INT PRIMARY KEY,
JobID INT,
ApplicantID INT,
ApplicationDate DATETIME,
CoverLetter TEXT,
FOREIGN KEY (JobID) REFERENCES Jobs(JobID),
FOREIGN KEY (ApplicantID) REFERENCES Applicants(ApplicantID));

INSERT INTO Companies (CompanyID, CompanyName, Location) VALUES
(1, 'Company 1', 'New York'),
(2, 'Company 2', 'Georgia'),
(3, 'Company 3', 'Chicago'),
(4, 'Company 4', 'Paris'),
(5, 'Company 5', 'Canada');
INSERT INTO Jobs (JobID, CompanyID, JobTitle, JobDescription, JobLocation, Salary, JobType, PostedDate) VALUES
(11, 1, 'Software Engineer', 'We are looking for a skilled and experienced software engineer to join our team.', 'New York', 80000.00, 'Full-time', '2024-04-15 09:00:00'),
(22, 2, 'Marketing Specialist', 'Seeking a creative marketing specialist to develop and implement marketing strategies.', 'Georgia', 70000.00, 'Full-time', '2024-04-16 10:30:00'),
(33, 3, 'Data Analyst', 'We are hiring a data analyst to analyze and interpret complex data sets.', 'Chicago', 75000.00, 'WFH', '2024-04-17 11:45:00'),
(44, 4, 'UX/UI Designer', 'Join our team as a UX/UI designer to create engaging user experiences.', 'Paris', 85000.00, 'Part-time', '2024-04-18 13:15:00'),
(55, 5, 'Accountant', 'We are seeking an experienced accountant to manage financial transactions.', 'Canada', 70000.00, 'Full-time', '2024-04-19 14:45:00');
INSERT INTO Applicants (ApplicantID, FirstName, LastName, Email, Phone, Resume) VALUES
(101, 'Tim', 'David', 'timdavid@example.com', '123-456-7890', 'Experienced software engineer with expertise in Java, Python, and SQL.'),
(102, 'Tim', 'Brook', 'timbrook@example.com', '987-654-3210', 'Marketing specialist with 3 years of experience developing and executing digital marketing campaigns.'),
(103, 'Jos', 'Butler', 'josbutler@example.com', '456-789-0123', 'Data analyst with strong analytical skills and proficiency in statistical analysis tools'),
(104, 'Harry', 'Edward', 'harryedward@example.com', '321-654-0987', 'Creative UX/UI designer with a passion for user-centered design.'),
(105, 'Niall', 'Horon', 'niallhoron@example.com', '789-012-3456', 'Detail-oriented accountant with a CPA certification and 4 years of experience in financial accounting.');
INSERT INTO Applications (ApplicationID, JobID, ApplicantID, ApplicationDate, CoverLetter) VALUES
(1001, 11, 101, '2024-04-20 09:30:00', 'Dear Hiring Manager, I am excited to apply for the Software Engineer position at Example Company 1...'),
(1002, 22, 102, '2024-04-21 10:45:00', 'To Whom It May Concern, I am writing to express my interest in the Marketing Specialist position at Example Company 2...'),
(1003, 33, 103, '2024-04-22 11:00:00 ', 'Hello, I am applying for the Data Analyst position at Example Company 3. I believe my analytical skills and experience make me a strong candidate...'),
(1004, 44, 104, '2024-04-23 12:15:00', 'Dear Hiring Team, I am writing to apply for the UX/UI Designer position at Example Company 4. With a strong background in user experience design...'),
(1005, 55, 105, '2024-04-24 13:30:00 ', 'Dear Hiring Committee, I am excited to submit my application for the Accountant position at Example Company 5. With years of experience in financial management...');

SELECT j.JobID, j.JobTitle, COUNT(a.ApplicationID) AS ApplicationCount
FROM Jobs j LEFT JOIN Applications a ON j.JobID = a.JobID
GROUP BY j.JobID, j.JobTitle;

SELECT j.JobTitle, c.CompanyName, j.JobLocation, j.Salary
FROM Jobs j
JOIN Companies c ON j.CompanyID = c.CompanyID
WHERE j.Salary BETWEEN 70000 AND 85000;

SELECT j.JobTitle, c.CompanyName, a.ApplicationDate
FROM Applications a
JOIN Jobs j ON a.JobID = j.JobID
JOIN Companies c ON j.CompanyID = c.CompanyID
WHERE a.ApplicantID = 102;

select avg(salary) from jobs
where Salary > 0;

SELECT c.CompanyName, COUNT(j.JobID) AS JobCount
FROM Companies c JOIN Jobs j ON c.CompanyID = j.CompanyID
GROUP BY c.CompanyName
HAVING COUNT(j.JobID) = (select MAX(JobCount) from (select COUNT(JobID) as JobCount from Jobs
													group by CompanyID) as MaxJobCount);
                                                    
ALTER TABLE Applicants
ADD ExperienceYears INT;
UPDATE Applicants
SET ExperienceYears = 5 WHERE ApplicantID = 1;
UPDATE Applicants
SET ExperienceYears = 2 WHERE ApplicantID = 2;
UPDATE Applicants
SET ExperienceYears = 0 WHERE ApplicantID = 3;
UPDATE Applicants
SET ExperienceYears = 1 WHERE ApplicantID = 4;
UPDATE Applicants
SET ExperienceYears = 4 WHERE ApplicantID = 5;

select distinct a.FirstName, a.LastName from Applicants a
join Applications app on a.ApplicantID = app.ApplicantID
join Jobs j on app.JobID = j.JobID
join Companies c on j.CompanyID = c.CompanyID
where c.Location = 'New York' and a.ExperienceYears >= 3;

select distinct JobTitle from Jobs
where Salary between 60000 and 80000;

select j.JobID, j.JobTitle from Jobs j
left join Applications a ON j.JobID = a.JobID
WHERE a.JobID IS NULL;

select a.FirstName, a.LastName, c.CompanyName, j.JobTitle
from Applicants a
join Applications app on a.ApplicantID = app.ApplicantID
join Jobs j on app.JobID = j.JobID
join Companies c on j.CompanyID = c.CompanyID;

select c.CompanyName, COUNT(j.JobID) as JobCount
from Companies c
left join Jobs j on c.CompanyID = j.CompanyID
group by c.CompanyName;

select a.FirstName, a.LastName, coalesce(c.CompanyName, 'Not Applied') as CompanyName, coalesce(j.JobTitle, 'Not Applied') AS JobTitle
from Applicants a
left join Applications app on a.ApplicantID = app.ApplicantID
left join Jobs j on app.JobID = j.JobID
left join Companies c on j.CompanyID = c.CompanyID;

select c.CompanyName from Companies c
join Jobs j on c.CompanyID = j.CompanyID
where j.Salary > (
    select avg(Salary) from Jobs);
    
ALTER TABLE Applicants
ADD State VARCHAR(20);

UPDATE Applicants
SET State = 'A'
WHERE ApplicantID = 101;

UPDATE Applicants
SET State = 'B'
WHERE ApplicantID = 102;

UPDATE Applicants
SET State = 'C'
WHERE ApplicantID =103;

UPDATE Applicants
SET State = 'D'
WHERE ApplicantID = 104;

UPDATE Applicants
SET State = 'E'
WHERE ApplicantID = 105;

ALTER TABLE Applicants
ADD City VARCHAR(20);

UPDATE Applicants
SET City = 'Newyork'
WHERE ApplicantID = 101;

UPDATE Applicants
SET City = 'Georgia'
WHERE ApplicantID = 102;

UPDATE Applicants
SET City = 'Chicago'
WHERE ApplicantID =103;

UPDATE Applicants
SET City = 'Paris'
WHERE ApplicantID = 104;

UPDATE Applicants
SET City = 'Canada'
WHERE ApplicantID = 105;

select concat(a.FirstName, ' ', a.LastName) as FullName,
       concat(a.City, ', ', a.State) as Location from Applicants a;
       
select * from Jobs
where JobTitle like '%Developer%' or JobTitle like '%Engineer%';

select a.FirstName, a.LastName, j.JobTitle
from Applicants a
left join Applications app on a.ApplicantID = app.ApplicantID
left join Jobs j on app.JobID = j.JobID;

select a.FirstName, a.LastName, c.CompanyName from Applicants a
join Applications app on a.ApplicantID = app.ApplicantID
join Jobs j on app.JobID = j.JobID
join Companies c on j.CompanyID = c.CompanyID
where c.Location = 'Newyork' and a.ExperienceYears > 2;



       

















