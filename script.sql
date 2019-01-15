--done: Question, Course, Student, Topic, StudentCourse

create database PROJECT
go

use PROJECT

create table Department
(
	[ID] [int] primary key NOT NULL identity,
	[Name] [nvarchar](50),
	[Description] [nvarchar](100),
	[Location] [nvarchar](50)
)

create table Instructor
(
	ID int primary key not null identity,
	Name nvarchar(50),
	Degree nvarchar(50),
	Salary money,
	Department int not null references Department(ID)
)

create table Course
(
	ID int primary key not null identity,
	Name nvarchar(20),
	Duration int
)

create table Topic
(
	ID int not null identity,
	Name nvarchar(20),
	Course int not null references Course(ID),
	primary key(ID, Course)
)

create table Student
(
	ID int primary key not null identity,
	FirstName nvarchar(20),
	LastName nvarchar(20),
	Address nvarchar(50),
	Department int not null references Department(ID)
)

create table Question
(
	ID int not null identity,
	Type nvarchar(20) check (Type in ('TrueOrFalse', 'MCQ')),
	Body nvarchar(200),
	ModelAnswer nchar(1) check (ModelAnswer in('T', 'F', 'A', 'B', 'C', 'D')),
	Grade int not null,
	Course int not null references Course(ID),
	primary key(ID)
)

create table Exam
(
	ID int not null primary key identity
)

create table InstructorCourses
(
	Instructor int references Instructor(ID),
	Course int references Course(ID),
	primary key(Instructor, Course)
)

create table ExamQuestions
(
	Exam int not null references Exam(ID),
	Question int not null references Question(ID),
	primary key(Exam, Question)
)

create table StudentAnswers
(
	Student int not null references Student(ID),
	Exam int not null references Exam(ID),
	Question int not null references Question(ID),
	Answer nchar(1) check (Answer in('T', 'F', 'A', 'B', 'C', 'D')),
	primary key(Student, Exam, Question)
)

create table StudentCourses
(
	Student int not null references Student(ID),
	Course int not null references Course(ID),
	Grade int,
	primary key(Student, Course)
)
go




-----Student table procedures
create procedure SelectStudent @ID int
as
select * from Student where @ID = ID
go

create procedure InsertStudent @FName nvarchar(20), @LName nvarchar(20), @Address nvarchar(50), @Department int
as
insert into Student values (@FName, @LName, @Address, @Department) 
go

create procedure UpdateStudent @ID int, @ColumnName varchar(20), @Value nvarchar(50)
as
execute('update student set ' + @ColumnName + ' = ''' + @Value + ''' where ID = ' + @ID)
go

create procedure DeleteStudent @ID int
as
delete from Student where ID = @ID
go





------------
-- Course table Procedures

--1)
CREATE PROCEDURE UpdateCourse  @ID INT , @CurseName nvarchar(50)
  AS
    BEGIN
     UPDATE Course 
     SET Name =@CurseName
     WHERE ID = @ID
    END
	go
--2)
CREATE PROCEDURE DeleteCourse @ID INT
  AS
	BEGIN
	   DELETE FROM Course WHERE ID = @ID 
	END
	go

--3)
CREATE PROCEDURE InsertCourse  @Crs_Name nvarchar(50) , @Crs_Duration int  
AS
	BEGIN
			insert into Course 
			values ( @Crs_Name , @Crs_Duration)
	END 
	go

--4)
CREATE PROCEDURE SelectCourse @id int
AS
  BEGIN
	SELECT * FROM Course WHERE ID = @id

  END
  go















------------------------------------------------------------------------------------------------
--Question table Procedures
--1)
CREATE PROCEDURE UpdateQuestion  @ID INT  , @body varchar(200) 
  AS
    BEGIN
     UPDATE Question 
     SET Body = @body
     WHERE ID = @ID
    END
	go

--2)
CREATE PROCEDURE DeleteQuestion @ID INT
  AS
	BEGIN
	   DELETE FROM Question WHERE ID = @ID 
	END
	go

--3)

CREATE PROCEDURE InsertQuestion   @type varchar(20), @body varchar(200), @modelanswer nchar(1) , @grade int  , @course int 
AS
	BEGIN
			insert into Question 
			values ( @type , @body  , @modelanswer  , @grade  , @course)
END
go

--4)

CREATE PROCEDURE SelectQuestion @id int
AS
  BEGIN
	SELECT * FROM Question WHERE ID = @id

  END
  go













----------------------------------------------------------

--Topic  table Procedures

--1)
CREATE PROCEDURE UpdateTopic  @ID INT  , @Name  nvarchar(20) 
  AS
    BEGIN
     UPDATE Topic 
     SET Name = @Name
     WHERE ID = @ID
    END
	go

--2)
CREATE PROCEDURE DeleteTopic @ID INT
  AS
	BEGIN
	   DELETE FROM Topic WHERE ID = @ID 
	END
	go

--3)

CREATE PROCEDURE InsertTopic   @name nvarchar(20) , @course int  
AS
	BEGIN
			insert into Topic 
			values (   @name , @course)
END
go

--4)

create PROCEDURE SelectTopic  @id int
AS
  BEGIN
	SELECT * FROM Topic WHERE ID = @id

 END
 go
---------------------------------------------------------
--StudentCourse  table Procedures
--1)
create PROCEDURE UpdateSudentCourse  @Student INT , @Course int , @Grade  int
  AS
    BEGIN
     UPDATE StudentCourses 
     SET Grade = @Grade
     WHERE Student = @Student and Course = @Course
    END
	go

--2)
CREATE PROCEDURE DeleteStudentCourses  @Student INT , @course int
  AS
	BEGIN
	   DELETE FROM StudentCourses WHERE Student = @Student and Course = @course
	END
	go

--3)

CREATE PROCEDURE InsertStudentCourses  @Student int  , @Course int , @Grade int
AS
	BEGIN
			insert into StudentCourses 
			values (   @Student , @Course , @Grade)
END
go

--4)

create PROCEDURE SelectStudentCourses  @Student int , @Course int 
AS
  BEGIN
	SELECT * FROM StudentCourses WHERE Student = @Student and  Course = @Course

  END
  go












----Some inserts
insert into Department values 
	('SD', 'System Development', 'Smart Village'),
	('Java', 'Java Technologies', 'Smart Village')

insert into Course values
	('C#', 12),
	('SQL', 7)

insert into Student values
	('Kerollos', 'Talaat', 'Giza', 1),
	('Muhammad', 'Osama', 'October', 1),
	('Amgad', 'Rady', 'October', 2),
	('John', 'Emad', 'Cairo', 2),
	('Ahmed', 'Adel', 'Giza', 1)
go



----------------------------------------------------
--Department Table Procedures
--1)

create procedure SelectDepartment(@id int)
as
begin

select Name,Description,Location
from Department
where ID=@id

end
go

--2)

create procedure InsertDepartment(@name nvarchar(50),@description nvarchar(100),@location nvarchar(50))
as
begin

insert into Department values(@name,@description,@location)

end
go
