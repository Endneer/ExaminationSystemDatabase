--done: Question, Course, Student, Topic, StudentCourse, Department, StudentAnswers, Exam, ExamQuestions, Instructor, InstructorCourses

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
	Course int not null references Course(ID) on delete cascade,
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
	Body nvarchar(max),
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
  if not exists ( select ID from Course where ID= @ID)
  print 'error'	
  else
   BEGIN
     UPDATE Course 
     SET Name =@CurseName
     WHERE ID = @ID
    END
	go
--2)
CREATE PROCEDURE DeleteCourse @ID INT
  AS
   if not exists ( select ID from Course where ID= @ID)
  print 'error'	
  ELSE 
	BEGIN
	   DELETE FROM Course WHERE ID = @ID 
	END
	GO

	
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
if not exists ( select ID from Course where ID= @id)
  print 'error'	
  ELSE

  BEGIN
	SELECT * FROM Course WHERE ID = @id

  END
  go



  











------------------------------------------------------------------------------------------------
--Question table Procedures
--1)
CREATE PROCEDURE UpdateQuestion  @ID INT  , @body varchar(200) 
  AS
  if not exists ( select ID from Question where ID= @ID)
  print 'error'	
  ELSE 
    BEGIN
     UPDATE Question 
     SET Body = @body
     WHERE ID = @ID
    END
	go

--2)
CREATE PROCEDURE DeleteQuestion @ID INT
  AS
   if not exists ( select ID from Question where ID= @ID)
  print 'error'	
  ELSE
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
 if not exists ( select ID from Question where ID= @id)
  print 'error'	
  ELSE
  BEGIN
	SELECT * FROM Question WHERE ID = @id

  END
  go













----------------------------------------------------------

--Topic  table Procedures

--1)
CREATE PROCEDURE UpdateTopic  @ID INT  , @Name  nvarchar(20) 
  AS
   if not exists ( select ID from Topic where ID= @id)
  print 'error'	
  ELSE
    BEGIN

     UPDATE Topic 
     SET Name = @Name
     WHERE ID = @ID
    END
	go

--2)
CREATE PROCEDURE DeleteTopic @ID INT
  AS
   if not exists ( select ID from Topic where ID= @ID)
  print 'error'	
  ELSE
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

CREATE PROCEDURE SelectTopic  @id int
AS
 if not exists ( select ID from Topic where ID= @id)
  print 'error'	
  ELSE
  BEGIN
	SELECT * FROM Topic WHERE ID = @id

 END
 go
---------------------------------------------------------
--StudentCourse  table Procedures
--1)
CREATE PROCEDURE UpdateSudentCourse  @Student INT , @Course int , @Grade  int
  AS
  if not exists ( select Grade from StudentCourses WHERE Student = @Student and Course = @Course)
  print 'error'	
  ELSE
    BEGIN
     UPDATE StudentCourses 
     SET Grade = @Grade
     WHERE Student = @Student and Course = @Course
    END
	go

--2)
CREATE PROCEDURE DeleteStudentCourses  @Student INT , @course int
  AS
  if not exists ( select Grade from StudentCourses WHERE Student = @Student and Course = @Course)
  print 'error'	
  ELSE
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

CREATE PROCEDURE SelectStudentCourses  @Student int , @Course int 
AS
if not exists ( select Grade from StudentCourses WHERE Student = @Student and Course = @Course)
  print 'error'	
  ELSE
  BEGIN
	SELECT * FROM StudentCourses WHERE Student = @Student and  Course = @Course

  END
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

--3)

create procedure UpdateDepartment (@id int ,@name nvarchar(50),@description nvarchar(100),@location nvarchar(50))
as
begin
if not exists(select * from Department where ID=@id)
print 'can not update'
else
update Department set Description=@description,Location=@location,Name=@name
where ID=@id
end
go

--4)

create procedure DeleteDepartment (@department int)
as
begin
if exists(select * from student where Department=@department)  or  exists(select * from Instructor where Department=@department)
print 'can not delete'
else 
delete from Department where ID=@department
end

go

-------------------------------------
--StudentAnswer Procedure
--1)

create procedure SelectStudentAnswer (@student int , @question int , @exam int)
as
begin
select Answer from StudentAnswers where Student=@student and Question=@question and Exam=@exam
end
go


