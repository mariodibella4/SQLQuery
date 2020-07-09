--MarioDiBella
USE Master;
GO
DROP DATABASE IF EXISTS schooldb;
GO
CREATE DATABASE schooldb;
GO
USE schooldb;
PRINT 'Part A Completed'

-- ****************************
-- PART B
-- ****************************
Go
Create Proc usp_dropTables 
AS
DROP TABLE IF EXISTS Student_Courses,StudentContacts,Employees,EmpJobPosition,CourseList,ContactType,StudentInformation;
Go


PRINT 'Part B Completed'

-- ****************************
-- PART C
-- ****************************
Go
Create table CourseList(
CourseID INT Identity(10,1) Primary Key,
CourseDescription char(200) not null,
CourseCost char(200) null,
CourseDurationYears char(200) null,
Notes char(200) null
);
GO
Create table StudentInformation(
StudentID INT identity(100,1) Primary Key,
Title char(50) null,
FirstName char(50) not null,
LastName char(50) not null,
Address1 char(200) null,
Address2 char(200) null,
City char(200) null,
County char(200) null,
Zip char(200) null,
Country char(200) null,
Telephone char(200) null,
Email char(500) null,
Enrolled char(200) null,
AltTelephone char(200) null
);
GO
Create table Student_Courses(
StudentCourseID INT identity(1,1) Primary Key,
StudentID INT Foreign Key References StudentInformation(StudentID),
CourseID INT Foreign Key References CourseList(CourseID),
CourseStartDate char(10) not null,
CourseComplete char(10) null
);
GO
CREATE TABLE EmpJobPosition(
EmpJobPositionID INT identity(1,1) Primary Key,
EmployeePosition char(200) not null
);
GO
Create Table Employees(
EmployeeID INT identity(1000,1) Primary Key,
EmployeeName char(100) not null,
EmployeePositionID INT Foreign Key References EmpJobPosition(EmpJobPositionID),
Access char(100) null
);
GO
Create Table ContactType(
ContactTypeID INT Identity(1,1) Primary Key,
ContactType char(200) not null
);
Create table StudentContacts(
ContactID INT identity(10000,1) Primary Key,
StudentID INT Foreign Key References StudentInformation(StudentID),
ContactTypeID INT Foreign Key References ContactType(ContactTypeID),
ContactDate char(10) not null,
EmployeeID INT Foreign Key References Employees(EmployeeID),
ContactDetails char(300) not null
);
GO


PRINT 'Part C Completed'

-- ****************************
-- PART D
-- ****************************
Alter Table Student_Courses
ADD UNIQUE(StudentID,CourseID);
GO
Alter Table StudentInformation
Add CreatedDateTime DATETIME NOT NULL
                DEFAULT CURRENT_TIMESTAMP;
GO
Alter Table StudentInformation
DROP COLUMN AltTelephone;
GO
Create INDEX
IX_LastName
ON
StudentInformation(LastName);
GO

PRINT 'Part D Completed'
GO
-- ****************************
-- PART E
-- ****************************
Create Trigger trg_assignEmail ON StudentInformation
After Insert
As 
Begin
Declare @firstName char(20);
Declare @lastName char(20);
Declare @email char(100);
IF (Select Email From Inserted)  is Null
Begin
Set @firstName= (Select FirstName From Inserted);
Set @lastName= (Select LastName From Inserted);
Update StudentInformation
Set Email=Replace(CONCAT(@firstName,'.',@lastName,'@disney.com'),' ','')
Where FirstName=@firstName
End
End;

PRINT 'Part E Completed'

-- ****************************
-- PART F
-- ****************************
GO
INSERT INTO StudentInformation
   (FirstName,LastName)
VALUES
   ('Mickey', 'Mouse');

INSERT INTO StudentInformation
   (FirstName,LastName)
VALUES
   ('Minnie', 'Mouse');

INSERT INTO StudentInformation
   (FirstName,LastName)
VALUES
   ('Donald', 'Duck');
SELECT * FROM StudentInformation;

INSERT INTO CourseList
   (CourseDescription)
VALUES
   ('Advanced Math');

INSERT INTO CourseList
   (CourseDescription)
VALUES
   ('Intermediate Math');

INSERT INTO CourseList
   (CourseDescription)
VALUES
   ('Beginning Computer Science');

INSERT INTO CourseList
   (CourseDescription)
VALUES
   ('Advanced Computer Science');
select * from CourseList;

INSERT INTO Student_Courses
   (StudentID,CourseID,CourseStartDate)
VALUES
   (100, 10, '01/05/2018');

INSERT INTO Student_Courses
   (StudentID,CourseID,CourseStartDate)
VALUES
   (101, 11, '01/05/2018');

INSERT INTO Student_Courses
   (StudentID,CourseID,CourseStartDate)
VALUES
   (102, 11, '01/05/2018');