--2)
create procedure InsertStudentAnswer (@student int , @question int , @exam int,@answer nchar(1))
as begin

if exists(select * from Student where ID=@student) and 
exists (select * from Question where ID=@question) and
exists (select * from Exam where ID=@exam)
insert into StudentAnswers values(@student,@exam,@question,@answer)
else 
print 'can not insert'

end
go

--3)
create procedure UpdateStudentAnswer (@student int , @question int , @exam int,@answer nchar(1))
as
begin

update StudentAnswers set Answer=@answer where Student=@student and Question=@question and Answer=@answer

end
go

--4)
create procedure DeleteStudentAnswer (@student int , @question int , @exam int)
as
begin
delete from StudentAnswers where Student=@student and Question=@question and Exam=@exam
end
go
-----------













--------------
----Exam

create procedure SelectExam @ID int
as 
select * from Exam where ID = @ID
go

create procedure DeleteExam @ID int
as
delete from exam where ID = @ID
go

create procedure UpdateExam @ID int 
as select 'Can''t update Exam'
go

create procedure InsertExam
as
insert into Exam default values
go
---------------



















------------
----ExamQuestions
create procedure SelectExamQuestion @ExamID int
as
select * from ExamQuestions where Exam = @ExamID
go

create procedure UpdateExamQuestion @ExamID int, @QuestionID int
as
update ExamQuestions set Question = @QuestionID where Exam = @ExamID
go

create procedure DeleteExamQuestion @ExamID int, @QuestionID int
as
delete from ExamQuestions where Exam = @ExamID and Question = @QuestionID
go

create procedure InsertExamQuestion @ExamID int, @QuestionID int
as
insert into ExamQuestions values (@ExamID, @QuestionID)
go














---------------------------------------------------------------------------
--Instructor TABLE

GO
CREATE PROC InsertInstructor (@insnam nvarchar(50), @deg int, @sal money, @dept int)
AS
	INSERT INTO Instructor( Name, Degree, Salary, Department ) 
	VALUES (@insnam, @deg, @sal, @dept)
	

GO
CREATE PROC SelectInstructor
AS
	SELECT *
	FROM Instructor



GO
CREATE PROC DeleteInstructor (@insid int)
AS
	IF @insid in (select ID from Instructor)
	begin
		DELETE FROM Instructor
		WHERE ID = @insid
	end


GO
CREATE PROC UpdateInstructor (@insid int, @colNam varchar(20), @val varchar(20))
AS
	IF @insid in (select ID from Instructor)
	begin
		
			if @colNam = 'Name'
				 update  Instructor set Name = @val where ID = @insid
			else if @colNam = 'Degree'
				 update  Instructor set Degree = @val where ID = @insid
			else if @colNam = 'salary'
				 update  Instructor set Salary = CONVERT(money, @val) where ID = @insid
				
		End
	



















---------------------------------------------------------------------------
--InstructorCourses TABLE

GO
CREATE PROC InsertInstructorCourses (@insid int, @crs int)
AS
	IF (@insid in (select ID from Instructor)) and (@crs in (select ID from Course))
	begin
		INSERT INTO InstructorCourses
		VALUES (@insid, @crs)
	end
	
	

GO
CREATE PROC SelectInstructorCourses
AS
	SELECT *
	FROM InstructorCourses


GO
CREATE PROC DeleteInstructorCourses (@insid int, @crs int)
AS
	DELETE FROM InstructorCourses
	WHERE Instructor = @insid and Course = @crs


GO
CREATE PROC UpdateInstructorCourses (@insid int, @colNam varchar(20), @val varchar(20))
AS
	IF @insid in (select Instructor from InstructorCourses) and (@val in (select ID from Course))
	begin
		EXECUTE ('Update InstructorCourses Set ' + @colNam + ' = ' + @val + ' Where ID = ' + @insid)
	end

	go












----Some inserts

insert into Department values 
	('SD', 'System Development', 'Smart Village'),
	('Java', 'Java Technologies', 'Smart Village'),
	('EL', 'E-Learning', 'Mansoura'),
('MM', 'Multimedia', 'Alex'),
('Unix', 'Unix', 'Alex'),
('NC', 'Network', 'Cairo'),
('EB' ,'E-Business', 'Alex')

insert into Course values
	('C#', 12),
	('SQL', 7),
('HTML', 20),
('C Progamming', 60),
('OOP', 80),
('Unix', 50),
('Web Service', 20),
('Java', 60),
('Oracle', 50),
('ASP.Net', 60),
('Win_XP', 20),
('Photoshop', 30)

insert into Instructor values
('Ahmed', 'Master', NULL, 1),
('Hany', 'Master', NULL, 1),
('Reham', 'Master', NULL, 1),
('Yasmin', 'PHD', NULL, 1),
('Amany', 'PHD', NULL, 1),
('Eman', 'Master', NULL, 1),
('Saly', 'NULL', NULL, 1),
('Amr', 'NULL', NULL, 3),
('Hussien', 'NULL', NULL, 5),
('Khalid', 'NULL', NULL, 3),
('Salah', 'NULL', NULL, 7),
('Adel', 'NULL', NULL, 7),
('Fakry', 'NULL', NULL, 2),
('Amena', 'NULL', NULL, 2),
('Ghada', NULL, NULL ,4)


insert into InstructorCourses values
(1, 1),
(1, 2),
(1, 3),
(2, 4),
(2, 5),
(3, 1),
(3, 6),
(3, 7),
(4, 2),
(4, 3),
(5, 8),
(5, 9),
(6, 5),
(6, 6),
(6, 9),
(6, 10),
(6, 11),
(7, 8),
(7, 9),
(8, 1),
(9, 2),
(10, 3),
(11, 8),
(11, 9),
(12, 10),
(12, 11),
(13, 3),
(13, 4)


insert into Topic values
('Events',1),
('Delegate',1),
('Lamda Expression',1),
('Procedure',2)

insert into Student values
	('Kerollos', 'Talaat', 'Giza', 1),
	('Muhammad', 'Osama', 'October', 1),
	('Amgad', 'Rady', 'October', 2),
	('John', 'Emad', 'Cairo', 2),
	('Ahmed', 'Adel', 'Giza', 1),
	('Ahmed', 'Hassan', 'Cairo', 1),
('Amr', 'Magdy', 'Cairo', 1),
('Mona', 'Saleh', 'Cairo', 1),
('Ahmed', 'Mohamed', 'Alex', 1),
('Khalid', 'Moahmed', 'Alex', 1),
('Heba', 'Farouk', 'Mansoura', 2),
('Ali', 'Hussien', 'Cairo', 2),
('Mohamed', 'Fars', 'Alex', 2),
('Saly', 'Ahmed', 'Mansoura', 3),
('Fady', 'Ali', 'Alex', 3),
('Marwa', 'Ahmed', 'Cairo', 3),
('Noha', 'Omar', 'Cairo', 4)




insert into StudentCourses values
(1, 1, 100),
(2, 1, 90),
(3, 1, 80),
(4, 1, 70),
(5, 1, 100),
(6, 1, 90),
(1, 2, 90),
(2, 2, 90),
(3, 2, 80),
(4, 2, 80),
(5, 2, 80),
(7, 2, 60),
(8, 2, 60),
(9, 2, 60),
(5, 3, 70),
(6, 3, 70),
(7, 3, 70),
(10, 3, 100),
(1, 4, 100),
(2, 4, 100),
(3, 4, 100),
(4, 4, 90),
(5, 4, 90),
(6, 5, 80),
(7, 6, 80),
(8, 7, 70),
(1, 8, 70),
(9, 8, 90),
(10, 8, 90),
(2, 9, 80),
(3, 9, 70),
(4, 9, 70),
(5, 9, 60),
(1, 10, 90),
(2, 10, 60),
(3, 10, 60)


insert into Question values
	('MCQ', 'Which of the following statements is correct about the C#.NET code snippet given below?

int a = 10; 
int b = 20; 
int c = 30;
enum color: byte
{
    red = a, 
    green = b,
    blue = c 
}
A.	Variables cannot be assigned to enum elements.
B.	Variables can be assigned to any one of the enum elements.
C.	Variables can be assigned only to the first enum element.
D.	Values assigned to enum elements must always be successive values.
E.	Values assigned to enum elements must always begin with 0.', 'A', 2, 1),
	('TrueOrFalse', 'A function can return more than one value.', 'F', 1, 1),
	('TrueOrFalse', 'In C#, a function needs to be defined using the static keyword, so that it can be called from the Main function.', 'T', 1, 1)

go