INSERT INTO Student_Courses
   (StudentID,CourseID,CourseStartDate)
VALUES
   (100, 11, '01/05/2018');

INSERT INTO Student_Courses
   (StudentID,CourseID,CourseStartDate)
VALUES
   (102, 13, '01/05/2018');
select * from Student_Courses;

INSERT INTO EmpJobPosition
   (EmployeePosition)
VALUES
   ('Math Instructor');

INSERT INTO EmpJobPosition
   (EmployeePosition)
VALUES
   ('Computer Science');
select * from EmpJobPosition

INSERT INTO Employees
   (EmployeeName,EmployeePositionID)
VALUES
   ('Walt Disney', 1);

INSERT INTO Employees
   (EmployeeName,EmployeePositionID)
VALUES
   ('John Lasseter', 2);

INSERT INTO Employees
   (EmployeeName,EmployeePositionID)
VALUES
   ('Danny Hillis', 2);
select * from Employees;

INSERT INTO ContactType
   (ContactType)
VALUES
   ('Tutor');

INSERT INTO ContactType
   (ContactType)
VALUES
   ('Homework Support');

INSERT INTO ContactType
   (ContactType)
VALUES
   ('Conference');
SELECT * from ContactType;

INSERT INTO StudentContacts
   (StudentID,ContactTypeID,EmployeeID,ContactDate,ContactDetails)
VALUES
   (100, 1, 1000, '11/15/2017', 'Micky and Walt Math Tutoring');

INSERT INTO StudentContacts
   (StudentID,ContactTypeID,EmployeeID,ContactDate,ContactDetails)
VALUES
   (101, 2, 1001, '11/18/2017', 'Minnie and John Homework support');

INSERT INTO StudentContacts
   (StudentID,ContactTypeID,EmployeeID,ContactDate,ContactDetails)
VALUES
   (100, 3, 1001, '11/18/2017', 'Micky and Walt Conference');

INSERT INTO StudentContacts
   (StudentID,ContactTypeID,EmployeeID,ContactDate,ContactDetails)
VALUES
   (102, 2, 1002, '11/20/2017', 'Donald and Danny Homework support');

SELECT * from StudentContacts;


INSERT INTO StudentInformation
   (FirstName,LastName,Email)
VALUES
   ('Porky', 'Pig', 'porky.pig@warnerbros.com');
INSERT INTO StudentInformation
   (FirstName,LastName)
VALUES
   ('Snow', 'White');



PRINT 'Part F Completed'
GO
-- ****************************
-- PART G
-- ****************************
Create Proc usp_addQuickContacts
			@email char(200),
			@empName char(50),
			@contactDetails char(200),
			@contactType char(100)
AS
Begin
Declare @cTypeID INT;

Set @cTypeID=(Select ContactTypeID From ContactType Where ContactType=@contactType)
	
	IF @cTypeID is Null
		Begin
		IF(Select Count(*) From StudentInformation Where @email=Email)>0
		Begin
			INSERT INTO ContactType(ContactType)
			Values(@contactType);
			INSERT INTO StudentContacts(ContactDate,ContactDetails,EmployeeID)
			Values(Convert(char,GETDATE(),1),@contactDetails,(Select EmployeeID From Employees Where @empName=EmployeeName));
		End
		ELSE
		Print 'Student EMAIL NOT in Database.'
		End
	ELSE
		Begin
		IF(Select Count(*) From StudentInformation Where @email=Email)>0
		Begin
		INSERT INTO StudentContacts(ContactDate,ContactTypeID,ContactDetails,EmployeeID)
			Values(Convert(char,GETDATE(),1),@cTypeID,@contactDetails,(Select EmployeeID From Employees Where @empName=EmployeeName));
		End	
		ELSE
		Print 'Student EMAIL NOT in Database.'
		End
End;
PRINT 'Part G Completed';
GO
-- ****************************
-- PART H
-- ****************************
Create Proc usp_getCourseRosterByName
				@courseDescript char(200)
AS
Select c.CourseDescription,s.FirstName,s.LastName
From CourseList c
INNER Join Student_Courses sC ON sC.CourseID=c.CourseID
Inner Join StudentInformation s ON s.StudentID=sC.StudentID
Where @courseDescript=c.CourseDescription;


PRINT 'Part G Completed';
-- ****************************
-- PART I
-- ****************************
GO
Create VIEW vtutorContacts
AS
Select e.EmployeeName, CONCAT(RTRIM(s.FirstName),' ',LTRIM(RTRiM(s.LastName)))As FullName,sC.ContactDetails,sC.ContactDate
From StudentContacts sC
INNER Join Employees e ON
			e.EmployeeID=sC.EmployeeID

INNER Join StudentInformation s ON
						s.StudentID=sC.StudentID And sC.ContactTypeID=(Select ContactTypeID From ContactType Where ContactType='Tutor');
GO
Print 'Part I Completed'
--MarioDiBella